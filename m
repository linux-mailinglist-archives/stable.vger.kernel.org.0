Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27AC2E4268
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441861AbgL1PWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436802AbgL1OCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A5C2063A;
        Mon, 28 Dec 2020 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164091;
        bh=TEEd7bTuM56HNa5on8CU/w48O/UpN0M1Aj2uOPamqOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqfikORFXV8Nn4Vfev/w9bcN6bktYc3PUvbm2mfITKhVGtRYBr+tk9MWe6T4QV7GD
         0UAWmRQnIRYLVMdiqGXmyeddeZ3Q+vE5itZSJ+Km2Uc2/y1OvIk2AncHILvRvTC8vP
         EodDOZxLY/VFRN/V+gUroH+6sMLxqnSLPJIZ7WQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/717] crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
Date:   Mon, 28 Dec 2020 13:40:55 +0100
Message-Id: <20201228125023.727162921@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit a2715fbdc6fc387e85211df917a4778761ec693d ]

Loading the module deadlocks since:
-local cbc(aes) implementation needs a fallback and
-crypto API tries to find one but the request_module() resolves back to
the same module

Fix this by changing the module alias for cbc(aes) and
using the NEED_FALLBACK flag when requesting for a fallback algorithm.

Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc encryption path")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/aes-neonbs-glue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index bda8bf17631e1..f70af1d0514b9 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -19,7 +19,7 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 MODULE_ALIAS_CRYPTO("ecb(aes)");
-MODULE_ALIAS_CRYPTO("cbc(aes)");
+MODULE_ALIAS_CRYPTO("cbc(aes)-all");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
 
@@ -191,7 +191,8 @@ static int cbc_init(struct crypto_skcipher *tfm)
 	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	unsigned int reqsize;
 
-	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+	ctx->enc_tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->enc_tfm))
 		return PTR_ERR(ctx->enc_tfm);
 
@@ -441,7 +442,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL |
+				  CRYPTO_ALG_NEED_FALLBACK,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
-- 
2.27.0



