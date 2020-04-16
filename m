Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6981ACAA5
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgDPPhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896336AbgDPNjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:39:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDB7206E9;
        Thu, 16 Apr 2020 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043876;
        bh=Mtb1Yzv9fn4jHqGvU001h2g8dXZkJ+KNPgcKxcKOBhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnynn9hGKKmsf5h4bwm9UyK9HBE6P/ri0jVVuFlkJ6Q/5YDy0Dz5C+Vv1fOhkYT5z
         32pxfP3YX25tai7izyF/UtnUoBuW/ggXtvSiA3Y0s/4oAC49AK7asetDJmae/WezgI
         IS7B/MlDjjTYXAcfF0hUaZOp+DV+bal6y6d0iA9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/146] crypto: ccree - dont mangle the request assoclen
Date:   Thu, 16 Apr 2020 15:24:38 +0200
Message-Id: <20200416131301.128298760@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit da3cf67f1bcf25b069a54ff70fd108860242c8f7 ]

We were mangling the request struct assoclen field.
Fix it by keeping an internal version and working on it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_aead.c       | 40 +++++++++++++++++-----------
 drivers/crypto/ccree/cc_aead.h       |  1 +
 drivers/crypto/ccree/cc_buffer_mgr.c | 22 +++++++--------
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index c9233420fe421..57aac15a335f5 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -731,7 +731,7 @@ static void cc_set_assoc_desc(struct aead_request *areq, unsigned int flow_mode,
 		dev_dbg(dev, "ASSOC buffer type DLLI\n");
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
-			     areq->assoclen, NS_BIT);
+			     areq_ctx->assoclen, NS_BIT);
 		set_flow_mode(&desc[idx], flow_mode);
 		if (ctx->auth_mode == DRV_HASH_XCBC_MAC &&
 		    areq_ctx->cryptlen > 0)
@@ -1080,9 +1080,11 @@ static void cc_proc_header_desc(struct aead_request *req,
 				struct cc_hw_desc desc[],
 				unsigned int *seq_size)
 {
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
+
 	/* Hash associated data */
-	if (req->assoclen > 0)
+	if (areq_ctx->assoclen > 0)
 		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 
 	/* Hash IV */
@@ -1310,7 +1312,7 @@ static int validate_data_size(struct cc_aead_ctx *ctx,
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	unsigned int assoclen = req->assoclen;
+	unsigned int assoclen = areq_ctx->assoclen;
 	unsigned int cipherlen = (direct == DRV_CRYPTO_DIRECTION_DECRYPT) ?
 			(req->cryptlen - ctx->authsize) : req->cryptlen;
 
@@ -1469,7 +1471,7 @@ static int cc_ccm(struct aead_request *req, struct cc_hw_desc desc[],
 	idx++;
 
 	/* process assoc data */
-	if (req->assoclen > 0) {
+	if (req_ctx->assoclen > 0) {
 		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
@@ -1561,7 +1563,7 @@ static int config_ccm_adata(struct aead_request *req)
 	 * NIST Special Publication 800-38C
 	 */
 	*b0 |= (8 * ((m - 2) / 2));
-	if (req->assoclen > 0)
+	if (req_ctx->assoclen > 0)
 		*b0 |= 64;  /* Enable bit 6 if Adata exists. */
 
 	rc = set_msg_len(b0 + 16 - l, cryptlen, l);  /* Write L'. */
@@ -1572,7 +1574,7 @@ static int config_ccm_adata(struct aead_request *req)
 	 /* END of "taken from crypto/ccm.c" */
 
 	/* l(a) - size of associated data. */
-	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req->assoclen);
+	req_ctx->ccm_hdr_size = format_ccm_a0(a0, req_ctx->assoclen);
 
 	memset(req->iv + 15 - req->iv[0], 0, req->iv[0] + 1);
 	req->iv[15] = 1;
@@ -1604,7 +1606,7 @@ static void cc_proc_rfc4309_ccm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + CCM_BLOCK_IV_OFFSET, req->iv,
 	       CCM_BLOCK_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= CCM_BLOCK_IV_SIZE;
+	areq_ctx->assoclen -= CCM_BLOCK_IV_SIZE;
 }
 
 static void cc_set_ghash_desc(struct aead_request *req,
@@ -1812,7 +1814,7 @@ static int cc_gcm(struct aead_request *req, struct cc_hw_desc desc[],
 	// for gcm and rfc4106.
 	cc_set_ghash_desc(req, desc, seq_size);
 	/* process(ghash) assoc data */
-	if (req->assoclen > 0)
+	if (req_ctx->assoclen > 0)
 		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
 	cc_set_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
@@ -1836,8 +1838,8 @@ static int config_gcm_context(struct aead_request *req)
 				(req->cryptlen - ctx->authsize);
 	__be32 counter = cpu_to_be32(2);
 
-	dev_dbg(dev, "%s() cryptlen = %d, req->assoclen = %d ctx->authsize = %d\n",
-		__func__, cryptlen, req->assoclen, ctx->authsize);
+	dev_dbg(dev, "%s() cryptlen = %d, req_ctx->assoclen = %d ctx->authsize = %d\n",
+		__func__, cryptlen, req_ctx->assoclen, ctx->authsize);
 
 	memset(req_ctx->hkey, 0, AES_BLOCK_SIZE);
 
@@ -1853,7 +1855,7 @@ static int config_gcm_context(struct aead_request *req)
 	if (!req_ctx->plaintext_authenticate_only) {
 		__be64 temp64;
 
-		temp64 = cpu_to_be64(req->assoclen * 8);
+		temp64 = cpu_to_be64(req_ctx->assoclen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1863,8 +1865,8 @@ static int config_gcm_context(struct aead_request *req)
 		 */
 		__be64 temp64;
 
-		temp64 = cpu_to_be64((req->assoclen + GCM_BLOCK_RFC4_IV_SIZE +
-				      cryptlen) * 8);
+		temp64 = cpu_to_be64((req_ctx->assoclen +
+				      GCM_BLOCK_RFC4_IV_SIZE + cryptlen) * 8);
 		memcpy(&req_ctx->gcm_len_block.len_a, &temp64, sizeof(temp64));
 		temp64 = 0;
 		memcpy(&req_ctx->gcm_len_block.len_c, &temp64, 8);
@@ -1884,7 +1886,7 @@ static void cc_proc_rfc4_gcm(struct aead_request *req)
 	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_IV_OFFSET, req->iv,
 	       GCM_BLOCK_RFC4_IV_SIZE);
 	req->iv = areq_ctx->ctr_iv;
-	req->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
+	areq_ctx->assoclen -= GCM_BLOCK_RFC4_IV_SIZE;
 }
 
 static int cc_proc_aead(struct aead_request *req,
@@ -1909,7 +1911,7 @@ static int cc_proc_aead(struct aead_request *req,
 	/* Check data length according to mode */
 	if (validate_data_size(ctx, direct, req)) {
 		dev_err(dev, "Unsupported crypt/assoc len %d/%d.\n",
-			req->cryptlen, req->assoclen);
+			req->cryptlen, areq_ctx->assoclen);
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
 		return -EINVAL;
 	}
@@ -2062,6 +2064,7 @@ static int cc_aead_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
@@ -2093,6 +2096,7 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = true;
 
@@ -2114,6 +2118,7 @@ static int cc_aead_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = false;
 
@@ -2143,6 +2148,7 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->is_gcm4543 = true;
@@ -2262,6 +2268,7 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2290,6 +2297,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
@@ -2321,6 +2329,7 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->plaintext_authenticate_only = false;
@@ -2349,6 +2358,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 
 	/* No generated IV required */
 	areq_ctx->backup_iv = req->iv;
+	areq_ctx->assoclen = req->assoclen;
 	areq_ctx->backup_giv = NULL;
 
 	cc_proc_rfc4_gcm(req);
diff --git a/drivers/crypto/ccree/cc_aead.h b/drivers/crypto/ccree/cc_aead.h
index 5edf3b351fa44..74bc99067f180 100644
--- a/drivers/crypto/ccree/cc_aead.h
+++ b/drivers/crypto/ccree/cc_aead.h
@@ -67,6 +67,7 @@ struct aead_req_ctx {
 	u8 backup_mac[MAX_MAC_SIZE];
 	u8 *backup_iv; /*store iv for generated IV flow*/
 	u8 *backup_giv; /*store iv for rfc3686(ctr) flow*/
+	u32 assoclen; /* internal assoclen */
 	dma_addr_t mac_buf_dma_addr; /* internal ICV DMA buffer */
 	/* buffer for internal ccm configurations */
 	dma_addr_t ccm_iv0_dma_addr;
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 7489887cc7802..6681d113c0d67 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -65,7 +65,7 @@ static void cc_copy_mac(struct device *dev, struct aead_request *req,
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	u32 skip = req->assoclen + req->cryptlen;
+	u32 skip = areq_ctx->assoclen + req->cryptlen;
 
 	if (areq_ctx->is_gcm4543)
 		skip += crypto_aead_ivsize(tfm);
@@ -574,8 +574,8 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 
 	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
-		req->assoclen, req->cryptlen);
-	size_to_unmap = req->assoclen + req->cryptlen;
+		areq_ctx->assoclen, req->cryptlen);
+	size_to_unmap = areq_ctx->assoclen + req->cryptlen;
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_unmap += areq_ctx->req_authsize;
 	if (areq_ctx->is_gcm4543)
@@ -717,7 +717,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 	struct scatterlist *current_sg = req->src;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned int sg_index = 0;
-	u32 size_of_assoc = req->assoclen;
+	u32 size_of_assoc = areq_ctx->assoclen;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (areq_ctx->is_gcm4543)
@@ -728,7 +728,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 		goto chain_assoc_exit;
 	}
 
-	if (req->assoclen == 0) {
+	if (areq_ctx->assoclen == 0) {
 		areq_ctx->assoc_buff_type = CC_DMA_BUF_NULL;
 		areq_ctx->assoc.nents = 0;
 		areq_ctx->assoc.mlli_nents = 0;
@@ -788,7 +788,7 @@ static int cc_aead_chain_assoc(struct cc_drvdata *drvdata,
 			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
 		cc_add_sg_entry(dev, sg_data, areq_ctx->assoc.nents, req->src,
-				req->assoclen, 0, is_last,
+				areq_ctx->assoclen, 0, is_last,
 				&areq_ctx->assoc.mlli_nents);
 		areq_ctx->assoc_buff_type = CC_DMA_BUF_MLLI;
 	}
@@ -972,11 +972,11 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	u32 src_mapped_nents = 0, dst_mapped_nents = 0;
 	u32 offset = 0;
 	/* non-inplace mode */
-	unsigned int size_for_map = req->assoclen + req->cryptlen;
+	unsigned int size_for_map = areq_ctx->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
-	u32 size_to_skip = req->assoclen;
+	u32 size_to_skip = areq_ctx->assoclen;
 
 	if (is_gcm4543)
 		size_to_skip += crypto_aead_ivsize(tfm);
@@ -1020,7 +1020,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	areq_ctx->src_offset = offset;
 
 	if (req->src != req->dst) {
-		size_for_map = req->assoclen + req->cryptlen;
+		size_for_map = areq_ctx->assoclen + req->cryptlen;
 		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 				authsize : 0;
 		if (is_gcm4543)
@@ -1186,7 +1186,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		areq_ctx->ccm_iv0_dma_addr = dma_addr;
 
 		rc = cc_set_aead_conf_buf(dev, areq_ctx, areq_ctx->ccm_config,
-					  &sg_data, req->assoclen);
+					  &sg_data, areq_ctx->assoclen);
 		if (rc)
 			goto aead_map_failure;
 	}
@@ -1237,7 +1237,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		areq_ctx->gcm_iv_inc2_dma_addr = dma_addr;
 	}
 
-	size_to_map = req->cryptlen + req->assoclen;
+	size_to_map = req->cryptlen + areq_ctx->assoclen;
 	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
 		size_to_map += authsize;
 
-- 
2.20.1



