Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513B520126A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391649AbgFSPw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392580AbgFSPXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B33021D7F;
        Fri, 19 Jun 2020 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580188;
        bh=yZWkXOfP2kad7R2XBI+KQjjxoy8Pk3WC5roLHhgPHOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+NBpjh28KkVmVmGiBD4ezDsyTMsiVPQo12oO5pz3pKHnL7sPRU5EjaEatcvMm/rh
         npqehy4uO0hDUn/G0pzRT7qYKhxFOudAtj7+/qcAgrtScZzmiiuLR9KBZNuXB3+kxu
         O8ox0NDbLvf3hz+DCjTaUM1GR/EsBVgxpxozS19M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Devulapally Shiva Krishna <shiva@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 156/376] Crypto/chcr: fix ctr, cbc, xts and rfc3686-ctr failed tests
Date:   Fri, 19 Jun 2020 16:31:14 +0200
Message-Id: <20200619141717.706332342@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devulapally Shiva Krishna <shiva@chelsio.com>

[ Upstream commit 6b363a286cd01961423f5dcd648b265088ec56d0 ]

This solves the following issues observed during self test when
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS is enabled.

1. Added fallback for cbc, ctr and rfc3686 if req->nbytes is zero
and for xts added a fallback case if req->nbytes is not multiple of 16.

2. In case of cbc-aes, solved wrong iv update. When
chcr_cipher_fallback() is called, used req->info pointer instead of
reqctx->iv.

3. In cbc-aes decryption there was a wrong result. This occurs when
chcr_cipher_fallback() is called from chcr_handle_cipher_resp().
In the fallback function iv(req->info) used is wrongly updated.
So use the initial iv for this case.

4)In case of ctr-aes encryption observed wrong result. In adjust_ctr_overflow()
there is condition which checks if ((bytes / AES_BLOCK_SIZE) > c),
where c is the number of blocks which can be processed without iv overflow,
but for the above bytes (req->nbytes < 32 , not a multiple of 16) this
condition fails and the 2nd block is corrupted as it requires the rollover iv.
So added a '=' condition in this to take care of this.

5)In rfc3686-ctr there was wrong result observed. This occurs when
chcr_cipher_fallback() is called from chcr_handle_cipher_resp().
Here also copying initial_iv in init_iv pointer for handling the fallback
case correctly.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c   | 42 ++++++++++++++++++----------
 drivers/crypto/chelsio/chcr_crypto.h |  1 +
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5a2d9ee9348d..446fb896ee6d 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1054,8 +1054,8 @@ static unsigned int adjust_ctr_overflow(u8 *iv, u32 bytes)
 	u32 temp = be32_to_cpu(*--b);
 
 	temp = ~temp;
-	c = (u64)temp +  1; // No of block can processed withou overflow
-	if ((bytes / AES_BLOCK_SIZE) > c)
+	c = (u64)temp +  1; // No of block can processed without overflow
+	if ((bytes / AES_BLOCK_SIZE) >= c)
 		bytes = c * AES_BLOCK_SIZE;
 	return bytes;
 }
@@ -1158,15 +1158,16 @@ static int chcr_final_cipher_iv(struct skcipher_request *req,
 static int chcr_handle_cipher_resp(struct skcipher_request *req,
 				   unsigned char *input, int err)
 {
+	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chcr_context *ctx = c_ctx(tfm);
-	struct uld_ctx *u_ctx = ULD_CTX(c_ctx(tfm));
-	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
-	struct sk_buff *skb;
 	struct cpl_fw6_pld *fw6_pld = (struct cpl_fw6_pld *)input;
-	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
-	struct cipher_wr_param wrparam;
+	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
+	struct uld_ctx *u_ctx = ULD_CTX(c_ctx(tfm));
 	struct chcr_dev *dev = c_ctx(tfm)->dev;
+	struct chcr_context *ctx = c_ctx(tfm);
+	struct adapter *adap = padap(ctx->dev);
+	struct cipher_wr_param wrparam;
+	struct sk_buff *skb;
 	int bytes;
 
 	if (err)
@@ -1197,6 +1198,8 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 	if (unlikely(bytes == 0)) {
 		chcr_cipher_dma_unmap(&ULD_CTX(c_ctx(tfm))->lldi.pdev->dev,
 				      req);
+		memcpy(req->iv, reqctx->init_iv, IV);
+		atomic_inc(&adap->chcr_stats.fallback);
 		err = chcr_cipher_fallback(ablkctx->sw_cipher,
 				     req->base.flags,
 				     req->src,
@@ -1248,20 +1251,28 @@ static int process_cipher(struct skcipher_request *req,
 				  struct sk_buff **skb,
 				  unsigned short op_type)
 {
+	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
-	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
 	struct ablk_ctx *ablkctx = ABLK_CTX(c_ctx(tfm));
+	struct adapter *adap = padap(c_ctx(tfm)->dev);
 	struct	cipher_wr_param wrparam;
 	int bytes, err = -EINVAL;
+	int subtype;
 
 	reqctx->processed = 0;
 	reqctx->partial_req = 0;
 	if (!req->iv)
 		goto error;
+	subtype = get_cryptoalg_subtype(tfm);
 	if ((ablkctx->enckey_len == 0) || (ivsize > AES_BLOCK_SIZE) ||
 	    (req->cryptlen == 0) ||
 	    (req->cryptlen % crypto_skcipher_blocksize(tfm))) {
+		if (req->cryptlen == 0 && subtype != CRYPTO_ALG_SUB_TYPE_XTS)
+			goto fallback;
+		else if (req->cryptlen % crypto_skcipher_blocksize(tfm) &&
+			 subtype == CRYPTO_ALG_SUB_TYPE_XTS)
+			goto fallback;
 		pr_err("AES: Invalid value of Key Len %d nbytes %d IV Len %d\n",
 		       ablkctx->enckey_len, req->cryptlen, ivsize);
 		goto error;
@@ -1302,12 +1313,10 @@ static int process_cipher(struct skcipher_request *req,
 	} else {
 		bytes = req->cryptlen;
 	}
-	if (get_cryptoalg_subtype(tfm) ==
-	    CRYPTO_ALG_SUB_TYPE_CTR) {
+	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR) {
 		bytes = adjust_ctr_overflow(req->iv, bytes);
 	}
-	if (get_cryptoalg_subtype(tfm) ==
-	    CRYPTO_ALG_SUB_TYPE_CTR_RFC3686) {
+	if (subtype == CRYPTO_ALG_SUB_TYPE_CTR_RFC3686) {
 		memcpy(reqctx->iv, ablkctx->nonce, CTR_RFC3686_NONCE_SIZE);
 		memcpy(reqctx->iv + CTR_RFC3686_NONCE_SIZE, req->iv,
 				CTR_RFC3686_IV_SIZE);
@@ -1315,20 +1324,25 @@ static int process_cipher(struct skcipher_request *req,
 		/* initialize counter portion of counter block */
 		*(__be32 *)(reqctx->iv + CTR_RFC3686_NONCE_SIZE +
 			CTR_RFC3686_IV_SIZE) = cpu_to_be32(1);
+		memcpy(reqctx->init_iv, reqctx->iv, IV);
 
 	} else {
 
 		memcpy(reqctx->iv, req->iv, IV);
+		memcpy(reqctx->init_iv, req->iv, IV);
 	}
 	if (unlikely(bytes == 0)) {
 		chcr_cipher_dma_unmap(&ULD_CTX(c_ctx(tfm))->lldi.pdev->dev,
 				      req);
+fallback:       atomic_inc(&adap->chcr_stats.fallback);
 		err = chcr_cipher_fallback(ablkctx->sw_cipher,
 					   req->base.flags,
 					   req->src,
 					   req->dst,
 					   req->cryptlen,
-					   reqctx->iv,
+					   subtype ==
+					   CRYPTO_ALG_SUB_TYPE_CTR_RFC3686 ?
+					   reqctx->iv : req->iv,
 					   op_type);
 		goto error;
 	}
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 542bebae001f..b3fdbdc25acb 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -302,6 +302,7 @@ struct chcr_skcipher_req_ctx {
 	unsigned int op;
 	u16 imm;
 	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
+	u8 init_iv[CHCR_MAX_CRYPTO_IV_LEN];
 	u16 txqidx;
 	u16 rxqidx;
 };
-- 
2.25.1



