Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F094187F38
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCQK7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgCQK7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9422420658;
        Tue, 17 Mar 2020 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442775;
        bh=PM8pvE6OwB8LDMCq4KfLYQAvcmFk6uCBwLt+Y0/b59A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CCiXbg0BzB9iJG5/slSaTB7yquxdMErytO0BNCkmSgYM4q9MMOU5HYkWTE0DnSCp
         XZtPm9gNdtl55KlE93AcBbzEjiIuMH0jJ8m3HsXyB8rb9FXyxJrspczAq6RDDS5v7Z
         Odaeh92IiyaFe99Bjxcy/7huFko64zGknQZ6K+es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 78/89] perf bench futex-wake: Restore thread count default to online CPU count
Date:   Tue, 17 Mar 2020 11:55:27 +0100
Message-Id: <20200317103309.069345868@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

commit f649bd9dd5d5004543bbc3c50b829577b49f5d75 upstream.

Since commit 3b2323c2c1c4 ("perf bench futex: Use cpumaps") the default
number of threads the benchmark uses got changed from number of online
CPUs to zero:

  $ perf bench futex wake
  # Running 'futex/wake' benchmark:
  Run summary [PID 15930]: blocking on 0 threads (at [private] futex 0x558b8ee4bfac), waking up 1 at a time.
  [Run 1]: Wokeup 0 of 0 threads in 0.0000 ms
  [...]
  [Run 10]: Wokeup 0 of 0 threads in 0.0000 ms
  Wokeup 0 of 0 threads in 0.0004 ms (+-40.82%)

Restore the old behavior by grabbing the number of online CPUs via
cpu->nr:

  $ perf bench futex wake
  # Running 'futex/wake' benchmark:
  Run summary [PID 18356]: blocking on 8 threads (at [private] futex 0xb3e62c), waking up 1 at a time.
  [Run 1]: Wokeup 8 of 8 threads in 0.0260 ms
  [...]
  [Run 10]: Wokeup 8 of 8 threads in 0.0270 ms
  Wokeup 8 of 8 threads in 0.0419 ms (+-24.35%)

Fixes: 3b2323c2c1c4 ("perf bench futex: Use cpumaps")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lore.kernel.org/lkml/20200305083714.9381-3-tommi.t.rantala@nokia.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/bench/futex-wake.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -42,7 +42,7 @@ static bool done = false, silent = false
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
-static unsigned int ncpus, threads_starting, nthreads = 0;
+static unsigned int threads_starting, nthreads = 0;
 static int futex_flag = 0;
 
 static const struct option options[] = {
@@ -140,7 +140,7 @@ int bench_futex_wake(int argc, const cha
 	sigaction(SIGINT, &act, NULL);
 
 	if (!nthreads)
-		nthreads = ncpus;
+		nthreads = cpu->nr;
 
 	worker = calloc(nthreads, sizeof(*worker));
 	if (!worker)


