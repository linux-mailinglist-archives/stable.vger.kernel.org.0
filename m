Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D104FC165
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344324AbiDKPuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242472AbiDKPuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CBCAE72
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7654FB8118F
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D95C385A4;
        Mon, 11 Apr 2022 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649692082;
        bh=Hdb9nuvoK/6OcCo3TjwTJGZjlgURdhmNb8ESIZzV8gc=;
        h=Subject:To:Cc:From:Date:From;
        b=PJOAFDPXvnC190uprjVLzXyAPwxQGjDSM8uSSbIA6oE8kU7xwNxVtoXA9+dJe9vC/
         uXWJ054ceopG2fPseFjMNlIONsmkcxkhUL/moQYjeeR847uBwEjghBImxZdq7vw+/u
         L6FuFaIrjCFBT/mrIyaupqHNMCxkquLP8pAL5JpI=
Subject: FAILED: patch "[PATCH] sched/core: Fix forceidle balancing" failed to apply to 5.16-stable tree
To:     peterz@infradead.org, rostedt@goodmis.org, talumbau@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 17:47:59 +0200
Message-ID: <164969207946142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b6547ed97f4f5dfc23f8e3970af6d11d7b7ed7e Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 16 Mar 2022 22:03:41 +0100
Subject: [PATCH] sched/core: Fix forceidle balancing

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

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d575b4914925..017ee7807930 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5752,6 +5752,8 @@ static inline struct task_struct *pick_task(struct rq *rq)
 
 extern void task_vruntime_update(struct rq *rq, struct task_struct *p, bool in_fi);
 
+static void queue_core_balance(struct rq *rq);
+
 static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 {
@@ -5801,7 +5803,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 		}
 
 		rq->core_pick = NULL;
-		return next;
+		goto out;
 	}
 
 	put_prev_task_balance(rq, prev, rf);
@@ -5851,7 +5853,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 			 */
 			WARN_ON_ONCE(fi_before);
 			task_vruntime_update(rq, next, false);
-			goto done;
+			goto out_set_next;
 		}
 	}
 
@@ -5970,8 +5972,12 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
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
 
@@ -6066,7 +6072,7 @@ static void sched_core_balance(struct rq *rq)
 
 static DEFINE_PER_CPU(struct callback_head, core_balance_head);
 
-void queue_core_balance(struct rq *rq)
+static void queue_core_balance(struct rq *rq)
 {
 	if (!sched_core_enabled(rq))
 		return;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 8f8b5020e76a..ecb0d7052877 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -434,7 +434,6 @@ static void set_next_task_idle(struct rq *rq, struct task_struct *next, bool fir
 {
 	update_idle_core(rq);
 	schedstat_inc(rq->sched_goidle);
-	queue_core_balance(rq);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 58263f90c559..8dccb34eb190 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1232,8 +1232,6 @@ static inline bool sched_group_cookie_match(struct rq *rq,
 	return false;
 }
 
-extern void queue_core_balance(struct rq *rq);
-
 static inline bool sched_core_enqueued(struct task_struct *p)
 {
 	return !RB_EMPTY_NODE(&p->core_node);
@@ -1267,10 +1265,6 @@ static inline raw_spinlock_t *__rq_lockp(struct rq *rq)
 	return &rq->__lock;
 }
 
-static inline void queue_core_balance(struct rq *rq)
-{
-}
-
 static inline bool sched_cpu_cookie_match(struct rq *rq, struct task_struct *p)
 {
 	return true;

