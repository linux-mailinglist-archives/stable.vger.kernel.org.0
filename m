Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513A55F2A66
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiJCHgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiJCHen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AEC52E77;
        Mon,  3 Oct 2022 00:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367CE60F63;
        Mon,  3 Oct 2022 07:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24026C433D6;
        Mon,  3 Oct 2022 07:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781612;
        bh=13C3QloQDPqqF6W9Qir9Cbi40y10lnN/vsoL0fBFNHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nq4LpLs0hc/A2R+TqHmXDwutsft9g+fBWA9S7VExpZMYCKZDB0DYJAPq0bzwOmPgr
         legHdBTfcHRi0B7k9gM0kYy5HSxEUBlA35qkS25pOHKAKHt4mbzrCy5K4KoZOi6Pyz
         ShoWDuN/u8AK/8OGwhrUCiVUH4jjLvhl0lDbNcrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
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
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 83/83] perf evsel: Add tool event helpers
Date:   Mon,  3 Oct 2022 09:11:48 +0200
Message-Id: <20221003070724.087426771@linuxfoundation.org>
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

commit 79932d161fda7f2d18761ace5f25445f7b525741 upstream.

Convert to and from a string. Fix evsel__tool_name() as array is
off-by-1.  Support more than just duration_time as a metric-id.

Fixes: 75eafc970bd9d36d ("perf list: Print all available tool events")
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
Link: https://lore.kernel.org/r/20220507053410.3798748-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/evsel.c |   41 +++++++++++++++++++++++++++++++----------
 tools/perf/util/evsel.h |   11 +++++++++++
 2 files changed, 42 insertions(+), 10 deletions(-)

--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -59,6 +59,33 @@ struct perf_missing_features perf_missin
 
 static clockid_t clockid;
 
+static const char *const perf_tool_event__tool_names[PERF_TOOL_MAX] = {
+	NULL,
+	"duration_time",
+	"user_time",
+	"system_time",
+};
+
+const char *perf_tool_event__to_str(enum perf_tool_event ev)
+{
+	if (ev > PERF_TOOL_NONE && ev < PERF_TOOL_MAX)
+		return perf_tool_event__tool_names[ev];
+
+	return NULL;
+}
+
+enum perf_tool_event perf_tool_event__from_str(const char *str)
+{
+	int i;
+
+	perf_tool_event__for_each_event(i) {
+		if (!strcmp(str, perf_tool_event__tool_names[i]))
+			return i;
+	}
+	return PERF_TOOL_NONE;
+}
+
+
 static int evsel__no_extra_init(struct evsel *evsel __maybe_unused)
 {
 	return 0;
@@ -600,15 +627,9 @@ static int evsel__sw_name(struct evsel *
 	return r + evsel__add_modifiers(evsel, bf + r, size - r);
 }
 
-const char *evsel__tool_names[PERF_TOOL_MAX] = {
-	"duration_time",
-	"user_time",
-	"system_time",
-};
-
 static int evsel__tool_name(enum perf_tool_event ev, char *bf, size_t size)
 {
-	return scnprintf(bf, size, "%s", evsel__tool_names[ev]);
+	return scnprintf(bf, size, "%s", perf_tool_event__to_str(ev));
 }
 
 static int __evsel__bp_name(char *bf, size_t size, u64 addr, u64 type)
@@ -761,7 +782,7 @@ const char *evsel__name(struct evsel *ev
 		break;
 
 	case PERF_TYPE_SOFTWARE:
-		if (evsel->tool_event)
+		if (evsel__is_tool(evsel))
 			evsel__tool_name(evsel->tool_event, bf, sizeof(bf));
 		else
 			evsel__sw_name(evsel, bf, sizeof(bf));
@@ -794,8 +815,8 @@ const char *evsel__metric_id(const struc
 	if (evsel->metric_id)
 		return evsel->metric_id;
 
-	if (evsel->core.attr.type == PERF_TYPE_SOFTWARE && evsel->tool_event)
-		return "duration_time";
+	if (evsel__is_tool(evsel))
+		return perf_tool_event__to_str(evsel->tool_event);
 
 	return "unknown";
 }
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -30,6 +30,12 @@ enum perf_tool_event {
 	PERF_TOOL_DURATION_TIME = 1,
 };
 
+const char *perf_tool_event__to_str(enum perf_tool_event ev);
+enum perf_tool_event perf_tool_event__from_str(const char *str);
+
+#define perf_tool_event__for_each_event(ev)		\
+	for ((ev) = PERF_TOOL_DURATION_TIME; (ev) < PERF_TOOL_MAX; ev++)
+
 /** struct evsel - event selector
  *
  * @evlist - evlist this evsel is in, if it is in one.
@@ -265,6 +271,11 @@ int __evsel__hw_cache_type_op_res_name(u
 const char *evsel__name(struct evsel *evsel);
 const char *evsel__metric_id(const struct evsel *evsel);
 
+static inline bool evsel__is_tool(const struct evsel *evsel)
+{
+	return evsel->tool_event != PERF_TOOL_NONE;
+}
+
 const char *evsel__group_name(struct evsel *evsel);
 int evsel__group_desc(struct evsel *evsel, char *buf, size_t size);
 


