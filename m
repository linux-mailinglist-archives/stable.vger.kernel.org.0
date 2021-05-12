Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9489237CC7A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239695AbhELQpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243230AbhELQg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0FF261CD4;
        Wed, 12 May 2021 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835287;
        bh=XZ4TaPHj27w0Zf2j9AhPFIRiGPgBYfqNZY3F62OMszI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4/YPHvWceDqXcKyQDlZckf7Z2QSkY4CrtkQG1SkP+pausL6Ti1DxWl64ZyjUB1OU
         jy2E1iEHAJdbZFuZ07r7UAkwtFnl3TTE50TsYNs7A5qzKoCkTUsPorwgAtT2AAWadn
         ZKhrp6GkC8wXCkQauaqnWdYwDFdDMVWybSS2HRh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 283/677] crypto: sun8i-ss - Fix memory leak of pad
Date:   Wed, 12 May 2021 16:45:29 +0200
Message-Id: <20210512144846.617601165@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 0b9aa24a5edd..64446b86c927 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -348,8 +348,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	bf = (__le32 *)pad;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result)
+	if (!result) {
+		kfree(pad);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < MAX_SG; i++) {
 		rctx->t_dst[i].addr = 0;
@@ -435,10 +437,9 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
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



