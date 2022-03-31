Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE104EDD8C
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 17:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbiCaPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 11:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238982AbiCaPmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 11:42:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89E142487;
        Thu, 31 Mar 2022 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648741028; x=1680277028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kBBNB+Un7rmvD0SjZLQnsFl6KoTCeAAwRJnh0pl0xjc=;
  b=Fv3STFSflXRQQNkvX208V/ptKvCwcNQx39IoavhIetobGwjN/mrBcOF4
   LWbDqqVb9ZnYyEcFJLoX2smh3R5+sBBzB7qNGrr4YZd30/kpdsnU1Nl6L
   yrFmC/q8DLwwZ+phVPYUWgOC0eGF74d/SIU6+VysyDCNNHFaS19MGQfFe
   mttMKVN944Y0D7JvHwWEaBViVWwhM4JuuPbSNASXBjq6g6CYbwcejpm4j
   Rmt1pb+FSDNmOids4b4xubDVNtabsTZyO/7oPxhQVtvO6hrdhP5XnR1YP
   07owaASQNHT1tVZDqyqms4o0T57bSeQAJ09PfJZhbG/u3nybGB6z14wvj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242022735"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242022735"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 08:36:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="555124761"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga007.fm.intel.com with ESMTP; 31 Mar 2022 08:36:55 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 1/4] crypto: qat - use pre-allocated buffers in datapath
Date:   Thu, 31 Mar 2022 16:36:49 +0100
Message-Id: <20220331153652.37020-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
References: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to do DMAs, the QAT device requires that the scatterlist
structures are mapped and translated into a format that the firmware can
understand. This is defined as the composition of a scatter gather list
(SGL) descriptor header, the struct qat_alg_buf_list, plus a variable
number of flat buffer descriptors, the struct qat_alg_buf.

The allocation and mapping of these data structures is done each time a
request is received from the skcipher and aead APIs.
In an OOM situation, this behaviour might lead to a dead-lock if an
allocation fails.

Based on the conversation in [1], increase the size of the aead and
skcipher request contexts to include an SGL descriptor that can handle
a maximum of 4 flat buffers.
If requests exceed 4 entries buffers, memory is allocated dynamically.

In addition, remove the CRYPTO_ALG_ALLOCATES_MEMORY flag from both aead
and skcipher alg structures.

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/

Cc: stable@vger.kernel.org
Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c   | 77 ++++++++++++----------
 drivers/crypto/qat/qat_common/qat_crypto.h | 24 +++++++
 2 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f998ed58457c..b9228f3a26de 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -46,19 +46,6 @@
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -693,7 +680,10 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bl);
+
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bl);
+
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
 		int bufless = blout->num_bufs - blout->num_mapped_bufs;
@@ -704,7 +694,9 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
-		kfree(blout);
+
+		if (!qat_req->buf.sgl_dst_valid)
+			kfree(blout);
 	}
 }
 
@@ -721,15 +713,24 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp = DMA_MAPPING_ERROR;
 	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
-	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
+	size_t sz_out, sz = struct_size(bufl, bufers, n);
+	int node = dev_to_node(&GET_DEV(inst->accel_dev));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
-			    dev_to_node(&GET_DEV(inst->accel_dev)));
-	if (unlikely(!bufl))
-		return -ENOMEM;
+	qat_req->buf.sgl_src_valid = false;
+	qat_req->buf.sgl_dst_valid = false;
+
+	if (n > QAT_MAX_BUFF_DESC) {
+		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		if (unlikely(!bufl))
+			return -ENOMEM;
+	} else {
+		bufl = &qat_req->buf.sgl_src.sgl_hdr;
+		memset(bufl, 0, sizeof(struct qat_alg_buf_list));
+		qat_req->buf.sgl_src_valid = true;
+	}
 
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
@@ -760,12 +761,18 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n + 1);
+		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
-				       dev_to_node(&GET_DEV(inst->accel_dev)));
-		if (unlikely(!buflout))
-			goto err_in;
+
+		if (n > QAT_MAX_BUFF_DESC) {
+			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			if (unlikely(!buflout))
+				goto err_in;
+		} else {
+			buflout = &qat_req->buf.sgl_dst.sgl_hdr;
+			memset(buflout, 0, sizeof(struct qat_alg_buf_list));
+			qat_req->buf.sgl_dst_valid = true;
+		}
 
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i)
@@ -810,7 +817,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	kfree(buflout);
+
+	if (!qat_req->buf.sgl_dst_valid)
+		kfree(buflout);
 
 err_in:
 	if (!dma_mapping_error(dev, blp))
@@ -823,7 +832,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	kfree(bufl);
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
@@ -1434,7 +1444,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1451,7 +1461,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1468,7 +1478,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1486,7 +1496,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1504,7 +1514,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1522,8 +1532,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
-			  CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index b6a4c95ae003..0928f159ea99 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -21,6 +21,26 @@ struct qat_crypto_instance {
 	atomic_t refctr;
 };
 
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
 struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *bl;
 	dma_addr_t blp;
@@ -28,6 +48,10 @@ struct qat_crypto_request_buffs {
 	dma_addr_t bloutp;
 	size_t sz;
 	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
 struct qat_crypto_request;
-- 
2.35.1

