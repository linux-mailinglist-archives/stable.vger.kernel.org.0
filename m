Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B6F5B70B2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiIMO1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiIMO0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3488361D80;
        Tue, 13 Sep 2022 07:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DDC614B3;
        Tue, 13 Sep 2022 14:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2C8C433D6;
        Tue, 13 Sep 2022 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078539;
        bh=WGaXiGtqgHgRtcWmM+ueCPynVJnTPIDS2BAH7VQdfcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGwbi2Nq+wOxtRZ/UZARjO6FGagDY6f904KuX9hnGH2xJpiBn3xVxKJr8ILxSTd+z
         QI4RZipzOBTMC54mkmmbnD/fzQhGLqqrgVEuB8sMst43C1A3ZXRNbCmkZtcZ7xsUpk
         pb2p4HFvutCXldPGzADi84Oe9Ae9ZHafKGhuCUmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 179/192] perf evlist: Always use arch_evlist__add_default_attrs()
Date:   Tue, 13 Sep 2022 16:04:45 +0200
Message-Id: <20220913140418.963060947@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit a9c1ecdabc4f2ef04ef5334b8deb3a5c5910136d ]

Current perf stat uses the evlist__add_default_attrs() to add the
generic default attrs, and uses arch_evlist__add_default_attrs() to add
the Arch specific default attrs, e.g., Topdown for x86.

It works well for the non-hybrid platforms. However, for a hybrid
platform, the hard code generic default attrs don't work.

Uses arch_evlist__add_default_attrs() to replace the
evlist__add_default_attrs(). The arch_evlist__add_default_attrs() is
modified to invoke the same __evlist__add_default_attrs() for the
generic default attrs. No functional change.

Add default_null_attrs[] to indicate the arch specific attrs.
No functional change for the arch specific default attrs either.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220721065706.2886112-4-zhengjun.xing@linux.intel.com
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f0c86a2bae4f ("perf stat: Fix L2 Topdown metrics disappear for raw events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evlist.c | 7 ++++++-
 tools/perf/builtin-stat.c         | 6 +++++-
 tools/perf/util/evlist.c          | 9 +++++++--
 tools/perf/util/evlist.h          | 7 +++++--
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/perf/arch/x86/util/evlist.c b/tools/perf/arch/x86/util/evlist.c
index 68f681ad54c1e..777bdf182a582 100644
--- a/tools/perf/arch/x86/util/evlist.c
+++ b/tools/perf/arch/x86/util/evlist.c
@@ -8,8 +8,13 @@
 #define TOPDOWN_L1_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound}"
 #define TOPDOWN_L2_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound,topdown-heavy-ops,topdown-br-mispredict,topdown-fetch-lat,topdown-mem-bound}"
 
-int arch_evlist__add_default_attrs(struct evlist *evlist)
+int arch_evlist__add_default_attrs(struct evlist *evlist,
+				   struct perf_event_attr *attrs,
+				   size_t nr_attrs)
 {
+	if (nr_attrs)
+		return __evlist__add_default_attrs(evlist, attrs, nr_attrs);
+
 	if (!pmu_have_event("cpu", "slots"))
 		return 0;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5f0333a8acd8a..5aacb7ed8c24a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1778,6 +1778,9 @@ static int add_default_attributes(void)
 	(PERF_COUNT_HW_CACHE_OP_PREFETCH	<<  8) |
 	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
 };
+
+	struct perf_event_attr default_null_attrs[] = {};
+
 	/* Set attrs if no event is selected and !null_run: */
 	if (stat_config.null_run)
 		return 0;
@@ -1959,7 +1962,8 @@ static int add_default_attributes(void)
 			return -1;
 
 		stat_config.topdown_level = TOPDOWN_MAX_LEVEL;
-		if (arch_evlist__add_default_attrs(evsel_list) < 0)
+		/* Platform specific attrs */
+		if (evlist__add_default_attrs(evsel_list, default_null_attrs) < 0)
 			return -1;
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 48af7d379d822..efa5f006b5c61 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -342,9 +342,14 @@ int __evlist__add_default_attrs(struct evlist *evlist, struct perf_event_attr *a
 	return evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
-__weak int arch_evlist__add_default_attrs(struct evlist *evlist __maybe_unused)
+__weak int arch_evlist__add_default_attrs(struct evlist *evlist,
+					  struct perf_event_attr *attrs,
+					  size_t nr_attrs)
 {
-	return 0;
+	if (!nr_attrs)
+		return 0;
+
+	return __evlist__add_default_attrs(evlist, attrs, nr_attrs);
 }
 
 struct evsel *evlist__find_tracepoint_by_id(struct evlist *evlist, int id)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1bde9ccf4e7da..129095c0fe6d3 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -107,10 +107,13 @@ static inline int evlist__add_default(struct evlist *evlist)
 int __evlist__add_default_attrs(struct evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
 
+int arch_evlist__add_default_attrs(struct evlist *evlist,
+				   struct perf_event_attr *attrs,
+				   size_t nr_attrs);
+
 #define evlist__add_default_attrs(evlist, array) \
-	__evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
+	arch_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
-int arch_evlist__add_default_attrs(struct evlist *evlist);
 struct evsel *arch_evlist__leader(struct list_head *list);
 
 int evlist__add_dummy(struct evlist *evlist);
-- 
2.35.1



