Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E75F2A11
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiJCHaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiJCH3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D0A2BDD;
        Mon,  3 Oct 2022 00:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 210BAB80E85;
        Mon,  3 Oct 2022 07:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5849FC433D6;
        Mon,  3 Oct 2022 07:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781577;
        bh=bQOQHFWXu0Y1xHZRrvTz4L2+IME1DPD6dr71obT4YDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmxX4gkJME4pKQ6Szs7ZWMB8JhFs5sjMWuM4uxvVbqabO/tJeanVmAjQ1Kw/iITm3
         j6F3yn0q4XrqjYlhNvuzXC0hycZ3nyjH5Sdaarf6oHdFrNxOmduSHsxesK0+WxmmLb
         +cqxQEQqIpjuQu06qcPFoaHzo0ErDyf+dpfSgA4Y=
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
Subject: [PATCH 5.15 71/83] perf metric: Add documentation and rename a variable.
Date:   Mon,  3 Oct 2022 09:11:36 +0200
Message-Id: <20221003070723.771956822@linuxfoundation.org>
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

[ Upstream commit 68074811dfb9529bb7cade0e67d42c7f7bf209e6 ]

Documentation to make current functionality clearer.

Rename a variable called 'metric' to 'metric_name' as it can be
ambiguous as to whether a string is the name of a metric or the
expression.

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
Link: https://lore.kernel.org/r/20211015172132.1162559-7-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 59 ++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 29b747ac31c1..2dc2a0dcf846 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -772,13 +772,27 @@ int __weak arch_get_runtimeparam(struct pmu_event *pe __maybe_unused)
 
 struct metricgroup_add_iter_data {
 	struct list_head *metric_list;
-	const char *metric;
+	const char *metric_name;
 	struct expr_ids *ids;
 	int *ret;
 	bool *has_match;
 	bool metric_no_group;
 };
 
+/**
+ * __add_metric - Add a metric to metric_list.
+ * @metric_list: The list the metric is added to.
+ * @pe: The pmu_event containing the metric to be added.
+ * @metric_no_group: Should events written to events be grouped "{}" or
+ *                   global. Grouping is the default but due to multiplexing the
+ *                   user may override.
+ * @runtime: A special argument for the parser only known at runtime.
+ * @mp: The pointer to a location holding the first metric added to metric
+ *      list. It is initialized here if this is the first metric.
+ * @parent: The last entry in a linked list of metrics being
+ *          added/resolved. This is maintained to detect recursion.
+ * @ids: Storage for parent list.
+ */
 static int __add_metric(struct list_head *metric_list,
 			struct pmu_event *pe,
 			bool metric_no_group,
@@ -1068,7 +1082,7 @@ static int metricgroup__add_metric_sys_event_iter(struct pmu_event *pe,
 	struct metric *m = NULL;
 	int ret;
 
-	if (!match_pe_metric(pe, d->metric))
+	if (!match_pe_metric(pe, d->metric_name))
 		return 0;
 
 	ret = add_metric(d->metric_list, pe, d->metric_no_group, &m, NULL, d->ids);
@@ -1087,7 +1101,22 @@ static int metricgroup__add_metric_sys_event_iter(struct pmu_event *pe,
 	return ret;
 }
 
-static int metricgroup__add_metric(const char *metric, bool metric_no_group,
+/**
+ * metricgroup__add_metric - Find and add a metric, or a metric group.
+ * @metric_name: The name of the metric or metric group. For example, "IPC"
+ *               could be the name of a metric and "TopDownL1" the name of a
+ *               metric group.
+ * @metric_no_group: Should events written to events be grouped "{}" or
+ *                   global. Grouping is the default but due to multiplexing the
+ *                   user may override.
+ * @events: an out argument string of events that need to be parsed and
+ *          associated with the metric. For example, the metric "IPC" would
+ *          create an events string like "{instructions,cycles}:W".
+ * @metric_list: The list that the metric or metric group are added to.
+ * @map: The map that is searched for metrics, most commonly the table for the
+ *       architecture perf is running upon.
+ */
+static int metricgroup__add_metric(const char *metric_name, bool metric_no_group,
 				   struct strbuf *events,
 				   struct list_head *metric_list,
 				   struct pmu_events_map *map)
@@ -1099,7 +1128,11 @@ static int metricgroup__add_metric(const char *metric, bool metric_no_group,
 	int i, ret;
 	bool has_match = false;
 
-	map_for_each_metric(pe, i, map, metric) {
+	/*
+	 * Iterate over all metrics seeing if metric matches either the name or
+	 * group. When it does add the metric to the list.
+	 */
+	map_for_each_metric(pe, i, map, metric_name) {
 		has_match = true;
 		m = NULL;
 
@@ -1122,7 +1155,7 @@ static int metricgroup__add_metric(const char *metric, bool metric_no_group,
 			.fn = metricgroup__add_metric_sys_event_iter,
 			.data = (void *) &(struct metricgroup_add_iter_data) {
 				.metric_list = &list,
-				.metric = metric,
+				.metric_name = metric_name,
 				.metric_no_group = metric_no_group,
 				.ids = &ids,
 				.has_match = &has_match,
@@ -1161,6 +1194,22 @@ static int metricgroup__add_metric(const char *metric, bool metric_no_group,
 	return ret;
 }
 
+/**
+ * metricgroup__add_metric_list - Find and add metrics, or metric groups,
+ *                                specified in a list.
+ * @list: the list of metrics or metric groups. For example, "IPC,CPI,TopDownL1"
+ *        would match the IPC and CPI metrics, and TopDownL1 would match all
+ *        the metrics in the TopDownL1 group.
+ * @metric_no_group: Should events written to events be grouped "{}" or
+ *                   global. Grouping is the default but due to multiplexing the
+ *                   user may override.
+ * @events: an out argument string of events that need to be parsed and
+ *          associated with the metric. For example, the metric "IPC" would
+ *          create an events string like "{instructions,cycles}:W".
+ * @metric_list: The list that metrics are added to.
+ * @map: The map that is searched for metrics, most commonly the table for the
+ *       architecture perf is running upon.
+ */
 static int metricgroup__add_metric_list(const char *list, bool metric_no_group,
 					struct strbuf *events,
 					struct list_head *metric_list,
-- 
2.35.1



