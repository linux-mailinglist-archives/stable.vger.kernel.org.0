Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CF64F39CA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378727AbiDELiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353966AbiDEKKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC052C5580;
        Tue,  5 Apr 2022 02:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5284261676;
        Tue,  5 Apr 2022 09:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60968C385A2;
        Tue,  5 Apr 2022 09:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152558;
        bh=eXvdArci5dS83ntGOoIJW7117iZdjc7XU61qBlsZ9Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/MvePSoU+rkkcKExbxFHbIRtF35hBStfFXASDrYHvhTWSddVv000FpByPdyefhjh
         hftGC60Wh2qvD5SGmLmUXSl1q7cwYbalmrc/XZgriBs/yyN6e7RUEo3WwgMTCXjlWH
         euBNiqUcH/17LmXs3S6qr0WrtCk3QbDEtbesw7ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 819/913] ubifs: Rename whiteout atomically
Date:   Tue,  5 Apr 2022 09:31:21 +0200
Message-Id: <20220405070404.380941623@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 278d9a243635f26c05ad95dcf9c5a593b9e04dc6 upstream.

Currently, rename whiteout has 3 steps:
  1. create tmpfile(which associates old dentry to tmpfile inode) for
     whiteout, and store tmpfile to disk
  2. link whiteout, associate whiteout inode to old dentry agagin and
     store old dentry, old inode, new dentry on disk
  3. writeback dirty whiteout inode to disk

Suddenly power-cut or error occurring(eg. ENOSPC returned by budget,
memory allocation failure) during above steps may cause kinds of problems:
  Problem 1: ENOSPC returned by whiteout space budget (before step 2),
	     old dentry will disappear after rename syscall, whiteout file
	     cannot be found either.

	     ls dir  // we get file, whiteout
	     rename(dir/file, dir/whiteout, REANME_WHITEOUT)
	     ENOSPC = ubifs_budget_space(&wht_req) // return
	     ls dir  // empty (no file, no whiteout)
  Problem 2: Power-cut happens before step 3, whiteout inode with 'nlink=1'
	     is not stored on disk, whiteout dentry(old dentry) is written
	     on disk, whiteout file is lost on next mount (We get "dead
	     directory entry" after executing 'ls -l' on whiteout file).

Now, we use following 3 steps to finish rename whiteout:
  1. create an in-mem inode with 'nlink = 1' as whiteout
  2. ubifs_jnl_rename (Write on disk to finish associating old dentry to
     whiteout inode, associating new dentry with old inode)
  3. iput(whiteout)

Rely writing in-mem inode on disk by ubifs_jnl_rename() to finish rename
whiteout, which avoids middle disk state caused by suddenly power-cut
and error occurring.

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c     |  144 +++++++++++++++++++++++++++++++++--------------------
 fs/ubifs/journal.c |   52 ++++++++++++++++---
 2 files changed, 136 insertions(+), 60 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -349,8 +349,56 @@ out_budg:
 	return err;
 }
 
-static int do_tmpfile(struct inode *dir, struct dentry *dentry,
-		      umode_t mode, struct inode **whiteout)
+static struct inode *create_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+	umode_t mode = S_IFCHR | WHITEOUT_MODE;
+	struct inode *inode;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct fscrypt_name nm;
+
+	/*
+	 * Create an inode('nlink = 1') for whiteout without updating journal,
+	 * let ubifs_jnl_rename() store it on flash to complete rename whiteout
+	 * atomically.
+	 */
+
+	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
+		dentry, mode, dir->i_ino);
+
+	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
+	if (err)
+		return ERR_PTR(err);
+
+	inode = ubifs_new_inode(c, dir, mode);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_free;
+	}
+
+	init_special_inode(inode, inode->i_mode, WHITEOUT_DEV);
+	ubifs_assert(c, inode->i_op == &ubifs_file_inode_operations);
+
+	err = ubifs_init_security(dir, inode, &dentry->d_name);
+	if (err)
+		goto out_inode;
+
+	/* The dir size is updated by do_rename. */
+	insert_inode_hash(inode);
+
+	return inode;
+
+out_inode:
+	make_bad_inode(inode);
+	iput(inode);
+out_free:
+	fscrypt_free_filename(&nm);
+	ubifs_err(c, "cannot create whiteout file, error %d", err);
+	return ERR_PTR(err);
+}
+
+static int ubifs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
+			 struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
@@ -392,25 +440,13 @@ static int do_tmpfile(struct inode *dir,
 	}
 	ui = ubifs_inode(inode);
 
-	if (whiteout) {
-		init_special_inode(inode, inode->i_mode, WHITEOUT_DEV);
-		ubifs_assert(c, inode->i_op == &ubifs_file_inode_operations);
-	}
-
 	err = ubifs_init_security(dir, inode, &dentry->d_name);
 	if (err)
 		goto out_inode;
 
 	mutex_lock(&ui->ui_mutex);
 	insert_inode_hash(inode);
-
-	if (whiteout) {
-		mark_inode_dirty(inode);
-		drop_nlink(inode);
-		*whiteout = inode;
-	} else {
-		d_tmpfile(dentry, inode);
-	}
+	d_tmpfile(dentry, inode);
 	ubifs_assert(c, ui->dirty);
 
 	instantiated = 1;
@@ -432,8 +468,6 @@ out_inode:
 	make_bad_inode(inode);
 	if (!instantiated)
 		iput(inode);
-	else if (whiteout)
-		iput(*whiteout);
 out_budg:
 	ubifs_release_budget(c, &req);
 	if (!instantiated)
@@ -443,12 +477,6 @@ out_budg:
 	return err;
 }
 
-static int ubifs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
-			 struct dentry *dentry, umode_t mode)
-{
-	return do_tmpfile(dir, dentry, mode, NULL);
-}
-
 /**
  * vfs_dent_type - get VFS directory entry type.
  * @type: UBIFS directory entry type
@@ -1266,17 +1294,19 @@ static int do_rename(struct inode *old_d
 					.dirtied_ino = 3 };
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
+	struct ubifs_budget_req wht_req;
 	struct timespec64 time;
 	unsigned int saved_nlink;
 	struct fscrypt_name old_nm, new_nm;
 
 	/*
-	 * Budget request settings: deletion direntry, new direntry, removing
-	 * the old inode, and changing old and new parent directory inodes.
+	 * Budget request settings:
+	 *   req: deletion direntry, new direntry, removing the old inode,
+	 *   and changing old and new parent directory inodes.
+	 *
+	 *   wht_req: new whiteout inode for RENAME_WHITEOUT.
 	 *
-	 * However, this operation also marks the target inode as dirty and
-	 * does not write it, so we allocate budget for the target inode
-	 * separately.
+	 *   ino_req: marks the target inode as dirty and does not write it.
 	 */
 
 	dbg_gen("dent '%pd' ino %lu in dir ino %lu to dent '%pd' in dir ino %lu flags 0x%x",
@@ -1326,7 +1356,6 @@ static int do_rename(struct inode *old_d
 
 	if (flags & RENAME_WHITEOUT) {
 		union ubifs_dev_desc *dev = NULL;
-		struct ubifs_budget_req wht_req;
 
 		dev = kmalloc(sizeof(union ubifs_dev_desc), GFP_NOFS);
 		if (!dev) {
@@ -1334,24 +1363,26 @@ static int do_rename(struct inode *old_d
 			goto out_release;
 		}
 
-		err = do_tmpfile(old_dir, old_dentry, S_IFCHR | WHITEOUT_MODE, &whiteout);
-		if (err) {
+		/*
+		 * The whiteout inode without dentry is pinned in memory,
+		 * umount won't happen during rename process because we
+		 * got parent dentry.
+		 */
+		whiteout = create_whiteout(old_dir, old_dentry);
+		if (IS_ERR(whiteout)) {
+			err = PTR_ERR(whiteout);
 			kfree(dev);
 			goto out_release;
 		}
 
-		spin_lock(&whiteout->i_lock);
-		whiteout->i_state |= I_LINKABLE;
-		spin_unlock(&whiteout->i_lock);
-
 		whiteout_ui = ubifs_inode(whiteout);
 		whiteout_ui->data = dev;
 		whiteout_ui->data_len = ubifs_encode_dev(dev, MKDEV(0, 0));
 		ubifs_assert(c, !whiteout_ui->dirty);
 
 		memset(&wht_req, 0, sizeof(struct ubifs_budget_req));
-		wht_req.dirtied_ino = 1;
-		wht_req.dirtied_ino_d = ALIGN(whiteout_ui->data_len, 8);
+		wht_req.new_ino = 1;
+		wht_req.new_ino_d = ALIGN(whiteout_ui->data_len, 8);
 		/*
 		 * To avoid deadlock between space budget (holds ui_mutex and
 		 * waits wb work) and writeback work(waits ui_mutex), do space
@@ -1359,6 +1390,11 @@ static int do_rename(struct inode *old_d
 		 */
 		err = ubifs_budget_space(c, &wht_req);
 		if (err) {
+			/*
+			 * Whiteout inode can not be written on flash by
+			 * ubifs_jnl_write_inode(), because it's neither
+			 * dirty nor zero-nlink.
+			 */
 			iput(whiteout);
 			goto out_release;
 		}
@@ -1433,17 +1469,11 @@ static int do_rename(struct inode *old_d
 		sync = IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir);
 		if (unlink && IS_SYNC(new_inode))
 			sync = 1;
-	}
-
-	if (whiteout) {
-		inc_nlink(whiteout);
-		mark_inode_dirty(whiteout);
-
-		spin_lock(&whiteout->i_lock);
-		whiteout->i_state &= ~I_LINKABLE;
-		spin_unlock(&whiteout->i_lock);
-
-		iput(whiteout);
+		/*
+		 * S_SYNC flag of whiteout inherits from the old_dir, and we
+		 * have already checked the old dir inode. So there is no need
+		 * to check whiteout.
+		 */
 	}
 
 	err = ubifs_jnl_rename(c, old_dir, old_inode, &old_nm, new_dir,
@@ -1454,6 +1484,11 @@ static int do_rename(struct inode *old_d
 	unlock_4_inodes(old_dir, new_dir, new_inode, whiteout);
 	ubifs_release_budget(c, &req);
 
+	if (whiteout) {
+		ubifs_release_budget(c, &wht_req);
+		iput(whiteout);
+	}
+
 	mutex_lock(&old_inode_ui->ui_mutex);
 	release = old_inode_ui->dirty;
 	mark_inode_dirty_sync(old_inode);
@@ -1462,11 +1497,16 @@ static int do_rename(struct inode *old_d
 	if (release)
 		ubifs_release_budget(c, &ino_req);
 	if (IS_SYNC(old_inode))
-		err = old_inode->i_sb->s_op->write_inode(old_inode, NULL);
+		/*
+		 * Rename finished here. Although old inode cannot be updated
+		 * on flash, old ctime is not a big problem, don't return err
+		 * code to userspace.
+		 */
+		old_inode->i_sb->s_op->write_inode(old_inode, NULL);
 
 	fscrypt_free_filename(&old_nm);
 	fscrypt_free_filename(&new_nm);
-	return err;
+	return 0;
 
 out_cancel:
 	if (unlink) {
@@ -1487,11 +1527,11 @@ out_cancel:
 				inc_nlink(old_dir);
 		}
 	}
+	unlock_4_inodes(old_dir, new_dir, new_inode, whiteout);
 	if (whiteout) {
-		drop_nlink(whiteout);
+		ubifs_release_budget(c, &wht_req);
 		iput(whiteout);
 	}
-	unlock_4_inodes(old_dir, new_dir, new_inode, whiteout);
 out_release:
 	ubifs_release_budget(c, &ino_req);
 	ubifs_release_budget(c, &req);
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -1207,9 +1207,9 @@ out_free:
  * @sync: non-zero if the write-buffer has to be synchronized
  *
  * This function implements the re-name operation which may involve writing up
- * to 4 inodes and 2 directory entries. It marks the written inodes as clean
- * and returns zero on success. In case of failure, a negative error code is
- * returned.
+ * to 4 inodes(new inode, whiteout inode, old and new parent directory inodes)
+ * and 2 directory entries. It marks the written inodes as clean and returns
+ * zero on success. In case of failure, a negative error code is returned.
  */
 int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 		     const struct inode *old_inode,
@@ -1222,14 +1222,15 @@ int ubifs_jnl_rename(struct ubifs_info *
 	void *p;
 	union ubifs_key key;
 	struct ubifs_dent_node *dent, *dent2;
-	int err, dlen1, dlen2, ilen, lnum, offs, len, orphan_added = 0;
+	int err, dlen1, dlen2, ilen, wlen, lnum, offs, len, orphan_added = 0;
 	int aligned_dlen1, aligned_dlen2, plen = UBIFS_INO_NODE_SZ;
 	int last_reference = !!(new_inode && new_inode->i_nlink == 0);
 	int move = (old_dir != new_dir);
-	struct ubifs_inode *new_ui;
+	struct ubifs_inode *new_ui, *whiteout_ui;
 	u8 hash_old_dir[UBIFS_HASH_ARR_SZ];
 	u8 hash_new_dir[UBIFS_HASH_ARR_SZ];
 	u8 hash_new_inode[UBIFS_HASH_ARR_SZ];
+	u8 hash_whiteout_inode[UBIFS_HASH_ARR_SZ];
 	u8 hash_dent1[UBIFS_HASH_ARR_SZ];
 	u8 hash_dent2[UBIFS_HASH_ARR_SZ];
 
@@ -1249,9 +1250,20 @@ int ubifs_jnl_rename(struct ubifs_info *
 	} else
 		ilen = 0;
 
+	if (whiteout) {
+		whiteout_ui = ubifs_inode(whiteout);
+		ubifs_assert(c, mutex_is_locked(&whiteout_ui->ui_mutex));
+		ubifs_assert(c, whiteout->i_nlink == 1);
+		ubifs_assert(c, !whiteout_ui->dirty);
+		wlen = UBIFS_INO_NODE_SZ;
+		wlen += whiteout_ui->data_len;
+	} else
+		wlen = 0;
+
 	aligned_dlen1 = ALIGN(dlen1, 8);
 	aligned_dlen2 = ALIGN(dlen2, 8);
-	len = aligned_dlen1 + aligned_dlen2 + ALIGN(ilen, 8) + ALIGN(plen, 8);
+	len = aligned_dlen1 + aligned_dlen2 + ALIGN(ilen, 8) +
+	      ALIGN(wlen, 8) + ALIGN(plen, 8);
 	if (move)
 		len += plen;
 
@@ -1313,6 +1325,15 @@ int ubifs_jnl_rename(struct ubifs_info *
 		p += ALIGN(ilen, 8);
 	}
 
+	if (whiteout) {
+		pack_inode(c, p, whiteout, 0);
+		err = ubifs_node_calc_hash(c, p, hash_whiteout_inode);
+		if (err)
+			goto out_release;
+
+		p += ALIGN(wlen, 8);
+	}
+
 	if (!move) {
 		pack_inode(c, p, old_dir, 1);
 		err = ubifs_node_calc_hash(c, p, hash_old_dir);
@@ -1352,6 +1373,9 @@ int ubifs_jnl_rename(struct ubifs_info *
 		if (new_inode)
 			ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf,
 						  new_inode->i_ino);
+		if (whiteout)
+			ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf,
+						  whiteout->i_ino);
 	}
 	release_head(c, BASEHD);
 
@@ -1368,8 +1392,6 @@ int ubifs_jnl_rename(struct ubifs_info *
 		err = ubifs_tnc_add_nm(c, &key, lnum, offs, dlen2, hash_dent2, old_nm);
 		if (err)
 			goto out_ro;
-
-		ubifs_delete_orphan(c, whiteout->i_ino);
 	} else {
 		err = ubifs_add_dirt(c, lnum, dlen2);
 		if (err)
@@ -1390,6 +1412,15 @@ int ubifs_jnl_rename(struct ubifs_info *
 		offs += ALIGN(ilen, 8);
 	}
 
+	if (whiteout) {
+		ino_key_init(c, &key, whiteout->i_ino);
+		err = ubifs_tnc_add(c, &key, lnum, offs, wlen,
+				    hash_whiteout_inode);
+		if (err)
+			goto out_ro;
+		offs += ALIGN(wlen, 8);
+	}
+
 	ino_key_init(c, &key, old_dir->i_ino);
 	err = ubifs_tnc_add(c, &key, lnum, offs, plen, hash_old_dir);
 	if (err)
@@ -1410,6 +1441,11 @@ int ubifs_jnl_rename(struct ubifs_info *
 		new_ui->synced_i_size = new_ui->ui_size;
 		spin_unlock(&new_ui->ui_lock);
 	}
+	/*
+	 * No need to mark whiteout inode clean.
+	 * Whiteout doesn't have non-zero size, no need to update
+	 * synced_i_size for whiteout_ui.
+	 */
 	mark_inode_clean(c, ubifs_inode(old_dir));
 	if (move)
 		mark_inode_clean(c, ubifs_inode(new_dir));


