Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AFF217137
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgGGPZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgGGPZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624902065D;
        Tue,  7 Jul 2020 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135514;
        bh=cETobMTfjW3FcUetdTwCtS+A8WEk7VJqGnBu37Pj5mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bejW2gM3zQcG/EpxPLN8ZJHvdDLA9s6UA/fC3kCQjF/o10dYxssaS2uJCQd63OKux
         1qn4dq4LiFdy6JcYa537z/mlIVIVjVYuhoR0F9Mwqyh614MWWPLTzslIl/f3DCSL3L
         h+t2PdVryCV7fDz8p7FHe7MAC4c6dehbi+QsLKrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Luo Xiaogang <lxgrxd@163.com>
Subject: [PATCH 5.7 072/112] nfsd4: fix nfsdfs reference count loop
Date:   Tue,  7 Jul 2020 17:17:17 +0200
Message-Id: <20200707145804.424998034@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 681370f4b00af0fcc65bbfb9f82de526ab7ceb0a ]

We don't drop the reference on the nfsdfs filesystem with
mntput(nn->nfsd_mnt) until nfsd_exit_net(), but that won't be called
until the nfsd module's unloaded, and we can't unload the module as long
as there's a reference on nfsdfs.  So this prevents module unloading.

Fixes: 2c830dd7209b ("nfsd: persist nfsd filesystem across mounts")
Reported-and-Tested-by:  Luo Xiaogang <lxgrxd@163.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  8 +++++++-
 fs/nfsd/nfsctl.c    | 22 ++++++++++++----------
 fs/nfsd/nfsd.h      |  3 +++
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f71e5590967bb..95e459a1dd7dc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7873,9 +7873,14 @@ nfs4_state_start_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int ret;
 
-	ret = nfs4_state_create_net(net);
+	ret = get_nfsdfs(net);
 	if (ret)
 		return ret;
+	ret = nfs4_state_create_net(net);
+	if (ret) {
+		mntput(nn->nfsd_mnt);
+		return ret;
+	}
 	locks_start_grace(net, &nn->nfsd4_manager);
 	nfsd4_client_tracking_init(net);
 	if (nn->track_reclaim_completes && nn->reclaim_str_hashtbl_size == 0)
@@ -7944,6 +7949,7 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
+	mntput(nn->nfsd_mnt);
 }
 
 void
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 71687d99b0901..9b22d857549c3 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1424,6 +1424,18 @@ static struct file_system_type nfsd_fs_type = {
 };
 MODULE_ALIAS_FS("nfsd");
 
+int get_nfsdfs(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct vfsmount *mnt;
+
+	mnt =  vfs_kern_mount(&nfsd_fs_type, SB_KERNMOUNT, "nfsd", NULL);
+	if (IS_ERR(mnt))
+		return PTR_ERR(mnt);
+	nn->nfsd_mnt = mnt;
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 static int create_proc_exports_entry(void)
 {
@@ -1451,7 +1463,6 @@ unsigned int nfsd_net_id;
 static __net_init int nfsd_init_net(struct net *net)
 {
 	int retval;
-	struct vfsmount *mnt;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	retval = nfsd_export_init(net);
@@ -1478,16 +1489,8 @@ static __net_init int nfsd_init_net(struct net *net)
 	init_waitqueue_head(&nn->ntf_wq);
 	seqlock_init(&nn->boot_lock);
 
-	mnt =  vfs_kern_mount(&nfsd_fs_type, SB_KERNMOUNT, "nfsd", NULL);
-	if (IS_ERR(mnt)) {
-		retval = PTR_ERR(mnt);
-		goto out_mount_err;
-	}
-	nn->nfsd_mnt = mnt;
 	return 0;
 
-out_mount_err:
-	nfsd_reply_cache_shutdown(nn);
 out_drc_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
@@ -1500,7 +1503,6 @@ static __net_exit void nfsd_exit_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	mntput(nn->nfsd_mnt);
 	nfsd_reply_cache_shutdown(nn);
 	nfsd_idmap_shutdown(net);
 	nfsd_export_shutdown(net);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 36cdd81b6688a..57c832d1b30fd 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -90,6 +90,8 @@ void		nfsd_destroy(struct net *net);
 
 bool		i_am_nfsd(void);
 
+int get_nfsdfs(struct net *);
+
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
@@ -100,6 +102,7 @@ struct dentry *nfsd_client_mkdir(struct nfsd_net *nn,
 		struct nfsdfs_client *ncl, u32 id, const struct tree_descr *);
 void nfsd_client_rmdir(struct dentry *dentry);
 
+
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 #ifdef CONFIG_NFSD_V2_ACL
 extern const struct svc_version nfsd_acl_version2;
-- 
2.25.1



