Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A881AC8E6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395038AbgDPPQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441637AbgDPNuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2190E2223F;
        Thu, 16 Apr 2020 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044960;
        bh=VmVN60V25JspsZ14eGwB7Xo4/VC6TrWzh+uz3z2ASuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNpvQQk/jcMLMdXwkMur12w2GRR/N9HqcS/6PZJ/LaX8jwJKFdWyyL6owh5Afr85q
         7OChxm0jFKzOqTlwAnenadwL49pqJocUy/qcvHsxeUxra6zyE3fwOkwqOd1xn3Qeu0
         1gDcuyT61WmUzqzZePBPRWuBO3h6e6c8KKrOFcbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 170/232] crypto: ccree - protect against empty or NULL scatterlists
Date:   Thu, 16 Apr 2020 15:24:24 +0200
Message-Id: <20200416131336.274627879@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit ce0fc6db38decf0d2919bfe783de6d6b76e421a9 upstream.

Deal gracefully with a NULL or empty scatterlist which can happen
if both cryptlen and assoclen are zero and we're doing in-place
AEAD encryption.

This fixes a crash when this causes us to try and map a NULL page,
at least with some platforms / DMA mapping configs.

Cc: stable@vger.kernel.org # v4.19+
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_buffer_mgr.c |   62 +++++++++++++++--------------------
 drivers/crypto/ccree/cc_buffer_mgr.h |    1 
 2 files changed, 28 insertions(+), 35 deletions(-)

--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -87,6 +87,8 @@ static unsigned int cc_get_sgl_nents(str
 {
 	unsigned int nents = 0;
 
+	*lbytes = 0;
+
 	while (nbytes && sg_list) {
 		nents++;
 		/* get the number of bytes in the last entry */
@@ -95,6 +97,7 @@ static unsigned int cc_get_sgl_nents(str
 				nbytes : sg_list->length;
 		sg_list = sg_next(sg_list);
 	}
+
 	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
 }
@@ -290,37 +293,25 @@ static int cc_map_sg(struct device *dev,
 		     unsigned int nbytes, int direction, u32 *nents,
 		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
-	if (sg_is_last(sg)) {
-		/* One entry only case -set to DLLI */
-		if (dma_map_sg(dev, sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_sg() single buffer failed\n");
-			return -ENOMEM;
-		}
-		dev_dbg(dev, "Mapped sg: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
-			&sg_dma_address(sg), sg_page(sg), sg_virt(sg),
-			sg->offset, sg->length);
-		*lbytes = nbytes;
-		*nents = 1;
-		*mapped_nents = 1;
-	} else {  /*sg_is_last*/
-		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
-		if (*nents > max_sg_nents) {
-			*nents = 0;
-			dev_err(dev, "Too many fragments. current %d max %d\n",
-				*nents, max_sg_nents);
-			return -ENOMEM;
-		}
-		/* In case of mmu the number of mapped nents might
-		 * be changed from the original sgl nents
-		 */
-		*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-		if (*mapped_nents == 0) {
-			*nents = 0;
-			dev_err(dev, "dma_map_sg() sg buffer failed\n");
-			return -ENOMEM;
-		}
+	int ret = 0;
+
+	*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
+	if (*nents > max_sg_nents) {
+		*nents = 0;
+		dev_err(dev, "Too many fragments. current %d max %d\n",
+			*nents, max_sg_nents);
+		return -ENOMEM;
 	}
 
+	ret = dma_map_sg(dev, sg, *nents, direction);
+	if (dma_mapping_error(dev, ret)) {
+		*nents = 0;
+		dev_err(dev, "dma_map_sg() sg buffer failed %d\n", ret);
+		return -ENOMEM;
+	}
+
+	*mapped_nents = ret;
+
 	return 0;
 }
 
@@ -555,11 +546,12 @@ void cc_unmap_aead_request(struct device
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		areq_ctx->assoclen, req->cryptlen);
 
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, areq_ctx->src.mapped_nents,
+		     DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst, sg_nents(req->dst),
+		dma_unmap_sg(dev, req->dst, areq_ctx->dst.mapped_nents,
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -881,7 +873,7 @@ static int cc_aead_chain_data(struct cc_
 					    &src_last_bytes);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (src_mapped_nents && (sg_index <= size_to_skip)) {
 		src_mapped_nents--;
 		offset -= areq_ctx->src_sgl->length;
 		sgl = sg_next(areq_ctx->src_sgl);
@@ -908,7 +900,7 @@ static int cc_aead_chain_data(struct cc_
 			size_for_map += crypto_aead_ivsize(tfm);
 
 		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
-			       &areq_ctx->dst.nents,
+			       &areq_ctx->dst.mapped_nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
 			       &dst_mapped_nents);
 		if (rc)
@@ -921,7 +913,7 @@ static int cc_aead_chain_data(struct cc_
 	offset = size_to_skip;
 
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (dst_mapped_nents && sg_index <= size_to_skip) {
 		dst_mapped_nents--;
 		offset -= areq_ctx->dst_sgl->length;
 		sgl = sg_next(areq_ctx->dst_sgl);
@@ -1123,7 +1115,7 @@ int cc_map_aead_request(struct cc_drvdat
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
-		       &areq_ctx->src.nents,
+		       &areq_ctx->src.mapped_nents,
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
 			LLI_MAX_NUM_OF_DATA_ENTRIES),
 		       &dummy, &mapped_nents);
--- a/drivers/crypto/ccree/cc_buffer_mgr.h
+++ b/drivers/crypto/ccree/cc_buffer_mgr.h
@@ -25,6 +25,7 @@ enum cc_sg_cpy_direct {
 
 struct cc_mlli {
 	cc_sram_addr_t sram_addr;
+	unsigned int mapped_nents;
 	unsigned int nents; //sg nents
 	unsigned int mlli_nents; //mlli nents might be different than the above
 };


