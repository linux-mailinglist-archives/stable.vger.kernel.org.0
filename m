Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B21143039
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgATQrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:47:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33653 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbgATQrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:47:25 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1itaCm-00043A-Gz; Mon, 20 Jan 2020 17:47:12 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 1AF581C1A42;
        Mon, 20 Jan 2020 17:47:12 +0100 (CET)
Date:   Mon, 20 Jan 2020 16:47:11 -0000
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix a deadlock due to inaccurate reference
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1578500886-21771-4-git-send-email-xiaochen.shen@intel.com>
References: <1578500886-21771-4-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <157953883190.396.13475989556891199147.tip-bot2@tip-bot2>
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

Commit-ID:     334b0f4e9b1b4a1d475f803419d202f6c5e4d18e
Gitweb:        https://git.kernel.org/tip/334b0f4e9b1b4a1d475f803419d202f6c5e4d18e
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Thu, 09 Jan 2020 00:28:05 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 20 Jan 2020 16:57:53 +01:00

x86/resctrl: Fix a deadlock due to inaccurate reference

There is a race condition which results in a deadlock when rmdir and
mkdir execute concurrently:

$ ls /sys/fs/resctrl/c1/mon_groups/m1/
cpus  cpus_list  mon_data  tasks

Thread 1: rmdir /sys/fs/resctrl/c1
Thread 2: mkdir /sys/fs/resctrl/c1/mon_groups/m1

3 locks held by mkdir/48649:
 #0:  (sb_writers#17){.+.+}, at: [<ffffffffb4ca2aa0>] mnt_want_write+0x20/0x50
 #1:  (&type->i_mutex_dir_key#8/1){+.+.}, at: [<ffffffffb4c8c13b>] filename_create+0x7b/0x170
 #2:  (rdtgroup_mutex){+.+.}, at: [<ffffffffb4a4389d>] rdtgroup_kn_lock_live+0x3d/0x70

4 locks held by rmdir/48652:
 #0:  (sb_writers#17){.+.+}, at: [<ffffffffb4ca2aa0>] mnt_want_write+0x20/0x50
 #1:  (&type->i_mutex_dir_key#8/1){+.+.}, at: [<ffffffffb4c8c3cf>] do_rmdir+0x13f/0x1e0
 #2:  (&type->i_mutex_dir_key#8){++++}, at: [<ffffffffb4c86d5d>] vfs_rmdir+0x4d/0x120
 #3:  (rdtgroup_mutex){+.+.}, at: [<ffffffffb4a4389d>] rdtgroup_kn_lock_live+0x3d/0x70

Thread 1 is deleting control group "c1". Holding rdtgroup_mutex,
kernfs_remove() removes all kernfs nodes under directory "c1"
recursively, then waits for sub kernfs node "mon_groups" to drop active
reference.

Thread 2 is trying to create a subdirectory "m1" in the "mon_groups"
directory. The wrapper kernfs_iop_mkdir() takes an active reference to
the "mon_groups" directory but the code drops the active reference to
the parent directory "c1" instead.

As a result, Thread 1 is blocked on waiting for active reference to drop
and never release rdtgroup_mutex, while Thread 2 is also blocked on
trying to get rdtgroup_mutex.

Thread 1 (rdtgroup_rmdir)   Thread 2 (rdtgroup_mkdir)
(rmdir /sys/fs/resctrl/c1)  (mkdir /sys/fs/resctrl/c1/mon_groups/m1)
-------------------------   -------------------------
                            kernfs_iop_mkdir
                              /*
                               * kn: "m1", parent_kn: "mon_groups",
                               * prgrp_kn: parent_kn->parent: "c1",
                               *
                               * "mon_groups", parent_kn->active++: 1
                               */
                              kernfs_get_active(parent_kn)
kernfs_iop_rmdir
  /* "c1", kn->active++ */
  kernfs_get_active(kn)

  rdtgroup_kn_lock_live
    atomic_inc(&rdtgrp->waitcount)
    /* "c1", kn->active-- */
    kernfs_break_active_protection(kn)
    mutex_lock

  rdtgroup_rmdir_ctrl
    free_all_child_rdtgrp
      sentry->flags = RDT_DELETED

    rdtgroup_ctrl_remove
      rdtgrp->flags = RDT_DELETED
      kernfs_get(kn)
      kernfs_remove(rdtgrp->kn)
        __kernfs_remove
          /* "mon_groups", sub_kn */
          atomic_add(KN_DEACTIVATED_BIAS, &sub_kn->active)
          kernfs_drain(sub_kn)
            /*
             * sub_kn->active == KN_DEACTIVATED_BIAS + 1,
             * waiting on sub_kn->active to drop, but it
             * never drops in Thread 2 which is blocked
             * on getting rdtgroup_mutex.
             */
Thread 1 hangs here ---->
            wait_event(sub_kn->active == KN_DEACTIVATED_BIAS)
            ...
                              rdtgroup_mkdir
                                rdtgroup_mkdir_mon(parent_kn, prgrp_kn)
                                  mkdir_rdt_prepare(parent_kn, prgrp_kn)
                                    rdtgroup_kn_lock_live(prgrp_kn)
                                      atomic_inc(&rdtgrp->waitcount)
                                      /*
                                       * "c1", prgrp_kn->active--
                                       *
                                       * The active reference on "c1" is
                                       * dropped, but not matching the
                                       * actual active reference taken
                                       * on "mon_groups", thus causing
                                       * Thread 1 to wait forever while
                                       * holding rdtgroup_mutex.
                                       */
                                      kernfs_break_active_protection(
                                                               prgrp_kn)
                                      /*
                                       * Trying to get rdtgroup_mutex
                                       * which is held by Thread 1.
                                       */
Thread 2 hangs here ---->             mutex_lock
                                      ...

The problem is that the creation of a subdirectory in the "mon_groups"
directory incorrectly releases the active protection of its parent
directory instead of itself before it starts waiting for rdtgroup_mutex.
This is triggered by the rdtgroup_mkdir() flow calling
rdtgroup_kn_lock_live()/rdtgroup_kn_unlock() with kernfs node of the
parent control group ("c1") as argument. It should be called with kernfs
node "mon_groups" instead. What is currently missing is that the
kn->priv of "mon_groups" is NULL instead of pointing to the rdtgrp.

Fix it by pointing kn->priv to rdtgrp when "mon_groups" is created. Then
it could be passed to rdtgroup_kn_lock_live()/rdtgroup_kn_unlock()
instead. And then it operates on the same rdtgroup structure but handles
the active reference of kernfs node "mon_groups" to prevent deadlock.
The same changes are also made to the "mon_data" directories.

This results in some unused function parameters that will be cleaned up
in follow-up patch as the focus here is on the fix only in support of
backporting efforts.

Fixes: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1578500886-21771-4-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index caab397..954fd04 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1970,7 +1970,7 @@ static int rdt_get_tree(struct fs_context *fc)
 
 	if (rdt_mon_capable) {
 		ret = mongroup_create_dir(rdtgroup_default.kn,
-					  NULL, "mon_groups",
+					  &rdtgroup_default, "mon_groups",
 					  &kn_mongrp);
 		if (ret < 0)
 			goto out_info;
@@ -2454,7 +2454,7 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
 	/*
 	 * Create the mon_data directory first.
 	 */
-	ret = mongroup_create_dir(parent_kn, NULL, "mon_data", &kn);
+	ret = mongroup_create_dir(parent_kn, prgrp, "mon_data", &kn);
 	if (ret)
 		return ret;
 
@@ -2653,7 +2653,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	uint files = 0;
 	int ret;
 
-	prdtgrp = rdtgroup_kn_lock_live(prgrp_kn);
+	prdtgrp = rdtgroup_kn_lock_live(parent_kn);
 	if (!prdtgrp) {
 		ret = -ENODEV;
 		goto out_unlock;
@@ -2726,7 +2726,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	kernfs_activate(kn);
 
 	/*
-	 * The caller unlocks the prgrp_kn upon success.
+	 * The caller unlocks the parent_kn upon success.
 	 */
 	return 0;
 
@@ -2737,7 +2737,7 @@ out_destroy:
 out_free_rgrp:
 	kfree(rdtgrp);
 out_unlock:
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
@@ -2775,7 +2775,7 @@ static int rdtgroup_mkdir_mon(struct kernfs_node *parent_kn,
 	 */
 	list_add_tail(&rdtgrp->mon.crdtgrp_list, &prgrp->mon.crdtgrp_list);
 
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
@@ -2818,7 +2818,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 		 * Create an empty mon_groups directory to hold the subset
 		 * of tasks and cpus to monitor.
 		 */
-		ret = mongroup_create_dir(kn, NULL, "mon_groups", NULL);
+		ret = mongroup_create_dir(kn, rdtgrp, "mon_groups", NULL);
 		if (ret) {
 			rdt_last_cmd_puts("kernfs subdir error\n");
 			goto out_del_list;
@@ -2834,7 +2834,7 @@ out_id_free:
 out_common_fail:
 	mkdir_rdt_prepare_clean(rdtgrp);
 out_unlock:
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
