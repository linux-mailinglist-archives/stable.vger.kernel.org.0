Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2936BF961
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjCRKQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCRKP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE93D927;
        Sat, 18 Mar 2023 03:15:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so4717762wmb.3;
        Sat, 18 Mar 2023 03:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfqqH40w4HE6WzfQRiTia8TiMis5qYAinCOETOm8WDM=;
        b=KAsqxX7FSI9OQmhMJzba26dg/uFT4HGDsxRL5fIwlTzD1DTIbhHNDY0kVNF4Nn0oZB
         8irUvzrf3rJ8miQir1as0rCbb8/x+Y4wwqfkY4BW901u4iSCrlkpvDZJ83w3Qica8EsX
         1ENR3KZa8JnWwOlAkHiU9wMbzLg2PFi1ibjUV5kOkkGubYpbf8B3P0ZuPMg/LWHxpZvY
         ui/VVX9hIh6C6xeoU/MgHgywYp4sS66XHD1Lg/BqIR03go6gn0byFIG8DU2DE70VnkJw
         d1te6Bbs1nERQg01QDXFNSs4cDhGh3eNKcb9wVr1HSLTkSOuWk1rxA0JnB5jxrZ0TUcF
         3d/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfqqH40w4HE6WzfQRiTia8TiMis5qYAinCOETOm8WDM=;
        b=fUzQno2rlrWpwsqKqWVoiMRfI0tLVXgprDAzYFjRX7RtK8Gu9lwrCr66BNiMoEdpLX
         sEEIcNLx/tisOwA573SjSyXMLqiXj26Pfcncgv7BOwAefxDbajtRHKPN9L9iK5JKo7RH
         oraue06g+zhvw5DtcgB3/NxM4JrjYicZQiuyhIjyTCznMWYdEKr6D+a1ZscS7R8Yhdab
         31wgRWoH596LTZgPh3O0cMonQGzIihQxwKnsVwlzAMD23JD/42tPU30M5MCy1ypTKGVf
         3YcHvOR+Ro7RtESln4XacZwZYE2N4vCjbaXFzbGhlMsK+FW7qnY08JfDrUp5lm3XlEs1
         lLRw==
X-Gm-Message-State: AO0yUKUurQrqA4C9k2JaC7URfzqZTXvvxjLxQ4ZLq/thzwmRmv38BkXe
        HVBzzrUfx+kHZYUPcXGPFN0=
X-Google-Smtp-Source: AK7set87jYH6NPigxChBc9092wYEk+8CLhT3hMCFDf77vKOsgqfmdEz6KtcUBkv40A0bQzg0vWZXaA==
X-Received: by 2002:a05:600c:4506:b0:3ed:253c:621b with SMTP id t6-20020a05600c450600b003ed253c621bmr21269706wmo.21.1679134550781;
        Sat, 18 Mar 2023 03:15:50 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Yang Xu <xuyang2018.jy@fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.10 09/15] fs: move S_ISGID stripping into the vfs_*() helpers
Date:   Sat, 18 Mar 2023 12:15:23 +0200
Message-Id: <20230318101529.1361673-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 1639a49ccdce58ea248841ed9b23babcce6dbb0b upstream.

[remove userns argument of helpers for 5.10.y backport]

Move setgid handling out of individual filesystems and into the VFS
itself to stop the proliferation of setgid inheritance bugs.

Creating files that have both the S_IXGRP and S_ISGID bit raised in
directories that themselves have the S_ISGID bit set requires additional
privileges to avoid security issues.

When a filesystem creates a new inode it needs to take care that the
caller is either in the group of the newly created inode or they have
CAP_FSETID in their current user namespace and are privileged over the
parent directory of the new inode. If any of these two conditions is
true then the S_ISGID bit can be raised for an S_IXGRP file and if not
it needs to be stripped.

However, there are several key issues with the current implementation:

* S_ISGID stripping logic is entangled with umask stripping.

  If a filesystem doesn't support or enable POSIX ACLs then umask
  stripping is done directly in the vfs before calling into the
  filesystem.
  If the filesystem does support POSIX ACLs then unmask stripping may be
  done in the filesystem itself when calling posix_acl_create().

  Since umask stripping has an effect on S_ISGID inheritance, e.g., by
  stripping the S_IXGRP bit from the file to be created and all relevant
  filesystems have to call posix_acl_create() before inode_init_owner()
  where we currently take care of S_ISGID handling S_ISGID handling is
  order dependent. IOW, whether or not you get a setgid bit depends on
  POSIX ACLs and umask and in what order they are called.

  Note that technically filesystems are free to impose their own
  ordering between posix_acl_create() and inode_init_owner() meaning
  that there's additional ordering issues that influence S_SIGID
  inheritance.

* Filesystems that don't rely on inode_init_owner() don't get S_ISGID
  stripping logic.

  While that may be intentional (e.g. network filesystems might just
  defer setgid stripping to a server) it is often just a security issue.

This is not just ugly it's unsustainably messy especially since we do
still have bugs in this area years after the initial round of setgid
bugfixes.

So the current state is quite messy and while we won't be able to make
it completely clean as posix_acl_create() is still a filesystem specific
call we can improve the S_SIGD stripping situation quite a bit by
hoisting it out of inode_init_owner() and into the vfs creation
operations. This means we alleviate the burden for filesystems to handle
S_ISGID stripping correctly and can standardize the ordering between
S_ISGID and umask stripping in the vfs.

We add a new helper vfs_prepare_mode() so S_ISGID handling is now done
in the VFS before umask handling. This has S_ISGID handling is
unaffected unaffected by whether umask stripping is done by the VFS
itself (if no POSIX ACLs are supported or enabled) or in the filesystem
in posix_acl_create() (if POSIX ACLs are supported).

The vfs_prepare_mode() helper is called directly in vfs_*() helpers that
create new filesystem objects. We need to move them into there to make
sure that filesystems like overlayfs hat have callchains like:

sys_mknod()
-> do_mknodat(mode)
   -> .mknod = ovl_mknod(mode)
      -> ovl_create(mode)
         -> vfs_mknod(mode)

get S_ISGID stripping done when calling into lower filesystems via
vfs_*() creation helpers. Moving vfs_prepare_mode() into e.g.
vfs_mknod() takes care of that. This is in any case semantically cleaner
because S_ISGID stripping is VFS security requirement.

Security hooks so far have seen the mode with the umask applied but
without S_ISGID handling done. The relevant hooks are called outside of
vfs_*() creation helpers so by calling vfs_prepare_mode() from vfs_*()
helpers the security hooks would now see the mode without umask
stripping applied. For now we fix this by passing the mode with umask
settings applied to not risk any regressions for LSM hooks. IOW, nothing
changes for LSM hooks. It is worth pointing out that security hooks
never saw the mode that is seen by the filesystem when actually creating
the file. They have always been completely misplaced for that to work.

The following filesystems use inode_init_owner() and thus relied on
S_ISGID stripping: spufs, 9p, bfs, btrfs, ext2, ext4, f2fs, hfsplus,
hugetlbfs, jfs, minix, nilfs2, ntfs3, ocfs2, omfs, overlayfs, ramfs,
reiserfs, sysv, ubifs, udf, ufs, xfs, zonefs, bpf, tmpfs.

All of the above filesystems end up calling inode_init_owner() when new
filesystem objects are created through the ->mkdir(), ->mknod(),
->create(), ->tmpfile(), ->rename() inode operations.

Since directories always inherit the S_ISGID bit with the exception of
xfs when irix_sgid_inherit mode is turned on S_ISGID stripping doesn't
apply. The ->symlink() and ->link() inode operations trivially inherit
the mode from the target and the ->rename() inode operation inherits the
mode from the source inode. All other creation inode operations will get
S_ISGID handling via vfs_prepare_mode() when called from their relevant
vfs_*() helpers.

In addition to this there are filesystems which allow the creation of
filesystem objects through ioctl()s or - in the case of spufs -
circumventing the vfs in other ways. If filesystem objects are created
through ioctl()s the vfs doesn't know about it and can't apply regular
permission checking including S_ISGID logic. Therfore, a filesystem
relying on S_ISGID stripping in inode_init_owner() in their ioctl()
callpath will be affected by moving this logic into the vfs. We audited
those filesystems:

* btrfs allows the creation of filesystem objects through various
  ioctls(). Snapshot creation literally takes a snapshot and so the mode
  is fully preserved and S_ISGID stripping doesn't apply.

  Creating a new subvolum relies on inode_init_owner() in
  btrfs_new_subvol_inode() but only creates directories and doesn't
  raise S_ISGID.

* ocfs2 has a peculiar implementation of reflinks. In contrast to e.g.
  xfs and btrfs FICLONE/FICLONERANGE ioctl() that is only concerned with
  the actual extents ocfs2 uses a separate ioctl() that also creates the
  target file.

  Iow, ocfs2 circumvents the vfs entirely here and did indeed rely on
  inode_init_owner() to strip the S_ISGID bit. This is the only place
  where a filesystem needs to call mode_strip_sgid() directly but this
  is self-inflicted pain.

* spufs doesn't go through the vfs at all and doesn't use ioctl()s
  either. Instead it has a dedicated system call spufs_create() which
  allows the creation of filesystem objects. But spufs only creates
  directories and doesn't allo S_SIGID bits, i.e. it specifically only
  allows 0777 bits.

* bpf uses vfs_mkobj() but also doesn't allow S_ISGID bits to be created.

The patch will have an effect on ext2 when the EXT2_MOUNT_GRPID mount
option is used, on ext4 when the EXT4_MOUNT_GRPID mount option is used,
and on xfs when the XFS_FEAT_GRPID mount option is used. When any of
these filesystems are mounted with their respective GRPID option then
newly created files inherit the parent directories group
unconditionally. In these cases non of the filesystems call
inode_init_owner() and thus did never strip the S_ISGID bit for newly
created files. Moving this logic into the VFS means that they now get
the S_ISGID bit stripped. This is a user visible change. If this leads
to regressions we will either need to figure out a better way or we need
to revert. However, given the various setgid bugs that we found just in
the last two years this is a regression risk we should take.

Associated with this change is a new set of fstests to enforce the
semantics for all new filesystems.

Link: https://lore.kernel.org/ceph-devel/20220427092201.wvsdjbnc7b4dttaw@wittgenstein [1]
Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [2]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [3]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [4]
Link: https://lore.kernel.org/r/1657779088-2242-3-git-send-email-xuyang2018.jy@fujitsu.com
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
[<brauner@kernel.org>: rewrote commit message]
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c       |  2 --
 fs/namei.c       | 80 ++++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/namei.c |  1 +
 3 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 23d03abcb0ff..52f834b6a3ad 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2147,8 +2147,6 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else
-			mode = mode_strip_sgid(dir, mode);
 	} else
 		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
diff --git a/fs/namei.c b/fs/namei.c
index 4159c140fa47..3d98db9802a7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2798,6 +2798,63 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 }
 EXPORT_SYMBOL(unlock_rename);
 
+/**
+ * mode_strip_umask - handle vfs umask stripping
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode to be created in @dir
+ *
+ * Umask stripping depends on whether or not the filesystem supports POSIX
+ * ACLs. If the filesystem doesn't support it umask stripping is done directly
+ * in here. If the filesystem does support POSIX ACLs umask stripping is
+ * deferred until the filesystem calls posix_acl_create().
+ *
+ * Returns: mode
+ */
+static inline umode_t mode_strip_umask(const struct inode *dir, umode_t mode)
+{
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
+	return mode;
+}
+
+/**
+ * vfs_prepare_mode - prepare the mode to be used for a new inode
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode
+ * @mask_perms:	allowed permission by the vfs
+ * @type:	type of file to be created
+ *
+ * This helper consolidates and enforces vfs restrictions on the @mode of a new
+ * object to be created.
+ *
+ * Umask stripping depends on whether the filesystem supports POSIX ACLs (see
+ * the kernel documentation for mode_strip_umask()). Moving umask stripping
+ * after setgid stripping allows the same ordering for both non-POSIX ACL and
+ * POSIX ACL supporting filesystems.
+ *
+ * Note that it's currently valid for @type to be 0 if a directory is created.
+ * Filesystems raise that flag individually and we need to check whether each
+ * filesystem can deal with receiving S_IFDIR from the vfs before we enforce a
+ * non-zero type.
+ *
+ * Returns: mode to be passed to the filesystem
+ */
+static inline umode_t vfs_prepare_mode(const struct inode *dir, umode_t mode,
+				       umode_t mask_perms, umode_t type)
+{
+	mode = mode_strip_sgid(dir, mode);
+	mode = mode_strip_umask(dir, mode);
+
+	/*
+	 * Apply the vfs mandated allowed permission mask and set the type of
+	 * file to be created before we call into the filesystem.
+	 */
+	mode &= (mask_perms & ~S_IFMT);
+	mode |= (type & S_IFMT);
+
+	return mode;
+}
+
 int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		bool want_excl)
 {
@@ -2807,8 +2864,8 @@ int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	if (!dir->i_op->create)
 		return -EACCES;	/* shouldn't it be ENOSYS? */
-	mode &= S_IALLUGO;
-	mode |= S_IFREG;
+
+	mode = vfs_prepare_mode(dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3072,8 +3129,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (open_flag & O_CREAT) {
 		if (open_flag & O_EXCL)
 			open_flag &= ~O_TRUNC;
-		if (!IS_POSIXACL(dir->d_inode))
-			mode &= ~current_umask();
+		mode = vfs_prepare_mode(dir->d_inode, mode, mode, mode);
 		if (likely(got_write))
 			create_error = may_o_create(&nd->path, dentry, mode);
 		else
@@ -3286,8 +3342,7 @@ struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode, int open_flag)
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
-	if (!IS_POSIXACL(dir))
-		mode &= ~current_umask();
+	mode = vfs_prepare_mode(dir, mode, mode, mode);
 	error = dir->i_op->tmpfile(dir, child, mode);
 	if (error)
 		goto out_err;
@@ -3548,6 +3603,7 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 	if (!dir->i_op->mknod)
 		return -EPERM;
 
+	mode = vfs_prepare_mode(dir, mode, mode, mode);
 	error = devcgroup_inode_mknod(mode, dev);
 	if (error)
 		return error;
@@ -3596,9 +3652,8 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mknod(&path, dentry, mode, dev);
+	error = security_path_mknod(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode), dev);
 	if (error)
 		goto out;
 	switch (mode & S_IFMT) {
@@ -3646,7 +3701,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (!dir->i_op->mkdir)
 		return -EPERM;
 
-	mode &= (S_IRWXUGO|S_ISVTX);
+	mode = vfs_prepare_mode(dir, mode, S_IRWXUGO | S_ISVTX, 0);
 	error = security_inode_mkdir(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3673,9 +3728,8 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mkdir(&path, dentry, mode);
+	error = security_path_mkdir(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode));
 	if (!error)
 		error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
 	done_path_create(&path, dentry);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 856474b0a1ae..df1f6b7aa797 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -198,6 +198,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	 * callers. */
 	if (S_ISDIR(mode))
 		set_nlink(inode, 2);
+	mode = mode_strip_sgid(dir, mode);
 	inode_init_owner(inode, dir, mode);
 	status = dquot_initialize(inode);
 	if (status)
-- 
2.34.1

