Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685344040B3
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 23:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhIHVwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 17:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235602AbhIHVwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 17:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B7E8610F8;
        Wed,  8 Sep 2021 21:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631137889;
        bh=KoVck986relZorHv7Og0MrrnvSEGPQxM/Ce82S4543I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djxv3m0xGbBVx+UNIvmpHx8cZckH7eE8lOVxji2c4kw6syS4aTOebWeaYfIU2OlZn
         5mkJiQwQN8zUcAHRbz+vHGtcRPj+b80614KfoJND4jKGVBCU4d3AvgDQegdEbV9AGf
         Yvuo/EFdvS1er0WGlHd2sc/7RtLAGNA/ZsivoIl62PXpNoTwuY9zCYS7JiHE2QroN9
         RFIgFr7Er89OvNZwiPXjvCToXflBgNUIHgw6RTrPAqHPNweItKIee4IZEIGZc9zhBD
         g7OLKhrryDH847WLVqTS74OFy4hD0wca7jtZUQ+dRUeTmy+aM3SwpvvAYPdXuj4Fyi
         CHYRZsoHOcKAg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 2/4] ext4: report correct st_size for encrypted symlinks
Date:   Wed,  8 Sep 2021 14:50:31 -0700
Message-Id: <20210908215033.1122580-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
In-Reply-To: <20210908215033.1122580-1-ebiggers@kernel.org>
References: <20210908215033.1122580-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8c4bca10ceafc43b1ca0a9fab5fa27e13cbce99e upstream.

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
---
 fs/ext4/symlink.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092..a9457fed351e 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,10 +52,19 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return paddr;
 }
 
+static int ext4_encrypted_symlink_getattr(const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	ext4_getattr(path, stat, request_mask, query_flags);
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
2.33.0.153.gba50c8fa24-goog

