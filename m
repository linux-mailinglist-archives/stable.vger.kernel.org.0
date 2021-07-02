Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF23B9C7B
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhGBG5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 02:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGBG5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 02:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659D461413;
        Fri,  2 Jul 2021 06:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625208891;
        bh=oytk1FqAK/cRWx3e72Lrjf5gkgDm1h+IK3FE/F4jrDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBRQEhrJJ96bGUI9d8xd7QPa3WJ5ACNQiNFFlLiciyLDX/+kJJiMK4kdY7t2a/Hu8
         L/JOKII31seusjSyqQH0p0zJVYGN3K/WIcgd4EvZ76bvtCnhC2R1Qi/gBZ1nIw4M5l
         /qtnEb4tJYlMpY81DoSUpGC6zCG/nQqQ/+GfV7vfTFAIkkyWTE3QNeeLSLVuC6wUlG
         ZFUirevxfCcRDTK+uQT13qFXoBgPqyIzKhznOb6tw3I87oy1lri67ZPC8T7fSxItPB
         ZiksVnwYTJeunNRiKmM8dyfsMgSZAi9iigVse/a8GYIuCo22x+3oUZcck+67uOfckh
         4dfuQHiZ4sTjQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/5] f2fs: report correct st_size for encrypted symlinks
Date:   Thu,  1 Jul 2021 23:53:48 -0700
Message-Id: <20210702065350.209646-4-ebiggers@kernel.org>
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

Fix this by calling fscrypt_symlink_getattr() after f2fs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: cbaf042a3cc6 ("f2fs crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/namei.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a9cd9cf97229..e2d540ae2293 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1305,9 +1305,19 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
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
-- 
2.32.0

