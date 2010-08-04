#!perl

use strict;
use warnings;

# Create a user agent object
use LWP::UserAgent;
use Test::More tests => 4;

my $host = "test.163.org";
my $uri = "http://127.0.0.1:8080/index2.html";

my $ua = LWP::UserAgent->new;
$ua->agent("Wget/1.11.4");

my $h = HTTP::Headers->new(
	Accept          => '*/*',
	Connection      => 'Keep-Alive',
	Host            => $host);

# Create a request
my $req = HTTP::Request->new("GET", $uri, $h);

# Pass request to the user agent and get a response back
my $res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success) {
    isnt($res->header("Content-Encoding"), "deflate", "The Content-Encoding should return NULL");
    like($res->header("X-Cache"), qr/MISS.*/, "X-Cache: MISS at first time");
    $res->decoded_content( raise_error => 1 );
}
else {
    print $res->status_line, "\n";
}

$ua = LWP::UserAgent->new;
$ua->agent("Wget/1.11.4");

$h = HTTP::Headers->new(
	Accept          => '*/*',
	Connection      => 'Keep-Alive',
	Host            => $host);

# Create a request
$req = HTTP::Request->new("GET", $uri, $h);

# Pass request to the user agent and get a response back
$res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success) {
    isnt($res->header("Content-Encoding"), "deflate", "The Content-Encoding should return NULL");
    like($res->header("X-Cache"), qr/HIT.*/, "X-Cache: HIT at second time");
    $res->decoded_content( raise_error => 1 );
}
else {
    print $res->status_line, "\n";
}

