Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5900A2C8A6D
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgK3REx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:04:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:63171 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgK3REw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 12:04:52 -0500
IronPort-SDR: WUiJLErhkPhQpT+GkuuLa8rXy9V9wIvuM+UkT5pDtHwRwV1Y62qK+oAgjZPA9/AK4eCr+iJMRp
 CByixA4AywNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160442850"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="160442850"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:03:57 -0800
IronPort-SDR: 4ZiKvRpimBg/9VzKB3qjSRvZL6ipdNVexk2k65mUqTBpexRx6g52W4hB6U/+MwFXUvuRDhHnm5
 R5viNrnTOikw==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549177804"
Received: from xshen14-linux.bj.intel.com ([10.238.155.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:03:54 -0800
From:   Xiaochen Shen <xiaochen.shen@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, bp@suse.de, reinette.chatre@intel.com,
        willemb@google.com
Cc:     tony.luck@intel.com, fenghua.yu@intel.com, pei.p.jia@intel.com,
        xiaochen.shen@intel.com
Subject: [PATCH 4.14 1/2] x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak
Date:   Tue,  1 Dec 2020 01:27:08 +0800
Message-Id: <1606757228-9555-1-git-send-email-xiaochen.shen@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606725284182232@kroah.com>
References: <1606725284182232@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fd8d9db3559a29fd737bcdb7c4fcbe1940caae34 upstream.

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

Backporting notes:

Since upstream commit fa7d949337cc ("x86/resctrl: Rename and move rdt
files to a separate directory"), the file
arch/x86/kernel/cpu/intel_rdt_rdtgroup.c has been renamed and moved to
arch/x86/kernel/cpu/resctrl/rdtgroup.c.
Apply the change against file arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
for older stable trees.

Upstream commit 17eafd076291 ("x86/intel_rdt: Split resource group
removal in two") moved part of resource group removal code from
rdtgroup_rmdir_ctrl() into a separate function rdtgroup_ctrl_remove().
Apply the change against original code base of rdtgroup_rmdir_ctrl() for
older stable trees.

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
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 35 ++------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index 60c63b2..a61d64c 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -830,7 +830,6 @@ static int rdtgroup_mkdir_info_resdir(struct rdt_resource *r, char *name,
 	if (IS_ERR(kn_subdir))
 		return PTR_ERR(kn_subdir);
 
-	kernfs_get(kn_subdir);
 	ret = rdtgroup_kn_set_ugid(kn_subdir);
 	if (ret)
 		return ret;
@@ -853,7 +852,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	kn_info = kernfs_create_dir(parent_kn, "info", parent_kn->mode, NULL);
 	if (IS_ERR(kn_info))
 		return PTR_ERR(kn_info);
-	kernfs_get(kn_info);
 
 	for_each_alloc_enabled_rdt_resource(r) {
 		fflags =  r->fflags | RF_CTRL_INFO;
@@ -870,12 +868,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
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
@@ -904,12 +896,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
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
@@ -1178,7 +1164,6 @@ static struct dentry *rdt_mount(struct file_system_type *fs_type,
 			dentry = ERR_PTR(ret);
 			goto out_info;
 		}
-		kernfs_get(kn_mongrp);
 
 		ret = mkdir_mondata_all(rdtgroup_default.kn,
 					&rdtgroup_default, &kn_mondata);
@@ -1186,7 +1171,6 @@ static struct dentry *rdt_mount(struct file_system_type *fs_type,
 			dentry = ERR_PTR(ret);
 			goto out_mongrp;
 		}
-		kernfs_get(kn_mondata);
 		rdtgroup_default.mon.mon_data_kn = kn_mondata;
 	}
 
@@ -1461,11 +1445,6 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
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
@@ -1626,8 +1605,8 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	/*
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
-	 * rdtgroup_kn_unlock(kn} call below. Take one extra reference
-	 * here, which will be dropped inside rdtgroup_kn_unlock().
+	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
+	 * which will be dropped inside rdtgroup_kn_unlock().
 	 */
 	kernfs_get(kn);
 
@@ -1839,11 +1818,6 @@ static int rdtgroup_rmdir_mon(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	WARN_ON(list_empty(&prdtgrp->mon.crdtgrp_list));
 	list_del(&rdtgrp->mon.crdtgrp_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 
 	return 0;
@@ -1880,11 +1854,6 @@ static int rdtgroup_rmdir_ctrl(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 
 	list_del(&rdtgrp->rdtgroup_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 
 	/*
-- 
1.8.3.1

