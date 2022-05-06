Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21351DAC1
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442316AbiEFOng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442331AbiEFOnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:43:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13206AA54;
        Fri,  6 May 2022 07:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847982; x=1683383982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LN40Utv6fBacuHLGcMEi9qKwhr/WVROAgUkXtQyys1k=;
  b=liW3KHE+VdK7k2kPVhB7DZrRLQ8NZxyf5qpyVyFM1t75tCcjG3OaqBfo
   KAkOVXEVNekFIG+08KYBUSEkXRfVk0X2ngJs+IfLkStAVD4c9QNBV8rpl
   D+8TBhdcPG++GBMOAr53QGNYk4mwbYBl3/MH01zYkITx2nF6L7xZBlPK0
   KvDbB4qhHdZvNiUz7Xcw2lxJN8vegExK76BnJkOk2SHIBxwJ0zpjVlzQb
   6NYH3otjwjZn4/gK54nMA7bNS/X1ksKph4suN/rwcMRuwd9ZHU4ZZT61W
   ZNmHID5G2z2fKUyrxLsJvJIaiwaiWB/98rWA1ko9HokPtLgO8QcnDPXhC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387516"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387516"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914899"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:26 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 10/11] crypto: qat - honor CRYPTO_TFM_REQ_MAY_SLEEP flag
Date:   Fri,  6 May 2022 15:39:02 +0100
Message-Id: <20220506143903.31776-11-giovanni.cabiddu@intel.com>
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

If a request has the flag CRYPTO_TFM_REQ_MAY_SLEEP set, allocate memory
using the flag GFP_KERNEL otherwise use GFP_ATOMIC.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c      | 19 ++++++++++++-------
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 17 ++++++++++-------
 drivers/crypto/qat/qat_common/qat_crypto.h    |  5 +++++
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 873533dc43a7..148edbe379e3 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -703,7 +703,8 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			       struct scatterlist *sgl,
 			       struct scatterlist *sglout,
-			       struct qat_crypto_request *qat_req)
+			       struct qat_crypto_request *qat_req,
+			       gfp_t flags)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	int i, sg_nctr = 0;
@@ -723,7 +724,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	qat_req->buf.sgl_dst_valid = false;
 
 	if (n > QAT_MAX_BUFF_DESC) {
-		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		bufl = kzalloc_node(sz, flags, node);
 		if (unlikely(!bufl))
 			return -ENOMEM;
 	} else {
@@ -765,7 +766,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		sg_nctr = 0;
 
 		if (n > QAT_MAX_BUFF_DESC) {
-			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			buflout = kzalloc_node(sz_out, flags, node);
 			if (unlikely(!buflout))
 				goto err_in;
 		} else {
@@ -966,6 +967,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
+	gfp_t f = qat_algs_alloc_flags(&areq->base);
 	int ret;
 	u32 cipher_len;
 
@@ -973,7 +975,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	if (cipher_len % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1008,6 +1010,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	struct qat_crypto_request *qat_req = aead_request_ctx(areq);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
+	gfp_t f = qat_algs_alloc_flags(&areq->base);
 	struct icp_qat_fw_la_bulk_req *msg;
 	u8 *iv = areq->iv;
 	int ret;
@@ -1015,7 +1018,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1193,13 +1196,14 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	struct qat_alg_skcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	gfp_t f = qat_algs_alloc_flags(&req->base);
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1258,13 +1262,14 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	struct qat_alg_skcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	gfp_t f = qat_algs_alloc_flags(&req->base);
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 7173a2a0a484..16d97db9ea15 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -224,9 +224,10 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(kpp_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret;
+	gfp_t flags = qat_algs_alloc_flags(&req->base);
 	int n_input_params = 0;
 	u8 *vaddr;
+	int ret;
 
 	if (unlikely(!ctx->xa))
 		return -EINVAL;
@@ -291,7 +292,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		} else {
 			int shift = ctx->p_size - req->src_len;
 
-			qat_req->src_align = kzalloc(ctx->p_size, GFP_KERNEL);
+			qat_req->src_align = kzalloc(ctx->p_size, flags);
 			if (unlikely(!qat_req->src_align))
 				return ret;
 
@@ -317,7 +318,7 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		qat_req->dst_align = NULL;
 		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = kzalloc(ctx->p_size, GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->p_size, flags);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
 
@@ -650,6 +651,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	gfp_t flags = qat_algs_alloc_flags(&req->base);
 	u8 *vaddr;
 	int ret;
 
@@ -696,7 +698,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, flags);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
@@ -714,7 +716,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		qat_req->dst_align = NULL;
 		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, flags);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
 		vaddr = qat_req->dst_align;
@@ -783,6 +785,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	gfp_t flags = qat_algs_alloc_flags(&req->base);
 	u8 *vaddr;
 	int ret;
 
@@ -839,7 +842,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, flags);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
@@ -857,7 +860,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		qat_req->dst_align = NULL;
 		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, flags);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
 		vaddr = qat_req->dst_align;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 245b6d9a3650..df3c738ce323 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -109,4 +109,9 @@ static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
 	return true;
 }
 
+static inline gfp_t qat_algs_alloc_flags(struct crypto_async_request *req)
+{
+	return req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
+
 #endif
-- 
2.35.1

