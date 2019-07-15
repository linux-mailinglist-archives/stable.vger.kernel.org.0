Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586B268C26
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbfGONtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbfGONtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:49:18 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 114262067C;
        Mon, 15 Jul 2019 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198557;
        bh=2MT316orRpKV/zz0pt5fGQlodNtGuYB5QOV1wiMuewY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woq3kK208csxKkxgg2v2p7tqtmPsNw4hrx193c6KEERaH4/ICIm8CR5nAc+I8VWUk
         bGznHD4QKD+qhB/SBveXnqg1SSYSuce6s2nlTQurH1OeJLsY3usbfS5ewUDXvQgKpX
         FLGaqHZ95lrpEhDPJpJKUS5iog8UqlIwrOdWbx9w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 044/249] fscrypt: clean up some BUG_ON()s in block encryption/decryption
Date:   Mon, 15 Jul 2019 09:43:29 -0400
Message-Id: <20190715134655.4076-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit eeacfdc68a104967162dfcba60f53f6f5b62a334 ]

Replace some BUG_ON()s with WARN_ON_ONCE() and returning an error code,
and move the check for len divisible by FS_CRYPTO_BLOCK_SIZE into
fscrypt_crypt_block() so that it's done for both encryption and
decryption, not just encryption.

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/crypto.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 335a362ee446..6f753198eeef 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -154,7 +154,10 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
 	int res = 0;
 
-	BUG_ON(len == 0);
+	if (WARN_ON_ONCE(len <= 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(len % FS_CRYPTO_BLOCK_SIZE != 0))
+		return -EINVAL;
 
 	fscrypt_generate_iv(&iv, lblk_num, ci);
 
@@ -238,8 +241,6 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 	struct page *ciphertext_page = page;
 	int err;
 
-	BUG_ON(len % FS_CRYPTO_BLOCK_SIZE != 0);
-
 	if (inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES) {
 		/* with inplace-encryption we just encrypt the page */
 		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num, page,
@@ -251,7 +252,8 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 		return ciphertext_page;
 	}
 
-	BUG_ON(!PageLocked(page));
+	if (WARN_ON_ONCE(!PageLocked(page)))
+		return ERR_PTR(-EINVAL);
 
 	ctx = fscrypt_get_ctx(gfp_flags);
 	if (IS_ERR(ctx))
@@ -299,8 +301,9 @@ EXPORT_SYMBOL(fscrypt_encrypt_page);
 int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 			unsigned int len, unsigned int offs, u64 lblk_num)
 {
-	if (!(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES))
-		BUG_ON(!PageLocked(page));
+	if (WARN_ON_ONCE(!PageLocked(page) &&
+			 !(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES)))
+		return -EINVAL;
 
 	return fscrypt_do_page_crypto(inode, FS_DECRYPT, lblk_num, page, page,
 				      len, offs, GFP_NOFS);
-- 
2.20.1

