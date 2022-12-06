Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABF864407A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiLFJwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiLFJvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:51:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851CED79;
        Tue,  6 Dec 2022 01:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201F9615FA;
        Tue,  6 Dec 2022 09:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69C0C43142;
        Tue,  6 Dec 2022 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320224;
        bh=hy3KNMnbe22CQ1fU6zKhmEZCUxAeUJtEnsGnEUh5p2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9SY/R7hOxHC8Y7PNysSXBLMGUrvU4t9/ZITTiGft7QHoBCdVnxNqmOLg2yfNUult
         A8RZbblGsoZNuleQHOrp2RA9P2JVa71r8uaVEGvTQ2QYa4iBWEhNonhYvh8CvqnEJO
         d2VOrWlCAlZS6QTYyXtkGEf6WwPPEhgMqrZQEEhlWY+PPNepWKQ5vj84UIudKxXT1n
         c3VPoZ9/fHGJOzDfli7BDhfSGNZMrOb0gVw0jAWayUcHzxEntyi1e85Pc9MD5x8s5T
         jbCN6Kd0yJybjdlbb+B9vTpGYG6+dFF4zZSTOeDxhvv9ps/QxaV4slKcoFvW3TfLnw
         iKzRXdYSWSI2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        syzbot+9228d6098455bb209ec8@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/12] perf: Fix perf_pending_task() UaF
Date:   Tue,  6 Dec 2022 04:49:53 -0500
Message-Id: <20221206094955.987437-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 517e6a301f34613bff24a8e35b5455884f2d83d8 ]

Per syzbot it is possible for perf_pending_task() to run after the
event is free()'d. There are two related but distinct cases:

 - the task_work was already queued before destroying the event;
 - destroying the event itself queues the task_work.

The first cannot be solved using task_work_cancel() since
perf_release() itself might be called from a task_work (____fput),
which means the current->task_works list is already empty and
task_work_cancel() won't be able to find the perf_pending_task()
entry.

The simplest alternative is extending the perf_event lifetime to cover
the task_work.

The second is just silly, queueing a task_work while you know the
event is going away makes no sense and is easily avoided by
re-arranging how the event is marked STATE_DEAD and ensuring it goes
through STATE_OFF on the way down.

Reported-by: syzbot+9228d6098455bb209ec8@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 60cb300fa0d0..a2bf2d1ea0b9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2367,6 +2367,7 @@ event_sched_out(struct perf_event *event,
 		    !event->pending_work) {
 			event->pending_work = 1;
 			dec = false;
+			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 			task_work_add(current, &event->pending_task, TWA_RESUME);
 		}
 		if (dec)
@@ -2412,6 +2413,7 @@ group_sched_out(struct perf_event *group_event,
 
 #define DETACH_GROUP	0x01UL
 #define DETACH_CHILD	0x02UL
+#define DETACH_DEAD	0x04UL
 
 /*
  * Cross CPU call to remove a performance event
@@ -2432,12 +2434,20 @@ __perf_remove_from_context(struct perf_event *event,
 		update_cgrp_time_from_cpuctx(cpuctx, false);
 	}
 
+	/*
+	 * Ensure event_sched_out() switches to OFF, at the very least
+	 * this avoids raising perf_pending_task() at this time.
+	 */
+	if (flags & DETACH_DEAD)
+		event->pending_disable = 1;
 	event_sched_out(event, cpuctx, ctx);
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
 	if (flags & DETACH_CHILD)
 		perf_child_detach(event);
 	list_del_event(event, ctx);
+	if (flags & DETACH_DEAD)
+		event->state = PERF_EVENT_STATE_DEAD;
 
 	if (!ctx->nr_events && ctx->is_active) {
 		if (ctx == &cpuctx->ctx)
@@ -5212,9 +5222,7 @@ int perf_event_release_kernel(struct perf_event *event)
 
 	ctx = perf_event_ctx_lock(event);
 	WARN_ON_ONCE(ctx->parent_ctx);
-	perf_remove_from_context(event, DETACH_GROUP);
 
-	raw_spin_lock_irq(&ctx->lock);
 	/*
 	 * Mark this event as STATE_DEAD, there is no external reference to it
 	 * anymore.
@@ -5226,8 +5234,7 @@ int perf_event_release_kernel(struct perf_event *event)
 	 * Thus this guarantees that we will in fact observe and kill _ALL_
 	 * child events.
 	 */
-	event->state = PERF_EVENT_STATE_DEAD;
-	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event, DETACH_GROUP|DETACH_DEAD);
 
 	perf_event_ctx_unlock(event, ctx);
 
@@ -6662,6 +6669,8 @@ static void perf_pending_task(struct callback_head *head)
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
+
+	put_event(event);
 }
 
 /*              
-- 
2.35.1

