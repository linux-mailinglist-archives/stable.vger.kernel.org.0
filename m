Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3437C51D35E
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390112AbiEFI1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 04:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385302AbiEFI1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 04:27:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209DE68F9D;
        Fri,  6 May 2022 01:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651825437; x=1683361437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QVieToZTwkUTg8tgOnNahmwcV80gLgiaQSpxnim20R4=;
  b=OXPIQJ9czPexSZK7ZPRR/ZaQO+OWkEaPats0uWK2t7+76sti/QjmuCdu
   g8cy0HkjZ9bRxRaZ5OVJTotq/+RTCpMnmW3HzkpxZ/9HNJht6uDTHknbi
   Evkv1fdHlmdep/VwaJRyLkkHD0AXTGP2z/6ae0mL0n+RgExDKiJK6XwMC
   HqzPSKSlBiwJpJot3kgRyfIknR/Edr81EPFHB7CWX1zn7NAi3zVFNyvr+
   iCi0y/4whiNNdv1VzcjRUHhpEm93jUrZb3I9C48Kpmrjfxnzj5ey9J5bZ
   RuMuG/e3ADpxCgU/sbcBAY1qKJho+ANj00HCB/zeDJc/tNeVWkKkex47a
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328938516"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328938516"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:23:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563709043"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 01:23:54 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 10/12] crypto: qat - use memzero_explicit() for algs
Date:   Fri,  6 May 2022 09:23:25 +0100
Message-Id: <20220506082327.21605-11-giovanni.cabiddu@intel.com>
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

Use memzero_explicit(), instead of a memset(.., 0, ..) in the
implementation of the algorithms, for buffers containing sensitive
information to ensure they are wiped out before free.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c      | 20 +++++++++----------
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 +++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 873533dc43a7..c42df18e02b2 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -637,12 +637,12 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
 	return 0;
 
 out_free_all:
-	memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
+	memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
-	memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
+	memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
@@ -1092,12 +1092,12 @@ static int qat_alg_skcipher_newkey(struct qat_alg_skcipher_ctx *ctx,
 	return 0;
 
 out_free_all:
-	memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+	memzero_explicit(ctx->dec_cd, sizeof(*ctx->dec_cd));
 	dma_free_coherent(dev, sizeof(*ctx->dec_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
-	memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+	memzero_explicit(ctx->enc_cd, sizeof(*ctx->enc_cd));
 	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
@@ -1359,12 +1359,12 @@ static void qat_alg_aead_exit(struct crypto_aead *tfm)
 
 	dev = &GET_DEV(inst->accel_dev);
 	if (ctx->enc_cd) {
-		memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
+		memzero_explicit(ctx->enc_cd, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->enc_cd, ctx->enc_cd_paddr);
 	}
 	if (ctx->dec_cd) {
-		memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
+		memzero_explicit(ctx->dec_cd, sizeof(struct qat_alg_cd));
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
 	}
@@ -1412,15 +1412,15 @@ static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 
 	dev = &GET_DEV(inst->accel_dev);
 	if (ctx->enc_cd) {
-		memset(ctx->enc_cd, 0,
-		       sizeof(struct icp_qat_hw_cipher_algo_blk));
+		memzero_explicit(ctx->enc_cd,
+				 sizeof(struct icp_qat_hw_cipher_algo_blk));
 		dma_free_coherent(dev,
 				  sizeof(struct icp_qat_hw_cipher_algo_blk),
 				  ctx->enc_cd, ctx->enc_cd_paddr);
 	}
 	if (ctx->dec_cd) {
-		memset(ctx->dec_cd, 0,
-		       sizeof(struct icp_qat_hw_cipher_algo_blk));
+		memzero_explicit(ctx->dec_cd,
+				 sizeof(struct icp_qat_hw_cipher_algo_blk));
 		dma_free_coherent(dev,
 				  sizeof(struct icp_qat_hw_cipher_algo_blk),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index b3badc5bd224..86c7d07435c8 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1087,19 +1087,19 @@ static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
 	return;
 
 free_dq:
-	memset(ctx->dq, '\0', half_key_sz);
+	memzero_explicit(ctx->dq, half_key_sz);
 	dma_free_coherent(dev, half_key_sz, ctx->dq, ctx->dma_dq);
 	ctx->dq = NULL;
 free_dp:
-	memset(ctx->dp, '\0', half_key_sz);
+	memzero_explicit(ctx->dp, half_key_sz);
 	dma_free_coherent(dev, half_key_sz, ctx->dp, ctx->dma_dp);
 	ctx->dp = NULL;
 free_q:
-	memset(ctx->q, '\0', half_key_sz);
+	memzero_explicit(ctx->q, half_key_sz);
 	dma_free_coherent(dev, half_key_sz, ctx->q, ctx->dma_q);
 	ctx->q = NULL;
 free_p:
-	memset(ctx->p, '\0', half_key_sz);
+	memzero_explicit(ctx->p, half_key_sz);
 	dma_free_coherent(dev, half_key_sz, ctx->p, ctx->dma_p);
 	ctx->p = NULL;
 err:
@@ -1116,27 +1116,27 @@ static void qat_rsa_clear_ctx(struct device *dev, struct qat_rsa_ctx *ctx)
 	if (ctx->e)
 		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
 	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
+		memzero_explicit(ctx->d, ctx->key_sz);
 		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
 	}
 	if (ctx->p) {
-		memset(ctx->p, '\0', half_key_sz);
+		memzero_explicit(ctx->p, half_key_sz);
 		dma_free_coherent(dev, half_key_sz, ctx->p, ctx->dma_p);
 	}
 	if (ctx->q) {
-		memset(ctx->q, '\0', half_key_sz);
+		memzero_explicit(ctx->q, half_key_sz);
 		dma_free_coherent(dev, half_key_sz, ctx->q, ctx->dma_q);
 	}
 	if (ctx->dp) {
-		memset(ctx->dp, '\0', half_key_sz);
+		memzero_explicit(ctx->dp, half_key_sz);
 		dma_free_coherent(dev, half_key_sz, ctx->dp, ctx->dma_dp);
 	}
 	if (ctx->dq) {
-		memset(ctx->dq, '\0', half_key_sz);
+		memzero_explicit(ctx->dq, half_key_sz);
 		dma_free_coherent(dev, half_key_sz, ctx->dq, ctx->dma_dq);
 	}
 	if (ctx->qinv) {
-		memset(ctx->qinv, '\0', half_key_sz);
+		memzero_explicit(ctx->qinv, half_key_sz);
 		dma_free_coherent(dev, half_key_sz, ctx->qinv, ctx->dma_qinv);
 	}
 
-- 
2.35.1

