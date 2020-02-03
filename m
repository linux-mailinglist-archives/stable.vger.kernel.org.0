Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE101150B8F
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgBCQ2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729632AbgBCQ2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:28:39 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94922051A;
        Mon,  3 Feb 2020 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747318;
        bh=7jfH0wCPJuTbM+1I5VAMx0diSl93SmEvXG+EQAXkbi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZafAjBv+dEEX6i9RsjJqryvuu23CierD+NR+ZlXKXYRbN5tDmsSDAIPq/NYHAjgg
         PjhCpdbnABRceMK6RInUp6PLs3ql6UssjuRHgr7OgeNDpzT3ORByHu8yQUtVgs/8D/
         t3TcmziJ1IitNRDOd0VgBl42XmC2v0yEG0y9orbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/89] x86/resctrl: Fix use-after-free when deleting resource groups
Date:   Mon,  3 Feb 2020 16:19:19 +0000
Message-Id: <20200203161921.591952372@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

commit b8511ccc75c033f6d54188ea4df7bf1e85778740 upstream.

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

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.

Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
in older stable trees.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 2dae1b3c42fcc..734996904dc3b 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -1260,7 +1260,11 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
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
 
@@ -1294,7 +1298,11 @@ static void rmdir_all_sub(void)
 
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
-- 
2.20.1



