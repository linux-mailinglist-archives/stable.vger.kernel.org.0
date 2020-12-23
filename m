Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF12E1373
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgLWCaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbgLWCZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968A82312E;
        Wed, 23 Dec 2020 02:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690296;
        bh=OXgRtkIRsH66civE9i6UM8dPNLRzdDaX3Z6b5P29/IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA6x4ZgLcFm/N/8vRe825N0+0MGNTO2hez68kdoB7CkD9HnWV92v7A+HhD560QjhH
         MmS21n5uAmcFEhfWTZQT2YMKID6nF1vsmXbGIPDk0UMAGyKcafHLW/lE/QXHOzHm7j
         poupatbMkHIBQ6uc3+ZH0ceQ6Bjk60Vg5LyDA33DUSxaq2DaIRW1/vI7PYig5yvSKN
         OkL/K5pM84SCKEbJht4na/nkhdbYNrP6sfUp2KLd7i3KNmdjWnseh8v9krjIrAhiaa
         GbhsEEu3HV+0FvphXNOcjKMnLblztsOGOp536Xos0ybnQvJCo4b00O8IMy7XOlHZX+
         4h77PY7MHF28Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 32/48] crypto: qce - Fix SHA result buffer corruption issues
Date:   Tue, 22 Dec 2020 21:24:00 -0500
Message-Id: <20201223022417.2794032-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 47e114ac09d01..5502a89c4b01e 100644
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

