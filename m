Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B936613DC59
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 14:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgAPNtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 08:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgAPNtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 08:49:02 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E042176D;
        Thu, 16 Jan 2020 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579182542;
        bh=4eDnCeywUXMSgK8wvLJsYC/uQhHp4VylsmBVXwZoQf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTDjUicL4UijwvdmqNiKtpbXr4w4+lPhez6O77TQeezieIT5C4GPrOOMpOAn+vwGe
         Ziv0CiTWIwldTl3wTfWWl7AILWXbR61tOHPciTVzlHgOX85c2iC5za8bqvDxxbDKv2
         eLmLW4KJHViSZDzT1AUmvd1IAbwv8t5ctRHXbEdg=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/12] perf c2c: Fix return type for histogram sorting comparision functions
Date:   Thu, 16 Jan 2020 10:48:13 -0300
Message-Id: <20200116134814.8811-12-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200116134814.8811-1-acme@kernel.org>
References: <20200116134814.8811-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

Commit 722ddfde366f ("perf tools: Fix time sorting") changed - correctly
so - hist_entry__sort to return int64. Unfortunately several of the
builtin-c2c.c comparison routines only happened to work due the cast
caused by the wrong return type.

This causes meaningless ordering of both the cacheline list, and the
cacheline details page. E.g a simple:

  perf c2c record -a sleep 3
  perf c2c report

will result in cacheline table like
  =================================================
             Shared Data Cache Line Table
  =================================================
  #
  #        ------- Cacheline ----------    Total     Tot  - LLC Load Hitm -  - Store Reference -  - Load Dram -     LLC  Total  - Core Load Hit -  - LLC Load Hit -
  # Index         Address  Node  PA cnt  records    Hitm  Total  Lcl    Rmt  Total  L1Hit  L1Miss     Lcl   Rmt  Ld Miss  Loads    FB    L1   L2     Llc      Rmt
  # .....  ..............  ....  ......  .......  ......  .....  .....  ...  ....   .....  ......  ......  ....  ......   .....  .....  ..... ...  ....     .......

        0  0x7f0d27ffba00   N/A       0       52   0.12%     13      6    7    12      12       0       0     7      14      40      4     16    0    0           0
        1  0x7f0d27ff61c0   N/A       0     6353  14.04%   1475    801  674   779     779       0       0   718    1392    5574   1299   1967    0  115           0
        2  0x7f0d26d3ec80   N/A       0       71   0.15%     16      4   12    13      13       0       0    12      24      58      1     20    0    9           0
        3  0x7f0d26d3ec00   N/A       0       98   0.22%     23     17    6    19      19       0       0     6      12      79      0     40    0   10           0

i.e. with the list not being ordered by Total Hitm.

Fixes: 722ddfde366f ("perf tools: Fix time sorting")
Signed-off-by: Andres Freund <andres@anarazel.de>
Tested-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # v3.16+
Link: http://lore.kernel.org/lkml/20200109043030.233746-1-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-c2c.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 346351260c0b..246ac0b4d54f 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 {
 	struct c2c_hist_entry *c2c_left;
 	struct c2c_hist_entry *c2c_right;
-	unsigned int tot_hitm_left;
-	unsigned int tot_hitm_right;
+	uint64_t tot_hitm_left;
+	uint64_t tot_hitm_right;
 
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
@@ -629,7 +629,8 @@ __f ## _cmp(struct perf_hpp_fmt *fmt __maybe_unused,			\
 									\
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);	\
 	c2c_right = container_of(right, struct c2c_hist_entry, he);	\
-	return c2c_left->stats.__f - c2c_right->stats.__f;		\
+	return (uint64_t) c2c_left->stats.__f -				\
+	       (uint64_t) c2c_right->stats.__f;				\
 }
 
 #define STAT_FN(__f)		\
@@ -682,7 +683,8 @@ ld_llcmiss_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
 
-	return llc_miss(&c2c_left->stats) - llc_miss(&c2c_right->stats);
+	return (uint64_t) llc_miss(&c2c_left->stats) -
+	       (uint64_t) llc_miss(&c2c_right->stats);
 }
 
 static uint64_t total_records(struct c2c_stats *stats)
-- 
2.21.1

