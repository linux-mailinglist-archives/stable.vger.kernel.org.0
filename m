Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A8C5415BE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359685AbiFGUjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377358AbiFGUdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CC17F820;
        Tue,  7 Jun 2022 11:34:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34562B8233E;
        Tue,  7 Jun 2022 18:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5333EC36AFF;
        Tue,  7 Jun 2022 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626892;
        bh=Jx1t5XAPdUTEUwodH2UHljSHn1Z8270s0i71CEmpdIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12YKT2E/36HcNH8PdHmOaCLxyXJRvGQrJME32TG0/2h4Q9xEuOvfSfnq0A3cuZxBV
         e1RTxUjBS9qqI8Ud/hMuT96hf/u/5GEUoRg5rkV011XEo1O71KLFuAjdyQqyX8ldMW
         wh64UxDjS2sPby5QGYH2tmtaxpJ3dhchBPjrHGeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Florian Fischer <florian.fischer@muhq.space>,
        Ingo Molnar <mingo@redhat.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Shunsuke Nakamura <nakamura.shun@fujitsu.com>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 542/772] perf evlist: Keep topdown counters in weak group
Date:   Tue,  7 Jun 2022 19:02:14 +0200
Message-Id: <20220607165004.934114625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit d98079c05b5a5411c6030c47b6256cbeeeff77d0 ]

On Intel Icelake, topdown events must always be grouped with a slots
event as leader. When a metric is parsed a weak group is formed and
retried if perf_event_open fails. The retried events aren't grouped
breaking the slots leader requirement. This change modifies the weak
group "reset" behavior so that topdown events aren't broken from the
group for the retry.

  $ perf stat -e '{slots,topdown-bad-spec,topdown-be-bound,topdown-fe-bound,topdown-retiring,branch-instructions,branch-misses,bus-cycles,cache-misses,cache-references,cpu-cycles,instructions,mem-loads,mem-stores,ref-cycles,baclears.any,ARITH.DIVIDER_ACTIVE}:W' -a sleep 1

   Performance counter stats for 'system wide':

    47,867,188,483      slots                                                         (92.27%)
   <not supported>      topdown-bad-spec
   <not supported>      topdown-be-bound
   <not supported>      topdown-fe-bound
   <not supported>      topdown-retiring
     2,173,346,937      branch-instructions                                           (92.27%)
        10,540,253      branch-misses             #    0.48% of all branches          (92.29%)
        96,291,140      bus-cycles                                                    (92.29%)
         6,214,202      cache-misses              #   20.120 % of all cache refs      (92.29%)
        30,886,082      cache-references                                              (76.91%)
    11,773,726,641      cpu-cycles                                                    (84.62%)
    11,807,585,307      instructions              #    1.00  insn per cycle           (92.31%)
                 0      mem-loads                                                     (92.32%)
     2,212,928,573      mem-stores                                                    (84.69%)
    10,024,403,118      ref-cycles                                                    (92.35%)
        16,232,978      baclears.any                                                  (92.35%)
        23,832,633      ARITH.DIVIDER_ACTIVE                                          (84.59%)

       0.981070734 seconds time elapsed

After:

  $ perf stat -e '{slots,topdown-bad-spec,topdown-be-bound,topdown-fe-bound,topdown-retiring,branch-instructions,branch-misses,bus-cycles,cache-misses,cache-references,cpu-cycles,instructions,mem-loads,mem-stores,ref-cycles,baclears.any,ARITH.DIVIDER_ACTIVE}:W' -a sleep 1

   Performance counter stats for 'system wide':

       31040189283      slots                                                         (92.27%)
        8997514811      topdown-bad-spec          #     28.2% bad speculation         (92.27%)
       10997536028      topdown-be-bound          #     34.5% backend bound           (92.27%)
        4778060526      topdown-fe-bound          #     15.0% frontend bound          (92.27%)
        7086628768      topdown-retiring          #     22.2% retiring                (92.27%)
        1417611942      branch-instructions                                           (92.26%)
           5285529      branch-misses             #    0.37% of all branches          (92.28%)
          62922469      bus-cycles                                                    (92.29%)
           1440708      cache-misses              #    8.292 % of all cache refs      (92.30%)
          17374098      cache-references                                              (76.94%)
        8040889520      cpu-cycles                                                    (84.63%)
        7709992319      instructions              #    0.96  insn per cycle           (92.32%)
                 0      mem-loads                                                     (92.32%)
        1515669558      mem-stores                                                    (84.68%)
        6542411177      ref-cycles                                                    (92.35%)
           4154149      baclears.any                                                  (92.35%)
          20556152      ARITH.DIVIDER_ACTIVE                                          (84.59%)

       1.010799593 seconds time elapsed

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Florian Fischer <florian.fischer@muhq.space>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: Shunsuke Nakamura <nakamura.shun@fujitsu.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220517052724.283874-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evsel.c | 12 ++++++++++++
 tools/perf/util/evlist.c         | 16 ++++++++++++++--
 tools/perf/util/evsel.c          | 10 ++++++++++
 tools/perf/util/evsel.h          |  3 +++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/x86/util/evsel.c b/tools/perf/arch/x86/util/evsel.c
index ac2899a25b7a..00cb4466b4ca 100644
--- a/tools/perf/arch/x86/util/evsel.c
+++ b/tools/perf/arch/x86/util/evsel.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include "util/evsel.h"
 #include "util/env.h"
+#include "util/pmu.h"
 #include "linux/string.h"
 
 void arch_evsel__set_sample_weight(struct evsel *evsel)
@@ -29,3 +30,14 @@ void arch_evsel__fixup_new_cycles(struct perf_event_attr *attr)
 
 	free(env.cpuid);
 }
+
+bool arch_evsel__must_be_in_group(const struct evsel *evsel)
+{
+	if ((evsel->pmu_name && strcmp(evsel->pmu_name, "cpu")) ||
+	    !pmu_have_event("cpu", "slots"))
+		return false;
+
+	return evsel->name &&
+		(!strcasecmp(evsel->name, "slots") ||
+		 strcasestr(evsel->name, "topdown"));
+}
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 41a66a48cbdf..3ff0de0b6710 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1790,8 +1790,17 @@ struct evsel *evlist__reset_weak_group(struct evlist *evsel_list, struct evsel *
 		if (evsel__has_leader(c2, leader)) {
 			if (is_open && close)
 				perf_evsel__close(&c2->core);
-			evsel__set_leader(c2, c2);
-			c2->core.nr_members = 0;
+			/*
+			 * We want to close all members of the group and reopen
+			 * them. Some events, like Intel topdown, require being
+			 * in a group and so keep these in the group.
+			 */
+			if (!evsel__must_be_in_group(c2) && c2 != leader) {
+				evsel__set_leader(c2, c2);
+				c2->core.nr_members = 0;
+				leader->core.nr_members--;
+			}
+
 			/*
 			 * Set this for all former members of the group
 			 * to indicate they get reopened.
@@ -1799,6 +1808,9 @@ struct evsel *evlist__reset_weak_group(struct evlist *evsel_list, struct evsel *
 			c2->reset_group = true;
 		}
 	}
+	/* Reset the leader count if all entries were removed. */
+	if (leader->core.nr_members == 1)
+		leader->core.nr_members = 0;
 	return leader;
 }
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22d3267ce294..6fb3cf924dd2 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3048,3 +3048,13 @@ int evsel__source_count(const struct evsel *evsel)
 	}
 	return count;
 }
+
+bool __weak arch_evsel__must_be_in_group(const struct evsel *evsel __maybe_unused)
+{
+	return false;
+}
+
+bool evsel__must_be_in_group(const struct evsel *evsel)
+{
+	return arch_evsel__must_be_in_group(evsel);
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 041b42d33bf5..a36172ed4cf6 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -483,6 +483,9 @@ bool evsel__has_leader(struct evsel *evsel, struct evsel *leader);
 bool evsel__is_leader(struct evsel *evsel);
 void evsel__set_leader(struct evsel *evsel, struct evsel *leader);
 int evsel__source_count(const struct evsel *evsel);
+bool evsel__must_be_in_group(const struct evsel *evsel);
+
+bool arch_evsel__must_be_in_group(const struct evsel *evsel);
 
 /*
  * Macro to swap the bit-field postition and size.
-- 
2.35.1



