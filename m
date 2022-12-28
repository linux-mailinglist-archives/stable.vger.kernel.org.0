Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F99658183
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiL1Q3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiL1Q2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8EA17E05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C75EB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB97C433EF;
        Wed, 28 Dec 2022 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244695;
        bh=y+Tgw53TjPC3I7qincX96GVE3X+m51HLOHYg9KeeNhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxMYufWzXmuhcuMAK/hzvpd7d0GerBRAtACEgCnD8uIwWnwqyG0fM33H8N/OMdLiQ
         j6NyqfGlyxLwkbIsEddmUxiCUrf1qhODKmbG/cb9j4/3yE32ki4ivCy7hUTUoRCjh8
         MT6yh+yE9vG2Z6nYyOQm0c7xelawYSGqxotDaSRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Nomura <nomurak@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0758/1073] perf stat: Do not delay the workload with --delay
Date:   Wed, 28 Dec 2022 15:39:06 +0100
Message-Id: <20221228144348.605440016@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit c587e77e100fa40eb6af10e00497c67acf493f33 ]

The -D/--delay option is to delay the measure after the program starts.
But the current code goes to sleep before starting the program so the
program is delayed too.  This is not the intention, let's fix it.

Before:

  $ time sudo ./perf stat -a -e cycles -D 3000 sleep 4
  Events disabled
  Events enabled

   Performance counter stats for 'system wide':

       4,326,949,337      cycles

         4.007494118 seconds time elapsed

  real	0m7.474s
  user	0m0.356s
  sys	0m0.120s

It ran the workload for 4 seconds and gave the 3 second delay.  So it
should skip the first 3 second and measure the last 1 second only.  But
as you can see, it delays 3 seconds and ran the workload after that for
4 seconds.  So the total time (real) was 7 seconds.

After:

  $ time sudo ./perf stat -a -e cycles -D 3000 sleep 4
  Events disabled
  Events enabled

   Performance counter stats for 'system wide':

       1,063,551,013      cycles

         1.002769510 seconds time elapsed

  real	0m4.484s
  user	0m0.385s
  sys	0m0.086s

The bug was introduced when it changed enablement of system-wide events
with a command line workload.  But it should've considered the initial
delay case.  The code was reworked since then (in bb8bc52e7578) so I'm
afraid it won't be applied cleanly.

Fixes: d0a0a511493d2695 ("perf stat: Fix forked applications enablement of counters")
Reported-by: Kevin Nomura <nomurak@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Link: https://lore.kernel.org/r/20221212230820.901382-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0b4a62e4ff67..cab6b70e95e2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -573,26 +573,14 @@ static int enable_counters(void)
 			return err;
 	}
 
-	if (stat_config.initial_delay < 0) {
-		pr_info(EVLIST_DISABLED_MSG);
-		return 0;
-	}
-
-	if (stat_config.initial_delay > 0) {
-		pr_info(EVLIST_DISABLED_MSG);
-		usleep(stat_config.initial_delay * USEC_PER_MSEC);
-	}
-
 	/*
 	 * We need to enable counters only if:
 	 * - we don't have tracee (attaching to task or cpu)
 	 * - we have initial delay configured
 	 */
-	if (!target__none(&target) || stat_config.initial_delay) {
+	if (!target__none(&target)) {
 		if (!all_counters_use_bpf)
 			evlist__enable(evsel_list);
-		if (stat_config.initial_delay > 0)
-			pr_info(EVLIST_ENABLED_MSG);
 	}
 	return 0;
 }
@@ -967,14 +955,27 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			return err;
 	}
 
-	err = enable_counters();
-	if (err)
-		return -1;
+	if (stat_config.initial_delay) {
+		pr_info(EVLIST_DISABLED_MSG);
+	} else {
+		err = enable_counters();
+		if (err)
+			return -1;
+	}
 
 	/* Exec the command, if any */
 	if (forks)
 		evlist__start_workload(evsel_list);
 
+	if (stat_config.initial_delay > 0) {
+		usleep(stat_config.initial_delay * USEC_PER_MSEC);
+		err = enable_counters();
+		if (err)
+			return -1;
+
+		pr_info(EVLIST_ENABLED_MSG);
+	}
+
 	t0 = rdclock();
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
-- 
2.35.1



