Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B43406215
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhIJAom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhIJAU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57426610A3;
        Fri, 10 Sep 2021 00:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233158;
        bh=GWvKccJ0nJQHbQb7eu5JBaHjm4ebnPH1Tahm7C9qC6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A04O/07p9+UY9iJjB8XDcLRacr6v4qo/asv5Q0itLODCXk/aTWis9u2E2oD+hklvp
         hI32sEaheyFGfQM8fac6y/q211uaM5NDfx7hiZbHbPsJxVicdk9BY9FN98Aba7Fxph
         qWggkFR4iCG648rRF6VYX+MOJbwKfu9a5nDDNZSPQshnj3uPs3LHGuWB/tB0JvEkrW
         JdGcexElZrJsMvyRnJPPrqXbQLeXDYrLv9VZYxUXYvsx34GSGBw3iBZmIK0pfJg+OX
         PK8HLzesWBEbMdXeJ9SLPfqsQemBWdnLktb8aiZB4IHsubE90vA7ZnpENOpLXcsH1R
         jULs7M7i7GSXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 40/88] ovl: copy up sync/noatime fileattr flags
Date:   Thu,  9 Sep 2021 20:17:32 -0400
Message-Id: <20210910001820.174272-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 72db82115d2bdfbfba8b15a92d91872cfe1b40c6 ]

When a lower file has sync/noatime fileattr flags, the behavior of
overlayfs post copy up is inconsistent.

Immediately after copy up, ovl inode still has the S_SYNC/S_NOATIME
inode flags copied from lower inode, so vfs code still treats the ovl
inode as sync/noatime.  After ovl inode evict or mount cycle,
the ovl inode does not have these inode flags anymore.

To fix this inconsistency, try to copy the fileattr flags on copy up
if the upper fs supports the fileattr_set() method.

This gives consistent behavior post copy up regardless of inode eviction
from cache.

We cannot copy up the immutable/append-only inode flags in a similar
manner, because immutable/append-only inodes cannot be linked and because
overlayfs will not be able to set overlay.* xattr on the upper inodes.

Those flags will be addressed by a followup patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 51 ++++++++++++++++++++++++++++++++++------
 fs/overlayfs/inode.c     | 44 ++++++++++++++++++++++++----------
 fs/overlayfs/overlayfs.h | 15 +++++++++++-
 3 files changed, 89 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2846b943e80c..5e7fb92f9edd 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/fileattr.h>
 #include <linux/splice.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
@@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 	return error;
 }
 
+static int ovl_copy_fileattr(struct path *old, struct path *new)
+{
+	struct fileattr oldfa = { .flags_valid = true };
+	struct fileattr newfa = { .flags_valid = true };
+	int err;
+
+	err = ovl_real_fileattr_get(old, &oldfa);
+	if (err)
+		return err;
+
+	err = ovl_real_fileattr_get(new, &newfa);
+	if (err)
+		return err;
+
+	BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
+	newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
+	newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
+
+	BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
+	newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
+	newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
+
+	return ovl_real_fileattr_set(new, &newfa);
+}
+
 static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
 			    struct path *new, loff_t len)
 {
@@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct inode *inode = d_inode(c->dentry);
+	struct path upperpath, datapath;
 	int err;
 
+	ovl_path_upper(c->dentry, &upperpath);
+	if (WARN_ON(upperpath.dentry != NULL))
+		return -EIO;
+
+	upperpath.dentry = temp;
+
 	/*
 	 * Copy up data first and then xattrs. Writing data after
 	 * xattrs will remove security.capability xattr automatically.
 	 */
 	if (S_ISREG(c->stat.mode) && !c->metacopy) {
-		struct path upperpath, datapath;
-
-		ovl_path_upper(c->dentry, &upperpath);
-		if (WARN_ON(upperpath.dentry != NULL))
-			return -EIO;
-		upperpath.dentry = temp;
-
 		ovl_path_lowerdata(c->dentry, &datapath);
 		err = ovl_copy_up_data(ofs, &datapath, &upperpath,
 				       c->stat.size);
@@ -518,6 +545,16 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	if (err)
 		return err;
 
+	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
+		/*
+		 * Copy the fileattr inode flags that are the source of already
+		 * copied i_flags
+		 */
+		err = ovl_copy_fileattr(&c->lowerpath, &upperpath);
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5e828a1c98a8..b288843e6b42 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -503,16 +503,14 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  * Introducing security_inode_fileattr_get/set() hooks would solve this issue
  * properly.
  */
-static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
+static int ovl_security_fileattr(struct path *realpath, struct fileattr *fa,
 				 bool set)
 {
-	struct path realpath;
 	struct file *file;
 	unsigned int cmd;
 	int err;
 
-	ovl_path_real(dentry, &realpath);
-	file = dentry_open(&realpath, O_RDONLY, current_cred());
+	file = dentry_open(realpath, O_RDONLY, current_cred());
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
@@ -527,11 +525,22 @@ static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
 	return err;
 }
 
+int ovl_real_fileattr_set(struct path *realpath, struct fileattr *fa)
+{
+	int err;
+
+	err = ovl_security_fileattr(realpath, fa, true);
+	if (err)
+		return err;
+
+	return vfs_fileattr_set(&init_user_ns, realpath->dentry, fa);
+}
+
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		     struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *upperdentry;
+	struct path upperpath;
 	const struct cred *old_cred;
 	int err;
 
@@ -541,12 +550,10 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 
 	err = ovl_copy_up(dentry);
 	if (!err) {
-		upperdentry = ovl_dentry_upper(dentry);
+		ovl_path_real(dentry, &upperpath);
 
 		old_cred = ovl_override_creds(inode->i_sb);
-		err = ovl_security_fileattr(dentry, fa, true);
-		if (!err)
-			err = vfs_fileattr_set(&init_user_ns, upperdentry, fa);
+		err = ovl_real_fileattr_set(&upperpath, fa);
 		revert_creds(old_cred);
 		ovl_copyflags(ovl_inode_real(inode), inode);
 	}
@@ -555,17 +562,28 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 	return err;
 }
 
+int ovl_real_fileattr_get(struct path *realpath, struct fileattr *fa)
+{
+	int err;
+
+	err = ovl_security_fileattr(realpath, fa, false);
+	if (err)
+		return err;
+
+	return vfs_fileattr_get(realpath->dentry, fa);
+}
+
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct path realpath;
 	const struct cred *old_cred;
 	int err;
 
+	ovl_path_real(dentry, &realpath);
+
 	old_cred = ovl_override_creds(inode->i_sb);
-	err = ovl_security_fileattr(dentry, fa, false);
-	if (!err)
-		err = vfs_fileattr_get(realdentry, fa);
+	err = ovl_real_fileattr_get(&realpath, fa);
 	revert_creds(old_cred);
 
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6ec73db4bf9e..8e94d9d0c919 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -518,9 +518,20 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	i_size_write(to, i_size_read(from));
 }
 
+/* vfs inode flags copied from real to ovl inode */
+#define OVL_COPY_I_FLAGS_MASK	(S_SYNC | S_NOATIME | S_APPEND | S_IMMUTABLE)
+
+/*
+ * fileattr flags copied from lower to upper inode on copy up.
+ * We cannot copy immutable/append-only flags, because that would prevevnt
+ * linking temp inode to upper dir.
+ */
+#define OVL_COPY_FS_FLAGS_MASK	(FS_SYNC_FL | FS_NOATIME_FL)
+#define OVL_COPY_FSX_FLAGS_MASK	(FS_XFLAG_SYNC | FS_XFLAG_NOATIME)
+
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
 {
-	unsigned int mask = S_SYNC | S_IMMUTABLE | S_APPEND | S_NOATIME;
+	unsigned int mask = OVL_COPY_I_FLAGS_MASK;
 
 	inode_set_flags(to, from->i_flags & mask, mask);
 }
@@ -548,6 +559,8 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 extern const struct file_operations ovl_file_operations;
 int __init ovl_aio_request_cache_init(void);
 void ovl_aio_request_cache_destroy(void);
+int ovl_real_fileattr_get(struct path *realpath, struct fileattr *fa);
+int ovl_real_fileattr_set(struct path *realpath, struct fileattr *fa);
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa);
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		     struct dentry *dentry, struct fileattr *fa);
-- 
2.30.2

