Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D6737CE2C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbhELRDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244288AbhELQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BE561D46;
        Wed, 12 May 2021 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835942;
        bh=l62Sl6/yB5emexJ9oBscxYstic+wcUgw0bbaBTc6h48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv1J8/Ka154YNEFmXTyi3EysDJMeFzkht7CNRGTKgyQxSq7O2r4aFjV53bVnSXXo9
         +89Wt448yibPgTFUmLZ5GH6We0XfwzBJOq7cRCg4jZkfFGLfmbf8e5U3+XSi90Zi5i
         qjirk3EuAyeUnCzDMN6y+htkn309PH41SkfJNrrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 546/677] ovl: invalidate readdir cache on changes to dir with origin
Date:   Wed, 12 May 2021 16:49:52 +0200
Message-Id: <20210512144855.514772062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 65cd913ec9d9d71529665924c81015b7ab7d9381 ]

The test in ovl_dentry_version_inc() was out-dated and did not include
the case where readdir cache is used on a non-merge dir that has origin
xattr, indicating that it may contain leftover whiteouts.

To make the code more robust, use the same helper ovl_dir_is_real()
to determine if readdir cache should be used and if readdir cache should
be invalidated.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com/
Cc: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h | 30 +++++++++++++++++++++++++++---
 fs/overlayfs/readdir.c   | 12 ------------
 fs/overlayfs/util.c      | 31 +++++++++----------------------
 3 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 95cff83786a5..2322f854533c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -319,9 +319,6 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
-void ovl_set_flag(unsigned long flag, struct inode *inode);
-void ovl_clear_flag(unsigned long flag, struct inode *inode);
-bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);
@@ -335,6 +332,21 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 			     int padding);
 int ovl_sync_status(struct ovl_fs *ofs);
 
+static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
+{
+	set_bit(flag, &OVL_I(inode)->flags);
+}
+
+static inline void ovl_clear_flag(unsigned long flag, struct inode *inode)
+{
+	clear_bit(flag, &OVL_I(inode)->flags);
+}
+
+static inline bool ovl_test_flag(unsigned long flag, struct inode *inode)
+{
+	return test_bit(flag, &OVL_I(inode)->flags);
+}
+
 static inline bool ovl_is_impuredir(struct super_block *sb,
 				    struct dentry *dentry)
 {
@@ -439,6 +451,18 @@ int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct ovl_fs *ofs);
 
+/*
+ * Can we iterate real dir directly?
+ *
+ * Non-merge dir may contain whiteouts from a time it was a merge upper, before
+ * lower dir was removed under it and possibly before it was rotated from upper
+ * to lower layer.
+ */
+static inline bool ovl_dir_is_real(struct dentry *dir)
+{
+	return !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
+}
+
 /* inode.c */
 int ovl_set_nlink_upper(struct dentry *dentry);
 int ovl_set_nlink_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f404a78e6b60..cc1e80257064 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -319,18 +319,6 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
-/*
- * Can we iterate real dir directly?
- *
- * Non-merge dir may contain whiteouts from a time it was a merge upper, before
- * lower dir was removed under it and possibly before it was rotated from upper
- * to lower layer.
- */
-static bool ovl_dir_is_real(struct dentry *dir)
-{
-	return !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
-}
-
 static void ovl_dir_reset(struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7f5a01a11f97..404a0a32ddf6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -422,18 +422,20 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	}
 }
 
-static void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
+static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
 {
 	struct inode *inode = d_inode(dentry);
 
 	WARN_ON(!inode_is_locked(inode));
+	WARN_ON(!d_is_dir(dentry));
 	/*
-	 * Version is used by readdir code to keep cache consistent.  For merge
-	 * dirs all changes need to be noted.  For non-merge dirs, cache only
-	 * contains impure (ones which have been copied up and have origins)
-	 * entries, so only need to note changes to impure entries.
+	 * Version is used by readdir code to keep cache consistent.
+	 * For merge dirs (or dirs with origin) all changes need to be noted.
+	 * For non-merge dirs, cache contains only impure entries (i.e. ones
+	 * which have been copied up and have origins), so only need to note
+	 * changes to impure entries.
 	 */
-	if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity)
+	if (!ovl_dir_is_real(dentry) || impurity)
 		OVL_I(inode)->version++;
 }
 
@@ -442,7 +444,7 @@ void ovl_dir_modified(struct dentry *dentry, bool impurity)
 	/* Copy mtime/ctime */
 	ovl_copyattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
 
-	ovl_dentry_version_inc(dentry, impurity);
+	ovl_dir_version_inc(dentry, impurity);
 }
 
 u64 ovl_dentry_version_get(struct dentry *dentry)
@@ -638,21 +640,6 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	return err;
 }
 
-void ovl_set_flag(unsigned long flag, struct inode *inode)
-{
-	set_bit(flag, &OVL_I(inode)->flags);
-}
-
-void ovl_clear_flag(unsigned long flag, struct inode *inode)
-{
-	clear_bit(flag, &OVL_I(inode)->flags);
-}
-
-bool ovl_test_flag(unsigned long flag, struct inode *inode)
-{
-	return test_bit(flag, &OVL_I(inode)->flags);
-}
-
 /**
  * Caller must hold a reference to inode to prevent it from being freed while
  * it is marked inuse.
-- 
2.30.2



