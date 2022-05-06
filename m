Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9171B51DAB7
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442286AbiEFOnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442296AbiEFOm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:42:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9046A42B;
        Fri,  6 May 2022 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847956; x=1683383956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DyfWIgo2v92FeS25yt2Fm6CFdJ2n1oBzonkJ0Ac0ttg=;
  b=SPNRRtslkeZktSJ1tjycmHnk2W8AXZbDxS7YbGqMUUuMTnBg/k32H+1S
   q5BX1ZWE05/Mk5tHiZhI76RnQCCXdgkXYboJGpB1MKNSqt/F2asaN52Q+
   evYNbsX4dfsoc3rmngkbhJdF/oARB+WrhJUAnWloJQXUYqx4kOXqYPXpy
   64vhQo3KG2AoikcVqrqXENRaZCL8rEcSKM0psHnOjn8XYxc+B4G0UbSea
   8xDczGaZZ1CKw8OtCPHA46D1DTxFzA2FvpbMjeqZLyMgC+Iu7xWhzLqxQ
   WX3EUJqAcFSGEn8fd+Y9N3nm5M2hfKdCVwKQas/vxle4ytPSHQFOsreMm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387474"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387474"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914825"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:13 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 04/11] crypto: qat - fix memory leak in RSA
Date:   Fri,  6 May 2022 15:38:56 +0100
Message-Id: <20220506143903.31776-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

