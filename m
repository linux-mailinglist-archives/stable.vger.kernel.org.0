Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E552ABDC2
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgKINtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729817AbgKIM4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C63208FE;
        Mon,  9 Nov 2020 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926575;
        bh=nrH2hU3hwpPBEY5fbZQPXXDgNeFP4A+Z4c6DQ1q30xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyJ4XFJS2GQLF0gf+5yRe2uartTHZupAOR1iXWc++No5QyQcdNGBf+DvGWVv1xZTZ
         QJEre2NsJ8yCX/S8wZwqc5BMRNuMpPk5LY59GPrugKzPBl+i1s81Ricnb5airBmDPg
         Dk3pVzSJEbs3oWCA4aaqrcOOi4e9+B2bev75rSbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.4 09/86] fscrypt: return -EXDEV for incompatible rename or link into encrypted dir
Date:   Mon,  9 Nov 2020 13:54:16 +0100
Message-Id: <20201109125021.309070153@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
 fs/ext4/namei.c |    6 +++---
 fs/f2fs/namei.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3218,7 +3218,7 @@ static int ext4_link(struct dentry *old_
 		return -EMLINK;
 	if (ext4_encrypted_inode(dir) &&
 	    !ext4_is_child_context_consistent_with_parent(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 	err = dquot_initialize(dir);
 	if (err)
 		return err;
@@ -3537,7 +3537,7 @@ static int ext4_rename(struct inode *old
 	    ext4_encrypted_inode(new.dir) &&
 	    !ext4_is_child_context_consistent_with_parent(new.dir,
 							  old.inode)) {
-		retval = -EPERM;
+		retval = -EXDEV;
 		goto end_rename;
 	}
 
@@ -3718,7 +3718,7 @@ static int ext4_cross_rename(struct inod
 							   old.inode) ||
 	     !ext4_is_child_context_consistent_with_parent(old_dir,
 							   new.inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	retval = dquot_initialize(old.dir);
 	if (retval)
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -169,7 +169,7 @@ static int f2fs_link(struct dentry *old_
 
 	if (f2fs_encrypted_inode(dir) &&
 		!f2fs_is_child_context_consistent_with_parent(dir, inode))
-		return -EPERM;
+		return -EXDEV;
 
 	f2fs_balance_fs(sbi);
 
@@ -597,7 +597,7 @@ static int f2fs_rename(struct inode *old
 	if ((old_dir != new_dir) && f2fs_encrypted_inode(new_dir) &&
 		!f2fs_is_child_context_consistent_with_parent(new_dir,
 							old_inode)) {
-		err = -EPERM;
+		err = -EXDEV;
 		goto out;
 	}
 
@@ -758,7 +758,7 @@ static int f2fs_cross_rename(struct inod
 								old_inode) ||
 		!f2fs_is_child_context_consistent_with_parent(old_dir,
 								new_inode)))
-		return -EPERM;
+		return -EXDEV;
 
 	f2fs_balance_fs(sbi);
 


