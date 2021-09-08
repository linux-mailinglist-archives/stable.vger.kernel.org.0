Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1124A4040B5
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhIHVwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 17:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235491AbhIHVwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 17:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B4BA60FDA;
        Wed,  8 Sep 2021 21:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631137889;
        bh=i6jyH8PvgB9yhUYtCQiIMlEe2F7QGBiOJVd7oI0isaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uc0ABPV3twDuxLbMd8GxOBFitN/d4dzY/uDlYPFrSwJ2ssdr1If877Acir+VjZZ8n
         Nt/1rGsencho7jBMorqXtpxbbAGOew+veyR+teonjCszMDWx75NRw2lv/M/1JDvZgE
         p6ecHZl1/g/3/8zg5mkWJqIhBqONxZnc+NctmDqqVS45hJ+/JP9bsKIhSTIVU4hLJT
         mC6a5VpUhXm37nyOBu54PPLjy8QaT9GOey4LjQfuAp8Nz0dM8f7Qgw9gHni6eqO2Hr
         br4oThTq/jK3hdSY3kuxtu/Qxx8lyhEc545uStdAaEsUArmfAqD5pOq6M2Ok1P+Rq6
         Y/EuKsKzzo1Ug==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 3/4] f2fs: report correct st_size for encrypted symlinks
Date:   Wed,  8 Sep 2021 14:50:32 -0700
Message-Id: <20210908215033.1122580-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
In-Reply-To: <20210908215033.1122580-1-ebiggers@kernel.org>
References: <20210908215033.1122580-1-ebiggers@kernel.org>
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
index e20a0f9e6845..edc80855974a 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1219,9 +1219,18 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
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
2.33.0.153.gba50c8fa24-goog

