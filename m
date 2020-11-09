Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D72ABCDD
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgKINBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbgKINAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:00:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8391A207BC;
        Mon,  9 Nov 2020 13:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926835;
        bh=5V8coG9Y/fEG66hh16i6UcXN2sRMX3Fdl/yFQ8i9qM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QezUdt1vvWCNw4WNtFMfNSp3pZH8DxMQg4Jmbz0xVqlRCjI6Kc5FjklUfkDH6sVYU
         G3ATWjOXkYieCaYvBU7BVnUEDoXF991OxudTJZ8qZ+3XwH23FF9tZrKw6GrGvZw2Nk
         Qu8l1EU9n8N5gfenSDwAASnkuC5gLzM18kDK2hes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 013/117] fscrypto: move ioctl processing more fully into common code
Date:   Mon,  9 Nov 2020 13:53:59 +0100
Message-Id: <20201109125026.281278591@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit db717d8e26c2d1b0dba3e08668a1e6a7f665adde upstream.

Multiple bugs were recently fixed in the "set encryption policy" ioctl.
To make it clear that fscrypt_process_policy() and fscrypt_get_policy()
implement ioctls and therefore their implementations must take standard
security and correctness precautions, rename them to
fscrypt_ioctl_set_policy() and fscrypt_ioctl_get_policy().  Make the
latter take in a struct file * to make it consistent with the former.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/crypto/policy.c       |   34 +++++++++++++++++++++-------------
 fs/ext4/ext4.h           |    4 ++--
 fs/ext4/ioctl.c          |   32 ++++----------------------------
 fs/f2fs/f2fs.h           |    4 ++--
 fs/f2fs/file.c           |   19 ++-----------------
 include/linux/fscrypto.h |   12 ++++++------
 6 files changed, 37 insertions(+), 68 deletions(-)

--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -93,16 +93,19 @@ static int create_encryption_context_fro
 	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
 }
 
-int fscrypt_process_policy(struct file *filp,
-				const struct fscrypt_policy *policy)
+int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 {
+	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
 	int ret;
 
+	if (copy_from_user(&policy, arg, sizeof(policy)))
+		return -EFAULT;
+
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
-	if (policy->version != 0)
+	if (policy.version != 0)
 		return -EINVAL;
 
 	ret = mnt_want_write_file(filp);
@@ -122,9 +125,9 @@ int fscrypt_process_policy(struct file *
 			ret = -ENOTEMPTY;
 		else
 			ret = create_encryption_context_from_policy(inode,
-								    policy);
+								    &policy);
 	} else if (!is_encryption_context_consistent_with_policy(inode,
-								 policy)) {
+								 &policy)) {
 		printk(KERN_WARNING
 		       "%s: Policy inconsistent with encryption context\n",
 		       __func__);
@@ -136,11 +139,13 @@ int fscrypt_process_policy(struct file *
 	mnt_drop_write_file(filp);
 	return ret;
 }
-EXPORT_SYMBOL(fscrypt_process_policy);
+EXPORT_SYMBOL(fscrypt_ioctl_set_policy);
 
-int fscrypt_get_policy(struct inode *inode, struct fscrypt_policy *policy)
+int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 {
+	struct inode *inode = file_inode(filp);
 	struct fscrypt_context ctx;
+	struct fscrypt_policy policy;
 	int res;
 
 	if (!inode->i_sb->s_cop->get_context ||
@@ -153,15 +158,18 @@ int fscrypt_get_policy(struct inode *ino
 	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
 		return -EINVAL;
 
-	policy->version = 0;
-	policy->contents_encryption_mode = ctx.contents_encryption_mode;
-	policy->filenames_encryption_mode = ctx.filenames_encryption_mode;
-	policy->flags = ctx.flags;
-	memcpy(&policy->master_key_descriptor, ctx.master_key_descriptor,
+	policy.version = 0;
+	policy.contents_encryption_mode = ctx.contents_encryption_mode;
+	policy.filenames_encryption_mode = ctx.filenames_encryption_mode;
+	policy.flags = ctx.flags;
+	memcpy(policy.master_key_descriptor, ctx.master_key_descriptor,
 				FS_KEY_DESCRIPTOR_SIZE);
+
+	if (copy_to_user(arg, &policy, sizeof(policy)))
+		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL(fscrypt_get_policy);
+EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
 
 /**
  * fscrypt_has_permitted_context() - is a file's encryption policy permitted
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2354,8 +2354,8 @@ static inline void ext4_fname_free_filen
 #define fscrypt_pullback_bio_page	fscrypt_notsupp_pullback_bio_page
 #define fscrypt_restore_control_page	fscrypt_notsupp_restore_control_page
 #define fscrypt_zeroout_range		fscrypt_notsupp_zeroout_range
-#define fscrypt_process_policy		fscrypt_notsupp_process_policy
-#define fscrypt_get_policy		fscrypt_notsupp_get_policy
+#define fscrypt_ioctl_set_policy	fscrypt_notsupp_ioctl_set_policy
+#define fscrypt_ioctl_get_policy	fscrypt_notsupp_ioctl_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
 #define fscrypt_get_encryption_info	fscrypt_notsupp_get_encryption_info
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -774,22 +774,12 @@ resizefs_out:
 	}
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
-	case EXT4_IOC_SET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-		struct fscrypt_policy policy;
 
+	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
+		return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 
-		if (copy_from_user(&policy,
-				   (struct fscrypt_policy __user *)arg,
-				   sizeof(policy)))
-			return -EFAULT;
-		return fscrypt_process_policy(filp, &policy);
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT: {
 		int err, err2;
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -826,23 +816,9 @@ resizefs_out:
 			return -EFAULT;
 		return 0;
 	}
-	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-		struct fscrypt_policy policy;
-		int err = 0;
+	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
-		if (!ext4_encrypted_inode(inode))
-			return -ENOENT;
-		err = fscrypt_get_policy(inode, &policy);
-		if (err)
-			return err;
-		if (copy_to_user((void __user *)arg, &policy, sizeof(policy)))
-			return -EFAULT;
-		return 0;
-#else
-		return -EOPNOTSUPP;
-#endif
-	}
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2513,8 +2513,8 @@ static inline bool f2fs_may_encrypt(stru
 #define fscrypt_pullback_bio_page	fscrypt_notsupp_pullback_bio_page
 #define fscrypt_restore_control_page	fscrypt_notsupp_restore_control_page
 #define fscrypt_zeroout_range		fscrypt_notsupp_zeroout_range
-#define fscrypt_process_policy		fscrypt_notsupp_process_policy
-#define fscrypt_get_policy		fscrypt_notsupp_get_policy
+#define fscrypt_ioctl_set_policy	fscrypt_notsupp_ioctl_set_policy
+#define fscrypt_ioctl_get_policy	fscrypt_notsupp_ioctl_get_policy
 #define fscrypt_has_permitted_context	fscrypt_notsupp_has_permitted_context
 #define fscrypt_inherit_context		fscrypt_notsupp_inherit_context
 #define fscrypt_get_encryption_info	fscrypt_notsupp_get_encryption_info
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1774,31 +1774,16 @@ static bool uuid_is_nonzero(__u8 u[16])
 
 static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 {
-	struct fscrypt_policy policy;
 	struct inode *inode = file_inode(filp);
 
-	if (copy_from_user(&policy, (struct fscrypt_policy __user *)arg,
-							sizeof(policy)))
-		return -EFAULT;
-
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
 
-	return fscrypt_process_policy(filp, &policy);
+	return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 }
 
 static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
 {
-	struct fscrypt_policy policy;
-	struct inode *inode = file_inode(filp);
-	int err;
-
-	err = fscrypt_get_policy(inode, &policy);
-	if (err)
-		return err;
-
-	if (copy_to_user((struct fscrypt_policy __user *)arg, &policy, sizeof(policy)))
-		return -EFAULT;
-	return 0;
+	return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 }
 
 static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -249,8 +249,8 @@ extern void fscrypt_restore_control_page
 extern int fscrypt_zeroout_range(struct inode *, pgoff_t, sector_t,
 						unsigned int);
 /* policy.c */
-extern int fscrypt_process_policy(struct file *, const struct fscrypt_policy *);
-extern int fscrypt_get_policy(struct inode *, struct fscrypt_policy *);
+extern int fscrypt_ioctl_set_policy(struct file *, const void __user *);
+extern int fscrypt_ioctl_get_policy(struct file *, void __user *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
@@ -318,14 +318,14 @@ static inline int fscrypt_notsupp_zeroou
 }
 
 /* policy.c */
-static inline int fscrypt_notsupp_process_policy(struct file *f,
-				const struct fscrypt_policy *p)
+static inline int fscrypt_notsupp_ioctl_set_policy(struct file *f,
+				const void __user *arg)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int fscrypt_notsupp_get_policy(struct inode *i,
-				struct fscrypt_policy *p)
+static inline int fscrypt_notsupp_ioctl_get_policy(struct file *f,
+				void __user *arg)
 {
 	return -EOPNOTSUPP;
 }


