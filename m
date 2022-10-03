Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF605F2A1A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiJCHa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiJCH3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41345193C4;
        Mon,  3 Oct 2022 00:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1826DB80E84;
        Mon,  3 Oct 2022 07:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7389FC433C1;
        Mon,  3 Oct 2022 07:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781601;
        bh=nbytP3D9KgG1Kq4uClmgzAzxcf7Tw7GRv1kkZmibIR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAOrygCb3L0U+SFIR1dSR/MX5D8NQvGPA/YUQreUMemDwVXLMClLKrqdGiQklK+9n
         5xWQQ93P+TfEvgefL5DRlovIOLX8W4v5XoYvkKb1bN3wxUloxgHajSu3XT8W/aesva
         y6L0gQxm9fTVRXnybKSLdvCEnA8qmmkIakIsf0c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florian Fischer <florian.fischer@muhq.space>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 79/83] perf list: Print all available tool events
Date:   Mon,  3 Oct 2022 09:11:44 +0200
Message-Id: <20221003070723.978824952@linuxfoundation.org>
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

From: Florian Fischer <florian.fischer@muhq.space>

[ Upstream commit 75eafc970bd9d36d906960a81376549f5dc99696 ]

Introduce names for the new tool events 'user_time' and 'system_time'.

  $ perf list
  ...
  duration_time                                      [Tool event]
  user_time                                          [Tool event]
  system_time                                        [Tool event]
  ...

Committer testing:

Before:

  $ perf list | grep Tool
  duration_time                                      [Tool event]
  $

After:

  $ perf list | grep Tool
    duration_time                                    [Tool event]
    user_time                                        [Tool event]
    system_time                                      [Tool event]
  $

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: http://lore.kernel.org/lkml/20220420174244.1741958-2-florian.fischer@muhq.space
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c        | 19 ++++++++++------
 tools/perf/util/evsel.h        |  1 +
 tools/perf/util/parse-events.c | 40 +++++++++++++++++++++++++++++-----
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1e43fac90fc8..dbb27b61e0de 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -600,6 +600,17 @@ static int evsel__sw_name(struct evsel *evsel, char *bf, size_t size)
 	return r + evsel__add_modifiers(evsel, bf + r, size - r);
 }
 
+const char *evsel__tool_names[PERF_TOOL_MAX] = {
+	"duration_time",
+	"user_time",
+	"system_time",
+};
+
+static int evsel__tool_name(enum perf_tool_event ev, char *bf, size_t size)
+{
+	return scnprintf(bf, size, "%s", evsel__tool_names[ev]);
+}
+
 static int __evsel__bp_name(char *bf, size_t size, u64 addr, u64 type)
 {
 	int r;
@@ -726,12 +737,6 @@ static int evsel__raw_name(struct evsel *evsel, char *bf, size_t size)
 	return ret + evsel__add_modifiers(evsel, bf + ret, size - ret);
 }
 
-static int evsel__tool_name(char *bf, size_t size)
-{
-	int ret = scnprintf(bf, size, "duration_time");
-	return ret;
-}
-
 const char *evsel__name(struct evsel *evsel)
 {
 	char bf[128];
@@ -757,7 +762,7 @@ const char *evsel__name(struct evsel *evsel)
 
 	case PERF_TYPE_SOFTWARE:
 		if (evsel->tool_event)
-			evsel__tool_name(bf, sizeof(bf));
+			evsel__tool_name(evsel->tool_event, bf, sizeof(bf));
 		else
 			evsel__sw_name(evsel, bf, sizeof(bf));
 		break;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 45476a888942..cd3e38ed3dfa 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -257,6 +257,7 @@ extern const char *evsel__hw_cache_op[PERF_COUNT_HW_CACHE_OP_MAX][EVSEL__MAX_ALI
 extern const char *evsel__hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX][EVSEL__MAX_ALIASES];
 extern const char *evsel__hw_names[PERF_COUNT_HW_MAX];
 extern const char *evsel__sw_names[PERF_COUNT_SW_MAX];
+extern const char *evsel__tool_names[PERF_TOOL_MAX];
 extern char *evsel__bpf_counter_events;
 bool evsel__match_bpf_counter_events(const char *name);
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 533c4b216ae2..e6b51810e85c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -156,6 +156,21 @@ struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
 	},
 };
 
+struct event_symbol event_symbols_tool[PERF_TOOL_MAX] = {
+	[PERF_TOOL_DURATION_TIME] = {
+		.symbol = "duration_time",
+		.alias  = "",
+	},
+	[PERF_TOOL_USER_TIME] = {
+		.symbol = "user_time",
+		.alias  = "",
+	},
+	[PERF_TOOL_SYSTEM_TIME] = {
+		.symbol = "system_time",
+		.alias  = "",
+	},
+};
+
 #define __PERF_EVENT_FIELD(config, name) \
 	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
 
@@ -2934,21 +2949,34 @@ int print_hwcache_events(const char *event_glob, bool name_only)
 	return evt_num;
 }
 
-static void print_tool_event(const char *name, const char *event_glob,
+static void print_tool_event(const struct event_symbol *syms, const char *event_glob,
 			     bool name_only)
 {
-	if (event_glob && !strglobmatch(name, event_glob))
+	if (syms->symbol == NULL)
+		return;
+
+	if (event_glob && !(strglobmatch(syms->symbol, event_glob) ||
+	      (syms->alias && strglobmatch(syms->alias, event_glob))))
 		return;
+
 	if (name_only)
-		printf("%s ", name);
-	else
+		printf("%s ", syms->symbol);
+	else {
+		char name[MAX_NAME_LEN];
+		if (syms->alias && strlen(syms->alias))
+			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
+		else
+			strlcpy(name, syms->symbol, MAX_NAME_LEN);
 		printf("  %-50s [%s]\n", name, "Tool event");
-
+	}
 }
 
 void print_tool_events(const char *event_glob, bool name_only)
 {
-	print_tool_event("duration_time", event_glob, name_only);
+	// Start at 1 because the first enum entry symbols no tool event
+	for (int i = 1; i < PERF_TOOL_MAX; ++i) {
+		print_tool_event(event_symbols_tool + i, event_glob, name_only);
+	}
 	if (pager_in_use())
 		printf("\n");
 }
-- 
2.35.1



