Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC645C21A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348700AbhKXNZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348624AbhKXNWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:22:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6177661288;
        Wed, 24 Nov 2021 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758054;
        bh=6KHWeQcoARM4R9/c5+12qMBsR1e5cPI96Ro90QMzT5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVq8LpC7OCg6pHZs0AMeeE5p/R43pHjk8x9En1ve+AOP/KCvDBtYCDHRAIkrxmwOw
         Riay6McCr5fylrt7d2osZlnvbESie9TpSmlJvIz0ExA3lnwY1ygwlvPx1EnBqZLv2o
         OaSAYMhcRzaLUNE9n+7+7OXjDnI9D+cssC+jjknU=
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
Subject: [PATCH 5.4 045/100] perf bench futex: Fix memory leak of perf_cpu_map__new()
Date:   Wed, 24 Nov 2021 12:58:01 +0100
Message-Id: <20211124115656.337659448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
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
index 30d97121dc4fb..c54013806ba4a 100644
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -224,6 +224,7 @@ int bench_futex_lock_pi(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_lock_pi_usage, options);
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index a00a6891447ab..11b7dbd374864 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -215,6 +215,7 @@ int bench_futex_requeue(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_requeue_usage, options);
diff --git a/tools/perf/bench/futex-wake-parallel.c b/tools/perf/bench/futex-wake-parallel.c
index a053cf2b70397..c3033d0905db1 100644
--- a/tools/perf/bench/futex-wake-parallel.c
+++ b/tools/perf/bench/futex-wake-parallel.c
@@ -319,6 +319,7 @@ int bench_futex_wake_parallel(int argc, const char **argv)
 	print_summary();
 
 	free(blocked_worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
 #endif /* HAVE_PTHREAD_BARRIER */
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index 58906e9499bb0..ad44a78392dc4 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -209,5 +209,6 @@ int bench_futex_wake(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
-- 
2.33.0



