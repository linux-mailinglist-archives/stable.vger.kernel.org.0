Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D432F7B9A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbhAONDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732772AbhAOMbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720CB2333E;
        Fri, 15 Jan 2021 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713887;
        bh=NXvOHF/PIpjKf4CiCK9hnK2M3FqkzZAvfFjDuMlSOo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C28SEzMVUAT6Kb+XWLqQmBNpO6afdl1i0Mh6lm2OCgl6VDbYwqlS8bRuZww/NjdxB
         s2e4j5sT6oSvGvZnkDaYekS/lgfsSBxpdrWcFYU01k+Ipb7wvzuyjzCJVuYq557nvt
         zV/Rl/WqF/KA7Z/oehFbD49KwTyBn5fuOOVrv0AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 06/28] x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR
Date:   Fri, 15 Jan 2021 13:27:43 +0100
Message-Id: <20210115121957.055546083@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

commit ae28d1aae48a1258bd09a6f707ebb4231d79a761 upstream

Currently, when moving a task to a resource group the PQR_ASSOC MSR is
updated with the new closid and rmid in an added task callback. If the
task is running, the work is run as soon as possible. If the task is not
running, the work is executed later in the kernel exit path when the
kernel returns to the task again.

Updating the PQR_ASSOC MSR as soon as possible on the CPU a moved task
is running is the right thing to do. Queueing work for a task that is
not running is unnecessary (the PQR_ASSOC MSR is already updated when
the task is scheduled in) and causing system resource waste with the way
in which it is implemented: Work to update the PQR_ASSOC register is
queued every time the user writes a task id to the "tasks" file, even if
the task already belongs to the resource group.

This could result in multiple pending work items associated with a
single task even if they are all identical and even though only a single
update with most recent values is needed. Specifically, even if a task
is moved between different resource groups while it is sleeping then it
is only the last move that is relevant but yet a work item is queued
during each move.

This unnecessary queueing of work items could result in significant
system resource waste, especially on tasks sleeping for a long time.
For example, as demonstrated by Shakeel Butt in [1] writing the same
task id to the "tasks" file can quickly consume significant memory. The
same problem (wasted system resources) occurs when moving a task between
different resource groups.

As pointed out by Valentin Schneider in [2] there is an additional issue
with the way in which the queueing of work is done in that the task_struct
update is currently done after the work is queued, resulting in a race with
the register update possibly done before the data needed by the update is
available.

To solve these issues, update the PQR_ASSOC MSR in a synchronous way
right after the new closid and rmid are ready during the task movement,
only if the task is running. If a moved task is not running nothing
is done since the PQR_ASSOC MSR will be updated next time the task is
scheduled. This is the same way used to update the register when tasks
are moved as part of resource group removal.

[1] https://lore.kernel.org/lkml/CALvZod7E9zzHwenzf7objzGKsdBmVwTgEJ0nPgs0LUFU3SN5Pw@mail.gmail.com/
[2] https://lore.kernel.org/lkml/20201123022433.17905-1-valentin.schneider@arm.com

 [ bp: Massage commit message and drop the two update_task_closid_rmid()
   variants. ]

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
for older stable trees.

Since upstream commit 352940ececaca ("x86/resctrl: Rename the RDT
functions and definitions"), resctrl functions received more generic
names. Specifically related to this backport, intel_rdt_sched_in()
was renamed to rescrl_sched_in().

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |  105 ++++++++++++-------------------
 1 file changed, 42 insertions(+), 63 deletions(-)

--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -411,82 +411,61 @@ static void rdtgroup_remove(struct rdtgr
 	kfree(rdtgrp);
 }
 
-struct task_move_callback {
-	struct callback_head	work;
-	struct rdtgroup		*rdtgrp;
-};
-
-static void move_myself(struct callback_head *head)
+static void _update_task_closid_rmid(void *task)
 {
-	struct task_move_callback *callback;
-	struct rdtgroup *rdtgrp;
-
-	callback = container_of(head, struct task_move_callback, work);
-	rdtgrp = callback->rdtgrp;
-
 	/*
-	 * If resource group was deleted before this task work callback
-	 * was invoked, then assign the task to root group and free the
-	 * resource group.
+	 * If the task is still current on this CPU, update PQR_ASSOC MSR.
+	 * Otherwise, the MSR is updated when the task is scheduled in.
 	 */
-	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
-	    (rdtgrp->flags & RDT_DELETED)) {
-		current->closid = 0;
-		current->rmid = 0;
-		rdtgroup_remove(rdtgrp);
-	}
-
-	preempt_disable();
-	/* update PQR_ASSOC MSR to make resource group go into effect */
-	intel_rdt_sched_in();
-	preempt_enable();
+	if (task == current)
+		intel_rdt_sched_in();
+}
 
-	kfree(callback);
+static void update_task_closid_rmid(struct task_struct *t)
+{
+	if (IS_ENABLED(CONFIG_SMP) && task_curr(t))
+		smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);
+	else
+		_update_task_closid_rmid(t);
 }
 
 static int __rdtgroup_move_task(struct task_struct *tsk,
 				struct rdtgroup *rdtgrp)
 {
-	struct task_move_callback *callback;
-	int ret;
-
-	callback = kzalloc(sizeof(*callback), GFP_KERNEL);
-	if (!callback)
-		return -ENOMEM;
-	callback->work.func = move_myself;
-	callback->rdtgrp = rdtgrp;
-
 	/*
-	 * Take a refcount, so rdtgrp cannot be freed before the
-	 * callback has been invoked.
+	 * Set the task's closid/rmid before the PQR_ASSOC MSR can be
+	 * updated by them.
+	 *
+	 * For ctrl_mon groups, move both closid and rmid.
+	 * For monitor groups, can move the tasks only from
+	 * their parent CTRL group.
 	 */
-	atomic_inc(&rdtgrp->waitcount);
-	ret = task_work_add(tsk, &callback->work, true);
-	if (ret) {
-		/*
-		 * Task is exiting. Drop the refcount and free the callback.
-		 * No need to check the refcount as the group cannot be
-		 * deleted before the write function unlocks rdtgroup_mutex.
-		 */
-		atomic_dec(&rdtgrp->waitcount);
-		kfree(callback);
-	} else {
-		/*
-		 * For ctrl_mon groups move both closid and rmid.
-		 * For monitor groups, can move the tasks only from
-		 * their parent CTRL group.
-		 */
-		if (rdtgrp->type == RDTCTRL_GROUP) {
-			tsk->closid = rdtgrp->closid;
+
+	if (rdtgrp->type == RDTCTRL_GROUP) {
+		tsk->closid = rdtgrp->closid;
+		tsk->rmid = rdtgrp->mon.rmid;
+	} else if (rdtgrp->type == RDTMON_GROUP) {
+		if (rdtgrp->mon.parent->closid == tsk->closid)
 			tsk->rmid = rdtgrp->mon.rmid;
-		} else if (rdtgrp->type == RDTMON_GROUP) {
-			if (rdtgrp->mon.parent->closid == tsk->closid)
-				tsk->rmid = rdtgrp->mon.rmid;
-			else
-				ret = -EINVAL;
-		}
+		else
+			return -EINVAL;
 	}
-	return ret;
+
+	/*
+	 * Ensure the task's closid and rmid are written before determining if
+	 * the task is current that will decide if it will be interrupted.
+	 */
+	barrier();
+
+	/*
+	 * By now, the task's closid and rmid are set. If the task is current
+	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
+	 * group go into effect. If the task is not current, the MSR will be
+	 * updated when the task is scheduled in.
+	 */
+	update_task_closid_rmid(tsk);
+
+	return 0;
 }
 
 static int rdtgroup_task_write_permission(struct task_struct *task,


