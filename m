Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815ED3FD7E5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 12:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbhIAKoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 06:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235353AbhIAKoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 06:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43DE6102A;
        Wed,  1 Sep 2021 10:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630493013;
        bh=LmPo0/kakr7NIDsmags9IOhyNdqhIKN4ce/9RMYFXo8=;
        h=Subject:To:Cc:From:Date:From;
        b=gn55yDU/BFhJPV7VkNelEky0HzP4UwBMmtxCuax3getBBpdFekgXlMnQ2toCPEOyw
         X8Gbf1mcngnRoO7hGb+uslv6I93iEGp4ZrsxRgpI7U76L2qNQ+rFaW153jQsSBVocQ
         N9Q4wNiBKdT2PTmgJmj2XZHFyaKIYJVZ6kDC0iPc=
Subject: FAILED: patch "[PATCH] f2fs: report correct st_size for encrypted symlinks" failed to apply to 4.14-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 12:43:23 +0200
Message-ID: <1630493003147115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

