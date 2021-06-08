Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1B13A0047
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhFHSl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235391AbhFHSj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F13E6142D;
        Tue,  8 Jun 2021 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177269;
        bh=W8PC+5cy/PBfmPbNY6yr9Y0XcPs97LVB5bTj8otjupU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf7P3Yyc1k1eFtuSB+ZZn8MF7JouBHr3NloJ43avI/lnSplzDjvQjIW0Sipx81EGB
         2nXWRCOWQ0MII5v8EqwZpsTf7MvLMYPoMQpJCC+75S9GNLXGJr06y6mLHRQ5xYASLw
         cfBg38+MOFcEo4hKcu7Wn71hbbgUmBLnFqjl9i40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
Subject: [PATCH 4.19 50/58] perf/cgroups: Dont rotate events for cgroups unnecessarily
Date:   Tue,  8 Jun 2021 20:27:31 +0200
Message-Id: <20210608175933.924635262@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit fd7d55172d1e2e501e6da0a5c1de25f06612dc2e upstream.

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
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/perf_event.h |    5 +++++
 kernel/events/core.c       |   42 ++++++++++++++++++++++--------------------
 2 files changed, 27 insertions(+), 20 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -747,6 +747,11 @@ struct perf_event_context {
 	int				nr_stat;
 	int				nr_freq;
 	int				rotate_disable;
+	/*
+	 * Set when nr_events != nr_active, except tolerant to events not
+	 * necessary to be active due to scheduling constraints, such as cgroups.
+	 */
+	int				rotate_necessary;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2952,6 +2952,12 @@ static void ctx_sched_out(struct perf_ev
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
@@ -3319,10 +3325,13 @@ static int flexible_sched_in(struct perf
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
@@ -3690,24 +3699,17 @@ ctx_first_active(struct perf_event_conte
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
@@ -3716,7 +3718,7 @@ static bool perf_rotate_context(struct p
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
 	if (task_rotate)
-		task_event = ctx_first_active(ctx);
+		task_event = ctx_first_active(task_ctx);
 	if (cpu_rotate)
 		cpu_event = ctx_first_active(&cpuctx->ctx);
 
@@ -3724,17 +3726,17 @@ static bool perf_rotate_context(struct p
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


