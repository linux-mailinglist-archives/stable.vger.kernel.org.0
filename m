Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70A624B6CF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHTKlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbgHTKQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A0B20658;
        Thu, 20 Aug 2020 10:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918600;
        bh=8oiJfUWAGWX/bCFj33VEYHm5fd1QvU3Tdt/J/MpTiwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhoQnWQ7rrLH67iqRiQVkDai2a776W7m/kUnSt+ILINQYpEmAuOzvL7LJ7Ds47WOX
         lwlYLPU/cMGg2r9hpVRAWf/EGGzEZ92ZvPf/o6j4Tr2wg/kzOhkYRcBI9Lt5jQMFRy
         EEfjTIoolN9xXhB1yKuUY6DQlJSELTLrIhHq8zYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, kernel@axis.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 218/228] perf bench mem: Always memset source before memcpy
Date:   Thu, 20 Aug 2020 11:23:13 +0200
Message-Id: <20200820091618.406713948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 1beaef29c34154ccdcb3f1ae557f6883eda18840 ]

For memcpy, the source pages are memset to zero only when --cycles is
used.  This leads to wildly different results with or without --cycles,
since all sources pages are likely to be mapped to the same zero page
without explicit writes.

Before this fix:

$ export cmd="./perf stat -e LLC-loads -- ./perf bench \
  mem memcpy -s 1024MB -l 100 -f default"
$ $cmd

         2,935,826      LLC-loads
       3.821677452 seconds time elapsed

$ $cmd --cycles

       217,533,436      LLC-loads
       8.616725985 seconds time elapsed

After this fix:

$ $cmd

       214,459,686      LLC-loads
       8.674301124 seconds time elapsed

$ $cmd --cycles

       214,758,651      LLC-loads
       8.644480006 seconds time elapsed

Fixes: 47b5757bac03c338 ("perf bench mem: Move boilerplate memory allocation to the infrastructure")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: kernel@axis.com
Link: http://lore.kernel.org/lkml/20200810133404.30829-1-vincent.whitchurch@axis.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/mem-functions.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 0251dd348124a..4864fc67d01b5 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -222,12 +222,8 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 	return 0;
 }
 
-static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, void *dst)
+static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 {
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
-	memcpy_t fn = r->fn.memcpy;
-	int i;
-
 	/* Make sure to always prefault zero pages even if MMAP_THRESH is crossed: */
 	memset(src, 0, size);
 
@@ -236,6 +232,15 @@ static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, vo
 	 * to not measure page fault overhead:
 	 */
 	fn(dst, src, size);
+}
+
+static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, void *dst)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	memcpy_t fn = r->fn.memcpy;
+	int i;
+
+	memcpy_prefault(fn, size, src, dst);
 
 	cycle_start = get_cycles();
 	for (i = 0; i < nr_loops; ++i)
@@ -251,11 +256,7 @@ static double do_memcpy_gettimeofday(const struct function *r, size_t size, void
 	memcpy_t fn = r->fn.memcpy;
 	int i;
 
-	/*
-	 * We prefault the freshly allocated memory range here,
-	 * to not measure page fault overhead:
-	 */
-	fn(dst, src, size);
+	memcpy_prefault(fn, size, src, dst);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
 	for (i = 0; i < nr_loops; ++i)
-- 
2.25.1



