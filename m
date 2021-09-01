Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18373FE02B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344093AbhIAQls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245557AbhIAQlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5147A610A1;
        Wed,  1 Sep 2021 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630514445;
        bh=ElP2laRUl00Wi96e0SI4lSyjrbGNrqur4f5EenyoSTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qX0XOUEehdEYaI0UHP7IpqMsWavIItgDfgb2G5OnFiX+XpiOjMPU5rML3RMGUSEwu
         gBJdAxqn0weaiiy9Mb26tMlCL/bdagcVLEd8VrMx1QNl2giItBYMMkVOI1f+2JnXJT
         5rI1d0p3zom6jcQIe04PhBW8E9FtLQQqyCNAZn6VLgMG9jva9TyA/vpNv8HiIa9mY2
         9KleRONcBNucvCTCOcVryGzkv/IySONXNzlkCpADd9ds82pFB9exhRNVgFVODWNasY
         CJn94sT34Edf/OJNJuz+dsx1fMzHm3Mw05rSsKY4AFDKKVc7hL5PpOMlbjVkn96miU
         D9mfXT2fO2l+g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 3/4] f2fs: report correct st_size for encrypted symlinks
Date:   Wed,  1 Sep 2021 09:40:40 -0700
Message-Id: <20210901164041.176238-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901164041.176238-1-ebiggers@kernel.org>
References: <20210901164041.176238-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 461b43a8f92e68e96c4424b31e15f2b35f1bbfa9 upstream.

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
---
 fs/f2fs/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 3a97ac56821ba..81a18ba18e301 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1256,9 +1256,18 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	return target;
 }
 
+static int f2fs_encrypted_symlink_getattr(const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	f2fs_getattr(path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.get_link       = f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
 	.listxattr	= f2fs_listxattr,
-- 
2.33.0

