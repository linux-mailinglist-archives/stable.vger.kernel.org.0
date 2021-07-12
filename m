Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8103C4D41
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbhGLHM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240846AbhGLHIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CCA61245;
        Mon, 12 Jul 2021 07:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073506;
        bh=bqZwh+M0iKXU3uZ7K0nQ6XpjpxVPA50AEV6Jo6bsYaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvNMk7cYF2H6Sloy8Cv4SFdD97+xp6lHRehwhUAaLhyPUIH30Z1ZeBETN5Qaal/03
         opKLrMS9VLp+D11xc6SqeD+zPxXYQDZuIW0RExXARyVoaubPx3iK6ZYg01iAAf76A7
         vfRp652/m3H2Unxrvwd1o/YsrfYcy1l5Mz85xq00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 266/700] crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
Date:   Mon, 12 Jul 2021 08:05:49 +0200
Message-Id: <20210712061004.510871392@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 4c0716ee1d973f6504d13f0e8d4d10350c85ad37 ]

The sa_dma_init() function doesn't release the requested dma channels
on all failure paths. Any failure in this function also ends up
leaking the dma pool created in sa_init_mem() in the sa_ul_probe()
function. Fix all of these issues.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Tero Kristo <kristo@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index b0f0502a5bb0..efde3e96f62d 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2275,9 +2275,9 @@ static int sa_dma_init(struct sa_crypto_data *dd)
 
 	dd->dma_rx2 = dma_request_chan(dd->dev, "rx2");
 	if (IS_ERR(dd->dma_rx2)) {
-		dma_release_channel(dd->dma_rx1);
-		return dev_err_probe(dd->dev, PTR_ERR(dd->dma_rx2),
-				     "Unable to request rx2 DMA channel\n");
+		ret = dev_err_probe(dd->dev, PTR_ERR(dd->dma_rx2),
+				    "Unable to request rx2 DMA channel\n");
+		goto err_dma_rx2;
 	}
 
 	dd->dma_tx = dma_request_chan(dd->dev, "tx");
@@ -2298,28 +2298,31 @@ static int sa_dma_init(struct sa_crypto_data *dd)
 	if (ret) {
 		dev_err(dd->dev, "can't configure IN dmaengine slave: %d\n",
 			ret);
-		return ret;
+		goto err_dma_config;
 	}
 
 	ret = dmaengine_slave_config(dd->dma_rx2, &cfg);
 	if (ret) {
 		dev_err(dd->dev, "can't configure IN dmaengine slave: %d\n",
 			ret);
-		return ret;
+		goto err_dma_config;
 	}
 
 	ret = dmaengine_slave_config(dd->dma_tx, &cfg);
 	if (ret) {
 		dev_err(dd->dev, "can't configure OUT dmaengine slave: %d\n",
 			ret);
-		return ret;
+		goto err_dma_config;
 	}
 
 	return 0;
 
+err_dma_config:
+	dma_release_channel(dd->dma_tx);
 err_dma_tx:
-	dma_release_channel(dd->dma_rx1);
 	dma_release_channel(dd->dma_rx2);
+err_dma_rx2:
+	dma_release_channel(dd->dma_rx1);
 
 	return ret;
 }
@@ -2364,7 +2367,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	sa_init_mem(dev_data);
 	ret = sa_dma_init(dev_data);
 	if (ret)
-		goto disable_pm_runtime;
+		goto destroy_dma_pool;
 
 	spin_lock_init(&dev_data->scid_lock);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -2394,9 +2397,9 @@ release_dma:
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
 
+destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
-disable_pm_runtime:
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.30.2



