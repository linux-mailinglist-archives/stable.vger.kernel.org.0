Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A648B14FABA
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBAVg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 16:36:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:43147 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBAVg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 16:36:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 13:36:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,391,1574150400"; 
   d="scan'208";a="329817601"
Received: from xshen14-linux.bj.intel.com ([10.238.155.105])
  by fmsmga001.fm.intel.com with ESMTP; 01 Feb 2020 13:36:22 -0800
From:   Xiaochen Shen <xiaochen.shen@intel.com>
To:     stable@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, fenghua.yu@intel.com,
        reinette.chatre@intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pei.p.jia@intel.com,
        xiaochen.shen@intel.com, Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 2/3] x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup
Date:   Sun,  2 Feb 2020 06:03:43 +0800
Message-Id: <1580594623-3020-1-git-send-email-xiaochen.shen@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578500886-21771-1-git-send-email-xiaochen.shen@intel.com>
References: <1578500886-21771-1-git-send-email-xiaochen.shen@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1578500886-21771-3-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index db22ba0..77770ca 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2877,13 +2877,13 @@ static int rdtgroup_rmdir_ctrl(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	closid_free(rdtgrp->closid);
 	free_rmid(rdtgrp->mon.rmid);
 
+	rdtgroup_ctrl_remove(kn, rdtgrp);
+
 	/*
 	 * Free all the child monitor group rmids.
 	 */
 	free_all_child_rdtgrp(rdtgrp);
 
-	rdtgroup_ctrl_remove(kn, rdtgrp);
-
 	return 0;
 }
 
-- 
1.8.3.1

