Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7575F2A00
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiJCH30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiJCH2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:28:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6046165C3;
        Mon,  3 Oct 2022 00:19:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A4F60FBE;
        Mon,  3 Oct 2022 07:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B08C433D7;
        Mon,  3 Oct 2022 07:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781583;
        bh=+U/7IA84oEAPfzBWLBWXdBsqQrJvwKuxeWtwTf6fQww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BylrFsrxTmzKurXwGj3wad2gfDhZoOgKf/tMn9NcqmxL8pZFa39/ZXllo41/DiODA
         kr/autIwfKiR/lqvdLzNhA4whVP1ScZ6StlAoIqHb6LpaHX+YvzR5i4n4gpTCK1UdN
         MvDs3idO1Qr5fIr3t84vB6XEdJMslauV8XW16Dbk=
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
Subject: [PATCH 5.15 73/83] perf parse-events: Add const to evsel name
Date:   Mon,  3 Oct 2022 09:11:38 +0200
Message-Id: <20221003070723.822004135@linuxfoundation.org>
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

[ Upstream commit 8e8bbfb311a26a17834f1839e15e2c29ea5e58c6 ]

The evsel name is strdup-ed before assignment and so can be const.

A later change will add another similar string.

Using const makes it clearer that these are not out arguments.

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
Link: https://lore.kernel.org/r/20211015172132.1162559-14-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events-hybrid.c | 15 +++++++++------
 tools/perf/util/parse-events-hybrid.h |  6 ++++--
 tools/perf/util/parse-events.c        | 15 ++++++++-------
 tools/perf/util/parse-events.h        |  7 ++++---
 tools/perf/util/pmu.c                 |  2 +-
 tools/perf/util/pmu.h                 |  2 +-
 6 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/parse-events-hybrid.c b/tools/perf/util/parse-events-hybrid.c
index b234d95fb10a..7e44deee1343 100644
--- a/tools/perf/util/parse-events-hybrid.c
+++ b/tools/perf/util/parse-events-hybrid.c
@@ -38,7 +38,7 @@ static void config_hybrid_attr(struct perf_event_attr *attr,
 
 static int create_event_hybrid(__u32 config_type, int *idx,
 			       struct list_head *list,
-			       struct perf_event_attr *attr, char *name,
+			       struct perf_event_attr *attr, const char *name,
 			       struct list_head *config_terms,
 			       struct perf_pmu *pmu)
 {
@@ -70,7 +70,7 @@ static int pmu_cmp(struct parse_events_state *parse_state,
 
 static int add_hw_hybrid(struct parse_events_state *parse_state,
 			 struct list_head *list, struct perf_event_attr *attr,
-			 char *name, struct list_head *config_terms)
+			 const char *name, struct list_head *config_terms)
 {
 	struct perf_pmu *pmu;
 	int ret;
@@ -94,7 +94,8 @@ static int add_hw_hybrid(struct parse_events_state *parse_state,
 }
 
 static int create_raw_event_hybrid(int *idx, struct list_head *list,
-				   struct perf_event_attr *attr, char *name,
+				   struct perf_event_attr *attr,
+				   const char *name,
 				   struct list_head *config_terms,
 				   struct perf_pmu *pmu)
 {
@@ -113,7 +114,7 @@ static int create_raw_event_hybrid(int *idx, struct list_head *list,
 
 static int add_raw_hybrid(struct parse_events_state *parse_state,
 			  struct list_head *list, struct perf_event_attr *attr,
-			  char *name, struct list_head *config_terms)
+			  const char *name, struct list_head *config_terms)
 {
 	struct perf_pmu *pmu;
 	int ret;
@@ -138,7 +139,8 @@ static int add_raw_hybrid(struct parse_events_state *parse_state,
 int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 				     struct list_head *list,
 				     struct perf_event_attr *attr,
-				     char *name, struct list_head *config_terms,
+				     const char *name,
+				     struct list_head *config_terms,
 				     bool *hybrid)
 {
 	*hybrid = false;
@@ -159,7 +161,8 @@ int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 }
 
 int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
-				   struct perf_event_attr *attr, char *name,
+				   struct perf_event_attr *attr,
+				   const char *name,
 				   struct list_head *config_terms,
 				   bool *hybrid,
 				   struct parse_events_state *parse_state)
diff --git a/tools/perf/util/parse-events-hybrid.h b/tools/perf/util/parse-events-hybrid.h
index f33bd67aa851..25a4a4f73f3a 100644
--- a/tools/perf/util/parse-events-hybrid.h
+++ b/tools/perf/util/parse-events-hybrid.h
@@ -11,11 +11,13 @@
 int parse_events__add_numeric_hybrid(struct parse_events_state *parse_state,
 				     struct list_head *list,
 				     struct perf_event_attr *attr,
-				     char *name, struct list_head *config_terms,
+				     const char *name,
+				     struct list_head *config_terms,
 				     bool *hybrid);
 
 int parse_events__add_cache_hybrid(struct list_head *list, int *idx,
-				   struct perf_event_attr *attr, char *name,
+				   struct perf_event_attr *attr,
+				   const char *name,
 				   struct list_head *config_terms,
 				   bool *hybrid,
 				   struct parse_events_state *parse_state);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b93a36ffeb9e..aaeebf0752b7 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -347,7 +347,7 @@ static int parse_events__is_name_term(struct parse_events_term *term)
 	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
 }
 
-static char *get_config_name(struct list_head *head_terms)
+static const char *get_config_name(struct list_head *head_terms)
 {
 	struct parse_events_term *term;
 
@@ -365,7 +365,7 @@ static struct evsel *
 __add_event(struct list_head *list, int *idx,
 	    struct perf_event_attr *attr,
 	    bool init_attr,
-	    char *name, struct perf_pmu *pmu,
+	    const char *name, struct perf_pmu *pmu,
 	    struct list_head *config_terms, bool auto_merge_stats,
 	    const char *cpu_list)
 {
@@ -404,14 +404,14 @@ __add_event(struct list_head *list, int *idx,
 }
 
 struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
-					char *name, struct perf_pmu *pmu)
+				      const char *name, struct perf_pmu *pmu)
 {
 	return __add_event(NULL, &idx, attr, false, name, pmu, NULL, false,
 			   NULL);
 }
 
 static int add_event(struct list_head *list, int *idx,
-		     struct perf_event_attr *attr, char *name,
+		     struct perf_event_attr *attr, const char *name,
 		     struct list_head *config_terms)
 {
 	return __add_event(list, idx, attr, true, name, NULL, config_terms,
@@ -474,7 +474,8 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 {
 	struct perf_event_attr attr;
 	LIST_HEAD(config_terms);
-	char name[MAX_NAME_LEN], *config_name;
+	char name[MAX_NAME_LEN];
+	const char *config_name;
 	int cache_type = -1, cache_op = -1, cache_result = -1;
 	char *op_result[2] = { op_result1, op_result2 };
 	int i, n, ret;
@@ -2038,7 +2039,7 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 	return 0;
 }
 
-int parse_events_name(struct list_head *list, char *name)
+int parse_events_name(struct list_head *list, const char *name)
 {
 	struct evsel *evsel;
 
@@ -3295,7 +3296,7 @@ char *parse_events_formats_error_string(char *additional_terms)
 
 struct evsel *parse_events__add_event_hybrid(struct list_head *list, int *idx,
 					     struct perf_event_attr *attr,
-					     char *name, struct perf_pmu *pmu,
+					     const char *name, struct perf_pmu *pmu,
 					     struct list_head *config_terms)
 {
 	return __add_event(list, idx, attr, true, name, pmu,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index bf6e41aa9b6a..6ef506c1b29e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -162,7 +162,7 @@ void parse_events_terms__purge(struct list_head *terms);
 void parse_events__clear_array(struct parse_events_array *a);
 int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
-int parse_events_name(struct list_head *list, char *name);
+int parse_events_name(struct list_head *list, const char *name);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				const char *sys, const char *event,
 				struct parse_events_error *error,
@@ -200,7 +200,7 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 			 bool use_alias);
 
 struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
-					char *name, struct perf_pmu *pmu);
+				      const char *name, struct perf_pmu *pmu);
 
 int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 			       char *str,
@@ -267,7 +267,8 @@ int perf_pmu__test_parse_init(void);
 
 struct evsel *parse_events__add_event_hybrid(struct list_head *list, int *idx,
 					     struct perf_event_attr *attr,
-					     char *name, struct perf_pmu *pmu,
+					     const char *name,
+					     struct perf_pmu *pmu,
 					     struct list_head *config_terms);
 
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bdabd62170d2..c647b3633d1d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1906,7 +1906,7 @@ int perf_pmu__caps_parse(struct perf_pmu *pmu)
 }
 
 void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
-				   char *name)
+				   const char *name)
 {
 	struct perf_pmu_format *format;
 	__u64 masks = 0, bits;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 394898b07fd9..dd0736de32c8 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -134,7 +134,7 @@ int perf_pmu__convert_scale(const char *scale, char **end, double *sval);
 int perf_pmu__caps_parse(struct perf_pmu *pmu);
 
 void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
-				   char *name);
+				   const char *name);
 
 bool perf_pmu__has_hybrid(void);
 int perf_pmu__match(char *pattern, char *name, char *tok);
-- 
2.35.1



