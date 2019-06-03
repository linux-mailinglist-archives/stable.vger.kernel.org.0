Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76C3265E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 04:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFCCJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jun 2019 22:09:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39644 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCCJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jun 2019 22:09:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so7351901pgc.6
        for <stable@vger.kernel.org>; Sun, 02 Jun 2019 19:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stz73iUf9C6RHHj3xWZfepbbnMyNao045W9wPexeqOg=;
        b=OWV+H2ukCkdcMzBttQVcGVVY/ANUL2/4r1X7AY/OpH5D16JJup0DYJtgmo+zicX5Jv
         0VMGP2aS03USXjvIUoknRaRoJsfKg0lVy+h4tBa8JlZBX9OH281VnGv44MIdQWUjfW4F
         b0/BuVLfgjxapSRnGjmkHbdb9LLD60Yrxrdts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stz73iUf9C6RHHj3xWZfepbbnMyNao045W9wPexeqOg=;
        b=BNoV4XuoCUEYeqPZUQp6UMiKBCRuUkNeEnRoz5krOK1PiVyRqGJZ/akeE0pC2TtLsg
         rp1/V8uZPW23Y018MhErZbSubxf8GLa5WJUtWCHtzWkY7MVEUPL6V6mhLwfnq+HgZ6wG
         vQdd5K5htbVFAA64+MveWYEXUI3ZR5TRQ7DhOMpo7z9AMolxeTxZbwSGsrRm9RaPNZYO
         A5NPGE2r98yzezlG6Jiucr59BVXsYTCagtBf3swgKuojXIySG1a7LweumW2XVwVyD8zE
         3YqRcd02mx3gcIJCbOvJv0VDYy488XSPecLKxCPNgC/ZQuLGFA6yc3jJA3OpVSEa7f07
         ++1w==
X-Gm-Message-State: APjAAAVNpYpB4DUA614hr2vax1qM96vqUnQ36Ix0Lf5TQu+DGIMKti9K
        Qnlul27FW4jzaDIRe77wzYN6bf/uhe8=
X-Google-Smtp-Source: APXvYqyLSdTdqYJobr3J//O8hGFEnS+QMTUvdKcaopilRPTmvD/1cRXiCDjhda0nHzlYUKVlrEIJaQ==
X-Received: by 2002:a65:6495:: with SMTP id e21mr25177639pgv.383.1559527767587;
        Sun, 02 Jun 2019 19:09:27 -0700 (PDT)
Received: from localhost (ppp167-251-205.static.internode.on.net. [59.167.251.205])
        by smtp.gmail.com with ESMTPSA id p18sm723916pff.93.2019.06.02.19.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Jun 2019 19:09:26 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Daniel Axtens <dja@axtens.net>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH BACKPORTv2 4.4] crypto: vmx - ghash: do nosimd fallback manually
Date:   Mon,  3 Jun 2019 12:09:20 +1000
Message-Id: <20190603020920.9798-1-dja@axtens.net>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 357d065a44cdd77ed5ff35155a989f2a763e96ef upstream.
[backported: the VMX driver did not use crypto_simd_usable() until
 after 5.1, CRYPTO_ALG_TYPE_SHASH was still specified in .options
 until after 4.14, and the sequence for preparing the kernel to use
 vmx changed after 4.4.]

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
---

v2: do stable backport form correctly.

---
 drivers/crypto/vmx/ghash.c | 218 +++++++++++++++----------------------
 1 file changed, 89 insertions(+), 129 deletions(-)

diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 84b9389bf1ed..d6b68cf7bba7 100644
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
@@ -39,71 +31,25 @@ void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
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
@@ -122,7 +68,53 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
 	gcm_init_p8(ctx->htable, (const u64 *) key);
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
+		enable_kernel_altivec();
+		enable_kernel_vsx();
+		enable_kernel_fp();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				dctx->buffer, GHASH_DIGEST_SIZE);
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
+		enable_kernel_altivec();
+		enable_kernel_vsx();
+		enable_kernel_fp();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				src, srclen);
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
@@ -132,51 +124,33 @@ static int p8_ghash_update(struct shash_desc *desc,
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
-			enable_kernel_altivec();
-			enable_kernel_vsx();
-			enable_kernel_fp();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
-			pagefault_enable();
-			preempt_enable();
-			src += GHASH_DIGEST_SIZE - dctx->bytes;
-			srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
-			dctx->bytes = 0;
-		}
-		len = srclen & ~(GHASH_DIGEST_SIZE - 1);
-		if (len) {
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_altivec();
-			enable_kernel_vsx();
-			enable_kernel_fp();
-			gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
-			pagefault_enable();
-			preempt_enable();
-			src += len;
-			srclen -= len;
-		}
-		if (srclen) {
-			memcpy(dctx->buffer, src, srclen);
-			dctx->bytes = srclen;
+				srclen);
+			dctx->bytes += srclen;
+			return 0;
 		}
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
@@ -185,26 +159,14 @@ static int p8_ghash_final(struct shash_desc *desc, u8 *out)
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
-			enable_kernel_altivec();
-			enable_kernel_vsx();
-			enable_kernel_fp();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
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
@@ -219,11 +181,9 @@ struct shash_alg p8_ghash_alg = {
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
-- 
2.19.1

