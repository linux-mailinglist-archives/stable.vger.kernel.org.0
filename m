Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF324BF16
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgHTNjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgHTJaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68791206FA;
        Thu, 20 Aug 2020 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915821;
        bh=0X7WpuY/jCJp0/tIa44IIaSK8ndpAN4TJYDqNrG0RlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgMXzSgVhFE0ViP6ibgE6isxuSKx9WUp9/6srzoawbUO8F7mHdUVZQk4ygh1fF+gO
         MQRQhlfJIKtQFYOtE3MIGen18TKFc+uUFB6TBntLNW3uJfnJq7K3C6Re6nKeq1qSOd
         4zUuRwo77qFlv7BuTt72Y3epexZVaB8BeBq0G7y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 145/232] crypto: caam - Remove broken arc4 support
Date:   Thu, 20 Aug 2020 11:19:56 +0200
Message-Id: <20200820091619.842249128@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit eeedb618378f8a09779546a3eeac16b000447d62 ]

The arc4 algorithm requires storing state in the request context
in order to allow more than one encrypt/decrypt operation.  As this
driver does not seem to do that, it means that using it for more
than one operation is broken.

Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
Link: https://lore.kernel.org/linux-crypto/CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com
Link: https://lore.kernel.org/linux-crypto/20200702101947.682-1-ardb@kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c | 29 -----------------------------
 drivers/crypto/caam/compat.h  |  1 -
 2 files changed, 30 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index bf90a4fcabd1f..8149ac4d6ef22 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -810,12 +810,6 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
 }
 
-static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
-				const u8 *key, unsigned int keylen)
-{
-	return skcipher_setkey(skcipher, key, keylen, 0);
-}
-
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1967,21 +1961,6 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_ECB,
 	},
-	{
-		.skcipher = {
-			.base = {
-				.cra_name = "ecb(arc4)",
-				.cra_driver_name = "ecb-arc4-caam",
-				.cra_blocksize = ARC4_BLOCK_SIZE,
-			},
-			.setkey = arc4_skcipher_setkey,
-			.encrypt = skcipher_encrypt,
-			.decrypt = skcipher_decrypt,
-			.min_keysize = ARC4_MIN_KEY_SIZE,
-			.max_keysize = ARC4_MAX_KEY_SIZE,
-		},
-		.caam.class1_alg_type = OP_ALG_ALGSEL_ARC4 | OP_ALG_AAI_ECB,
-	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
@@ -3457,7 +3436,6 @@ int caam_algapi_init(struct device *ctrldev)
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int i = 0, err = 0;
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
-	u32 arc4_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false, gcm_support;
 
@@ -3477,8 +3455,6 @@ int caam_algapi_init(struct device *ctrldev)
 			   CHA_ID_LS_DES_SHIFT;
 		aes_inst = cha_inst & CHA_ID_LS_AES_MASK;
 		md_inst = (cha_inst & CHA_ID_LS_MD_MASK) >> CHA_ID_LS_MD_SHIFT;
-		arc4_inst = (cha_inst & CHA_ID_LS_ARC4_MASK) >>
-			    CHA_ID_LS_ARC4_SHIFT;
 		ccha_inst = 0;
 		ptha_inst = 0;
 
@@ -3499,7 +3475,6 @@ int caam_algapi_init(struct device *ctrldev)
 		md_inst = mdha & CHA_VER_NUM_MASK;
 		ccha_inst = rd_reg32(&priv->ctrl->vreg.ccha) & CHA_VER_NUM_MASK;
 		ptha_inst = rd_reg32(&priv->ctrl->vreg.ptha) & CHA_VER_NUM_MASK;
-		arc4_inst = rd_reg32(&priv->ctrl->vreg.afha) & CHA_VER_NUM_MASK;
 
 		gcm_support = aesa & CHA_VER_MISC_AES_GCM;
 	}
@@ -3522,10 +3497,6 @@ int caam_algapi_init(struct device *ctrldev)
 		if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
 				continue;
 
-		/* Skip ARC4 algorithms if not supported by device */
-		if (!arc4_inst && alg_sel == OP_ALG_ALGSEL_ARC4)
-			continue;
-
 		/*
 		 * Check support for AES modes not available
 		 * on LP devices.
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 60e2a54c19f11..c3c22a8de4c00 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -43,7 +43,6 @@
 #include <crypto/akcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
-#include <crypto/arc4.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/rsa.h>
-- 
2.25.1



