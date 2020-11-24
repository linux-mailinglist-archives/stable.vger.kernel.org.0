Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652782C25A1
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgKXMZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 07:25:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43058 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733022AbgKXMZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 07:25:11 -0500
Date:   Tue, 24 Nov 2020 12:25:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606220708;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6PTdIXUwgO4+to+Hmlg/nX1OGP4X+Fps2bjz4MmJus=;
        b=KhMgjq4kW6Ob3IawXXv1Vuxy/7nhOcpVL8RYKQtzhjycH8W1yATD/50PBcC+oHVDvWc1eq
        mMcOqtxcje9gQ9HMKR4L3PCIYx79pgp1ZO0MMtoyRe4Z7edKoMTMGKL2+IVEa+1kO4UUwR
        FbGollVkrZ/j3SI3KcAybYHZtWGdz6BR+tUz65NhmkJL/52hmTrEzYVk/8IiYB81aJ+W+v
        y6J75RdUHEe1bb29wK0itv5wr0CZeQZTb5sOH+c5yb3VG1TKdOV3NVMBo2x2bM+LHNWC/W
        bfIEVQnJh4Rf9rJLpDAjrPC9dZWzpyHDvFExA9txu2DktdUeOIo9PZPzHg6law==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606220708;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6PTdIXUwgO4+to+Hmlg/nX1OGP4X+Fps2bjz4MmJus=;
        b=lYP7eDcoivb2K1VljWm5biJ+SatV3lIW45rz0XVdqmcdfmDiHzm3cqus3fUCeVnAeyF5Ma
        A599EWv+XIs0t3BQ==
From:   "tip-bot2 for Xiaochen Shen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Remove superfluous kernfs_get() calls
 to prevent refcount leak
Cc:     Willem de Bruijn <willemb@google.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1604085053-31639-1-git-send-email-xiaochen.shen@intel.com>
References: <1604085053-31639-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Message-ID: <160622070719.11115.17631622807765497130.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     fd8d9db3559a29fd737bcdb7c4fcbe1940caae34
Gitweb:        https://git.kernel.org/tip/fd8d9db3559a29fd737bcdb7c4fcbe1940caae34
Author:        Xiaochen Shen <xiaochen.shen@intel.com>
AuthorDate:    Sat, 31 Oct 2020 03:10:53 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 24 Nov 2020 12:03:04 +01:00

x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak

Willem reported growing of kernfs_node_cache entries in slabtop when
repeatedly creating and removing resctrl subdirectories as well as when
repeatedly mounting and unmounting the resctrl filesystem.

On resource group (control as well as monitoring) creation via a mkdir
an extra kernfs_node reference is obtained to ensure that the rdtgroup
structure remains accessible for the rdtgroup_kn_unlock() calls where it
is removed on deletion. The kernfs_node reference count is dropped by
kernfs_put() in rdtgroup_kn_unlock().

With the above explaining the need for one kernfs_get()/kernfs_put()
pair in resctrl there are more places where a kernfs_node reference is
obtained without a corresponding release. The excessive amount of
reference count on kernfs nodes will never be dropped to 0 and the
kernfs nodes will never be freed in the call paths of rmdir and umount.
It leads to reference count leak and kernfs_node_cache memory leak.

Remove the superfluous kernfs_get() calls and expand the existing
comments surrounding the remaining kernfs_get()/kernfs_put() pair that
remains in use.

Superfluous kernfs_get() calls are removed from two areas:

  (1) In call paths of mount and mkdir, when kernfs nodes for "info",
  "mon_groups" and "mon_data" directories and sub-directories are
  created, the reference count of newly created kernfs node is set to 1.
  But after kernfs_create_dir() returns, superfluous kernfs_get() are
  called to take an additional reference.

  (2) kernfs_get() calls in rmdir call paths.

Fixes: 17eafd076291 ("x86/intel_rdt: Split resource group removal in two")
Fixes: 4af4a88e0c92 ("x86/intel_rdt/cqm: Add mount,umount support")
Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: d89b7379015f ("x86/intel_rdt/cqm: Add mon_data")
Fixes: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring")
Fixes: 5dc1d5c6bac2 ("x86/intel_rdt: Simplify info and base file lists")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Fixes: 4e978d06dedb ("x86/intel_rdt: Add "info" files to resctrl file system")
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Willem de Bruijn <willemb@google.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1604085053-31639-1-git-send-email-xiaochen.shen@intel.com
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 35 +------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index af323e2..2ab1266 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1769,7 +1769,6 @@ static int rdtgroup_mkdir_info_resdir(struct rdt_resource *r, char *name,
 	if (IS_ERR(kn_subdir))
 		return PTR_ERR(kn_subdir);
 
-	kernfs_get(kn_subdir);
 	ret = rdtgroup_kn_set_ugid(kn_subdir);
 	if (ret)
 		return ret;
@@ -1792,7 +1791,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	kn_info = kernfs_create_dir(parent_kn, "info", parent_kn->mode, NULL);
 	if (IS_ERR(kn_info))
 		return PTR_ERR(kn_info);
-	kernfs_get(kn_info);
 
 	ret = rdtgroup_add_files(kn_info, RF_TOP_INFO);
 	if (ret)
@@ -1813,12 +1811,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 			goto out_destroy;
 	}
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that @rdtgrp->kn is always accessible.
-	 */
-	kernfs_get(kn_info);
-
 	ret = rdtgroup_kn_set_ugid(kn_info);
 	if (ret)
 		goto out_destroy;
@@ -1847,12 +1839,6 @@ mongroup_create_dir(struct kernfs_node *parent_kn, struct rdtgroup *prgrp,
 	if (dest_kn)
 		*dest_kn = kn;
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that @rdtgrp->kn is always accessible.
-	 */
-	kernfs_get(kn);
-
 	ret = rdtgroup_kn_set_ugid(kn);
 	if (ret)
 		goto out_destroy;
@@ -2139,13 +2125,11 @@ static int rdt_get_tree(struct fs_context *fc)
 					  &kn_mongrp);
 		if (ret < 0)
 			goto out_info;
-		kernfs_get(kn_mongrp);
 
 		ret = mkdir_mondata_all(rdtgroup_default.kn,
 					&rdtgroup_default, &kn_mondata);
 		if (ret < 0)
 			goto out_mongrp;
-		kernfs_get(kn_mondata);
 		rdtgroup_default.mon.mon_data_kn = kn_mondata;
 	}
 
@@ -2499,11 +2483,6 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (IS_ERR(kn))
 		return PTR_ERR(kn);
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that kn is always accessible.
-	 */
-	kernfs_get(kn);
 	ret = rdtgroup_kn_set_ugid(kn);
 	if (ret)
 		goto out_destroy;
@@ -2838,8 +2817,8 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	/*
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
-	 * rdtgroup_kn_unlock(kn} call below. Take one extra reference
-	 * here, which will be dropped inside rdtgroup_kn_unlock().
+	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
+	 * which will be dropped inside rdtgroup_kn_unlock().
 	 */
 	kernfs_get(kn);
 
@@ -3049,11 +3028,6 @@ static int rdtgroup_rmdir_mon(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	WARN_ON(list_empty(&prdtgrp->mon.crdtgrp_list));
 	list_del(&rdtgrp->mon.crdtgrp_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 
 	return 0;
@@ -3065,11 +3039,6 @@ static int rdtgroup_ctrl_remove(struct kernfs_node *kn,
 	rdtgrp->flags = RDT_DELETED;
 	list_del(&rdtgrp->rdtgroup_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 	return 0;
 }
