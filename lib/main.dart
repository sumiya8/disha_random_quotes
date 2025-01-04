import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(RandomQuoteApp());

class RandomQuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Quote Generator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String quote = "Press the button to get a quote!";
  String author = "";
  bool isLoading = false;

  // Fetch random quote from the API
  Future<void> fetchQuote() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://api.quotable.io/random"); // Verified API link
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          quote = data['content'];
          author = data['author'];
        });
      } else {
        showErrorSnackBar("Failed to fetch quote. Please try again!");
      }
    } catch (e) {
      showErrorSnackBar("An error occurred. Please check your connection!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Show error messages using a SnackBar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Quote Generator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Text(
              author.isNotEmpty ? "- $author" : "",
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : fetchQuote,
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text("Get Random Quote"),
            ),
          ],
        ),
      ),
    );
  }
}
