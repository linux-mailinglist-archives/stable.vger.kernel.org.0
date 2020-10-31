Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3352A1A38
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgJaTGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 15:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgJaTGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 15:06:41 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A69205ED;
        Sat, 31 Oct 2020 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604171200;
        bh=d+/c+7Fnv4byX9qUFUAXwzitQsidOMxkPzy0wEio50U=;
        h=From:To:Cc:Subject:Date:From;
        b=tNv9IGUMgz+Awi7f6uxEot7BrEGYOdzdEY1KqSThPkjB4AAfrYIXbZn9jtMDXLG3+
         HBgq/TR719ltnm0sQKqZgetNiLisLXGPP/3KEjr9TkKgoveaz3nEQYxYc2tULaUvJu
         kRgbztkG9xc0GezgsL7vjiFuMgebIKoHKi8khUf8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 4.9] fscrypt: return -EXDEV for incompatible rename or link into encrypted dir
Date:   Sat, 31 Oct 2020 12:06:22 -0700
Message-Id: <20201031190622.256948-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit f5e55e777cc93eae1416f0fa4908e8846b6d7825 upstream.
[Please apply to 4.9-stable.  This is an important fix to have,
and it will be needed for xfstest generic/398 to pass if
https://lkml.kernel.org/r/20201031054141.695517-1-ebiggers@kernel.org
is applied.  Note, this commit had to be reworked to apply to 4.9.]

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
---
 fs/crypto/policy.c | 3 +--
 fs/ext4/namei.c    | 6 +++---
 fs/f2fs/namei.c    | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 57a97b38a2fa2..51f4463718e84 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -180,8 +180,7 @@ EXPORT_SYMBOL(fscrypt_get_policy);
  * malicious offline violations of this constraint, while the link and rename
  * checks are needed to prevent online violations of this constraint.
  *
- * Return: 1 if permitted, 0 if forbidden.  If forbidden, the caller must fail
- * the filesystem operation with EPERM.
+ * Return: 1 if permitted, 0 if forbidden.
  */
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 157dbbe235f90..8ded38ac4cdef 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3259,7 +3259,7 @@ static int ext4_link(struct dentry *old_dentry,
 		return -EMLINK;
 	if (ext4_encrypted_inode(dir) &&
 			!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
        if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
 	   (!projid_eq(EXT4_I(dir)->i_projid,
@@ -3597,7 +3597,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if ((old.dir != new.dir) &&
 	    ext4_encrypted_inode(new.dir) &&
 	    !fscrypt_has_permitted_context(new.dir, old.inode)) {
-		retval = -EPERM;
+		retval = -EXDEV;
 		goto end_rename;
 	}
 
@@ -3776,7 +3776,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    (old_dir != new_dir) &&
 	    (!fscrypt_has_permitted_context(new_dir, old.inode) ||
 	     !fscrypt_has_permitted_context(old_dir, new.inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ccb99d5cfd8b0..ce0957318771c 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -177,7 +177,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (f2fs_encrypted_inode(dir) &&
 			!fscrypt_has_permitted_context(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	f2fs_balance_fs(sbi, true);
 
@@ -667,7 +667,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if ((old_dir != new_dir) && f2fs_encrypted_inode(new_dir) &&
 			!fscrypt_has_permitted_context(new_dir, old_inode)) {
-		err = -EPERM;
+		err = -EXDEV;
 		goto out;
 	}
 
@@ -855,7 +855,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 			(old_dir != new_dir) &&
 			(!fscrypt_has_permitted_context(new_dir, old_inode) ||
 			 !fscrypt_has_permitted_context(old_dir, new_inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_entry) {
-- 
2.29.1

