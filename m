Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052002E3CD7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438486AbgL1OHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438133AbgL1OHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E979207B2;
        Mon, 28 Dec 2020 14:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164418;
        bh=Bs/ZR5rMdwoamsfCJATM59R0BP69ypLw8UgV7JKnTFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMqOq/9OoIIm2zWC58RjeImn70DUTJOjTtH+W0KhPomKjF8Tj4a4yakE/JdUJmptK
         rB/cTYFzIyhF1xyeaCOGaREioFeUjXfAkVUx8hYSpOQIFWHnwpo7o57XNFn2kfvzSw
         wFnXsbEtieUA3WHJnjGlHXIXKdMgzKiBE2dzcPEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/717] crypto: sun8i-ce - fix two error paths memory leak
Date:   Mon, 28 Dec 2020 13:42:50 +0100
Message-Id: <20201228125029.200071592@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 732b764099f651a088fd931d7b8121b6aa84e62e ]

This patch fixes the following smatch warnings:
drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c:412
sun8i_ce_hash_run() warn: possible memory leak of 'result'
Note: "buf" is leaked as well.

Furthermore, in case of ENOMEM, crypto_finalize_hash_request() was not
called which was an error.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index a94bf28f858a7..4c5a2c11d7141 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -262,13 +262,13 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	u32 common;
 	u64 byte_count;
 	__le32 *bf;
-	void *buf;
+	void *buf = NULL;
 	int j, i, todo;
 	int nbw = 0;
 	u64 fill, min_fill;
 	__be64 *bebits;
 	__le64 *lebits;
-	void *result;
+	void *result = NULL;
 	u64 bs;
 	int digestsize;
 	dma_addr_t addr_res, addr_pad;
@@ -285,13 +285,17 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	/* the padding could be up to two block. */
 	buf = kzalloc(bs * 2, GFP_KERNEL | GFP_DMA);
-	if (!buf)
-		return -ENOMEM;
+	if (!buf) {
+		err = -ENOMEM;
+		goto theend;
+	}
 	bf = (__le32 *)buf;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result)
-		return -ENOMEM;
+	if (!result) {
+		err = -ENOMEM;
+		goto theend;
+	}
 
 	flow = rctx->flow;
 	chan = &ce->chanlist[flow];
@@ -403,11 +407,11 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
-	kfree(buf);
 
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-	kfree(result);
 theend:
+	kfree(buf);
+	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
 	return 0;
 }
-- 
2.27.0



