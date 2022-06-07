Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B502540DC4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353964AbiFGSuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354389AbiFGSq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAA42873F;
        Tue,  7 Jun 2022 11:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A31617B0;
        Tue,  7 Jun 2022 18:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F47C385A5;
        Tue,  7 Jun 2022 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624858;
        bh=4ZBKrg277j10J4kfqZX7XizaQzgUZzCFAjO9QyhY8fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQqrQvPDLxtwjwU5f8iidSABlax398+LUqB0kBY5+o9wQKdtjq3AlYv+b/6czrBrg
         4a0SB/6/X13beyIoSpl80Ab60ORH5x7NhSOzS/qYvCt6n8AnSrWppWCGnQwv6IRaGm
         HXz2NBmn2ln22VA2cbOCtB326P3ArLtpFtEaCd7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/667] f2fs: support fault injection for dquot_initialize()
Date:   Tue,  7 Jun 2022 19:02:22 +0200
Message-Id: <20220607164949.008245956@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 10a26878564f27327b12e8f4b4d8d7b43065fae5 ]

This patch adds a new function f2fs_dquot_initialize() to wrap
dquot_initialize(), and it supports to inject fault into
f2fs_dquot_initialize() to simulate inner failure occurs in
dquot_initialize().

Usage:
a) echo 65536 > /sys/fs/f2fs/<dev>/inject_type or
b) mount -o fault_type=65536 <dev> <mountpoint>

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst |  1 +
 fs/f2fs/checkpoint.c               |  2 +-
 fs/f2fs/f2fs.h                     |  2 ++
 fs/f2fs/file.c                     |  6 +++---
 fs/f2fs/inline.c                   |  2 +-
 fs/f2fs/inode.c                    |  2 +-
 fs/f2fs/namei.c                    | 30 +++++++++++++++---------------
 fs/f2fs/recovery.c                 |  6 +++---
 fs/f2fs/super.c                    | 16 ++++++++++++++++
 fs/f2fs/verity.c                   |  2 +-
 fs/f2fs/xattr.c                    |  2 +-
 11 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 09de6ebbbdfa..7fe50b0bccde 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -197,6 +197,7 @@ fault_type=%d		 Support configuring fault injection type, should be
 			 FAULT_DISCARD		  0x000002000
 			 FAULT_WRITE_IO		  0x000004000
 			 FAULT_SLAB_ALLOC	  0x000008000
+			 FAULT_DQUOT_INIT	  0x000010000
 			 ===================	  ===========
 mode=%s			 Control block allocation mode which supports "adaptive"
 			 and "lfs". In "lfs" mode, there should be no random
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 1ff32926e199..70d898ad2d1d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -653,7 +653,7 @@ static int recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 		return PTR_ERR(inode);
 	}
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err) {
 		iput(inode);
 		goto err_out;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0a0fa1a64d06..d775048d4366 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -55,6 +55,7 @@ enum {
 	FAULT_DISCARD,
 	FAULT_WRITE_IO,
 	FAULT_SLAB_ALLOC,
+	FAULT_DQUOT_INIT,
 	FAULT_MAX,
 };
 
@@ -3375,6 +3376,7 @@ static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
  */
 int f2fs_inode_dirtied(struct inode *inode, bool sync);
 void f2fs_inode_synced(struct inode *inode);
+int f2fs_dquot_initialize(struct inode *inode);
 int f2fs_enable_quota_files(struct f2fs_sb_info *sbi, bool rdonly);
 int f2fs_quota_sync(struct super_block *sb, int type);
 loff_t max_file_blocks(struct inode *inode);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8ef92719c679..21dde125ff77 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -786,7 +786,7 @@ int f2fs_truncate(struct inode *inode)
 		return -EIO;
 	}
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		return err;
 
@@ -916,7 +916,7 @@ int f2fs_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		return err;
 
 	if (is_quota_modification(inode, attr)) {
-		err = dquot_initialize(inode);
+		err = f2fs_dquot_initialize(inode);
 		if (err)
 			return err;
 	}
@@ -3023,7 +3023,7 @@ static int f2fs_ioc_setproject(struct inode *inode, __u32 projid)
 	}
 	f2fs_put_page(ipage, 1);
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		return err;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 56a20d5c15da..ea08f0dfa1bd 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -192,7 +192,7 @@ int f2fs_convert_inline_inode(struct inode *inode)
 			f2fs_hw_is_readonly(sbi) || f2fs_readonly(sbi->sb))
 		return 0;
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		return err;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2272000fb10b..a40e52ba5ec8 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -759,7 +759,7 @@ void f2fs_evict_inode(struct inode *inode)
 	if (inode->i_nlink || is_bad_inode(inode))
 		goto no_delete;
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err) {
 		err = 0;
 		set_sbi_flag(sbi, SBI_QUOTA_NEED_REPAIR);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ae0838001480..a728a0af9ce0 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -74,7 +74,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	if (err)
 		goto fail_drop;
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		goto fail_drop;
 
@@ -345,7 +345,7 @@ static int f2fs_create(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!f2fs_is_checkpoint_ready(sbi))
 		return -ENOSPC;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -404,7 +404,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 			F2FS_I(old_dentry->d_inode)->i_projid)))
 		return -EXDEV;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -460,7 +460,7 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 		return 0;
 	}
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -598,10 +598,10 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 		goto fail;
 	}
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		goto fail;
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		goto fail;
 
@@ -675,7 +675,7 @@ static int f2fs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	if (err)
 		return err;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -746,7 +746,7 @@ static int f2fs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	if (unlikely(f2fs_cp_error(sbi)))
 		return -EIO;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -803,7 +803,7 @@ static int f2fs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!f2fs_is_checkpoint_ready(sbi))
 		return -ENOSPC;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -841,7 +841,7 @@ static int __f2fs_tmpfile(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	int err;
 
-	err = dquot_initialize(dir);
+	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
 
@@ -965,16 +965,16 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return err;
 	}
 
-	err = dquot_initialize(old_dir);
+	err = f2fs_dquot_initialize(old_dir);
 	if (err)
 		goto out;
 
-	err = dquot_initialize(new_dir);
+	err = f2fs_dquot_initialize(new_dir);
 	if (err)
 		goto out;
 
 	if (new_inode) {
-		err = dquot_initialize(new_inode);
+		err = f2fs_dquot_initialize(new_inode);
 		if (err)
 			goto out;
 	}
@@ -1138,11 +1138,11 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 			F2FS_I(new_dentry->d_inode)->i_projid)))
 		return -EXDEV;
 
-	err = dquot_initialize(old_dir);
+	err = f2fs_dquot_initialize(old_dir);
 	if (err)
 		goto out;
 
-	err = dquot_initialize(new_dir);
+	err = f2fs_dquot_initialize(new_dir);
 	if (err)
 		goto out;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 04655511d7f5..66b75bc6a60a 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -81,7 +81,7 @@ static struct fsync_inode_entry *add_fsync_inode(struct f2fs_sb_info *sbi,
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		goto err_out;
 
@@ -203,7 +203,7 @@ static int recover_dentry(struct inode *inode, struct page *ipage,
 			goto out_put;
 		}
 
-		err = dquot_initialize(einode);
+		err = f2fs_dquot_initialize(einode);
 		if (err) {
 			iput(einode);
 			goto out_put;
@@ -508,7 +508,7 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
-		ret = dquot_initialize(inode);
+		ret = f2fs_dquot_initialize(inode);
 		if (ret) {
 			iput(inode);
 			return ret;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6dc66b7bc1f5..d41081aae2e5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -58,6 +58,7 @@ const char *f2fs_fault_name[FAULT_MAX] = {
 	[FAULT_DISCARD]		= "discard error",
 	[FAULT_WRITE_IO]	= "write IO error",
 	[FAULT_SLAB_ALLOC]	= "slab alloc",
+	[FAULT_DQUOT_INIT]	= "dquot initialize",
 };
 
 void f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned int rate,
@@ -2535,6 +2536,16 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 	return len - towrite;
 }
 
+int f2fs_dquot_initialize(struct inode *inode)
+{
+	if (time_to_inject(F2FS_I_SB(inode), FAULT_DQUOT_INIT)) {
+		f2fs_show_injection_info(F2FS_I_SB(inode), FAULT_DQUOT_INIT);
+		return -ESRCH;
+	}
+
+	return dquot_initialize(inode);
+}
+
 static struct dquot **f2fs_get_dquots(struct inode *inode)
 {
 	return F2FS_I(inode)->i_dquot;
@@ -2919,6 +2930,11 @@ static const struct quotactl_ops f2fs_quotactl_ops = {
 	.get_nextdqblk	= dquot_get_next_dqblk,
 };
 #else
+int f2fs_dquot_initialize(struct inode *inode)
+{
+	return 0;
+}
+
 int f2fs_quota_sync(struct super_block *sb, int type)
 {
 	return 0;
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 03549b5ba204..fe5acdccaae1 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -136,7 +136,7 @@ static int f2fs_begin_enable_verity(struct file *filp)
 	 * here and not rely on ->open() doing it.  This must be done before
 	 * evicting the inline data.
 	 */
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		return err;
 
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 6a3b3bec7989..797ac505a075 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -782,7 +782,7 @@ int f2fs_setxattr(struct inode *inode, int index, const char *name,
 	if (!f2fs_is_checkpoint_ready(sbi))
 		return -ENOSPC;
 
-	err = dquot_initialize(inode);
+	err = f2fs_dquot_initialize(inode);
 	if (err)
 		return err;
 
-- 
2.35.1



