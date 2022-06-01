Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B404A53A6E1
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353875AbiFAN4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353874AbiFANz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6686A93475;
        Wed,  1 Jun 2022 06:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DFBF615E6;
        Wed,  1 Jun 2022 13:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A263BC3411E;
        Wed,  1 Jun 2022 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091680;
        bh=VZt2nOdWMwFzurUHIONWPqfBKwllbRhQspuztDZ+FDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mygib4T1yeePQ4UjO3dIiTxg/WRjDQVC1UP9wjF0Yz9za9na5StX+7j5SmqIo5nE7
         HycWrC6fJC7MUWN55zVZ09KF6sqioSn5/F2DhqbrrTBB2kVJSIq1Nyo+7a7EbqipgZ
         /LPHPvHESh6EDbPVJ8zaJ8VD/KsiOu6XfB75H8fxv+DoWPOhLTcmR93nvaagZ9+r7d
         fGr96X7fqnywe3X5sEKVlp26d+39+tLTvu77AJRtXLt2E4zBYqTS/Fp48RkW6UedK0
         97HOs+TYJ0uD/r+I4Arsz8KdHm3Mw+Sw1tQXOJ1uhdp3Xe7XQAQMpkKHZKTYX1ntoV
         gz+8mkOvooxgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 10/48] crypto: ccree - use fine grained DMA mapping dir
Date:   Wed,  1 Jun 2022 09:53:43 -0400
Message-Id: <20220601135421.2003328-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit a260436c98171cd825955a84a7f6e62bc8f4f00d ]

Use a fine grained specification of DMA mapping directions
in certain cases, allowing both a more optimized operation
as well as shushing out a harmless, though persky
dma-debug warning.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 11e0278c8631..6140e4927322 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -356,12 +356,14 @@ void cc_unmap_cipher_request(struct device *dev, void *ctx,
 			      req_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
-	dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
-
 	if (src != dst) {
-		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_FROM_DEVICE);
 		dev_dbg(dev, "Unmapped req->dst=%pK\n", sg_virt(dst));
+		dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
+	} else {
+		dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
+		dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
 	}
 }
 
@@ -377,6 +379,7 @@ int cc_map_cipher_request(struct cc_drvdata *drvdata, void *ctx,
 	u32 dummy = 0;
 	int rc = 0;
 	u32 mapped_nents = 0;
+	int src_direction = (src != dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL);
 
 	req_ctx->dma_buf_type = CC_DMA_BUF_DLLI;
 	mlli_params->curr_pool = NULL;
@@ -399,7 +402,7 @@ int cc_map_cipher_request(struct cc_drvdata *drvdata, void *ctx,
 	}
 
 	/* Map the src SGL */
-	rc = cc_map_sg(dev, src, nbytes, DMA_BIDIRECTIONAL, &req_ctx->in_nents,
+	rc = cc_map_sg(dev, src, nbytes, src_direction, &req_ctx->in_nents,
 		       LLI_MAX_NUM_OF_DATA_ENTRIES, &dummy, &mapped_nents);
 	if (rc)
 		goto cipher_exit;
@@ -416,7 +419,7 @@ int cc_map_cipher_request(struct cc_drvdata *drvdata, void *ctx,
 		}
 	} else {
 		/* Map the dst sg */
-		rc = cc_map_sg(dev, dst, nbytes, DMA_BIDIRECTIONAL,
+		rc = cc_map_sg(dev, dst, nbytes, DMA_FROM_DEVICE,
 			       &req_ctx->out_nents, LLI_MAX_NUM_OF_DATA_ENTRIES,
 			       &dummy, &mapped_nents);
 		if (rc)
@@ -456,6 +459,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
+	int src_direction = (req->src != req->dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL);
 
 	if (areq_ctx->mac_buf_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
@@ -514,13 +518,11 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		areq_ctx->assoclen, req->cryptlen);
 
-	dma_unmap_sg(dev, req->src, areq_ctx->src.mapped_nents,
-		     DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, areq_ctx->src.mapped_nents, src_direction);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst, areq_ctx->dst.mapped_nents,
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev, req->dst, areq_ctx->dst.mapped_nents, DMA_FROM_DEVICE);
 	}
 	if (drvdata->coherent &&
 	    areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT &&
@@ -843,7 +845,7 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 		else
 			size_for_map -= authsize;
 
-		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_BIDIRECTIONAL,
+		rc = cc_map_sg(dev, req->dst, size_for_map, DMA_FROM_DEVICE,
 			       &areq_ctx->dst.mapped_nents,
 			       LLI_MAX_NUM_OF_DATA_ENTRIES, &dst_last_bytes,
 			       &dst_mapped_nents);
@@ -1056,7 +1058,8 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		size_to_map += authsize;
 	}
 
-	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
+	rc = cc_map_sg(dev, req->src, size_to_map,
+		       (req->src != req->dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL),
 		       &areq_ctx->src.mapped_nents,
 		       (LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES +
 			LLI_MAX_NUM_OF_DATA_ENTRIES),
-- 
2.35.1

