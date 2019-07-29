Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8F4793FC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfG2T0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbfG2T0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:26:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B2721773;
        Mon, 29 Jul 2019 19:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428396;
        bh=kgKS+LMdkKPPHCb6GVjY3hWtP1rEuJZq78YZ0Pj86O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/aOkT4pNTrKOfvYBIApwqmf2wqFQrXTgb9LMlo734eSyyJbxojW96Cwlqv9x0zNX
         iaiTA1m3mDEL4TRHnYULahewU1ZOTyQ99OOWkynUwEFhiDUGDWgcoTuw/PMhQXjbEy
         5jEgaJ0gMBZzUN4osAYUkrv5h4RAHZ1zDJAf2JrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/293] fscrypt: clean up some BUG_ON()s in block encryption/decryption
Date:   Mon, 29 Jul 2019 21:18:35 +0200
Message-Id: <20190729190823.128833624@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index daf2683f0655..f862ad19c714 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -157,7 +157,10 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
 	int res = 0;
 
-	BUG_ON(len == 0);
+	if (WARN_ON_ONCE(len <= 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(len % FS_CRYPTO_BLOCK_SIZE != 0))
+		return -EINVAL;
 
 	BUILD_BUG_ON(sizeof(iv) != FS_IV_SIZE);
 	BUILD_BUG_ON(AES_BLOCK_SIZE != FS_IV_SIZE);
@@ -257,8 +260,6 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 	struct page *ciphertext_page = page;
 	int err;
 
-	BUG_ON(len % FS_CRYPTO_BLOCK_SIZE != 0);
-
 	if (inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES) {
 		/* with inplace-encryption we just encrypt the page */
 		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num, page,
@@ -270,7 +271,8 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 		return ciphertext_page;
 	}
 
-	BUG_ON(!PageLocked(page));
+	if (WARN_ON_ONCE(!PageLocked(page)))
+		return ERR_PTR(-EINVAL);
 
 	ctx = fscrypt_get_ctx(inode, gfp_flags);
 	if (IS_ERR(ctx))
@@ -318,8 +320,9 @@ EXPORT_SYMBOL(fscrypt_encrypt_page);
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



