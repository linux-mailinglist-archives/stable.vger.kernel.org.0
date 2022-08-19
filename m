Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6864D59A00E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351972AbiHSQPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiHSQO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E082186E7;
        Fri, 19 Aug 2022 08:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 627FEB8280C;
        Fri, 19 Aug 2022 15:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17CCC433D6;
        Fri, 19 Aug 2022 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924678;
        bh=N6k61obm7+JxfcVd42/OpjD4ro6f/RUmzdU5nuGhMFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYCOo2Pbhns3PlT9aohLehTVyeP4B01fRMe64zTaU3AU/Ah/cN6QnqFe6FtoUPmSL
         sAKYr9HVvT9VkVJnqKwAVW51/KoybhjkDjRsydSbTVcTNfnMHlJf720FiQ9cfjcqP9
         Bwt9//eWJpr7Xj+ZeFdr9jDGZd7xRxYg2L4j1Ixo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/545] crypto: hisilicon/sec - fixes some coding style
Date:   Fri, 19 Aug 2022 17:39:48 +0200
Message-Id: <20220819153839.111104539@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit a44dce504bce620daff97a3e77650b7b579e8753 ]

1.delete the original complex method of obtaining the
current device and replace it with the initialized
device pointer.
2.fixes some coding style

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 75 +++++++++++-----------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  2 -
 3 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 037762b531e2..5c35043f980f 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -4,8 +4,6 @@
 #ifndef __HISI_SEC_V2_H
 #define __HISI_SEC_V2_H
 
-#include <linux/list.h>
-
 #include "../qm.h"
 #include "sec_crypto.h"
 
@@ -50,7 +48,7 @@ struct sec_req {
 
 	int err_type;
 	int req_id;
-	int flag;
+	u32 flag;
 
 	/* Status of the SEC request */
 	bool fake_busy;
@@ -140,6 +138,7 @@ struct sec_ctx {
 	bool pbuf_supported;
 	struct sec_cipher_ctx c_ctx;
 	struct sec_auth_ctx a_ctx;
+	struct device *dev;
 };
 
 enum sec_endian {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 630dcb59ad56..0b674a771ee0 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -42,7 +42,6 @@
 
 #define SEC_TOTAL_IV_SZ		(SEC_IV_SIZE * QM_Q_DEPTH)
 #define SEC_SGL_SGE_NR		128
-#define SEC_CTX_DEV(ctx)	(&(ctx)->sec->qm.pdev->dev)
 #define SEC_CIPHER_AUTH		0xfe
 #define SEC_AUTH_CIPHER		0x1
 #define SEC_MAX_MAC_LEN		64
@@ -95,7 +94,7 @@ static int sec_alloc_req_id(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
 				  0, QM_Q_DEPTH, GFP_ATOMIC);
 	mutex_unlock(&qp_ctx->req_lock);
 	if (unlikely(req_id < 0)) {
-		dev_err(SEC_CTX_DEV(req->ctx), "alloc req id fail!\n");
+		dev_err(req->ctx->dev, "alloc req id fail!\n");
 		return req_id;
 	}
 
@@ -110,7 +109,7 @@ static void sec_free_req_id(struct sec_req *req)
 	int req_id = req->req_id;
 
 	if (unlikely(req_id < 0 || req_id >= QM_Q_DEPTH)) {
-		dev_err(SEC_CTX_DEV(req->ctx), "free request id invalid!\n");
+		dev_err(req->ctx->dev, "free request id invalid!\n");
 		return;
 	}
 
@@ -136,7 +135,7 @@ static int sec_aead_verify(struct sec_req *req)
 				aead_req->cryptlen + aead_req->assoclen -
 				authsize);
 	if (unlikely(sz != authsize || memcmp(mac_out, mac, sz))) {
-		dev_err(SEC_CTX_DEV(req->ctx), "aead verify failure!\n");
+		dev_err(req->ctx->dev, "aead verify failure!\n");
 		return -EBADMSG;
 	}
 
@@ -175,7 +174,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 	if (unlikely(req->err_type || done != SEC_SQE_DONE ||
 	    (ctx->alg_type == SEC_SKCIPHER && flag != SEC_SQE_CFLAG) ||
 	    (ctx->alg_type == SEC_AEAD && flag != SEC_SQE_AEAD_FLAG))) {
-		dev_err(SEC_CTX_DEV(ctx),
+		dev_err_ratelimited(ctx->dev,
 			"err_type[%d],done[%d],flag[%d]\n",
 			req->err_type, done, flag);
 		err = -EIO;
@@ -323,8 +322,8 @@ static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
 static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 				  struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
 	struct sec_alg_res *res = qp_ctx->res;
+	struct device *dev = ctx->dev;
 	int ret;
 
 	ret = sec_alloc_civ_resource(dev, res);
@@ -357,7 +356,7 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 static void sec_alg_resource_free(struct sec_ctx *ctx,
 				  struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	sec_free_civ_resource(dev, qp_ctx->res);
 
@@ -370,7 +369,7 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 			     int qp_ctx_id, int alg_type)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	struct sec_qp_ctx *qp_ctx;
 	struct hisi_qp *qp;
 	int ret = -ENOMEM;
@@ -426,7 +425,7 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 static void sec_release_qp_ctx(struct sec_ctx *ctx,
 			       struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	hisi_qm_stop_qp(qp_ctx->qp);
 	sec_alg_resource_free(ctx, qp_ctx);
@@ -450,6 +449,7 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
+	ctx->dev = &sec->qm.pdev->dev;
 	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
 	ctx->pbuf_supported = ctx->sec->iommu_used;
@@ -474,11 +474,9 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 err_sec_release_qp_ctx:
 	for (i = i - 1; i >= 0; i--)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
-
 	kfree(ctx->qp_ctx);
 err_destroy_qps:
 	sec_destroy_qps(ctx->qps, sec->ctx_q_num);
-
 	return ret;
 }
 
@@ -497,7 +495,7 @@ static int sec_cipher_init(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
-	c_ctx->c_key = dma_alloc_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	c_ctx->c_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &c_ctx->c_key_dma, GFP_KERNEL);
 	if (!c_ctx->c_key)
 		return -ENOMEM;
@@ -510,7 +508,7 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
 	memzero_explicit(c_ctx->c_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  c_ctx->c_key, c_ctx->c_key_dma);
 }
 
@@ -518,7 +516,7 @@ static int sec_auth_init(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
-	a_ctx->a_key = dma_alloc_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	a_ctx->a_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &a_ctx->a_key_dma, GFP_KERNEL);
 	if (!a_ctx->a_key)
 		return -ENOMEM;
@@ -531,7 +529,7 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
 	memzero_explicit(a_ctx->a_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
 }
 
@@ -631,12 +629,13 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct device *dev = ctx->dev;
 	int ret;
 
 	if (c_mode == SEC_CMODE_XTS) {
 		ret = xts_verify_key(tfm, key, keylen);
 		if (ret) {
-			dev_err(SEC_CTX_DEV(ctx), "xts mode key err!\n");
+			dev_err(dev, "xts mode key err!\n");
 			return ret;
 		}
 	}
@@ -657,7 +656,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec key err!\n");
+		dev_err(dev, "set sec key err!\n");
 		return ret;
 	}
 
@@ -689,7 +688,7 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 
@@ -699,9 +698,8 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 		copy_size = c_req->c_len;
 
 	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
-				qp_ctx->res[req_id].pbuf,
-				copy_size);
-
+							qp_ctx->res[req_id].pbuf,
+							copy_size);
 	if (unlikely(pbuf_length != copy_size)) {
 		dev_err(dev, "copy src data to pbuf error!\n");
 		return -EINVAL;
@@ -725,7 +723,7 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 
@@ -737,7 +735,6 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 	pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst),
 				qp_ctx->res[req_id].pbuf,
 				copy_size);
-
 	if (unlikely(pbuf_length != copy_size))
 		dev_err(dev, "copy pbuf data to dst error!\n");
 
@@ -750,7 +747,7 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	struct sec_alg_res *res = &qp_ctx->res[req->req_id];
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int ret;
 
 	if (req->use_pbuf) {
@@ -805,7 +802,7 @@ static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
 			     struct scatterlist *src, struct scatterlist *dst)
 {
 	struct sec_cipher_req *c_req = &req->c_req;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	if (req->use_pbuf) {
 		sec_cipher_pbuf_unmap(ctx, req, dst);
@@ -889,6 +886,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct device *dev = ctx->dev;
 	struct crypto_authenc_keys keys;
 	int ret;
 
@@ -902,13 +900,13 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec cipher key err!\n");
+		dev_err(dev, "set sec cipher key err!\n");
 		goto bad_key;
 	}
 
 	ret = sec_aead_auth_set_key(&ctx->a_ctx, &keys);
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec auth key err!\n");
+		dev_err(dev, "set sec auth key err!\n");
 		goto bad_key;
 	}
 
@@ -1061,7 +1059,7 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 	sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
 				cryptlen - iv_size);
 	if (unlikely(sz != iv_size))
-		dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
+		dev_err(req->ctx->dev, "copy output iv error!\n");
 }
 
 static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
@@ -1160,7 +1158,7 @@ static int sec_aead_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	ret = sec_skcipher_bd_fill(ctx, req);
 	if (unlikely(ret)) {
-		dev_err(SEC_CTX_DEV(ctx), "skcipher bd fill is error!\n");
+		dev_err(ctx->dev, "skcipher bd fill is error!\n");
 		return ret;
 	}
 
@@ -1194,7 +1192,7 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 					  a_req->assoclen);
 
 		if (unlikely(sz != authsize)) {
-			dev_err(SEC_CTX_DEV(req->ctx), "copy out mac err!\n");
+			dev_err(c->dev, "copy out mac err!\n");
 			err = -EINVAL;
 		}
 	}
@@ -1259,7 +1257,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 	ret = ctx->req_op->bd_send(ctx, req);
 	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS) ||
 		(ret == -EBUSY && !(req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
-		dev_err_ratelimited(SEC_CTX_DEV(ctx), "send sec request failed!\n");
+		dev_err_ratelimited(ctx->dev, "send sec request failed!\n");
 		goto err_send_req;
 	}
 
@@ -1326,7 +1324,7 @@ static int sec_aead_init(struct crypto_aead *tfm)
 	ctx->alg_type = SEC_AEAD;
 	ctx->c_ctx.ivsize = crypto_aead_ivsize(tfm);
 	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
-		dev_err(SEC_CTX_DEV(ctx), "get error aead iv size!\n");
+		dev_err(ctx->dev, "get error aead iv size!\n");
 		return -EINVAL;
 	}
 
@@ -1376,7 +1374,7 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 
 	auth_ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
 	if (IS_ERR(auth_ctx->hash_tfm)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead alloc shash error!\n");
+		dev_err(ctx->dev, "aead alloc shash error!\n");
 		sec_aead_exit(tfm);
 		return PTR_ERR(auth_ctx->hash_tfm);
 	}
@@ -1410,7 +1408,7 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
 	if (unlikely(!sk_req->src || !sk_req->dst)) {
@@ -1533,14 +1531,15 @@ static struct skcipher_alg sec_skciphers[] = {
 
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
-	u8 c_alg = ctx->c_ctx.c_alg;
 	struct aead_request *req = sreq->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	size_t authsize = crypto_aead_authsize(tfm);
+	struct device *dev = ctx->dev;
+	u8 c_alg = ctx->c_ctx.c_alg;
 
 	if (unlikely(!req->src || !req->dst || !req->cryptlen ||
 		req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead input param error!\n");
+		dev_err(dev, "aead input param error!\n");
 		return -EINVAL;
 	}
 
@@ -1552,7 +1551,7 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 
 	/* Support AES only */
 	if (unlikely(c_alg != SEC_CALG_AES)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");
+		dev_err(dev, "aead crypto alg error!\n");
 		return -EINVAL;
 
 	}
@@ -1562,7 +1561,7 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		sreq->c_req.c_len = req->cryptlen - authsize;
 
 	if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
-		dev_err(SEC_CTX_DEV(ctx), "aead crypto length error!\n");
+		dev_err(dev, "aead crypto length error!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index b2786e17d8fe..1db2ae4b7b66 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -64,7 +64,6 @@ enum sec_addr_type {
 };
 
 struct sec_sqe_type2 {
-
 	/*
 	 * mac_len: 0~4 bits
 	 * a_key_len: 5~10 bits
@@ -120,7 +119,6 @@ struct sec_sqe_type2 {
 	/* c_pad_len_field: 0~1 bits */
 	__le16 c_pad_len_field;
 
-
 	__le64 long_a_data_len;
 	__le64 a_ivin_addr;
 	__le64 a_key_addr;
-- 
2.35.1



