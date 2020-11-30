Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F492C8A4C
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgK3RAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:00:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:47733 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgK3RAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 12:00:43 -0500
IronPort-SDR: NsRUHswvhkT05mX4vhaG3nL2Hu/6CLuupZgBdZ8SdreuXjv+I5eVzaRfZx8TXR3tvm8VJucTlf
 qFHETyQykVVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="152502242"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="152502242"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:00:02 -0800
IronPort-SDR: CUgCMKWicH3WgSaIU077OfJomLEIESNlkz553SckubU+g1LsgFiqDX4rjnNxyos6WGFhFJtsJu
 WSysKzGmkfKg==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549175610"
Received: from xshen14-linux.bj.intel.com ([10.238.155.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:00:00 -0800
From:   Xiaochen Shen <xiaochen.shen@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, bp@suse.de, reinette.chatre@intel.com,
        willemb@google.com
Cc:     tony.luck@intel.com, fenghua.yu@intel.com, pei.p.jia@intel.com,
        xiaochen.shen@intel.com
Subject: [PATCH 4.19 2/2] x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak
Date:   Tue,  1 Dec 2020 01:23:14 +0800
Message-Id: <1606756994-9159-1-git-send-email-xiaochen.shen@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606725286224153@kroah.com>
References: <1606725286224153@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 758999246965eeb8b253d47e72f7bfe508804b16 upstream.

On resource group creation via a mkdir an extra kernfs_node reference is
obtained by kernfs_get() to ensure that the rdtgroup structure remains
accessible for the rdtgroup_kn_unlock() calls where it is removed on
deletion. Currently the extra kernfs_node reference count is only
dropped by kernfs_put() in rdtgroup_kn_unlock() while the rdtgroup
structure is removed in a few other locations that lack the matching
reference drop.

In call paths of rmdir and umount, when a control group is removed,
kernfs_remove() is called to remove the whole kernfs nodes tree of the
control group (including the kernfs nodes trees of all child monitoring
groups), and then rdtgroup structure is freed by kfree(). The rdtgroup
structures of all child monitoring groups under the control group are
freed by kfree() in free_all_child_rdtgrp().

Before calling kfree() to free the rdtgroup structures, the kernfs node
of the control group itself as well as the kernfs nodes of all child
monitoring groups still take the extra references which will never be
dropped to 0 and the kernfs nodes will never be freed. It leads to
reference count leak and kernfs_node_cache memory leak.

For example, reference count leak is observed in these two cases:
  (1) mount -t resctrl resctrl /sys/fs/resctrl
      mkdir /sys/fs/resctrl/c1
      mkdir /sys/fs/resctrl/c1/mon_groups/m1
      umount /sys/fs/resctrl

  (2) mkdir /sys/fs/resctrl/c1
      mkdir /sys/fs/resctrl/c1/mon_groups/m1
      rmdir /sys/fs/resctrl/c1

The same reference count leak issue also exists in the error exit paths
of mkdir in mkdir_rdt_prepare() and rdtgroup_mkdir_ctrl_mon().

Fix this issue by following changes to make sure the extra kernfs_node
reference on rdtgroup is dropped before freeing the rdtgroup structure.
  (1) Introduce rdtgroup removal helper rdtgroup_remove() to wrap up
  kernfs_put() and kfree().

  (2) Call rdtgroup_remove() in rdtgroup removal path where the rdtgroup
  structure is about to be freed by kfree().

  (3) Call rdtgroup_remove() or kernfs_put() as appropriate in the error
  exit paths of mkdir where an extra reference is taken by kernfs_get().

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
in older stable trees.

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1604085088-31707-1-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index dc9061a..12083f2 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -515,6 +515,24 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+/**
+ * rdtgroup_remove - the helper to remove resource group safely
+ * @rdtgrp: resource group to remove
+ *
+ * On resource group creation via a mkdir, an extra kernfs_node reference is
+ * taken to ensure that the rdtgroup structure remains accessible for the
+ * rdtgroup_kn_unlock() calls where it is removed.
+ *
+ * Drop the extra reference here, then free the rdtgroup structure.
+ *
+ * Return: void
+ */
+static void rdtgroup_remove(struct rdtgroup *rdtgrp)
+{
+	kernfs_put(rdtgrp->kn);
+	kfree(rdtgrp);
+}
+
 struct task_move_callback {
 	struct callback_head	work;
 	struct rdtgroup		*rdtgrp;
@@ -537,7 +555,7 @@ static void move_myself(struct callback_head *head)
 	    (rdtgrp->flags & RDT_DELETED)) {
 		current->closid = 0;
 		current->rmid = 0;
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	}
 
 	preempt_disable();
@@ -1959,8 +1977,7 @@ void rdtgroup_kn_unlock(struct kernfs_node *kn)
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
 		kernfs_unbreak_active_protection(kn);
-		kernfs_put(rdtgrp->kn);
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	} else {
 		kernfs_unbreak_active_protection(kn);
 	}
@@ -2169,7 +2186,7 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 		if (atomic_read(&sentry->waitcount) != 0)
 			sentry->flags = RDT_DELETED;
 		else
-			kfree(sentry);
+			rdtgroup_remove(sentry);
 	}
 }
 
@@ -2211,7 +2228,7 @@ static void rmdir_all_sub(void)
 		if (atomic_read(&rdtgrp->waitcount) != 0)
 			rdtgrp->flags = RDT_DELETED;
 		else
-			kfree(rdtgrp);
+			rdtgroup_remove(rdtgrp);
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
@@ -2602,7 +2619,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
 	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
-	 * which will be dropped inside rdtgroup_kn_unlock().
+	 * which will be dropped by kernfs_put() in rdtgroup_remove().
 	 */
 	kernfs_get(kn);
 
@@ -2643,6 +2660,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 out_idfree:
 	free_rmid(rdtgrp->mon.rmid);
 out_destroy:
+	kernfs_put(rdtgrp->kn);
 	kernfs_remove(rdtgrp->kn);
 out_free_rgrp:
 	kfree(rdtgrp);
@@ -2655,7 +2673,7 @@ static void mkdir_rdt_prepare_clean(struct rdtgroup *rgrp)
 {
 	kernfs_remove(rgrp->kn);
 	free_rmid(rgrp->mon.rmid);
-	kfree(rgrp);
+	rdtgroup_remove(rgrp);
 }
 
 /*
-- 
1.8.3.1

