Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87139175
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfFGPkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbfFGPkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:40:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6234120840;
        Fri,  7 Jun 2019 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922044;
        bh=o1Vka6At+A1+UK3C55LJMF33CWzgZLBqjLWVLHcfxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaFbBnuFyrjdslkQllvJsh5B3dghkAGmMqyCDE6UwFZTB7gGksrCQOhCcd1cUhLnf
         Z/hE06XRX7akQaGuaHH2WOxEP6vPbaP4nddXDMXLgQUe+btgFZIetzezAwg4Km6GKU
         +CsQhUJqwmufeUrnCc0R/SRH3g8yb79AdUG4WGgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Daniel Axtens <dja@axtens.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 17/69] crypto: vmx - ghash: do nosimd fallback manually
Date:   Fri,  7 Jun 2019 17:38:58 +0200
Message-Id: <20190607153850.441468818@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit 357d065a44cdd77ed5ff35155a989f2a763e96ef upstream.

VMX ghash was using a fallback that did not support interleaving simd
and nosimd operations, leading to failures in the extended test suite.

If I understood correctly, Eric's suggestion was to use the same
data format that the generic code uses, allowing us to call into it
with the same contexts. I wasn't able to get that to work - I think
there's a very different key structure and data layout being used.

So instead steal the arm64 approach and perform the fallback
operations directly if required.

Fixes: cc333cd68dfa ("crypto: vmx - Adding GHASH routines for VMX module")
Cc: stable@vger.kernel.org # v4.1+
Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/vmx/ghash.c |  213 ++++++++++++++++++---------------------------
 1 file changed, 87 insertions(+), 126 deletions(-)

--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -1,22 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * GHASH routines supporting VMX instructions on the Power 8
  *
- * Copyright (C) 2015 International Business Machines Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright (C) 2015, 2019 International Business Machines Inc.
  *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
+ *
+ * Extended by Daniel Axtens <dja@axtens.net> to replace the fallback
+ * mechanism. The new approach is based on arm64 code, which is:
+ *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/types.h>
@@ -39,71 +31,25 @@ void gcm_ghash_p8(u64 Xi[2], const u128
 		  const u8 *in, size_t len);
 
 struct p8_ghash_ctx {
+	/* key used by vector asm */
 	u128 htable[16];
-	struct crypto_shash *fallback;
+	/* key used by software fallback */
+	be128 key;
 };
 
 struct p8_ghash_desc_ctx {
 	u64 shash[2];
 	u8 buffer[GHASH_DIGEST_SIZE];
 	int bytes;
-	struct shash_desc fallback_desc;
 };
 
-static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
-{
-	const char *alg = "ghash-generic";
-	struct crypto_shash *fallback;
-	struct crypto_shash *shash_tfm = __crypto_shash_cast(tfm);
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	fallback = crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(fallback)) {
-		printk(KERN_ERR
-		       "Failed to allocate transformation for '%s': %ld\n",
-		       alg, PTR_ERR(fallback));
-		return PTR_ERR(fallback);
-	}
-
-	crypto_shash_set_flags(fallback,
-			       crypto_shash_get_flags((struct crypto_shash
-						       *) tfm));
-
-	/* Check if the descsize defined in the algorithm is still enough. */
-	if (shash_tfm->descsize < sizeof(struct p8_ghash_desc_ctx)
-	    + crypto_shash_descsize(fallback)) {
-		printk(KERN_ERR
-		       "Desc size of the fallback implementation (%s) does not match the expected value: %lu vs %u\n",
-		       alg,
-		       shash_tfm->descsize - sizeof(struct p8_ghash_desc_ctx),
-		       crypto_shash_descsize(fallback));
-		return -EINVAL;
-	}
-	ctx->fallback = fallback;
-
-	return 0;
-}
-
-static void p8_ghash_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	if (ctx->fallback) {
-		crypto_free_shash(ctx->fallback);
-		ctx->fallback = NULL;
-	}
-}
-
 static int p8_ghash_init(struct shash_desc *desc)
 {
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	dctx->bytes = 0;
 	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
-	dctx->fallback_desc.tfm = ctx->fallback;
-	dctx->fallback_desc.flags = desc->flags;
-	return crypto_shash_init(&dctx->fallback_desc);
+	return 0;
 }
 
 static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -121,7 +67,51 @@ static int p8_ghash_setkey(struct crypto
 	disable_kernel_vsx();
 	pagefault_enable();
 	preempt_enable();
-	return crypto_shash_setkey(ctx->fallback, key, keylen);
+
+	memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
+
+	return 0;
+}
+
+static inline void __ghash_block(struct p8_ghash_ctx *ctx,
+				 struct p8_ghash_desc_ctx *dctx)
+{
+	if (!IN_INTERRUPT) {
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				dctx->buffer, GHASH_DIGEST_SIZE);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+	} else {
+		crypto_xor((u8 *)dctx->shash, dctx->buffer, GHASH_BLOCK_SIZE);
+		gf128mul_lle((be128 *)dctx->shash, &ctx->key);
+	}
+}
+
+static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
+				  struct p8_ghash_desc_ctx *dctx,
+				  const u8 *src, unsigned int srclen)
+{
+	if (!IN_INTERRUPT) {
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				src, srclen);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+	} else {
+		while (srclen >= GHASH_BLOCK_SIZE) {
+			crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
+			gf128mul_lle((be128 *)dctx->shash, &ctx->key);
+			srclen -= GHASH_BLOCK_SIZE;
+			src += GHASH_BLOCK_SIZE;
+		}
+	}
 }
 
 static int p8_ghash_update(struct shash_desc *desc,
@@ -131,49 +121,33 @@ static int p8_ghash_update(struct shash_
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (IN_INTERRUPT) {
-		return crypto_shash_update(&dctx->fallback_desc, src,
-					   srclen);
-	} else {
-		if (dctx->bytes) {
-			if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
-				memcpy(dctx->buffer + dctx->bytes, src,
-				       srclen);
-				dctx->bytes += srclen;
-				return 0;
-			}
+	if (dctx->bytes) {
+		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
 			memcpy(dctx->buffer + dctx->bytes, src,
-			       GHASH_DIGEST_SIZE - dctx->bytes);
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			src += GHASH_DIGEST_SIZE - dctx->bytes;
-			srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
-			dctx->bytes = 0;
+				srclen);
+			dctx->bytes += srclen;
+			return 0;
 		}
-		len = srclen & ~(GHASH_DIGEST_SIZE - 1);
-		if (len) {
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			src += len;
-			srclen -= len;
-		}
-		if (srclen) {
-			memcpy(dctx->buffer, src, srclen);
-			dctx->bytes = srclen;
-		}
-		return 0;
+		memcpy(dctx->buffer + dctx->bytes, src,
+			GHASH_DIGEST_SIZE - dctx->bytes);
+
+		__ghash_block(ctx, dctx);
+
+		src += GHASH_DIGEST_SIZE - dctx->bytes;
+		srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
+		dctx->bytes = 0;
+	}
+	len = srclen & ~(GHASH_DIGEST_SIZE - 1);
+	if (len) {
+		__ghash_blocks(ctx, dctx, src, len);
+		src += len;
+		srclen -= len;
 	}
+	if (srclen) {
+		memcpy(dctx->buffer, src, srclen);
+		dctx->bytes = srclen;
+	}
+	return 0;
 }
 
 static int p8_ghash_final(struct shash_desc *desc, u8 *out)
@@ -182,25 +156,14 @@ static int p8_ghash_final(struct shash_d
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (IN_INTERRUPT) {
-		return crypto_shash_final(&dctx->fallback_desc, out);
-	} else {
-		if (dctx->bytes) {
-			for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
-				dctx->buffer[i] = 0;
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			dctx->bytes = 0;
-		}
-		memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
-		return 0;
+	if (dctx->bytes) {
+		for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
+			dctx->buffer[i] = 0;
+		__ghash_block(ctx, dctx);
+		dctx->bytes = 0;
 	}
+	memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
+	return 0;
 }
 
 struct shash_alg p8_ghash_alg = {
@@ -215,11 +178,9 @@ struct shash_alg p8_ghash_alg = {
 		 .cra_name = "ghash",
 		 .cra_driver_name = "p8_ghash",
 		 .cra_priority = 1000,
-		 .cra_flags = CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_NEED_FALLBACK,
+		 .cra_flags = CRYPTO_ALG_TYPE_SHASH,
 		 .cra_blocksize = GHASH_BLOCK_SIZE,
 		 .cra_ctxsize = sizeof(struct p8_ghash_ctx),
 		 .cra_module = THIS_MODULE,
-		 .cra_init = p8_ghash_init_tfm,
-		 .cra_exit = p8_ghash_exit_tfm,
 	},
 };


