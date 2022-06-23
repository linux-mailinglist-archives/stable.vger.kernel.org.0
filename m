Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B238C558534
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiFWRyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiFWRwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985CE2126B;
        Thu, 23 Jun 2022 10:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D5F6B82480;
        Thu, 23 Jun 2022 17:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B204BC3411B;
        Thu, 23 Jun 2022 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004368;
        bh=GveS77NFMpQY+xaymSevlHEOIq7CUjT0HjuXcn/+YKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKcOFiAkIvYt6XDGG8os93P9oTLySz64rBYdiUdyfKNb7njTdFSLB3YROsXhPl8eJ
         BiF2mIKnmfL9QrjV8eRphXuMIvugLhsBKOuTIzoo1Qqa74vwxNH4Qkqgz3V1FPSluC
         AVM3XTGe330yyrv+trpTKUxY8sj0COErzuMInexU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 016/234] lib/crypto: blake2s: move hmac construction into wireguard
Date:   Thu, 23 Jun 2022 18:41:23 +0200
Message-Id: <20220623164343.521144705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit d8d83d8ab0a453e17e68b3a3bed1f940c34b8646 upstream.

Basically nobody should use blake2s in an HMAC construction; it already
has a keyed variant. But unfortunately for historical reasons, Noise,
used by WireGuard, uses HKDF quite strictly, which means we have to use
this. Because this really shouldn't be used by others, this commit moves
it into wireguard's noise.c locally, so that kernels that aren't using
WireGuard don't get this superfluous code baked in. On m68k systems,
this shaves off ~314 bytes.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
[Jason: for stable, skip the wireguard changes, since this kernel
 doesn't have wireguard.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/blake2s.h      |    3 ---
 lib/crypto/blake2s-selftest.c |   31 -------------------------------
 lib/crypto/blake2s.c          |   37 -------------------------------------
 3 files changed, 71 deletions(-)

--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -100,7 +100,4 @@ static inline void blake2s(u8 *out, cons
 	blake2s_final(&state, out);
 }
 
-void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
-		     const size_t keylen);
-
 #endif /* BLAKE2S_H */
--- a/lib/crypto/blake2s-selftest.c
+++ b/lib/crypto/blake2s-selftest.c
@@ -15,7 +15,6 @@
  * #include <stdio.h>
  *
  * #include <openssl/evp.h>
- * #include <openssl/hmac.h>
  *
  * #define BLAKE2S_TESTVEC_COUNT	256
  *
@@ -58,16 +57,6 @@
  *	}
  *	printf("};\n\n");
  *
- *	printf("static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {\n");
- *
- *	HMAC(EVP_blake2s256(), key, sizeof(key), buf, sizeof(buf), hash, NULL);
- *	print_vec(hash, BLAKE2S_OUTBYTES);
- *
- *	HMAC(EVP_blake2s256(), buf, sizeof(buf), key, sizeof(key), hash, NULL);
- *	print_vec(hash, BLAKE2S_OUTBYTES);
- *
- *	printf("};\n");
- *
  *	return 0;
  *}
  */
@@ -554,15 +543,6 @@ static const u8 blake2s_testvecs[][BLAKE
     0xd6, 0x98, 0x6b, 0x07, 0x10, 0x65, 0x52, 0x65, },
 };
 
-static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
-  { 0xce, 0xe1, 0x57, 0x69, 0x82, 0xdc, 0xbf, 0x43, 0xad, 0x56, 0x4c, 0x70,
-    0xed, 0x68, 0x16, 0x96, 0xcf, 0xa4, 0x73, 0xe8, 0xe8, 0xfc, 0x32, 0x79,
-    0x08, 0x0a, 0x75, 0x82, 0xda, 0x3f, 0x05, 0x11, },
-  { 0x77, 0x2f, 0x0c, 0x71, 0x41, 0xf4, 0x4b, 0x2b, 0xb3, 0xc6, 0xb6, 0xf9,
-    0x60, 0xde, 0xe4, 0x52, 0x38, 0x66, 0xe8, 0xbf, 0x9b, 0x96, 0xc4, 0x9f,
-    0x60, 0xd9, 0x24, 0x37, 0x99, 0xd6, 0xec, 0x31, },
-};
-
 bool __init blake2s_selftest(void)
 {
 	u8 key[BLAKE2S_KEY_SIZE];
@@ -607,16 +587,5 @@ bool __init blake2s_selftest(void)
 		}
 	}
 
-	if (success) {
-		blake2s256_hmac(hash, buf, key, sizeof(buf), sizeof(key));
-		success &= !memcmp(hash, blake2s_hmac_testvecs[0], BLAKE2S_HASH_SIZE);
-
-		blake2s256_hmac(hash, key, buf, sizeof(key), sizeof(buf));
-		success &= !memcmp(hash, blake2s_hmac_testvecs[1], BLAKE2S_HASH_SIZE);
-
-		if (!success)
-			pr_err("blake2s256_hmac self-test: FAIL\n");
-	}
-
 	return success;
 }
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -59,43 +59,6 @@ void blake2s_final(struct blake2s_state
 }
 EXPORT_SYMBOL(blake2s_final);
 
-void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
-		     const size_t keylen)
-{
-	struct blake2s_state state;
-	u8 x_key[BLAKE2S_BLOCK_SIZE] __aligned(__alignof__(u32)) = { 0 };
-	u8 i_hash[BLAKE2S_HASH_SIZE] __aligned(__alignof__(u32));
-	int i;
-
-	if (keylen > BLAKE2S_BLOCK_SIZE) {
-		blake2s_init(&state, BLAKE2S_HASH_SIZE);
-		blake2s_update(&state, key, keylen);
-		blake2s_final(&state, x_key);
-	} else
-		memcpy(x_key, key, keylen);
-
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
-		x_key[i] ^= 0x36;
-
-	blake2s_init(&state, BLAKE2S_HASH_SIZE);
-	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
-	blake2s_update(&state, in, inlen);
-	blake2s_final(&state, i_hash);
-
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
-		x_key[i] ^= 0x5c ^ 0x36;
-
-	blake2s_init(&state, BLAKE2S_HASH_SIZE);
-	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
-	blake2s_update(&state, i_hash, BLAKE2S_HASH_SIZE);
-	blake2s_final(&state, i_hash);
-
-	memcpy(out, i_hash, BLAKE2S_HASH_SIZE);
-	memzero_explicit(x_key, BLAKE2S_BLOCK_SIZE);
-	memzero_explicit(i_hash, BLAKE2S_HASH_SIZE);
-}
-EXPORT_SYMBOL(blake2s256_hmac);
-
 static int __init mod_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&


