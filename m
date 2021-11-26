Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD49C45E537
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358396AbhKZCkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358173AbhKZCiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B05461207;
        Fri, 26 Nov 2021 02:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894007;
        bh=6I5DmSQZEADLjxC+pKn5XQFg0mPjdZPlh4S2otOmnOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTttzGbdC8wkJ89DjRs4TNHNkKiW9dH6U0DN6EPyqU33dScLAhI+VURwjGMP+cWDd
         ARSt1Au1cn+JAFZ0vQ5vjxS+n1P87F8OlHyAsQJq0PL4xRjJbUdHVs3RwAcs+04TeX
         NGF05148cx+KL9LpDpUtqibf64ARxNg9aA9pQeYOzTQHDD5FDzwSUKF6+MPlSfSr4e
         tRAN5zTk6t9NRpyNt4CPCuGlI9EwU0MKS1u4T8X6rrJM7YZSRdpVmQ4vKTLlzGSOQR
         gADdNoAx0/nnpf3bfkwxm1sXo2D/3+Srzni5uDwqRkKsFqnXVmlCtXYUQ6niQ0Vn1H
         4W5+V/AAMru8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, ravi.bangoria@linux.ibm.com, rickyman7@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 35/39] perf sort: Fix the 'p_stage_cyc' sort key behavior
Date:   Thu, 25 Nov 2021 21:31:52 -0500
Message-Id: <20211126023156.441292-35-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit db4b284029099224f387d75198e5995df1cb8aef ]

andle 'p_stage_cyc' (for pipeline stage cycles) sort key with the same
rationale as for the 'weight' and 'local_weight', see the fix in this
series for a full explanation.

Not sure it also needs the local and global variants.

But I couldn't test it actually because I don't have the machine.

Reviewed-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20211105225617.151364-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 12 ++++--------
 tools/perf/util/sort.c |  4 ++--
 tools/perf/util/sort.h |  2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 54fe97dd191cf..b776465e04ef3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -289,12 +289,10 @@ static long hist_time(unsigned long htime)
 	return htime;
 }
 
-static void he_stat__add_period(struct he_stat *he_stat, u64 period,
-				u64 p_stage_cyc)
+static void he_stat__add_period(struct he_stat *he_stat, u64 period)
 {
 	he_stat->period		+= period;
 	he_stat->nr_events	+= 1;
-	he_stat->p_stage_cyc	+= p_stage_cyc;
 }
 
 static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
@@ -305,7 +303,6 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
-	dest->p_stage_cyc	+= src->p_stage_cyc;
 }
 
 static void he_stat__decay(struct he_stat *he_stat)
@@ -593,7 +590,6 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 	struct hist_entry *he;
 	int64_t cmp;
 	u64 period = entry->stat.period;
-	u64 p_stage_cyc = entry->stat.p_stage_cyc;
 	bool leftmost = true;
 
 	p = &hists->entries_in->rb_root.rb_node;
@@ -612,11 +608,11 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 
 		if (!cmp) {
 			if (sample_self) {
-				he_stat__add_period(&he->stat, period, p_stage_cyc);
+				he_stat__add_period(&he->stat, period);
 				hist_entry__add_callchain_period(he, period);
 			}
 			if (symbol_conf.cumulate_callchain)
-				he_stat__add_period(he->stat_acc, period, p_stage_cyc);
+				he_stat__add_period(he->stat_acc, period);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -726,7 +722,6 @@ __hists__add_entry(struct hists *hists,
 		.stat = {
 			.nr_events = 1,
 			.period	= sample->period,
-			.p_stage_cyc = sample->p_stage_cyc,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
@@ -741,6 +736,7 @@ __hists__add_entry(struct hists *hists,
 		.time = hist_time(sample->time),
 		.weight = sample->weight,
 		.ins_lat = sample->ins_lat,
+		.p_stage_cyc = sample->p_stage_cyc,
 	}, *he = hists__findnew_entry(hists, &entry, al, sample_self);
 
 	if (!hists->has_callchains && he && he->callchain_size != 0)
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index adc0584695d62..a111065b484ef 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1394,13 +1394,13 @@ struct sort_entry sort_global_ins_lat = {
 static int64_t
 sort__global_p_stage_cyc_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return left->stat.p_stage_cyc - right->stat.p_stage_cyc;
+	return left->p_stage_cyc - right->p_stage_cyc;
 }
 
 static int hist_entry__p_stage_cyc_snprintf(struct hist_entry *he, char *bf,
 					size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%-*u", width, he->stat.p_stage_cyc);
+	return repsep_snprintf(bf, size, "%-*u", width, he->p_stage_cyc);
 }
 
 struct sort_entry sort_p_stage_cyc = {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 22ae7c6ae3986..7b7145501933f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,7 +49,6 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
-	u64			p_stage_cyc;
 	u32			nr_events;
 };
 
@@ -109,6 +108,7 @@ struct hist_entry {
 	u64			code_page_size;
 	u64			weight;
 	u64			ins_lat;
+	u64			p_stage_cyc;
 	u8			cpumode;
 	u8			depth;
 
-- 
2.33.0

