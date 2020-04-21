Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A41A1B2DEB
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDURPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:15:14 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58261 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbgDURPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:15:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 783A819403CD;
        Tue, 21 Apr 2020 13:15:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NufvgV
        ByGzMBhPll+tz+EpGq8ds3CNhbnR7FMCdUDNM=; b=kOXFW9bZXV3KDVBoj3PEMn
        3DmFfsD4fBX8fXzqoJw4dMzS3PkFOty0SJ6AybGaqHngFS6rgbQDCY4ccSBDmZa7
        Gt+UhgtjeSytor1HgUFNuTNfyz1eEz/ezqonjJo0RITaKIZCUySfuOiye2Oypock
        t8qUigAxL1pTD1O6Cxg75ZWsR8HJNzD5TfrLib1j4y8aSNkTsmZr3BgRxzoxThWe
        PCfEiDgefONaxwqiA6C7/69Wqsj6k9ZB1lpN05PxxmAdjiYF/x/qzQbMDHd49saP
        skFUc6SgR0yruIY2ZGtQfBr0GnQMSG1gW/c1ev1aY3J6kpAmoL1pILgA6hpm3T5w
        ==
X-ME-Sender: <xms:HiqfXqszYvRo_74ve-d7thnrhKho9EizqnIN1_-7qx2ttWdgZic3zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HyqfXv4Z8lK1tDNndBxt3pdhrxUWWNtVpwvM8DeTnvkI09kYKXzcwQ>
    <xmx:HyqfXnPb-bpGAdWt6Q5T36L0Tq6c1AEpEZIgkb4P_evIq-IHYBrACQ>
    <xmx:HyqfXlPpOkw9HE6zxWUk_FXWPI6q5rZzqf505NdAMzJBruHWQzvFHg>
    <xmx:HyqfXsrZ-trmLCz9PASYpjUJEa2mcUsfUCX39EUUDSjzpqqRiUTP1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5D543280063;
        Tue, 21 Apr 2020 13:15:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] afs: Fix race between post-modification dir edit and" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:15:09 +0200
Message-ID: <15874893097686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2105c2820d366b76f38e6ad61c75771881ecc532 Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Fri, 10 Apr 2020 15:23:27 +0100
Subject: [PATCH] afs: Fix race between post-modification dir edit and
 readdir/d_revalidate

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

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 31d297e0f765..d6278616fb88 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1275,6 +1275,7 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct afs_fs_cursor fc;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	mode |= S_IFDIR;
@@ -1295,7 +1296,7 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1316,10 +1317,14 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
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
@@ -1360,6 +1365,7 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct afs_fs_cursor fc;
 	struct afs_vnode *dvnode = AFS_FS_I(dir), *vnode = NULL;
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%pd}",
@@ -1391,7 +1397,7 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1404,9 +1410,12 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
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
 
@@ -1544,10 +1553,15 @@ static int afs_unlink(struct inode *dir, struct dentry *dentry)
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
@@ -1573,6 +1587,7 @@ static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct afs_status_cb *scb;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	mode |= S_IFREG;
@@ -1597,7 +1612,7 @@ static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1618,9 +1633,12 @@ static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
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
@@ -1648,6 +1666,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct afs_vnode *vnode = AFS_FS_I(d_inode(from));
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%llx:%llu},{%pd}",
@@ -1672,7 +1691,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		if (mutex_lock_interruptible_nested(&vnode->io_lock, 1) < 0) {
 			afs_end_vnode_operation(&fc);
@@ -1702,9 +1721,12 @@ static int afs_link(struct dentry *from, struct inode *dir,
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
@@ -1732,6 +1754,7 @@ static int afs_symlink(struct inode *dir, struct dentry *dentry,
 	struct afs_status_cb *scb;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
 	struct key *key;
+	afs_dataversion_t data_version;
 	int ret;
 
 	_enter("{%llx:%llu},{%pd},%s",
@@ -1759,7 +1782,7 @@ static int afs_symlink(struct inode *dir, struct dentry *dentry,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t data_version = dvnode->status.data_version + 1;
+		data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -1780,9 +1803,12 @@ static int afs_symlink(struct inode *dir, struct dentry *dentry,
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
@@ -1812,6 +1838,8 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *tmp = NULL, *rehash = NULL;
 	struct inode *new_inode;
 	struct key *key;
+	afs_dataversion_t orig_data_version;
+	afs_dataversion_t new_data_version;
 	bool new_negative = d_is_negative(new_dentry);
 	int ret;
 
@@ -1890,9 +1918,6 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	ret = -ERESTARTSYS;
 	if (afs_begin_vnode_operation(&fc, orig_dvnode, key, true)) {
-		afs_dataversion_t orig_data_version;
-		afs_dataversion_t new_data_version;
-
 		orig_data_version = orig_dvnode->status.data_version + 1;
 
 		if (orig_dvnode != new_dvnode) {
@@ -1928,18 +1953,25 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (ret == 0) {
 		if (rehash)
 			d_rehash(rehash);
-		if (test_bit(AFS_VNODE_DIR_VALID, &orig_dvnode->flags))
-		    afs_edit_dir_remove(orig_dvnode, &old_dentry->d_name,
-					afs_edit_dir_for_rename_0);
+		down_write(&orig_dvnode->validate_lock);
+		if (test_bit(AFS_VNODE_DIR_VALID, &orig_dvnode->flags) &&
+		    orig_dvnode->status.data_version == orig_data_version)
+			afs_edit_dir_remove(orig_dvnode, &old_dentry->d_name,
+					    afs_edit_dir_for_rename_0);
+		if (orig_dvnode != new_dvnode) {
+			up_write(&orig_dvnode->validate_lock);
 
-		if (!new_negative &&
-		    test_bit(AFS_VNODE_DIR_VALID, &new_dvnode->flags))
-			afs_edit_dir_remove(new_dvnode, &new_dentry->d_name,
-					    afs_edit_dir_for_rename_1);
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
@@ -1958,6 +1990,7 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		afs_update_dentry_version(&fc, old_dentry, &scb[1]);
 		afs_update_dentry_version(&fc, new_dentry, &scb[1]);
 		d_move(old_dentry, new_dentry);
+		up_write(&new_dvnode->validate_lock);
 		goto error_tmp;
 	}
 
diff --git a/fs/afs/dir_silly.c b/fs/afs/dir_silly.c
index 361088a5edb9..d94e2b7cddff 100644
--- a/fs/afs/dir_silly.c
+++ b/fs/afs/dir_silly.c
@@ -21,6 +21,7 @@ static int afs_do_silly_rename(struct afs_vnode *dvnode, struct afs_vnode *vnode
 {
 	struct afs_fs_cursor fc;
 	struct afs_status_cb *scb;
+	afs_dataversion_t dir_data_version;
 	int ret = -ERESTARTSYS;
 
 	_enter("%pd,%pd", old, new);
@@ -31,7 +32,7 @@ static int afs_do_silly_rename(struct afs_vnode *dvnode, struct afs_vnode *vnode
 
 	trace_afs_silly_rename(vnode, false);
 	if (afs_begin_vnode_operation(&fc, dvnode, key, true)) {
-		afs_dataversion_t dir_data_version = dvnode->status.data_version + 1;
+		dir_data_version = dvnode->status.data_version + 1;
 
 		while (afs_select_fileserver(&fc)) {
 			fc.cb_break = afs_calc_vnode_cb_break(dvnode);
@@ -54,12 +55,15 @@ static int afs_do_silly_rename(struct afs_vnode *dvnode, struct afs_vnode *vnode
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
@@ -181,10 +185,14 @@ static int afs_do_silly_unlink(struct afs_vnode *dvnode, struct afs_vnode *vnode
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

