import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Home Page with Theme Switcher
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Switcher"),
        actions: [
          BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, themeData) {
              return CupertinoSwitch(
                value: themeData == ThemeData.dark(),
                onChanged: (bool val) {
                  BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
                },
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text("Theme changing app")),
    );
  }
}

// Bloccccc
class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light()) {
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await isDark();
      if (hasDarkTheme) {
        emit(ThemeData.dark());
      } else {
        emit(ThemeData.light());
      }
    });

    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == ThemeData.dark();
      emit(isDark ? ThemeData.light() : ThemeData.dark());
      setTheme(isDark);
    });
  }

  // shared preferences  ikkadha use
  Future<bool> isDark() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("is_dark") ?? false;
  }

  // Set the theme in shared preferences
  Future<void> setTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_dark", !isDark);
  }
}

// ThemeEvent  use
@immutable
abstract class ThemeEvent {}

class InitialThemeSetEvent extends ThemeEvent {}

class ThemeSwitchEvent extends ThemeEvent {}
