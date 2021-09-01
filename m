Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD573FD83A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 12:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhIAK5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 06:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhIAK5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 06:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B716F61056;
        Wed,  1 Sep 2021 10:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630493771;
        bh=7scoYMgPELA4Etwj5DTWJHWvdoqmUHsNnPlCREy0N7Y=;
        h=Subject:To:Cc:From:Date:From;
        b=WYjcNdmhgbfj7DZ/TlOQfwAn4nm9l28NOgU8zY2B3/9fYA/qV95E588m9qIVzqhvv
         VoUwU5kLntUvA8A+rrlpfs5BMCYsSV4B6l1ad0eM7eWJ3I0QhOBb91vhSSIQxzu+fn
         1Qaqb3jLqcFLI+FB5eFtS3a/nj8Y90GnKBwPqI5U=
Subject: FAILED: patch "[PATCH] f2fs: report correct st_size for encrypted symlinks" failed to apply to 5.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 12:56:08 +0200
Message-ID: <1630493768164104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 461b43a8f92e68e96c4424b31e15f2b35f1bbfa9 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 1 Jul 2021 23:53:48 -0700
Subject: [PATCH] f2fs: report correct st_size for encrypted symlinks

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after f2fs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: cbaf042a3cc6 ("f2fs crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index e149c8c66a71..9c528e583c9d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1323,9 +1323,19 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	return target;
 }
 
+static int f2fs_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	f2fs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.get_link	= f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 	.listxattr	= f2fs_listxattr,
 };

