Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE926F387
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbgIRDHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgIRCDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B76F2311D;
        Fri, 18 Sep 2020 02:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394627;
        bh=1NFky1aHyOFCcv+zMkvnVftWgULXvQQIBmoB9HF5QTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIlBHPVRQXocLJJR6WPzHWTNdApfIi5S0mGPmc5/0S9zT3XlepNon5aCKipb6ms6q
         jlBvz8zLt/tChbzdLQdbGTfMFGwv8xn0wTHwAHgCsOqV8jqTCVBuGht/oiO2BWVPnJ
         0wHFQHqwPSWlfYgwpMUMdMKZTFCmQJjrwxE3eLb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 128/330] crypto: chelsio - This fixes the kernel panic which occurs during a libkcapi test
Date:   Thu, 17 Sep 2020 21:57:48 -0400
Message-Id: <20200918020110.2063155-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 9195189e00a7db55e7d448cee973cae87c5a3c71 ]

The libkcapi test which causes kernel panic is
aead asynchronous vmsplice multiple test.

./bin/kcapi  -v -d 4 -x 10   -c "ccm(aes)"
-q 4edb58e8d5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d
-t a7877c99 -n 674742abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4
-a fb7bc304a3909e66e2e0c5ef952712dd884ce3e7324171369f2c5db1adc48c7d

This patch avoids dma_mapping of a zero length sg which causes the panic,
by using sg_nents_for_len which maps only upto a specific length

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index fe2eadc0ce83d..2d30ed5a2674b 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2480,8 +2480,9 @@ int chcr_aead_dma_map(struct device *dev,
 	else
 		reqctx->b0_dma = 0;
 	if (req->src == req->dst) {
-		error = dma_map_sg(dev, req->src, sg_nents(req->src),
-				   DMA_BIDIRECTIONAL);
+		error = dma_map_sg(dev, req->src,
+				sg_nents_for_len(req->src, dst_size),
+					DMA_BIDIRECTIONAL);
 		if (!error)
 			goto err;
 	} else {
-- 
2.25.1

