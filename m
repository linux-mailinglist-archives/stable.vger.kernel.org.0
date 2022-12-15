Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2964E066
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLOSNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiLOSMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:12:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ADB396D0
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C359B81C34
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818F9C433EF;
        Thu, 15 Dec 2022 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127960;
        bh=OZfafIR5BzYTte8Ris8LN9kDDkt2u8dTy6WY8pG5geM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIqrAtR8PBxPmmIu7zbRH7/q7Ps4sZ/hPy5FXq2Ju8x/K1lyHshiaVSeHL+FjSJtB
         KWrtoD/Eb7iguXsRxsFlSB9HER7vV4BUpdUkEQJX+PlTNJbprVRl2TChIN5Y2H7+KT
         LAWkf+gUiSAP1Nj0ZJsxaJAUZ5IzQliQcwfDh+jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9228d6098455bb209ec8@syzkaller.appspotmail.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/14] perf: Fix perf_pending_task() UaF
Date:   Thu, 15 Dec 2022 19:10:49 +0100
Message-Id: <20221215172907.302003042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
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
index 44f982b73640..5422bd77c7d4 100644
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



