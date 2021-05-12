Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F249037C8C6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhELQMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhELQHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6120461D13;
        Wed, 12 May 2021 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833771;
        bh=h9r+ERbM9K4eWELi9BdPErpjwtGTI5Bze+WkBHEj2uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bka6JJKU7PSGiSwU3TqSxZaxIzuklsXgZtvVxLh0FMJdX0OTUafosX0LBfBUanb4D
         xsIGII31kewBC/6PZsHEgoAxi32US6EP6a7dBNooVM/Td+titQCE14EON57iXyWoOR
         h8VqkHfniRK0vGjTLB+Wz1qttfXm5Kuegd1KAhN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 282/601] crypto: chelsio - Read rxchannel-id from firmware
Date:   Wed, 12 May 2021 16:45:59 +0200
Message-Id: <20210512144837.101311519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 16a9874fe468855e8ddd72883ca903f706d0a9d0 ]

The rxchannel id is updated by the driver using the
port no value, but this does not ensure that the value
is correct. So now rx channel value is obtained from
etoc channel map value.

Fixes: 567be3a5d227 ("crypto: chelsio - Use multiple txq/rxq per...")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f5a336634daa..405ff957b837 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -769,13 +769,14 @@ static inline void create_wreq(struct chcr_context *ctx,
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	unsigned int tx_channel_id, rx_channel_id;
 	unsigned int txqidx = 0, rxqidx = 0;
-	unsigned int qid, fid;
+	unsigned int qid, fid, portno;
 
 	get_qidxs(req, &txqidx, &rxqidx);
 	qid = u_ctx->lldi.rxq_ids[rxqidx];
 	fid = u_ctx->lldi.rxq_ids[0];
+	portno = rxqidx / ctx->rxq_perchan;
 	tx_channel_id = txqidx / ctx->txq_perchan;
-	rx_channel_id = rxqidx / ctx->rxq_perchan;
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[portno]);
 
 
 	chcr_req->wreq.op_to_cctx_size = FILL_WR_OP_CCTX_SIZE;
@@ -806,6 +807,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(wrparam->req);
 	struct chcr_context *ctx = c_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 	struct sk_buff *skb = NULL;
 	struct chcr_wr *chcr_req;
@@ -822,6 +824,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	nents = sg_nents_xlen(reqctx->dstsg,  wrparam->bytes, CHCR_DST_SG_SIZE,
 			      reqctx->dst_ofst);
 	dst_size = get_space_for_phys_dsgl(nents);
@@ -1580,6 +1583,7 @@ static struct sk_buff *create_hash_wr(struct ahash_request *req,
 	int error = 0;
 	unsigned int rx_channel_id = req_ctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	transhdr_len = HASH_TRANSHDR_SIZE(param->kctx_len);
 	req_ctx->hctx_wr.imm = (transhdr_len + param->bfr_len +
 				param->sg_len) <= SGE_MAX_WR_LEN;
@@ -2438,6 +2442,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
@@ -2457,6 +2462,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	if (req->cryptlen == 0)
 		return NULL;
 
@@ -2710,9 +2716,11 @@ void chcr_add_aead_dst_ent(struct aead_request *req,
 	struct dsgl_walk dsgl_walk;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	u32 temp;
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	dsgl_walk_init(&dsgl_walk, phys_cpl);
 	dsgl_walk_add_page(&dsgl_walk, IV + reqctx->b0_len, reqctx->iv_dma);
 	temp = req->assoclen + req->cryptlen +
@@ -2752,9 +2760,11 @@ void chcr_add_cipher_dst_ent(struct skcipher_request *req,
 	struct chcr_skcipher_req_ctx *reqctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(wrparam->req);
 	struct chcr_context *ctx = c_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct dsgl_walk dsgl_walk;
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	dsgl_walk_init(&dsgl_walk, phys_cpl);
 	dsgl_walk_add_sg(&dsgl_walk, reqctx->dstsg, wrparam->bytes,
 			 reqctx->dst_ofst);
@@ -2958,6 +2968,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
 	unsigned int cipher_mode = CHCR_SCMD_CIPHER_MODE_AES_CCM;
@@ -2967,6 +2978,8 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	unsigned int tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
+
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
 		assoclen = req->assoclen - 8;
 	else
@@ -3127,6 +3140,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
 	struct sk_buff *skb = NULL;
@@ -3143,6 +3157,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106)
 		assoclen = req->assoclen - 8;
 
-- 
2.30.2



