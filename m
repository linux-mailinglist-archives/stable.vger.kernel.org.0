Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2430D3FD8D3
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbhIALel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 07:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243809AbhIALej (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 07:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34C5260F6C;
        Wed,  1 Sep 2021 11:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630496022;
        bh=6eCUgyFWDZSkeWV7HajJ8XXRxMsU0Nwm7FgFbr91zZI=;
        h=Subject:To:Cc:From:Date:From;
        b=mmHgp2/4uRuD28YI5iSQB/j+pnFBje7y3tR4/kIq1HYLQk8Jp/OdpOStzCqITAZCN
         VOyECd/J2sP/uQBUlBGHF5zAP9TciU3puU4gJdGAFxv7W0321F+MT68gHJ49Mkpce4
         ghAHhmc7BM5E0Ns+uVy9/dxCBAh7OCwhUWwUUTp8=
Subject: FAILED: patch "[PATCH] ubifs: report correct st_size for encrypted symlinks" failed to apply to 5.10-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Sep 2021 13:33:40 +0200
Message-ID: <1630496020180238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 064c734986011390b4d111f1a99372b7f26c3850 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 1 Jul 2021 23:53:49 -0700
Subject: [PATCH] ubifs: report correct st_size for encrypted symlinks

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after ubifs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: ca7f85be8d6c ("ubifs: Add support for encrypted symlinks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 2e4e1d159969..5cfa28cd00cd 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1630,6 +1630,17 @@ static const char *ubifs_get_link(struct dentry *dentry,
 	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
 }
 
+static int ubifs_symlink_getattr(struct user_namespace *mnt_userns,
+				 const struct path *path, struct kstat *stat,
+				 u32 request_mask, unsigned int query_flags)
+{
+	ubifs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	if (IS_ENCRYPTED(d_inode(path->dentry)))
+		return fscrypt_symlink_getattr(path, stat);
+	return 0;
+}
+
 const struct address_space_operations ubifs_file_address_operations = {
 	.readpage       = ubifs_readpage,
 	.writepage      = ubifs_writepage,
@@ -1655,7 +1666,7 @@ const struct inode_operations ubifs_file_inode_operations = {
 const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = ubifs_get_link,
 	.setattr     = ubifs_setattr,
-	.getattr     = ubifs_getattr,
+	.getattr     = ubifs_symlink_getattr,
 	.listxattr   = ubifs_listxattr,
 	.update_time = ubifs_update_time,
 };

