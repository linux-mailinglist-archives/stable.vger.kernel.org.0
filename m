Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9124B3B7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgHTJvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729809AbgHTJv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E5E2075E;
        Thu, 20 Aug 2020 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917089;
        bh=SyegA3bvJrFg8dpHJ5/ardA2mwqjWJ6lgwFOeVX86zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pb7uG2eEucq9jEXov8gznVvj1/LmeuofH9ebmhu3FEVjLUTM6uU0c9H1rI9cZJXS2
         Wgunr+6WQfp9fNYeSI3mQ7/HQF89oIgz2e9OpQNnjijj8z90DukQ13kY3OMHEnDID7
         c5W2ubnQdetije08KgrkAYS7Z0QN2RKqS08+NTDQ=
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
Subject: [PATCH 5.4 141/152] perf bench mem: Always memset source before memcpy
Date:   Thu, 20 Aug 2020 11:21:48 +0200
Message-Id: <20200820091601.031660279@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
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
index 9235b76501be8..19d45c377ac18 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -223,12 +223,8 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
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
 
@@ -237,6 +233,15 @@ static u64 do_memcpy_cycles(const struct function *r, size_t size, void *src, vo
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
@@ -252,11 +257,7 @@ static double do_memcpy_gettimeofday(const struct function *r, size_t size, void
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



