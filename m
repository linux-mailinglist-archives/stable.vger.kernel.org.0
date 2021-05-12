Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2159637C48E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhELPb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235423AbhELP1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63080616E8;
        Wed, 12 May 2021 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832373;
        bh=kXwUv/xodgEjxSU8dehnR30+tljWJsn0221ZTfiT1sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHKiATkMJqczv3n0keJc9vbrRFNG5oQXSYKSUKKXX/d4M3o9C2NLtxLCtJaCOKCMB
         jfX0NROhA2Qz6bK4fZp99lSGvdtevF1D6KBGjv/9r9u56QERZUoVUmY+4sKJvHCbdj
         wSXMAduhT5PYWyayuQf8vkjXb/49qjyAQ+eQ90PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/530] crypto: chelsio - Read rxchannel-id from firmware
Date:   Wed, 12 May 2021 16:46:02 +0200
Message-Id: <20210512144828.116369955@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 13b908ea4873..884adeb63ba3 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -768,13 +768,14 @@ static inline void create_wreq(struct chcr_context *ctx,
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
@@ -805,6 +806,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(wrparam->req);
 	struct chcr_context *ctx = c_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 	struct sk_buff *skb = NULL;
 	struct chcr_wr *chcr_req;
@@ -821,6 +823,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	nents = sg_nents_xlen(reqctx->dstsg,  wrparam->bytes, CHCR_DST_SG_SIZE,
 			      reqctx->dst_ofst);
 	dst_size = get_space_for_phys_dsgl(nents);
@@ -1579,6 +1582,7 @@ static struct sk_buff *create_hash_wr(struct ahash_request *req,
 	int error = 0;
 	unsigned int rx_channel_id = req_ctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	transhdr_len = HASH_TRANSHDR_SIZE(param->kctx_len);
 	req_ctx->hctx_wr.imm = (transhdr_len + param->bfr_len +
 				param->sg_len) <= SGE_MAX_WR_LEN;
@@ -2437,6 +2441,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
@@ -2456,6 +2461,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	if (req->cryptlen == 0)
 		return NULL;
 
@@ -2709,9 +2715,11 @@ void chcr_add_aead_dst_ent(struct aead_request *req,
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
@@ -2751,9 +2759,11 @@ void chcr_add_cipher_dst_ent(struct skcipher_request *req,
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
@@ -2957,6 +2967,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
 	unsigned int cipher_mode = CHCR_SCMD_CIPHER_MODE_AES_CCM;
@@ -2966,6 +2977,8 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	unsigned int tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
+
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
 		assoclen = req->assoclen - 8;
 	else
@@ -3126,6 +3139,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_context *ctx = a_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
 	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
 	struct sk_buff *skb = NULL;
@@ -3142,6 +3156,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	struct adapter *adap = padap(ctx->dev);
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 
+	rx_channel_id = cxgb4_port_e2cchan(u_ctx->lldi.ports[rx_channel_id]);
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106)
 		assoclen = req->assoclen - 8;
 
-- 
2.30.2



