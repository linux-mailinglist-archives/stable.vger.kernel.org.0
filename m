Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B319D23A5E5
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgHCMam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgHCMak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E9662054F;
        Mon,  3 Aug 2020 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457838;
        bh=iBRlGITrjfv/S2amqM1NyQzfRh/LjyCHcWdVhCP4M0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5PoYMt69VaPAewoqoHaMPA1Flhl7zje2QSOdm9Ek3QLi6XGb4Y4XwcHx2OcRB3zs
         z8xIWy3bIBNKGf3XwNNvHpxr789aPr4THlDu65BX+Fd49gHUr/qTWRSL/SBXa6oMrr
         ICkfSXcrXetvmOVwxIu9uFjUfsYRWGwAJcTPfPPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.4 90/90] perf bench: Share some global variables to fix build with gcc 10
Date:   Mon,  3 Aug 2020 14:19:52 +0200
Message-Id: <20200803121901.932193708@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit e4d9b04b973b2dbce7b42af95ea70d07da1c936d upstream.

Noticed with gcc 10 (fedora rawhide) that those variables were not being
declared as static, so end up with:

  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  make[4]: *** [/git/perf/tools/build/Makefile.build:145: /tmp/build/perf/bench/perf-in.o] Error 1

Prefix those with bench__ and add them to bench/bench.h, so that we can
share those on the tools needing to access those variables from signal
handlers.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200303155811.GD13702@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/bench/bench.h         |    4 ++++
 tools/perf/bench/epoll-ctl.c     |    7 +++----
 tools/perf/bench/epoll-wait.c    |   11 +++++------
 tools/perf/bench/futex-hash.c    |   12 ++++++------
 tools/perf/bench/futex-lock-pi.c |   11 +++++------
 5 files changed, 23 insertions(+), 22 deletions(-)

--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -2,6 +2,10 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <sys/time.h>
+
+extern struct timeval bench__start, bench__end, bench__runtime;
+
 /*
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
--- a/tools/perf/bench/epoll-ctl.c
+++ b/tools/perf/bench/epoll-ctl.c
@@ -35,7 +35,6 @@
 
 static unsigned int nthreads = 0;
 static unsigned int nsecs    = 8;
-struct timeval start, end, runtime;
 static bool done, __verbose, randomize;
 
 /*
@@ -94,8 +93,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void nest_epollfd(void)
@@ -361,7 +360,7 @@ int bench_epoll_ctl(int argc, const char
 
 	threads_starting = nthreads;
 
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 
 	do_threads(worker, cpu);
 
--- a/tools/perf/bench/epoll-wait.c
+++ b/tools/perf/bench/epoll-wait.c
@@ -90,7 +90,6 @@
 
 static unsigned int nthreads = 0;
 static unsigned int nsecs    = 8;
-struct timeval start, end, runtime;
 static bool wdone, done, __verbose, randomize, nonblocking;
 
 /*
@@ -276,8 +275,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void print_summary(void)
@@ -287,7 +286,7 @@ static void print_summary(void)
 
 	printf("\nAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 static int do_threads(struct worker *worker, struct perf_cpu_map *cpu)
@@ -479,7 +478,7 @@ int bench_epoll_wait(int argc, const cha
 
 	threads_starting = nthreads;
 
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 
 	do_threads(worker, cpu);
 
@@ -519,7 +518,7 @@ int bench_epoll_wait(int argc, const cha
 		qsort(worker, nthreads, sizeof(struct worker), cmpworker);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 
 		update_stats(&throughput_stats, t);
 
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -37,7 +37,7 @@ static unsigned int nfutexes = 1024;
 static bool fshared = false, done = false, silent = false;
 static int futex_flag = 0;
 
-struct timeval start, end, runtime;
+struct timeval bench__start, bench__end, bench__runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -103,8 +103,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void print_summary(void)
@@ -114,7 +114,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 int bench_futex_hash(int argc, const char **argv)
@@ -161,7 +161,7 @@ int bench_futex_hash(int argc, const cha
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 	for (i = 0; i < nthreads; i++) {
 		worker[i].tid = i;
 		worker[i].futex = calloc(nfutexes, sizeof(*worker[i].futex));
@@ -204,7 +204,7 @@ int bench_futex_hash(int argc, const cha
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 		update_stats(&throughput_stats, t);
 		if (!silent) {
 			if (nfutexes == 1)
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -37,7 +37,6 @@ static bool silent = false, multi = fals
 static bool done = false, fshared = false;
 static unsigned int nthreads = 0;
 static int futex_flag = 0;
-struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -64,7 +63,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 static void toggle_done(int sig __maybe_unused,
@@ -73,8 +72,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void *workerfn(void *arg)
@@ -185,7 +184,7 @@ int bench_futex_lock_pi(int argc, const
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 
 	create_threads(worker, thread_attr, cpu);
 	pthread_attr_destroy(&thread_attr);
@@ -211,7 +210,7 @@ int bench_futex_lock_pi(int argc, const
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 
 		update_stats(&throughput_stats, t);
 		if (!silent)


