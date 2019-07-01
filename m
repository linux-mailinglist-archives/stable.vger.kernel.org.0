Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9152373B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbfETMXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388288AbfETMXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2767E216C4;
        Mon, 20 May 2019 12:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354980;
        bh=t4YPewq3D+jh2vmXPVGr1+GWoDZMuOUNpivSsGEzJiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmNTun6fbwayVKRLkEmOHBhPP4p5FzCzUl8RNj4WMqEI0E1DYW9oaSaxWzak0wFLi
         VMOnRm62ezAc874Y/E8r5HT6mB4TbH7rSkocHnHPHdISMTkBCyuo3HbZtv/RbcMb6T
         gv0QTuHFtPOlblBguHE9sQS6Axa9X8rTa5ESJSz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 044/105] crypto: ccree - remove special handling of chained sg
Date:   Mon, 20 May 2019 14:13:50 +0200
Message-Id: <20190520115250.067723383@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit c4b22bf51b815fb61a35a27fc847a88bc28ebb63 upstream.

We were handling chained scattergather lists with specialized code
needlessly as the regular sg APIs handle them just fine. The code
handling this also had an (unused) code path with a use-before-init
error, flagged by Coverity.

Remove all special handling of chained sg and leave their handling
to the regular sg APIs.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_buffer_mgr.c |   98 +++++++----------------------------
 1 file changed, 22 insertions(+), 76 deletions(-)

--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -83,24 +83,17 @@ static void cc_copy_mac(struct device *d
  */
 static unsigned int cc_get_sgl_nents(struct device *dev,
 				     struct scatterlist *sg_list,
-				     unsigned int nbytes, u32 *lbytes,
-				     bool *is_chained)
+				     unsigned int nbytes, u32 *lbytes)
 {
 	unsigned int nents = 0;
 
 	while (nbytes && sg_list) {
-		if (sg_list->length) {
-			nents++;
-			/* get the number of bytes in the last entry */
-			*lbytes = nbytes;
-			nbytes -= (sg_list->length > nbytes) ?
-					nbytes : sg_list->length;
-			sg_list = sg_next(sg_list);
-		} else {
-			sg_list = (struct scatterlist *)sg_page(sg_list);
-			if (is_chained)
-				*is_chained = true;
-		}
+		nents++;
+		/* get the number of bytes in the last entry */
+		*lbytes = nbytes;
+		nbytes -= (sg_list->length > nbytes) ?
+				nbytes : sg_list->length;
+		sg_list = sg_next(sg_list);
 	}
 	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
@@ -142,7 +135,7 @@ void cc_copy_sg_portion(struct device *d
 {
 	u32 nents, lbytes;
 
-	nents = cc_get_sgl_nents(dev, sg, end, &lbytes, NULL);
+	nents = cc_get_sgl_nents(dev, sg, end, &lbytes);
 	sg_copy_buffer(sg, nents, (void *)dest, (end - to_skip + 1), to_skip,
 		       (direct == CC_SG_TO_BUF));
 }
@@ -311,40 +304,10 @@ static void cc_add_sg_entry(struct devic
 	sgl_data->num_of_buffers++;
 }
 
-static int cc_dma_map_sg(struct device *dev, struct scatterlist *sg, u32 nents,
-			 enum dma_data_direction direction)
-{
-	u32 i, j;
-	struct scatterlist *l_sg = sg;
-
-	for (i = 0; i < nents; i++) {
-		if (!l_sg)
-			break;
-		if (dma_map_sg(dev, l_sg, 1, direction) != 1) {
-			dev_err(dev, "dma_map_page() sg buffer failed\n");
-			goto err;
-		}
-		l_sg = sg_next(l_sg);
-	}
-	return nents;
-
-err:
-	/* Restore mapped parts */
-	for (j = 0; j < i; j++) {
-		if (!sg)
-			break;
-		dma_unmap_sg(dev, sg, 1, direction);
-		sg = sg_next(sg);
-	}
-	return 0;
-}
-
 static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 		     unsigned int nbytes, int direction, u32 *nents,
 		     u32 max_sg_nents, u32 *lbytes, u32 *mapped_nents)
 {
-	bool is_chained = false;
-
 	if (sg_is_last(sg)) {
 		/* One entry only case -set to DLLI */
 		if (dma_map_sg(dev, sg, 1, direction) != 1) {
@@ -358,35 +321,21 @@ static int cc_map_sg(struct device *dev,
 		*nents = 1;
 		*mapped_nents = 1;
 	} else {  /*sg_is_last*/
-		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes,
-					  &is_chained);
+		*nents = cc_get_sgl_nents(dev, sg, nbytes, lbytes);
 		if (*nents > max_sg_nents) {
 			*nents = 0;
 			dev_err(dev, "Too many fragments. current %d max %d\n",
 				*nents, max_sg_nents);
 			return -ENOMEM;
 		}
-		if (!is_chained) {
-			/* In case of mmu the number of mapped nents might
-			 * be changed from the original sgl nents
-			 */
-			*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
-			if (*mapped_nents == 0) {
-				*nents = 0;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
-		} else {
-			/*In this case the driver maps entry by entry so it
-			 * must have the same nents before and after map
-			 */
-			*mapped_nents = cc_dma_map_sg(dev, sg, *nents,
-						      direction);
-			if (*mapped_nents != *nents) {
-				*nents = *mapped_nents;
-				dev_err(dev, "dma_map_sg() sg buffer failed\n");
-				return -ENOMEM;
-			}
+		/* In case of mmu the number of mapped nents might
+		 * be changed from the original sgl nents
+		 */
+		*mapped_nents = dma_map_sg(dev, sg, *nents, direction);
+		if (*mapped_nents == 0) {
+			*nents = 0;
+			dev_err(dev, "dma_map_sg() sg buffer failed\n");
+			return -ENOMEM;
 		}
 	}
 
@@ -571,7 +520,6 @@ void cc_unmap_aead_request(struct device
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 	u32 dummy;
-	bool chained;
 	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr) {
@@ -636,15 +584,14 @@ void cc_unmap_aead_request(struct device
 		size_to_unmap += crypto_aead_ivsize(tfm);
 
 	dma_unmap_sg(dev, req->src,
-		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
-				      &dummy, &chained),
+		     cc_get_sgl_nents(dev, req->src, size_to_unmap, &dummy),
 		     DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst,
 			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
-					      &dummy, &chained),
+					      &dummy),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
@@ -1022,7 +969,6 @@ static int cc_aead_chain_data(struct cc_
 	unsigned int size_for_map = req->assoclen + req->cryptlen;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	u32 sg_index = 0;
-	bool chained = false;
 	bool is_gcm4543 = areq_ctx->is_gcm4543;
 	u32 size_to_skip = req->assoclen;
 
@@ -1043,7 +989,7 @@ static int cc_aead_chain_data(struct cc_
 	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 			authsize : 0;
 	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
-					    &src_last_bytes, &chained);
+					    &src_last_bytes);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
 	while (sg_index <= size_to_skip) {
@@ -1085,7 +1031,7 @@ static int cc_aead_chain_data(struct cc_
 	}
 
 	dst_mapped_nents = cc_get_sgl_nents(dev, req->dst, size_for_map,
-					    &dst_last_bytes, &chained);
+					    &dst_last_bytes);
 	sg_index = areq_ctx->dst_sgl->length;
 	offset = size_to_skip;
 
@@ -1486,7 +1432,7 @@ int cc_map_hash_request_update(struct cc
 		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents =
-			cc_get_sgl_nents(dev, src, nbytes, &dummy, NULL);
+			cc_get_sgl_nents(dev, src, nbytes, &dummy);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;


