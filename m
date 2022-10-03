Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF67F5F2A05
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiJCH33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiJCH3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30C6CC4;
        Mon,  3 Oct 2022 00:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C402860F9E;
        Mon,  3 Oct 2022 07:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D997BC433C1;
        Mon,  3 Oct 2022 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781464;
        bh=7jf8lxbFWIJq9EwMInVoh7BkFcPx5cCsy/iCviXCE0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXz6tf2p2/qmRY400k9f6fmbsCwG8c+Rv/M7DWXd8Qm6eRCTnYD7rdLArosClJyuG
         lGWBXXUpG5TnRe1d2q0dYJfXyG3gwHjy4kQWc8kaKRllwZCKqj8v6nAGSxmOhHdqBa
         MA3hN0J7ONTILYoDQkhM8Vxj6efsU1/mhHhYXxFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/83] cgroup: reduce dependency on cgroup_mutex
Date:   Mon,  3 Oct 2022 09:10:30 +0200
Message-Id: <20221003070722.118445218@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit be288169712f3dea0bc6b50c00b3ab53d85f1435 ]

Currently cgroup_get_from_path() and cgroup_get_from_id() grab
cgroup_mutex before traversing the default hierarchy to find the
kernfs_node corresponding to the path/id and then extract the linked
cgroup. Since cgroup_mutex is still held, it is guaranteed that the
cgroup will be alive and the reference can be taken on it.

However similar guarantee can be provided without depending on the
cgroup_mutex and potentially reducing avenues of cgroup_mutex contentions.
The kernfs_node's priv pointer is RCU protected pointer and with just
rcu read lock we can grab the reference on the cgroup without
cgroup_mutex. So, remove cgroup_mutex from them.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: df02452f3df0 ("cgroup: cgroup_get_from_id() must check the looked-up kn is a directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 51 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 75c3881af078..97282d6b5d18 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6021,17 +6021,20 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	struct kernfs_node *kn;
 	struct cgroup *cgrp = NULL;
 
-	mutex_lock(&cgroup_mutex);
 	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
-		goto out_unlock;
+		goto out;
+
+	rcu_read_lock();
 
-	cgrp = kn->priv;
-	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (cgrp && !cgroup_tryget(cgrp))
 		cgrp = NULL;
+
+	rcu_read_unlock();
+
 	kernfs_put(kn);
-out_unlock:
-	mutex_unlock(&cgroup_mutex);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_id);
@@ -6585,30 +6588,34 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
  *
  * Find the cgroup at @path on the default hierarchy, increment its
  * reference count and return it.  Returns pointer to the found cgroup on
- * success, ERR_PTR(-ENOENT) if @path doesn't exist and ERR_PTR(-ENOTDIR)
- * if @path points to a non-directory.
+ * success, ERR_PTR(-ENOENT) if @path doesn't exist or if the cgroup has already
+ * been released and ERR_PTR(-ENOTDIR) if @path points to a non-directory.
  */
 struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
-	struct cgroup *cgrp;
-
-	mutex_lock(&cgroup_mutex);
+	struct cgroup *cgrp = ERR_PTR(-ENOENT);
 
 	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
-	if (kn) {
-		if (kernfs_type(kn) == KERNFS_DIR) {
-			cgrp = kn->priv;
-			cgroup_get_live(cgrp);
-		} else {
-			cgrp = ERR_PTR(-ENOTDIR);
-		}
-		kernfs_put(kn);
-	} else {
-		cgrp = ERR_PTR(-ENOENT);
+	if (!kn)
+		goto out;
+
+	if (kernfs_type(kn) != KERNFS_DIR) {
+		cgrp = ERR_PTR(-ENOTDIR);
+		goto out_kernfs;
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	rcu_read_lock();
+
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (!cgrp || !cgroup_tryget(cgrp))
+		cgrp = ERR_PTR(-ENOENT);
+
+	rcu_read_unlock();
+
+out_kernfs:
+	kernfs_put(kn);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
-- 
2.35.1



