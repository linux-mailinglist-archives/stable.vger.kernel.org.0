Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E25F23305
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbfETLui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:50:38 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:43982 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730606AbfETLui (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 07:50:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8030015AB;
        Mon, 20 May 2019 04:50:37 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7BE13F5AF;
        Mon, 20 May 2019 04:50:35 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     gregkh@linuxfoundation.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [STABLE PATCH 1/2] crypto: ccree: zap entire sg on aead request unmap
Date:   Mon, 20 May 2019 14:50:23 +0300
Message-Id: <20190520115025.16457-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115025.16457-1-gilad@benyossef.com>
References: <20190520115025.16457-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were trying to be clever zapping out of the cache only the required
length out of scatter list on AEAD request completion and getting it
wrong.

As Knuth said: "when in douby, use brute force". Zap the whole length of
the scatter list.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 0ee1c52da0a4..0774bf54fcab 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -568,11 +568,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	u32 dummy;
-	bool chained;
-	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
@@ -629,22 +625,12 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		req->assoclen, req->cryptlen);
-	size_to_unmap = req->assoclen + req->cryptlen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
-		size_to_unmap += areq_ctx->req_authsize;
-	if (areq_ctx->is_gcm4543)
-		size_to_unmap += crypto_aead_ivsize(tfm);
 
-	dma_unmap_sg(dev, req->src,
-		     cc_get_sgl_nents(dev, req->src, size_to_unmap,
-				      &dummy, &chained),
-		     DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst,
-			     cc_get_sgl_nents(dev, req->dst, size_to_unmap,
-					      &dummy, &chained),
+		dma_unmap_sg(dev, req->dst, sg_nents(req->dst),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&
-- 
2.21.0

