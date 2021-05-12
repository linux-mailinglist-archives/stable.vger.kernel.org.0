Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0A37C41A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhELP2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhELPWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A8661963;
        Wed, 12 May 2021 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832146;
        bh=VdG7MfJyAOQlxsgl3SvZay79iRjHCdkdkkJTjITfmNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oc/zHxjfhI6079Es7N/RPjtBhgfb2/GuDi1tPX8sgKO2+2RBkRZrCREt6UBpwQSf3
         J+uNN6MvMa+y5N8H2wgVJxYpVDd1Sfa37r7nUKwWL8T1GDKbcbm89GP5kpUIJIbsTB
         uCfHsQqoHwEXnSR+PCHg21MGxu5OHajq1qhJcLh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/530] crypto: sun8i-ss - Fix memory leak of object d when dma_iv fails to map
Date:   Wed, 12 May 2021 16:44:31 +0200
Message-Id: <20210512144825.130747288@linuxfoundation.org>
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

[ Upstream commit 98b5ef3e97b16eaeeedb936f8bda3594ff84a70e ]

In the case where the dma_iv mapping fails, the return error path leaks
the memory allocated to object d.  Fix this by adding a new error return
label and jumping to this to ensure d is free'd before the return.

Addresses-Coverity: ("Resource leak")
Fixes: ac2614d721de ("crypto: sun8i-ss - Add support for the PRNG")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
index 08a1473b2145..3191527928e4 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
@@ -103,7 +103,8 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	dma_iv = dma_map_single(ss->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
 	if (dma_mapping_error(ss->dev, dma_iv)) {
 		dev_err(ss->dev, "Cannot DMA MAP IV\n");
-		return -EFAULT;
+		err = -EFAULT;
+		goto err_free;
 	}
 
 	dma_dst = dma_map_single(ss->dev, d, todo, DMA_FROM_DEVICE);
@@ -167,6 +168,7 @@ err_iv:
 		memcpy(ctx->seed, d + dlen, ctx->slen);
 	}
 	memzero_explicit(d, todo);
+err_free:
 	kfree(d);
 
 	return err;
-- 
2.30.2



