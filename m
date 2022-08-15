Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA05950E8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiHPEsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiHPEqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF934B249B;
        Mon, 15 Aug 2022 13:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A7DB81197;
        Mon, 15 Aug 2022 20:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03638C433C1;
        Mon, 15 Aug 2022 20:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596207;
        bh=zqRJVTqnhVnCcS8AAZW3JKoLlu8MDd4u9JRcij25GfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbjBukhuAnusNpHiF6Eg9v1CLdK5NzXxRmai34uuFCkjwkKZ6hRA2qaGFnDeXY4i+
         FJq452Dv2z8zkEjGS7gOxCJvkCbCt+5rjTbw6HLToyAyX0WvaWgTKGe5/4kD8RhIvh
         hchm/GlfdzD1rhqD/MplwFaRIMl7aA7+eWaWAnv4=
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
Subject: [PATCH 5.19 1005/1157] perf stat: Revert "perf stat: Add default hybrid events"
Date:   Mon, 15 Aug 2022 20:06:01 +0200
Message-Id: <20220815180520.003520098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit ace3e31e653e79cae9b047e85f567e6b44c98532 ]

This reverts commit Fixes: ac2dc29edd21f9ec ("perf stat: Add default
hybrid events")

Between this patch and the reverted patch, the commit 6c1912898ed21bef
("perf parse-events: Rename parse_events_error functions") and the
commit 07eafd4e053a41d7 ("perf parse-event: Add init and exit to
parse_event_error") clean up the parse_events_error_*() codes. The
related change is also reverted.

The reverted patch is hard to be extended to support new default events,
e.g., Topdown events, and the existing "--detailed" option on a hybrid
platform.

A new solution will be proposed in the following patch to enable the
perf stat default on a hybrid platform.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220721065706.2886112-2-zhengjun.xing@linux.intel.com
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d2ecd4d29624..86f838c5661e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1685,12 +1685,6 @@ static int add_default_attributes(void)
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
   { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
 
-};
-	struct perf_event_attr default_sw_attrs[] = {
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
-  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
 };
 
 /*
@@ -1947,30 +1941,6 @@ static int add_default_attributes(void)
 	}
 
 	if (!evsel_list->core.nr_entries) {
-		if (perf_pmu__has_hybrid()) {
-			struct parse_events_error errinfo;
-			const char *hybrid_str = "cycles,instructions,branches,branch-misses";
-
-			if (target__has_cpu(&target))
-				default_sw_attrs[0].config = PERF_COUNT_SW_CPU_CLOCK;
-
-			if (evlist__add_default_attrs(evsel_list,
-						      default_sw_attrs) < 0) {
-				return -1;
-			}
-
-			parse_events_error__init(&errinfo);
-			err = parse_events(evsel_list, hybrid_str, &errinfo);
-			if (err) {
-				fprintf(stderr,
-					"Cannot set up hybrid events %s: %d\n",
-					hybrid_str, err);
-				parse_events_error__print(&errinfo, hybrid_str);
-			}
-			parse_events_error__exit(&errinfo);
-			return err ? -1 : 0;
-		}
-
 		if (target__has_cpu(&target))
 			default_attrs0[0].config = PERF_COUNT_SW_CPU_CLOCK;
 
-- 
2.35.1



