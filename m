Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719A86BB349
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjCOMnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjCOMmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015FBA590D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B9DF61CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB6C433EF;
        Wed, 15 Mar 2023 12:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884091;
        bh=5J51evrFgc48Sen+dNOUlWUDE1CCj5Q6jT8nUP6OMKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lq3TXHQzGdSZTYG1RVpERqVqgZwh54SUiCkXHPE23+eSB4SFfzbnTgnDzdT/dDc+
         hlLOE80Wtte+CzMZSxwZqr9GWNHG+2tGtqP1U7SoHpnQepbZGOKO2oiwopTHvhODnM
         TV6XwFHYC/eDjJqVnpN/JH+LttCET858lf7f0YQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Changbin Du <changbin.du@huawei.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hui Wang <hw.huiwang@huawei.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 064/141] perf stat: Fix counting when initial delay configured
Date:   Wed, 15 Mar 2023 13:12:47 +0100
Message-Id: <20230315115741.904564938@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@huawei.com>

[ Upstream commit 25f69c69bc3ca8c781a94473f28d443d745768e3 ]

When creating counters with initial delay configured, the enable_on_exec
field is not set. So we need to enable the counters later. The problem
is, when a workload is specified the target__none() is true. So we also
need to check stat_config.initial_delay.

In this change, we add a new field 'initial_delay' for struct target
which could be shared by other subcommands. And define
target__enable_on_exec() which returns whether enable_on_exec should be
set on normal cases.

Before this fix the event is not counted:

  $ ./perf stat -e instructions -D 100 sleep 2
  Events disabled
  Events enabled

   Performance counter stats for 'sleep 2':

       <not counted>      instructions

         1.901661124 seconds time elapsed

         0.001602000 seconds user
         0.000000000 seconds sys

After fix it works:

  $ ./perf stat -e instructions -D 100 sleep 2
  Events disabled
  Events enabled

   Performance counter stats for 'sleep 2':

             404,214      instructions

         1.901743475 seconds time elapsed

         0.001617000 seconds user
         0.000000000 seconds sys

Fixes: c587e77e100fa40e ("perf stat: Do not delay the workload with --delay")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hui Wang <hw.huiwang@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230302031146.2801588-2-changbin.du@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 15 +++++----------
 tools/perf/util/stat.c    |  6 +-----
 tools/perf/util/stat.h    |  1 -
 tools/perf/util/target.h  | 12 ++++++++++++
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9f3e4b2575165..387dc9c9e7bee 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -539,12 +539,7 @@ static int enable_counters(void)
 			return err;
 	}
 
-	/*
-	 * We need to enable counters only if:
-	 * - we don't have tracee (attaching to task or cpu)
-	 * - we have initial delay configured
-	 */
-	if (!target__none(&target)) {
+	if (!target__enable_on_exec(&target)) {
 		if (!all_counters_use_bpf)
 			evlist__enable(evsel_list);
 	}
@@ -914,7 +909,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			return err;
 	}
 
-	if (stat_config.initial_delay) {
+	if (target.initial_delay) {
 		pr_info(EVLIST_DISABLED_MSG);
 	} else {
 		err = enable_counters();
@@ -926,8 +921,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__start_workload(evsel_list);
 
-	if (stat_config.initial_delay > 0) {
-		usleep(stat_config.initial_delay * USEC_PER_MSEC);
+	if (target.initial_delay > 0) {
+		usleep(target.initial_delay * USEC_PER_MSEC);
 		err = enable_counters();
 		if (err)
 			return -1;
@@ -1248,7 +1243,7 @@ static struct option stat_options[] = {
 		     "aggregate counts per thread", AGGR_THREAD),
 	OPT_SET_UINT(0, "per-node", &stat_config.aggr_mode,
 		     "aggregate counts per numa node", AGGR_NODE),
-	OPT_INTEGER('D', "delay", &stat_config.initial_delay,
+	OPT_INTEGER('D', "delay", &target.initial_delay,
 		    "ms to wait before starting measurement after program start (-1: start with events disabled)"),
 	OPT_CALLBACK_NOOPT(0, "metric-only", &stat_config.metric_only, NULL,
 			"Only print computed metrics. No raw values", enable_metric_only),
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 534d36d26fc38..a07473703c6dd 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -842,11 +842,7 @@ int create_perf_stat_counter(struct evsel *evsel,
 	if (evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
 
-		/*
-		 * In case of initial_delay we enable tracee
-		 * events manually.
-		 */
-		if (target__none(target) && !config->initial_delay)
+		if (target__enable_on_exec(target))
 			attr->enable_on_exec = 1;
 	}
 
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 499c3bf813336..eb8cf33c3ba55 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -166,7 +166,6 @@ struct perf_stat_config {
 	FILE			*output;
 	unsigned int		 interval;
 	unsigned int		 timeout;
-	int			 initial_delay;
 	unsigned int		 unit_width;
 	unsigned int		 metric_only_len;
 	int			 times;
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index daec6cba500d4..880f1af7f6ad6 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -18,6 +18,7 @@ struct target {
 	bool	     per_thread;
 	bool	     use_bpf;
 	bool	     hybrid;
+	int	     initial_delay;
 	const char   *attr_map;
 };
 
@@ -72,6 +73,17 @@ static inline bool target__none(struct target *target)
 	return !target__has_task(target) && !target__has_cpu(target);
 }
 
+static inline bool target__enable_on_exec(struct target *target)
+{
+	/*
+	 * Normally enable_on_exec should be set if:
+	 *  1) The tracee process is forked (not attaching to existed task or cpu).
+	 *  2) And initial_delay is not configured.
+	 * Otherwise, we enable tracee events manually.
+	 */
+	return target__none(target) && !target->initial_delay;
+}
+
 static inline bool target__has_per_thread(struct target *target)
 {
 	return target->system_wide && target->per_thread;
-- 
2.39.2



