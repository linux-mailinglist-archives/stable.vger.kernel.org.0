Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F145F29A6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJCHXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJCHWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3BD3719B;
        Mon,  3 Oct 2022 00:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4283160FA2;
        Mon,  3 Oct 2022 07:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FEAC433C1;
        Mon,  3 Oct 2022 07:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781305;
        bh=D9GUw/I8M0RpPlgzTGnaHM/QY41l6Py1J4baPAW2qN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yh5OmXW7zijpSvYC9zy6Iee+VRhcQrnNyeVoXiDtgN1QDNLNdkPilawHAnj30GX/E
         6Ctcd3OpchJNggt/vXVDP5+mXIehNh+2WPqADtAqxSx1Z9YjThTzWCA9OoJhcdfSt9
         Odqp6SJ21BG1E7UxPorB5IQwK5TknGOngLXw3SyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Ammy <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 072/101] perf parse-events: Remove "not supported" hybrid cache events
Date:   Mon,  3 Oct 2022 09:11:08 +0200
Message-Id: <20221003070726.258674812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit 71c86cda750b001100e0d6dc04a88449b7381a59 ]

By default, we create two hybrid cache events, one is for cpu_core, and
another is for cpu_atom. But Some hybrid hardware cache events are only
available on one CPU PMU. For example, the 'L1-dcache-load-misses' is only
available on cpu_core, while the 'L1-icache-loads' is only available on
cpu_atom. We need to remove "not supported" hybrid cache events. By
extending is_event_supported() to global API and using it to check if the
hybrid cache events are supported before being created, we can remove the
"not supported" hybrid cache events.

Before:

 # ./perf stat -e L1-dcache-load-misses,L1-icache-loads -a sleep 1

 Performance counter stats for 'system wide':

            52,570      cpu_core/L1-dcache-load-misses/
   <not supported>      cpu_atom/L1-dcache-load-misses/
   <not supported>      cpu_core/L1-icache-loads/
         1,471,817      cpu_atom/L1-icache-loads/

       1.004915229 seconds time elapsed

After:

 # ./perf stat -e L1-dcache-load-misses,L1-icache-loads -a sleep 1

 Performance counter stats for 'system wide':

            54,510      cpu_core/L1-dcache-load-misses/
         1,441,286      cpu_atom/L1-icache-loads/

       1.005114281 seconds time elapsed

Fixes: 30def61f64bac5f5 ("perf parse-events: Create two hybrid cache events")
Reported-by: Yi Ammy <ammy.yi@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220923030013.3726410-2-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events-hybrid.c | 21 ++++++++++++---
 tools/perf/util/parse-events.c        | 39 +++++++++++++++++++++++++++
 tools/perf/util/parse-events.h        |  1 +
 tools/perf/util/print-events.c        | 39 ---------------------------
 4 files changed, 57 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/parse-events-hybrid.c b/tools/perf/util/parse-events-hybrid.c
index 284f8eabd3b9..7c9f9150bad5 100644
--- a/tools/perf/util/parse-events-hybrid.c
+++ b/tools/perf/util/parse-events-hybrid.c
@@ -33,7 +33,8 @@ static void config_hybrid_attr(struct perf_event_attr *attr,
 	 * If the PMU type ID is 0, the PERF_TYPE_RAW will be applied.
 	 */
 	attr->type = type;
-	attr->config = attr->config | ((__u64)pmu_type << PERF_PMU_TYPE_SHIFT);
+	attr->config = (attr->config & PERF_HW_EVENT_MASK) |
+			((__u64)pmu_type << PERF_PMU_TYPE_SHIFT);
 }
 
 static int create_event_hybrid(__u32 config_type, int *idx,
@@ -48,13 +49,25 @@ static int create_event_hybrid(__u32 config_type, int *idx,
 	__u64 config = attr->config;
 
 	config_hybrid_attr(attr, config_type, pmu->type);
+
+	/*
+	 * Some hybrid hardware cache events are only available on one CPU
+	 * PMU. For example, the 'L1-dcache-load-misses' is only available
+	 * on cpu_core, while the 'L1-icache-loads' is only available on
+	 * cpu_atom. We need to remove "not supported" hybrid cache events.
+	 */
+	if (attr->type == PERF_TYPE_HW_CACHE
+	    && !is_event_supported(attr->type, attr->config))
+		return 0;
+
 	evsel = parse_events__add_event_hybrid(list, idx, attr, name, metric_id,
 					       pmu, config_terms);
-	if (evsel)
+	if (evsel) {
 		evsel->pmu_name = strdup(pmu->name);
-	else
+		if (!evsel->pmu_name)
+			return -ENOMEM;
+	} else
 		return -ENOMEM;
-
 	attr->type = type;
 	attr->config = config;
 	return 0;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3acf7452572c..b51c646c212e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -29,6 +29,7 @@
 #include "util/parse-events-hybrid.h"
 #include "util/pmu-hybrid.h"
 #include "tracepoint.h"
+#include "thread_map.h"
 
 #define MAX_NAME_LEN 100
 
@@ -158,6 +159,44 @@ struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
 #define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
+bool is_event_supported(u8 type, u64 config)
+{
+	bool ret = true;
+	int open_return;
+	struct evsel *evsel;
+	struct perf_event_attr attr = {
+		.type = type,
+		.config = config,
+		.disabled = 1,
+	};
+	struct perf_thread_map *tmap = thread_map__new_by_tid(0);
+
+	if (tmap == NULL)
+		return false;
+
+	evsel = evsel__new(&attr);
+	if (evsel) {
+		open_return = evsel__open(evsel, NULL, tmap);
+		ret = open_return >= 0;
+
+		if (open_return == -EACCES) {
+			/*
+			 * This happens if the paranoid value
+			 * /proc/sys/kernel/perf_event_paranoid is set to 2
+			 * Re-run with exclude_kernel set; we don't do that
+			 * by default as some ARM machines do not support it.
+			 *
+			 */
+			evsel->core.attr.exclude_kernel = 1;
+			ret = evsel__open(evsel, NULL, tmap) >= 0;
+		}
+		evsel__delete(evsel);
+	}
+
+	perf_thread_map__put(tmap);
+	return ret;
+}
+
 const char *event_type(int type)
 {
 	switch (type) {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ba9fa3ddaf6e..fd97bb74559e 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -19,6 +19,7 @@ struct option;
 struct perf_pmu;
 
 bool have_tracepoints(struct list_head *evlist);
+bool is_event_supported(u8 type, u64 config);
 
 const char *event_type(int type);
 
diff --git a/tools/perf/util/print-events.c b/tools/perf/util/print-events.c
index 04050d4f6db8..c4d5d87fae2f 100644
--- a/tools/perf/util/print-events.c
+++ b/tools/perf/util/print-events.c
@@ -22,7 +22,6 @@
 #include "probe-file.h"
 #include "string2.h"
 #include "strlist.h"
-#include "thread_map.h"
 #include "tracepoint.h"
 #include "pfm.h"
 #include "pmu-hybrid.h"
@@ -239,44 +238,6 @@ void print_sdt_events(const char *subsys_glob, const char *event_glob,
 	strlist__delete(sdtlist);
 }
 
-static bool is_event_supported(u8 type, u64 config)
-{
-	bool ret = true;
-	int open_return;
-	struct evsel *evsel;
-	struct perf_event_attr attr = {
-		.type = type,
-		.config = config,
-		.disabled = 1,
-	};
-	struct perf_thread_map *tmap = thread_map__new_by_tid(0);
-
-	if (tmap == NULL)
-		return false;
-
-	evsel = evsel__new(&attr);
-	if (evsel) {
-		open_return = evsel__open(evsel, NULL, tmap);
-		ret = open_return >= 0;
-
-		if (open_return == -EACCES) {
-			/*
-			 * This happens if the paranoid value
-			 * /proc/sys/kernel/perf_event_paranoid is set to 2
-			 * Re-run with exclude_kernel set; we don't do that
-			 * by default as some ARM machines do not support it.
-			 *
-			 */
-			evsel->core.attr.exclude_kernel = 1;
-			ret = evsel__open(evsel, NULL, tmap) >= 0;
-		}
-		evsel__delete(evsel);
-	}
-
-	perf_thread_map__put(tmap);
-	return ret;
-}
-
 int print_hwcache_events(const char *event_glob, bool name_only)
 {
 	unsigned int type, op, i, evt_i = 0, evt_num = 0, npmus = 0;
-- 
2.35.1



