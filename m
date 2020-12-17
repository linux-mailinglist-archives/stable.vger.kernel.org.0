Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCD02DDB7E
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgLQWcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 17:32:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:41195 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgLQWcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 17:32:22 -0500
IronPort-SDR: QkrdW/tReGX3BCYaRMkr2sLVkSo7n1wNNsS1TNQnPd4N3WRfAgsjaURYBFMvKnFBODy2lwxeaB
 2ina6GuMJpDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="154567841"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="154567841"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:31:41 -0800
IronPort-SDR: UQ+L2K8zP8bxAnqE6VxtxYz7hpKEgOm0XFnLXhtKrENRZZ/0lAnq2wwT5BaoS50/vqPe5ptI2t
 RbF+kmYuofoQ==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="387836627"
Received: from rchatre-mobl1.jf.intel.com ([10.54.70.7])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 14:31:41 -0800
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com
Cc:     kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH V2 1/4] x86/resctrl: Use IPI instead of task_work_add() to update PQR_ASSOC MSR
Date:   Thu, 17 Dec 2020 14:31:18 -0800
Message-Id: <17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1608243147.git.reinette.chatre@intel.com>
References: <cover.1608243147.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Currently when moving a task to a resource group the PQR_ASSOC MSR
is updated with the new closid and rmid in an added task callback.
If the task is running the work is run as soon as possible. If the
task is not running the work is executed later in the kernel exit path
when the kernel returns to the task again.

Updating the PQR_ASSOC MSR as soon as possible on the CPU a moved task
is running is the right thing to do. Queueing work for a task that is
not running is unnecessary (the PQR_ASSOC MSR is already updated when the
task is scheduled in) and causing system resource waste with the way in
which it is implemented: Work to update the PQR_ASSOC register is queued
every time the user writes a task id to the "tasks" file, even if the task
already belongs to the resource group. This could result in multiple
pending work items associated with a single task even if they are all
identical and even though only a single update with most recent values
is needed.  Specifically, even if a task is moved between different
resource groups while it is sleeping then it is only the last move that
is relevant but yet a work item is queued during each move.
This unnecessary queueing of work items could result in significant system
resource waste, especially on tasks sleeping for a long time. For example,
as demonstrated by Shakeel Butt in [1] writing the same task id to the
"tasks" file can quickly consume significant memory. The same problem
(wasted system resources) occurs when moving a task between different
resource groups.

As pointed out by Valentin Schneider in [2] there is an additional issue
with the way in which the queueing of work is done in that the task_struct
update is currently done after the work is queued, resulting in a race with
the register update possibly done before the data needed by the update is
available.

To solve these issues, the PQR_ASSOC MSR is updated in a synchronous way
right after the new closid and rmid are ready during the task movement,
only if the task is running. If a moved task is not running nothing is
done since the PQR_ASSOC MSR will be updated next time the task is
scheduled.  This is the same way used to update the register when tasks
are moved as part of resource group removal.

[1] https://lore.kernel.org/lkml/CALvZod7E9zzHwenzf7objzGKsdBmVwTgEJ0nPgs0LUFU3SN5Pw@mail.gmail.com/
[2] https://lore.kernel.org/lkml/20201123022433.17905-1-valentin.schneider@arm.com

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Reported-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Cc: stable@vger.kernel.org
---
V1->V2:
* Add Reviewed-by tags.
* Use task_curr() instead of task_struct->on_cpu (James)
* Fixup subject line (James)
* Remove unnecessary check for non-existent resource group type. (James and Valentin)
* Include barrier() after closid/rmid written. (Valentin)

 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 118 ++++++++++---------------
 1 file changed, 49 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index f3418428682b..c5937a12d731 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -525,89 +525,69 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
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
-	if (unlikely(current->flags & PF_EXITING))
-		goto out;
-
-	preempt_disable();
-	/* update PQR_ASSOC MSR to make resource group go into effect */
-	resctrl_sched_in();
-	preempt_enable();
+	if (task == current)
+		resctrl_sched_in();
+}
 
-out:
-	kfree(callback);
+#ifdef CONFIG_SMP
+static void update_task_closid_rmid(struct task_struct *t)
+{
+	if (task_curr(t))
+		smp_call_function_single(task_cpu(t), _update_task_closid_rmid,
+					 t, 1);
 }
+#else
+static void update_task_closid_rmid(struct task_struct *t)
+{
+	_update_task_closid_rmid(t);
+}
+#endif
 
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
-	ret = task_work_add(tsk, &callback->work, TWA_RESUME);
-	if (ret) {
-		/*
-		 * Task is exiting. Drop the refcount and free the callback.
-		 * No need to check the refcount as the group cannot be
-		 * deleted before the write function unlocks rdtgroup_mutex.
-		 */
-		atomic_dec(&rdtgrp->waitcount);
-		kfree(callback);
-		rdt_last_cmd_puts("Task exited\n");
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
+		if (rdtgrp->mon.parent->closid == tsk->closid) {
 			tsk->rmid = rdtgrp->mon.rmid;
-		} else if (rdtgrp->type == RDTMON_GROUP) {
-			if (rdtgrp->mon.parent->closid == tsk->closid) {
-				tsk->rmid = rdtgrp->mon.rmid;
-			} else {
-				rdt_last_cmd_puts("Can't move task to different control group\n");
-				ret = -EINVAL;
-			}
+		} else {
+			rdt_last_cmd_puts("Can't move task to different control group\n");
+			return -EINVAL;
 		}
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
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
-- 
2.26.2

