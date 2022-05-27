Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C81C535F5D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242527AbiE0Lhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351333AbiE0Lh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:37:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CDD63380;
        Fri, 27 May 2022 04:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1631BB824D9;
        Fri, 27 May 2022 11:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B987C385A9;
        Fri, 27 May 2022 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651445;
        bh=j2VFwEiy5AqGYcr1GVEs82OBxC5PnBk4BsCsWy+UcgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWFWIlU9IdOxUwrP3FLp+v60WdRff7TvMbfI71IhmLOxr3jOsdrfjCTrmPxOJ7x4q
         GOBoUR7LrRHWhvwUhFAGgIHDXt40FFr+81lA1bhyOgg8xmXWw3EWreo0T8347Ro39I
         hBPklm0vl8C82xtrL0/LNi/DteYDdY/czC1I4YSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 021/163] crypto: blake2s - optimize blake2s initialization
Date:   Fri, 27 May 2022 10:48:21 +0200
Message-Id: <20220527084831.110196319@linuxfoundation.org>
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

commit 42ad8cf821f0d8564c393e9ad7d00a1a271d18ae upstream.

If no key was provided, then don't waste time initializing the block
buffer, as its initial contents won't be used.

Also, make crypto_blake2s_init() and blake2s() call a single internal
function __blake2s_init() which treats the key as optional, rather than
conditionally calling blake2s_init() or blake2s_init_key().  This
reduces the compiled code size, as previously both blake2s_init() and
blake2s_init_key() were being inlined into these two callers, except
when the key size passed to blake2s() was a compile-time constant.

These optimizations aren't that significant for BLAKE2s.  However, the
equivalent optimizations will be more significant for BLAKE2b, as
everything is twice as big in BLAKE2b.  And it's good to keep things
consistent rather than making optimizations for BLAKE2b but not BLAKE2s.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/blake2s.h          |   53 +++++++++++++++++++-------------------
 include/crypto/internal/blake2s.h |    5 ---
 2 files changed, 28 insertions(+), 30 deletions(-)

--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -43,29 +43,34 @@ enum blake2s_iv {
 	BLAKE2S_IV7 = 0x5BE0CD19UL,
 };
 
-void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
-void blake2s_final(struct blake2s_state *state, u8 *out);
-
-static inline void blake2s_init_param(struct blake2s_state *state,
-				      const u32 param)
+static inline void __blake2s_init(struct blake2s_state *state, size_t outlen,
+				  const void *key, size_t keylen)
 {
-	*state = (struct blake2s_state){{
-		BLAKE2S_IV0 ^ param,
-		BLAKE2S_IV1,
-		BLAKE2S_IV2,
-		BLAKE2S_IV3,
-		BLAKE2S_IV4,
-		BLAKE2S_IV5,
-		BLAKE2S_IV6,
-		BLAKE2S_IV7,
-	}};
+	state->h[0] = BLAKE2S_IV0 ^ (0x01010000 | keylen << 8 | outlen);
+	state->h[1] = BLAKE2S_IV1;
+	state->h[2] = BLAKE2S_IV2;
+	state->h[3] = BLAKE2S_IV3;
+	state->h[4] = BLAKE2S_IV4;
+	state->h[5] = BLAKE2S_IV5;
+	state->h[6] = BLAKE2S_IV6;
+	state->h[7] = BLAKE2S_IV7;
+	state->t[0] = 0;
+	state->t[1] = 0;
+	state->f[0] = 0;
+	state->f[1] = 0;
+	state->buflen = 0;
+	state->outlen = outlen;
+	if (keylen) {
+		memcpy(state->buf, key, keylen);
+		memset(&state->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen);
+		state->buflen = BLAKE2S_BLOCK_SIZE;
+	}
 }
 
 static inline void blake2s_init(struct blake2s_state *state,
 				const size_t outlen)
 {
-	blake2s_init_param(state, 0x01010000 | outlen);
-	state->outlen = outlen;
+	__blake2s_init(state, outlen, NULL, 0);
 }
 
 static inline void blake2s_init_key(struct blake2s_state *state,
@@ -75,12 +80,12 @@ static inline void blake2s_init_key(stru
 	WARN_ON(IS_ENABLED(DEBUG) && (!outlen || outlen > BLAKE2S_HASH_SIZE ||
 		!key || !keylen || keylen > BLAKE2S_KEY_SIZE));
 
-	blake2s_init_param(state, 0x01010000 | keylen << 8 | outlen);
-	memcpy(state->buf, key, keylen);
-	state->buflen = BLAKE2S_BLOCK_SIZE;
-	state->outlen = outlen;
+	__blake2s_init(state, outlen, key, keylen);
 }
 
+void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
+void blake2s_final(struct blake2s_state *state, u8 *out);
+
 static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
 			   const size_t outlen, const size_t inlen,
 			   const size_t keylen)
@@ -91,11 +96,7 @@ static inline void blake2s(u8 *out, cons
 		outlen > BLAKE2S_HASH_SIZE || keylen > BLAKE2S_KEY_SIZE ||
 		(!key && keylen)));
 
-	if (keylen)
-		blake2s_init_key(&state, outlen, key, keylen);
-	else
-		blake2s_init(&state, outlen);
-
+	__blake2s_init(&state, outlen, key, keylen);
 	blake2s_update(&state, in, inlen);
 	blake2s_final(&state, out);
 }
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -93,10 +93,7 @@ static inline int crypto_blake2s_init(st
 	struct blake2s_state *state = shash_desc_ctx(desc);
 	unsigned int outlen = crypto_shash_digestsize(desc->tfm);
 
-	if (tctx->keylen)
-		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
-	else
-		blake2s_init(state, outlen);
+	__blake2s_init(state, outlen, tctx->key, tctx->keylen);
 	return 0;
 }
 


