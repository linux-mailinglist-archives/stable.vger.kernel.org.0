Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDFE6AEA86
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjCGReh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjCGReW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0FAA17DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C01A614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79530C433D2;
        Tue,  7 Mar 2023 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210208;
        bh=71wvhIOlgngeLbSnX47fS0nbU1QTrb0yd6vU7r9qBsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xe8aIlnR39UsMGp3tG+8+WrJdr18UdV3X2q8w1O7MAFjH02IxpLwTtY92mvTHp01v
         FLix5ja1h3dLIX+n4H1fVwb9FpvaZVaEuLrjHbl2vbm4vSgH69YJ+/WGroLn8067vg
         AR6NKo9kLU5PS/HiOG2aQaLqNz4IeM85zExgXpYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0468/1001] perf stat: Hide invalid uncore event output for aggr mode
Date:   Tue,  7 Mar 2023 17:54:00 +0100
Message-Id: <20230307170041.706783470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dd15480a3d67b9cf04a1f6f5d60f1c0dc018e22f ]

The current display code for perf stat iterates given cpus and build the
aggr map to collect the event data for the aggregation mode.

But uncore events have their own cpu maps and it won't guarantee that
it'd match to the aggr map.  For example, per-package uncore events
would generate a single value for each socket.  When user asks per-core
aggregation mode, the output would contain 0 values for other cores.

Thus it needs to check the uncore PMU's cpumask and if it matches to the
current aggregation id.

Before:
  $ sudo ./perf stat -a --per-core -e power/energy-pkg/ sleep 1

   Performance counter stats for 'system wide':

  S0-D0-C0              1               3.73 Joules power/energy-pkg/
  S0-D0-C1              0      <not counted> Joules power/energy-pkg/
  S0-D0-C2              0      <not counted> Joules power/energy-pkg/
  S0-D0-C3              0      <not counted> Joules power/energy-pkg/

         1.001404046 seconds time elapsed

  Some events weren't counted. Try disabling the NMI watchdog:
  	echo 0 > /proc/sys/kernel/nmi_watchdog
  	perf stat ...
  	echo 1 > /proc/sys/kernel/nmi_watchdog

The core 1, 2 and 3 should not be printed because the event is handled
in a cpu in the core 0 only.  With this change, the output becomes like
below.

After:
  $ sudo ./perf stat -a --per-core -e power/energy-pkg/ sleep 1

   Performance counter stats for 'system wide':

  S0-D0-C0              1               2.09 Joules power/energy-pkg/

Fixes: b897613510890d6e ("perf stat: Update event skip condition for system-wide per-thread mode and merged uncore and hybrid events")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Ian Rogers <irogers@google.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230125192431.2929677-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 51 ++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 8bd8b0142630c..1b5cb20efd237 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -787,6 +787,51 @@ static void uniquify_counter(struct perf_stat_config *config, struct evsel *coun
 		uniquify_event_name(counter);
 }
 
+/**
+ * should_skip_zero_count() - Check if the event should print 0 values.
+ * @config: The perf stat configuration (including aggregation mode).
+ * @counter: The evsel with its associated cpumap.
+ * @id: The aggregation id that is being queried.
+ *
+ * Due to mismatch between the event cpumap or thread-map and the
+ * aggregation mode, sometimes it'd iterate the counter with the map
+ * which does not contain any values.
+ *
+ * For example, uncore events have dedicated CPUs to manage them,
+ * result for other CPUs should be zero and skipped.
+ *
+ * Return: %true if the value should NOT be printed, %false if the value
+ * needs to be printed like "<not counted>" or "<not supported>".
+ */
+static bool should_skip_zero_counter(struct perf_stat_config *config,
+				     struct evsel *counter,
+				     const struct aggr_cpu_id *id)
+{
+	struct perf_cpu cpu;
+	int idx;
+
+	/*
+	 * Skip value 0 when enabling --per-thread globally,
+	 * otherwise it will have too many 0 output.
+	 */
+	if (config->aggr_mode == AGGR_THREAD && config->system_wide)
+		return true;
+	/*
+	 * Skip value 0 when it's an uncore event and the given aggr id
+	 * does not belong to the PMU cpumask.
+	 */
+	if (!counter->pmu || !counter->pmu->is_uncore)
+		return false;
+
+	perf_cpu_map__for_each_cpu(cpu, idx, counter->pmu->cpus) {
+		struct aggr_cpu_id own_id = config->aggr_get_id(config, cpu);
+
+		if (aggr_cpu_id__equal(id, &own_id))
+			return false;
+	}
+	return true;
+}
+
 static void print_counter_aggrdata(struct perf_stat_config *config,
 				   struct evsel *counter, int s,
 				   struct outstate *os)
@@ -814,11 +859,7 @@ static void print_counter_aggrdata(struct perf_stat_config *config,
 	ena = aggr->counts.ena;
 	run = aggr->counts.run;
 
-	/*
-	 * Skip value 0 when enabling --per-thread globally, otherwise it will
-	 * have too many 0 output.
-	 */
-	if (val == 0 && config->aggr_mode == AGGR_THREAD && config->system_wide)
+	if (val == 0 && should_skip_zero_counter(config, counter, &id))
 		return;
 
 	if (!metric_only) {
-- 
2.39.2



