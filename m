Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A98657845
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiL1OtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiL1Os7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C53A11C0F;
        Wed, 28 Dec 2022 06:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B82E96154C;
        Wed, 28 Dec 2022 14:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACFBC433D2;
        Wed, 28 Dec 2022 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238927;
        bh=ESG6vHWQHNMYMbMpucgd91WJcm2wFIVVf8wyRKGpZJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bch8OHr6NaF4/WFyMIcjVbfvsBk0tD3KgTuIWpzZ94aX36xzV2JQvb3s3Vn/Mmszn
         3vHgmNcGVU5PKa+DuYaBuZe05+3h8eCo7MmSYcckcve0BuLSVccCiHdW8weJGlgMsL
         DxnG/PzhVYZGzp4PD7smjQ/xQrT6b5PcAAe1/mpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-unionfs@vger.kernel.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/731] ovl: store lower path in ovl_inode
Date:   Wed, 28 Dec 2022 15:32:50 +0100
Message-Id: <20221228144258.379288348@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ffa5723c6d259b3191f851a50a98d0352b345b39 ]

Create some ovl_i_* helpers to get real path from ovl inode. Instead of
just stashing struct inode for the lower layer we stash struct path for
the lower layer. The helpers allow to retrieve a struct path for the
relevant upper or lower layer. This will be used when retrieving
information based on struct inode when copying up inode attributes from
upper or lower inodes to ovl inodes and when checking permissions in
ovl_permission() in following patches. This is needed to support
idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: b306e90ffabd ("ovl: remove privs in ovl_copyfile()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c     | 11 +++++++----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     |  5 +++--
 fs/overlayfs/util.c      | 15 ++++++++++++++-
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1f36158c7dbe..06479bc88b7e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -777,13 +777,16 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		    unsigned long ino, int fsid)
 {
 	struct inode *realinode;
+	struct ovl_inode *oi = OVL_I(inode);
 
 	if (oip->upperdentry)
-		OVL_I(inode)->__upperdentry = oip->upperdentry;
-	if (oip->lowerpath && oip->lowerpath->dentry)
-		OVL_I(inode)->lower = igrab(d_inode(oip->lowerpath->dentry));
+		oi->__upperdentry = oip->upperdentry;
+	if (oip->lowerpath && oip->lowerpath->dentry) {
+		oi->lowerpath.dentry = dget(oip->lowerpath->dentry);
+		oi->lowerpath.layer = oip->lowerpath->layer;
+	}
 	if (oip->lowerdata)
-		OVL_I(inode)->lowerdata = igrab(d_inode(oip->lowerdata));
+		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
 	realinode = ovl_inode_real(inode);
 	ovl_copyattr(realinode, inode);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2cd5741c873b..27f221962665 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -293,10 +293,12 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
+void ovl_i_path_real(struct inode *inode, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
+const struct ovl_layer *ovl_i_layer_lower(struct inode *inode);
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 63efee554f69..b2d64f3c974b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -129,7 +129,7 @@ struct ovl_inode {
 	unsigned long flags;
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
-	struct inode *lower;
+	struct ovl_path lowerpath;
 
 	/* synchronize copy up and more */
 	struct mutex lock;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9837aaf9caf1..e2ed38c5f721 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -184,7 +184,8 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->version = 0;
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
-	oi->lower = NULL;
+	oi->lowerpath.dentry = NULL;
+	oi->lowerpath.layer = NULL;
 	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
@@ -205,7 +206,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
-	iput(oi->lower);
+	dput(oi->lowerpath.dentry);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f48284a2a896..2567918dc684 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -236,6 +236,17 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 	return ovl_upperdentry_dereference(OVL_I(inode));
 }
 
+void ovl_i_path_real(struct inode *inode, struct path *path)
+{
+	path->dentry = ovl_i_dentry_upper(inode);
+	if (!path->dentry) {
+		path->dentry = OVL_I(inode)->lowerpath.dentry;
+		path->mnt = OVL_I(inode)->lowerpath.layer->mnt;
+	} else {
+		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
+	}
+}
+
 struct inode *ovl_inode_upper(struct inode *inode)
 {
 	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
@@ -245,7 +256,9 @@ struct inode *ovl_inode_upper(struct inode *inode)
 
 struct inode *ovl_inode_lower(struct inode *inode)
 {
-	return OVL_I(inode)->lower;
+	struct dentry *lowerdentry = OVL_I(inode)->lowerpath.dentry;
+
+	return lowerdentry ? d_inode(lowerdentry) : NULL;
 }
 
 struct inode *ovl_inode_real(struct inode *inode)
-- 
2.35.1



