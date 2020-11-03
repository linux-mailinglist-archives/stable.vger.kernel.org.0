Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8252A5557
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388677AbgKCVJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388649AbgKCVJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0676421534;
        Tue,  3 Nov 2020 21:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437739;
        bh=0oUTKBGJQP2/cY9pKCYFHOQHO0I/75GiG5qbTL/9mhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xw0fMMMVl5VPmB64cF6stj2NJtJM7RzjdvXBHMD2zWZF4nwDDyjdcZehWBCnKK9EE
         ZO6dhfDxWT/3Eubm9Qmwo8tJzxy4BqJiABe8aU7eIbl99+94BPl3sqYJlWlfgxF8R9
         sDKDCNWtn/NWZQL1tjQwS3eITDm3SdZxL/Ykw058=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.14 013/125] fscrypt: return -EXDEV for incompatible rename or link into encrypted dir
Date:   Tue,  3 Nov 2020 21:36:30 +0100
Message-Id: <20201103203158.649403860@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
 fs/crypto/policy.c |    3 +--
 fs/ext4/namei.c    |    6 +++---
 fs/f2fs/namei.c    |    6 +++---
 fs/ubifs/dir.c     |    6 +++---
 4 files changed, 10 insertions(+), 11 deletions(-)

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
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3280,7 +3280,7 @@ static int ext4_link(struct dentry *old_
 		return -EMLINK;
 	if (ext4_encrypted_inode(dir) &&
 			!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
        if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
 	   (!projid_eq(EXT4_I(dir)->i_projid,
@@ -3618,7 +3618,7 @@ static int ext4_rename(struct inode *old
 	if ((old.dir != new.dir) &&
 	    ext4_encrypted_inode(new.dir) &&
 	    !fscrypt_has_permitted_context(new.dir, old.inode)) {
-		retval = -EPERM;
+		retval = -EXDEV;
 		goto end_rename;
 	}
 
@@ -3798,7 +3798,7 @@ static int ext4_cross_rename(struct inod
 	    (old_dir != new_dir) &&
 	    (!fscrypt_has_permitted_context(new_dir, old.inode) ||
 	     !fscrypt_has_permitted_context(old_dir, new.inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -222,7 +222,7 @@ static int f2fs_link(struct dentry *old_
 
 	if (f2fs_encrypted_inode(dir) &&
 			!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	if (is_inode_flag_set(dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(dir)->i_projid,
@@ -746,7 +746,7 @@ static int f2fs_rename(struct inode *old
 
 	if ((old_dir != new_dir) && f2fs_encrypted_inode(new_dir) &&
 			!fscrypt_has_permitted_context(new_dir, old_inode)) {
-		err = -EPERM;
+		err = -EXDEV;
 		goto out;
 	}
 
@@ -942,7 +942,7 @@ static int f2fs_cross_rename(struct inod
 			(old_dir != new_dir) &&
 			(!fscrypt_has_permitted_context(new_dir, old_inode) ||
 			 !fscrypt_has_permitted_context(old_dir, new_inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -747,7 +747,7 @@ static int ubifs_link(struct dentry *old
 
 	if (ubifs_crypt_is_encrypted(dir) &&
 	    !fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
 	if (err)
@@ -1357,7 +1357,7 @@ static int do_rename(struct inode *old_d
 	if (old_dir != new_dir) {
 		if (ubifs_crypt_is_encrypted(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir, old_inode))
-			return -EPERM;
+			return -EXDEV;
 	}
 
 	if (unlink && is_dir) {
@@ -1579,7 +1579,7 @@ static int ubifs_xrename(struct inode *o
 	    (old_dir != new_dir) &&
 	    (!fscrypt_has_permitted_context(new_dir, fst_inode) ||
 	     !fscrypt_has_permitted_context(old_dir, snd_inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	err = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &fst_nm);
 	if (err)


