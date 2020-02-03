Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233AD150BE0
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgBCQbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:31:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbgBCQbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:31:22 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDC121775;
        Mon,  3 Feb 2020 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747480;
        bh=lefoyMbQsgXq2gDmEPbfAtneaTO6MoZYwTMBNKMkTMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bl0aGkkj7qyXARYXpYyTj9JSm5bT5bQK1LpIW4mEeQU8zTQvcEPJ+cxHb+sD5UHlo
         VcpNnqC+LWUKJ7G1kPGy0WJ0kNJyf/rij57ZM/TxjV3FdCJHodPz3hoMdo9OCMoLBi
         9WnuU2vHJ/gPq5mJj9ndWmfyJ7N3YhzSGPzhDiKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/70] x86/resctrl: Fix a deadlock due to inaccurate reference
Date:   Mon,  3 Feb 2020 16:19:16 +0000
Message-Id: <20200203161912.983146506@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

commit 334b0f4e9b1b4a1d475f803419d202f6c5e4d18e upstream.

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

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
for older stable trees.

Fixes: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1578500886-21771-4-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 77770caeea242..11c5accfa4db5 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2005,7 +2005,7 @@ static struct dentry *rdt_mount(struct file_system_type *fs_type,
 
 	if (rdt_mon_capable) {
 		ret = mongroup_create_dir(rdtgroup_default.kn,
-					  NULL, "mon_groups",
+					  &rdtgroup_default, "mon_groups",
 					  &kn_mongrp);
 		if (ret) {
 			dentry = ERR_PTR(ret);
@@ -2415,7 +2415,7 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
 	/*
 	 * Create the mon_data directory first.
 	 */
-	ret = mongroup_create_dir(parent_kn, NULL, "mon_data", &kn);
+	ret = mongroup_create_dir(parent_kn, prgrp, "mon_data", &kn);
 	if (ret)
 		return ret;
 
@@ -2568,7 +2568,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	uint files = 0;
 	int ret;
 
-	prdtgrp = rdtgroup_kn_lock_live(prgrp_kn);
+	prdtgrp = rdtgroup_kn_lock_live(parent_kn);
 	rdt_last_cmd_clear();
 	if (!prdtgrp) {
 		ret = -ENODEV;
@@ -2643,7 +2643,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	kernfs_activate(kn);
 
 	/*
-	 * The caller unlocks the prgrp_kn upon success.
+	 * The caller unlocks the parent_kn upon success.
 	 */
 	return 0;
 
@@ -2654,7 +2654,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 out_free_rgrp:
 	kfree(rdtgrp);
 out_unlock:
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
@@ -2692,7 +2692,7 @@ static int rdtgroup_mkdir_mon(struct kernfs_node *parent_kn,
 	 */
 	list_add_tail(&rdtgrp->mon.crdtgrp_list, &prgrp->mon.crdtgrp_list);
 
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
@@ -2735,7 +2735,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 		 * Create an empty mon_groups directory to hold the subset
 		 * of tasks and cpus to monitor.
 		 */
-		ret = mongroup_create_dir(kn, NULL, "mon_groups", NULL);
+		ret = mongroup_create_dir(kn, rdtgrp, "mon_groups", NULL);
 		if (ret) {
 			rdt_last_cmd_puts("kernfs subdir error\n");
 			goto out_del_list;
@@ -2751,7 +2751,7 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
 out_common_fail:
 	mkdir_rdt_prepare_clean(rdtgrp);
 out_unlock:
-	rdtgroup_kn_unlock(prgrp_kn);
+	rdtgroup_kn_unlock(parent_kn);
 	return ret;
 }
 
-- 
2.20.1



