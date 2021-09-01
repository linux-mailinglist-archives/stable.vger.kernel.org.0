Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FEE3FDFEB
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245218AbhIAQ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245513AbhIAQ3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37EF561053;
        Wed,  1 Sep 2021 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630513694;
        bh=IvOj3TWDsd4j4rGrt0HMpecdoT9QeKJnx5c98Hb3GYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjLpjeYq2gdPnVyWce7RFry5NtZnzyHaPldFdWlYR7SkAKXkiXXDIvzonnCSftLY9
         Aj4PfL+4A7GEpXUsBte2NPZHwJGKYucN7klQd1bZ/LNRi6WB5F1LwTMRVk24kNLYwA
         K4978sPLFm10Jl+znvkUmgdRohwdOivONAKaxnp17evz1OFI0TdZsNpa119JGRK8vg
         xCcvQTDXtRc4MbcIZXeHNMlbTXngUJG/6KfA5t+Zf5bdTCiygIeHIJfWqAF21qXitD
         aLlbh1jxc7uBIiGsBu5mm4zo71oJDkfLDCKeI6IrcV0nlCyt8YnlGHyA6GqzPPCSPz
         WuUwaoOW9L/Gw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.10 3/4] f2fs: report correct st_size for encrypted symlinks
Date:   Wed,  1 Sep 2021 09:27:20 -0700
Message-Id: <20210901162721.138605-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901162721.138605-1-ebiggers@kernel.org>
References: <20210901162721.138605-1-ebiggers@kernel.org>
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
index 17d0e5f4efec8..710a6f73a6858 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1307,9 +1307,18 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
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
 	.get_link	= f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 	.listxattr	= f2fs_listxattr,
 };
-- 
2.33.0

