Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BFB55D318
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbiF1MQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345471AbiF1MQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495D427177
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3F861139
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55431C3411D;
        Tue, 28 Jun 2022 12:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418603;
        bh=hbb5iE0z/gST+0VVYM+flJFwNjBAgurOlUzC6+AqaCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TU0G13RuidlQpI2wLAnawKgOC0cnP/blPz5s2180kZRpNWAkZd5qw7ODeMOk8vLGS
         IxHCo0Q5OGiFytzrpmzhdamyXLQdGCkjCucmmCeAHpgPUVSj2Etf+cKdjtSZGBCbOS
         Co6058Kcrb9O3uX5ICC1alpOExIhZ2XtUW0byJY+IyEOQNqrwqzkydPaQeyKQhIki/
         VeURc2jbVIP7iB9UqYnCR1szFVtiT4z9vqcEbDQ/PPhK4TurY26oJdCEejn9GXRhsb
         LmqwbnIKJFHM7RIQsk4TTfPjG1/hP3BO/bHiZVcYWQUZA/WKXVx7oEJrniuPzzcvzH
         /TFNc00EKLZ6g==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 10/12] fs: support mapped mounts of mapped filesystems
Date:   Tue, 28 Jun 2022 14:16:18 +0200
Message-Id: <20220628121620.188722-11-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13544; i=brauner@kernel.org; h=from:subject; bh=WRl7Ac54iaXaFpSLs9rBYcO/ozQmFhUKlScE1Rwkook=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+ihwjePstnj3H0uiP8Rx3NZ/stt7er9wzfrF96Tf7bvl NXe6UEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBENm1gZDg1S6CFOTJq2ePpuSFsUU XHziZFr31vyJ5l3qC+XpvD7ynD/7TSMo7UUywRB8UEd+b9bKgIbL7M+CdN/ZeQoW9Jzc/lLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit bd303368b776eead1c29e6cdda82bde7128b82a7 upstream.

In previous patches we added new and modified existing helpers to handle
idmapped mounts of filesystems mounted with an idmapping. In this final
patch we convert all relevant places in the vfs to actually pass the
filesystem's idmapping into these helpers.

With this the vfs is in shape to handle idmapped mounts of filesystems
mounted with an idmapping. Note that this is just the generic
infrastructure. Actually adding support for idmapped mounts to a
filesystem mountable with an idmapping is follow-up work.

In this patch we extend the definition of an idmapped mount from a mount
that that has the initial idmapping attached to it to a mount that has
an idmapping attached to it which is not the same as the idmapping the
filesystem was mounted with.

As before we do not allow the initial idmapping to be attached to a
mount. In addition this patch prevents that the idmapping the filesystem
was mounted with can be attached to a mount created based on this
filesystem.

This has multiple reasons and advantages. First, attaching the initial
idmapping or the filesystem's idmapping doesn't make much sense as in
both cases the values of the i_{g,u}id and other places where k{g,u}ids
are used do not change. Second, a user that really wants to do this for
whatever reason can just create a separate dedicated identical idmapping
to attach to the mount. Third, we can continue to use the initial
idmapping as an indicator that a mount is not idmapped allowing us to
continue to keep passing the initial idmapping into the mapping helpers
to tell them that something isn't an idmapped mount even if the
filesystem is mounted with an idmapping.

Link: https://lore.kernel.org/r/20211123114227.3124056-11-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-11-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-11-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/namespace.c       | 51 +++++++++++++++++++++++++++++++++-----------
 fs/open.c            |  7 +++---
 fs/posix_acl.c       |  8 +++----
 include/linux/fs.h   | 17 ++++++++-------
 security/commoncap.c |  9 ++++----
 5 files changed, 59 insertions(+), 33 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5b5aa107b9f3..dc31ad6b370f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fs_context.h>
 #include <linux/shmem_fs.h>
+#include <linux/mnt_idmapping.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -561,7 +562,7 @@ static void free_vfsmnt(struct mount *mnt)
 	struct user_namespace *mnt_userns;
 
 	mnt_userns = mnt_user_ns(&mnt->mnt);
-	if (mnt_userns != &init_user_ns)
+	if (!initial_idmapping(mnt_userns))
 		put_user_ns(mnt_userns);
 	kfree_const(mnt->mnt_devname);
 #ifdef CONFIG_SMP
@@ -965,6 +966,7 @@ static struct mount *skip_mnt_tree(struct mount *p)
 struct vfsmount *vfs_create_mount(struct fs_context *fc)
 {
 	struct mount *mnt;
+	struct user_namespace *fs_userns;
 
 	if (!fc->root)
 		return ERR_PTR(-EINVAL);
@@ -982,6 +984,10 @@ struct vfsmount *vfs_create_mount(struct fs_context *fc)
 	mnt->mnt_mountpoint	= mnt->mnt.mnt_root;
 	mnt->mnt_parent		= mnt;
 
+	fs_userns = mnt->mnt.mnt_sb->s_user_ns;
+	if (!initial_idmapping(fs_userns))
+		mnt->mnt.mnt_userns = get_user_ns(fs_userns);
+
 	lock_mount_hash();
 	list_add_tail(&mnt->mnt_instance, &mnt->mnt.mnt_sb->s_mounts);
 	unlock_mount_hash();
@@ -1072,7 +1078,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_userns = mnt_user_ns(&old->mnt);
-	if (mnt->mnt.mnt_userns != &init_user_ns)
+	if (!initial_idmapping(mnt->mnt.mnt_userns))
 		mnt->mnt.mnt_userns = get_user_ns(mnt->mnt.mnt_userns);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
@@ -3927,10 +3933,18 @@ static unsigned int recalc_flags(struct mount_kattr *kattr, struct mount *mnt)
 static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 {
 	struct vfsmount *m = &mnt->mnt;
+	struct user_namespace *fs_userns = m->mnt_sb->s_user_ns;
 
 	if (!kattr->mnt_userns)
 		return 0;
 
+	/*
+	 * Creating an idmapped mount with the filesystem wide idmapping
+	 * doesn't make sense so block that. We don't allow mushy semantics.
+	 */
+	if (kattr->mnt_userns == fs_userns)
+		return -EINVAL;
+
 	/*
 	 * Once a mount has been idmapped we don't allow it to change its
 	 * mapping. It makes things simpler and callers can just create
@@ -3943,12 +3957,8 @@ static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 	if (!(m->mnt_sb->s_type->fs_flags & FS_ALLOW_IDMAP))
 		return -EINVAL;
 
-	/* Don't yet support filesystem mountable in user namespaces. */
-	if (m->mnt_sb->s_user_ns != &init_user_ns)
-		return -EINVAL;
-
 	/* We're not controlling the superblock. */
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(fs_userns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Mount has already been visible in the filesystem hierarchy. */
@@ -4002,14 +4012,27 @@ static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 
 static void do_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 {
-	struct user_namespace *mnt_userns;
+	struct user_namespace *mnt_userns, *old_mnt_userns;
 
 	if (!kattr->mnt_userns)
 		return;
 
+	/*
+	 * We're the only ones able to change the mount's idmapping. So
+	 * mnt->mnt.mnt_userns is stable and we can retrieve it directly.
+	 */
+	old_mnt_userns = mnt->mnt.mnt_userns;
+
 	mnt_userns = get_user_ns(kattr->mnt_userns);
 	/* Pairs with smp_load_acquire() in mnt_user_ns(). */
 	smp_store_release(&mnt->mnt.mnt_userns, mnt_userns);
+
+	/*
+	 * If this is an idmapped filesystem drop the reference we've taken
+	 * in vfs_create_mount() before.
+	 */
+	if (!initial_idmapping(old_mnt_userns))
+		put_user_ns(old_mnt_userns);
 }
 
 static void mount_setattr_commit(struct mount_kattr *kattr,
@@ -4133,13 +4156,15 @@ static int build_mount_idmapped(const struct mount_attr *attr, size_t usize,
 	}
 
 	/*
-	 * The init_user_ns is used to indicate that a vfsmount is not idmapped.
-	 * This is simpler than just having to treat NULL as unmapped. Users
-	 * wanting to idmap a mount to init_user_ns can just use a namespace
-	 * with an identity mapping.
+	 * The initial idmapping cannot be used to create an idmapped
+	 * mount. We use the initial idmapping as an indicator of a mount
+	 * that is not idmapped. It can simply be passed into helpers that
+	 * are aware of idmapped mounts as a convenient shortcut. A user
+	 * can just create a dedicated identity mapping to achieve the same
+	 * result.
 	 */
 	mnt_userns = container_of(ns, struct user_namespace, ns);
-	if (mnt_userns == &init_user_ns) {
+	if (initial_idmapping(mnt_userns)) {
 		err = -EPERM;
 		goto out_fput;
 	}
diff --git a/fs/open.c b/fs/open.c
index 31c47abbddf6..1ba1d2ab2ef0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -641,7 +641,7 @@ SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 
 int chown_common(const struct path *path, uid_t user, gid_t group)
 {
-	struct user_namespace *mnt_userns;
+	struct user_namespace *mnt_userns, *fs_userns;
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
 	int error;
@@ -653,8 +653,9 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 	gid = make_kgid(current_user_ns(), group);
 
 	mnt_userns = mnt_user_ns(path->mnt);
-	uid = mapped_kuid_user(mnt_userns, &init_user_ns, uid);
-	gid = mapped_kgid_user(mnt_userns, &init_user_ns, gid);
+	fs_userns = i_user_ns(inode);
+	uid = mapped_kuid_user(mnt_userns, fs_userns, uid);
+	gid = mapped_kgid_user(mnt_userns, fs_userns, gid);
 
 retry_deleg:
 	newattrs.ia_valid =  ATTR_CTIME;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 3d7ee193424a..d6c7b620fb8f 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -377,8 +377,8 @@ posix_acl_permission(struct user_namespace *mnt_userns, struct inode *inode,
                                 break;
                         case ACL_USER:
 				uid = mapped_kuid_fs(mnt_userns,
-						      &init_user_ns,
-						      pa->e_uid);
+						     i_user_ns(inode),
+						     pa->e_uid);
 				if (uid_eq(uid, current_fsuid()))
                                         goto mask;
 				break;
@@ -392,8 +392,8 @@ posix_acl_permission(struct user_namespace *mnt_userns, struct inode *inode,
 				break;
                         case ACL_GROUP:
 				gid = mapped_kgid_fs(mnt_userns,
-						      &init_user_ns,
-						      pa->e_gid);
+						     i_user_ns(inode),
+						     pa->e_gid);
 				if (in_group_p(gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d418dffb1681..76162f046670 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1643,7 +1643,7 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
 static inline kuid_t i_uid_into_mnt(struct user_namespace *mnt_userns,
 				    const struct inode *inode)
 {
-	return mapped_kuid_fs(mnt_userns, &init_user_ns, inode->i_uid);
+	return mapped_kuid_fs(mnt_userns, i_user_ns(inode), inode->i_uid);
 }
 
 /**
@@ -1657,7 +1657,7 @@ static inline kuid_t i_uid_into_mnt(struct user_namespace *mnt_userns,
 static inline kgid_t i_gid_into_mnt(struct user_namespace *mnt_userns,
 				    const struct inode *inode)
 {
-	return mapped_kgid_fs(mnt_userns, &init_user_ns, inode->i_gid);
+	return mapped_kgid_fs(mnt_userns, i_user_ns(inode), inode->i_gid);
 }
 
 /**
@@ -1671,7 +1671,7 @@ static inline kgid_t i_gid_into_mnt(struct user_namespace *mnt_userns,
 static inline void inode_fsuid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_uid = mapped_fsuid(mnt_userns, &init_user_ns);
+	inode->i_uid = mapped_fsuid(mnt_userns, i_user_ns(inode));
 }
 
 /**
@@ -1685,7 +1685,7 @@ static inline void inode_fsuid_set(struct inode *inode,
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_gid = mapped_fsgid(mnt_userns, &init_user_ns);
+	inode->i_gid = mapped_fsgid(mnt_userns, i_user_ns(inode));
 }
 
 /**
@@ -1706,10 +1706,10 @@ static inline bool fsuidgid_has_mapping(struct super_block *sb,
 	kuid_t kuid;
 	kgid_t kgid;
 
-	kuid = mapped_fsuid(mnt_userns, &init_user_ns);
+	kuid = mapped_fsuid(mnt_userns, fs_userns);
 	if (!uid_valid(kuid))
 		return false;
-	kgid = mapped_fsgid(mnt_userns, &init_user_ns);
+	kgid = mapped_fsgid(mnt_userns, fs_userns);
 	if (!gid_valid(kgid))
 		return false;
 	return kuid_has_mapping(fs_userns, kuid) &&
@@ -2655,13 +2655,14 @@ static inline struct user_namespace *file_mnt_user_ns(struct file *file)
  * is_idmapped_mnt - check whether a mount is mapped
  * @mnt: the mount to check
  *
- * If @mnt has an idmapping attached to it @mnt is mapped.
+ * If @mnt has an idmapping attached different from the
+ * filesystem's idmapping then @mnt is mapped.
  *
  * Return: true if mount is mapped, false if not.
  */
 static inline bool is_idmapped_mnt(const struct vfsmount *mnt)
 {
-	return mnt_user_ns(mnt) != &init_user_ns;
+	return mnt_user_ns(mnt) != mnt->mnt_sb->s_user_ns;
 }
 
 extern long vfs_truncate(const struct path *, loff_t);
diff --git a/security/commoncap.c b/security/commoncap.c
index d288a62e2999..5fc8986c3c77 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -419,7 +419,7 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
 	kroot = make_kuid(fs_ns, root);
 
 	/* If this is an idmapped mount shift the kuid. */
-	kroot = mapped_kuid_fs(mnt_userns, &init_user_ns, kroot);
+	kroot = mapped_kuid_fs(mnt_userns, fs_ns, kroot);
 
 	/* If the root kuid maps to a valid uid in current ns, then return
 	 * this as a nscap. */
@@ -556,13 +556,12 @@ int cap_convert_nscap(struct user_namespace *mnt_userns, struct dentry *dentry,
 		return -EINVAL;
 	if (!capable_wrt_inode_uidgid(mnt_userns, inode, CAP_SETFCAP))
 		return -EPERM;
-	if (size == XATTR_CAPS_SZ_2 && (mnt_userns == &init_user_ns))
+	if (size == XATTR_CAPS_SZ_2 && (mnt_userns == fs_ns))
 		if (ns_capable(inode->i_sb->s_user_ns, CAP_SETFCAP))
 			/* user is privileged, just write the v2 */
 			return size;
 
-	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns,
-				   &init_user_ns);
+	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns, fs_ns);
 	if (!uid_valid(rootid))
 		return -EINVAL;
 
@@ -703,7 +702,7 @@ int get_vfs_caps_from_disk(struct user_namespace *mnt_userns,
 	/* Limit the caps to the mounter of the filesystem
 	 * or the more limited uid specified in the xattr.
 	 */
-	rootkuid = mapped_kuid_fs(mnt_userns, &init_user_ns, rootkuid);
+	rootkuid = mapped_kuid_fs(mnt_userns, fs_ns, rootkuid);
 	if (!rootid_owns_currentns(rootkuid))
 		return -ENODATA;
 
-- 
2.34.1

