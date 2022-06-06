Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE953E7E6
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiFFLmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiFFLmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:42:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF19A3BA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9603760F84
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFA5C3411C;
        Mon,  6 Jun 2022 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654515730;
        bh=QbMvM/GKBaR63Q7zuwZKe8x2iMO9NAXuMWxbPMVl5AE=;
        h=Subject:To:Cc:From:Date:From;
        b=v/lAdt27QGNYPRHPjlsySYv2/NKHeirkM/RyTeU6rlhUZAYIN+kMVi7kLeWrqmTTz
         d3Oe1Jp5OJ/ItvYVr7JDVX2ftXIORcTbyq4yS8cmaI9ZVcDiGamzH/E9GO0pDltYNA
         6256pcNVs1hgwqkdO5RRZEIH8np3qxzt664TNVpw=
Subject: WTF: patch "[PATCH] crypto: qat - fix memory leak in RSA" was seriously submitted to be applied to the 5.18-stable tree?
To:     giovanni.cabiddu@intel.com, adam.guerin@intel.com,
        herbert@gondor.apana.org.au, wojciech.ziemba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:42:03 +0200
Message-ID: <165451572322421@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80a52e1ee7757b742f96bfb0d58f0c14eb6583d0 Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Mon, 9 May 2022 14:34:11 +0100
Subject: [PATCH] crypto: qat - fix memory leak in RSA

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

