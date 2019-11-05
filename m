Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB64F033F
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390335AbfKEQon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:44:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:41610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390346AbfKEQol (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D55CDB23A;
        Tue,  5 Nov 2019 16:44:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3885E1E4AAB; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 05/25] ext4: Do not iput inode under running transaction
Date:   Tue,  5 Nov 2019 17:44:11 +0100
Message-Id: <20191105164437.32602-5-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When ext4_mkdir(), ext4_symlink(), ext4_create(), or ext4_mknod() fail
to add entry into directory, it ends up dropping freshly created inode
under the running transaction and thus inode truncation happens under
that transaction. That breaks assumptions that evict() does not get
called from a transaction context and at least in ext4_symlink() case it
can result in inode eviction deadlocking in inode_wait_for_writeback()
when flush worker finds symlink inode, starts to write it back and
blocks on starting a transaction. So change the code in ext4_mkdir() and
ext4_add_nondir() to drop inode reference only after the transaction is
stopped. We also have to add inode to the orphan list in that case as
otherwise the inode would get leaked in case we crash before inode
deletion is committed.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 97cf1c8b56b2..a67cae3c8ff5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2547,21 +2547,29 @@ static void ext4_dec_count(handle_t *handle, struct inode *inode)
 }
 
 
+/*
+ * Add non-directory inode to a directory. On success, the inode reference is
+ * consumed by dentry is instantiation. This is also indicated by clearing of
+ * *inodep pointer. On failure, the caller is responsible for dropping the
+ * inode reference in the safe context.
+ */
 static int ext4_add_nondir(handle_t *handle,
-		struct dentry *dentry, struct inode *inode)
+		struct dentry *dentry, struct inode **inodep)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
+	struct inode *inode = *inodep;
 	int err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
 		ext4_mark_inode_dirty(handle, inode);
 		if (IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
 		d_instantiate_new(dentry, inode);
+		*inodep = NULL;
 		return 0;
 	}
 	drop_nlink(inode);
+	ext4_orphan_add(handle, inode);
 	unlock_new_inode(inode);
-	iput(inode);
 	return err;
 }
 
@@ -2595,10 +2603,12 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
-		err = ext4_add_nondir(handle, dentry, inode);
+		err = ext4_add_nondir(handle, dentry, &inode);
 	}
 	if (handle)
 		ext4_journal_stop(handle);
+	if (!IS_ERR_OR_NULL(inode))
+		iput(inode);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -2625,10 +2635,12 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
 		inode->i_op = &ext4_special_inode_operations;
-		err = ext4_add_nondir(handle, dentry, inode);
+		err = ext4_add_nondir(handle, dentry, &inode);
 	}
 	if (handle)
 		ext4_journal_stop(handle);
+	if (!IS_ERR_OR_NULL(inode))
+		iput(inode);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -2778,10 +2790,12 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (err) {
 out_clear_inode:
 		clear_nlink(inode);
+		ext4_orphan_add(handle, inode);
 		unlock_new_inode(inode);
 		ext4_mark_inode_dirty(handle, inode);
+		ext4_journal_stop(handle);
 		iput(inode);
-		goto out_stop;
+		goto out_retry;
 	}
 	ext4_inc_count(handle, dir);
 	ext4_update_dx_flag(dir);
@@ -2795,6 +2809,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 out_stop:
 	if (handle)
 		ext4_journal_stop(handle);
+out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -3327,9 +3342,11 @@ static int ext4_symlink(struct inode *dir,
 		inode->i_size = disk_link.len - 1;
 	}
 	EXT4_I(inode)->i_disksize = inode->i_size;
-	err = ext4_add_nondir(handle, dentry, inode);
+	err = ext4_add_nondir(handle, dentry, &inode);
 	if (handle)
 		ext4_journal_stop(handle);
+	if (inode)
+		iput(inode);
 	goto out_free_encrypted_link;
 
 err_drop_inode:
-- 
2.16.4

