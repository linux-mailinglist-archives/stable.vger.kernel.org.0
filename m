Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A421AC49B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409600AbgDPOCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409590AbgDPOCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27B2F2223F;
        Thu, 16 Apr 2020 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045726;
        bh=qDzRr4D2eX3GIJJq1cCaTDMW2ws6b3pi1gGVHdqdP0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cgin6yrLCNWNQosOfrBJ8Cj6q94N0XsDlVWlMMHOVSZS/96t6HiZUUQMRFjhX6Q/O
         7FqZUuc3S5CY5e/Ma9Ziy3vTPqGNMaer9NLpPTaKvD7ASe4PU9H2izi/ZVmF4lxdwI
         uYS4vEmQCsNhtgRLHOCaS2zQEg/yamFjv2KcCn6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 252/254] perf/core: Fix event cgroup tracking
Date:   Thu, 16 Apr 2020 15:25:41 +0200
Message-Id: <20200416131357.094486192@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 33238c50451596be86db1505ab65fee5172844d0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 70 +++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 95860901949e7..b816127367ffc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -935,16 +935,10 @@ perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
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
@@ -961,28 +955,41 @@ list_update_cgroup_event(struct perf_event *event,
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
@@ -1048,11 +1055,14 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
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
@@ -1682,13 +1692,14 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
 
@@ -1864,8 +1875,6 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	list_update_cgroup_event(event, ctx, false);
-
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -1882,8 +1891,10 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -2114,6 +2125,7 @@ event_sched_out(struct perf_event *event,
 
 	if (READ_ONCE(event->pending_disable) >= 0) {
 		WRITE_ONCE(event->pending_disable, -1);
+		perf_cgroup_event_disable(event, ctx);
 		state = PERF_EVENT_STATE_OFF;
 	}
 	perf_event_set_state(event, state);
@@ -2250,6 +2262,7 @@ static void __perf_event_disable(struct perf_event *event,
 		event_sched_out(event, cpuctx, ctx);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_OFF);
+	perf_cgroup_event_disable(event, ctx);
 }
 
 /*
@@ -2633,7 +2646,7 @@ static int  __perf_install_in_context(void *info)
 	}
 
 #ifdef CONFIG_CGROUP_PERF
-	if (is_cgroup_event(event)) {
+	if (event->state > PERF_EVENT_STATE_OFF && is_cgroup_event(event)) {
 		/*
 		 * If the current cgroup doesn't match the event's
 		 * cgroup, we should not try to schedule it.
@@ -2793,6 +2806,7 @@ static void __perf_event_enable(struct perf_event *event,
 		ctx_sched_out(ctx, cpuctx, EVENT_TIME);
 
 	perf_event_set_state(event, PERF_EVENT_STATE_INACTIVE);
+	perf_cgroup_event_enable(event, ctx);
 
 	if (!ctx->is_active)
 		return;
@@ -3447,8 +3461,10 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	}
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE) {
-		if (event->attr.pinned)
+		if (event->attr.pinned) {
+			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
+		}
 
 		sid->can_add_hw = 0;
 		sid->ctx->rotate_necessary = 1;
-- 
2.20.1



