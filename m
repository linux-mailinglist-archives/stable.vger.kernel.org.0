Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D913073AA0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404093AbfGXTwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404083AbfGXTwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:52:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6D522ADC;
        Wed, 24 Jul 2019 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997927;
        bh=UHLBMKuVRGNJacK5YLD3HvgkTEb59mm4jBKEy/AzQ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm0sD5oxO7YS6yIHyQlsOn4wq4tUFiHoYERDlC2BA5+mk1TBpXtvmN5zGLGzjqlUe
         m0nqTOZXryihzbncgWxSjIwB+Dxl6Ep+pdj6mQMur6SjIqdSSiAvq5zG3mqbDTqxNB
         eZTQr3E1PExs/VOwBTEgkg65KEi/gmp2GUOpmbI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 191/371] perf stat: Fix group lookup for metric group
Date:   Wed, 24 Jul 2019 21:19:03 +0200
Message-Id: <20190724191739.307166522@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



