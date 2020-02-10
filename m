Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB511577D2
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgBJNCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgBJMka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:30 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC0B2467A;
        Mon, 10 Feb 2020 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338429;
        bh=4vEfRdlu3oLVPvXQNnaJjWhCEed+ph+icj0JNeghhpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Io/KnEvj+mOZVYD85ThyZRPaFbjutgEMSirHkrwCrMc7zXhgd2yaeElbvSSAkEyzc
         LqWQkImiRvYJWhNm/6THz59u2SNWmXyG41dnsAN+AxBLKpOrBZ+WSjtHqyn8cx7CMK
         KoHifgywFpTC+PLOliBARe/vc2Dic+mjp3VWxsio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 118/367] crypto: ccree - fix FDE descriptor sequence
Date:   Mon, 10 Feb 2020 04:30:31 -0800
Message-Id: <20200210122435.559058062@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

commit 5c83e8ec4d51ac4cc58482ed04297e6882b32a09 upstream.

In FDE mode (xts, essiv and bitlocker) the cryptocell hardware requires
that the the XEX key will be loaded after Key1.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_cipher.c |   48 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -523,6 +523,7 @@ static void cc_setup_readiv_desc(struct
 	}
 }
 
+
 static void cc_setup_state_desc(struct crypto_tfm *tfm,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
@@ -534,8 +535,6 @@ static void cc_setup_state_desc(struct c
 	int cipher_mode = ctx_p->cipher_mode;
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
-	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
-	unsigned int key_len = ctx_p->keylen;
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
 	unsigned int du_size = nbytes;
 
@@ -571,6 +570,47 @@ static void cc_setup_state_desc(struct c
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
 	case DRV_CIPHER_BITLOCKER:
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
+	case DRV_CIPHER_BITLOCKER:
 		/* load XEX key */
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
@@ -881,12 +921,14 @@ static int cc_cipher_process(struct skci
 
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


