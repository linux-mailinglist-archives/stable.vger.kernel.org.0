Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD83B9C7C
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhGBG50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 02:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhGBG5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 02:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272A961410;
        Fri,  2 Jul 2021 06:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625208891;
        bh=NFKe+Rh35XCUFQjlTK/C5r/wZ9hR1rSfzhzMNQKZWXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvRZop+k2n401pFsbas/CVW3bm74+XhbaKBfce27QrnxiwBF4+7Drowi/O4jEJErk
         ApD3a5v/fsBnarKjCn4pI/DvcFrEI0iIDAohB9eDGN0fJZ5VdzD6Ze6tpzSEaQDFM5
         /SL27l/2bdUy0+z7gd7x/l+UeUxHARI0DAcV1q0s2LJsRdpbD7sBfqYH4nkms5Zyc7
         Cu7u1E2tXDPXtJF/+w1JRXQB8aBQWegVDCnNkwgpqkBl7G55KR5X8ah6pQgSbQ08pQ
         sTwYE4t1vyhoCPvez+Xuz1Oju2i4poy2TCsSajJqP4981fP+IEa8RTfmPf8+uUwOv5
         gTb2GBio352OQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/5] ext4: report correct st_size for encrypted symlinks
Date:   Thu,  1 Jul 2021 23:53:47 -0700
Message-Id: <20210702065350.209646-3-ebiggers@kernel.org>
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

Fix this by calling fscrypt_symlink_getattr() after ext4_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: f348c252320b ("ext4 crypto: add symlink encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/symlink.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

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
 
-- 
2.32.0

