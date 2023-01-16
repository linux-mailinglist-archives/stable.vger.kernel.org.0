Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936BD66C95F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjAPQt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbjAPQsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:48:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2253030B0A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACF02B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183F7C433EF;
        Mon, 16 Jan 2023 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886950;
        bh=SaKxcX090vV8uGZHwGfqMmClVocNkCdg45iVhDMIJDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yShI4sbkreb5vMtRwCd5j7Ohiuw9wybxFDnGh3IaIuGObXG0c8dgBs0sM3h2plGhO
         WMxTPHoq5PtDrkTHROvz9m4RuRRd/Fz6ryBBQDVvUASQ9FOJHPVBPYVwf78ot5JWXS
         zYdAEg5aJMplM8taasRSnqQjSdRuphOeMzFrHqdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 624/658] quota: Factor out setup of quota inode
Date:   Mon, 16 Jan 2023 16:51:52 +0100
Message-Id: <20230116154938.033874843@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit c7d3d28360fdb3ed3a5aa0bab19315e0fdc994a1 ]

Factor out setting up of quota inode and eventual error cleanup from
vfs_load_quota_inode(). This will simplify situation for filesystems
that don't have any quota inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: d32387748476 ("ext4: fix bug_on in __es_tree_search caused by bad quota inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c         | 108 ++++++++++++++++++++++++---------------
 include/linux/quotaops.h |   2 +
 2 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dc5f8654b277..84f61ab05890 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2306,28 +2306,60 @@ EXPORT_SYMBOL(dquot_quota_off);
  *	Turn quotas on on a device
  */
 
-/*
- * Helper function to turn quotas on when we already have the inode of
- * quota file and no quota information is loaded.
- */
-static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
+static int vfs_setup_quota_inode(struct inode *inode, int type)
+{
+	struct super_block *sb = inode->i_sb;
+	struct quota_info *dqopt = sb_dqopt(sb);
+
+	if (!S_ISREG(inode->i_mode))
+		return -EACCES;
+	if (IS_RDONLY(inode))
+		return -EROFS;
+	if (sb_has_quota_loaded(sb, type))
+		return -EBUSY;
+
+	dqopt->files[type] = igrab(inode);
+	if (!dqopt->files[type])
+		return -EIO;
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		/* We don't want quota and atime on quota files (deadlocks
+		 * possible) Also nobody should write to the file - we use
+		 * special IO operations which ignore the immutable bit. */
+		inode_lock(inode);
+		inode->i_flags |= S_NOQUOTA;
+		inode_unlock(inode);
+		/*
+		 * When S_NOQUOTA is set, remove dquot references as no more
+		 * references can be added
+		 */
+		__dquot_drop(inode);
+	}
+	return 0;
+}
+
+static void vfs_cleanup_quota_inode(struct super_block *sb, int type)
+{
+	struct quota_info *dqopt = sb_dqopt(sb);
+	struct inode *inode = dqopt->files[type];
+
+	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
+		inode_lock(inode);
+		inode->i_flags &= ~S_NOQUOTA;
+		inode_unlock(inode);
+	}
+	dqopt->files[type] = NULL;
+	iput(inode);
+}
+
+int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	unsigned int flags)
 {
 	struct quota_format_type *fmt = find_quota_format(format_id);
-	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int error;
 
 	if (!fmt)
 		return -ESRCH;
-	if (!S_ISREG(inode->i_mode)) {
-		error = -EACCES;
-		goto out_fmt;
-	}
-	if (IS_RDONLY(inode)) {
-		error = -EROFS;
-		goto out_fmt;
-	}
 	if (!sb->s_op->quota_write || !sb->s_op->quota_read ||
 	    (type == PRJQUOTA && sb->dq_op->get_projid == NULL)) {
 		error = -EINVAL;
@@ -2359,27 +2391,9 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		invalidate_bdev(sb->s_bdev);
 	}
 
-	if (!(dqopt->flags & DQUOT_QUOTA_SYS_FILE)) {
-		/* We don't want quota and atime on quota files (deadlocks
-		 * possible) Also nobody should write to the file - we use
-		 * special IO operations which ignore the immutable bit. */
-		inode_lock(inode);
-		inode->i_flags |= S_NOQUOTA;
-		inode_unlock(inode);
-		/*
-		 * When S_NOQUOTA is set, remove dquot references as no more
-		 * references can be added
-		 */
-		__dquot_drop(inode);
-	}
-
-	error = -EIO;
-	dqopt->files[type] = igrab(inode);
-	if (!dqopt->files[type])
-		goto out_file_flags;
 	error = -EINVAL;
 	if (!fmt->qf_ops->check_quota_file(sb, type))
-		goto out_file_init;
+		goto out_fmt;
 
 	dqopt->ops[type] = fmt->qf_ops;
 	dqopt->info[type].dqi_format = fmt;
@@ -2387,7 +2401,7 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	INIT_LIST_HEAD(&dqopt->info[type].dqi_dirty_list);
 	error = dqopt->ops[type]->read_file_info(sb, type);
 	if (error < 0)
-		goto out_file_init;
+		goto out_fmt;
 	if (dqopt->flags & DQUOT_QUOTA_SYS_FILE) {
 		spin_lock(&dq_data_lock);
 		dqopt->info[type].dqi_flags |= DQF_SYS_FILE;
@@ -2402,18 +2416,30 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		dquot_disable(sb, type, flags);
 
 	return error;
-out_file_init:
-	dqopt->files[type] = NULL;
-	iput(inode);
-out_file_flags:
-	inode_lock(inode);
-	inode->i_flags &= ~S_NOQUOTA;
-	inode_unlock(inode);
 out_fmt:
 	put_quota_format(fmt);
 
 	return error;
 }
+EXPORT_SYMBOL(dquot_load_quota_sb);
+
+/*
+ * Helper function to turn quotas on when we already have the inode of
+ * quota file and no quota information is loaded.
+ */
+static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
+	unsigned int flags)
+{
+	int err;
+
+	err = vfs_setup_quota_inode(inode, type);
+	if (err < 0)
+		return err;
+	err = dquot_load_quota_sb(inode->i_sb, type, format_id, flags);
+	if (err < 0)
+		vfs_cleanup_quota_inode(inode->i_sb, type);
+	return err;
+}
 
 /* Reenable quotas on remount RW */
 int dquot_resume(struct super_block *sb, int type)
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 91e0b7624053..ec10897f7f60 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -99,6 +99,8 @@ int dquot_file_open(struct inode *inode, struct file *file);
 
 int dquot_enable(struct inode *inode, int type, int format_id,
 	unsigned int flags);
+int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
+	unsigned int flags);
 int dquot_quota_on(struct super_block *sb, int type, int format_id,
 	const struct path *path);
 int dquot_quota_on_mount(struct super_block *sb, char *qf_name,
-- 
2.35.1



