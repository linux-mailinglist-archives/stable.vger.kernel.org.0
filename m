Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1181B4073
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgDVKqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbgDVKRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFC92070B;
        Wed, 22 Apr 2020 10:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550628;
        bh=VTe4mnvx5+YzhPhTvVQi6IhlZm9D9rXHch/3VZrzXAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9EeFMO5pQwgSkpr9qc22Xs2ZHQupIx65bwC/MbcnLRIxlIi3Z2Vu4iLlFBQEIdkE
         sLioHb7wqNh9Rh2oFnYF2+2KsDc0Q9L3AXg/hQlD1JNzQYfdaAln8bw5FSiSxWYjGv
         am0tJda9hqgJTf1Y9j/UrwJdJ+A5CSv0CsjpB9tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 028/118] afs: Fix race between post-modification dir edit and readdir/d_revalidate
Date:   Wed, 22 Apr 2020 11:56:29 +0200
Message-Id: <20200422095036.502406124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 2105c2820d366b76f38e6ad61c75771881ecc532 upstream.

AFS directories are retained locally as a structured file, with lookup
being effected by a local search of the file contents.  When a modification
(such as mkdir) happens, the dir file content is modified locally rather
than redownloading the directory.

The directory contents are accessed in a number of ways, with a number of
different locks schemes:

 (1) Download of contents - dvnode->validate_lock/write in afs_read_dir().

 (2) Lookup and readdir - dvnode->validate_lock/read in afs_dir_iterate(),
     downgrading from (1) if necessary.

 (3) d_revalidate of child dentry - dvnode->validate_lock/read in
     afs_do_lookup_one() downgrading from (1) if necessary.

 (4) Edit of dir after modification - page locks on individual dir pages.

Unfortunately, because (4) uses different locking scheme to (1) - (3),
nothing protects against the page being scanned whilst the edit is
underway.  Even download is not safe as it doesn't lock the pages - relying
instead on the validate_lock to serialise as a whole (the theory being that
directory contents are treated as a block and always downloaded as a
block).

Fix this by write-locking dvnode->validate_lock around the edits.  Care
must be taken in the rename case as there may be two different dirs - but
they need not be locked at the same time.  In any case, once the lock is
taken, the directory version must be rechecked, and the edit skipped if a
later version has been downloaded by revalidation (there can't have been
any local changes because the VFS holds the inode lock, but there can have
been remote changes).

Fixes: 63a4681ff39c ("afs: Locally edit directory data for mkdir/create/unlink/...")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/dir.c       |   91 ++++++++++++++++++++++++++++++++++++-----------------
 fs/afs/dir_silly.c |   22 ++++++++----
 2 files changed, 77 insertions(+), 36 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1275,6 +1275,7 @@ static int afs_mkdir(struct inode *dir,
 	struct afs_fs_cursor fc;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	mode |= S_IFDIR;
@@ -1295,7 +1296,7 @@ static int afs_mkdir(struct inode *dir,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1316,10 +1317,14 @@ static int afs_mkdir(struct inode *dir,
 		goto error_key;
 	}
 
-	if (ret == 0 &&
-	    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
-		afs_edit_dir_add(dvnode, &dentry->d_name, &iget_data.fid,
-				 afs_edit_dir_for_create);
+	if (ret == 0) {
+		down_write(&dvnode->validate_lock);
+		if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+		    dvnode->status.data_version == data_version)
+			afs_edit_dir_add(dvnode, &dentry->d_name, &iget_data.fid,
+					 afs_edit_dir_for_create);
+		up_write(&dvnode->validate_lock);
+	}
 
 	key_put(key);
 	kfree(scb);
@@ -1360,6 +1365,7 @@ static int afs_rmdir(struct inode *dir,
 	struct afs_fs_cursor fc;
 	struct afs_vnode *dvnode = AFS_FS_I(dir), *vnode = NULL;
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%pd}",
@@ -1391,7 +1397,7 @@ static int afs_rmdir(struct inode *dir,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1404,9 +1410,12 @@ static int afs_rmdir(struct inode *dir,
 		ret = afs_end_vnode_operation(&fc);
 		if (ret == 0) {
 			afs_dir_remove_subdir(dentry);
-			if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
+			down_write(&dvnode->validate_lock);
+			if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+			    dvnode->status.data_version == data_version)
 				afs_edit_dir_remove(dvnode, &dentry->d_name,
 						    afs_edit_dir_for_rmdir);
+			up_write(&dvnode->validate_lock);
 		}
 	}
 
@@ -1544,10 +1553,15 @@ static int afs_unlink(struct inode *dir,
 		ret = afs_end_vnode_operation(&fc);
 		if (ret == 0 && !(scb[1].have_status || scb[1].have_error))
 			ret = afs_dir_remove_link(dvnode, dentry, key);
-		if (ret == 0 &&
-		    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
-			afs_edit_dir_remove(dvnode, &dentry->d_name,
-					    afs_edit_dir_for_unlink);
+
+		if (ret == 0) {
+			down_write(&dvnode->validate_lock);
+			if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+			    dvnode->status.data_version == data_version)
+				afs_edit_dir_remove(dvnode, &dentry->d_name,
+						    afs_edit_dir_for_unlink);
+			up_write(&dvnode->validate_lock);
+		}
 	}
 
 	if (need_rehash && ret < 0 && ret != -ENOENT)
@@ -1573,6 +1587,7 @@ static int afs_create(struct inode *dir,
 	struct afs_status_cb *scb;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	mode |= S_IFREG;
@@ -1597,7 +1612,7 @@ static int afs_create(struct inode *dir,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1618,9 +1633,12 @@ static int afs_create(struct inode *dir,
 		goto error_key;
 	}
 
-	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
+	down_write(&dvnode->validate_lock);
+	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+	    dvnode->status.data_version == data_version)
 		afs_edit_dir_add(dvnode, &dentry->d_name, &iget_data.fid,
 				 afs_edit_dir_for_create);
+	up_write(&dvnode->validate_lock);
 
 	kfree(scb);
 	key_put(key);
@@ -1648,6 +1666,7 @@ static int afs_link(struct dentry *from,
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct afs_vnode *vnode = AFS_FS_I(d_inode(from));
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%llx:%llu},{%pd}",
@@ -1672,7 +1691,7 @@ static int afs_link(struct dentry *from,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		if (mutex_lock_interruptible_nested(&vnode->io_lock, 1) < 0) {
 			afs_end_vnode_operation(&fc);
@@ -1702,9 +1721,12 @@ static int afs_link(struct dentry *from,
 		goto error_key;
 	}
 
-	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
+	down_write(&dvnode->validate_lock);
+	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+	    dvnode->status.data_version == data_version)
 		afs_edit_dir_add(dvnode, &dentry->d_name, &vnode->fid,
 				 afs_edit_dir_for_link);
+	up_write(&dvnode->validate_lock);
 
 	key_put(key);
 	kfree(scb);
@@ -1732,6 +1754,7 @@ static int afs_symlink(struct inode *dir
 	struct afs_status_cb *scb;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%pd},%s",
@@ -1759,7 +1782,7 @@ static int afs_symlink(struct inode *dir
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1780,9 +1803,12 @@ static int afs_symlink(struct inode *dir
 		goto error_key;
 	}
 
-	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
+	down_write(&dvnode->validate_lock);
+	if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+	    dvnode->status.data_version == data_version)
 		afs_edit_dir_add(dvnode, &dentry->d_name, &iget_data.fid,
 				 afs_edit_dir_for_symlink);
+	up_write(&dvnode->validate_lock);
 
 	key_put(key);
 	kfree(scb);
@@ -1812,6 +1838,8 @@ static int afs_rename(struct inode *old_
 	struct dentry *tmp = NULL, *rehash = NULL;
 	struct inode *new_inode;
 	struct key *key;
+	afs_dataversion_t orig_data_version;
+	afs_dataversion_t new_data_version;
 	bool new_negative = d_is_negative(new_dentry);
 	int ret;
 
@@ -1890,9 +1918,6 @@ static int afs_rename(struct inode *old_
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, orig_dvnode, key, true)) {
-		afs_dataversion_t orig_data_version;
-		afs_dataversion_t new_data_version;
-
 		orig_data_version = orig_dvnode->status.data_version + 1;
 
 		if (orig_dvnode != new_dvnode) {
@@ -1928,18 +1953,25 @@ static int afs_rename(struct inode *old_
 	if (ret == 0) {
 		if (rehash)
 			d_rehash(rehash);
-		if (test_bit(AFS_VNODE_DIR_VALID, &orig_dvnode->flags))
-		    afs_edit_dir_remove(orig_dvnode, &old_dentry->d_name,
-					afs_edit_dir_for_rename_0);
-
-		if (!new_negative &&
-		    test_bit(AFS_VNODE_DIR_VALID, &new_dvnode->flags))
-			afs_edit_dir_remove(new_dvnode, &new_dentry->d_name,
-					    afs_edit_dir_for_rename_1);
+		down_write(&orig_dvnode->validate_lock);
+		if (test_bit(AFS_VNODE_DIR_VALID, &orig_dvnode->flags) &&
+		    orig_dvnode->status.data_version == orig_data_version)
+			afs_edit_dir_remove(orig_dvnode, &old_dentry->d_name,
+					    afs_edit_dir_for_rename_0);
+		if (orig_dvnode != new_dvnode) {
+			up_write(&orig_dvnode->validate_lock);
+
+			down_write(&new_dvnode->validate_lock);
+		}
+		if (test_bit(AFS_VNODE_DIR_VALID, &new_dvnode->flags) &&
+		    orig_dvnode->status.data_version == new_data_version) {
+			if (!new_negative)
+				afs_edit_dir_remove(new_dvnode, &new_dentry->d_name,
+						    afs_edit_dir_for_rename_1);
 
-		if (test_bit(AFS_VNODE_DIR_VALID, &new_dvnode->flags))
 			afs_edit_dir_add(new_dvnode, &new_dentry->d_name,
 					 &vnode->fid, afs_edit_dir_for_rename_2);
+		}
 
 		new_inode = d_inode(new_dentry);
 		if (new_inode) {
@@ -1958,6 +1990,7 @@ static int afs_rename(struct inode *old_
 		afs_update_dentry_version(&fc, old_dentry, &scb[1]);
 		afs_update_dentry_version(&fc, new_dentry, &scb[1]);
 		d_move(old_dentry, new_dentry);
+		up_write(&new_dvnode->validate_lock);
 		goto error_tmp;
 	}
 
--- a/fs/afs/dir_silly.c
+++ b/fs/afs/dir_silly.c
@@ -21,6 +21,7 @@ static int afs_do_silly_rename(struct af
 {
 	struct afs_fs_cursor fc;
 	struct afs_status_cb *scb;
+	afs_dataversion_t dir_data_version;
 	int ret = -ERESTARTSYS;
 
 	_enter("%pd,%pd", old, new);
@@ -31,7 +32,7 @@ static int afs_do_silly_rename(struct af
 
 	trace_afs_silly_rename(vnode, false);
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t dir_data_version = dvnode->status.data_version + 1;
+		dir_data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -54,12 +55,15 @@ static int afs_do_silly_rename(struct af
 			dvnode->silly_key = key_get(key);
 		}
 
-		if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
+		down_write(&dvnode->validate_lock);
+		if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+		    dvnode->status.data_version == dir_data_version) {
 			afs_edit_dir_remove(dvnode, &old->d_name,
 					    afs_edit_dir_for_silly_0);
-		if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
 			afs_edit_dir_add(dvnode, &new->d_name,
 					 &vnode->fid, afs_edit_dir_for_silly_1);
+		}
+		up_write(&dvnode->validate_lock);
 	}
 
 	kfree(scb);
@@ -181,10 +185,14 @@ static int afs_do_silly_unlink(struct af
 				clear_bit(AFS_VNODE_CB_PROMISED, &vnode->flags);
 			}
 		}
-		if (ret == 0 &&
-		    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
-			afs_edit_dir_remove(dvnode, &dentry->d_name,
-					    afs_edit_dir_for_unlink);
+		if (ret == 0) {
+			down_write(&dvnode->validate_lock);
+			if (test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) &&
+			    dvnode->status.data_version == dir_data_version)
+				afs_edit_dir_remove(dvnode, &dentry->d_name,
+						    afs_edit_dir_for_unlink);
+			up_write(&dvnode->validate_lock);
+		}
 	}
 
 	kfree(scb);


