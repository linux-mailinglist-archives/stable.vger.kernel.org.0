Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9652C9B66
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgLAJH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbgLAJHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:07:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0571120671;
        Tue,  1 Dec 2020 09:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813634;
        bh=MzdzlcNt7UQXUaObuV279fwptYb1t9M3gehXOuqZ+eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCjxPoU5r7kQQNflMGuMc1LMQOuXKMf2ujsDxnB+YYjwgVKPvbbMhBcXAvFXW5Py5
         EBUCdLTIA4WUxc2eAmqmzRpz9Ct5cQ0sQu+GlVA1Co3iG6DGrzlVcInvCnVI0uMtxu
         NlGjmzmXA8pkdk2HRchYGRtnlxBdhwcGtUgoOT7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.4 89/98] x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak
Date:   Tue,  1 Dec 2020 09:54:06 +0100
Message-Id: <20201201084659.457353621@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaochen Shen <xiaochen.shen@intel.com>

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

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1604085088-31707-1-git-send-email-xiaochen.shen@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -507,6 +507,24 @@ unlock:
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
@@ -529,7 +547,7 @@ static void move_myself(struct callback_
 	    (rdtgrp->flags & RDT_DELETED)) {
 		current->closid = 0;
 		current->rmid = 0;
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	}
 
 	preempt_disable();
@@ -1914,8 +1932,7 @@ void rdtgroup_kn_unlock(struct kernfs_no
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
 		kernfs_unbreak_active_protection(kn);
-		kernfs_put(rdtgrp->kn);
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	} else {
 		kernfs_unbreak_active_protection(kn);
 	}
@@ -2207,7 +2224,7 @@ static void free_all_child_rdtgrp(struct
 		if (atomic_read(&sentry->waitcount) != 0)
 			sentry->flags = RDT_DELETED;
 		else
-			kfree(sentry);
+			rdtgroup_remove(sentry);
 	}
 }
 
@@ -2249,7 +2266,7 @@ static void rmdir_all_sub(void)
 		if (atomic_read(&rdtgrp->waitcount) != 0)
 			rdtgrp->flags = RDT_DELETED;
 		else
-			kfree(rdtgrp);
+			rdtgroup_remove(rdtgrp);
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
@@ -2685,7 +2702,7 @@ static int mkdir_rdt_prepare(struct kern
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
 	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
-	 * which will be dropped inside rdtgroup_kn_unlock().
+	 * which will be dropped by kernfs_put() in rdtgroup_remove().
 	 */
 	kernfs_get(kn);
 
@@ -2726,6 +2743,7 @@ static int mkdir_rdt_prepare(struct kern
 out_idfree:
 	free_rmid(rdtgrp->mon.rmid);
 out_destroy:
+	kernfs_put(rdtgrp->kn);
 	kernfs_remove(rdtgrp->kn);
 out_free_rgrp:
 	kfree(rdtgrp);
@@ -2738,7 +2756,7 @@ static void mkdir_rdt_prepare_clean(stru
 {
 	kernfs_remove(rgrp->kn);
 	free_rmid(rgrp->mon.rmid);
-	kfree(rgrp);
+	rdtgroup_remove(rgrp);
 }
 
 /*


