Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8E126A99
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfLSStG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbfLSStF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:49:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50BA12465E;
        Thu, 19 Dec 2019 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781344;
        bh=V4W7W/f4wiWQT9IugME53mzZW3R0mWlSXE+ycXYBgdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwou+Fp32s55EVzFQsUrGq4bYDKtDteHl44cWlMRTmaCc3olor8vOAUE4CqG1q0um
         w3IktF5sQNvDEwrC4Gfde/it2XGv9bEHxhCXVaMCYZw+JYofHrjOqVuL9pIwgDvZ3i
         AqGUN4LxX7NfR2z5UEmEuzkpL9CjfLmEBIZ1LmYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 166/199] reiserfs: fix extended attributes on the root directory
Date:   Thu, 19 Dec 2019 19:34:08 +0100
Message-Id: <20191219183224.642619223@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

[ Upstream commit 60e4cf67a582d64f07713eda5fcc8ccdaf7833e6 ]

Since commit d0a5b995a308 (vfs: Add IOP_XATTR inode operations flag)
extended attributes haven't worked on the root directory in reiserfs.

This is due to reiserfs conditionally setting the sb->s_xattrs handler
array depending on whether it located or create the internal privroot
directory.  It necessarily does this after the root inode is already
read in.  The IOP_XATTR flag is set during inode initialization, so
it never gets set on the root directory.

This commit unconditionally assigns sb->s_xattrs and clears IOP_XATTR on
internal inodes.  The old return values due to the conditional assignment
are handled via open_xa_root, which now returns EOPNOTSUPP as the VFS
would have done.

Link: https://lore.kernel.org/r/20191024143127.17509-1-jeffm@suse.com
CC: stable@vger.kernel.org
Fixes: d0a5b995a308 ("vfs: Add IOP_XATTR inode operations flag")
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/inode.c     | 12 ++++++++++--
 fs/reiserfs/namei.c     |  7 +++++--
 fs/reiserfs/reiserfs.h  |  2 ++
 fs/reiserfs/super.c     |  2 ++
 fs/reiserfs/xattr.c     | 19 ++++++++++++-------
 fs/reiserfs/xattr_acl.c |  4 +---
 6 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index bd4c727f4610b..9531b6c18ac7b 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2102,6 +2102,15 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 		goto out_inserted_sd;
 	}
 
+	/*
+	 * Mark it private if we're creating the privroot
+	 * or something under it.
+	 */
+	if (IS_PRIVATE(dir) || dentry == REISERFS_SB(sb)->priv_root) {
+		inode->i_flags |= S_PRIVATE;
+		inode->i_opflags &= ~IOP_XATTR;
+	}
+
 	if (reiserfs_posixacl(inode->i_sb)) {
 		reiserfs_write_unlock(inode->i_sb);
 		retval = reiserfs_inherit_default_acl(th, dir, dentry, inode);
@@ -2116,8 +2125,7 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 		reiserfs_warning(inode->i_sb, "jdm-13090",
 				 "ACLs aren't enabled in the fs, "
 				 "but vfs thinks they are!");
-	} else if (IS_PRIVATE(dir))
-		inode->i_flags |= S_PRIVATE;
+	}
 
 	if (security->name) {
 		reiserfs_write_unlock(inode->i_sb);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 1ec728cf82d13..1c900f3220898 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -377,10 +377,13 @@ static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
 
 		/*
 		 * Propagate the private flag so we know we're
-		 * in the priv tree
+		 * in the priv tree.  Also clear IOP_XATTR
+		 * since we don't have xattrs on xattr files.
 		 */
-		if (IS_PRIVATE(dir))
+		if (IS_PRIVATE(dir)) {
 			inode->i_flags |= S_PRIVATE;
+			inode->i_opflags &= ~IOP_XATTR;
+		}
 	}
 	reiserfs_write_unlock(dir->i_sb);
 	if (retval == IO_ERROR) {
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index d920a646b5784..3e78a394fdb84 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -1167,6 +1167,8 @@ static inline int bmap_would_wrap(unsigned bmap_nr)
 	return bmap_nr > ((1LL << 16) - 1);
 }
 
+extern const struct xattr_handler *reiserfs_xattr_handlers[];
+
 /*
  * this says about version of key of all items (but stat data) the
  * object consists of
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index dec6c93044fa3..cd2d555b3a6dd 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2026,6 +2026,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	if (replay_only(s))
 		goto error_unlocked;
 
+	s->s_xattr = reiserfs_xattr_handlers;
+
 	if (bdev_read_only(s->s_bdev) && !(s->s_flags & MS_RDONLY)) {
 		SWARN(silent, s, "clm-7000",
 		      "Detected readonly device, marking FS readonly");
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 9e313fc7fdc70..dbc2ada9884f1 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -121,13 +121,13 @@ static struct dentry *open_xa_root(struct super_block *sb, int flags)
 	struct dentry *xaroot;
 
 	if (d_really_is_negative(privroot))
-		return ERR_PTR(-ENODATA);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	inode_lock_nested(d_inode(privroot), I_MUTEX_XATTR);
 
 	xaroot = dget(REISERFS_SB(sb)->xattr_root);
 	if (!xaroot)
-		xaroot = ERR_PTR(-ENODATA);
+		xaroot = ERR_PTR(-EOPNOTSUPP);
 	else if (d_really_is_negative(xaroot)) {
 		int err = -ENODATA;
 
@@ -609,6 +609,10 @@ int reiserfs_xattr_set(struct inode *inode, const char *name,
 	int error, error2;
 	size_t jbegin_count = reiserfs_xattr_nblocks(inode, buffer_size);
 
+	/* Check before we start a transaction and then do nothing. */
+	if (!d_really_is_positive(REISERFS_SB(inode->i_sb)->priv_root))
+		return -EOPNOTSUPP;
+
 	if (!(flags & XATTR_REPLACE))
 		jbegin_count += reiserfs_xattr_jcreate_nblocks(inode);
 
@@ -831,8 +835,7 @@ ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 	if (d_really_is_negative(dentry))
 		return -EINVAL;
 
-	if (!dentry->d_sb->s_xattr ||
-	    get_inode_sd_version(d_inode(dentry)) == STAT_DATA_V1)
+	if (get_inode_sd_version(d_inode(dentry)) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
 	dir = open_xa_dir(d_inode(dentry), XATTR_REPLACE);
@@ -872,6 +875,7 @@ static int create_privroot(struct dentry *dentry)
 	}
 
 	d_inode(dentry)->i_flags |= S_PRIVATE;
+	d_inode(dentry)->i_opflags &= ~IOP_XATTR;
 	reiserfs_info(dentry->d_sb, "Created %s - reserved for xattr "
 		      "storage.\n", PRIVROOT_NAME);
 
@@ -885,7 +889,7 @@ static int create_privroot(struct dentry *dentry) { return 0; }
 #endif
 
 /* Actual operations that are exported to VFS-land */
-static const struct xattr_handler *reiserfs_xattr_handlers[] = {
+const struct xattr_handler *reiserfs_xattr_handlers[] = {
 #ifdef CONFIG_REISERFS_FS_XATTR
 	&reiserfs_xattr_user_handler,
 	&reiserfs_xattr_trusted_handler,
@@ -956,8 +960,10 @@ int reiserfs_lookup_privroot(struct super_block *s)
 	if (!IS_ERR(dentry)) {
 		REISERFS_SB(s)->priv_root = dentry;
 		d_set_d_op(dentry, &xattr_lookup_poison_ops);
-		if (d_really_is_positive(dentry))
+		if (d_really_is_positive(dentry)) {
 			d_inode(dentry)->i_flags |= S_PRIVATE;
+			d_inode(dentry)->i_opflags &= ~IOP_XATTR;
+		}
 	} else
 		err = PTR_ERR(dentry);
 	inode_unlock(d_inode(s->s_root));
@@ -986,7 +992,6 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 	}
 
 	if (d_really_is_positive(privroot)) {
-		s->s_xattr = reiserfs_xattr_handlers;
 		inode_lock(d_inode(privroot));
 		if (!REISERFS_SB(s)->xattr_root) {
 			struct dentry *dentry;
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index d92a1dc6ee70f..1f1fdfd3bc5cc 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -316,10 +316,8 @@ reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
 	 * would be useless since permissions are ignored, and a pain because
 	 * it introduces locking cycles
 	 */
-	if (IS_PRIVATE(dir)) {
-		inode->i_flags |= S_PRIVATE;
+	if (IS_PRIVATE(inode))
 		goto apply_umask;
-	}
 
 	err = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
 	if (err)
-- 
2.20.1



