Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD911F997
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfLORPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:15:25 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48705 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfLORPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:15:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E9E5223E2;
        Sun, 15 Dec 2019 12:15:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 12:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ky9q68
        iPfma0KD0ZNU6FYzP7oC2tpgnT3v/nejlqzfs=; b=twAR/Zk9raTpX2tRo+h8Kw
        JbRB1p1Mi0UAFNEaueYHU+CbknhvKh/HEZRtesuILpoNkdv7gT8sA3qBVcLqPNdc
        EhsY1Y+V2wQSdx7KSn2RrdgC3bqbZaFcLo1rc+L+g54s5Te4Yb6qmT0HZjbwp5SM
        Kyvhy29+H5iRRm5yy48SQG2DJ2QvAKLyAdJvX4YCrne75SinKStE4HUiUISUiQzO
        vVKUg8a7+o6aQSzypwIAAxL61T/rASyuUNf4qZzF3+ChIMGl+uQcAZkOeCxWq1Vc
        Bzg5bm4kiAirBUByTesiEVtRB+h8wFwUrijYLCdDX2zLCTMwn4qUTNWw+mwEBW4A
        ==
X-ME-Sender: <xms:K2r2XVg3gadDYSIwrLFoNYzR9Cmj_lHGryAW1RrOYhfUhEv-R83UQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:K2r2Xaz8LkOadcxoa8BOD6_mCjA_h36wOyq7QrUgC38IW6Py8OngrQ>
    <xmx:K2r2XW7rCQj9d3ENDuQWGoAN-XhJoocDbKzcwDBaE6Ba7Kcu_EOuIw>
    <xmx:K2r2XQkBkSSHgYkViy9ogC1ZIeK7T7xqSE4B524sSg9up8EiZpOoqQ>
    <xmx:LGr2XW9OlxXMUb_hJOM5-Fx21F4aOUJJuxahA2M2smOJa7jUqLY6TQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8096C30600D7;
        Sun, 15 Dec 2019 12:15:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] reiserfs: fix extended attributes on the root directory" failed to apply to 4.9-stable tree
To:     jeffm@suse.com, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 18:15:19 +0100
Message-ID: <1576430119239212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60e4cf67a582d64f07713eda5fcc8ccdaf7833e6 Mon Sep 17 00:00:00 2001
From: Jeff Mahoney <jeffm@suse.com>
Date: Thu, 24 Oct 2019 10:31:27 -0400
Subject: [PATCH] reiserfs: fix extended attributes on the root directory

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

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 132ec4406ed0..6419e6dacc39 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2097,6 +2097,15 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
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
@@ -2111,8 +2120,7 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 		reiserfs_warning(inode->i_sb, "jdm-13090",
 				 "ACLs aren't enabled in the fs, "
 				 "but vfs thinks they are!");
-	} else if (IS_PRIVATE(dir))
-		inode->i_flags |= S_PRIVATE;
+	}
 
 	if (security->name) {
 		reiserfs_write_unlock(inode->i_sb);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 97f3fc4fdd79..959a066b7bb0 100644
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
index e5ca9ed79e54..726580114d55 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -1168,6 +1168,8 @@ static inline int bmap_would_wrap(unsigned bmap_nr)
 	return bmap_nr > ((1LL << 16) - 1);
 }
 
+extern const struct xattr_handler *reiserfs_xattr_handlers[];
+
 /*
  * this says about version of key of all items (but stat data) the
  * object consists of
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index d69b4ac0ae2f..3244037b1286 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2049,6 +2049,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	if (replay_only(s))
 		goto error_unlocked;
 
+	s->s_xattr = reiserfs_xattr_handlers;
+
 	if (bdev_read_only(s->s_bdev) && !sb_rdonly(s)) {
 		SWARN(silent, s, "clm-7000",
 		      "Detected readonly device, marking FS readonly");
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index b5b26d8a192c..62b40df36c98 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -122,13 +122,13 @@ static struct dentry *open_xa_root(struct super_block *sb, int flags)
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
 
@@ -619,6 +619,10 @@ int reiserfs_xattr_set(struct inode *inode, const char *name,
 	int error, error2;
 	size_t jbegin_count = reiserfs_xattr_nblocks(inode, buffer_size);
 
+	/* Check before we start a transaction and then do nothing. */
+	if (!d_really_is_positive(REISERFS_SB(inode->i_sb)->priv_root))
+		return -EOPNOTSUPP;
+
 	if (!(flags & XATTR_REPLACE))
 		jbegin_count += reiserfs_xattr_jcreate_nblocks(inode);
 
@@ -841,8 +845,7 @@ ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 	if (d_really_is_negative(dentry))
 		return -EINVAL;
 
-	if (!dentry->d_sb->s_xattr ||
-	    get_inode_sd_version(d_inode(dentry)) == STAT_DATA_V1)
+	if (get_inode_sd_version(d_inode(dentry)) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
 	dir = open_xa_dir(d_inode(dentry), XATTR_REPLACE);
@@ -882,6 +885,7 @@ static int create_privroot(struct dentry *dentry)
 	}
 
 	d_inode(dentry)->i_flags |= S_PRIVATE;
+	d_inode(dentry)->i_opflags &= ~IOP_XATTR;
 	reiserfs_info(dentry->d_sb, "Created %s - reserved for xattr "
 		      "storage.\n", PRIVROOT_NAME);
 
@@ -895,7 +899,7 @@ static int create_privroot(struct dentry *dentry) { return 0; }
 #endif
 
 /* Actual operations that are exported to VFS-land */
-static const struct xattr_handler *reiserfs_xattr_handlers[] = {
+const struct xattr_handler *reiserfs_xattr_handlers[] = {
 #ifdef CONFIG_REISERFS_FS_XATTR
 	&reiserfs_xattr_user_handler,
 	&reiserfs_xattr_trusted_handler,
@@ -966,8 +970,10 @@ int reiserfs_lookup_privroot(struct super_block *s)
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
@@ -996,7 +1002,6 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 	}
 
 	if (d_really_is_positive(privroot)) {
-		s->s_xattr = reiserfs_xattr_handlers;
 		inode_lock(d_inode(privroot));
 		if (!REISERFS_SB(s)->xattr_root) {
 			struct dentry *dentry;
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index aa9380bac196..05f666794561 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -320,10 +320,8 @@ reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
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

