Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C451A9BBE
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896751AbgDOLHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:07:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44791 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896746AbgDOLHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:07:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5069D5C0145;
        Wed, 15 Apr 2020 07:06:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vx3w0/
        XoK6VstiaxUD8OU+wvWZB2bkT3YZgRXBoMd+E=; b=b0I6xO+VwfoqcDyJ7JjF+a
        fvKj8yizvyTMMPSbwQSMEOe/znv9Cp7gmeU7Iygonhh1pTRv6DLqzN1hj/kcxlHH
        uNWJXzQlK1cJJRPHkP0th0ECvbbfXKTb4YvV6Fn+3y8hGNIPfPbEQRkNymtoqHm8
        pnYBF0nMKMEZ0rSkoPBa7+cBLA+RzDQ+usSBG1ZgWFUt0WXFID9ganSrHMIMjwoX
        JuRdh+CS94KM75YBzx90VjeYln4qooggGiH2jDVrbtHGz86eZPtJqxKkq+bsqRKd
        3co4/LIeDoouvWR64YKq0F9QYsTL66GbefRrqQ2XM++TkT6H6YNWX8bZFydBV8BA
        ==
X-ME-Sender: <xms:yeqWXuL8P4aiEg0Z4PLnk8DXMmaRn3IxxSZZ9ZeO7N0WeX6HipXIYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepkeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:yeqWXjn-oxWQ90J-82q_93Y2_Kn1kVv2LKZlYyGpuJ5s-1rmuO_eyQ>
    <xmx:yeqWXuovF3YEwa0674QQsKFD5lOiNH49_tNCTYe6mR5SCEY-q15_PQ>
    <xmx:yeqWXlA76J6lWMo26cRPD87CaMTJH19VFXd4U044ilvFbFEjD444nQ>
    <xmx:yeqWXk2f9wQlvZm3sKb6PCt5OvJuaR6NalXA9h0urnRf2z6TjLR00Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B28D03280063;
        Wed, 15 Apr 2020 07:06:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - protect against empty or NULL scatterlists" failed to apply to 4.19-stable tree
To:     gilad@benyossef.com, geert+renesas@glider.be,
        herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:06:47 +0200
Message-ID: <1586948807146181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce0fc6db38decf0d2919bfe783de6d6b76e421a9 Mon Sep 17 00:00:00 2001
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Wed, 29 Jan 2020 16:37:54 +0200
Subject: [PATCH] crypto: ccree - protect against empty or NULL scatterlists

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

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index a72586eccd81..b938ceae7ae7 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -87,6 +87,8 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 {
 	unsigned int nents = 0;
 
+	*lbytes = 0;
+
 	while (nbytes && sg_list) {
 		nents++;
 		/* get the number of bytes in the last entry */
@@ -95,6 +97,7 @@ static unsigned int cc_get_sgl_nents(struct device *dev,
 				nbytes : sg_list->length;
 		sg_list = sg_next(sg_list);
 	}
+
 	dev_dbg(dev, "nents %d last bytes %d\n", nents, *lbytes);
 	return nents;
 }
@@ -290,37 +293,25 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
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
 
@@ -555,11 +546,12 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
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
@@ -881,7 +873,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 					    &src_last_bytes);
 	sg_index = areq_ctx->src_sgl->length;
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (src_mapped_nents && (sg_index <= size_to_skip)) {
 		src_mapped_nents--;
 		offset -= areq_ctx->src_sgl->length;
 		sgl = sg_next(areq_ctx->src_sgl);
@@ -908,7 +900,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 			size_for_map += crypto_aead_ivsize(tfm);
 
 		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
-			       &areq_ctx->dst.nents,
+			       &areq_ctx->dst.mapped_nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
 			       &dst_mapped_nents);
 		if (rc)
@@ -921,7 +913,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 	offset = size_to_skip;
 
 	//check where the data starts
-	while (sg_index <= size_to_skip) {
+	while (dst_mapped_nents && sg_index <= size_to_skip) {
 		dst_mapped_nents--;
 		offset -= areq_ctx->dst_sgl->length;
 		sgl = sg_next(areq_ctx->dst_sgl);
@@ -1123,7 +1115,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
-		       &areq_ctx->src.nents,
+		       &areq_ctx->src.mapped_nents,
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
 			LLI_MAX_NUM_OF_DATA_ENTRIES),
 		       &dummy, &mapped_nents);
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.h b/drivers/crypto/ccree/cc_buffer_mgr.h
index af434872c6ff..827b6cb1236e 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.h
+++ b/drivers/crypto/ccree/cc_buffer_mgr.h
@@ -25,6 +25,7 @@ enum cc_sg_cpy_direct {
 
 struct cc_mlli {
 	cc_sram_addr_t sram_addr;
+	unsigned int mapped_nents;
 	unsigned int nents; //sg nents
 	unsigned int mlli_nents; //mlli nents might be different than the above
 };

