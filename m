Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179ED695CF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbfGOOPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730888AbfGOOPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:15:34 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E452083D;
        Mon, 15 Jul 2019 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200133;
        bh=sWs75kMv5SbJX3sSqtr7kqjR9As/V0r5DSmaOku8aQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liD9mCU5+kaxtzQ0OC8gO6WUCnf3Ve/V/sse6/jszNTncx8QjmNP1Csvyo0KldYrI
         gtnXvN2bobnv3tZ2k+ytWab2abCMT8wfSoI3TVD7TlFDB3Qw5X54kmEVkB0/3LgEFz
         LWxaP4zlsGBz8sU3ZUxYCKVmzevZTpRO9yqCgDjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 191/219] perf stat: Fix group lookup for metric group
Date:   Mon, 15 Jul 2019 10:03:12 -0400
Message-Id: <20190715140341.6443-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 2f87f33f4226523df9c9cc28f9874ea02fcc3d3f ]

The metric group code tries to find a group it added earlier in the
evlist. Fix the lookup to handle groups with partially overlaps
correctly. When a sub string match fails and we reset the match, we have
to compare the first element again.

I also renamed the find_evsel function to find_evsel_group to make its
purpose clearer.

With the earlier changes this fixes:

Before:

  % perf stat -M UPI,IPC sleep 1
  ...
         1,032,922      uops_retired.retire_slots #      1.1 UPI
         1,896,096      inst_retired.any
         1,896,096      inst_retired.any
         1,177,254      cpu_clk_unhalted.thread

After:

  % perf stat -M UPI,IPC sleep 1
  ...
        1,013,193      uops_retired.retire_slots #      1.1 UPI
           932,033      inst_retired.any
           932,033      inst_retired.any          #      0.9 IPC
         1,091,245      cpu_clk_unhalted.thread

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Fixes: b18f3e365019 ("perf stat: Support JSON metrics in perf stat")
Link: http://lkml.kernel.org/r/20190624193711.35241-4-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 47 ++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index b8d864ed4afe..a48895c4324a 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -94,26 +94,49 @@ struct egroup {
 	const char *metric_expr;
 };
 
-static struct perf_evsel *find_evsel(struct perf_evlist *perf_evlist,
-				     const char **ids,
-				     int idnum,
-				     struct perf_evsel **metric_events)
+static bool record_evsel(int *ind, struct perf_evsel **start,
+			 int idnum,
+			 struct perf_evsel **metric_events,
+			 struct perf_evsel *ev)
+{
+	metric_events[*ind] = ev;
+	if (*ind == 0)
+		*start = ev;
+	if (++*ind == idnum) {
+		metric_events[*ind] = NULL;
+		return true;
+	}
+	return false;
+}
+
+static struct perf_evsel *find_evsel_group(struct perf_evlist *perf_evlist,
+					   const char **ids,
+					   int idnum,
+					   struct perf_evsel **metric_events)
 {
 	struct perf_evsel *ev, *start = NULL;
 	int ind = 0;
 
 	evlist__for_each_entry (perf_evlist, ev) {
+		if (ev->collect_stat)
+			continue;
 		if (!strcmp(ev->name, ids[ind])) {
-			metric_events[ind] = ev;
-			if (ind == 0)
-				start = ev;
-			if (++ind == idnum) {
-				metric_events[ind] = NULL;
+			if (record_evsel(&ind, &start, idnum,
+					 metric_events, ev))
 				return start;
-			}
 		} else {
+			/*
+			 * We saw some other event that is not
+			 * in our list of events. Discard
+			 * the whole match and start again.
+			 */
 			ind = 0;
 			start = NULL;
+			if (!strcmp(ev->name, ids[ind])) {
+				if (record_evsel(&ind, &start, idnum,
+						 metric_events, ev))
+					return start;
+			}
 		}
 	}
 	/*
@@ -143,8 +166,8 @@ static int metricgroup__setup_events(struct list_head *groups,
 			ret = -ENOMEM;
 			break;
 		}
-		evsel = find_evsel(perf_evlist, eg->ids, eg->idnum,
-				   metric_events);
+		evsel = find_evsel_group(perf_evlist, eg->ids, eg->idnum,
+					 metric_events);
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
 					eg->metric_name, eg->metric_expr);
-- 
2.20.1

