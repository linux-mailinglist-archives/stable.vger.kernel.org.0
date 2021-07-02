Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521B03B9C7F
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhGBG51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 02:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhGBG5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 02:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A419F61416;
        Fri,  2 Jul 2021 06:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625208891;
        bh=8UwGI3mTEOy+/FNQC2YBcGZZYXAkamywQ/BEcm9u/PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bn/fBOYp3M8tUVY2Ebpw1Q47/lWTLSOQ+UWnSo+oVj4xZO7jBEZ9Wu1cyV6oLrjB1
         wuoEQ5TLRZ86nsoPIVZ+f7ip9+en17J39v+pGwJ9AOrJvlph0XvJSUgm6jwHyedRM2
         HOQZkcuz29/kb7XRvZaLkLymKDYI4oVQzAKIOR0oLqgRVzDXqRrwhuyOz/bKcmIz/4
         4OzQppuvSS+8tjlf9zZHd3bKnqTo3MpfQghXb1m/rXOfUPfbkqzO+ZTYAhOLjdYwqF
         ImwrigtKqh+S4TycOXhqEoX7+Qk7TgnvEEDzz/R7PaCMN/43fJOnvplzZkz6Ts8Wnf
         MSx1YWjnRsnAQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 4/5] ubifs: report correct st_size for encrypted symlinks
Date:   Thu,  1 Jul 2021 23:53:49 -0700
Message-Id: <20210702065350.209646-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702065350.209646-1-ebiggers@kernel.org>
References: <20210702065350.209646-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after ubifs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: ca7f85be8d6c ("ubifs: Add support for encrypted symlinks")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

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
-- 
2.32.0

