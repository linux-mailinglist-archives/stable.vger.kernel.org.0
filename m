Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37C82EEE7D
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 09:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbhAHIT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 03:19:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48894 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbhAHIT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 03:19:27 -0500
Date:   Fri, 08 Jan 2021 08:18:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610093923;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5getzKg1L+mZshZOeUzP5hd6FqOotU7xvE61/6rfYAQ=;
        b=FWtFCLvyJodYHeQRnTnkPepQqYkQTrRJcm7daqpV+cMGueY4KkL9XWd0kroLq9H8R/5ZEp
        y/HwLWRVm6G9YvPzG/tLCWa6tRAmlGwMKzvDsssB2L5QKuvlcpOcP5Jgj8SjKwnlBpfaPI
        uCSReqxylyp4dHI1go/L6pSlquVX85X0r5yGTHZu03INXDUKYddMlsOseP+qSA5tLqcQ61
        nM9dkLX/JRzWD5u9IdXG76U/Aw2PyCfe/iC0TV8Qmx90XyEaZ5E4J93UcRlWr+t0mbzmfL
        8+q9aqTsjFw+lN1ZOQRbIoddPE5/UNp5A82MWMLVRVu8B39nIxQd0lf9YzEFKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610093923;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5getzKg1L+mZshZOeUzP5hd6FqOotU7xvE61/6rfYAQ=;
        b=Crt9osVKbFqbIrJECZrnAoJW9D5Pt/gHXDbNEfE8In30rYM6X8VeXLtm2nvSnufYUqVIM2
        59fikDtFfy2BOpDA==
From:   "tip-bot2 for Fenghua Yu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Use an IPI instead of task_work_add()
 to update PQR_ASSOC MSR
Cc:     Shakeel Butt <shakeelb@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94=2E16082?=
 =?utf-8?q?43147=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
References: =?utf-8?q?=3C17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94=2E160824?=
 =?utf-8?q?3147=2Egit=2Ereinette=2Echatre=40intel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <161009392323.414.8857731060215542124.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     ae28d1aae48a1258bd09a6f707ebb4231d79a761
Gitweb:        https://git.kernel.org/tip/ae28d1aae48a1258bd09a6f707ebb4231d79a761
Author:        Fenghua Yu <fenghua.yu@intel.com>
AuthorDate:    Thu, 17 Dec 2020 14:31:18 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 08 Jan 2021 09:03:36 +01:00

x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR

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
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 112 +++++++++---------------
 1 file changed, 43 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 29ffb95..1c6f8a6 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -525,89 +525,63 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
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
