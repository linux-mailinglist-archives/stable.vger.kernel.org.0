Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4E73FD7D2
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 12:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhIAKmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 06:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231903AbhIAKmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 06:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B44D6102A;
        Wed,  1 Sep 2021 10:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630492878;
        bh=A+rpq14Dvx7XJ/BZTkh9ljK3RnY2WOzzNIaY372sYrs=;
        h=Subject:To:Cc:From:Date:From;
        b=L2FIR0d1EhW3MRrBQMSk9AfbFZiuaDNWJHdjg+RLzZz6BkAqoDY7EuZgaeSOig6rM
         qZ22uLoqiy4A1mAtOox6w9raKvZyxzWlE2itnXz/bb7wrC0ClJfNedEG+XRuCOHhL2
         vGeyAaD4VLmR6RWCoBjI90+XCNIpeGKCepKuIjXQ=
Subject: FAILED: patch "[PATCH] ext4: report correct st_size for encrypted symlinks" failed to apply to 4.19-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 12:41:06 +0200
Message-ID: <163049286619246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c4bca10ceafc43b1ca0a9fab5fa27e13cbce99e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 1 Jul 2021 23:53:47 -0700
Subject: [PATCH] ext4: report correct st_size for encrypted symlinks

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after ext4_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: f348c252320b ("ext4 crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092..69109746e6e2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,10 +52,20 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return paddr;
 }
 
+static int ext4_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	ext4_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_encrypted_symlink_getattr,
 	.listxattr	= ext4_listxattr,
 };
 

