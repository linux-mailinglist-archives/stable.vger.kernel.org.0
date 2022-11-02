Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5136157E6
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiKBClU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKBClU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44961205FA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96770CE1F13
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABD7C433D7;
        Wed,  2 Nov 2022 02:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356876;
        bh=3BCjV++MlhYYn690Oz8DQMbCgZXuWB9HQc9lM+gA0Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+g6ZdXXJw28g6A3GrNxw5PAxqkSHNTAD2/uzrUe9yb+Tmm3bZ75Je6EOIqGbJozM
         Z6/MGr4nT1IP1HR3Qbnj64LJmVDMxsnEhi1xkmnaTw0DQPlB+Mup7iXwgYQ1dR4v5O
         SJiigf/yLYtkyyGejhg5hfcyM+ngf3sNO38/lLmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bruno Goncalves <bgoncalv@redhat.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.0 075/240] crypto: x86/polyval - Fix crashes when keys are not 16-byte aligned
Date:   Wed,  2 Nov 2022 03:30:50 +0100
Message-Id: <20221102022113.099901833@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

commit 9f6035af06b526e678808d492fc0830aef6cfbd8 upstream.

crypto_tfm::__crt_ctx is not guaranteed to be 16-byte aligned on x86-64.
This causes crashes due to movaps instructions in clmul_polyval_update.

Add logic to align polyval_tfm_ctx to 16 bytes.

Cc: <stable@vger.kernel.org>
Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/polyval-clmulni_glue.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
index b7664d018851..8fa58b0f3cb3 100644
--- a/arch/x86/crypto/polyval-clmulni_glue.c
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -27,13 +27,17 @@
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
+#define POLYVAL_ALIGN	16
+#define POLYVAL_ALIGN_ATTR __aligned(POLYVAL_ALIGN)
+#define POLYVAL_ALIGN_EXTRA ((POLYVAL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+#define POLYVAL_CTX_SIZE (sizeof(struct polyval_tfm_ctx) + POLYVAL_ALIGN_EXTRA)
 #define NUM_KEY_POWERS	8
 
 struct polyval_tfm_ctx {
 	/*
 	 * These powers must be in the order h^8, ..., h^1.
 	 */
-	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
+	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE] POLYVAL_ALIGN_ATTR;
 };
 
 struct polyval_desc_ctx {
@@ -45,6 +49,11 @@ asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator);
 asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
 
+static inline struct polyval_tfm_ctx *polyval_tfm_ctx(struct crypto_shash *tfm)
+{
+	return PTR_ALIGN(crypto_shash_ctx(tfm), POLYVAL_ALIGN);
+}
+
 static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
 	const u8 *in, size_t nblocks, u8 *accumulator)
 {
@@ -72,7 +81,7 @@ static void internal_polyval_mul(u8 *op1, const u8 *op2)
 static int polyval_x86_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
-	struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+	struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(tfm);
 	int i;
 
 	if (keylen != POLYVAL_BLOCK_SIZE)
@@ -102,7 +111,7 @@ static int polyval_x86_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
 	u8 *pos;
 	unsigned int nblocks;
 	unsigned int n;
@@ -143,7 +152,7 @@ static int polyval_x86_update(struct shash_desc *desc,
 static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
 
 	if (dctx->bytes) {
 		internal_polyval_mul(dctx->buffer,
@@ -167,7 +176,7 @@ static struct shash_alg polyval_alg = {
 		.cra_driver_name	= "polyval-clmulni",
 		.cra_priority		= 200,
 		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
+		.cra_ctxsize		= POLYVAL_CTX_SIZE,
 		.cra_module		= THIS_MODULE,
 	},
 };
-- 
2.38.1



