Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC292400E82
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 09:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhIEHKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 03:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbhIEHKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Sep 2021 03:10:05 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E8EC061575;
        Sun,  5 Sep 2021 00:08:59 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i6so4837121wrv.2;
        Sun, 05 Sep 2021 00:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vx1PkRayMUVx2xdKlP/hp9zSV99vs5wmY2KCX4qd7OU=;
        b=ez8/fycPhERMLJ7iC0C6+gZpxoZ5q2nsUktANRqdFZ/3EfklFjQypuWJWHBK0aOUuB
         0h0MHQB9EN2Hbr5Rb2r7aD/V89d1dPLt34pNGO1hAyKUNB0/BMjDShNoL0eZTwRtGca7
         88do9wmvAEWjnpjLlgikNlNtMbZjhuwkyWTI0x//z8jDFp9D/+wLQ/jEoMXmzrnqY6U1
         8bNC/61GlkldW5BjqCqHdOJNn6vGhXwYJYQtp82utUQ839RoWVUkSVpI+UKCMBTkIiQW
         7BWDTMP/YVvoezdZpmNRp2RGi3NY7pe7vqnT9f0GzLLKJB1waf/SbP+X8mYdqHJmBBK6
         cCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vx1PkRayMUVx2xdKlP/hp9zSV99vs5wmY2KCX4qd7OU=;
        b=eTot1lchrXpYEPfDYYe9pqmlnEF1UbptdN+eBjqS9oa9v1mtGVCRA1axpUsNbLXCW0
         oJUrBH1RTngmkWpmEXbQe1BnU3DivQpAYsUMeI9AJyesxcTGy3lU2DQS+82bZPnzB8lg
         TXtNU6YwwG/GCS1VpphhZnaIpO+I/Nf01lpXoPqYfEByhhYro+QYuyALDoSMKa8phLx6
         UA4C4DEso8Tr5+YcJrEMj1n0xMsFY3mlmFejZFHwcDHkPDza+mLdGeHVp8tic64mpVDL
         bV5VCqCOtc67mStjOZg49FUwJ1OazftVnkP80BFfGU0CKwm1G8/ZUIKEVbexsKUb8bUN
         Q5hQ==
X-Gm-Message-State: AOAM530t7MwY5ENlMPXOZ0zizE2mwyzNYMdWQW4cldRVfBmieOkqgJ41
        PprTaFtCNixulGz4YitDXQpJ924nLi4=
X-Google-Smtp-Source: ABdhPJz3wb1NmGVO8oVWrvKZeF7rk3x0l23DoL8d4jeXzyG6hOpIcfZBy03wpDwLl39xdaaOXXcHOw==
X-Received: by 2002:adf:c785:: with SMTP id l5mr7088959wrg.360.1630825737849;
        Sun, 05 Sep 2021 00:08:57 -0700 (PDT)
Received: from localhost.localdomain ([141.226.244.47])
        by smtp.gmail.com with ESMTPSA id q4sm4148355wra.43.2021.09.05.00.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 00:08:57 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Nikolaus Rath <Nikolaus@rath.org>,
        Vivek Goyal <vgoyal@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 1/2] new helper: inode_wrong_type()
Date:   Sun,  5 Sep 2021 10:08:32 +0300
Message-Id: <20210905070833.201102-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6e3e2c4362e41a2f18e3f7a5ad81bd2f49a47b85 ]

inode_wrong_type(inode, mode) returns true if setting inode->i_mode
to given value would've changed the inode type.  We have enough of
those checks open-coded to make a helper worthwhile.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/9p/vfs_inode.c      | 4 ++--
 fs/9p/vfs_inode_dotl.c | 4 ++--
 fs/cifs/inode.c        | 5 ++---
 fs/fuse/dir.c          | 6 +++---
 fs/fuse/inode.c        | 2 +-
 fs/fuse/readdir.c      | 2 +-
 fs/nfs/inode.c         | 6 +++---
 fs/nfsd/nfsproc.c      | 2 +-
 fs/overlayfs/namei.c   | 4 ++--
 include/linux/fs.h     | 5 +++++
 10 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index ae0c38ad1fcb..0791480bf922 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -398,7 +398,7 @@ static int v9fs_test_inode(struct inode *inode, void *data)
 
 	umode = p9mode2unixmode(v9ses, st, &rdev);
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+	if (inode_wrong_type(inode, umode))
 		return 0;
 
 	/* compare qid details */
@@ -1360,7 +1360,7 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 	 * Don't update inode if the file type is different
 	 */
 	umode = p9mode2unixmode(v9ses, st, &rdev);
-	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+	if (inode_wrong_type(inode, umode))
 		goto out;
 
 	/*
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 0028eccb665a..72b67d810b8c 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -59,7 +59,7 @@ static int v9fs_test_inode_dotl(struct inode *inode, void *data)
 	struct p9_stat_dotl *st = (struct p9_stat_dotl *)data;
 
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+	if (inode_wrong_type(inode, st->st_mode))
 		return 0;
 
 	if (inode->i_generation != st->st_gen)
@@ -933,7 +933,7 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 	/*
 	 * Don't update inode if the file type is different
 	 */
-	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+	if (inode_wrong_type(inode, st->st_mode))
 		goto out;
 
 	/*
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b1f0c05d6eaf..b11a919b9cab 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -425,8 +425,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		}
 
 		/* if filetype is different, return error */
-		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
-		    (fattr.cf_mode & S_IFMT))) {
+		if (unlikely(inode_wrong_type(*pinode, fattr.cf_mode))) {
 			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
 			goto cgiiu_exit;
@@ -1243,7 +1242,7 @@ cifs_find_inode(struct inode *inode, void *opaque)
 		return 0;
 
 	/* don't match inode of different type */
-	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
+	if (inode_wrong_type(inode, fattr->cf_mode))
 		return 0;
 
 	/* if it's not a directory or has no dentries, then flag it */
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 756bbdd563e0..37d50dde845e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -252,7 +252,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (ret == -ENOMEM)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
-		    (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
+		    inode_wrong_type(inode, outarg.attr.mode))
 			goto invalid;
 
 		forget_all_cached_acls(inode);
@@ -1062,7 +1062,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
-		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		    inode_wrong_type(inode, outarg.attr.mode)) {
 			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
@@ -1699,7 +1699,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 	}
 
 	if (fuse_invalid_attr(&outarg.attr) ||
-	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+	    inode_wrong_type(inode, outarg.attr.mode)) {
 		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f94b0bb57619..6345c4679fb8 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -340,7 +340,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		inode->i_generation = generation;
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
-	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
+	} else if (inode_wrong_type(inode, attr->mode)) {
 		/* Inode has changed type, any I/O on the old should fail */
 		fuse_make_bad(inode);
 		iput(inode);
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 3441ffa740f3..277f7041d55a 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -202,7 +202,7 @@ static int fuse_direntplus_link(struct file *file,
 		inode = d_inode(dentry);
 		if (!inode ||
 		    get_node_id(inode) != o->nodeid ||
-		    ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
+		    inode_wrong_type(inode, o->attr.mode)) {
 			d_invalidate(dentry);
 			dput(dentry);
 			goto retry;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 9811880470a0..21addb78523d 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -322,7 +322,7 @@ nfs_find_actor(struct inode *inode, void *opaque)
 
 	if (NFS_FILEID(inode) != fattr->fileid)
 		return 0;
-	if ((S_IFMT & inode->i_mode) != (S_IFMT & fattr->mode))
+	if (inode_wrong_type(inode, fattr->mode))
 		return 0;
 	if (nfs_compare_fh(NFS_FH(inode), fh))
 		return 0;
@@ -1446,7 +1446,7 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 			return 0;
 		return -ESTALE;
 	}
-	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && (inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT))
+	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && inode_wrong_type(inode, fattr->mode))
 		return -ESTALE;
 
 
@@ -1861,7 +1861,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	/*
 	 * Make sure the inode's type hasn't changed.
 	 */
-	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && (inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT)) {
+	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && inode_wrong_type(inode, fattr->mode)) {
 		/*
 		* Big trouble! The inode has become a different object.
 		*/
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 0d71549f9d42..9c9de2b66e64 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -376,7 +376,7 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 
 		/* Make sure the type and device matches */
 		resp->status = nfserr_exist;
-		if (inode && type != (inode->i_mode & S_IFMT))
+		if (inode && inode_wrong_type(inode, type))
 			goto out_unlock;
 	}
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f3309e044f07..092812c2f118 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -366,7 +366,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 		return PTR_ERR(origin);
 
 	if (upperdentry && !ovl_is_whiteout(upperdentry) &&
-	    ((d_inode(origin)->i_mode ^ d_inode(upperdentry)->i_mode) & S_IFMT))
+	    inode_wrong_type(d_inode(upperdentry), d_inode(origin)->i_mode))
 		goto invalid;
 
 	if (!*stackp)
@@ -724,7 +724,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 		index = ERR_PTR(-ESTALE);
 		goto out;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
-		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
+		   inode_wrong_type(inode, d_inode(origin)->i_mode)) {
 		/*
 		 * Index should always be of the same file type as origin
 		 * except for the case of a whiteout index. A whiteout
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8bde32cf9711..43bb6a51e42d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2768,6 +2768,11 @@ static inline bool execute_ok(struct inode *inode)
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
-- 
2.16.5

