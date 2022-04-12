Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23FD4FDA99
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377623AbiDLHuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359391AbiDLHnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFF92B271;
        Tue, 12 Apr 2022 00:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8EA6171C;
        Tue, 12 Apr 2022 07:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E97C385A5;
        Tue, 12 Apr 2022 07:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748130;
        bh=FQfC2Om4wIcb1HIRf/yVr+QDGuzzRTC58mtKVCt3alY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=li28B2RER282A8uLPRhqldziNBu1ivqnOdfc2X+iKYCScGJtERpAQSvnGqTYUjPY1
         VAUri0759QCa7CF1lYYyJHmd6Y8tX4lqb8tmS0HABaHCWBA24Ja6iFx+RqASkDqFJo
         BeKbJS7QqeVmOkDPxdKZSOCXYDaqfkINfey8FD5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "T.J. Alumbaugh" <talumbau@chromium.org>
Subject: [PATCH 5.17 331/343] sched/core: Fix forceidle balancing
Date:   Tue, 12 Apr 2022 08:32:29 +0200
Message-Id: <20220412063000.871956573@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 5b6547ed97f4f5dfc23f8e3970af6d11d7b7ed7e upstream.

Steve reported that ChromeOS encounters the forceidle balancer being
ran from rt_mutex_setprio()'s balance_callback() invocation and
explodes.

Now, the forceidle balancer gets queued every time the idle task gets
selected, set_next_task(), which is strictly too often.
rt_mutex_setprio() also uses set_next_task() in the 'change' pattern:

	queued = task_on_rq_queued(p); /* p->on_rq == TASK_ON_RQ_QUEUED */
	running = task_current(rq, p); /* rq->curr == p */

	if (queued)
		dequeue_task(...);
	if (running)
		put_prev_task(...);

	/* change task properties */

	if (queued)
		enqueue_task(...);
	if (running)
		set_next_task(...);

However, rt_mutex_setprio() will explicitly not run this pattern on
the idle task (since priority boosting the idle task is quite insane).
Most other 'change' pattern users are pidhash based and would also not
apply to idle.

Also, the change pattern doesn't contain a __balance_callback()
invocation and hence we could have an out-of-band balance-callback,
which *should* trigger the WARN in rq_pin_lock() (which guards against
this exact anti-pattern).

So while none of that explains how this happens, it does indicate that
having it in set_next_task() might not be the most robust option.

Instead, explicitly queue the forceidle balancer from pick_next_task()
when it does indeed result in forceidle selection. Having it here,
ensures it can only be triggered under the __schedule() rq->lock
instance, and hence must be ran from that context.

This also happens to clean up the code a little, so win-win.

Fixes: d2dfa17bc7de ("sched: Trivial forced-newidle balancer")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: T.J. Alumbaugh <talumbau@chromium.org>
Link: https://lkml.kernel.org/r/20220330160535.GN8939@worktop.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |   14 ++++++++++----
 kernel/sched/idle.c  |    1 -
 kernel/sched/sched.h |    6 ------
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5675,6 +5675,8 @@ static inline struct task_struct *pick_t
 
 extern void task_vruntime_update(struct rq *rq, struct task_struct *p, bool in_fi);
 
+static void queue_core_balance(struct rq *rq);
+
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 {
@@ -5724,7 +5726,7 @@ pick_next_task(struct rq *rq, struct tas
 		}
 
 		rq->core_pick = NULL;
-		return next;
+		goto out;
 	}
 
 	put_prev_task_balance(rq, prev, rf);
@@ -5774,7 +5776,7 @@ pick_next_task(struct rq *rq, struct tas
 			 */
 			WARN_ON_ONCE(fi_before);
 			task_vruntime_update(rq, next, false);
-			goto done;
+			goto out_set_next;
 		}
 	}
 
@@ -5893,8 +5895,12 @@ pick_next_task(struct rq *rq, struct tas
 		resched_curr(rq_i);
 	}
 
-done:
+out_set_next:
 	set_next_task(rq, next);
+out:
+	if (rq->core->core_forceidle_count && next == rq->idle)
+		queue_core_balance(rq);
+
 	return next;
 }
 
@@ -5989,7 +5995,7 @@ static void sched_core_balance(struct rq
 
 static DEFINE_PER_CPU(struct callback_head, core_balance_head);
 
-void queue_core_balance(struct rq *rq)
+static void queue_core_balance(struct rq *rq)
 {
 	if (!sched_core_enabled(rq))
 		return;
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -437,7 +437,6 @@ static void set_next_task_idle(struct rq
 {
 	update_idle_core(rq);
 	schedstat_inc(rq->sched_goidle);
-	queue_core_balance(rq);
 }
 
 #ifdef CONFIG_SMP
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1247,8 +1247,6 @@ static inline bool sched_group_cookie_ma
 	return false;
 }
 
-extern void queue_core_balance(struct rq *rq);
-
 static inline bool sched_core_enqueued(struct task_struct *p)
 {
 	return !RB_EMPTY_NODE(&p->core_node);
@@ -1282,10 +1280,6 @@ static inline raw_spinlock_t *__rq_lockp
 	return &rq->__lock;
 }
 
-static inline void queue_core_balance(struct rq *rq)
-{
-}
-
 static inline bool sched_cpu_cookie_match(struct rq *rq, struct task_struct *p)
 {
 	return true;


