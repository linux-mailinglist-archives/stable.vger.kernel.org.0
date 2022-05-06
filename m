Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED7551D34F
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353474AbiEFI1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 04:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344584AbiEFI1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 04:27:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CB2689BE;
        Fri,  6 May 2022 01:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651825422; x=1683361422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DyfWIgo2v92FeS25yt2Fm6CFdJ2n1oBzonkJ0Ac0ttg=;
  b=I49v2p9pitEbuT8bi9IrITwuht8RXYYx70UF5F+DwqLKG7zWu5VaOjG7
   5YE5YJhgyAcYOpt5fCRkLON2ZyGyZuHd2c1XFBEhHwyHNZypE5i/391u3
   Lgr7c/dmykL1w3msH8ox9yK99jkqDViC1l5l87dNTcQm1pzR+/EnwJ51E
   S023ezTx//fB3Ns2XY2aQ5Qlvf4CxW9E2eMCnygseNIQas1QcHZcNhbm4
   PylfVokr0EAQoqvBhI+eE2OzcnMHB4YhY2KER94lGgN0YetdJnfMQtbQN
   2PEyXCPhgSQY5hgSCk10nLwsD4lLjrfdQRciQblnB424wfPFSHjTutd7j
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328938460"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328938460"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:23:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563708955"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 01:23:40 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 04/12] crypto: qat - fix memory leak in RSA
Date:   Fri,  6 May 2022 09:23:19 +0100
Message-Id: <20220506082327.21605-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 306219a4b00e..9be972430f11 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1254,18 +1254,8 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
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

