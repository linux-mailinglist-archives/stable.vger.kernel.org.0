Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2258173A9C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403824AbfGXTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404063AbfGXTwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:52:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95140217D4;
        Wed, 24 Jul 2019 19:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997921;
        bh=37qhZRHmYZ4Vv5ccEyMlz+I5hVSPh0cUKDBsnMTKIrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9Vc4Z9hWjknq4So601mCwSoLtiyokyO0lT4XGq8acMKfYjohHP0mymc3OrZdX9US
         GrP0aGB+S2Iy3lKu36hVik7lZrz2oCeD9X1Z8i46U5f8Vy0g8jYqQjxK1sMTyeXTl3
         2JAb1Ccb/B+IYY6I2ksOelclKFefLfSe3+tmJz6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Agustin Vega-Frias <agustinv@codeaurora.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 189/371] perf stat: Fix metrics with --no-merge
Date:   Wed, 24 Jul 2019 21:19:01 +0200
Message-Id: <20190724191739.213582051@linuxfoundation.org>
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



