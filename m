Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098ED45C324
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352364AbhKXNfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351817AbhKXNdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AC461B21;
        Wed, 24 Nov 2021 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758431;
        bh=pyfvXeey07e81ohSpF5WnV3MRD0hzYq67MxsUEfP1Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=we5QUcqakOgJCBSOTwIL1rdvYHbkdKVDzd6nLsx55dcytV4ba3J8YztHw1rUxcKSU
         w3cOJduKAEfSNrAg+rt3kc/TSv3kqsEWb12WIeiGtQrQ4uCHPv7OPmxks60CN+fJaH
         Q5s3WIyNuE5ivxspY/j3sBOYEeQfR6VpftwOwKMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/154] perf bench futex: Fix memory leak of perf_cpu_map__new()
Date:   Wed, 24 Nov 2021 12:57:42 +0100
Message-Id: <20211124115704.448125985@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sohaib Mohamed <sohaib.amhmd@gmail.com>

[ Upstream commit 88e48238d53682281c9de2a0b65d24d3b64542a0 ]

ASan reports memory leaks while running:

  $ sudo ./perf bench futex all

The leaks are caused by perf_cpu_map__new not being freed.
This patch adds the missing perf_cpu_map__put since it calls
cpu_map_delete implicitly.

Fixes: 9c3516d1b850ea93 ("libperf: Add perf_cpu_map__new()/perf_cpu_map__read() functions")
Signed-off-by: Sohaib Mohamed <sohaib.amhmd@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: André Almeida <andrealmeid@collabora.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sohaib Mohamed <sohaib.amhmd@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lore.kernel.org/lkml/20211112201134.77892-1-sohaib.amhmd@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/futex-lock-pi.c       | 1 +
 tools/perf/bench/futex-requeue.c       | 1 +
 tools/perf/bench/futex-wake-parallel.c | 1 +
 tools/perf/bench/futex-wake.c          | 1 +
 4 files changed, 4 insertions(+)

diff --git a/tools/perf/bench/futex-lock-pi.c b/tools/perf/bench/futex-lock-pi.c
index bb25d8beb3b85..159bc89e6a79a 100644
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -226,6 +226,7 @@ int bench_futex_lock_pi(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_lock_pi_usage, options);
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 7a15c2e610228..105b36cdc42d3 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -216,6 +216,7 @@ int bench_futex_requeue(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_requeue_usage, options);
diff --git a/tools/perf/bench/futex-wake-parallel.c b/tools/perf/bench/futex-wake-parallel.c
index cd2b81a845acb..a129c94eb3fe1 100644
--- a/tools/perf/bench/futex-wake-parallel.c
+++ b/tools/perf/bench/futex-wake-parallel.c
@@ -320,6 +320,7 @@ int bench_futex_wake_parallel(int argc, const char **argv)
 	print_summary();
 
 	free(blocked_worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
 #endif /* HAVE_PTHREAD_BARRIER */
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index 2dfcef3e371e4..507ff533612c6 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -210,5 +210,6 @@ int bench_futex_wake(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
-- 
2.33.0



