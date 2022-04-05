Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E250E4F3221
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiDEI1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbiDEIUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A96F24;
        Tue,  5 Apr 2022 01:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847A560B0E;
        Tue,  5 Apr 2022 08:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6027CC385A1;
        Tue,  5 Apr 2022 08:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146518;
        bh=uL5cgqrCoA+lOLd9fVJ0zymc0rSZyhphf4xwR6dSiaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXz1KiKQoqkHzoC0TgttsXDoySMxTgs4V2p7WJG2NFBi1BI+yulFLbRJzcNR8Oz9G
         R0MJZUi5phPgqhpGsXS+3EvOstrlEJlrTpZBW9o/6xyDn/tsNXib//HFgBAPlu4lf+
         8o8a+ai3a9ihOayxFsLlEcc4vL6pBXSw82Zj+czI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0792/1126] perf parse-events: Move slots only with topdown
Date:   Tue,  5 Apr 2022 09:25:39 +0200
Message-Id: <20220405070430.819563632@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit bc355822f0d9623b632069105d425c822d124cc8 ]

If slots isn't with a topdown event then moving it is unnecessary. For
example {instructions, slots} is re-ordered:

  $ perf stat -e '{instructions,slots}' -a sleep 1

   Performance counter stats for 'system wide':

         936,600,825      slots
         144,440,968      instructions

         1.006061423 seconds time elapsed

Which can break tools expecting the command line order to match the
printed order. It is necessary to move the slots event first when it
appears with topdown events. Add extra checking so that the slots event
is only moved in the case of there being a topdown event like:

  $ perf stat -e '{instructions,slots,topdown-fe-bound}' -a sleep 1

   Performance counter stats for 'system wide':

          2427568570      slots
           300927614      instructions
           551021649      topdown-fe-bound

         1.001771803 seconds time elapsed

Fixes: 94dbfd6781a0e87b ("perf parse-events: Architecture specific leader override")
Reported-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220321223344.1034479-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evlist.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/perf/arch/x86/util/evlist.c b/tools/perf/arch/x86/util/evlist.c
index 8d9b55959256..cfc208d71f00 100644
--- a/tools/perf/arch/x86/util/evlist.c
+++ b/tools/perf/arch/x86/util/evlist.c
@@ -20,17 +20,27 @@ int arch_evlist__add_default_attrs(struct evlist *evlist)
 
 struct evsel *arch_evlist__leader(struct list_head *list)
 {
-	struct evsel *evsel, *first;
+	struct evsel *evsel, *first, *slots = NULL;
+	bool has_topdown = false;
 
 	first = list_first_entry(list, struct evsel, core.node);
 
 	if (!pmu_have_event("cpu", "slots"))
 		return first;
 
+	/* If there is a slots event and a topdown event then the slots event comes first. */
 	__evlist__for_each_entry(list, evsel) {
-		if (evsel->pmu_name && !strcmp(evsel->pmu_name, "cpu") &&
-			evsel->name && strcasestr(evsel->name, "slots"))
-			return evsel;
+		if (evsel->pmu_name && !strcmp(evsel->pmu_name, "cpu") && evsel->name) {
+			if (strcasestr(evsel->name, "slots")) {
+				slots = evsel;
+				if (slots == first)
+					return first;
+			}
+			if (!strncasecmp(evsel->name, "topdown", 7))
+				has_topdown = true;
+			if (slots && has_topdown)
+				return slots;
+		}
 	}
 	return first;
 }
-- 
2.34.1



