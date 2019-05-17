Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31921A0B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfEQOwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 10:52:16 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:36387 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728396AbfEQOwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 10:52:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1464C472;
        Fri, 17 May 2019 10:52:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 10:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jU7qfu
        h9M54Rn1QikplwsvAyysn+LbiX92b5wTSP0H8=; b=Sip0hg/ttwJdbBRey0GmTn
        dHPk6vo2oMRkhIzRTlX8FV56tDEQs7JUoFgBAVDniKjW1fSSMBc18kYk7dG6D+Mm
        TbkVJ+IXq02FJXw2gQI7qVggUAMN4aGBRZedjPkfqtuBMAIEqbk37ekoIb9vfwgl
        V716vO3ADkzdEaj+fMP4wAFqja+bgU1ET9UScQlX9bw0J6Uugrose1r0sIa//SPW
        iq+g/II4aV0TkIaIAvGMkVnJBJc509xXfoWHS9QYo1QH71l9b3aWP96flsNmyghK
        u7B/8hDsmr9PnpAMaZ88XAisUGbGMINgDIO7pLdIwL1fmAPX2zv9u+zt+lQzzMXQ
        ==
X-ME-Sender: <xms:nsreXHsP72HoHUoT9WlIIwlkEb8Jv4Vt3QjMQ9A_nhIvb4hgD2XEWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:nsreXCgkAAPop_q7gafDenHOr5Jx46efQpWzc4vYOHxyLQPwECStGw>
    <xmx:nsreXPugFXqEto_uUCkt3tk4anrXIl2r-DJPM8ueqSOofNT23izUWw>
    <xmx:nsreXN_vKPWPsjOAQHeQjIM0wZsbHZO8V1nRcer65vo0XRNsrwoBZw>
    <xmx:nsreXN9RKbZ8jm2hlnQ98zJnKHocy4lQeYImoB817rJ2odpkG_EuEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F166C103D2;
        Fri, 17 May 2019 10:52:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccree - zap entire sg on aead request unmap" failed to apply to 4.19-stable tree
To:     gilad@benyossef.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 16:52:03 +0200
Message-ID: <155810472359211@kroah.com>
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

