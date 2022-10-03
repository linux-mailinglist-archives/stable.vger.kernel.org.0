Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E195F2B9E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiJCIWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiJCIWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:22:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE62F7A769;
        Mon,  3 Oct 2022 00:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 481F2B80E8C;
        Mon,  3 Oct 2022 07:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF68C433D6;
        Mon,  3 Oct 2022 07:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781586;
        bh=fR8PO0eKNqHcM7WtHr582VKTe0KdCUnsZg4yAb+R4gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poXwQOuD/Q6KZ+k1RwFo0hy7mnFEdkQuBtMPedL6Gf9pKo57ZAQTilpBHIK4RHVz+
         pMt/Eig3kwcfd6ZaC8vXRrQ2iV3zfinlDd7MrB1Of4XVDsAxPmr+o4q5SbdVSUC+sD
         QLvJElmKuhUWQE7q0UWk7L7rI1a90rURAsMv/+l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Kilroy <andrew.kilroy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Changbin Du <changbin.du@intel.com>,
        Denys Zagorui <dzagorui@cisco.com>,
        Fabian Hemmer <copy@copy.sh>, Felix Fietkau <nbd@nbd.name>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kees Kook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nicholas Fraser <nfraser@codeweavers.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Clarke <pc@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        ShihCheng Tu <mrtoastcheng@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/83] perf parse-events: Add new "metric-id" term
Date:   Mon,  3 Oct 2022 09:11:39 +0200
Message-Id: <20221003070723.848985048@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2b62b3a611715d3ca612e3225cf436277ed9648b ]

Add a new "metric-id" term to events so that metric parsing can set an
ID that can be reliably looked up.

Metric parsing currently will turn a metric like "instructions/cycles"
into a parse events string of "{instructions,cycles}:W".

However, parse-events may change "instructions" into "instructions:u" if
perf_event_paranoid=2.

When this happens expr__resolve_id currently fails as stat-shadow adds
the ID "instructions:u" to match with the counter value and the metric
tries to look up the ID just "instructions".

A later patch will use the new term.

An example of the current problem:

  $ echo -1 > /proc/sys/kernel/perf_event_paranoid
  $ perf stat -M IPC /bin/true
   Performance counter stats for '/bin/true':

           1,217,161      inst_retired.any          #     0.97 IPC
           1,250,389      cpu_clk_unhalted.thread

         0.002064773 seconds time elapsed

         0.002378000 seconds user
         0.000000000 seconds sys

  $ echo 2 > /proc/sys/kernel/perf_event_paranoid
  $ perf stat -M IPC /bin/true
   Performance counter stats for '/bin/true':

             150,298      inst_retired.any:u        #      nan IPC
             187,095      cpu_clk_unhalted.thread:u

         0.002042731 seconds time elapsed

         0.000000000 seconds user
         0.002377000 seconds sys

Note: nan IPC is printed as an effect of "perf metric: Use NAN for
missing event IDs." but earlier versions of perf just fail with a parse
error and display no value.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Antonov <alexander.antonov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Kilroy <andrew.kilroy@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Denys Zagorui <dzagorui@cisco.com>
Cc: Fabian Hemmer <copy@copy.sh>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nicholas Fraser <nfraser@codeweavers.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: ShihCheng Tu <mrtoastcheng@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Wan Jiabing <wanjiabing@vivo.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20211015172132.1162559-15-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c               | 17 +++++
 tools/perf/util/evsel.h               |  2 +
 tools/perf/util/parse-events-hybrid.c | 25 ++++---
 tools/perf/util/parse-events-hybrid.h |  4 +-
 tools/perf/util/parse-events.c        | 95 ++++++++++++++++++---------
 tools/perf/util/parse-events.h        |  5 +-
 tools/perf/util/parse-events.l        |  1 +
 tools/perf/util/pfm.c                 |  3 +-
 8 files changed, 107 insertions(+), 45 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c87f9974c0c1..1e43fac90fc8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -410,6 +410,11 @@ struct evsel *evsel__clone(struct evsel *orig)
 		if (evsel->filter == NULL)
 			goto out_err;
 	}
+	if (orig->metric_id) {
+		evsel->metric_id = strdup(orig->metric_id);
+		if (evsel->metric_id == NULL)
+			goto out_err;
+	}
 	evsel->cgrp = cgroup__get(orig->cgrp);
 	evsel->tp_format = orig->tp_format;
 	evsel->handler = orig->handler;
@@ -779,6 +784,17 @@ const char *evsel__name(struct evsel *evsel)
 	return "unknown";
 }
 
+const char *evsel__metric_id(const struct evsel *evsel)
+{
+	if (evsel->metric_id)
+		return evsel->metric_id;
+
+	if (evsel->core.attr.type == PERF_TYPE_SOFTWARE && evsel->tool_event)
+		return "duration_time";
+
+	return "unknown";
+}
+
 const char *evsel__group_name(struct evsel *evsel)
 {
 	return evsel->group_name ?: "anon group";
@@ -1432,6 +1448,7 @@ void evsel__exit(struct evsel *evsel)
 	zfree(&evsel->group_name);
 	zfree(&evsel->name);
 	zfree(&evsel->pmu_name);
+	zfree(&evsel->metric_id);
 	evsel__zero_per_pkg(evsel);
 	hashmap__free(evsel->per_pkg_mask);
 	evsel->per_pkg_mask = NULL;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 1f7edfa8568a..45476a888942 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -68,6 +68,7 @@ struct evsel {
 		double			scale;
 		const char		*unit;
 		struct cgroup		*cgrp;
+		const char		*metric_id;
 		enum perf_tool_event	tool_event;
 		/* parse modifier helper */
 		int			exclude_GH;
@@ -261,6 +262,7 @@ bool evsel__match_bpf_counter_events(const char *name);
 
 int __evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result, char *bf, size_t size);
 const char *evsel__name(struct evsel *evsel);
+const char *evsel__metric_id(const struct evsel *evsel);
 
 const char *evsel__group_name(struct evsel *evsel);
 int evsel__group_desc(struct evsel *evsel, char *buf, size_t size);
diff --git a/tools/perf/util/parse-events-hybrid.c b/tools/perf/util/parse-events-hybrid.c
index 7e44deee1343..9fc86971027b 100644
--- a/tools/perf/util/parse-events-hybrid.c
+++ b/tools/perf/util/parse-events-hybrid.c
@@ -39,6 +39,7 @@ static void config_hybrid_attr(struct perf_event_attr *attr,
 static int create_event_hybrid(__u32 config_type, int *idx,
 			       struct list_head *list,
 			       struct perf_event_attr *attr, const char *name,
+			       const char *metric_id,
 			       struct list_head *config_terms,
 			       struct perf_pmu *pmu)
 {
@@ -47,7 +48,7 @@ static int create_event_hybrid(__u32 config_type, int *idx,
 	__u64 config = attr->config;
 
 	config_hybrid_attr(attr, config_type, pmu->type);
-	evsel = parse_events__add_event_hybrid(list, idx, attr, name,
+	evsel = parse_events__add_event_hybrid(list, idx, attr, name, metric_id,
 					       pmu, config_terms);
 	if (evsel)
 		evsel->pmu_name = strdup(pmu->name);
@@ -70,7 +71,8 @@ static int pmu_cmp(struct parse_events_state *parse_state,
 
 static int add_hw_hybrid(struct parse_events_state *parse_state,
 			 struct list_head *list, struct perf_event_attr *attr,
-			 const char *name, struct list_head *config_terms)
+			 const char *name, const char *metric_id,
+			 struct list_head *config_terms)
 {
 	struct perf_pmu *pmu;
 	int ret;
@@ -84,7 +86,7 @@ static int add_hw_hybrid(struct parse_events_state *parse_state,
 		copy_config_terms(&terms, config_terms);
 		ret = create_event_hybrid(PERF_TYPE_HARDWARE,
 					  &parse_state->idx, list, attr, name,
-					  &terms, pmu);
+					  metric_id, &terms, pmu);
 		free_config_terms(&terms);
 		if (ret)
 			return ret;
@@ -96,13 +98,14 @@ static int add_hw_hybrid(struct parse_events_state *parse_state,
 static int create_raw_event_hybrid(int *idx, struct list_head *list,
 				   struct perf_event_attr *attr,
 				   const char *name,
+				   const char *metric_id,
 				   struct list_head *config_terms,
 				   struct perf_pmu *pmu)
 {
 	struct evsel *evsel;
 
 	attr->type = pmu->type;
-	evsel = parse_events__add_event_hybrid(list, idx, attr, name,
+	evsel = parse_events__add_event_hybrid(list, idx, attr, name, metric_id,
 					       pmu, config_terms);
 	if (evsel)
 		evsel->pmu_name = strdup(pmu->name);
@@ -114,7 +117,8 @@ static int create_raw_event_hybrid(int *idx, struct list_head *list,
 
 static int add_raw_hybrid(struct parse_events_state *parse_state,
 			  struct list_head *list, struct perf_event_attr *attr,
-			  const char *name, struct list_head *config_terms)
+			  const char *name, const char *metric_id,
+			  struct list_head *config_terms)
 {
 	struct perf_pmu *pmu;
 	int ret;
@@ -127,7 +131,7 @@ static int add_raw_hybrid(struct parse_events_state *parse_state,
 
 		copy_config_terms(&terms, config_terms);
 		ret = create_raw_event_hybrid(&parse_state->idx, list, attr,
-					      name, &terms, pmu);
+					      name, metric_id, &terms, pmu);
 		free_config_terms(&terms);
 		if (ret)
 			return ret;
@@ -139,7 +143,7 @@ static int add_raw_hybrid(struct parse_events_state *parse_state,
 int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 				     struct list_head *list,
 				     struct perf_event_attr *attr,
-				     const char *name,
+				     const char *name, const char *metric_id,
 				     struct list_head *config_terms,
 				     bool *hybrid)
 {
@@ -152,17 +156,18 @@ int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 
 	*hybrid = true;
 	if (attr->type != PERF_TYPE_RAW) {
-		return add_hw_hybrid(parse_state, list, attr, name,
+		return add_hw_hybrid(parse_state, list, attr, name, metric_id,
 				     config_terms);
 	}
 
-	return add_raw_hybrid(parse_state, list, attr, name,
+	return add_raw_hybrid(parse_state, list, attr, name, metric_id,
 			      config_terms);
 }
 
 int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
 				   struct perf_event_attr *attr,
 				   const char *name,
+				   const char *metric_id,
 				   struct list_head *config_terms,
 				   bool *hybrid,
 				   struct parse_events_state *parse_state)
@@ -183,7 +188,7 @@ int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
 
 		copy_config_terms(&terms, config_terms);
 		ret = create_event_hybrid(PERF_TYPE_HW_CACHE, idx, list,
-					  attr, name, &terms, pmu);
+					  attr, name, metric_id, &terms, pmu);
 		free_config_terms(&terms);
 		if (ret)
 			return ret;
diff --git a/tools/perf/util/parse-events-hybrid.h b/tools/perf/util/parse-events-hybrid.h
index 25a4a4f73f3a..cbc05fec02a2 100644
--- a/tools/perf/util/parse-events-hybrid.h
+++ b/tools/perf/util/parse-events-hybrid.h
@@ -11,13 +11,13 @@
 int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 				     struct list_head *list,
 				     struct perf_event_attr *attr,
-				     const char *name,
+				     const char *name, const char *metric_id,
 				     struct list_head *config_terms,
 				     bool *hybrid);
 
 int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
 				   struct perf_event_attr *attr,
-				   const char *name,
+				   const char *name, const char *metric_id,
 				   struct list_head *config_terms,
 				   bool *hybrid,
 				   struct parse_events_state *parse_state);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aaeebf0752b7..e62514577b97 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -342,12 +342,7 @@ const char *event_type(int type)
 	return "unknown";
 }
 
-static int parse_events__is_name_term(struct parse_events_term *term)
-{
-	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
-}
-
-static const char *get_config_name(struct list_head *head_terms)
+static char *get_config_str(struct list_head *head_terms, int type_term)
 {
 	struct parse_events_term *term;
 
@@ -355,17 +350,27 @@ static const char *get_config_name(struct list_head *head_terms)
 		return NULL;
 
 	list_for_each_entry(term, head_terms, list)
-		if (parse_events__is_name_term(term))
+		if (term->type_term == type_term)
 			return term->val.str;
 
 	return NULL;
 }
 
+static char *get_config_metric_id(struct list_head *head_terms)
+{
+	return get_config_str(head_terms, PARSE_EVENTS__TERM_TYPE_METRIC_ID);
+}
+
+static char *get_config_name(struct list_head *head_terms)
+{
+	return get_config_str(head_terms, PARSE_EVENTS__TERM_TYPE_NAME);
+}
+
 static struct evsel *
 __add_event(struct list_head *list, int *idx,
 	    struct perf_event_attr *attr,
 	    bool init_attr,
-	    const char *name, struct perf_pmu *pmu,
+	    const char *name, const char *metric_id, struct perf_pmu *pmu,
 	    struct list_head *config_terms, bool auto_merge_stats,
 	    const char *cpu_list)
 {
@@ -394,6 +399,9 @@ __add_event(struct list_head *list, int *idx,
 	if (name)
 		evsel->name = strdup(name);
 
+	if (metric_id)
+		evsel->metric_id = strdup(metric_id);
+
 	if (config_terms)
 		list_splice_init(config_terms, &evsel->config_terms);
 
@@ -404,18 +412,21 @@ __add_event(struct list_head *list, int *idx,
 }
 
 struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
-				      const char *name, struct perf_pmu *pmu)
+				      const char *name, const char *metric_id,
+				      struct perf_pmu *pmu)
 {
-	return __add_event(NULL, &idx, attr, false, name, pmu, NULL, false,
-			   NULL);
+	return __add_event(/*list=*/NULL, &idx, attr, /*init_attr=*/false, name,
+			   metric_id, pmu, /*config_terms=*/NULL,
+			   /*auto_merge_stats=*/false, /*cpu_list=*/NULL);
 }
 
 static int add_event(struct list_head *list, int *idx,
 		     struct perf_event_attr *attr, const char *name,
-		     struct list_head *config_terms)
+		     const char *metric_id, struct list_head *config_terms)
 {
-	return __add_event(list, idx, attr, true, name, NULL, config_terms,
-			   false, NULL) ? 0 : -ENOMEM;
+	return __add_event(list, idx, attr, /*init_attr*/true, name, metric_id,
+			   /*pmu=*/NULL, config_terms,
+			   /*auto_merge_stats=*/false, /*cpu_list=*/NULL) ? 0 : -ENOMEM;
 }
 
 static int add_event_tool(struct list_head *list, int *idx,
@@ -427,8 +438,10 @@ static int add_event_tool(struct list_head *list, int *idx,
 		.config = PERF_COUNT_SW_DUMMY,
 	};
 
-	evsel = __add_event(list, idx, &attr, true, NULL, NULL, NULL, false,
-			    "0");
+	evsel = __add_event(list, idx, &attr, /*init_attr=*/true, /*name=*/NULL,
+			    /*metric_id=*/NULL, /*pmu=*/NULL,
+			    /*config_terms=*/NULL, /*auto_merge_stats=*/false,
+			    /*cpu_list=*/"0");
 	if (!evsel)
 		return -ENOMEM;
 	evsel->tool_event = tool_event;
@@ -475,7 +488,7 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 	struct perf_event_attr attr;
 	LIST_HEAD(config_terms);
 	char name[MAX_NAME_LEN];
-	const char *config_name;
+	const char *config_name, *metric_id;
 	int cache_type = -1, cache_op = -1, cache_result = -1;
 	char *op_result[2] = { op_result1, op_result2 };
 	int i, n, ret;
@@ -540,13 +553,17 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 			return -ENOMEM;
 	}
 
+	metric_id = get_config_metric_id(head_config);
 	ret = parse_events__add_cache_hybrid(list, idx, &attr,
-					     config_name ? : name, &config_terms,
+					     config_name ? : name,
+					     metric_id,
+					     &config_terms,
 					     &hybrid, parse_state);
 	if (hybrid)
 		goto out_free_terms;
 
-	ret = add_event(list, idx, &attr, config_name ? : name, &config_terms);
+	ret = add_event(list, idx, &attr, config_name ? : name, metric_id,
+			&config_terms);
 out_free_terms:
 	free_config_terms(&config_terms);
 	return ret;
@@ -1023,7 +1040,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.sample_period = 1;
 
-	return add_event(list, idx, &attr, NULL, NULL);
+	return add_event(list, idx, &attr, /*name=*/NULL, /*mertic_id=*/NULL,
+			 /*config_terms=*/NULL);
 }
 
 static int check_type_val(struct parse_events_term *term,
@@ -1068,6 +1086,7 @@ static const char *config_term_names[__PARSE_EVENTS__TERM_TYPE_NR] = {
 	[PARSE_EVENTS__TERM_TYPE_PERCORE]		= "percore",
 	[PARSE_EVENTS__TERM_TYPE_AUX_OUTPUT]		= "aux-output",
 	[PARSE_EVENTS__TERM_TYPE_AUX_SAMPLE_SIZE]	= "aux-sample-size",
+	[PARSE_EVENTS__TERM_TYPE_METRIC_ID]		= "metric-id",
 };
 
 static bool config_term_shrinked;
@@ -1090,6 +1109,7 @@ config_term_avail(int term_type, struct parse_events_error *err)
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
+	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 	case PARSE_EVENTS__TERM_TYPE_PERCORE:
 		return true;
@@ -1180,6 +1200,9 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
 		break;
+	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
+		CHECK_TYPE_VAL(STR);
+		break;
 	case PARSE_EVENTS__TERM_TYPE_MAX_STACK:
 		CHECK_TYPE_VAL(NUM);
 		break;
@@ -1449,6 +1472,7 @@ int parse_events_add_numeric(struct parse_events_state *parse_state,
 {
 	struct perf_event_attr attr;
 	LIST_HEAD(config_terms);
+	const char *name, *metric_id;
 	bool hybrid;
 	int ret;
 
@@ -1465,14 +1489,16 @@ int parse_events_add_numeric(struct parse_events_state *parse_state,
 			return -ENOMEM;
 	}
 
+	name = get_config_name(head_config);
+	metric_id = get_config_metric_id(head_config);
 	ret = parse_events__add_numeric_hybrid(parse_state, list, &attr,
-					       get_config_name(head_config),
+					       name, metric_id,
 					       &config_terms, &hybrid);
 	if (hybrid)
 		goto out_free_terms;
 
-	ret = add_event(list, &parse_state->idx, &attr,
-			get_config_name(head_config), &config_terms);
+	ret = add_event(list, &parse_state->idx, &attr, name, metric_id,
+			&config_terms);
 out_free_terms:
 	free_config_terms(&config_terms);
 	return ret;
@@ -1574,8 +1600,11 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 
 	if (!head_config) {
 		attr.type = pmu->type;
-		evsel = __add_event(list, &parse_state->idx, &attr, true, NULL,
-				    pmu, NULL, auto_merge_stats, NULL);
+		evsel = __add_event(list, &parse_state->idx, &attr,
+				    /*init_attr=*/true, /*name=*/NULL,
+				    /*metric_id=*/NULL, pmu,
+				    /*config_terms=*/NULL, auto_merge_stats,
+				    /*cpu_list=*/NULL);
 		if (evsel) {
 			evsel->pmu_name = name ? strdup(name) : NULL;
 			evsel->use_uncore_alias = use_uncore_alias;
@@ -1628,9 +1657,10 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 		return -EINVAL;
 	}
 
-	evsel = __add_event(list, &parse_state->idx, &attr, true,
-			    get_config_name(head_config), pmu,
-			    &config_terms, auto_merge_stats, NULL);
+	evsel = __add_event(list, &parse_state->idx, &attr, /*init_attr=*/true,
+			    get_config_name(head_config),
+			    get_config_metric_id(head_config), pmu,
+			    &config_terms, auto_merge_stats, /*cpu_list=*/NULL);
 	if (!evsel)
 		return -ENOMEM;
 
@@ -3296,9 +3326,12 @@ char *parse_events_formats_error_string(char *additional_terms)
 
 struct evsel *parse_events__add_event_hybrid(struct list_head *list, int *idx,
 					     struct perf_event_attr *attr,
-					     const char *name, struct perf_pmu *pmu,
+					     const char *name,
+					     const char *metric_id,
+					     struct perf_pmu *pmu,
 					     struct list_head *config_terms)
 {
-	return __add_event(list, idx, attr, true, name, pmu,
-			   config_terms, false, NULL);
+	return __add_event(list, idx, attr, /*init_attr=*/true, name, metric_id,
+			   pmu, config_terms, /*auto_merge_stats=*/false,
+			   /*cpu_list=*/NULL);
 }
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 6ef506c1b29e..9de27b7c9eec 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -87,6 +87,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_PERCORE,
 	PARSE_EVENTS__TERM_TYPE_AUX_OUTPUT,
 	PARSE_EVENTS__TERM_TYPE_AUX_SAMPLE_SIZE,
+	PARSE_EVENTS__TERM_TYPE_METRIC_ID,
 	__PARSE_EVENTS__TERM_TYPE_NR,
 };
 
@@ -200,7 +201,8 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 			 bool use_alias);
 
 struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
-				      const char *name, struct perf_pmu *pmu);
+				      const char *name, const char *metric_id,
+				      struct perf_pmu *pmu);
 
 int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 			       char *str,
@@ -268,6 +270,7 @@ int perf_pmu__test_parse_init(void);
 struct evsel *parse_events__add_event_hybrid(struct list_head *list, int *idx,
 					     struct perf_event_attr *attr,
 					     const char *name,
+					     const char *metric_id,
 					     struct perf_pmu *pmu,
 					     struct list_head *config_terms);
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 923849024b15..b752eb2c620a 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -295,6 +295,7 @@ no-overwrite		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NOOVERWRITE); }
 percore			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_PERCORE); }
 aux-output		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_AUX_OUTPUT); }
 aux-sample-size		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_AUX_SAMPLE_SIZE); }
+metric-id		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_METRIC_ID); }
 r{num_raw_hex}		{ return raw(yyscanner); }
 r0x{num_raw_hex}	{ return raw(yyscanner); }
 ,			{ return ','; }
diff --git a/tools/perf/util/pfm.c b/tools/perf/util/pfm.c
index 756295dedccc..f0bcfcab1a93 100644
--- a/tools/perf/util/pfm.c
+++ b/tools/perf/util/pfm.c
@@ -87,7 +87,8 @@ int parse_libpfm_events_option(const struct option *opt, const char *str,
 
 		pmu = perf_pmu__find_by_type((unsigned int)attr.type);
 		evsel = parse_events__add_event(evlist->core.nr_entries,
-						&attr, q, pmu);
+						&attr, q, /*metric_id=*/NULL,
+						pmu);
 		if (evsel == NULL)
 			goto error;
 
-- 
2.35.1



