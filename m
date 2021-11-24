Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3E45C4C9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350101AbhKXNvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243638AbhKXNto (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD37F61A78;
        Wed, 24 Nov 2021 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759005;
        bh=bL5oRu47bEegD6Ik5oTg1A6IbzHYsq+TmQ6Pv7/ZrNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn0rJCa537hvkHel0qP89lvbee1/7zALU9e/L5ppQcIX+kBDDIL4UdyeMYsCWYFTq
         2wCWxNxftCIpMuQshrIFsFC6w50VFJj9zLY4LvLIfKNC+Xmoi6M85iODBVXwOU+xn0
         HdsyjrSJbot54KRUCNr1oiAa9+UQlEp+nssz6O6I=
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
Subject: [PATCH 5.15 102/279] perf bench futex: Fix memory leak of perf_cpu_map__new()
Date:   Wed, 24 Nov 2021 12:56:29 +0100
Message-Id: <20211124115722.301404836@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
index 5d1fe9c35807a..137890f78e17a 100644
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -233,6 +233,7 @@ int bench_futex_lock_pi(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_lock_pi_usage, options);
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 97fe31fd3a236..f7a5ffebb9408 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -294,6 +294,7 @@ int bench_futex_requeue(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 err:
 	usage_with_options(bench_futex_requeue_usage, options);
diff --git a/tools/perf/bench/futex-wake-parallel.c b/tools/perf/bench/futex-wake-parallel.c
index e970e6b9ad535..0983f40b4b408 100644
--- a/tools/perf/bench/futex-wake-parallel.c
+++ b/tools/perf/bench/futex-wake-parallel.c
@@ -329,6 +329,7 @@ int bench_futex_wake_parallel(int argc, const char **argv)
 	print_summary();
 
 	free(blocked_worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
 #endif /* HAVE_PTHREAD_BARRIER */
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index 77f058a477903..2226a475e782b 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -222,5 +222,6 @@ int bench_futex_wake(int argc, const char **argv)
 	print_summary();
 
 	free(worker);
+	perf_cpu_map__put(cpu);
 	return ret;
 }
-- 
2.33.0



