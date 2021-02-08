Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387693137A7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhBHP2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhBHPYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCFB564EFB;
        Mon,  8 Feb 2021 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797289;
        bh=pXoUEQcea30fpYy0qQMmpIdCPQRloy23VCwOhA3C7U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4BHcdiKt44DENYudu9mwnUOsXAe6E7Mj9W7OK16s42R6KXNux8mRyroWJBb2wTCG
         q6GrMU9LG4l3BFhyMY6YwuMOInT9T+COFGG6UL5RXwZR0Bo9ogKdT+d+DeY1J9FFZB
         NvnPorGWBPm/deOOdix364BgUX508iEmzBSPiYRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 056/120] ovl: implement volatile-specific fsync error behaviour
Date:   Mon,  8 Feb 2021 16:00:43 +0100
Message-Id: <20210208145820.654264876@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit 335d3fc57941e5c6164c69d439aec1cb7a800876 upstream.

Overlayfs's volatile option allows the user to bypass all forced sync calls
to the upperdir filesystem. This comes at the cost of safety. We can never
ensure that the user's data is intact, but we can make a best effort to
expose whether or not the data is likely to be in a bad state.

The best way to handle this in the time being is that if an overlayfs's
upperdir experiences an error after a volatile mount occurs, that error
will be returned on fsync, fdatasync, sync, and syncfs. This is
contradictory to the traditional behaviour of VFS which fails the call
once, and only raises an error if a subsequent fsync error has occurred,
and been raised by the filesystem.

One awkward aspect of the patch is that we have to manually set the
superblock's errseq_t after the sync_fs callback as opposed to just
returning an error from syncfs. This is because the call chain looks
something like this:

sys_syncfs ->
	sync_filesystem ->
		__sync_filesystem ->
			/* The return value is ignored here
			sb->s_op->sync_fs(sb)
			_sync_blockdev
		/* Where the VFS fetches the error to raise to userspace */
		errseq_check_and_advance

Because of this we call errseq_set every time the sync_fs callback occurs.
Due to the nature of this seen / unseen dichotomy, if the upperdir is an
inconsistent state at the initial mount time, overlayfs will refuse to
mount, as overlayfs cannot get a snapshot of the upperdir's errseq that
will increment on error until the user calls syncfs.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/overlayfs.rst |    8 +++++++
 fs/overlayfs/file.c                     |    5 ++--
 fs/overlayfs/overlayfs.h                |    1 
 fs/overlayfs/ovl_entry.h                |    2 +
 fs/overlayfs/readdir.c                  |    5 ++--
 fs/overlayfs/super.c                    |   34 +++++++++++++++++++++++++-------
 fs/overlayfs/util.c                     |   27 +++++++++++++++++++++++++
 7 files changed, 71 insertions(+), 11 deletions(-)

--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -575,6 +575,14 @@ without significant effort.
 The advantage of mounting with the "volatile" option is that all forms of
 sync calls to the upper filesystem are omitted.
 
+In order to avoid a giving a false sense of safety, the syncfs (and fsync)
+semantics of volatile mounts are slightly different than that of the rest of
+VFS.  If any writeback error occurs on the upperdir's filesystem after a
+volatile mount takes place, all sync functions will return an error.  Once this
+condition is reached, the filesystem will not recover, and every subsequent sync
+call will return an error, even if the upperdir has not experience a new error
+since the last sync call.
+
 When overlay is mounted with "volatile" option, the directory
 "$workdir/work/incompat/volatile" is created.  During next mount, overlay
 checks for this directory and refuses to mount if present. This is a strong
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -445,8 +445,9 @@ static int ovl_fsync(struct file *file,
 	const struct cred *old_cred;
 	int ret;
 
-	if (!ovl_should_sync(OVL_FS(file_inode(file)->i_sb)))
-		return 0;
+	ret = ovl_sync_status(OVL_FS(file_inode(file)->i_sb));
+	if (ret <= 0)
+		return ret;
 
 	ret = ovl_real_fdget_meta(file, &real, !datasync);
 	if (ret)
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -322,6 +322,7 @@ int ovl_check_metacopy_xattr(struct ovl_
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 			     int padding);
+int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline bool ovl_is_impuredir(struct super_block *sb,
 				    struct dentry *dentry)
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -79,6 +79,8 @@ struct ovl_fs {
 	atomic_long_t last_ino;
 	/* Whiteout dentry cache */
 	struct dentry *whiteout;
+	/* r/o snapshot of upperdir sb's only taken on volatile mounts */
+	errseq_t errseq;
 };
 
 static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -900,8 +900,9 @@ static int ovl_dir_fsync(struct file *fi
 	struct file *realfile;
 	int err;
 
-	if (!ovl_should_sync(OVL_FS(file->f_path.dentry->d_sb)))
-		return 0;
+	err = ovl_sync_status(OVL_FS(file->f_path.dentry->d_sb));
+	if (err <= 0)
+		return err;
 
 	realfile = ovl_dir_real_file(file, true);
 	err = PTR_ERR_OR_ZERO(realfile);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -261,11 +261,20 @@ static int ovl_sync_fs(struct super_bloc
 	struct super_block *upper_sb;
 	int ret;
 
-	if (!ovl_upper_mnt(ofs))
-		return 0;
+	ret = ovl_sync_status(ofs);
+	/*
+	 * We have to always set the err, because the return value isn't
+	 * checked in syncfs, and instead indirectly return an error via
+	 * the sb's writeback errseq, which VFS inspects after this call.
+	 */
+	if (ret < 0) {
+		errseq_set(&sb->s_wb_err, -EIO);
+		return -EIO;
+	}
+
+	if (!ret)
+		return ret;
 
-	if (!ovl_should_sync(ofs))
-		return 0;
 	/*
 	 * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
 	 * All the super blocks will be iterated, including upper_sb.
@@ -1927,6 +1936,8 @@ static int ovl_fill_super(struct super_b
 	sb->s_op = &ovl_super_operations;
 
 	if (ofs->config.upperdir) {
+		struct super_block *upper_sb;
+
 		if (!ofs->config.workdir) {
 			pr_err("missing 'workdir'\n");
 			goto out_err;
@@ -1936,6 +1947,16 @@ static int ovl_fill_super(struct super_b
 		if (err)
 			goto out_err;
 
+		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
+		if (!ovl_should_sync(ofs)) {
+			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);
+			if (errseq_check(&upper_sb->s_wb_err, ofs->errseq)) {
+				err = -EIO;
+				pr_err("Cannot mount volatile when upperdir has an unseen error. Sync upperdir fs to clear state.\n");
+				goto out_err;
+			}
+		}
+
 		err = ovl_get_workdir(sb, ofs, &upperpath);
 		if (err)
 			goto out_err;
@@ -1943,9 +1964,8 @@ static int ovl_fill_super(struct super_b
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
-		sb->s_stack_depth = ovl_upper_mnt(ofs)->mnt_sb->s_stack_depth;
-		sb->s_time_gran = ovl_upper_mnt(ofs)->mnt_sb->s_time_gran;
-
+		sb->s_stack_depth = upper_sb->s_stack_depth;
+		sb->s_time_gran = upper_sb->s_time_gran;
 	}
 	oe = ovl_get_lowerstack(sb, splitlower, numlower, ofs, layers);
 	err = PTR_ERR(oe);
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -950,3 +950,30 @@ err_free:
 	kfree(buf);
 	return ERR_PTR(res);
 }
+
+/*
+ * ovl_sync_status() - Check fs sync status for volatile mounts
+ *
+ * Returns 1 if this is not a volatile mount and a real sync is required.
+ *
+ * Returns 0 if syncing can be skipped because mount is volatile, and no errors
+ * have occurred on the upperdir since the mount.
+ *
+ * Returns -errno if it is a volatile mount, and the error that occurred since
+ * the last mount. If the error code changes, it'll return the latest error
+ * code.
+ */
+
+int ovl_sync_status(struct ovl_fs *ofs)
+{
+	struct vfsmount *mnt;
+
+	if (ovl_should_sync(ofs))
+		return 1;
+
+	mnt = ovl_upper_mnt(ofs);
+	if (!mnt)
+		return 0;
+
+	return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
+}


