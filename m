Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B1E5B7095
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiIMO1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiIMO0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B20A67469;
        Tue, 13 Sep 2022 07:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638D7614B2;
        Tue, 13 Sep 2022 14:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB82C433C1;
        Tue, 13 Sep 2022 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078541;
        bh=nwEjTRfM2KzfiJetdsq1wWf1SwWuqHNYI9pB7SCD7IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrB3XjEruWjqz/iQleCepP/2KQGwUPbU20xCr75EwgsRtHAlq6120ybe84tQa7iPw
         TxnqWVtnWJW5XZ9XhDh9Yjypx+2gEJXqEUW76zXXljbf1RIDCUWrfd71f1VkzGobnA
         EgeT5HrhQLTMGPLw7BXogbADxVxVeTxYhPowzREY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 180/192] perf stat: Fix L2 Topdown metrics disappear for raw events
Date:   Tue, 13 Sep 2022 16:04:46 +0200
Message-Id: <20220913140419.016363032@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit f0c86a2bae4fd12bfa8bad4d43fb59fb498cdd14 ]

In perf/Documentation/perf-stat.txt, for "--td-level" the default "0" means
the max level that the current hardware support.

So we need initialize the stat_config.topdown_level to TOPDOWN_MAX_LEVEL
when “--td-level=0” or no “--td-level” option. Otherwise, for the
hardware with a max level is 2, the 2nd level metrics disappear for raw
events in this case.

The issue cannot be observed for the perf stat default or "--topdown"
options. This commit fixes the raw events issue and removes the
duplicated code for the perf stat default.

Before:

 # ./perf stat -e "cpu-clock,context-switches,cpu-migrations,page-faults,instructions,cycles,ref-cycles,branches,branch-misses,{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound,topdown-heavy-ops,topdown-br-mispredict,topdown-fetch-lat,topdown-mem-bound}" sleep 1

 Performance counter stats for 'sleep 1':

              1.03 msec cpu-clock                        #    0.001 CPUs utilized
                 1      context-switches                 #  966.216 /sec
                 0      cpu-migrations                   #    0.000 /sec
                60      page-faults                      #   57.973 K/sec
         1,132,112      instructions                     #    1.41  insn per cycle
           803,872      cycles                           #    0.777 GHz
         1,909,120      ref-cycles                       #    1.845 G/sec
           236,634      branches                         #  228.640 M/sec
             6,367      branch-misses                    #    2.69% of all branches
         4,823,232      slots                            #    4.660 G/sec
         1,210,536      topdown-retiring                 #     25.1% Retiring
           699,841      topdown-bad-spec                 #     14.5% Bad Speculation
         1,777,975      topdown-fe-bound                 #     36.9% Frontend Bound
         1,134,878      topdown-be-bound                 #     23.5% Backend Bound
           189,146      topdown-heavy-ops                #  182.756 M/sec
           662,012      topdown-br-mispredict            #  639.647 M/sec
         1,097,048      topdown-fetch-lat                #    1.060 G/sec
           416,121      topdown-mem-bound                #  402.063 M/sec

       1.002423690 seconds time elapsed

       0.002494000 seconds user
       0.000000000 seconds sys

After:

 # ./perf stat -e "cpu-clock,context-switches,cpu-migrations,page-faults,instructions,cycles,ref-cycles,branches,branch-misses,{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound,topdown-heavy-ops,topdown-br-mispredict,topdown-fetch-lat,topdown-mem-bound}" sleep 1

 Performance counter stats for 'sleep 1':

              1.13 msec cpu-clock                        #    0.001 CPUs utilized
                 1      context-switches                 #  882.128 /sec
                 0      cpu-migrations                   #    0.000 /sec
                61      page-faults                      #   53.810 K/sec
         1,137,612      instructions                     #    1.29  insn per cycle
           881,477      cycles                           #    0.778 GHz
         2,093,496      ref-cycles                       #    1.847 G/sec
           236,356      branches                         #  208.496 M/sec
             7,090      branch-misses                    #    3.00% of all branches
         5,288,862      slots                            #    4.665 G/sec
         1,223,697      topdown-retiring                 #     23.1% Retiring
           767,403      topdown-bad-spec                 #     14.5% Bad Speculation
         2,053,322      topdown-fe-bound                 #     38.8% Frontend Bound
         1,244,438      topdown-be-bound                 #     23.5% Backend Bound
           186,665      topdown-heavy-ops                #      3.5% Heavy Operations       #     19.6% Light Operations
           725,922      topdown-br-mispredict            #     13.7% Branch Mispredict      #      0.8% Machine Clears
         1,327,400      topdown-fetch-lat                #     25.1% Fetch Latency          #     13.7% Fetch Bandwidth
           497,775      topdown-mem-bound                #      9.4% Memory Bound           #     14.1% Core Bound

       1.002701530 seconds time elapsed

       0.002744000 seconds user
       0.000000000 seconds sys

Fixes: 63e39aa6ae103451 ("perf stat: Support L2 Topdown events")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220826140057.3289401-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5aacb7ed8c24a..82e14faecc3e4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1944,6 +1944,9 @@ static int add_default_attributes(void)
 		free(str);
 	}
 
+	if (!stat_config.topdown_level)
+		stat_config.topdown_level = TOPDOWN_MAX_LEVEL;
+
 	if (!evsel_list->core.nr_entries) {
 		if (target__has_cpu(&target))
 			default_attrs0[0].config = PERF_COUNT_SW_CPU_CLOCK;
@@ -1960,8 +1963,6 @@ static int add_default_attributes(void)
 		}
 		if (evlist__add_default_attrs(evsel_list, default_attrs1) < 0)
 			return -1;
-
-		stat_config.topdown_level = TOPDOWN_MAX_LEVEL;
 		/* Platform specific attrs */
 		if (evlist__add_default_attrs(evsel_list, default_null_attrs) < 0)
 			return -1;
-- 
2.35.1



