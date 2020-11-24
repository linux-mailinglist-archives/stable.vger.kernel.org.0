Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9672C259E
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 13:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733074AbgKXMZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 07:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733032AbgKXMZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 07:25:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94264C0613D6;
        Tue, 24 Nov 2020 04:25:09 -0800 (PST)
Date:   Tue, 24 Nov 2020 12:25:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606220707;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TD1cXptQK69KKX0sVGEJyWh1TykVQLhdRkmPmKU6KG0=;
        b=kGlnyeMIjhWp7OL8PwqCaMf8fG9ydvsNPWitOiPP+q6v1KP3WWHkj5Q2RAMo3DNMKtfGvq
        9zdfHDE3lHKcEcYahvKxFIe38ukhBTPMbJpIOCKuhLPaWgfZ5cu3p/uZC2bFfLEx7yaYBK
        L4Jq/B7F0I8/9SFYoMoySTkSy6BdKIFgUetL60mUuv0mSA5DirLqQdOYf5ggysqfblyAzn
        Fc7d+Oq8O58KkOHpqUYgFY0otTiEYwRGGj8Sn1HG1ZJ0gl8pJEw9ohosSD5J6Jw4sdRLXa
        5K3CAV/Xio6L8EiRXbLsyzmwjU3+s2NjiifPcJX0c97XVaqYiqlwQqHxkerJxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606220707;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TD1cXptQK69KKX0sVGEJyWh1TykVQLhdRkmPmKU6KG0=;
        b=UimyM5YFEL2Wc/+p5JWLX2mBHQD/HYdl1dJm9tDwjf7sdwj6y8TD+9/nyY6tvKFWx2U2kj
        kz5dB9O11eu/L7Bg==
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Add necessary kernfs_put() calls to
 prevent refcount leak
Cc:     Willem de Bruijn <willemb@google.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1604085088-31707-1-git-send-email-xiaochen.shen@intel.com>
References: <1604085088-31707-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <160622070643.11115.8923839554293015216.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     758999246965eeb8b253d47e72f7bfe508804b16
Gitweb:        https://git.kernel.org/tip/758999246965eeb8b253d47e72f7bfe508804b16
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Sat, 31 Oct 2020 03:11:28 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 24 Nov 2020 12:13:37 +01:00

x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak

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
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 32 +++++++++++++++++++------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 2ab1266..6f4ca4b 100644
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
@@ -529,7 +547,7 @@ static void move_myself(struct callback_head *head)
 	    (rdtgrp->flags & RDT_DELETED)) {
 		current->closid = 0;
 		current->rmid = 0;
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	}
 
 	if (unlikely(current->flags & PF_EXITING))
@@ -2065,8 +2083,7 @@ void rdtgroup_kn_unlock(struct kernfs_node *kn)
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
 		kernfs_unbreak_active_protection(kn);
-		kernfs_put(rdtgrp->kn);
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	} else {
 		kernfs_unbreak_active_protection(kn);
 	}
@@ -2341,7 +2358,7 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 		if (atomic_read(&sentry->waitcount) != 0)
 			sentry->flags = RDT_DELETED;
 		else
-			kfree(sentry);
+			rdtgroup_remove(sentry);
 	}
 }
 
@@ -2383,7 +2400,7 @@ static void rmdir_all_sub(void)
 		if (atomic_read(&rdtgrp->waitcount) != 0)
 			rdtgrp->flags = RDT_DELETED;
 		else
-			kfree(rdtgrp);
+			rdtgroup_remove(rdtgrp);
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
@@ -2818,7 +2835,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
 	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
-	 * which will be dropped inside rdtgroup_kn_unlock().
+	 * which will be dropped by kernfs_put() in rdtgroup_remove().
 	 */
 	kernfs_get(kn);
 
@@ -2859,6 +2876,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 out_idfree:
 	free_rmid(rdtgrp->mon.rmid);
 out_destroy:
+	kernfs_put(rdtgrp->kn);
 	kernfs_remove(rdtgrp->kn);
 out_free_rgrp:
 	kfree(rdtgrp);
@@ -2871,7 +2889,7 @@ static void mkdir_rdt_prepare_clean(struct rdtgroup *rgrp)
 {
 	kernfs_remove(rgrp->kn);
 	free_rmid(rgrp->mon.rmid);
-	kfree(rgrp);
+	rdtgroup_remove(rgrp);
 }
 
 /*
