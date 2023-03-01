Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213CF6A72C6
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCASJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjCASJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACC41099
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8067A61386
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95089C433EF;
        Wed,  1 Mar 2023 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694148;
        bh=UzGHytlZ1BGMW3vEY6MPfepUnxm8JjMerHh6c1hH0DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ko6lIv0VXJrqTKyHiBPp+2xj1YN/NSEfb2jlptHmc7BBbE/K0fG9MA9VB6v/0F7XC
         /9x/Sfj3NxEz7zTyXa8BEaQ0T6oJ/ZJVim2xgAMTbaLpduqYhQI1evth2cHoEUUVHs
         JofuLraS3l2Jk8SC2sVJXfTvN5r7AIYdkcx924to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.2 02/16] crypto: arm64/sm4-gcm - Fix possible crash in GCM cryption
Date:   Wed,  1 Mar 2023 19:07:38 +0100
Message-Id: <20230301180653.358560430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 4e4a08868f15897ca236528771c3733fded42c62 upstream.

An often overlooked aspect of the skcipher walker API is that an
error is not just indicated by a non-zero return value, but by the
fact that walk->nbytes is zero.

Thus it is an error to call skcipher_walk_done after getting back
walk->nbytes == 0 from the previous interaction with the walker.

This is because when walk->nbytes is zero the walker is left in
an undefined state and any further calls to it may try to free
uninitialised stack memory.

The sm4 arm64 ccm code gets this wrong and ends up calling
skcipher_walk_done even when walk->nbytes is zero.

This patch rewrites the loop in a form that resembles other callers.

Reported-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Fixes: ae1b83c7d572 ("crypto: arm64/sm4 - add CE implementation for GCM mode")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/sm4-ce-gcm-glue.c |   51 +++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -135,22 +135,23 @@ static void gcm_calculate_auth_mac(struc
 }
 
 static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
-		     struct sm4_gcm_ctx *ctx, u8 ghash[],
+		     u8 ghash[], int err,
 		     void (*sm4_ce_pmull_gcm_crypt)(const u32 *rkey_enc,
 				u8 *dst, const u8 *src, u8 *iv,
 				unsigned int nbytes, u8 *ghash,
 				const u8 *ghash_table, const u8 *lengths))
 {
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct sm4_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	u8 __aligned(8) iv[SM4_BLOCK_SIZE];
 	be128 __aligned(8) lengths;
-	int err;
 
 	memset(ghash, 0, SM4_BLOCK_SIZE);
 
 	lengths.a = cpu_to_be64(req->assoclen * 8);
 	lengths.b = cpu_to_be64(walk->total * 8);
 
-	memcpy(iv, walk->iv, GCM_IV_SIZE);
+	memcpy(iv, req->iv, GCM_IV_SIZE);
 	put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 	kernel_neon_begin();
@@ -158,49 +159,51 @@ static int gcm_crypt(struct aead_request
 	if (req->assoclen)
 		gcm_calculate_auth_mac(req, ghash);
 
-	do {
+	while (walk->nbytes) {
 		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 		const u8 *src = walk->src.virt.addr;
 		u8 *dst = walk->dst.virt.addr;
 
 		if (walk->nbytes == walk->total) {
-			tail = 0;
-
 			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
 					       walk->nbytes, ghash,
 					       ctx->ghash_table,
 					       (const u8 *)&lengths);
-		} else if (walk->nbytes - tail) {
-			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-					       walk->nbytes - tail, ghash,
-					       ctx->ghash_table, NULL);
+
+			kernel_neon_end();
+
+			return skcipher_walk_done(walk, 0);
 		}
 
+		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
+				       walk->nbytes - tail, ghash,
+				       ctx->ghash_table, NULL);
+
 		kernel_neon_end();
 
 		err = skcipher_walk_done(walk, tail);
-		if (err)
-			return err;
-		if (walk->nbytes)
-			kernel_neon_begin();
-	} while (walk->nbytes > 0);
 
-	return 0;
+		kernel_neon_begin();
+	}
+
+	sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
+			       walk->nbytes, ghash, ctx->ghash_table,
+			       (const u8 *)&lengths);
+
+	kernel_neon_end();
+
+	return err;
 }
 
 static int gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct sm4_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	u8 __aligned(8) ghash[SM4_BLOCK_SIZE];
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
-	if (err)
-		return err;
-
-	err = gcm_crypt(req, &walk, ctx, ghash, sm4_ce_pmull_gcm_enc);
+	err = gcm_crypt(req, &walk, ghash, err, sm4_ce_pmull_gcm_enc);
 	if (err)
 		return err;
 
@@ -215,17 +218,13 @@ static int gcm_decrypt(struct aead_reque
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	unsigned int authsize = crypto_aead_authsize(aead);
-	struct sm4_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	u8 __aligned(8) ghash[SM4_BLOCK_SIZE];
 	u8 authtag[SM4_BLOCK_SIZE];
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
-	if (err)
-		return err;
-
-	err = gcm_crypt(req, &walk, ctx, ghash, sm4_ce_pmull_gcm_dec);
+	err = gcm_crypt(req, &walk, ghash, err, sm4_ce_pmull_gcm_dec);
 	if (err)
 		return err;
 


