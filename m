Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30A96B2B9C
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 18:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCIRIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 12:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCIRH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 12:07:59 -0500
X-Greylist: delayed 532 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Mar 2023 09:04:35 PST
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [45.157.188.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA79CE7C81
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 09:04:35 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PXb0W27KzzMqG0T;
        Thu,  9 Mar 2023 17:55:39 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PXb0V5ZHrzMslrt;
        Thu,  9 Mar 2023 17:55:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678380939;
        bh=uPajZJs+jU8cEgwLqntijm09MCIH0iL/1aPPbTJuMU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/54t4r9ay41/bPQxJWrasqEdoxH2cpS8gE7pdldTDz7Vn7OxZ3/84QxyaERIVENr
         T37pYGZWoZPNOBSWDYy+Dvx7HmJWCkTxPuFqgOsiwUvfpU83k5e+bzd4LYJHE8GXTS
         NkcWCKorvdnzzcFsJa5iy4vkemkAckgjE3m0Yv5I=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Weinberger <richard@nod.at>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Christopher Obbard <chris.obbard@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>, Jeff Xu <jeffxu@google.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Moore <paul@paul-moore.com>,
        Ritesh Raj Sarraf <ritesh@collabora.com>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sjoerd Simons <sjoerd@collabora.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v1 1/5] hostfs: Fix ephemeral inodes
Date:   Thu,  9 Mar 2023 17:54:51 +0100
Message-Id: <20230309165455.175131-2-mic@digikod.net>
In-Reply-To: <20230309165455.175131-1-mic@digikod.net>
References: <20230309165455.175131-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hostfs creates a new inode for each opened or created file, which created
useless inode allocations and forbade identifying a host file with a kernel
inode.

Fix this uncommon filesystem behavior by tying kernel inodes to host
file's inode and device IDs.  Even if the host filesystem inodes may be
recycled, this cannot happen while a file referencing it is open, which
is the case with hostfs.  It should be noted that hostfs inode IDs may
not be unique for the same hostfs superblock because multiple host's
(backed) superblocks may be used.

Delete inodes when dropping them to force backed host's file descriptors
closing.

This enables to entirely remove ARCH_EPHEMERAL_INODES, and then makes
Landlock fully supported by UML.  This is very useful for testing
(ongoing and backported) changes.

These changes also factor out and simplify some helpers thanks to the
new hostfs_inode_update() and the hostfs_iget() revamp: read_name(),
hostfs_create(), hostfs_lookup(), hostfs_mknod(), and
hostfs_fill_sb_common().

A following commit with new Landlock tests check this new hostfs inode
consistency.

Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: <stable@vger.kernel.org> # 5.15.x: ce72750f04d6: hostfs: Fix writeback of dirty pages
Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20230309165455.175131-2-mic@digikod.net
---
 arch/Kconfig              |   7 --
 arch/um/Kconfig           |   1 -
 fs/hostfs/hostfs.h        |   1 +
 fs/hostfs/hostfs_kern.c   | 213 +++++++++++++++++++-------------------
 fs/hostfs/hostfs_user.c   |   1 +
 security/landlock/Kconfig |   2 +-
 6 files changed, 109 insertions(+), 116 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e3511afbb7f2..d5f0841ac3c1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1156,13 +1156,6 @@ config COMPAT_32BIT_TIME
 config ARCH_NO_PREEMPT
 	bool
 
-config ARCH_EPHEMERAL_INODES
-	def_bool n
-	help
-	  An arch should select this symbol if it doesn't keep track of inode
-	  instances on its own, but instead relies on something else (e.g. the
-	  host kernel for an UML kernel).
-
 config ARCH_SUPPORTS_RT
 	bool
 
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 541a9b18e343..4057d5267c6a 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,7 +5,6 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
-	select ARCH_EPHEMERAL_INODES
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV
diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 69cb796f6270..0239e3af3945 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -65,6 +65,7 @@ struct hostfs_stat {
 	unsigned long long blocks;
 	unsigned int maj;
 	unsigned int min;
+	dev_t dev;
 };
 
 extern int stat_file(const char *path, struct hostfs_stat *p, int fd);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 28b4f15c19eb..19496f732016 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -26,6 +26,7 @@ struct hostfs_inode_info {
 	fmode_t mode;
 	struct inode vfs_inode;
 	struct mutex open_mutex;
+	dev_t dev;
 };
 
 static inline struct hostfs_inode_info *HOSTFS_I(struct inode *inode)
@@ -182,14 +183,6 @@ static char *follow_link(char *link)
 	return ERR_PTR(n);
 }
 
-static struct inode *hostfs_iget(struct super_block *sb)
-{
-	struct inode *inode = new_inode(sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-	return inode;
-}
-
 static int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 {
 	/*
@@ -228,6 +221,7 @@ static struct inode *hostfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	hi->fd = -1;
 	hi->mode = 0;
+	hi->dev = 0;
 	inode_init_once(&hi->vfs_inode);
 	mutex_init(&hi->open_mutex);
 	return &hi->vfs_inode;
@@ -240,6 +234,7 @@ static void hostfs_evict_inode(struct inode *inode)
 	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
 		HOSTFS_I(inode)->fd = -1;
+		HOSTFS_I(inode)->dev = 0;
 	}
 }
 
@@ -265,6 +260,7 @@ static int hostfs_show_options(struct seq_file *seq, struct dentry *root)
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.free_inode	= hostfs_free_inode,
+	.drop_inode	= generic_delete_inode,
 	.evict_inode	= hostfs_evict_inode,
 	.statfs		= hostfs_statfs,
 	.show_options	= hostfs_show_options,
@@ -512,18 +508,31 @@ static const struct address_space_operations hostfs_aops = {
 	.write_end	= hostfs_write_end,
 };
 
-static int read_name(struct inode *ino, char *name)
+static int hostfs_inode_update(struct inode *ino, const struct hostfs_stat *st)
+{
+	set_nlink(ino, st->nlink);
+	i_uid_write(ino, st->uid);
+	i_gid_write(ino, st->gid);
+	ino->i_atime =
+		(struct timespec64){ st->atime.tv_sec, st->atime.tv_nsec };
+	ino->i_mtime =
+		(struct timespec64){ st->mtime.tv_sec, st->mtime.tv_nsec };
+	ino->i_ctime =
+		(struct timespec64){ st->ctime.tv_sec, st->ctime.tv_nsec };
+	ino->i_size = st->size;
+	ino->i_blocks = st->blocks;
+	return 0;
+}
+
+static int hostfs_inode_set(struct inode *ino, void *data)
 {
+	struct hostfs_stat *st = data;
 	dev_t rdev;
-	struct hostfs_stat st;
-	int err = stat_file(name, &st, -1);
-	if (err)
-		return err;
 
 	/* Reencode maj and min with the kernel encoding.*/
-	rdev = MKDEV(st.maj, st.min);
+	rdev = MKDEV(st->maj, st->min);
 
-	switch (st.mode & S_IFMT) {
+	switch (st->mode & S_IFMT) {
 	case S_IFLNK:
 		ino->i_op = &hostfs_link_iops;
 		break;
@@ -535,7 +544,7 @@ static int read_name(struct inode *ino, char *name)
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		init_special_inode(ino, st.mode & S_IFMT, rdev);
+		init_special_inode(ino, st->mode & S_IFMT, rdev);
 		ino->i_op = &hostfs_iops;
 		break;
 	case S_IFREG:
@@ -547,17 +556,42 @@ static int read_name(struct inode *ino, char *name)
 		return -EIO;
 	}
 
-	ino->i_ino = st.ino;
-	ino->i_mode = st.mode;
-	set_nlink(ino, st.nlink);
-	i_uid_write(ino, st.uid);
-	i_gid_write(ino, st.gid);
-	ino->i_atime = (struct timespec64){ st.atime.tv_sec, st.atime.tv_nsec };
-	ino->i_mtime = (struct timespec64){ st.mtime.tv_sec, st.mtime.tv_nsec };
-	ino->i_ctime = (struct timespec64){ st.ctime.tv_sec, st.ctime.tv_nsec };
-	ino->i_size = st.size;
-	ino->i_blocks = st.blocks;
-	return 0;
+	HOSTFS_I(ino)->dev = st->dev;
+	ino->i_ino = st->ino;
+	ino->i_mode = st->mode;
+	return hostfs_inode_update(ino, st);
+}
+
+static int hostfs_inode_test(struct inode *inode, void *data)
+{
+	const struct hostfs_stat *st = data;
+
+	return inode->i_ino == st->ino && HOSTFS_I(inode)->dev == st->dev;
+}
+
+static struct inode *hostfs_iget(struct super_block *sb, char *name)
+{
+	struct inode *inode;
+	struct hostfs_stat st;
+	int err = stat_file(name, &st, -1);
+
+	if (err)
+		return ERR_PTR(err);
+
+	inode = iget5_locked(sb, st.ino, hostfs_inode_test, hostfs_inode_set,
+			     &st);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	if (inode->i_state & I_NEW) {
+		unlock_new_inode(inode);
+	} else {
+		spin_lock(&inode->i_lock);
+		hostfs_inode_update(inode, &st);
+		spin_unlock(&inode->i_lock);
+	}
+
+	return inode;
 }
 
 static int hostfs_create(struct mnt_idmap *idmap, struct inode *dir,
@@ -565,62 +599,48 @@ static int hostfs_create(struct mnt_idmap *idmap, struct inode *dir,
 {
 	struct inode *inode;
 	char *name;
-	int error, fd;
-
-	inode = hostfs_iget(dir->i_sb);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto out;
-	}
+	int fd;
 
-	error = -ENOMEM;
 	name = dentry_name(dentry);
 	if (name == NULL)
-		goto out_put;
+		return -ENOMEM;
 
 	fd = file_create(name, mode & 0777);
-	if (fd < 0)
-		error = fd;
-	else
-		error = read_name(inode, name);
+	if (fd < 0) {
+		__putname(name);
+		return fd;
+	}
 
+	inode = hostfs_iget(dir->i_sb, name);
 	__putname(name);
-	if (error)
-		goto out_put;
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
 	HOSTFS_I(inode)->fd = fd;
 	HOSTFS_I(inode)->mode = FMODE_READ | FMODE_WRITE;
 	d_instantiate(dentry, inode);
 	return 0;
-
- out_put:
-	iput(inode);
- out:
-	return error;
 }
 
 static struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
 				    unsigned int flags)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
 	char *name;
-	int err;
-
-	inode = hostfs_iget(ino->i_sb);
-	if (IS_ERR(inode))
-		goto out;
 
-	err = -ENOMEM;
 	name = dentry_name(dentry);
-	if (name) {
-		err = read_name(inode, name);
-		__putname(name);
-	}
-	if (err) {
-		iput(inode);
-		inode = (err == -ENOENT) ? NULL : ERR_PTR(err);
+	if (name == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	inode = hostfs_iget(ino->i_sb, name);
+	__putname(name);
+	if (IS_ERR(inode)) {
+		if (PTR_ERR(inode) == -ENOENT)
+			inode = NULL;
+		else
+			return ERR_CAST(inode);
 	}
- out:
+
 	return d_splice_alias(inode, dentry);
 }
 
@@ -704,35 +724,23 @@ static int hostfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	char *name;
 	int err;
 
-	inode = hostfs_iget(dir->i_sb);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		goto out;
-	}
-
-	err = -ENOMEM;
 	name = dentry_name(dentry);
 	if (name == NULL)
-		goto out_put;
+		return -ENOMEM;
 
 	err = do_mknod(name, mode, MAJOR(dev), MINOR(dev));
-	if (err)
-		goto out_free;
+	if (err) {
+		__putname(name);
+		return err;
+	}
 
-	err = read_name(inode, name);
+	inode = hostfs_iget(dir->i_sb, name);
 	__putname(name);
-	if (err)
-		goto out_put;
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
 
 	d_instantiate(dentry, inode);
 	return 0;
-
- out_free:
-	__putname(name);
- out_put:
-	iput(inode);
- out:
-	return err;
 }
 
 static int hostfs_rename2(struct mnt_idmap *idmap,
@@ -929,49 +937,40 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	err = super_setup_bdi(sb);
 	if (err)
-		goto out;
+		return err;
 
 	/* NULL is printed as '(null)' by printf(): avoid that. */
 	if (req_root == NULL)
 		req_root = "";
 
-	err = -ENOMEM;
 	sb->s_fs_info = host_root_path =
 		kasprintf(GFP_KERNEL, "%s/%s", root_ino, req_root);
 	if (host_root_path == NULL)
-		goto out;
-
-	root_inode = new_inode(sb);
-	if (!root_inode)
-		goto out;
+		return -ENOMEM;
 
-	err = read_name(root_inode, host_root_path);
-	if (err)
-		goto out_put;
+	root_inode = hostfs_iget(sb, host_root_path);
+	if (IS_ERR(root_inode))
+		return PTR_ERR(root_inode);
 
 	if (S_ISLNK(root_inode->i_mode)) {
-		char *name = follow_link(host_root_path);
-		if (IS_ERR(name)) {
-			err = PTR_ERR(name);
-			goto out_put;
-		}
-		err = read_name(root_inode, name);
+		char *name;
+
+		iput(root_inode);
+		name = follow_link(host_root_path);
+		if (IS_ERR(name))
+			return PTR_ERR(name);
+
+		root_inode = hostfs_iget(sb, name);
 		kfree(name);
-		if (err)
-			goto out_put;
+		if (IS_ERR(root_inode))
+			return PTR_ERR(root_inode);
 	}
 
-	err = -ENOMEM;
 	sb->s_root = d_make_root(root_inode);
 	if (sb->s_root == NULL)
-		goto out;
+		return -ENOMEM;
 
 	return 0;
-
-out_put:
-	iput(root_inode);
-out:
-	return err;
 }
 
 static struct dentry *hostfs_read_sb(struct file_system_type *type,
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 5ecc4706172b..840619e39a1a 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -36,6 +36,7 @@ static void stat64_to_hostfs(const struct stat64 *buf, struct hostfs_stat *p)
 	p->blocks = buf->st_blocks;
 	p->maj = os_major(buf->st_rdev);
 	p->min = os_minor(buf->st_rdev);
+	p->dev = buf->st_dev;
 }
 
 int stat_file(const char *path, struct hostfs_stat *p, int fd)
diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
index 8e33c4e8ffb8..c1e862a38410 100644
--- a/security/landlock/Kconfig
+++ b/security/landlock/Kconfig
@@ -2,7 +2,7 @@
 
 config SECURITY_LANDLOCK
 	bool "Landlock support"
-	depends on SECURITY && !ARCH_EPHEMERAL_INODES
+	depends on SECURITY
 	select SECURITY_PATH
 	help
 	  Landlock is a sandboxing mechanism that enables processes to restrict
-- 
2.39.2

