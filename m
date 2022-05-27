Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23B4535F9A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245530AbiE0LkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351491AbiE0Lji (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345F9133262;
        Fri, 27 May 2022 04:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D53561CE7;
        Fri, 27 May 2022 11:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A539C34113;
        Fri, 27 May 2022 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651515;
        bh=Ua3W8SZn7O+KQzMNE+FuOzDeTWLcEYdeajQFzpknbA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llh4Op31QwGhq0ycrCB6J8Zo51pziYajz3s30PR7ZiOdSEzkIXh/KBBNYVgiFxUOJ
         1pcxD+8V45rmvmyKVM009XnOMJP3LM2A3rvDDbddrxioiKLRkGtOA9bigO6J3uDsFe
         n1hTIKAfv6+OdkkQMm8e1OQ1swJZE5xBsn1DaWD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 020/163] crypto: blake2s - share the "shash" API boilerplate code
Date:   Fri, 27 May 2022 10:48:20 +0200
Message-Id: <20220527084830.978000904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 8c4a93a1270ddffc7660ae43fa8030ecfe9c06d9 upstream.

Add helper functions for shash implementations of BLAKE2s to
include/crypto/internal/blake2s.h, taking advantage of
__blake2s_update() and __blake2s_final() that were added by the previous
patch to share more code between the library and shash implementations.

crypto_blake2s_setkey() and crypto_blake2s_init() are usable as
shash_alg::setkey and shash_alg::init directly, while
crypto_blake2s_update() and crypto_blake2s_final() take an extra
'blake2s_compress_t' function pointer parameter.  This allows the
implementation of the compression function to be overridden, which is
the only part that optimized implementations really care about.

The new functions are inline functions (similar to those in sha1_base.h,
sha256_base.h, and sm3_base.h) because this avoids needing to add a new
module blake2s_helpers.ko, they aren't *too* long, and this avoids
indirect calls which are expensive these days.  Note that they can't go
in blake2s_generic.ko, as that would require selecting CRYPTO_BLAKE2S
from CRYPTO_BLAKE2S_X86, which would cause a recursive dependency.

Finally, use these new helper functions in the x86 implementation of
BLAKE2s.  (This part should be a separate patch, but unfortunately the
x86 implementation used the exact same function names like
"crypto_blake2s_update()", so it had to be updated at the same time.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/blake2s-glue.c    |   74 +++----------------------------------
 crypto/blake2s_generic.c          |   76 ++++----------------------------------
 include/crypto/internal/blake2s.h |   65 ++++++++++++++++++++++++++++++--
 3 files changed, 76 insertions(+), 139 deletions(-)

--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -58,75 +58,15 @@ void blake2s_compress_arch(struct blake2
 }
 EXPORT_SYMBOL(blake2s_compress_arch);
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
+static int crypto_blake2s_update_x86(struct shash_desc *desc,
+				     const u8 *in, unsigned int inlen)
 {
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(tctx->key, key, keylen);
-	tctx->keylen = keylen;
-
-	return 0;
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_arch);
 }
 
-static int crypto_blake2s_init(struct shash_desc *desc)
+static int crypto_blake2s_final_x86(struct shash_desc *desc, u8 *out)
 {
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const int outlen = crypto_shash_digestsize(desc->tfm);
-
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
-
-	return 0;
-}
-
-static int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
-				 unsigned int inlen)
-{
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return 0;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		blake2s_compress_arch(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		blake2s_compress_arch(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
-
-	return 0;
-}
-
-static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
-{
-	struct blake2s_state *state = shash_desc_ctx(desc);
-
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	blake2s_compress_arch(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
-	memzero_explicit(state, sizeof(*state));
-
-	return 0;
+	return crypto_blake2s_final(desc, out, blake2s_compress_arch);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
@@ -141,8 +81,8 @@ static int crypto_blake2s_final(struct s
 		.digestsize		= digest_size,			\
 		.setkey			= crypto_blake2s_setkey,	\
 		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update,	\
-		.final			= crypto_blake2s_final,		\
+		.update			= crypto_blake2s_update_x86,	\
+		.final			= crypto_blake2s_final_x86,	\
 		.descsize		= sizeof(struct blake2s_state),	\
 	}
 
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR MIT
 /*
+ * shash interface to the generic implementation of BLAKE2s
+ *
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
@@ -10,75 +12,15 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
-				 unsigned int keylen)
+static int crypto_blake2s_update_generic(struct shash_desc *desc,
+					 const u8 *in, unsigned int inlen)
 {
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-
-	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(tctx->key, key, keylen);
-	tctx->keylen = keylen;
-
-	return 0;
-}
-
-static int crypto_blake2s_init(struct shash_desc *desc)
-{
-	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const int outlen = crypto_shash_digestsize(desc->tfm);
-
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
-
-	return 0;
-}
-
-static int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
-				 unsigned int inlen)
-{
-	struct blake2s_state *state = shash_desc_ctx(desc);
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return 0;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		blake2s_compress_generic(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		blake2s_compress_generic(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
-
-	return 0;
+	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_generic);
 }
 
-static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
+static int crypto_blake2s_final_generic(struct shash_desc *desc, u8 *out)
 {
-	struct blake2s_state *state = shash_desc_ctx(desc);
-
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	blake2s_compress_generic(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
-	memzero_explicit(state, sizeof(*state));
-
-	return 0;
+	return crypto_blake2s_final(desc, out, blake2s_compress_generic);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
@@ -93,8 +35,8 @@ static int crypto_blake2s_final(struct s
 		.digestsize		= digest_size,			\
 		.setkey			= crypto_blake2s_setkey,	\
 		.init			= crypto_blake2s_init,		\
-		.update			= crypto_blake2s_update,	\
-		.final			= crypto_blake2s_final,		\
+		.update			= crypto_blake2s_update_generic, \
+		.final			= crypto_blake2s_final_generic,	\
 		.descsize		= sizeof(struct blake2s_state),	\
 	}
 
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -1,16 +1,16 @@
 /* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Helper functions for BLAKE2s implementations.
+ * Keep this in sync with the corresponding BLAKE2b header.
+ */
 
 #ifndef BLAKE2S_INTERNAL_H
 #define BLAKE2S_INTERNAL_H
 
 #include <crypto/blake2s.h>
+#include <crypto/internal/hash.h>
 #include <linux/string.h>
 
-struct blake2s_tfm_ctx {
-	u8 key[BLAKE2S_KEY_SIZE];
-	unsigned int keylen;
-};
-
 void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
 			      size_t nblocks, const u32 inc);
 
@@ -27,6 +27,8 @@ static inline void blake2s_set_lastblock
 typedef void (*blake2s_compress_t)(struct blake2s_state *state,
 				   const u8 *block, size_t nblocks, u32 inc);
 
+/* Helper functions for BLAKE2s shared by the library and shash APIs */
+
 static inline void __blake2s_update(struct blake2s_state *state,
 				    const u8 *in, size_t inlen,
 				    blake2s_compress_t compress)
@@ -64,4 +66,57 @@ static inline void __blake2s_final(struc
 	memcpy(out, state->h, state->outlen);
 }
 
+/* Helper functions for shash implementations of BLAKE2s */
+
+struct blake2s_tfm_ctx {
+	u8 key[BLAKE2S_KEY_SIZE];
+	unsigned int keylen;
+};
+
+static inline int crypto_blake2s_setkey(struct crypto_shash *tfm,
+					const u8 *key, unsigned int keylen)
+{
+	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE)
+		return -EINVAL;
+
+	memcpy(tctx->key, key, keylen);
+	tctx->keylen = keylen;
+
+	return 0;
+}
+
+static inline int crypto_blake2s_init(struct shash_desc *desc)
+{
+	const struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	unsigned int outlen = crypto_shash_digestsize(desc->tfm);
+
+	if (tctx->keylen)
+		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
+	else
+		blake2s_init(state, outlen);
+	return 0;
+}
+
+static inline int crypto_blake2s_update(struct shash_desc *desc,
+					const u8 *in, unsigned int inlen,
+					blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	__blake2s_update(state, in, inlen, compress);
+	return 0;
+}
+
+static inline int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
+				       blake2s_compress_t compress)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	__blake2s_final(state, out, compress);
+	return 0;
+}
+
 #endif /* BLAKE2S_INTERNAL_H */


