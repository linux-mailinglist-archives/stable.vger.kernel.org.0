Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF3401BB1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242552AbhIFM6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242919AbhIFM6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0EB661056;
        Mon,  6 Sep 2021 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933039;
        bh=/a0xnHpmx0dMVu4J1XttUMg+m1SMSIPf7fSpcdjcPLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/DWK4fuEhfjCD3mLH7eokbQikFM4OjUXuyCjHY7kVuXLyWdREfL4+0bEiW6ijtHt
         G/mcwg5wlXqvGdYKNtRzP8mOl2U+eIaSx0KnMOGZ9e6j9M0ri8ixWzEXEqdoFQqknF
         O1tHivc/uEwxlqo6xzhV/25gEGChQeaYRESLiuvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 27/29] new helper: inode_wrong_type()
Date:   Mon,  6 Sep 2021 14:55:42 +0200
Message-Id: <20210906125450.686005946@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6e3e2c4362e41a2f18e3f7a5ad81bd2f49a47b85 upstream.

inode_wrong_type(inode, mode) returns true if setting inode->i_mode
to given value would've changed the inode type.  We have enough of
those checks open-coded to make a helper worthwhile.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c      |    4 ++--
 fs/9p/vfs_inode_dotl.c |    4 ++--
 fs/cifs/inode.c        |    5 ++---
 fs/fuse/dir.c          |    6 +++---
 fs/fuse/inode.c        |    2 +-
 fs/fuse/readdir.c      |    2 +-
 fs/nfs/inode.c         |    6 +++---
 fs/nfsd/nfsproc.c      |    2 +-
 fs/overlayfs/namei.c   |    4 ++--
 include/linux/fs.h     |    5 +++++
 10 files changed, 22 insertions(+), 18 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -398,7 +398,7 @@ static int v9fs_test_inode(struct inode
 
 	umode = p9mode2unixmode(v9ses, st, &rdev);
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+	if (inode_wrong_type(inode, umode))
 		return 0;
 
 	/* compare qid details */
@@ -1360,7 +1360,7 @@ int v9fs_refresh_inode(struct p9_fid *fi
 	 * Don't update inode if the file type is different
 	 */
 	umode = p9mode2unixmode(v9ses, st, &rdev);
-	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+	if (inode_wrong_type(inode, umode))
 		goto out;
 
 	/*
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -59,7 +59,7 @@ static int v9fs_test_inode_dotl(struct i
 	struct p9_stat_dotl *st = (struct p9_stat_dotl *)data;
 
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+	if (inode_wrong_type(inode, st->st_mode))
 		return 0;
 
 	if (inode->i_generation != st->st_gen)
@@ -933,7 +933,7 @@ int v9fs_refresh_inode_dotl(struct p9_fi
 	/*
 	 * Don't update inode if the file type is different
 	 */
-	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+	if (inode_wrong_type(inode, st->st_mode))
 		goto out;
 
 	/*
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -425,8 +425,7 @@ int cifs_get_inode_info_unix(struct inod
 		}
 
 		/* if filetype is different, return error */
-		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
-		    (fattr.cf_mode & S_IFMT))) {
+		if (unlikely(inode_wrong_type(*pinode, fattr.cf_mode))) {
 			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
@@ -1243,7 +1242,7 @@ cifs_find_inode(struct inode *inode, voi
 		return 0;
 
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
+	if (inode_wrong_type(inode, fattr->cf_mode))
 		return 0;
 
 	/* if it's not a directory or has no dentries, then flag it */
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -252,7 +252,7 @@ static int fuse_dentry_revalidate(struct
 		if (ret == -ENOMEM)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
-		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
+		    inode_wrong_type(inode, outarg.attr.mode))
 			goto invalid;
 
 		forget_all_cached_acls(inode);
@@ -1062,7 +1062,7 @@ static int fuse_do_getattr(struct inode
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
-		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		    inode_wrong_type(inode, outarg.attr.mode)) {
 			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
@@ -1699,7 +1699,7 @@ int fuse_do_setattr(struct dentry *dentr
 	}
 
 	if (fuse_invalid_attr(&outarg.attr) ||
-	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+	    inode_wrong_type(inode, outarg.attr.mode)) {
 		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -340,7 +340,7 @@ retry:
 		inode->i_generation = generation;
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
-	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
+	} else if (inode_wrong_type(inode, attr->mode)) {
 		/* Inode has changed type, any I/O on the old should fail */
 		fuse_make_bad(inode);
 		iput(inode);
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -202,7 +202,7 @@ retry:
 		inode = d_inode(dentry);
 		if (!inode ||
 		    get_node_id(inode) != o->nodeid ||
-		    ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
+		    inode_wrong_type(inode, o->attr.mode)) {
 			d_invalidate(dentry);
 			dput(dentry);
 			goto retry;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -322,7 +322,7 @@ nfs_find_actor(struct inode *inode, void
 
 	if (NFS_FILEID(inode) != fattr->fileid)
 		return 0;
-	if ((S_IFMT & inode->i_mode) != (S_IFMT & fattr->mode))
+	if (inode_wrong_type(inode, fattr->mode))
 		return 0;
 	if (nfs_compare_fh(NFS_FH(inode), fh))
 		return 0;
@@ -1446,7 +1446,7 @@ static int nfs_check_inode_attributes(st
 			return 0;
 		return -ESTALE;
 	}
-	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && (inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT))
+	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && inode_wrong_type(inode, fattr->mode))
 		return -ESTALE;
 
 
@@ -1861,7 +1861,7 @@ static int nfs_update_inode(struct inode
 	/*
 	 * Make sure the inode's type hasn't changed.
 	 */
-	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && (inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT)) {
+	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && inode_wrong_type(inode, fattr->mode)) {
 		/*
 		* Big trouble! The inode has become a different object.
 		*/
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -376,7 +376,7 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 
 		/* Make sure the type and device matches */
 		resp->status = nfserr_exist;
-		if (inode && type != (inode->i_mode & S_IFMT))
+		if (inode && inode_wrong_type(inode, type))
 			goto out_unlock;
 	}
 
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -366,7 +366,7 @@ int ovl_check_origin_fh(struct ovl_fs *o
 		return PTR_ERR(origin);
 
 	if (upperdentry && !ovl_is_whiteout(upperdentry) &&
-	    ((d_inode(origin)->i_mode ^ d_inode(upperdentry)->i_mode) & S_IFMT))
+	    inode_wrong_type(d_inode(upperdentry), d_inode(origin)->i_mode))
 		goto invalid;
 
 	if (!*stackp)
@@ -724,7 +724,7 @@ struct dentry *ovl_lookup_index(struct o
 		index = ERR_PTR(-ESTALE);
 		goto out;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
-		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
+		   inode_wrong_type(inode, d_inode(origin)->i_mode)) {
 		/*
 		 * Index should always be of the same file type as origin
 		 * except for the case of a whiteout index. A whiteout
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2768,6 +2768,11 @@ static inline bool execute_ok(struct ino
 	return (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode);
 }
 
+static inline bool inode_wrong_type(const struct inode *inode, umode_t mode)
+{
+	return (inode->i_mode ^ mode) & S_IFMT;
+}
+
 static inline void file_start_write(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))


