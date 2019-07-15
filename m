Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A4B68F8D
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389509AbfGOOPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389504AbfGOOPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:15:21 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA67520651;
        Mon, 15 Jul 2019 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200120;
        bh=sYvTTtjC6qEEigEX//SCq1GLdYh4FrlB/F42FWnPUos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/+BLpY3qI8L5wCStg65M0Jv2dTB3F8wjCDTxH4LCzKufe5ukV+GLc+FP4dqYixZV
         6HchP4WMrifYfFVfsC8fAGAdO/IBzx2Q4c5N8pyj3crBK0C+FgVAQ+cKIvGyBybUhI
         yRRyWyCQYJPY+1+RQt0Xx+rjenAWUPMm2b6n+lhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Agustin Vega-Frias <agustinv@codeaurora.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 189/219] perf stat: Fix metrics with --no-merge
Date:   Mon, 15 Jul 2019 10:03:10 -0400
Message-Id: <20190715140341.6443-189-sashal@kernel.org>
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

[ Upstream commit e3a9427323a53ceee540276a74af7706f350d052 ]

Since Fixes: 8c5421c016a4 ("perf pmu: Display pmu name when printing
unmerged events in stat") using --no-merge adds the PMU name to the
evsel name.

This breaks the metric value lookup because the parser doesn't know
about this.

Remove the extra postfixes for the metric evaluation.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Agustin Vega-Frias <agustinv@codeaurora.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Fixes: 8c5421c016a4 ("perf pmu: Display pmu name when printing unmerged events in stat")
Link: http://lkml.kernel.org/r/20190624193711.35241-5-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-shadow.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index e545e2a8ae71..0ef98e991ade 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -723,6 +723,7 @@ static void generic_metric(struct perf_stat_config *config,
 	double ratio;
 	int i;
 	void *ctxp = out->ctx;
+	char *n, *pn;
 
 	expr__ctx_init(&pctx);
 	expr__add_id(&pctx, name, avg);
@@ -742,7 +743,19 @@ static void generic_metric(struct perf_stat_config *config,
 			stats = &v->stats;
 			scale = 1.0;
 		}
-		expr__add_id(&pctx, metric_events[i]->name, avg_stats(stats)*scale);
+
+		n = strdup(metric_events[i]->name);
+		if (!n)
+			return;
+		/*
+		 * This display code with --no-merge adds [cpu] postfixes.
+		 * These are not supported by the parser. Remove everything
+		 * after the space.
+		 */
+		pn = strchr(n, ' ');
+		if (pn)
+			*pn = 0;
+		expr__add_id(&pctx, n, avg_stats(stats)*scale);
 	}
 	if (!metric_events[i]) {
 		const char *p = metric_expr;
@@ -759,6 +772,9 @@ static void generic_metric(struct perf_stat_config *config,
 				     (metric_name ? metric_name : name) : "", 0);
 	} else
 		print_metric(config, ctxp, NULL, NULL, "", 0);
+
+	for (i = 1; i < pctx.num_ids; i++)
+		free((void *)pctx.ids[i].name);
 }
 
 void perf_stat__print_shadow_stats(struct perf_stat_config *config,
-- 
2.20.1

