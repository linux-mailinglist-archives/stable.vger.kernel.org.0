Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A2469E6E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379521AbhLFPiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378945AbhLFPgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1088C061D7E;
        Mon,  6 Dec 2021 07:22:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A874CB81120;
        Mon,  6 Dec 2021 15:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A586AC341C5;
        Mon,  6 Dec 2021 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804150;
        bh=6I5DmSQZEADLjxC+pKn5XQFg0mPjdZPlh4S2otOmnOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfjN7bL+FE7tiDOnOZB7sxSqGPP55hMth1//0cbFIAeRJplmH6qjMTOYjWxcf5guu
         kSD6ldRmTe5g1dJnvxGO9gqosKCKXdhrfPwta3oLT5aOHgzlaBCW4BtMt40CB6/T/U
         4Ctqo7o0zObSvsw06JnMefoSqmW+CijEyFSVEKUo=
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
Subject: [PATCH 5.15 045/207] perf sort: Fix the p_stage_cyc sort key behavior
Date:   Mon,  6 Dec 2021 15:54:59 +0100
Message-Id: <20211206145611.791336429@linuxfoundation.org>
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



