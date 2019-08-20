Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8BA9617E
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbfHTNry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730141AbfHTNkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:37 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9FA2087E;
        Tue, 20 Aug 2019 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308436;
        bh=Dx3dIR1n5St+t2X3jAAhx6DGC7iGs/duOhnSS0hjN5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggjNXKkSnMPQP6SC5m6H+vXIYh2FkQw0stVpkrW/FQ+WYu3pWmz+4ZBXtnmNlcLTG
         BTMn3FW6OX2U2OIgcNTRn43koHVVLVAMntnV82VpQveR1lhn35WnQhS5UK7DSyzrrx
         2fLSbz2MmhOLOhI7tBJL3cziNuByfcupSrt247FI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 08/44] afs: Fix missing dentry data version updating
Date:   Tue, 20 Aug 2019 09:39:52 -0400
Message-Id: <20190820134028.10829-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9dd0b82ef530cdfe805c9f7079c99e104be59a14 ]

In the in-kernel afs filesystem, the d_fsdata dentry field is used to hold
the data version of the parent directory when it was created or when
d_revalidate() last caused it to be updated.  This is compared to the
->invalid_before field in the directory inode, rather than the actual data
version number, thereby allowing changes due to local edits to be ignored.
Only if the server data version gets bumped unexpectedly (eg. by a
competing client), do we need to revalidate stuff.

However, the d_fsdata field should also be updated if an rpc op is
performed that modifies that particular dentry.  Such ops return the
revised data version of the directory(ies) involved, so we should use that.

This is particularly problematic for rename, since a dentry from one
directory may be moved directly into another directory (ie. mv a/x b/x).
It would then be sporting the wrong data version - and if this is in the
future, for the destination directory, revalidations would be missed,
leading to foreign renames and hard-link deletion being missed.

Fix this by the following means:

 (1) Return the data version number from operations that read the directory
     contents - if they issue the read.  This starts in afs_dir_iterate()
     and is used, ignored or passed back by its callers.

 (2) In afs_lookup*(), set the dentry version to the version returned by
     (1) before d_splice_alias() is called and the dentry published.

 (3) In afs_d_revalidate(), set the dentry version to that returned from
     (1) if an rpc call was issued.  This means that if a parallel
     procedure, such as mkdir(), modifies the directory, we won't
     accidentally use the data version from that.

 (4) In afs_{mkdir,create,link,symlink}(), set the new dentry's version to
     the directory data version before d_instantiate() is called.

 (5) In afs_{rmdir,unlink}, update the target dentry's version to the
     directory data version as soon as we've updated the directory inode.

 (6) In afs_rename(), we need to unhash the old dentry before we start so
     that we don't get afs_d_revalidate() reverting the version change in
     cross-directory renames.

     We then need to set both the old and the new dentry versions the data
     version of the new directory before we call d_move() as d_move() will
     rehash them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 84 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 14 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index b87b41721eaa8..9620f19308f58 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -441,7 +441,7 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
  * iterate through the data blob that lists the contents of an AFS directory
  */
 static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
-			   struct key *key)
+			   struct key *key, afs_dataversion_t *_dir_version)
 {
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct afs_xdr_dir_page *dbuf;
@@ -461,6 +461,7 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 	req = afs_read_dir(dvnode, key);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
+	*_dir_version = req->data_version;
 
 	/* round the file position up to the next entry boundary */
 	ctx->pos += sizeof(union afs_xdr_dirent) - 1;
@@ -515,7 +516,10 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
  */
 static int afs_readdir(struct file *file, struct dir_context *ctx)
 {
-	return afs_dir_iterate(file_inode(file), ctx, afs_file_key(file));
+	afs_dataversion_t dir_version;
+
+	return afs_dir_iterate(file_inode(file), ctx, afs_file_key(file),
+			       &dir_version);
 }
 
 /*
@@ -556,7 +560,8 @@ static int afs_lookup_one_filldir(struct dir_context *ctx, const char *name,
  * - just returns the FID the dentry name maps to if found
  */
 static int afs_do_lookup_one(struct inode *dir, struct dentry *dentry,
-			     struct afs_fid *fid, struct key *key)
+			     struct afs_fid *fid, struct key *key,
+			     afs_dataversion_t *_dir_version)
 {
 	struct afs_super_info *as = dir->i_sb->s_fs_info;
 	struct afs_lookup_one_cookie cookie = {
@@ -569,7 +574,7 @@ static int afs_do_lookup_one(struct inode *dir, struct dentry *dentry,
 	_enter("{%lu},%p{%pd},", dir->i_ino, dentry, dentry);
 
 	/* search the directory */
-	ret = afs_dir_iterate(dir, &cookie.ctx, key);
+	ret = afs_dir_iterate(dir, &cookie.ctx, key, _dir_version);
 	if (ret < 0) {
 		_leave(" = %d [iter]", ret);
 		return ret;
@@ -643,6 +648,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 	struct afs_server *server;
 	struct afs_vnode *dvnode = AFS_FS_I(dir), *vnode;
 	struct inode *inode = NULL, *ti;
+	afs_dataversion_t data_version = READ_ONCE(dvnode->status.data_version);
 	int ret, i;
 
 	_enter("{%lu},%p{%pd},", dir->i_ino, dentry, dentry);
@@ -670,12 +676,14 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 		cookie->fids[i].vid = as->volume->vid;
 
 	/* search the directory */
-	ret = afs_dir_iterate(dir, &cookie->ctx, key);
+	ret = afs_dir_iterate(dir, &cookie->ctx, key, &data_version);
 	if (ret < 0) {
 		inode = ERR_PTR(ret);
 		goto out;
 	}
 
+	dentry->d_fsdata = (void *)(unsigned long)data_version;
+
 	inode = ERR_PTR(-ENOENT);
 	if (!cookie->found)
 		goto out;
@@ -969,7 +977,8 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	struct dentry *parent;
 	struct inode *inode;
 	struct key *key;
-	long dir_version, de_version;
+	afs_dataversion_t dir_version;
+	long de_version;
 	int ret;
 
 	if (flags & LOOKUP_RCU)
@@ -1015,20 +1024,20 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	 * on a 32-bit system, we only have 32 bits in the dentry to store the
 	 * version.
 	 */
-	dir_version = (long)dir->status.data_version;
+	dir_version = dir->status.data_version;
 	de_version = (long)dentry->d_fsdata;
-	if (de_version == dir_version)
+	if (de_version == (long)dir_version)
 		goto out_valid_noupdate;
 
-	dir_version = (long)dir->invalid_before;
-	if (de_version - dir_version >= 0)
+	dir_version = dir->invalid_before;
+	if (de_version - (long)dir_version >= 0)
 		goto out_valid;
 
 	_debug("dir modified");
 	afs_stat_v(dir, n_reval);
 
 	/* search the directory for this vnode */
-	ret = afs_do_lookup_one(&dir->vfs_inode, dentry, &fid, key);
+	ret = afs_do_lookup_one(&dir->vfs_inode, dentry, &fid, key, &dir_version);
 	switch (ret) {
 	case 0:
 		/* the filename maps to something */
@@ -1081,7 +1090,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	}
 
 out_valid:
-	dentry->d_fsdata = (void *)dir_version;
+	dentry->d_fsdata = (void *)(unsigned long)dir_version;
 out_valid_noupdate:
 	dput(parent);
 	key_put(key);
@@ -1187,6 +1196,20 @@ static void afs_prep_for_new_inode(struct afs_fs_cursor *fc,
 	iget_data->cb_s_break = fc->cbi->server->cb_s_break;
 }
 
+/*
+ * Note that a dentry got changed.  We need to set d_fsdata to the data version
+ * number derived from the result of the operation.  It doesn't matter if
+ * d_fsdata goes backwards as we'll just revalidate.
+ */
+static void afs_update_dentry_version(struct afs_fs_cursor *fc,
+				      struct dentry *dentry,
+				      struct afs_status_cb *scb)
+{
+	if (fc->ac.error == 0)
+		dentry->d_fsdata =
+			(void *)(unsigned long)scb->status.data_version;
+}
+
 /*
  * create a directory on an AFS filesystem
  */
@@ -1229,6 +1252,7 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		afs_check_for_remote_deletion(&fc, dvnode);
 		afs_vnode_commit_status(&fc, dvnode, fc.cb_break,
 					&data_version, &scb[0]);
+		afs_update_dentry_version(&fc, dentry, &scb[0]);
 		afs_vnode_new_inode(&fc, dentry, &iget_data, &scb[1]);
 		ret = afs_end_vnode_operation(&fc);
 		if (ret < 0)
@@ -1321,6 +1345,7 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 
 		afs_vnode_commit_status(&fc, dvnode, fc.cb_break,
 					&data_version, scb);
+		afs_update_dentry_version(&fc, dentry, scb);
 		ret = afs_end_vnode_operation(&fc);
 		if (ret == 0) {
 			afs_dir_remove_subdir(dentry);
@@ -1462,6 +1487,7 @@ static int afs_unlink(struct inode *dir, struct dentry *dentry)
 					&data_version, &scb[0]);
 		afs_vnode_commit_status(&fc, vnode, fc.cb_break_2,
 					&data_version_2, &scb[1]);
+		afs_update_dentry_version(&fc, dentry, &scb[0]);
 		ret = afs_end_vnode_operation(&fc);
 		if (ret == 0 && !(scb[1].have_status || scb[1].have_error))
 			ret = afs_dir_remove_link(dvnode, dentry, key);
@@ -1530,6 +1556,7 @@ static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		afs_check_for_remote_deletion(&fc, dvnode);
 		afs_vnode_commit_status(&fc, dvnode, fc.cb_break,
 					&data_version, &scb[0]);
+		afs_update_dentry_version(&fc, dentry, &scb[0]);
 		afs_vnode_new_inode(&fc, dentry, &iget_data, &scb[1]);
 		ret = afs_end_vnode_operation(&fc);
 		if (ret < 0)
@@ -1611,6 +1638,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 		afs_vnode_commit_status(&fc, vnode, fc.cb_break_2,
 					NULL, &scb[1]);
 		ihold(&vnode->vfs_inode);
+		afs_update_dentry_version(&fc, dentry, &scb[0]);
 		d_instantiate(dentry, &vnode->vfs_inode);
 
 		mutex_unlock(&vnode->io_lock);
@@ -1690,6 +1718,7 @@ static int afs_symlink(struct inode *dir, struct dentry *dentry,
 		afs_check_for_remote_deletion(&fc, dvnode);
 		afs_vnode_commit_status(&fc, dvnode, fc.cb_break,
 					&data_version, &scb[0]);
+		afs_update_dentry_version(&fc, dentry, &scb[0]);
 		afs_vnode_new_inode(&fc, dentry, &iget_data, &scb[1]);
 		ret = afs_end_vnode_operation(&fc);
 		if (ret < 0)
@@ -1795,6 +1824,17 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
+	/* This bit is potentially nasty as there's a potential race with
+	 * afs_d_revalidate{,_rcu}().  We have to change d_fsdata on the dentry
+	 * to reflect it's new parent's new data_version after the op, but
+	 * d_revalidate may see old_dentry between the op having taken place
+	 * and the version being updated.
+	 *
+	 * So drop the old_dentry for now to make other threads go through
+	 * lookup instead - which we hold a lock against.
+	 */
+	d_drop(old_dentry);
+
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, orig_dvnode, key, true)) {
 		afs_dataversion_t orig_data_version;
@@ -1806,7 +1846,7 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (orig_dvnode != new_dvnode) {
 			if (mutex_lock_interruptible_nested(&new_dvnode->io_lock, 1) < 0) {
 				afs_end_vnode_operation(&fc);
-				goto error_rehash;
+				goto error_rehash_old;
 			}
 			new_data_version = new_dvnode->status.data_version + 1;
 		} else {
@@ -1831,7 +1871,7 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 		ret = afs_end_vnode_operation(&fc);
 		if (ret < 0)
-			goto error_rehash;
+			goto error_rehash_old;
 	}
 
 	if (ret == 0) {
@@ -1857,10 +1897,26 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				drop_nlink(new_inode);
 			spin_unlock(&new_inode->i_lock);
 		}
+
+		/* Now we can update d_fsdata on the dentries to reflect their
+		 * new parent's data_version.
+		 *
+		 * Note that if we ever implement RENAME_EXCHANGE, we'll have
+		 * to update both dentries with opposing dir versions.
+		 */
+		if (new_dvnode != orig_dvnode) {
+			afs_update_dentry_version(&fc, old_dentry, &scb[1]);
+			afs_update_dentry_version(&fc, new_dentry, &scb[1]);
+		} else {
+			afs_update_dentry_version(&fc, old_dentry, &scb[0]);
+			afs_update_dentry_version(&fc, new_dentry, &scb[0]);
+		}
 		d_move(old_dentry, new_dentry);
 		goto error_tmp;
 	}
 
+error_rehash_old:
+	d_rehash(new_dentry);
 error_rehash:
 	if (rehash)
 		d_rehash(rehash);
-- 
2.20.1

