Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50921A09
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfEQOwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 10:52:06 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53323 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbfEQOwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 10:52:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 96C43471;
        Fri, 17 May 2019 10:52:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 10:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ADNlGK
        gQOBx47JJyTx8cbUceeqhp14Ewz77I6DsWPTw=; b=u2KnNH6QqXe6uASeYo6G1e
        D8gN0WMxHaLIL+1A5BgI6HbqE6P9Ylhk1Hr1HRVdL7akGJh/D4H08Nw0fnGwxSUl
        E2XFflgB/NvgD+LWT4GtqC9h+oWr41C7g9Y1B1mR/6KW1532PTNWc8p6rcFhWCgb
        /9CLyjdaK8fRw/TaUOCYc9E1HRDPoWYqbcX7mNNEWpET94wi0Ud+mAFEpgbz40+I
        yCuwPGzR99TOOYDdByZ594Zxq88/Mnd+XNSVyRrYLIr8GCdsxdbKTiMV3vrRCTL/
        GHP3Po2AS9dO7z3m3YIFCxhHbs1SQywzauxtlHlE5oo8WxDQJljKC8730VLyYIwg
        ==
X-ME-Sender: <xms:lMreXIJGtnzSOenbKUDS5sZrX7Kc5FVRgNohJRzGrk1qOJRTQHYHnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:lMreXF_9ascZyNgmBaWFS8icss0xg3bAZinlS4xukZheKoSGEHiSGA>
    <xmx:lMreXLC5uyTx_PhTvsF8oAk9-P7Dz-cHKZ4V9HNQWL_Q9oO4N1VYpQ>
    <xmx:lMreXIlPtbKqAz-uK86cMMdlMe6Lne-XDYTDb54mt6XnEXxngablVQ>
    <xmx:lcreXIgllqVqTpY0Q5hqc5KubIlmUQZfmHd1vGUZZ3lRE8S6iQytvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E759180066;
        Fri, 17 May 2019 10:52:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - zap entire sg on aead request unmap" failed to apply to 5.1-stable tree
To:     gilad@benyossef.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 16:52:01 +0200
Message-ID: <15581047210193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05c292afb0c0545c0cf084172db13e544eeb8f56 Mon Sep 17 00:00:00 2001
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Thu, 18 Apr 2019 16:39:01 +0300
Subject: [PATCH] crypto: ccree - zap entire sg on aead request unmap

We were trying to be clever zapping out of the cache only the required
length out of scatter list on AEAD request completion and getting it
wrong.

As Knuth said: "when in douby, use brute force". Zap the whole length of
the scatter list.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index fa625bdde3f9..09dceec7d828 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -517,9 +517,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = areq_ctx->hw_iv_size;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	u32 size_to_unmap = 0;
 
 	if (areq_ctx->mac_buf_dma_addr) {
 		dma_unmap_single(dev, areq_ctx->mac_buf_dma_addr,
@@ -576,19 +574,12 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		areq_ctx->assoclen, req->cryptlen);
-	size_to_unmap = areq_ctx->assoclen + req->cryptlen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
-		size_to_unmap += areq_ctx->req_authsize;
-	if (areq_ctx->is_gcm4543)
-		size_to_unmap += crypto_aead_ivsize(tfm);
 
-	dma_unmap_sg(dev, req->src, sg_nents_for_len(req->src, size_to_unmap),
-		     DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_BIDIRECTIONAL);
 	if (req->src != req->dst) {
 		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
 			sg_virt(req->dst));
-		dma_unmap_sg(dev, req->dst,
-			     sg_nents_for_len(req->dst, size_to_unmap),
+		dma_unmap_sg(dev, req->dst, sg_nents(req->dst),
 			     DMA_BIDIRECTIONAL);
 	}
 	if (drvdata->coherent &&

