Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868C1150DB7
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgBCQ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgBCQ2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:28:41 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D2421744;
        Mon,  3 Feb 2020 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747320;
        bh=/iqsiNq1ufmoQNtCN5R0k0FfUZr3NDO+99uNskwHkS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwiBlk9Z4QcnEq3xNdYVkuLdRj7Iuk300wIb9bbe4TGqGWL1m6IV00mRc1kBtP8fj
         /qnpgkf/tz4yIwsr25fmih4aTRAvqe1sT9UQMZEgZTb+OurdKvQXi9cgSbWuO8lv8V
         E73062Iu/WcU6JffXoUBosMdtyuOl0dUT1yRVzS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/89] x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup
Date:   Mon,  3 Feb 2020 16:19:20 +0000
Message-Id: <20200203161921.742470591@linuxfoundation.org>
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

commit 074fadee59ee7a9d2b216e9854bd4efb5dad679f upstream.

There is a race condition in the following scenario which results in an
use-after-free issue when reading a monitoring file and deleting the
parent ctrl_mon group concurrently:

Thread 1 calls atomic_inc() to take refcount of rdtgrp and then calls
kernfs_break_active_protection() to drop the active reference of kernfs
node in rdtgroup_kn_lock_live().

In Thread 2, kernfs_remove() is a blocking routine. It waits on all sub
kernfs nodes to drop the active reference when removing all subtree
kernfs nodes recursively. Thread 2 could block on kernfs_remove() until
Thread 1 calls kernfs_break_active_protection(). Only after
kernfs_remove() completes the refcount of rdtgrp could be trusted.

Before Thread 1 calls atomic_inc() and kernfs_break_active_protection(),
Thread 2 could call kfree() when the refcount of rdtgrp (sentry) is 0
instead of 1 due to the race.

In Thread 1, in rdtgroup_kn_unlock(), referring to earlier rdtgrp memory
(rdtgrp->waitcount) which was already freed in Thread 2 results in
use-after-free issue.

Thread 1 (rdtgroup_mondata_show)  Thread 2 (rdtgroup_rmdir)
--------------------------------  -------------------------
rdtgroup_kn_lock_live
  /*
   * kn active protection until
   * kernfs_break_active_protection(kn)
   */
  rdtgrp = kernfs_to_rdtgroup(kn)
                                  rdtgroup_kn_lock_live
                                    atomic_inc(&rdtgrp->waitcount)
                                    mutex_lock
                                  rdtgroup_rmdir_ctrl
                                    free_all_child_rdtgrp
                                      /*
                                       * sentry->waitcount should be 1
                                       * but is 0 now due to the race.
                                       */
                                      kfree(sentry)*[1]
  /*
   * Only after kernfs_remove()
   * completes, the refcount of
   * rdtgrp could be trusted.
   */
  atomic_inc(&rdtgrp->waitcount)
  /* kn->active-- */
  kernfs_break_active_protection(kn)
                                    rdtgroup_ctrl_remove
                                      rdtgrp->flags = RDT_DELETED
                                      /*
                                       * Blocking routine, wait for
                                       * all sub kernfs nodes to drop
                                       * active reference in
                                       * kernfs_break_active_protection.
                                       */
                                      kernfs_remove(rdtgrp->kn)
                                  rdtgroup_kn_unlock
                                    mutex_unlock
                                    atomic_dec_and_test(
                                                &rdtgrp->waitcount)
                                    && (flags & RDT_DELETED)
                                      kernfs_unbreak_active_protection(kn)
                                      kfree(rdtgrp)
  mutex_lock
mon_event_read
rdtgroup_kn_unlock
  mutex_unlock
  /*
   * Use-after-free: refer to earlier rdtgrp
   * memory which was freed in [1].
   */
  atomic_dec_and_test(&rdtgrp->waitcount)
  && (flags & RDT_DELETED)
    /* kn->active++ */
    kernfs_unbreak_active_protection(kn)
    kfree(rdtgrp)

Fix it by moving free_all_child_rdtgrp() to after kernfs_remove() in
rdtgroup_rmdir_ctrl() to ensure it has the accurate refcount of rdtgrp.

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
for older stable trees.

Upstream commit 17eafd076291 ("x86/intel_rdt: Split resource group
removal in two") moved part of resource group removal code from
rdtgroup_rmdir_mon() into a separate function rdtgroup_ctrl_remove().
Apply the change against original code base of rdtgroup_rmdir_mon() for
older stable trees.

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1578500886-21771-3-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 734996904dc3b..01574966d91fd 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -1800,11 +1800,6 @@ static int rdtgroup_rmdir_ctrl(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	closid_free(rdtgrp->closid);
 	free_rmid(rdtgrp->mon.rmid);
 
-	/*
-	 * Free all the child monitor group rmids.
-	 */
-	free_all_child_rdtgrp(rdtgrp);
-
 	list_del(&rdtgrp->rdtgroup_list);
 
 	/*
@@ -1814,6 +1809,11 @@ static int rdtgroup_rmdir_ctrl(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 
+	/*
+	 * Free all the child monitor group rmids.
+	 */
+	free_all_child_rdtgrp(rdtgrp);
+
 	return 0;
 }
 
-- 
2.20.1



