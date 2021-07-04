Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F273BB02C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhGDXHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230309AbhGDXHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45F8F6135D;
        Sun,  4 Jul 2021 23:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439907;
        bh=sFpWLh59XEW/L2ThVMuQX65C/0NRjUggW0zKEKMo3Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juk1reujd792tcqPvRS9VhGFrCnU24N63wSXwr0+BHHMiKC4NBgqjTtn796VyTk7R
         ckjvPmwRFWvVf7U7eDu3WBWZTfNE1Z008xJKaO1KZS2KItdGOL60cG8MbEFvvZQd1d
         RTsMk5WFN7XUBBe4AtXnYn0izoqPtnyJWOoM4gX+BHb8zfzNMmjQJMxNbpsPJVHR4H
         GMEihOOrJ0HxElmJWGh+rzpT2968HebPBsgRQUt1IpfRNBaX45R64gRdH8l9ZWSHkM
         gF+y1Isq9/vvYWp9EJ2kj68oOwxkRRmyK9DN6ktm2Z8w6Vb72x0SonlrmnjdTUwwqp
         BKDbewR8FWFVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 33/85] crypto: qce: skcipher: Fix incorrect sg count for dma transfers
Date:   Sun,  4 Jul 2021 19:03:28 -0400
Message-Id: <20210704230420.1488358-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

[ Upstream commit 1339a7c3ba05137a2d2fe75f602311bbfc6fab33 ]

Use the sg count returned by dma_map_sg to call into
dmaengine_prep_slave_sg rather than using the original sg count. dma_map_sg
can merge consecutive sglist entries, thus making the original sg count
wrong. This is a fix for memory coruption issues observed while testing
encryption/decryption of large messages using libkcapi framework.

Patch has been tested further by running full suite of tcrypt.ko tests
including fuzz tests.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/skcipher.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index c0a0d8c4fce1..259418479227 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -72,7 +72,7 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	struct scatterlist *sg;
 	bool diff_dst;
 	gfp_t gfp;
-	int ret;
+	int dst_nents, src_nents, ret;
 
 	rctx->iv = req->iv;
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
@@ -123,21 +123,22 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	sg_mark_end(sg);
 	rctx->dst_sg = rctx->dst_tbl.sgl;
 
-	ret = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
-	if (ret < 0)
+	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	if (dst_nents < 0)
 		goto error_free;
 
 	if (diff_dst) {
-		ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
-		if (ret < 0)
+		src_nents = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		if (src_nents < 0)
 			goto error_unmap_dst;
 		rctx->src_sg = req->src;
 	} else {
 		rctx->src_sg = rctx->dst_sg;
+		src_nents = dst_nents - 1;
 	}
 
-	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
-			       rctx->dst_sg, rctx->dst_nents,
+	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents,
+			       rctx->dst_sg, dst_nents,
 			       qce_skcipher_done, async_req);
 	if (ret)
 		goto error_unmap_src;
-- 
2.30.2

