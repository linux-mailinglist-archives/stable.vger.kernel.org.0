Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CDF5498C5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383486AbiFMO02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383751AbiFMOX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E4321273;
        Mon, 13 Jun 2022 04:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4952612A8;
        Mon, 13 Jun 2022 11:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B848C34114;
        Mon, 13 Jun 2022 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120709;
        bh=gJVcHejTKcyuP/psQJV5MtzjcY2RzC0c8YvPepU7RPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oxqw/PGTNtqLyyp40Jf0BwlVTPHdClLyc21JcQLHgnlyAiZez4YvmSUFjlAwEKMdg
         An9Dvgzf2qesmBnkpOu24kLrHwITqYJSussa9YzQxtK3wje82mqJvUZZ7yV2WCqtBc
         +UQoxoG6/i5fA6nSd2McVATZqajWoFb8iMUO9tzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 129/298] perf parse-events: Move slots event for the hybrid platform too
Date:   Mon, 13 Jun 2022 12:10:23 +0200
Message-Id: <20220613094928.855785268@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit e0e14cdff31d326f81e0edbd5140f788c870756c ]

The commit 94dbfd6781a0e87b ("perf parse-events: Architecture specific
leader override") introduced a feature to reorder the slots event to
fulfill the restriction of the perf metrics topdown group. But the
feature doesn't work on the hybrid machine.

  $ perf stat -e "{cpu_core/instructions/,cpu_core/slots/,cpu_core/topdown-retiring/}" -a sleep 1

   Performance counter stats for 'system wide':

       <not counted>      cpu_core/instructions/
       <not counted>      cpu_core/slots/
     <not supported>      cpu_core/topdown-retiring/

         1.002871801 seconds time elapsed

A hybrid platform has a different PMU name for the core PMUs, while
current perf hard code the PMU name "cpu".

Introduce a new function to check whether the system supports the perf
metrics feature. The result is cached for the future usage.

For X86, the core PMU name always has "cpu" prefix.

With the patch:

  $ perf stat -e "{cpu_core/instructions/,cpu_core/slots/,cpu_core/topdown-retiring/}" -a sleep 1

   Performance counter stats for 'system wide':

          76,337,010      cpu_core/slots/
          10,416,809      cpu_core/instructions/
          11,692,372      cpu_core/topdown-retiring/

         1.002805453 seconds time elapsed

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220518143900.1493980-5-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evlist.c  |  5 +++--
 tools/perf/arch/x86/util/topdown.c | 25 +++++++++++++++++++++++++
 tools/perf/arch/x86/util/topdown.h |  7 +++++++
 3 files changed, 35 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/topdown.h

diff --git a/tools/perf/arch/x86/util/evlist.c b/tools/perf/arch/x86/util/evlist.c
index 75564a7df15b..68f681ad54c1 100644
--- a/tools/perf/arch/x86/util/evlist.c
+++ b/tools/perf/arch/x86/util/evlist.c
@@ -3,6 +3,7 @@
 #include "util/pmu.h"
 #include "util/evlist.h"
 #include "util/parse-events.h"
+#include "topdown.h"
 
 #define TOPDOWN_L1_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound}"
 #define TOPDOWN_L2_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound,topdown-heavy-ops,topdown-br-mispredict,topdown-fetch-lat,topdown-mem-bound}"
@@ -25,12 +26,12 @@ struct evsel *arch_evlist__leader(struct list_head *list)
 
 	first = list_first_entry(list, struct evsel, core.node);
 
-	if (!pmu_have_event("cpu", "slots"))
+	if (!topdown_sys_has_perf_metrics())
 		return first;
 
 	/* If there is a slots event and a topdown event then the slots event comes first. */
 	__evlist__for_each_entry(list, evsel) {
-		if (evsel->pmu_name && !strcmp(evsel->pmu_name, "cpu") && evsel->name) {
+		if (evsel->pmu_name && !strncmp(evsel->pmu_name, "cpu", 3) && evsel->name) {
 			if (strcasestr(evsel->name, "slots")) {
 				slots = evsel;
 				if (slots == first)
diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
index 2f3d96aa92a5..f4d5422e9960 100644
--- a/tools/perf/arch/x86/util/topdown.c
+++ b/tools/perf/arch/x86/util/topdown.c
@@ -3,6 +3,31 @@
 #include "api/fs/fs.h"
 #include "util/pmu.h"
 #include "util/topdown.h"
+#include "topdown.h"
+
+/* Check whether there is a PMU which supports the perf metrics. */
+bool topdown_sys_has_perf_metrics(void)
+{
+	static bool has_perf_metrics;
+	static bool cached;
+	struct perf_pmu *pmu;
+
+	if (cached)
+		return has_perf_metrics;
+
+	/*
+	 * The perf metrics feature is a core PMU feature.
+	 * The PERF_TYPE_RAW type is the type of a core PMU.
+	 * The slots event is only available when the core PMU
+	 * supports the perf metrics feature.
+	 */
+	pmu = perf_pmu__find_by_type(PERF_TYPE_RAW);
+	if (pmu && pmu_have_event(pmu->name, "slots"))
+		has_perf_metrics = true;
+
+	cached = true;
+	return has_perf_metrics;
+}
 
 /*
  * Check whether we can use a group for top down.
diff --git a/tools/perf/arch/x86/util/topdown.h b/tools/perf/arch/x86/util/topdown.h
new file mode 100644
index 000000000000..46bf9273e572
--- /dev/null
+++ b/tools/perf/arch/x86/util/topdown.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOPDOWN_H
+#define _TOPDOWN_H 1
+
+bool topdown_sys_has_perf_metrics(void);
+
+#endif
-- 
2.35.1



