Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D156469D65
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385816AbhLFP3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43528 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385918AbhLFPZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33CDE61342;
        Mon,  6 Dec 2021 15:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1596FC341C2;
        Mon,  6 Dec 2021 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804147;
        bh=higaiy19hTMVm9wdu3LUEVyWxBKuznw/D0yw5+vC4Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifnKILFgh6S19BEFma6sds2vww3+erQOSFkBNtPZ9GEuulzdI543ues5g/aT5Y/r4
         g0pAiTuWQGjYlyRPCyb2ux0q7kWXWkUb4EU87bTELwkUQOAJo4UbRRd9NXbZDo4kfl
         kctLxPnGSu/+sU6HiBw5ojDXbiUiOj+EqZk0rjxo=
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
Subject: [PATCH 5.15 044/207] perf sort: Fix the ins_lat sort key behavior
Date:   Mon,  6 Dec 2021 15:54:58 +0100
Message-Id: <20211206145611.752692867@linuxfoundation.org>
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

[ Upstream commit 4d03c75363eeca861c843319a0e6f4426234ed6c ]

Handle 'ins_lat' (for instruction latency) and 'local_ins_lat' sort keys
with the same rationale as for the 'weight' and 'local_weight', see the
previous fix in this series for a full explanation.

But I couldn't test it actually, so only build tested.

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
Link: https://lore.kernel.org/r/20211105225617.151364-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 11 ++++-------
 tools/perf/util/sort.c | 24 +++++++-----------------
 tools/perf/util/sort.h |  2 +-
 3 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4e9bd7b589b1a..54fe97dd191cf 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -290,11 +290,10 @@ static long hist_time(unsigned long htime)
 }
 
 static void he_stat__add_period(struct he_stat *he_stat, u64 period,
-				u64 ins_lat, u64 p_stage_cyc)
+				u64 p_stage_cyc)
 {
 	he_stat->period		+= period;
 	he_stat->nr_events	+= 1;
-	he_stat->ins_lat	+= ins_lat;
 	he_stat->p_stage_cyc	+= p_stage_cyc;
 }
 
@@ -306,7 +305,6 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
-	dest->ins_lat		+= src->ins_lat;
 	dest->p_stage_cyc	+= src->p_stage_cyc;
 }
 
@@ -595,7 +593,6 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 	struct hist_entry *he;
 	int64_t cmp;
 	u64 period = entry->stat.period;
-	u64 ins_lat = entry->stat.ins_lat;
 	u64 p_stage_cyc = entry->stat.p_stage_cyc;
 	bool leftmost = true;
 
@@ -615,11 +612,11 @@ static struct hist_entry *hists__findnew_entry(struct hists *hists,
 
 		if (!cmp) {
 			if (sample_self) {
-				he_stat__add_period(&he->stat, period, ins_lat, p_stage_cyc);
+				he_stat__add_period(&he->stat, period, p_stage_cyc);
 				hist_entry__add_callchain_period(he, period);
 			}
 			if (symbol_conf.cumulate_callchain)
-				he_stat__add_period(he->stat_acc, period, ins_lat, p_stage_cyc);
+				he_stat__add_period(he->stat_acc, period, p_stage_cyc);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -729,7 +726,6 @@ __hists__add_entry(struct hists *hists,
 		.stat = {
 			.nr_events = 1,
 			.period	= sample->period,
-			.ins_lat = sample->ins_lat,
 			.p_stage_cyc = sample->p_stage_cyc,
 		},
 		.parent = sym_parent,
@@ -744,6 +740,7 @@ __hists__add_entry(struct hists *hists,
 		.ops = ops,
 		.time = hist_time(sample->time),
 		.weight = sample->weight,
+		.ins_lat = sample->ins_lat,
 	}, *he = hists__findnew_entry(hists, &entry, al, sample_self);
 
 	if (!hists->has_callchains && he && he->callchain_size != 0)
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 903f34fff27e1..adc0584695d62 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1358,45 +1358,35 @@ struct sort_entry sort_global_weight = {
 	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
 };
 
-static u64 he_ins_lat(struct hist_entry *he)
-{
-		return he->stat.nr_events ? he->stat.ins_lat / he->stat.nr_events : 0;
-}
-
 static int64_t
-sort__local_ins_lat_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__ins_lat_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-		return he_ins_lat(left) - he_ins_lat(right);
+	return left->ins_lat - right->ins_lat;
 }
 
 static int hist_entry__local_ins_lat_snprintf(struct hist_entry *he, char *bf,
 					      size_t size, unsigned int width)
 {
-		return repsep_snprintf(bf, size, "%-*u", width, he_ins_lat(he));
+	return repsep_snprintf(bf, size, "%-*u", width, he->ins_lat);
 }
 
 struct sort_entry sort_local_ins_lat = {
 	.se_header	= "Local INSTR Latency",
-	.se_cmp		= sort__local_ins_lat_cmp,
+	.se_cmp		= sort__ins_lat_cmp,
 	.se_snprintf	= hist_entry__local_ins_lat_snprintf,
 	.se_width_idx	= HISTC_LOCAL_INS_LAT,
 };
 
-static int64_t
-sort__global_ins_lat_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-		return left->stat.ins_lat - right->stat.ins_lat;
-}
-
 static int hist_entry__global_ins_lat_snprintf(struct hist_entry *he, char *bf,
 					       size_t size, unsigned int width)
 {
-		return repsep_snprintf(bf, size, "%-*u", width, he->stat.ins_lat);
+	return repsep_snprintf(bf, size, "%-*u", width,
+			       he->ins_lat * he->stat.nr_events);
 }
 
 struct sort_entry sort_global_ins_lat = {
 	.se_header	= "INSTR Latency",
-	.se_cmp		= sort__global_ins_lat_cmp,
+	.se_cmp		= sort__ins_lat_cmp,
 	.se_snprintf	= hist_entry__global_ins_lat_snprintf,
 	.se_width_idx	= HISTC_GLOBAL_INS_LAT,
 };
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e18b79916f638..22ae7c6ae3986 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,7 +49,6 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
-	u64			ins_lat;
 	u64			p_stage_cyc;
 	u32			nr_events;
 };
@@ -109,6 +108,7 @@ struct hist_entry {
 	s32			cpu;
 	u64			code_page_size;
 	u64			weight;
+	u64			ins_lat;
 	u8			cpumode;
 	u8			depth;
 
-- 
2.33.0



