Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43A469D64
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376493AbhLFP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385868AbhLFPZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89EC76132B;
        Mon,  6 Dec 2021 15:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459A5C341C2;
        Mon,  6 Dec 2021 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804145;
        bh=4W5Jz5mXel77U631en9VVjtxRIl28aQMdz5JYY6FSUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK8CBIBLrk9Jr/QhltXkQWGbRAlyjYLksvEoJAiSLb4UYjaRUxGJ9uMsvKVXF9O4Y
         hXXeiUr0KSz3z3YGx2IHTZiRcXo7lz+bZlHY1328KnKkSkXpv+vyWIoL+YssMePSgt
         QMQDX82cJ9luDZPesDjSBb07DmYrODADigwON5AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/207] perf sort: Fix the weight sort key behavior
Date:   Mon,  6 Dec 2021 15:54:57 +0100
Message-Id: <20211206145611.710764766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 784e8adda4cdb3e2510742023729851b6c08803c ]

Currently, the 'weight' field in the perf sample has latency information
for some instructions like in memory accesses.  And perf tool has 'weight'
and 'local_weight' sort keys to display the info.

But it's somewhat confusing what it shows exactly.  In my understanding,
'local_weight' shows a weight in a single sample, and (global) 'weight'
shows a sum of the weights in the hist_entry.

For example:

  $ perf mem record -t load dd if=/dev/zero of=/dev/null bs=4k count=1M

  $ perf report --stdio -n -s +local_weight
  ...
  #
  # Overhead  Samples  Command  Shared Object     Symbol                     Local Weight
  # ........  .......  .......  ................  .........................  ............
  #
      21.23%      313  dd       [kernel.vmlinux]  [k] lockref_get_not_zero   32
      12.43%      183  dd       [kernel.vmlinux]  [k] lockref_get_not_zero   35
      11.97%      159  dd       [kernel.vmlinux]  [k] lockref_get_not_zero   36
      10.40%      141  dd       [kernel.vmlinux]  [k] lockref_put_return     32
       7.63%      113  dd       [kernel.vmlinux]  [k] lockref_get_not_zero   33
       6.37%       92  dd       [kernel.vmlinux]  [k] lockref_get_not_zero   34
       6.15%       90  dd       [kernel.vmlinux]  [k] lockref_put_return     33
  ...

So let's look at the 'lockref_get_not_zero' symbols.  The top entry
shows that 313 samples were captured with 'local_weight' 32, so the
total weight should be 313 x 32 = 10016.  But it's not the case:

  $ perf report --stdio -n -s +local_weight,weight -S lockref_get_not_zero
  ...
  #
  # Overhead  Samples  Command  Shared Object     Local Weight  Weight
  # ........  .......  .......  ................  ............  ......
  #
       1.36%        4  dd       [kernel.vmlinux]  36            144
       0.47%        4  dd       [kernel.vmlinux]  37            148
       0.42%        4  dd       [kernel.vmlinux]  32            128
       0.40%        4  dd       [kernel.vmlinux]  34            136
       0.35%        4  dd       [kernel.vmlinux]  36            144
       0.34%        4  dd       [kernel.vmlinux]  35            140
       0.30%        4  dd       [kernel.vmlinux]  36            144
       0.30%        4  dd       [kernel.vmlinux]  34            136
       0.30%        4  dd       [kernel.vmlinux]  32            128
       0.30%        4  dd       [kernel.vmlinux]  32            128
  ...

With the 'weight' sort key, it's divided to 4 samples even with the same
info ('comm', 'dso', 'sym' and 'local_weight').  I don't think this is
what we want.

I found this because of the way it aggregates the 'weight' value.  Since
it's not a period, we should not add them in the he->stat.  Otherwise,
two 32 'weight' entries will create a 64 'weight' entry.

After that, new 32 'weight' samples don't have a matching entry so it'd
create a new entry and make it a 64 'weight' entry again and again.
Later, they will be merged into 128 'weight' entries during the
hists__collapse_resort() with 4 samples, multiple times like above.

Let's keep the weight and display it differently.  For 'local_weight',
it can show the weight as is, and for (global) 'weight' it can display
the number multiplied by the number of samples.

With this change, I can see the expected numbers.

  $ perf report --stdio -n -s +local_weight,weight -S lockref_get_not_zero
  ...
  #
  # Overhead  Samples  Command  Shared Object     Local Weight  Weight
  # ........  .......  .......  ................  ............  .....
  #
      21.23%      313  dd       [kernel.vmlinux]  32            10016
      12.43%      183  dd       [kernel.vmlinux]  35            6405
      11.97%      159  dd       [kernel.vmlinux]  36            5724
       7.63%      113  dd       [kernel.vmlinux]  33            3729
       6.37%       92  dd       [kernel.vmlinux]  34            3128
       4.17%       59  dd       [kernel.vmlinux]  37            2183
       0.08%        1  dd       [kernel.vmlinux]  269           269
       0.08%        1  dd       [kernel.vmlinux]  38            38

Reviewed-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20211105225617.151364-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 14 +++++---------
 tools/perf/util/sort.c | 24 +++++++-----------------
 tools/perf/util/sort.h |  2 +-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 65fe65ba03c25..4e9bd7b589b1a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -290,11 +290,9 @@ static long hist_time(unsigned long htime)
 }
 
 static void he_stat__add_period(struct he_stat *he_stat, u64 period,
-				u64 weight, u64 ins_lat, u64 p_stage_cyc)
+				u64 ins_lat, u64 p_stage_cyc)
 {
-
 	he_stat->period		+= period;
-	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
 	he_stat->ins_lat	+= ins_lat;
 	he_stat->p_stage_cyc	+= p_stage_cyc;
@@ -308,9 +306,8 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
-	dest->weight		+= src->weight;
 	dest->ins_lat		+= src->ins_lat;
-	dest->p_stage_cyc		+= src->p_stage_cyc;
+	dest->p_stage_cyc	+= src->p_stage_cyc;
 }
 
 static void he_stat__decay(struct he_stat *he_stat)
@@ -598,7 +595,6 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 	struct hist_entry *he;
 	int64_t cmp;
 	u64 period = entry->stat.period;
-	u64 weight = entry->stat.weight;
 	u64 ins_lat = entry->stat.ins_lat;
 	u64 p_stage_cyc = entry->stat.p_stage_cyc;
 	bool leftmost = true;
@@ -619,11 +615,11 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 
 		if (!cmp) {
 			if (sample_self) {
-				he_stat__add_period(&he->stat, period, weight, ins_lat, p_stage_cyc);
+				he_stat__add_period(&he->stat, period, ins_lat, p_stage_cyc);
 				hist_entry__add_callchain_period(he, period);
 			}
 			if (symbol_conf.cumulate_callchain)
-				he_stat__add_period(he->stat_acc, period, weight, ins_lat, p_stage_cyc);
+				he_stat__add_period(he->stat_acc, period, ins_lat, p_stage_cyc);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -733,7 +729,6 @@ __hists__add_entry(struct hists *hists,
 		.stat = {
 			.nr_events = 1,
 			.period	= sample->period,
-			.weight = sample->weight,
 			.ins_lat = sample->ins_lat,
 			.p_stage_cyc = sample->p_stage_cyc,
 		},
@@ -748,6 +743,7 @@ __hists__add_entry(struct hists *hists,
 		.raw_size = sample->raw_size,
 		.ops = ops,
 		.time = hist_time(sample->time),
+		.weight = sample->weight,
 	}, *he = hists__findnew_entry(hists, &entry, al, sample_self);
 
 	if (!hists->has_callchains && he && he->callchain_size != 0)
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 568a88c001c6c..903f34fff27e1 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1325,45 +1325,35 @@ struct sort_entry sort_mispredict = {
 	.se_width_idx	= HISTC_MISPREDICT,
 };
 
-static u64 he_weight(struct hist_entry *he)
-{
-	return he->stat.nr_events ? he->stat.weight / he->stat.nr_events : 0;
-}
-
 static int64_t
-sort__local_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__weight_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return he_weight(left) - he_weight(right);
+	return left->weight - right->weight;
 }
 
 static int hist_entry__local_weight_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(he));
+	return repsep_snprintf(bf, size, "%-*llu", width, he->weight);
 }
 
 struct sort_entry sort_local_weight = {
 	.se_header	= "Local Weight",
-	.se_cmp		= sort__local_weight_cmp,
+	.se_cmp		= sort__weight_cmp,
 	.se_snprintf	= hist_entry__local_weight_snprintf,
 	.se_width_idx	= HISTC_LOCAL_WEIGHT,
 };
 
-static int64_t
-sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return left->stat.weight - right->stat.weight;
-}
-
 static int hist_entry__global_weight_snprintf(struct hist_entry *he, char *bf,
 					      size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*llu", width, he->stat.weight);
+	return repsep_snprintf(bf, size, "%-*llu", width,
+			       he->weight * he->stat.nr_events);
 }
 
 struct sort_entry sort_global_weight = {
 	.se_header	= "Weight",
-	.se_cmp		= sort__global_weight_cmp,
+	.se_cmp		= sort__weight_cmp,
 	.se_snprintf	= hist_entry__global_weight_snprintf,
 	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
 };
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b67c469aba795..e18b79916f638 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,7 +49,6 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
-	u64			weight;
 	u64			ins_lat;
 	u64			p_stage_cyc;
 	u32			nr_events;
@@ -109,6 +108,7 @@ struct hist_entry {
 	s32			socket;
 	s32			cpu;
 	u64			code_page_size;
+	u64			weight;
 	u8			cpumode;
 	u8			depth;
 
-- 
2.33.0



