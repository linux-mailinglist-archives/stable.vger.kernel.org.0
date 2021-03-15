Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC15033BA87
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCOOJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233634AbhCOOEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1C964F26;
        Mon, 15 Mar 2021 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817044;
        bh=w3kA6KVD8oO3i6qdq7ots3lG0U0fsVTt5Oda33Ydt6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbEW+RtJJ007iEIWCWT9FrL+nadGONNVS0zUITw1Jqr0mAGzAZ/1nd97yxMzS9Rvo
         brYGa5IMttsrKpybnzKvWU76Rv0BybJX9Cs2camF3KDxkT/vPShYktI5caX4ZYw9Nn
         mXCdlSmDyPktSsyIdhjkMLMWloD/5Re+jaaBY0Zc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 5.11 272/306] sched: Fix migration_cpu_stop() requeueing
Date:   Mon, 15 Mar 2021 14:55:35 +0100
Message-Id: <20210315135516.857766425@linuxfoundation.org>
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

commit 8a6edb5257e2a84720fe78cb179eca58ba76126f upstream.

When affine_move_task(p) is called on a running task @p, which is not
otherwise already changing affinity, we'll first set
p->migration_pending and then do:

	 stop_one_cpu(cpu_of_rq(rq), migration_cpu_stop, &arg);

This then gets us to migration_cpu_stop() running on the CPU that was
previously running our victim task @p.

If we find that our task is no longer on that runqueue (this can
happen because of a concurrent migration due to load-balance etc.),
then we'll end up at the:

	} else if (dest_cpu < 1 || pending) {

branch. Which we'll take because we set pending earlier. Here we first
check if the task @p has already satisfied the affinity constraints,
if so we bail early [A]. Otherwise we'll reissue migration_cpu_stop()
onto the CPU that is now hosting our task @p:

	stop_one_cpu_nowait(cpu_of(rq), migration_cpu_stop,
			    &pending->arg, &pending->stop_work);

Except, we've never initialized pending->arg, which will be all 0s.

This then results in running migration_cpu_stop() on the next CPU with
arg->p == NULL, which gives the by now obvious result of fireworks.

The cure is to change affine_move_task() to always use pending->arg,
furthermore we can use the exact same pattern as the
SCA_MIGRATE_ENABLE case, since we'll block on the pending->done
completion anyway, no point in adding yet another completion in
stop_one_cpu().

This then gives a clear distinction between the two
migration_cpu_stop() use cases:

  - sched_exec() / migrate_task_to() : arg->pending == NULL
  - affine_move_task() : arg->pending != NULL;

And we can have it ignore p->migration_pending when !arg->pending. Any
stop work from sched_exec() / migrate_task_to() is in addition to stop
works from affine_move_task(), which will be sufficient to issue the
completion.

Fixes: 6d337eab041d ("sched: Fix migrate_disable() vs set_cpus_allowed_ptr()")
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224131355.357743989@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1922,6 +1922,24 @@ static int migration_cpu_stop(void *data
 	rq_lock(rq, &rf);
 
 	pending = p->migration_pending;
+	if (pending && !arg->pending) {
+		/*
+		 * This happens from sched_exec() and migrate_task_to(),
+		 * neither of them care about pending and just want a task to
+		 * maybe move about.
+		 *
+		 * Even if there is a pending, we can ignore it, since
+		 * affine_move_task() will have it's own stop_work's in flight
+		 * which will manage the completion.
+		 *
+		 * Notably, pending doesn't need to match arg->pending. This can
+		 * happen when tripple concurrent affine_move_task() first sets
+		 * pending, then clears pending and eventually sets another
+		 * pending.
+		 */
+		pending = NULL;
+	}
+
 	/*
 	 * If task_rq(p) != rq, it cannot be migrated here, because we're
 	 * holding rq->lock, if p->on_rq == 0 it cannot get enqueued because
@@ -2194,10 +2212,6 @@ static int affine_move_task(struct rq *r
 			    int dest_cpu, unsigned int flags)
 {
 	struct set_affinity_pending my_pending = { }, *pending = NULL;
-	struct migration_arg arg = {
-		.task = p,
-		.dest_cpu = dest_cpu,
-	};
 	bool complete = false;
 
 	/* Can the task run on the task's current CPU? If so, we're done */
@@ -2235,6 +2249,12 @@ static int affine_move_task(struct rq *r
 			/* Install the request */
 			refcount_set(&my_pending.refs, 1);
 			init_completion(&my_pending.done);
+			my_pending.arg = (struct migration_arg) {
+				.task = p,
+				.dest_cpu = -1,		/* any */
+				.pending = &my_pending,
+			};
+
 			p->migration_pending = &my_pending;
 		} else {
 			pending = p->migration_pending;
@@ -2265,12 +2285,6 @@ static int affine_move_task(struct rq *r
 		p->migration_flags &= ~MDF_PUSH;
 		task_rq_unlock(rq, p, rf);
 
-		pending->arg = (struct migration_arg) {
-			.task = p,
-			.dest_cpu = -1,
-			.pending = pending,
-		};
-
 		stop_one_cpu_nowait(cpu_of(rq), migration_cpu_stop,
 				    &pending->arg, &pending->stop_work);
 
@@ -2283,8 +2297,11 @@ static int affine_move_task(struct rq *r
 		 * is_migration_disabled(p) checks to the stopper, which will
 		 * run on the same CPU as said p.
 		 */
+		refcount_inc(&pending->refs); /* pending->{arg,stop_work} */
 		task_rq_unlock(rq, p, rf);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+
+		stop_one_cpu_nowait(cpu_of(rq), migration_cpu_stop,
+				    &pending->arg, &pending->stop_work);
 
 	} else {
 


