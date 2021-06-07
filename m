Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8715239D6A7
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 10:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFGID2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 04:03:28 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41006 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhFGID1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 04:03:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0UbXBgMv_1623052893;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UbXBgMv_1623052893)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 16:01:33 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 5.2 1/2] perf/cgroups: Don't rotate events for cgroups unnecessarily
Date:   Mon,  7 Jun 2021 16:01:30 +0800
Message-Id: <20210607080131.9043-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit fd7d55172d1e2e501e6da0a5c1de25f06612dc2e ]

Currently perf_rotate_context assumes that if the context's nr_events !=
nr_active a rotation is necessary for perf event multiplexing. With
cgroups, nr_events is the total count of events for all cgroups and
nr_active will not include events in a cgroup other than the current
task's. This makes rotation appear necessary for cgroups when it is not.

Add a perf_event_context flag that is set when rotation is necessary.
Clear the flag during sched_out and set it when a flexible sched_in
fails due to resources.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lkml.kernel.org/r/20190601082722.44543-1-irogers@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 42 ++++++++++++++++++++++--------------------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a9d3fbb..f19ac49 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -749,6 +749,11 @@ struct perf_event_context {
 	int				nr_stat;
 	int				nr_freq;
 	int				rotate_disable;
+	/*
+	 * Set when nr_events != nr_active, except tolerant to events not
+	 * necessary to be active due to scheduling constraints, such as cgroups.
+	 */
+	int				rotate_necessary;
 	refcount_t			refcount;
 	struct task_struct		*task;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4bc15cf..190772d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2957,6 +2957,12 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	if (!ctx->nr_active || !(is_active & EVENT_ALL))
 		return;
 
+	/*
+	 * If we had been multiplexing, no rotations are necessary, now no events
+	 * are active.
+	 */
+	ctx->rotate_necessary = 0;
+
 	perf_pmu_disable(ctx->pmu);
 	if (is_active & EVENT_PINNED) {
 		list_for_each_entry_safe(event, tmp, &ctx->pinned_active, active_list)
@@ -3324,10 +3330,13 @@ static int flexible_sched_in(struct perf_event *event, void *data)
 		return 0;
 
 	if (group_can_go_on(event, sid->cpuctx, sid->can_add_hw)) {
-		if (!group_sched_in(event, sid->cpuctx, sid->ctx))
-			list_add_tail(&event->active_list, &sid->ctx->flexible_active);
-		else
+		int ret = group_sched_in(event, sid->cpuctx, sid->ctx);
+		if (ret) {
 			sid->can_add_hw = 0;
+			sid->ctx->rotate_necessary = 1;
+			return 0;
+		}
+		list_add_tail(&event->active_list, &sid->ctx->flexible_active);
 	}
 
 	return 0;
@@ -3695,24 +3704,17 @@ static void rotate_ctx(struct perf_event_context *ctx, struct perf_event *event)
 static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *cpu_event = NULL, *task_event = NULL;
-	bool cpu_rotate = false, task_rotate = false;
-	struct perf_event_context *ctx = NULL;
+	struct perf_event_context *task_ctx = NULL;
+	int cpu_rotate, task_rotate;
 
 	/*
 	 * Since we run this from IRQ context, nobody can install new
 	 * events, thus the event count values are stable.
 	 */
 
-	if (cpuctx->ctx.nr_events) {
-		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
-			cpu_rotate = true;
-	}
-
-	ctx = cpuctx->task_ctx;
-	if (ctx && ctx->nr_events) {
-		if (ctx->nr_events != ctx->nr_active)
-			task_rotate = true;
-	}
+	cpu_rotate = cpuctx->ctx.rotate_necessary;
+	task_ctx = cpuctx->task_ctx;
+	task_rotate = task_ctx ? task_ctx->rotate_necessary : 0;
 
 	if (!(cpu_rotate || task_rotate))
 		return false;
@@ -3721,7 +3723,7 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	if (task_rotate)
-		task_event = ctx_first_active(ctx);
+		task_event = ctx_first_active(task_ctx);
 	if (cpu_rotate)
 		cpu_event = ctx_first_active(&cpuctx->ctx);
 
@@ -3729,17 +3731,17 @@ static bool perf_rotate_context(struct perf_cpu_context *cpuctx)
 	 * As per the order given at ctx_resched() first 'pop' task flexible
 	 * and then, if needed CPU flexible.
 	 */
-	if (task_event || (ctx && cpu_event))
-		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+	if (task_event || (task_ctx && cpu_event))
+		ctx_sched_out(task_ctx, cpuctx, EVENT_FLEXIBLE);
 	if (cpu_event)
 		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
 	if (task_event)
-		rotate_ctx(ctx, task_event);
+		rotate_ctx(task_ctx, task_event);
 	if (cpu_event)
 		rotate_ctx(&cpuctx->ctx, cpu_event);
 
-	perf_event_sched_in(cpuctx, ctx, current);
+	perf_event_sched_in(cpuctx, task_ctx, current);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-- 
1.8.3.1

