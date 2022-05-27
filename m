Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F1E535F85
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351399AbiE0LjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351465AbiE0Lio (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:38:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0809E106A6E;
        Fri, 27 May 2022 04:38:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED61AB82466;
        Fri, 27 May 2022 11:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB1C385A9;
        Fri, 27 May 2022 11:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651497;
        bh=0Cl6RwgLZ683pUXVRBAUU69djwhzRF9IwBEwOkpm2d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wweQhpqsF/LdD4GRkr6orrw00rQpfPdgcZ4JXytsayL+OSABkLmt0Z0pNawltVEoh
         AhITs1T9Bt7tFQSOED1JoAIy+OaGQVKrP5cdQIhxPVP1uRyvRsgYXQytXMZLaUZbka
         VQS4+Bf23YZGRJTBAQHrEjOhHesFbGU6SN0ROY5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 017/163] crypto: x86/blake2s - define shash_alg structs using macros
Date:   Fri, 27 May 2022 10:48:17 +0200
Message-Id: <20220527084830.582395329@linuxfoundation.org>
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

commit 1aa90f4cf034ed4f016a02330820ac0551a6c13c upstream.

The shash_alg structs for the four variants of BLAKE2s are identical
except for the algorithm name, driver name, and digest size.  So, avoid
code duplication by using a macro to define these structs.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/blake2s-glue.c |   84 +++++++++++------------------------------
 1 file changed, 23 insertions(+), 61 deletions(-)

--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -129,67 +129,29 @@ static int crypto_blake2s_final(struct s
 	return 0;
 }
 
-static struct shash_alg blake2s_algs[] = {{
-	.base.cra_name		= "blake2s-128",
-	.base.cra_driver_name	= "blake2s-128-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_128_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-160",
-	.base.cra_driver_name	= "blake2s-160-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_160_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-224",
-	.base.cra_driver_name	= "blake2s-224-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_224_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-256",
-	.base.cra_driver_name	= "blake2s-256-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_256_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}};
+#define BLAKE2S_ALG(name, driver_name, digest_size)			\
+	{								\
+		.base.cra_name		= name,				\
+		.base.cra_driver_name	= driver_name,			\
+		.base.cra_priority	= 200,				\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
+		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
+		.base.cra_module	= THIS_MODULE,			\
+		.digestsize		= digest_size,			\
+		.setkey			= crypto_blake2s_setkey,	\
+		.init			= crypto_blake2s_init,		\
+		.update			= crypto_blake2s_update,	\
+		.final			= crypto_blake2s_final,		\
+		.descsize		= sizeof(struct blake2s_state),	\
+	}
+
+static struct shash_alg blake2s_algs[] = {
+	BLAKE2S_ALG("blake2s-128", "blake2s-128-x86", BLAKE2S_128_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-160", "blake2s-160-x86", BLAKE2S_160_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-224", "blake2s-224-x86", BLAKE2S_224_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-256", "blake2s-256-x86", BLAKE2S_256_HASH_SIZE),
+};
 
 static int __init blake2s_mod_init(void)
 {


