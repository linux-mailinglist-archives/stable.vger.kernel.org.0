Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E9530AEA8
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 19:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBASDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 13:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBASDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 13:03:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213AB64EA5;
        Mon,  1 Feb 2021 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202577;
        bh=DJ9ICFsS9IRWDkenOCWqKHa2sb36lWtmArNO1qICcfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pm1WuywWJq5gJ3ZW+O+hWC9ubhoXFaoNL/jJGuOWVKNrYjWnFX4HPoH3RlArxl4xe
         iPrR/xnMiL9GyYnjcZARKsAaHzt0X4B2U83Zly4MPtqrDc4xIAp/WYhoQD/4dtuoM8
         7QuM9cCWTjnZ+2PU7yP2FAOuWBnRUifCu3uvKd2Y5dSXB+fLaDkq0QAfIpZPaSyHM3
         /9wa50Znvnlo3h1DmDSNuU/X3u8UsR16FBA/0D9BkBNyF3YRe8Ts7kHK2qaGcZUqZj
         IdjG9ciwx5j0tqtSni/R5Y6T6lOQu8swueaSndKyN/C3bYkgATKa2Ng53j+HEU5Dfn
         xag2UNtWOajTQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/9] crypto: michael_mic - fix broken misalignment handling
Date:   Mon,  1 Feb 2021 19:02:29 +0100
Message-Id: <20210201180237.3171-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Michael MIC driver uses the cra_alignmask to ensure that pointers
presented to its update and finup/final methods are 32-bit aligned.
However, due to the way the shash API works, this is no guarantee that
the 32-bit reads occurring in the update method are also aligned, as the
size of the buffer presented to update may be of uneven length. For
instance, an update() of 3 bytes followed by a misaligned update() of 4
or more bytes will result in a misaligned access using an accessor that
is not suitable for this.

On most architectures, this does not matter, and so setting the
cra_alignmask is pointless. On architectures where this does matter,
setting the cra_alignmask does not actually solve the problem.

So let's get rid of the cra_alignmask, and use unaligned accessors
instead, where appropriate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/michael_mic.c | 31 ++++++++------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 63350c4ad461..f4c31049601c 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -7,7 +7,7 @@
  * Copyright (c) 2004 Jouni Malinen <j@w1.fi>
  */
 #include <crypto/internal/hash.h>
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
@@ -19,7 +19,7 @@ struct michael_mic_ctx {
 };
 
 struct michael_mic_desc_ctx {
-	u8 pending[4];
+	__le32 pending;
 	size_t pending_len;
 
 	u32 l, r;
@@ -60,13 +60,12 @@ static int michael_update(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
 	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
-	const __le32 *src;
 
 	if (mctx->pending_len) {
 		int flen = 4 - mctx->pending_len;
 		if (flen > len)
 			flen = len;
-		memcpy(&mctx->pending[mctx->pending_len], data, flen);
+		memcpy((u8 *)&mctx->pending + mctx->pending_len, data, flen);
 		mctx->pending_len += flen;
 		data += flen;
 		len -= flen;
@@ -74,23 +73,21 @@ static int michael_update(struct shash_desc *desc, const u8 *data,
 		if (mctx->pending_len < 4)
 			return 0;
 
-		src = (const __le32 *)mctx->pending;
-		mctx->l ^= le32_to_cpup(src);
+		mctx->l ^= le32_to_cpu(mctx->pending);
 		michael_block(mctx->l, mctx->r);
 		mctx->pending_len = 0;
 	}
 
-	src = (const __le32 *)data;
-
 	while (len >= 4) {
-		mctx->l ^= le32_to_cpup(src++);
+		mctx->l ^= get_unaligned_le32(data);
 		michael_block(mctx->l, mctx->r);
+		data += 4;
 		len -= 4;
 	}
 
 	if (len > 0) {
 		mctx->pending_len = len;
-		memcpy(mctx->pending, src, len);
+		memcpy(&mctx->pending, data, len);
 	}
 
 	return 0;
@@ -100,8 +97,7 @@ static int michael_update(struct shash_desc *desc, const u8 *data,
 static int michael_final(struct shash_desc *desc, u8 *out)
 {
 	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
-	u8 *data = mctx->pending;
-	__le32 *dst = (__le32 *)out;
+	u8 *data = (u8 *)&mctx->pending;
 
 	/* Last block and padding (0x5a, 4..7 x 0) */
 	switch (mctx->pending_len) {
@@ -123,8 +119,8 @@ static int michael_final(struct shash_desc *desc, u8 *out)
 	/* l ^= 0; */
 	michael_block(mctx->l, mctx->r);
 
-	dst[0] = cpu_to_le32(mctx->l);
-	dst[1] = cpu_to_le32(mctx->r);
+	put_unaligned_le32(mctx->l, out);
+	put_unaligned_le32(mctx->r, out + 4);
 
 	return 0;
 }
@@ -135,13 +131,11 @@ static int michael_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct michael_mic_ctx *mctx = crypto_shash_ctx(tfm);
 
-	const __le32 *data = (const __le32 *)key;
-
 	if (keylen != 8)
 		return -EINVAL;
 
-	mctx->l = le32_to_cpu(data[0]);
-	mctx->r = le32_to_cpu(data[1]);
+	mctx->l = get_unaligned_le32(key);
+	mctx->r = get_unaligned_le32(key + 4);
 	return 0;
 }
 
@@ -156,7 +150,6 @@ static struct shash_alg alg = {
 		.cra_name		=	"michael_mic",
 		.cra_driver_name	=	"michael_mic-generic",
 		.cra_blocksize		=	8,
-		.cra_alignmask		=	3,
 		.cra_ctxsize		=	sizeof(struct michael_mic_ctx),
 		.cra_module		=	THIS_MODULE,
 	}
-- 
2.20.1

