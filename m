Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44693378499
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhEJKxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhEJKwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:52:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C4561A14;
        Mon, 10 May 2021 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643246;
        bh=4B13p1wN5mmEIDWaCCuSAbdhOYxjBS/wXmAQ6Wmvtqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HI5R/TZgPuMy7ESJ8mcQrBhiCsOKr7IORuhFZZxCU6MIze5famH/cENZpIsZhHyIA
         72AZlrgtcyKKePUTf09Z5tYh8EipFJWTS7OALYaXprOWckWhUoaJEasemCgqLLv/ly
         8kSagEpE2hO1uLJAW2mORSpU/ftf6r2soNjN+iwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/299] perf: Rework perf_event_exit_event()
Date:   Mon, 10 May 2021 12:20:00 +0200
Message-Id: <20210510102011.649894045@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ef54c1a476aef7eef26fe13ea10dc090952c00f8 ]

Make perf_event_exit_event() more robust, such that we can use it from
other contexts. Specifically the up and coming remove_on_exec.

For this to work we need to address a few issues. Remove_on_exec will
not destroy the entire context, so we cannot rely on TASK_TOMBSTONE to
disable event_function_call() and we thus have to use
perf_remove_from_context().

When using perf_remove_from_context(), there's two races to consider.
The first is against close(), where we can have concurrent tear-down
of the event. The second is against child_list iteration, which should
not find a half baked event.

To address this, teach perf_remove_from_context() to special case
!ctx->is_active and about DETACH_CHILD.

[ elver@google.com: fix racing parent/child exit in sync_child_event(). ]
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210408103605.1676875-2-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |   1 +
 kernel/events/core.c       | 142 +++++++++++++++++++++----------------
 2 files changed, 80 insertions(+), 63 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 22ce0604b448..072ac6c1ef2b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -607,6 +607,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_TASK_DATA	0x08
 #define PERF_ATTACH_ITRACE	0x10
 #define PERF_ATTACH_SCHED_CB	0x20
+#define PERF_ATTACH_CHILD	0x40
 
 struct perf_cgroup;
 struct perf_buffer;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8e1b8126c0e4..45fa7167cee2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2209,6 +2209,26 @@ out:
 	perf_event__header_size(leader);
 }
 
+static void sync_child_event(struct perf_event *child_event);
+
+static void perf_child_detach(struct perf_event *event)
+{
+	struct perf_event *parent_event = event->parent;
+
+	if (!(event->attach_state & PERF_ATTACH_CHILD))
+		return;
+
+	event->attach_state &= ~PERF_ATTACH_CHILD;
+
+	if (WARN_ON_ONCE(!parent_event))
+		return;
+
+	lockdep_assert_held(&parent_event->child_mutex);
+
+	sync_child_event(event);
+	list_del_init(&event->child_list);
+}
+
 static bool is_orphaned_event(struct perf_event *event)
 {
 	return event->state == PERF_EVENT_STATE_DEAD;
@@ -2316,6 +2336,7 @@ group_sched_out(struct perf_event *group_event,
 }
 
 #define DETACH_GROUP	0x01UL
+#define DETACH_CHILD	0x02UL
 
 /*
  * Cross CPU call to remove a performance event
@@ -2339,6 +2360,8 @@ __perf_remove_from_context(struct perf_event *event,
 	event_sched_out(event, cpuctx, ctx);
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
+	if (flags & DETACH_CHILD)
+		perf_child_detach(event);
 	list_del_event(event, ctx);
 
 	if (!ctx->nr_events && ctx->is_active) {
@@ -2367,25 +2390,21 @@ static void perf_remove_from_context(struct perf_event *event, unsigned long fla
 
 	lockdep_assert_held(&ctx->mutex);
 
-	event_function_call(event, __perf_remove_from_context, (void *)flags);
-
 	/*
-	 * The above event_function_call() can NO-OP when it hits
-	 * TASK_TOMBSTONE. In that case we must already have been detached
-	 * from the context (by perf_event_exit_event()) but the grouping
-	 * might still be in-tact.
+	 * Because of perf_event_exit_task(), perf_remove_from_context() ought
+	 * to work in the face of TASK_TOMBSTONE, unlike every other
+	 * event_function_call() user.
 	 */
-	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_CONTEXT);
-	if ((flags & DETACH_GROUP) &&
-	    (event->attach_state & PERF_ATTACH_GROUP)) {
-		/*
-		 * Since in that case we cannot possibly be scheduled, simply
-		 * detach now.
-		 */
-		raw_spin_lock_irq(&ctx->lock);
-		perf_group_detach(event);
+	raw_spin_lock_irq(&ctx->lock);
+	if (!ctx->is_active) {
+		__perf_remove_from_context(event, __get_cpu_context(ctx),
+					   ctx, (void *)flags);
 		raw_spin_unlock_irq(&ctx->lock);
+		return;
 	}
+	raw_spin_unlock_irq(&ctx->lock);
+
+	event_function_call(event, __perf_remove_from_context, (void *)flags);
 }
 
 /*
@@ -12249,14 +12268,17 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 }
 EXPORT_SYMBOL_GPL(perf_pmu_migrate_context);
 
-static void sync_child_event(struct perf_event *child_event,
-			       struct task_struct *child)
+static void sync_child_event(struct perf_event *child_event)
 {
 	struct perf_event *parent_event = child_event->parent;
 	u64 child_val;
 
-	if (child_event->attr.inherit_stat)
-		perf_event_read_event(child_event, child);
+	if (child_event->attr.inherit_stat) {
+		struct task_struct *task = child_event->ctx->task;
+
+		if (task && task != TASK_TOMBSTONE)
+			perf_event_read_event(child_event, task);
+	}
 
 	child_val = perf_event_count(child_event);
 
@@ -12271,60 +12293,53 @@ static void sync_child_event(struct perf_event *child_event,
 }
 
 static void
-perf_event_exit_event(struct perf_event *child_event,
-		      struct perf_event_context *child_ctx,
-		      struct task_struct *child)
+perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	struct perf_event *parent_event = child_event->parent;
+	struct perf_event *parent_event = event->parent;
+	unsigned long detach_flags = 0;
 
-	/*
-	 * Do not destroy the 'original' grouping; because of the context
-	 * switch optimization the original events could've ended up in a
-	 * random child task.
-	 *
-	 * If we were to destroy the original group, all group related
-	 * operations would cease to function properly after this random
-	 * child dies.
-	 *
-	 * Do destroy all inherited groups, we don't care about those
-	 * and being thorough is better.
-	 */
-	raw_spin_lock_irq(&child_ctx->lock);
-	WARN_ON_ONCE(child_ctx->is_active);
+	if (parent_event) {
+		/*
+		 * Do not destroy the 'original' grouping; because of the
+		 * context switch optimization the original events could've
+		 * ended up in a random child task.
+		 *
+		 * If we were to destroy the original group, all group related
+		 * operations would cease to function properly after this
+		 * random child dies.
+		 *
+		 * Do destroy all inherited groups, we don't care about those
+		 * and being thorough is better.
+		 */
+		detach_flags = DETACH_GROUP | DETACH_CHILD;
+		mutex_lock(&parent_event->child_mutex);
+	}
 
-	if (parent_event)
-		perf_group_detach(child_event);
-	list_del_event(child_event, child_ctx);
-	perf_event_set_state(child_event, PERF_EVENT_STATE_EXIT); /* is_event_hup() */
-	raw_spin_unlock_irq(&child_ctx->lock);
+	perf_remove_from_context(event, detach_flags);
+
+	raw_spin_lock_irq(&ctx->lock);
+	if (event->state > PERF_EVENT_STATE_EXIT)
+		perf_event_set_state(event, PERF_EVENT_STATE_EXIT);
+	raw_spin_unlock_irq(&ctx->lock);
 
 	/*
-	 * Parent events are governed by their filedesc, retain them.
+	 * Child events can be freed.
 	 */
-	if (!parent_event) {
-		perf_event_wakeup(child_event);
+	if (parent_event) {
+		mutex_unlock(&parent_event->child_mutex);
+		/*
+		 * Kick perf_poll() for is_event_hup();
+		 */
+		perf_event_wakeup(parent_event);
+		free_event(event);
+		put_event(parent_event);
 		return;
 	}
-	/*
-	 * Child events can be cleaned up.
-	 */
-
-	sync_child_event(child_event, child);
 
 	/*
-	 * Remove this event from the parent's list
-	 */
-	WARN_ON_ONCE(parent_event->ctx->parent_ctx);
-	mutex_lock(&parent_event->child_mutex);
-	list_del_init(&child_event->child_list);
-	mutex_unlock(&parent_event->child_mutex);
-
-	/*
-	 * Kick perf_poll() for is_event_hup().
+	 * Parent events are governed by their filedesc, retain them.
 	 */
-	perf_event_wakeup(parent_event);
-	free_event(child_event);
-	put_event(parent_event);
+	perf_event_wakeup(event);
 }
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
@@ -12381,7 +12396,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	perf_event_task(child, child_ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, child_ctx, child);
+		perf_event_exit_event(child_event, child_ctx);
 
 	mutex_unlock(&child_ctx->mutex);
 
@@ -12641,6 +12656,7 @@ inherit_event(struct perf_event *parent_event,
 	 */
 	raw_spin_lock_irqsave(&child_ctx->lock, flags);
 	add_event_to_ctx(child_event, child_ctx);
+	child_event->attach_state |= PERF_ATTACH_CHILD;
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
-- 
2.30.2



