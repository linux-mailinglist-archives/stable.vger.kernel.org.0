Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6C2A562E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgKCVCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387577AbgKCVCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D7C206B5;
        Tue,  3 Nov 2020 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437328;
        bh=WYPz9GCLoK8yqpbQpAb/S5o4qAgT2cqvPZcPYMc0Vck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkOnUgFxSz1Z5arFvLAevutrpOdv6KEFb+7O7l0lFe4UmPt3demKx9Rga2iHkd2dk
         x8irzT3w4PobgOAx2+10RkAK3jI1aft81oy+DCEHs7xH00rQx8pFnN3VLnfwvrNLcN
         3P5dlYzcHGuxAjaeMbj8NjYZEy6k0k4teYhRdAgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 029/191] fscrypt: return -EXDEV for incompatible rename or link into encrypted dir
Date:   Tue,  3 Nov 2020 21:35:21 +0100
Message-Id: <20201103203236.497451355@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit f5e55e777cc93eae1416f0fa4908e8846b6d7825 upstream.

Currently, trying to rename or link a regular file, directory, or
symlink into an encrypted directory fails with EPERM when the source
file is unencrypted or is encrypted with a different encryption policy,
and is on the same mountpoint.  It is correct for the operation to fail,
but the choice of EPERM breaks tools like 'mv' that know to copy rather
than rename if they see EXDEV, but don't know what to do with EPERM.

Our original motivation for EPERM was to encourage users to securely
handle their data.  Encrypting files by "moving" them into an encrypted
directory can be insecure because the unencrypted data may remain in
free space on disk, where it can later be recovered by an attacker.
It's much better to encrypt the data from the start, or at least try to
securely delete the source data e.g. using the 'shred' program.

However, the current behavior hasn't been effective at achieving its
goal because users tend to be confused, hack around it, and complain;
see e.g. https://github.com/google/fscrypt/issues/76.  And in some cases
it's actually inconsistent or unnecessary.  For example, 'mv'-ing files
between differently encrypted directories doesn't work even in cases
where it can be secure, such as when in userspace the same passphrase
protects both directories.  Yet, you *can* already 'mv' unencrypted
files into an encrypted directory if the source files are on a different
mountpoint, even though doing so is often insecure.

There are probably better ways to teach users to securely handle their
files.  For example, the 'fscrypt' userspace tool could provide a
command that migrates unencrypted files into an encrypted directory,
acting like 'shred' on the source files and providing appropriate
warnings depending on the type of the source filesystem and disk.

Receiving errors on unimportant files might also force some users to
disable encryption, thus making the behavior counterproductive.  It's
desirable to make encryption as unobtrusive as possible.

Therefore, change the error code from EPERM to EXDEV so that tools
looking for EXDEV will fall back to a copy.

This, of course, doesn't prevent users from still doing the right things
to securely manage their files.  Note that this also matches the
behavior when a file is renamed between two project quota hierarchies;
so there's precedent for using EXDEV for things other than mountpoints.

xfstests generic/398 will require an update with this change.

[Rewritten from an earlier patch series by Michael Halcrow.]

Cc: Michael Halcrow <mhalcrow@google.com>
Cc: Joe Richey <joerichey@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 Documentation/filesystems/fscrypt.rst |   12 ++++++++++--
 fs/crypto/hooks.c                     |    6 +++---
 fs/crypto/policy.c                    |    3 +--
 include/linux/fscrypt.h               |    4 ++--
 4 files changed, 16 insertions(+), 9 deletions(-)

--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -426,10 +426,18 @@ astute users may notice some differences
 - Unencrypted files, or files encrypted with a different encryption
   policy (i.e. different key, modes, or flags), cannot be renamed or
   linked into an encrypted directory; see `Encryption policy
-  enforcement`_.  Attempts to do so will fail with EPERM.  However,
+  enforcement`_.  Attempts to do so will fail with EXDEV.  However,
   encrypted files can be renamed within an encrypted directory, or
   into an unencrypted directory.
 
+  Note: "moving" an unencrypted file into an encrypted directory, e.g.
+  with the `mv` program, is implemented in userspace by a copy
+  followed by a delete.  Be aware that the original unencrypted data
+  may remain recoverable from free space on the disk; prefer to keep
+  all files encrypted from the very beginning.  The `shred` program
+  may be used to overwrite the source files but isn't guaranteed to be
+  effective on all filesystems and storage devices.
+
 - Direct I/O is not supported on encrypted files.  Attempts to use
   direct I/O on such files will fall back to buffered I/O.
 
@@ -516,7 +524,7 @@ not be encrypted.
 Except for those special files, it is forbidden to have unencrypted
 files, or files encrypted with a different encryption policy, in an
 encrypted directory tree.  Attempts to link or rename such a file into
-an encrypted directory will fail with EPERM.  This is also enforced
+an encrypted directory will fail with EXDEV.  This is also enforced
 during ->lookup() to provide limited protection against offline
 attacks that try to disable or downgrade encryption in known locations
 where applications may later write sensitive data.  It is recommended
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -58,7 +58,7 @@ int __fscrypt_prepare_link(struct inode
 		return err;
 
 	if (!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	return 0;
 }
@@ -82,13 +82,13 @@ int __fscrypt_prepare_rename(struct inod
 		if (IS_ENCRYPTED(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir,
 						   d_inode(old_dentry)))
-			return -EPERM;
+			return -EXDEV;
 
 		if ((flags & RENAME_EXCHANGE) &&
 		    IS_ENCRYPTED(old_dir) &&
 		    !fscrypt_has_permitted_context(old_dir,
 						   d_inode(new_dentry)))
-			return -EPERM;
+			return -EXDEV;
 	}
 	return 0;
 }
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -153,8 +153,7 @@ EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
  * malicious offline violations of this constraint, while the link and rename
  * checks are needed to prevent online violations of this constraint.
  *
- * Return: 1 if permitted, 0 if forbidden.  If forbidden, the caller must fail
- * the filesystem operation with EPERM.
+ * Return: 1 if permitted, 0 if forbidden.
  */
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -89,7 +89,7 @@ static inline int fscrypt_require_key(st
  * in an encrypted directory tree use the same encryption policy.
  *
  * Return: 0 on success, -ENOKEY if the directory's encryption key is missing,
- * -EPERM if the link would result in an inconsistent encryption policy, or
+ * -EXDEV if the link would result in an inconsistent encryption policy, or
  * another -errno code.
  */
 static inline int fscrypt_prepare_link(struct dentry *old_dentry,
@@ -119,7 +119,7 @@ static inline int fscrypt_prepare_link(s
  * We also verify that the rename will not violate the constraint that all files
  * in an encrypted directory tree use the same encryption policy.
  *
- * Return: 0 on success, -ENOKEY if an encryption key is missing, -EPERM if the
+ * Return: 0 on success, -ENOKEY if an encryption key is missing, -EXDEV if the
  * rename would cause inconsistent encryption policies, or another -errno code.
  */
 static inline int fscrypt_prepare_rename(struct inode *old_dir,


