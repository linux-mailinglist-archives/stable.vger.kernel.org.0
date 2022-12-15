Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3A64DD4D
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 16:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiLOPJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 10:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiLOPId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 10:08:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305A830F6B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 07:08:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832CB616A9
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 15:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A83FC433D2;
        Thu, 15 Dec 2022 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671116909;
        bh=7eOLCls4k18+fACy16KoO3zoduCoXLHKpTjIyajBmM8=;
        h=Subject:To:Cc:From:Date:From;
        b=nKomZSJmxTsh8ZWZvhp4GE+M/LflYCOM0qkDAL9u65Ghbredk7JZZ8NA/AKoGaKg/
         w9ogQy8cpfUFsx3cb2fefAcWpstCDoOlJGhot+PsXd95EeJtoN2gxsFsPe6r3DjjpX
         auPg1l9E7QxtPV1Dc+uJTswDgr32v1vmUSlOQ4l4=
Subject: FAILED: patch "[PATCH] cgroup: Reorganize css_set_lock and kernfs path processing" failed to apply to 5.15-stable tree
To:     mkoutny@suse.com, dan.carpenter@oracle.com, tj@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Dec 2022 16:08:18 +0100
Message-ID: <1671116898115241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

46307fd6e27a ("cgroup: Reorganize css_set_lock and kernfs path processing")
4534dee94105 ("cgroup: cgroup: Honor caller's cgroup NS when resolving cgroup id")
74e4b956eb1c ("cgroup: Honor caller's cgroup NS when resolving path")
e210a89f5b07 ("cgroup.c: add helper __cset_cgroup_from_root to cleanup duplicated codes")
be288169712f ("cgroup: reduce dependency on cgroup_mutex")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46307fd6e27a3f678a1678b02e667678c22aa8cc Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Date: Mon, 10 Oct 2022 10:29:18 +0200
Subject: [PATCH] cgroup: Reorganize css_set_lock and kernfs path processing
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The commit 74e4b956eb1c incorrectly wrapped kernfs_walk_and_get
(might_sleep) under css_set_lock (spinlock). css_set_lock is needed by
__cset_cgroup_from_root to ensure stable cset->cgrp_links but not for
kernfs_walk_and_get.

We only need to make sure that the returned root_cgrp won't be freed
under us. This is given in the case of global root because it is static
(cgrp_dfl_root.cgrp). When the root_cgrp is lower in the hierarchy, it
is pinned by cgroup_ns->root_cset (and `current` task cannot switch
namespace asynchronously so ns_proxy pins cgroup_ns).

Note this reasoning won't hold for root cgroups in v1 hierarchies,
therefore create a special-cased helper function just for the default
hierarchy.

Fixes: 74e4b956eb1c ("cgroup: Honor caller's cgroup NS when resolving path")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 764bdd5fd8d1..ecf409e3c3a7 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1392,6 +1392,9 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_free_root(root);
 }
 
+/*
+ * Returned cgroup is without refcount but it's valid as long as cset pins it.
+ */
 static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
 {
@@ -1403,6 +1406,7 @@ static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
 		res_cgroup = cset->dfl_cgrp;
 	} else {
 		struct cgrp_cset_link *link;
+		lockdep_assert_held(&css_set_lock);
 
 		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
 			struct cgroup *c = link->cgrp;
@@ -1414,6 +1418,7 @@ static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
 		}
 	}
 
+	BUG_ON(!res_cgroup);
 	return res_cgroup;
 }
 
@@ -1436,23 +1441,36 @@ current_cgns_cgroup_from_root(struct cgroup_root *root)
 
 	rcu_read_unlock();
 
-	BUG_ON(!res);
 	return res;
 }
 
+/*
+ * Look up cgroup associated with current task's cgroup namespace on the default
+ * hierarchy.
+ *
+ * Unlike current_cgns_cgroup_from_root(), this doesn't need locks:
+ * - Internal rcu_read_lock is unnecessary because we don't dereference any rcu
+ *   pointers.
+ * - css_set_lock is not needed because we just read cset->dfl_cgrp.
+ * - As a bonus returned cgrp is pinned with the current because it cannot
+ *   switch cgroup_ns asynchronously.
+ */
+static struct cgroup *current_cgns_cgroup_dfl(void)
+{
+	struct css_set *cset;
+
+	cset = current->nsproxy->cgroup_ns->root_cset;
+	return __cset_cgroup_from_root(cset, &cgrp_dfl_root);
+}
+
 /* look up cgroup associated with given css_set on the specified hierarchy */
 static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
 {
-	struct cgroup *res = NULL;
-
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_lock);
 
-	res = __cset_cgroup_from_root(cset, root);
-
-	BUG_ON(!res);
-	return res;
+	return __cset_cgroup_from_root(cset, root);
 }
 
 /*
@@ -6105,9 +6123,7 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	if (!cgrp)
 		return ERR_PTR(-ENOENT);
 
-	spin_lock_irq(&css_set_lock);
-	root_cgrp = current_cgns_cgroup_from_root(&cgrp_dfl_root);
-	spin_unlock_irq(&css_set_lock);
+	root_cgrp = current_cgns_cgroup_dfl();
 	if (!cgroup_is_descendant(cgrp, root_cgrp)) {
 		cgroup_put(cgrp);
 		return ERR_PTR(-ENOENT);
@@ -6686,10 +6702,8 @@ struct cgroup *cgroup_get_from_path(const char *path)
 	struct cgroup *cgrp = ERR_PTR(-ENOENT);
 	struct cgroup *root_cgrp;
 
-	spin_lock_irq(&css_set_lock);
-	root_cgrp = current_cgns_cgroup_from_root(&cgrp_dfl_root);
+	root_cgrp = current_cgns_cgroup_dfl();
 	kn = kernfs_walk_and_get(root_cgrp->kn, path);
-	spin_unlock_irq(&css_set_lock);
 	if (!kn)
 		goto out;
 

