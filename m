Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7467060BB38
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiJXUwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiJXUvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450BF1D440F;
        Mon, 24 Oct 2022 11:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4299861321;
        Mon, 24 Oct 2022 12:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577F8C433C1;
        Mon, 24 Oct 2022 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615790;
        bh=V158gqfaGOuKvv7mls5uKxEIcANh4s5FzQov9SkR/sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoLcKqd1OiGPW3M7GcvVcJxEqCCaKnwceirsiecHJDvF5ZU5YPSouzB+Ha4uFcneO
         L60j0Xwvcq9984UWe3VW4hNDJQvb14Sptb8ZaepEgm3cW5PvXSgLLrDU8ZZne6LrVL
         mUhr/cNvOxbqoVZQcDd5WXwWZ6jgTL3h5SKBeWZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Harliman Liem <pliem@maxlinear.com>,
        Antoine Tenart <atenart@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/530] crypto: inside-secure - Change swab to swab32
Date:   Mon, 24 Oct 2022 13:32:08 +0200
Message-Id: <20221024113102.451425449@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Harliman Liem <pliem@maxlinear.com>

[ Upstream commit 664593407e936b6438fbfaaf98876910fd31cf9a ]

The use of swab() is causing failures in 64-bit arch, as it
translates to __swab64() instead of the intended __swab32().
It eventually causes wrong results in xcbcmac & cmac algo.

Fixes: 78cf1c8bfcb8 ("crypto: inside-secure - Move ipad/opad into safexcel_context")
Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index bc60b5802256..2124416742f8 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -383,7 +383,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 					u32 x;
 
 					x = ipad[i] ^ ipad[i + 4];
-					cache[i] ^= swab(x);
+					cache[i] ^= swab32(x);
 				}
 			}
 			cache_len = AES_BLOCK_SIZE;
@@ -821,7 +821,7 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			u32 *result = (void *)areq->result;
 
 			/* K3 */
-			result[i] = swab(ctx->base.ipad.word[i + 4]);
+			result[i] = swab32(ctx->base.ipad.word[i + 4]);
 		}
 		areq->result[0] ^= 0x80;			// 10- padding
 		crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
@@ -2106,7 +2106,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 		"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 	for (i = 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->base.ipad.word[i] = swab(key_tmp[i]);
+		ctx->base.ipad.word[i] = swab32(key_tmp[i]);
 
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
@@ -2189,7 +2189,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->base.ipad.word[i + 8] = swab(aes.key_enc[i]);
+		ctx->base.ipad.word[i + 8] = swab32(aes.key_enc[i]);
 
 	/* precompute the CMAC key material */
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
-- 
2.35.1



