Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA7D143036
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgATQrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:47:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33649 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATQrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:47:21 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1itaCm-00043D-Of; Mon, 20 Jan 2020 17:47:12 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 6136C1C1A43;
        Mon, 20 Jan 2020 17:47:12 +0100 (CET)
Date:   Mon, 20 Jan 2020 16:47:12 -0000
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix use-after-free due to inaccurate
 refcount of rdtgroup
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1578500886-21771-3-git-send-email-xiaochen.shen@intel.com>
References: <1578500886-21771-3-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <157953883217.396.12697425856555767565.tip-bot2@tip-bot2>
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

Commit-ID:     074fadee59ee7a9d2b216e9854bd4efb5dad679f
Gitweb:        https://git.kernel.org/tip/074fadee59ee7a9d2b216e9854bd4efb5dad679f
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Thu, 09 Jan 2020 00:28:04 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 20 Jan 2020 16:56:11 +01:00

x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

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
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 23904ab..caab397 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2960,13 +2960,13 @@ static int rdtgroup_rmdir_ctrl(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
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
 
