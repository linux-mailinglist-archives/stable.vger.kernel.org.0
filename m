Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD20D3B5FE0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhF1OVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232677AbhF1OVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB4761C7B;
        Mon, 28 Jun 2021 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889919;
        bh=F1dqXNFfwa12acFvwYCztOyALcH2DFJB92oD0WgQ68g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYRV0scbjXz9EmJPdrAlSknEzrvOPLaLI/5dm/kjUFLXIQKZ8oJgOQ/QFMjX0x4WL
         Z76KdNHUolNAJxekp3IqQgvCXNWq37LCneUvuFc2GRwG2kuf7kp8gjsl1GC/ce0D9M
         oPe3Og0izlvDzIWpvh8aRwLmbABWp2j4kCt9Bslpb0iyOka5IpyK8D/mUmkIDUMRCg
         B7ySaATrMDxGZ39F+qjCNCnQXOE4gRI1tRhfKQMj4+sSbpsUvGsuG0iXb5POWl7fYW
         ptNXzUGgReQGmHcsMjgfzuVAbeDpFb4ZKZAVaO73iEiK9mmcP2xKonZdAjewsVgMQF
         AtFbIUUYHqFBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 010/110] psi: Fix psi state corruption when schedule() races with cgroup move
Date:   Mon, 28 Jun 2021 10:16:48 -0400
Message-Id: <20210628141828.31757-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit d583d360a620e6229422b3455d0be082b8255f5e upstream.

4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
introduced a race condition that corrupts internal psi state. This
manifests as kernel warnings, sometimes followed by bogusly high IO
pressure:

  psi: task underflow! cpu=1 t=2 tasks=[0 0 0 0] clear=c set=0
  (schedule() decreasing RUNNING and ONCPU, both of which are 0)

  psi: incosistent task state! task=2412744:systemd cpu=17 psi_flags=e clear=3 set=0
  (cgroup_move_task() clearing MEMSTALL and IOWAIT, but task is MEMSTALL | RUNNING | ONCPU)

What the offending commit does is batch the two psi callbacks in
schedule() to reduce the number of cgroup tree updates. When prev is
deactivated and removed from the runqueue, nothing is done in psi at
first; when the task switch completes, TSK_RUNNING and TSK_IOWAIT are
updated along with TSK_ONCPU.

However, the deactivation and the task switch inside schedule() aren't
atomic: pick_next_task() may drop the rq lock for load balancing. When
this happens, cgroup_move_task() can run after the task has been
physically dequeued, but the psi updates are still pending. Since it
looks at the task's scheduler state, it doesn't move everything to the
new cgroup that the task switch that follows is about to clear from
it. cgroup_move_task() will leak the TSK_RUNNING count in the old
cgroup, and psi_sched_switch() will underflow it in the new cgroup.

A similar thing can happen for iowait. TSK_IOWAIT is usually set when
a p->in_iowait task is dequeued, but again this update is deferred to
the switch. cgroup_move_task() can see an unqueued p->in_iowait task
and move a non-existent TSK_IOWAIT. This results in the inconsistent
task state warning, as well as a counter underflow that will result in
permanent IO ghost pressure being reported.

Fix this bug by making cgroup_move_task() use task->psi_flags instead
of looking at the potentially mismatching scheduler state.

[ We used the scheduler state historically in order to not rely on
  task->psi_flags for anything but debugging. But that ship has sailed
  anyway, and this is simpler and more robust.

  We previously already batched TSK_ONCPU clearing with the
  TSK_RUNNING update inside the deactivation call from schedule(). But
  that ordering was safe and didn't result in TSK_ONCPU corruption:
  unlike most places in the scheduler, cgroup_move_task() only checked
  task_current() and handled TSK_ONCPU if the task was still queued. ]

Fixes: 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210503174917.38579-1-hannes@cmpxchg.org
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/psi.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 651218ded981..ef37acd28e4a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -965,7 +965,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
  */
 void cgroup_move_task(struct task_struct *task, struct css_set *to)
 {
-	unsigned int task_flags = 0;
+	unsigned int task_flags;
 	struct rq_flags rf;
 	struct rq *rq;
 
@@ -980,15 +980,31 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 
 	rq = task_rq_lock(task, &rf);
 
-	if (task_on_rq_queued(task)) {
-		task_flags = TSK_RUNNING;
-		if (task_current(rq, task))
-			task_flags |= TSK_ONCPU;
-	} else if (task->in_iowait)
-		task_flags = TSK_IOWAIT;
-
-	if (task->in_memstall)
-		task_flags |= TSK_MEMSTALL;
+	/*
+	 * We may race with schedule() dropping the rq lock between
+	 * deactivating prev and switching to next. Because the psi
+	 * updates from the deactivation are deferred to the switch
+	 * callback to save cgroup tree updates, the task's scheduling
+	 * state here is not coherent with its psi state:
+	 *
+	 * schedule()                   cgroup_move_task()
+	 *   rq_lock()
+	 *   deactivate_task()
+	 *     p->on_rq = 0
+	 *     psi_dequeue() // defers TSK_RUNNING & TSK_IOWAIT updates
+	 *   pick_next_task()
+	 *     rq_unlock()
+	 *                                rq_lock()
+	 *                                psi_task_change() // old cgroup
+	 *                                task->cgroups = to
+	 *                                psi_task_change() // new cgroup
+	 *                                rq_unlock()
+	 *     rq_lock()
+	 *   psi_sched_switch() // does deferred updates in new cgroup
+	 *
+	 * Don't rely on the scheduling state. Use psi_flags instead.
+	 */
+	task_flags = task->psi_flags;
 
 	if (task_flags)
 		psi_task_change(task, task_flags, 0);
-- 
2.30.2

