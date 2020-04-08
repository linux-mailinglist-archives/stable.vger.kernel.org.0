Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E31A219F
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 14:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgDHMUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 08:20:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49648 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgDHMUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 08:20:32 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jM9gt-00062n-Fp; Wed, 08 Apr 2020 14:20:23 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id E2D0F1C04D7;
        Wed,  8 Apr 2020 14:20:22 +0200 (CEST)
Date:   Wed, 08 Apr 2020 12:20:22 -0000
From:   "tip-bot2 for Peter Zijlstra" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/core: Fix event cgroup tracking
Cc:     <stable@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200318193337.GB20760@hirez.programming.kicks-ass.net>
References: <20200318193337.GB20760@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Message-ID: <158634842257.28353.14335300348077819307.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     33238c50451596be86db1505ab65fee5172844d0
Gitweb:        https://git.kernel.org/tip/33238c50451596be86db1505ab65fee5172844d0
Author:        Peter Zijlstra <peterz@infradead.org>
AuthorDate:    Wed, 18 Mar 2020 20:33:37 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 08 Apr 2020 11:33:44 +02:00

perf/core: Fix event cgroup tracking

Song reports that installing cgroup events is broken since:

  db0503e4f675 ("perf/core: Optimize perf_install_in_event()")

The problem being that cgroup events try to track cpuctx->cgrp even
for disabled events, which is pointless and actively harmful since the
above commit. Rework the code to have explicit enable/disable hooks
for cgroup events, such that we can limit cgroup tracking to active
events.

More specifically, since the above commit disabled events are no
longer added to their context from the 'right' CPU, and we can't
access things like the current cgroup for a remote CPU.

Cc: <stable@vger.kernel.org> # v5.5+
Fixes: db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
Reported-by: Song Liu <songliubraving@fb.com>
Tested-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20200318193337.GB20760@hirez.programming.kicks-ass.net
---
 kernel/events/core.c | 70 ++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 55e4441..7afd0b5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -983,16 +983,10 @@ perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
 	event->shadow_ctx_time = now - t->timestamp;
 }
 
-/*
- * Update cpuctx->cgrp so that it is set when first cgroup event is added and
- * cleared when last cgroup event is removed.
- */
 static inline void
-list_update_cgroup_event(struct perf_event *event,
-			 struct perf_event_context *ctx, bool add)
+perf_cgroup_event_enable(struct perf_event *event, struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx;
-	struct list_head *cpuctx_entry;
 
 	if (!is_cgroup_event(event))
 		return;
@@ -1009,28 +1003,41 @@ list_update_cgroup_event(struct perf_event *event,
 	 * because if the first would mismatch, the second would not try again
 	 * and we would leave cpuctx->cgrp unset.
 	 */
-	if (add && !cpuctx->cgrp) {
+	if (ctx->is_active && !cpuctx->cgrp) {
 		struct perf_cgroup *cgrp = perf_cgroup_from_task(current, ctx);
 
 		if (cgroup_is_descendant(cgrp->css.cgroup, event->cgrp->css.cgroup))
 			cpuctx->cgrp = cgrp;
 	}
 
-	if (add && ctx->nr_cgroups++)
+	if (ctx->nr_cgroups++)
 		return;
-	else if (!add && --ctx->nr_cgroups)
+
+	list_add(&cpuctx->cgrp_cpuctx_entry,
+			per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
+}
+
+static inline void
+perf_cgroup_event_disable(struct perf_event *event, struct perf_event_context *ctx)
+{
+	struct perf_cpu_context *cpuctx;
+
+	if (!is_cgroup_event(event))
 		return;
 
-	/* no cgroup running */
-	if (!add)
+	/*
+	 * Because cgroup events are always per-cpu events,
+	 * @ctx == &cpuctx->ctx.
+	 */
+	cpuctx = container_of(ctx, struct perf_cpu_context, ctx);
+
+	if (--ctx->nr_cgroups)
+		return;
+
+	if (ctx->is_active && cpuctx->cgrp)
 		cpuctx->cgrp = NULL;
 
-	cpuctx_entry = &cpuctx->cgrp_cpuctx_entry;
-	if (add)
-		list_add(cpuctx_entry,
-			 per_cpu_ptr(&cgrp_cpuctx_list, event->cpu));
-	else
-		list_del(cpuctx_entry);
+	list_del(&cpuctx->cgrp_cpuctx_entry);
 }
 
 #else /* !CONFIG_CGROUP_PERF */
@@ -1096,11 +1103,14 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
 }
 
 static inline void
-list_update_cgroup_event(struct perf_event *event,
-			 struct perf_event_context *ctx, bool add)
+perf_cgroup_event_enable(struct perf_event *event, struct perf_event_context *ctx)
 {
 }
 
+static inline void
+perf_cgroup_event_disable(struct perf_event *event, struct perf_event_context *ctx)
+{
+}
 #endif
 
 /*
@@ -1791,13 +1801,14 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		add_event_to_groups(event, ctx);
 	}
 
-	list_update_cgroup_event(event, ctx, true);
-
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
 
+	if (event->state > PERF_EVENT_STATE_OFF)
+		perf_cgroup_event_enable(event, ctx);
+
 	ctx->generation++;
 }
 
@@ -1976,8 +1987,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	list_update_cgroup_event(event, ctx, false);
-
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -1994,8 +2003,10 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	 * of error state is by explicit re-enabling
 	 * of the event
 	 */
-	if (event->state > PERF_EVENT_STATE_OFF)
+	if (event->state > PERF_EVENT_STATE_OFF) {
+		perf_cgroup_event_disable(event, ctx);
 		perf_event_set_state(event, PERF_EVENT_STATE_OFF);
+	}
 
 	ctx->generation++;
 }
@@ -2226,6 +2237,7 @@ event_sched_out(struct perf_event *event,
 
 	if (READ_ONCE(event->pending_disable) >= 0) {
 		WRITE_ONCE(event->pending_disable, -1);
+		perf_cgroup_event_disable(event, ctx);
 		state = PERF_EVENT_STATE_OFF;
 	}
 	perf_event_set_state(event, state);
@@ -2363,6 +2375,7 @@ static void __perf_event_disable(struct perf_event *event,
 		event_sched_out(event, cpuctx, ctx);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_OFF);
+	perf_cgroup_event_disable(event, ctx);
 }
 
 /*
@@ -2746,7 +2759,7 @@ static int  __perf_install_in_context(void *info)
 	}
 
 #ifdef CONFIG_CGROUP_PERF
-	if (is_cgroup_event(event)) {
+	if (event->state > PERF_EVENT_STATE_OFF && is_cgroup_event(event)) {
 		/*
 		 * If the current cgroup doesn't match the event's
 		 * cgroup, we should not try to schedule it.
@@ -2906,6 +2919,7 @@ static void __perf_event_enable(struct perf_event *event,
 		ctx_sched_out(ctx, cpuctx, EVENT_TIME);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_INACTIVE);
+	perf_cgroup_event_enable(event, ctx);
 
 	if (!ctx->is_active)
 		return;
@@ -3616,8 +3630,10 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	}
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE) {
-		if (event->attr.pinned)
+		if (event->attr.pinned) {
+			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		}
 
 		*can_add_hw = 0;
 		ctx->rotate_necessary = 1;
