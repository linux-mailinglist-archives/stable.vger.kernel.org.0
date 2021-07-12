Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E623C483E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhGLGhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235969AbhGLGfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E82B6101E;
        Mon, 12 Jul 2021 06:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071577;
        bh=6qvfVHz8Ivbu+S8FtkH8bJH6LL/dj1fkRbuXihqrtqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5ECzWjq600kR8a2fadVWyPKNhCr5wdfL3Ink/DUbtxq36udEQJ+0f/PiJzS6tH+n
         PlATGUpPxMUSUoBWWGM/M/RxovIRoEmlqttzxBMXdX3zdbcsutjBWBKjrfMzHojAj7
         sJYqQ6iurN1gkY5I7ljPXsoK+V+LSwJvQKIx420A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/593] crypto: qce: skcipher: Fix incorrect sg count for dma transfers
Date:   Mon, 12 Jul 2021 08:04:49 +0200
Message-Id: <20210712060857.335221127@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a2d3da0ad95f..5a6559131eac 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -71,7 +71,7 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	struct scatterlist *sg;
 	bool diff_dst;
 	gfp_t gfp;
-	int ret;
+	int dst_nents, src_nents, ret;
 
 	rctx->iv = req->iv;
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
@@ -122,21 +122,22 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
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



