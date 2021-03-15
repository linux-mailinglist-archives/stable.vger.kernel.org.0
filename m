Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EFE33BA96
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhCOOJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234522AbhCOOEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B85D64DAD;
        Mon, 15 Mar 2021 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817050;
        bh=qnQtDiodf1/hFwBBqCwObIlg53X0wpN0Hr3q0RR52+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjWV1/8wLtMyxbsP37J6/96vGEte55MswkBHO8k9Ntegq57XkpyFVnBrCBjlRDbqk
         UraBQle47i4fXH7S+N439z0Tn6U3c6bsTBvDstlBVB5woId2pca8hxdXll39Qsggdn
         LCc1N8wP2d8iR9bH/S9Bhq9lhFFn/SoU41NvWCkg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 5.11 275/306] sched: Simplify migration_cpu_stop()
Date:   Mon, 15 Mar 2021 14:55:38 +0100
Message-Id: <20210315135516.960898011@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Peter Zijlstra <peterz@infradead.org>

commit c20cf065d4a619d394d23290093b1002e27dff86 upstream.

When affine_move_task() issues a migration_cpu_stop(), the purpose of
that function is to complete that @pending, not any random other
p->migration_pending that might have gotten installed since.

This realization much simplifies migration_cpu_stop() and allows
further necessary steps to fix all this as it provides the guarantee
that @pending's stopper will complete @pending (and not some random
other @pending).

Fixes: 6d337eab041d ("sched: Fix migrate_disable() vs set_cpus_allowed_ptr()")
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224131355.430014682@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   56 +++++++---------------------------------------------
 1 file changed, 8 insertions(+), 48 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1898,8 +1898,8 @@ static struct rq *__migrate_task(struct
  */
 static int migration_cpu_stop(void *data)
 {
-	struct set_affinity_pending *pending;
 	struct migration_arg *arg = data;
+	struct set_affinity_pending *pending = arg->pending;
 	struct task_struct *p = arg->task;
 	int dest_cpu = arg->dest_cpu;
 	struct rq *rq = this_rq();
@@ -1921,25 +1921,6 @@ static int migration_cpu_stop(void *data
 	raw_spin_lock(&p->pi_lock);
 	rq_lock(rq, &rf);
 
-	pending = p->migration_pending;
-	if (pending && !arg->pending) {
-		/*
-		 * This happens from sched_exec() and migrate_task_to(),
-		 * neither of them care about pending and just want a task to
-		 * maybe move about.
-		 *
-		 * Even if there is a pending, we can ignore it, since
-		 * affine_move_task() will have it's own stop_work's in flight
-		 * which will manage the completion.
-		 *
-		 * Notably, pending doesn't need to match arg->pending. This can
-		 * happen when tripple concurrent affine_move_task() first sets
-		 * pending, then clears pending and eventually sets another
-		 * pending.
-		 */
-		pending = NULL;
-	}
-
 	/*
 	 * If task_rq(p) != rq, it cannot be migrated here, because we're
 	 * holding rq->lock, if p->on_rq == 0 it cannot get enqueued because
@@ -1950,31 +1931,20 @@ static int migration_cpu_stop(void *data
 			goto out;
 
 		if (pending) {
-			p->migration_pending = NULL;
+			if (p->migration_pending == pending)
+				p->migration_pending = NULL;
 			complete = true;
 		}
 
-		/* migrate_enable() --  we must not race against SCA */
-		if (dest_cpu < 0) {
-			/*
-			 * When this was migrate_enable() but we no longer
-			 * have a @pending, a concurrent SCA 'fixed' things
-			 * and we should be valid again. Nothing to do.
-			 */
-			if (!pending) {
-				WARN_ON_ONCE(!cpumask_test_cpu(task_cpu(p), &p->cpus_mask));
-				goto out;
-			}
-
+		if (dest_cpu < 0)
 			dest_cpu = cpumask_any_distribute(&p->cpus_mask);
-		}
 
 		if (task_on_rq_queued(p))
 			rq = __migrate_task(rq, &rf, p, dest_cpu);
 		else
 			p->wake_cpu = dest_cpu;
 
-	} else if (dest_cpu < 0 || pending) {
+	} else if (pending) {
 		/*
 		 * This happens when we get migrated between migrate_enable()'s
 		 * preempt_enable() and scheduling the stopper task. At that
@@ -1989,23 +1959,14 @@ static int migration_cpu_stop(void *data
 		 * ->pi_lock, so the allowed mask is stable - if it got
 		 * somewhere allowed, we're done.
 		 */
-		if (pending && cpumask_test_cpu(task_cpu(p), p->cpus_ptr)) {
-			p->migration_pending = NULL;
+		if (cpumask_test_cpu(task_cpu(p), p->cpus_ptr)) {
+			if (p->migration_pending == pending)
+				p->migration_pending = NULL;
 			complete = true;
 			goto out;
 		}
 
 		/*
-		 * When this was migrate_enable() but we no longer have an
-		 * @pending, a concurrent SCA 'fixed' things and we should be
-		 * valid again. Nothing to do.
-		 */
-		if (!pending) {
-			WARN_ON_ONCE(!cpumask_test_cpu(task_cpu(p), &p->cpus_mask));
-			goto out;
-		}
-
-		/*
 		 * When migrate_enable() hits a rq mis-match we can't reliably
 		 * determine is_migration_disabled() and so have to chase after
 		 * it.
@@ -2022,7 +1983,6 @@ out:
 		complete_all(&pending->done);
 
 	/* For pending->{arg,stop_work} */
-	pending = arg->pending;
 	if (pending && refcount_dec_and_test(&pending->refs))
 		wake_up_var(&pending->refs);
 


