Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B947413D7B5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 11:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbgAPKPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 05:15:21 -0500
Received: from foss.arm.com ([217.140.110.172]:47500 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgAPKPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED5E431B;
        Thu, 16 Jan 2020 02:15:19 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B0513F534;
        Thu, 16 Jan 2020 02:15:18 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] crypto: ccree - fix FDE descriptor sequence
Date:   Thu, 16 Jan 2020 12:14:42 +0200
Message-Id: <20200116101447.20374-8-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

In FDE mode (xts, essiv and bitlocker) the cryptocell hardware requires
that the the XEX key will be loaded after Key1.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Cc: stable@vger.kernel.org 
---
 drivers/crypto/ccree/cc_cipher.c | 48 ++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 03aa4fb8e6cb..7d6252d892d7 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -520,6 +520,7 @@ static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
 	}
 }
 
+
 static void cc_setup_state_desc(struct crypto_tfm *tfm,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
@@ -531,8 +532,6 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 	int cipher_mode = ctx_p->cipher_mode;
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
-	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
-	unsigned int key_len = ctx_p->keylen;
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
 	unsigned int du_size = nbytes;
 
@@ -567,6 +566,47 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
+		break;
+	default:
+		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
+	}
+}
+
+
+static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
+				 struct cipher_req_ctx *req_ctx,
+				 unsigned int ivsize, unsigned int nbytes,
+				 struct cc_hw_desc desc[],
+				 unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	int cipher_mode = ctx_p->cipher_mode;
+	int flow_mode = ctx_p->flow_mode;
+	int direction = req_ctx->gen_ctx.op_type;
+	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
+	unsigned int key_len = ctx_p->keylen;
+	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
+	unsigned int du_size = nbytes;
+
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
+			     skcipher_alg.base);
+
+	if (cc_alg->data_unit)
+		du_size = cc_alg->data_unit;
+
+	switch (cipher_mode) {
+	case DRV_CIPHER_ECB:
+		break;
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
+		break;
+	case DRV_CIPHER_XTS:
+	case DRV_CIPHER_ESSIV:
 	case DRV_CIPHER_BITLOCKER:
 		/* load XEX key */
 		hw_desc_init(&desc[*seq_size]);
@@ -877,12 +917,14 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* STAT_PHASE_2: Create sequence */
 
-	/* Setup IV and XEX key used */
+	/* Setup state (IV)  */
 	cc_setup_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
 	/* Setup MLLI line, if needed */
 	cc_setup_mlli_desc(tfm, req_ctx, dst, src, nbytes, req, desc, &seq_len);
 	/* Setup key */
 	cc_setup_key_desc(tfm, req_ctx, nbytes, desc, &seq_len);
+	/* Setup state (IV and XEX key)  */
+	cc_setup_xex_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
 	/* Data processing */
 	cc_setup_flow_desc(tfm, req_ctx, dst, src, nbytes, desc, &seq_len);
 	/* Read next IV */
-- 
2.23.0

