Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE02150C3F
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgBCQeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbgBCQea (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:30 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E92A2082E;
        Mon,  3 Feb 2020 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747670;
        bh=nU36sniQgPFfGCvo9LY0os9+T+abyU6kUH4GzuHQaT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1H33yeBFh+gA9NjVz7RfEH58Ctcdjfxe6+kpg7YBR6VMX4JUKGQ1n8ta1sJm29sYX
         1FrFqpag8pXeSkFfUV6IWQvk8qeLitde180YGQNGV02wJ1KOmrEM8uvG9U/Ytei/+2
         Fc4BcxnbgjqIpdPcR8TZENd+a6aCso7kbdNdV2n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 09/90] perf c2c: Fix return type for histogram sorting comparision functions
Date:   Mon,  3 Feb 2020 16:19:12 +0000
Message-Id: <20200203161918.812118193@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

commit c1c8013ec34d7163431d18367808ea40b2e305f8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-c2c.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __
 {
 	struct c2c_hist_entry *c2c_left;
 	struct c2c_hist_entry *c2c_right;
-	unsigned int tot_hitm_left;
-	unsigned int tot_hitm_right;
+	uint64_t tot_hitm_left;
+	uint64_t tot_hitm_right;
 
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
@@ -629,7 +629,8 @@ __f ## _cmp(struct perf_hpp_fmt *fmt __m
 									\
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);	\
 	c2c_right = container_of(right, struct c2c_hist_entry, he);	\
-	return c2c_left->stats.__f - c2c_right->stats.__f;		\
+	return (uint64_t) c2c_left->stats.__f -				\
+	       (uint64_t) c2c_right->stats.__f;				\
 }
 
 #define STAT_FN(__f)		\
@@ -682,7 +683,8 @@ ld_llcmiss_cmp(struct perf_hpp_fmt *fmt
 	c2c_left  = container_of(left, struct c2c_hist_entry, he);
 	c2c_right = container_of(right, struct c2c_hist_entry, he);
 
-	return llc_miss(&c2c_left->stats) - llc_miss(&c2c_right->stats);
+	return (uint64_t) llc_miss(&c2c_left->stats) -
+	       (uint64_t) llc_miss(&c2c_right->stats);
 }
 
 static uint64_t total_records(struct c2c_stats *stats)


