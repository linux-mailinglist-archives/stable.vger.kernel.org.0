Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4965C14258E
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 09:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgATI1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 03:27:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60787 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgATI10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 03:27:26 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1itSOu-0002sC-Ow; Mon, 20 Jan 2020 09:27:12 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 3AAB11C1A3D;
        Mon, 20 Jan 2020 09:27:12 +0100 (CET)
Date:   Mon, 20 Jan 2020 08:27:12 -0000
From:   "tip-bot2 for Andres Freund" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf c2c: Fix return type for histogram sorting
 comparision functions
Cc:     Andres Freund <andres@anarazel.de>,
        Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v3.16+@tip-bot2.tec.linutronix.de,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200109043030.233746-1-andres@anarazel.de>
References: <20200109043030.233746-1-andres@anarazel.de>
MIME-Version: 1.0
Message-ID: <157950883206.396.14634708982531515260.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     c1c8013ec34d7163431d18367808ea40b2e305f8
Gitweb:        https://git.kernel.org/tip/c1c8013ec34d7163431d18367808ea40b2e305f8
Author:        Andres Freund <andres@anarazel.de>
AuthorDate:    Wed, 08 Jan 2020 20:30:30 -08:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Tue, 14 Jan 2020 13:29:21 -03:00

perf c2c: Fix return type for histogram sorting comparision functions

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
index 3463512..246ac0b 100644
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
