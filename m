Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C35417412
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345335AbhIXNCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345281AbhIXNAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B95A613C8;
        Fri, 24 Sep 2021 12:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488026;
        bh=r3lxI0r23us1CjIf2yDVX+CSZQywtUPKF6wBpa4voX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYIEA5NPDm6iv2reqSgyIKxAK3Ggea5hY/gnvGPXmKBPZ93HpFb4s9eqf7oWiPEvr
         X/pPhCzd80e9kQzkCTFjW57RQqrOjIZQYy/BJxB7iBHAIH44aMaXhgOeW4GFMuW79P
         dXAM9s1rFRgvWRglWCU5OyKnQbU8MlfbQuVf/4y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 054/100] perf tools: Fix hybrid config terms list corruption
Date:   Fri, 24 Sep 2021 14:44:03 +0200
Message-Id: <20210924124343.244062304@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 99fc5941b835d662eb2e91d8b61249e9a51df9f0 ]

A config terms list was spliced twice, resulting in a never-ending loop
when the list was traversed. Fix by using list_splice_init() and copying
and freeing the lists as necessary.

This patch also depends on patch "perf tools: Factor out
copy_config_terms() and free_config_terms()"

Example on ADL:

 Before:

  # perf record -e '{intel_pt//,cycles/aux-sample-size=4096/pp}' uname &
  # jobs
  [1]+  Running                    perf record -e "{intel_pt//,cycles/aux-sample-size=4096/pp}" uname
  # perf top -E 10
    PerfTop:    4071 irqs/sec  kernel: 6.9%  exact: 100.0% lost: 0/0 drop: 0/0 [4000Hz cycles],  (all, 24 CPUs)
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    97.60%  perf           [.] __evsel__get_config_term
     0.25%  [kernel]       [k] kallsyms_expand_symbol.constprop.13
     0.24%  perf           [.] kallsyms__parse
     0.15%  [kernel]       [k] _raw_spin_lock
     0.14%  [kernel]       [k] number
     0.13%  [kernel]       [k] advance_transaction
     0.08%  [kernel]       [k] format_decode
     0.08%  perf           [.] map__process_kallsym_symbol
     0.08%  perf           [.] rb_insert_color
     0.08%  [kernel]       [k] vsnprintf
  exiting.
  # kill %1

After:

  # perf record -e '{intel_pt//,cycles/aux-sample-size=4096/pp}' uname &
  Linux
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.060 MB perf.data ]
  # perf script | head
       perf-exec   604 [001]  1827.312293:                            psb:  psb offs: 0                       ffffffffb8415e87 pt_config_start+0x37 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb856a3bd event_sched_in.isra.133+0xfd ([kernel.kallsyms]) => ffffffffb856a9a0 perf_pmu_nop_void+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb856b10e merge_sched_in+0x26e ([kernel.kallsyms]) => ffffffffb856a2c0 event_sched_in.isra.133+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb856a45d event_sched_in.isra.133+0x19d ([kernel.kallsyms]) => ffffffffb8568b80 perf_event_set_state.part.61+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb8568b86 perf_event_set_state.part.61+0x6 ([kernel.kallsyms]) => ffffffffb85662a0 perf_event_update_time+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb856a35c event_sched_in.isra.133+0x9c ([kernel.kallsyms]) => ffffffffb8567610 perf_log_itrace_start+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb856a377 event_sched_in.isra.133+0xb7 ([kernel.kallsyms]) => ffffffffb8403b40 x86_pmu_add+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb8403b86 x86_pmu_add+0x46 ([kernel.kallsyms]) => ffffffffb8403940 collect_events+0x0 ([kernel.kallsyms])
       perf-exec   604  1827.312293:          1                       branches:  ffffffffb8403a7b collect_events+0x13b ([kernel.kallsyms]) => ffffffffb8402cd0 collect_event+0x0 ([kernel.kallsyms])

Fixes: 30def61f64bac5 ("perf parse-events Create two hybrid cache events")
Fixes: 94da591b1c7913 ("perf parse-events Create two hybrid raw events")
Fixes: 9cbfa2f64c04d9 ("perf parse-events Create two hybrid hardware events")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: https //lore.kernel.org/r/20210909125508.28693-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events-hybrid.c | 18 +++++++++++++++---
 tools/perf/util/parse-events.c        | 18 ++++++++++++------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events-hybrid.c b/tools/perf/util/parse-events-hybrid.c
index 10160ab126f9..b234d95fb10a 100644
--- a/tools/perf/util/parse-events-hybrid.c
+++ b/tools/perf/util/parse-events-hybrid.c
@@ -76,12 +76,16 @@ static int add_hw_hybrid(struct parse_events_state *parse_state,
 	int ret;
 
 	perf_pmu__for_each_hybrid_pmu(pmu) {
+		LIST_HEAD(terms);
+
 		if (pmu_cmp(parse_state, pmu))
 			continue;
 
+		copy_config_terms(&terms, config_terms);
 		ret = create_event_hybrid(PERF_TYPE_HARDWARE,
 					  &parse_state->idx, list, attr, name,
-					  config_terms, pmu);
+					  &terms, pmu);
+		free_config_terms(&terms);
 		if (ret)
 			return ret;
 	}
@@ -115,11 +119,15 @@ static int add_raw_hybrid(struct parse_events_state *parse_state,
 	int ret;
 
 	perf_pmu__for_each_hybrid_pmu(pmu) {
+		LIST_HEAD(terms);
+
 		if (pmu_cmp(parse_state, pmu))
 			continue;
 
+		copy_config_terms(&terms, config_terms);
 		ret = create_raw_event_hybrid(&parse_state->idx, list, attr,
-					      name, config_terms, pmu);
+					      name, &terms, pmu);
+		free_config_terms(&terms);
 		if (ret)
 			return ret;
 	}
@@ -165,11 +173,15 @@ int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
 
 	*hybrid = true;
 	perf_pmu__for_each_hybrid_pmu(pmu) {
+		LIST_HEAD(terms);
+
 		if (pmu_cmp(parse_state, pmu))
 			continue;
 
+		copy_config_terms(&terms, config_terms);
 		ret = create_event_hybrid(PERF_TYPE_HW_CACHE, idx, list,
-					  attr, name, config_terms, pmu);
+					  attr, name, &terms, pmu);
+		free_config_terms(&terms);
 		if (ret)
 			return ret;
 	}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5eae23cfceb..790b72f2f31f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -387,7 +387,7 @@ __add_event(struct list_head *list, int *idx,
 		evsel->name = strdup(name);
 
 	if (config_terms)
-		list_splice(config_terms, &evsel->config_terms);
+		list_splice_init(config_terms, &evsel->config_terms);
 
 	if (list)
 		list_add_tail(&evsel->core.node, list);
@@ -535,9 +535,12 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 					     config_name ? : name, &config_terms,
 					     &hybrid, parse_state);
 	if (hybrid)
-		return ret;
+		goto out_free_terms;
 
-	return add_event(list, idx, &attr, config_name ? : name, &config_terms);
+	ret = add_event(list, idx, &attr, config_name ? : name, &config_terms);
+out_free_terms:
+	free_config_terms(&config_terms);
+	return ret;
 }
 
 static void tracepoint_error(struct parse_events_error *e, int err,
@@ -1457,10 +1460,13 @@ int parse_events_add_numeric(struct parse_events_state *parse_state,
 					       get_config_name(head_config),
 					       &config_terms, &hybrid);
 	if (hybrid)
-		return ret;
+		goto out_free_terms;
 
-	return add_event(list, &parse_state->idx, &attr,
-			 get_config_name(head_config), &config_terms);
+	ret = add_event(list, &parse_state->idx, &attr,
+			get_config_name(head_config), &config_terms);
+out_free_terms:
+	free_config_terms(&config_terms);
+	return ret;
 }
 
 int parse_events_add_tool(struct parse_events_state *parse_state,
-- 
2.33.0



