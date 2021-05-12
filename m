Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8AF37C46D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhELPaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235137AbhELP0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A1F061A06;
        Wed, 12 May 2021 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832307;
        bh=+ZSX+yPtuGULCRIss4T0JsrpfGrp9F8Pn8qWcb3paSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igmP6KRiLxo1ROiKckXZysaViywbjDZfFVvdw9qTJWLSsloWIWZlaQKfmdRovJdwV
         BqkM3JcOah35K359htNMyvbD1hBMhSnibcm7OgWeYfzgS4EOr/RXMyB1H7gfTr1b8v
         vEyRZEcDD5ec3ZUouHOcJLF/sg8cD0cOfPEkpVIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/530] crypto: sun8i-ss - Fix memory leak of pad
Date:   Wed, 12 May 2021 16:45:37 +0200
Message-Id: <20210512144827.290049604@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 50274b01ac1689b1a3f6bc4b5b3dbf361a55dd3a ]

It appears there are several failure return paths that don't seem
to be free'ing pad. Fix these.

Addresses-Coverity: ("Resource leak")
Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 541bcd814384..756d5a783548 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -347,8 +347,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	bf = (__le32 *)pad;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result)
+	if (!result) {
+		kfree(pad);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < MAX_SG; i++) {
 		rctx->t_dst[i].addr = 0;
@@ -434,10 +436,9 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	dma_unmap_sg(ss->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
 	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
-	kfree(pad);
-
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
 theend:
+	kfree(pad);
 	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
 	return 0;
-- 
2.30.2



