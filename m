Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B3B3FE028
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbhIAQlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245462AbhIAQlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AB8610A4;
        Wed,  1 Sep 2021 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630514445;
        bh=33RC3YogqXCC1E17dtW915hQmiG+ogGdN4NtjjBgfzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1SO4KbLU/xzU1M6KMMYOaf9afJ4v/u3OImED28F07LnAtkkEDSyGFpwhjTFY/7mX
         iLnsv55XhW3ZZhRWFEday3Ioh9fNsCmFZuIM5grmwljJK3F3VujCcabRn8akneb4K8
         yA0gnSjU0YfE0msbkWjWShnoQ34G00wT4iKn7/QKTtJW2lUyCsFH09lFpjuDYRVR4H
         B+aQGAqJHVuPhezxASOlzyWbSpqNmogkF7izTuAQC1jRxVAdS1ScrM6LVE1w6B8Fgd
         5mVgOdhCvRz0LaOJUYdJJvZKIwHqbf3pNCUtK7meDb3dXkt3M7/gnjRsPimOHhxObw
         gcbGdJpnciuxA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 2/4] ext4: report correct st_size for encrypted symlinks
Date:   Wed,  1 Sep 2021 09:40:39 -0700
Message-Id: <20210901164041.176238-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901164041.176238-1-ebiggers@kernel.org>
References: <20210901164041.176238-1-ebiggers@kernel.org>
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
index dd05af983092d..a9457fed351ed 100644
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
2.33.0

