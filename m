Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCEB540DF9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348213AbiFGSvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354620AbiFGSrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A2366A3;
        Tue,  7 Jun 2022 11:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46820618DE;
        Tue,  7 Jun 2022 18:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B9AC385A5;
        Tue,  7 Jun 2022 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624955;
        bh=PU9uh3rClWw6uB3MVdt2U8NRohynfHhGPod8jVgggrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKwoBQ2YlHGY43P88QJ9f+Pw4rTG2Cynnu9LmmVwQUTF1XXnJlHJ03SAmVlVxd42n
         6yOuriUS+CsAyhThZ2HnsB7sKNLvlI37PD8lqwfc1oF8DDKFoXg2gEIeS5IE+boS9J
         7rZGXTWaxtwhvnHrqsOpH47RWVMqTC7fE7WzQv/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/667] NFS: Create a new nfs_alloc_fattr_with_label() function
Date:   Tue,  7 Jun 2022 19:02:58 +0200
Message-Id: <20220607164950.089796084@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit d755ad8dc752d44545613ea04d660aed674e540d ]

For creating fattrs with the label field already allocated for us. I
also update nfs_free_fattr() to free the label in the end.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/getroot.c       | 17 ++++++-----------
 fs/nfs/inode.c         | 17 +++++++++++++++++
 fs/nfs/internal.h      |  9 ---------
 include/linux/nfs_fs.h | 13 +++++++++++++
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 59355c106ece..7604cb6a0ac2 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -80,18 +80,15 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 		goto out;
 
 	/* get the actual root for this mount */
-	fsinfo.fattr = nfs_alloc_fattr();
+	fsinfo.fattr = nfs_alloc_fattr_with_label(server);
 	if (fsinfo.fattr == NULL)
 		goto out_name;
 
-	fsinfo.fattr->label = nfs4_label_alloc(server, GFP_KERNEL);
-	if (IS_ERR(fsinfo.fattr->label))
-		goto out_fattr;
 	error = server->nfs_client->rpc_ops->getroot(server, ctx->mntfh, &fsinfo);
 	if (error < 0) {
 		dprintk("nfs_get_root: getattr error = %d\n", -error);
 		nfs_errorf(fc, "NFS: Couldn't getattr on root");
-		goto out_label;
+		goto out_fattr;
 	}
 
 	inode = nfs_fhget(s, ctx->mntfh, fsinfo.fattr, NULL);
@@ -99,12 +96,12 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 		dprintk("nfs_get_root: get root inode failed\n");
 		error = PTR_ERR(inode);
 		nfs_errorf(fc, "NFS: Couldn't get root inode");
-		goto out_label;
+		goto out_fattr;
 	}
 
 	error = nfs_superblock_set_dummy_root(s, inode);
 	if (error != 0)
-		goto out_label;
+		goto out_fattr;
 
 	/* root dentries normally start off anonymous and get spliced in later
 	 * if the dentry tree reaches them; however if the dentry already
@@ -115,7 +112,7 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 		dprintk("nfs_get_root: get root dentry failed\n");
 		error = PTR_ERR(root);
 		nfs_errorf(fc, "NFS: Couldn't get root dentry");
-		goto out_label;
+		goto out_fattr;
 	}
 
 	security_d_instantiate(root, inode);
@@ -154,8 +151,6 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 	nfs_setsecurity(inode, fsinfo.fattr, fsinfo.fattr->label);
 	error = 0;
 
-out_label:
-	nfs4_label_free(fsinfo.fattr->label);
 out_fattr:
 	nfs_free_fattr(fsinfo.fattr);
 out_name:
@@ -165,5 +160,5 @@ int nfs_get_root(struct super_block *s, struct fs_context *fc)
 error_splat_root:
 	dput(fc->root);
 	fc->root = NULL;
-	goto out_label;
+	goto out_fattr;
 }
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4ed75673adf6..b60c57f6f723 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1589,6 +1589,23 @@ struct nfs_fattr *nfs_alloc_fattr(void)
 }
 EXPORT_SYMBOL_GPL(nfs_alloc_fattr);
 
+struct nfs_fattr *nfs_alloc_fattr_with_label(struct nfs_server *server)
+{
+	struct nfs_fattr *fattr = nfs_alloc_fattr();
+
+	if (!fattr)
+		return NULL;
+
+	fattr->label = nfs4_label_alloc(server, GFP_NOFS);
+	if (IS_ERR(fattr->label)) {
+		kfree(fattr);
+		return NULL;
+	}
+
+	return fattr;
+}
+EXPORT_SYMBOL_GPL(nfs_alloc_fattr_with_label);
+
 struct nfs_fh *nfs_alloc_fhandle(void)
 {
 	struct nfs_fh *fh;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index fbfe293af72c..2ceb4b98ec15 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -351,14 +351,6 @@ nfs4_label_copy(struct nfs4_label *dst, struct nfs4_label *src)
 
 	return dst;
 }
-static inline void nfs4_label_free(struct nfs4_label *label)
-{
-	if (label) {
-		kfree(label->label);
-		kfree(label);
-	}
-	return;
-}
 
 static inline void nfs_zap_label_cache_locked(struct nfs_inode *nfsi)
 {
@@ -367,7 +359,6 @@ static inline void nfs_zap_label_cache_locked(struct nfs_inode *nfsi)
 }
 #else
 static inline struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags) { return NULL; }
-static inline void nfs4_label_free(void *label) {}
 static inline void nfs_zap_label_cache_locked(struct nfs_inode *nfsi)
 {
 }
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 5ffcde9ac413..66b6cc24ab8c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -421,9 +421,22 @@ extern void nfs_fattr_set_barrier(struct nfs_fattr *fattr);
 extern unsigned long nfs_inc_attr_generation_counter(void);
 
 extern struct nfs_fattr *nfs_alloc_fattr(void);
+extern struct nfs_fattr *nfs_alloc_fattr_with_label(struct nfs_server *server);
+
+static inline void nfs4_label_free(struct nfs4_label *label)
+{
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+	if (label) {
+		kfree(label->label);
+		kfree(label);
+	}
+#endif
+}
 
 static inline void nfs_free_fattr(const struct nfs_fattr *fattr)
 {
+	if (fattr)
+		nfs4_label_free(fattr->label);
 	kfree(fattr);
 }
 
-- 
2.35.1



