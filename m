Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561C3535F99
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351529AbiE0Lju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351574AbiE0LjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:39:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C642132778;
        Fri, 27 May 2022 04:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BEE461CB7;
        Fri, 27 May 2022 11:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4988CC385A9;
        Fri, 27 May 2022 11:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651509;
        bh=SW6KoCPu7r19e77UcCdKF4o/skbGK1MFZ1TBGk8IlsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11meKyftx6zkitji46hGm4WZKWpmjmgakmNM24UsS9ERlyRO0g6Y+9BHzOzYWEV/H
         boM7/pkCbcObB99yYSYrK9hjGvMUqPDz9KNCOro2nCiJS6s86NTQJYyWP4RilRukVf
         YsFyKrjsgx2SVHE0jT92KlP93GJO/a12RN6zSjyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 019/163] crypto: blake2s - move update and final logic to internal/blake2s.h
Date:   Fri, 27 May 2022 10:48:19 +0200
Message-Id: <20220527084830.826405614@linuxfoundation.org>
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

commit 057edc9c8bb2d5ff5b058b521792c392428a0714 upstream.

Move most of blake2s_update() and blake2s_final() into new inline
functions __blake2s_update() and __blake2s_final() in
include/crypto/internal/blake2s.h so that this logic can be shared by
the shash helper functions.  This will avoid duplicating this logic
between the library and shash implementations.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/internal/blake2s.h |   41 ++++++++++++++++++++++++++++++++
 lib/crypto/blake2s.c              |   48 ++++++--------------------------------
 2 files changed, 49 insertions(+), 40 deletions(-)

--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -4,6 +4,7 @@
 #define BLAKE2S_INTERNAL_H
 
 #include <crypto/blake2s.h>
+#include <linux/string.h>
 
 struct blake2s_tfm_ctx {
 	u8 key[BLAKE2S_KEY_SIZE];
@@ -23,4 +24,44 @@ static inline void blake2s_set_lastblock
 	state->f[0] = -1;
 }
 
+typedef void (*blake2s_compress_t)(struct blake2s_state *state,
+				   const u8 *block, size_t nblocks, u32 inc);
+
+static inline void __blake2s_update(struct blake2s_state *state,
+				    const u8 *in, size_t inlen,
+				    blake2s_compress_t compress)
+{
+	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
+
+	if (unlikely(!inlen))
+		return;
+	if (inlen > fill) {
+		memcpy(state->buf + state->buflen, in, fill);
+		(*compress)(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
+		state->buflen = 0;
+		in += fill;
+		inlen -= fill;
+	}
+	if (inlen > BLAKE2S_BLOCK_SIZE) {
+		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
+		/* Hash one less (full) block than strictly possible */
+		(*compress)(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
+		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+	}
+	memcpy(state->buf + state->buflen, in, inlen);
+	state->buflen += inlen;
+}
+
+static inline void __blake2s_final(struct blake2s_state *state, u8 *out,
+				   blake2s_compress_t compress)
+{
+	blake2s_set_lastblock(state);
+	memset(state->buf + state->buflen, 0,
+	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
+	(*compress)(state, state->buf, 1, state->buflen);
+	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
+	memcpy(out, state->h, state->outlen);
+}
+
 #endif /* BLAKE2S_INTERNAL_H */
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -15,55 +15,23 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/bug.h>
-#include <asm/unaligned.h>
+
+#if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S)
+#  define blake2s_compress blake2s_compress_arch
+#else
+#  define blake2s_compress blake2s_compress_generic
+#endif
 
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
-	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return;
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, state->buf, 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, state->buf, 1,
-						 BLAKE2S_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2S_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, in, nblocks - 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, in, nblocks - 1,
-						 BLAKE2S_BLOCK_SIZE);
-		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
+	__blake2s_update(state, in, inlen, blake2s_compress);
 }
 EXPORT_SYMBOL(blake2s_update);
 
 void blake2s_final(struct blake2s_state *state, u8 *out)
 {
 	WARN_ON(IS_ENABLED(DEBUG) && !out);
-	blake2s_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-		blake2s_compress_arch(state, state->buf, 1, state->buflen);
-	else
-		blake2s_compress_generic(state, state->buf, 1, state->buflen);
-	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-	memcpy(out, state->h, state->outlen);
+	__blake2s_final(state, out, blake2s_compress);
 	memzero_explicit(state, sizeof(*state));
 }
 EXPORT_SYMBOL(blake2s_final);


