Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4043B5830FA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbiG0Ro7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243093AbiG0RoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5778AB2C;
        Wed, 27 Jul 2022 09:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E181B821AC;
        Wed, 27 Jul 2022 16:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7BBC433D6;
        Wed, 27 Jul 2022 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940773;
        bh=9I/JEJjN3N7i7yzhTwu3g+bbof/43fJ1qkVXXeHxttY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9LOXYYgm9fn/oj3i02sw+SM56AvVMpgU+8heag7SgncTJzWzualDocfmCVQKn3T1
         vli40Ltq82oyX1aPy1uqk6IfWmGesKUXcymtkNuuf5lio3xYTu4KmtfwVJK9UiW8qa
         PHko4Fc9zU8FlGtYSBQsYu4pJpKDgqb1LkALuHeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 144/158] crypto: qat - fix memory leak in RSA
Date:   Wed, 27 Jul 2022 18:13:28 +0200
Message-Id: <20220727161027.125433230@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 80a52e1ee7757b742f96bfb0d58f0c14eb6583d0 ]

When an RSA key represented in form 2 (as defined in PKCS #1 V2.1) is
used, some components of the private key persist even after the TFM is
released.
Replace the explicit calls to free the buffers in qat_rsa_exit_tfm()
with a call to qat_rsa_clear_ctx() which frees all buffers referenced in
the TFM context.

Cc: stable@vger.kernel.org
Fixes: 879f77e9071f ("crypto: qat - Add RSA CRT mode")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index ff7249c093c9..2bc02c75398e 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1257,18 +1257,8 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 
-	if (ctx->n)
-		dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
-	if (ctx->e)
-		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
-	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
-		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
-	}
+	qat_rsa_clear_ctx(dev, ctx);
 	qat_crypto_put_instance(ctx->inst);
-	ctx->n = NULL;
-	ctx->e = NULL;
-	ctx->d = NULL;
 }
 
 static struct akcipher_alg rsa = {
-- 
2.35.1



