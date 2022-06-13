Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9DC549667
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383497AbiFMO0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383774AbiFMOX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0932E9C3;
        Mon, 13 Jun 2022 04:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D263B80D31;
        Mon, 13 Jun 2022 11:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C149C34114;
        Mon, 13 Jun 2022 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120711;
        bh=oPvLPVSnUwxVm9FEdOgtJaVg+07QbMxAqqkLoJz7sQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC1oKz5XQQ4FSuzEWv36Szzu4cC8f3fYAqVoDEDiCyTkqnHMl1+FZ0n1UsDMQe23b
         fefHXBs+APAYY6m0JmnKBta7N9H52KUHz5EGAuRVqVKEuVc+Ja5Ta7XsR13rxbKa6I
         rQl+GzIFNHLBEe938g3KSKQyH4wn3y3itEB9I8T4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 130/298] perf record: Support sample-read topdown metric group for hybrid platforms
Date:   Mon, 13 Jun 2022 12:10:24 +0200
Message-Id: <20220613094928.886152999@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit 151e7d75036b4e2ac0f33730bc1a5b3ff424d9a7 ]

With the hardware TopDown metrics feature, the sample-read feature should
be supported for a TopDown group, e.g., sample a non-topdown event and read
a Topdown metric group. But the current perf record code errors are out.

For a TopDown metric group,the slots event must be the leader of the group,
but the leader slots event doesn't support sampling. To support sample-read
the TopDown metric group, uses the 2nd event of the group as the "leader"
for the purposes of sampling.

Only the platform with the TopDown metric feature supports sample-read the
topdown group. In commit acb65150a47c ("perf record: Support sample-read
topdown metric group"), it adds arch_topdown_sample_read() to indicate
whether the TopDown group supports sample-read, it should only work on the
non-hybrid systems, this patch extends the support for hybrid platforms.

Before:

  # ./perf record -e "{cpu_core/slots/,cpu_core/cycles/,cpu_core/topdown-retiring/}:S" -a sleep 1
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cpu_core/topdown-retiring/).
  /bin/dmesg | grep -i perf may provide additional information.

After:

  # ./perf record -e "{cpu_core/slots/,cpu_core/cycles/,cpu_core/topdown-retiring/}:S" -a sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.238 MB perf.data (369 samples) ]

Fixes: acb65150a47c2bae ("perf record: Support sample-read topdown metric group")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220602153603.1884710-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evsel.c   |  3 ++-
 tools/perf/arch/x86/util/evsel.h   |  7 +++++++
 tools/perf/arch/x86/util/topdown.c | 21 ++++-----------------
 3 files changed, 13 insertions(+), 18 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/evsel.h

diff --git a/tools/perf/arch/x86/util/evsel.c b/tools/perf/arch/x86/util/evsel.c
index ff4561b7b600..3501399cef35 100644
--- a/tools/perf/arch/x86/util/evsel.c
+++ b/tools/perf/arch/x86/util/evsel.c
@@ -5,6 +5,7 @@
 #include "util/env.h"
 #include "util/pmu.h"
 #include "linux/string.h"
+#include "evsel.h"
 
 void arch_evsel__set_sample_weight(struct evsel *evsel)
 {
@@ -32,7 +33,7 @@ void arch_evsel__fixup_new_cycles(struct perf_event_attr *attr)
 }
 
 /* Check whether the evsel's PMU supports the perf metrics */
-static bool evsel__sys_has_perf_metrics(const struct evsel *evsel)
+bool evsel__sys_has_perf_metrics(const struct evsel *evsel)
 {
 	const char *pmu_name = evsel->pmu_name ? evsel->pmu_name : "cpu";
 
diff --git a/tools/perf/arch/x86/util/evsel.h b/tools/perf/arch/x86/util/evsel.h
new file mode 100644
index 000000000000..19ad1691374d
--- /dev/null
+++ b/tools/perf/arch/x86/util/evsel.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _EVSEL_H
+#define _EVSEL_H 1
+
+bool evsel__sys_has_perf_metrics(const struct evsel *evsel);
+
+#endif
diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
index f4d5422e9960..f81a7cfe4d63 100644
--- a/tools/perf/arch/x86/util/topdown.c
+++ b/tools/perf/arch/x86/util/topdown.c
@@ -4,6 +4,7 @@
 #include "util/pmu.h"
 #include "util/topdown.h"
 #include "topdown.h"
+#include "evsel.h"
 
 /* Check whether there is a PMU which supports the perf metrics. */
 bool topdown_sys_has_perf_metrics(void)
@@ -55,33 +56,19 @@ void arch_topdown_group_warn(void)
 
 #define TOPDOWN_SLOTS		0x0400
 
-static bool is_topdown_slots_event(struct evsel *counter)
-{
-	if (!counter->pmu_name)
-		return false;
-
-	if (strcmp(counter->pmu_name, "cpu"))
-		return false;
-
-	if (counter->core.attr.config == TOPDOWN_SLOTS)
-		return true;
-
-	return false;
-}
-
 /*
  * Check whether a topdown group supports sample-read.
  *
- * Only Topdown metic supports sample-read. The slots
+ * Only Topdown metric supports sample-read. The slots
  * event must be the leader of the topdown group.
  */
 
 bool arch_topdown_sample_read(struct evsel *leader)
 {
-	if (!pmu_have_event("cpu", "slots"))
+	if (!evsel__sys_has_perf_metrics(leader))
 		return false;
 
-	if (is_topdown_slots_event(leader))
+	if (leader->core.attr.config == TOPDOWN_SLOTS)
 		return true;
 
 	return false;
-- 
2.35.1



