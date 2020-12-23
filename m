Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445772E1428
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgLWCWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgLWCWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58D1A2333F;
        Wed, 23 Dec 2020 02:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690128;
        bh=qgR2+42IlfG0tj6SzNlTxnZI4Uj/FSO1TGXLktEoijA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGSGWMuB0si4Dhp3G9/KFCvzaLI8xA2AgGATR/rS3xyAtS0m0gtf5UYXzUzKi9BeL
         Z+RYKzJgLnTNukfwklDMFne4N/+KAX5rcFcSwb8qeNgyzf24OLg96SwUAIdyb4aY00
         2XsRW7SZf3AAoPAwX5C+e7aM1DnddIGd6mIA830q/Zeg/OUWzlB0mBia6limz9tvNl
         MAMGyIESHGjG5VPjBxbzfZAEv8Vx2mXIThjGAkTMKslJ3n1mPmsSXQVY5XsBJi/D/v
         6LbJxxzdhB2fZ4KMro4ajhvtsFrPIdEvi+HAGbYNBCUk8HrO2wsQjdfFntfX0tcmX4
         DBB8ifJmpCLew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/87] crypto: qce - Fix SHA result buffer corruption issues
Date:   Tue, 22 Dec 2020 21:20:28 -0500
Message-Id: <20201223022103.2792705-52-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

[ Upstream commit 1148a9654b5a69611d33e14719251c6ec20f5f2c ]

Partial hash was being copied into the final result buffer without the
entire message block processed. Depending on how the end user processes
this result buffer, errors vary from result buffer corruption to result
buffer poisoing. Fix this issue by ensuring that only the final hash value
is copied into the result buffer.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index d8a5db11b7ea1..49e29cb6d5b8d 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -55,7 +55,7 @@ static void qce_ahash_done(void *data)
 	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 
 	memcpy(rctx->digest, result->auth_iv, digestsize);
-	if (req->result)
+	if (req->result && rctx->last_blk)
 		memcpy(req->result, result->auth_iv, digestsize);
 
 	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
-- 
2.27.0

