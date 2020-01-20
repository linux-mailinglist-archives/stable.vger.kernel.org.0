Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4399814303C
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgATQr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:47:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33659 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgATQr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:47:27 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1itaCm-00043G-W2; Mon, 20 Jan 2020 17:47:13 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A07071C1A41;
        Mon, 20 Jan 2020 17:47:12 +0100 (CET)
Date:   Mon, 20 Jan 2020 16:47:12 -0000
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix use-after-free when deleting
 resource groups
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1578500886-21771-2-git-send-email-xiaochen.shen@intel.com>
References: <1578500886-21771-2-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <157953883246.396.8806061711020542800.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b8511ccc75c033f6d54188ea4df7bf1e85778740
Gitweb:        https://git.kernel.org/tip/b8511ccc75c033f6d54188ea4df7bf1e85778740
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Thu, 09 Jan 2020 00:28:03 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 20 Jan 2020 16:45:43 +01:00

x86/resctrl: Fix use-after-free when deleting resource groups

A resource group (rdtgrp) contains a reference count (rdtgrp->waitcount)
that indicates how many waiters expect this rdtgrp to exist. Waiters
could be waiting on rdtgroup_mutex or some work sitting on a task's
workqueue for when the task returns from kernel mode or exits.

The deletion of a rdtgrp is intended to have two phases:

  (1) while holding rdtgroup_mutex the necessary cleanup is done and
  rdtgrp->flags is set to RDT_DELETED,

  (2) after releasing the rdtgroup_mutex, the rdtgrp structure is freed
  only if there are no waiters and its flag is set to RDT_DELETED. Upon
  gaining access to rdtgroup_mutex or rdtgrp, a waiter is required to check
  for the RDT_DELETED flag.

When unmounting the resctrl file system or deleting ctrl_mon groups,
all of the subdirectories are removed and the data structure of rdtgrp
is forcibly freed without checking rdtgrp->waitcount. If at this point
there was a waiter on rdtgrp then a use-after-free issue occurs when the
waiter starts running and accesses the rdtgrp structure it was waiting
on.

See kfree() calls in [1], [2] and [3] in these two call paths in
following scenarios:
(1) rdt_kill_sb() -> rmdir_all_sub() -> free_all_child_rdtgrp()
(2) rdtgroup_rmdir() -> rdtgroup_rmdir_ctrl() -> free_all_child_rdtgrp()

There are several scenarios that result in use-after-free issue in
following:

Scenario 1:
-----------
In Thread 1, rdtgroup_tasks_write() adds a task_work callback
move_myself(). If move_myself() is scheduled to execute after Thread 2
rdt_kill_sb() is finished, referring to earlier rdtgrp memory
(rdtgrp->waitcount) which was already freed in Thread 2 results in
use-after-free issue.

Thread 1 (rdtgroup_tasks_write)        Thread 2 (rdt_kill_sb)
-------------------------------        ----------------------
rdtgroup_kn_lock_live
  atomic_inc(&rdtgrp->waitcount)
  mutex_lock
rdtgroup_move_task
  __rdtgroup_move_task
    /*
     * Take an extra refcount, so rdtgrp cannot be freed
     * before the call back move_myself has been invoked
     */
    atomic_inc(&rdtgrp->waitcount)
    /* Callback move_myself will be scheduled for later */
    task_work_add(move_myself)
rdtgroup_kn_unlock
  mutex_unlock
  atomic_dec_and_test(&rdtgrp->waitcount)
  && (flags & RDT_DELETED)
                                       mutex_lock
                                       rmdir_all_sub
                                         /*
                                          * sentry and rdtgrp are freed
                                          * without checking refcount
                                          */
                                         free_all_child_rdtgrp
                                           kfree(sentry)*[1]
                                         kfree(rdtgrp)*[2]
                                       mutex_unlock
/*
 * Callback is scheduled to execute
 * after rdt_kill_sb is finished
 */
move_myself
  /*
   * Use-after-free: refer to earlier rdtgrp
   * memory which was freed in [1] or [2].
   */
  atomic_dec_and_test(&rdtgrp->waitcount)
  && (flags & RDT_DELETED)
    kfree(rdtgrp)

Scenario 2:
-----------
In Thread 1, rdtgroup_tasks_write() adds a task_work callback
move_myself(). If move_myself() is scheduled to execute after Thread 2
rdtgroup_rmdir() is finished, referring to earlier rdtgrp memory
(rdtgrp->waitcount) which was already freed in Thread 2 results in
use-after-free issue.

Thread 1 (rdtgroup_tasks_write)        Thread 2 (rdtgroup_rmdir)
-------------------------------        -------------------------
rdtgroup_kn_lock_live
  atomic_inc(&rdtgrp->waitcount)
  mutex_lock
rdtgroup_move_task
  __rdtgroup_move_task
    /*
     * Take an extra refcount, so rdtgrp cannot be freed
     * before the call back move_myself has been invoked
     */
    atomic_inc(&rdtgrp->waitcount)
    /* Callback move_myself will be scheduled for later */
    task_work_add(move_myself)
rdtgroup_kn_unlock
  mutex_unlock
  atomic_dec_and_test(&rdtgrp->waitcount)
  && (flags & RDT_DELETED)
                                       rdtgroup_kn_lock_live
                                         atomic_inc(&rdtgrp->waitcount)
                                         mutex_lock
                                       rdtgroup_rmdir_ctrl
                                         free_all_child_rdtgrp
                                           /*
                                            * sentry is freed without
                                            * checking refcount
                                            */
                                           kfree(sentry)*[3]
                                         rdtgroup_ctrl_remove
                                           rdtgrp->flags = RDT_DELETED
                                       rdtgroup_kn_unlock
                                         mutex_unlock
                                         atomic_dec_and_test(
                                                     &rdtgrp->waitcount)
                                         && (flags & RDT_DELETED)
                                           kfree(rdtgrp)
/*
 * Callback is scheduled to execute
 * after rdt_kill_sb is finished
 */
move_myself
  /*
   * Use-after-free: refer to earlier rdtgrp
   * memory which was freed in [3].
   */
  atomic_dec_and_test(&rdtgrp->waitcount)
  && (flags & RDT_DELETED)
    kfree(rdtgrp)

If CONFIG_DEBUG_SLAB=y, Slab corruption on kmalloc-2k can be observed
like following. Note that "0x6b" is POISON_FREE after kfree(). The
corrupted bits "0x6a", "0x64" at offset 0x424 correspond to
waitcount member of struct rdtgroup which was freed:

  Slab corruption (Not tainted): kmalloc-2k start=ffff9504c5b0d000, len=2048
  420: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkjkkkkkkkkkkk
  Single bit error detected. Probably bad RAM.
  Run memtest86+ or a similar memory test tool.
  Next obj: start=ffff9504c5b0d800, len=2048
  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

  Slab corruption (Not tainted): kmalloc-2k start=ffff9504c58ab800, len=2048
  420: 6b 6b 6b 6b 64 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkdkkkkkkkkkkk
  Prev obj: start=ffff9504c58ab000, len=2048
  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

Fix this by taking reference count (waitcount) of rdtgrp into account in
the two call paths that currently do not do so. Instead of always
freeing the resource group it will only be freed if there are no waiters
on it. If there are waiters, the resource group will have its flags set
to RDT_DELETED.

It will be left to the waiter to free the resource group when it starts
running and finding that it was the last waiter and the resource group
has been removed (rdtgrp->flags & RDT_DELETED) since. (1) rdt_kill_sb()
-> rmdir_all_sub() -> free_all_child_rdtgrp() (2) rdtgroup_rmdir() ->
rdtgroup_rmdir_ctrl() -> free_all_child_rdtgrp()

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1578500886-21771-2-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index dac7209..23904ab 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2205,7 +2205,11 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
 		free_rmid(sentry->mon.rmid);
 		list_del(&sentry->mon.crdtgrp_list);
-		kfree(sentry);
+
+		if (atomic_read(&sentry->waitcount) != 0)
+			sentry->flags = RDT_DELETED;
+		else
+			kfree(sentry);
 	}
 }
 
@@ -2243,7 +2247,11 @@ static void rmdir_all_sub(void)
 
 		kernfs_remove(rdtgrp->kn);
 		list_del(&rdtgrp->rdtgroup_list);
-		kfree(rdtgrp);
+
+		if (atomic_read(&rdtgrp->waitcount) != 0)
+			rdtgrp->flags = RDT_DELETED;
+		else
+			kfree(rdtgrp);
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
