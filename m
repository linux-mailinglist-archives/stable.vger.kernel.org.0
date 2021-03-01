Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF6328AEB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbhCASZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238483AbhCASTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAEE2651EA;
        Mon,  1 Mar 2021 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619172;
        bh=tZbi8YwY+uE93scbvSaEFJhbMFKnrIymQU5w0/aaGIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGA+2EHb4c14NRvK/8MUM2N8TGmea9nakVToXUCGgmQDZgoklWrP4+vILrCUlLRv4
         0/Sr6vyIKMdvKsqV+ioR0JXw6sftTb+tvxrX3DiDyWPJz6bNjtnD8Q8jCaHU21Kd+7
         UMCXYU5uIySy3UHfsoo+sN0B4HGDhOuh+tx9wW3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/663] mmc: owl-mmc: Fix a resource leak in an error handling path and in the remove function
Date:   Mon,  1 Mar 2021 17:09:37 +0100
Message-Id: <20210301161158.130834396@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5d15cbf63515c6183d2ed7c9dd0586b4db23ffb1 ]

'dma_request_chan()' calls should be balanced by a corresponding
'dma_release_channel()' call.

Add the missing call both in the error handling path of the probe function
and in the remove function.

Fixes: ff65ffe46d28 ("mmc: Add Actions Semi Owl SoCs SD/MMC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201209194202.54099-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/owl-mmc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/owl-mmc.c b/drivers/mmc/host/owl-mmc.c
index ccf214a89eda9..3d4abf175b1d8 100644
--- a/drivers/mmc/host/owl-mmc.c
+++ b/drivers/mmc/host/owl-mmc.c
@@ -641,7 +641,7 @@ static int owl_mmc_probe(struct platform_device *pdev)
 	owl_host->irq = platform_get_irq(pdev, 0);
 	if (owl_host->irq < 0) {
 		ret = -EINVAL;
-		goto err_free_host;
+		goto err_release_channel;
 	}
 
 	ret = devm_request_irq(&pdev->dev, owl_host->irq, owl_irq_handler,
@@ -649,19 +649,21 @@ static int owl_mmc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n",
 			owl_host->irq);
-		goto err_free_host;
+		goto err_release_channel;
 	}
 
 	ret = mmc_add_host(mmc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add host\n");
-		goto err_free_host;
+		goto err_release_channel;
 	}
 
 	dev_dbg(&pdev->dev, "Owl MMC Controller Initialized\n");
 
 	return 0;
 
+err_release_channel:
+	dma_release_channel(owl_host->dma);
 err_free_host:
 	mmc_free_host(mmc);
 
@@ -675,6 +677,7 @@ static int owl_mmc_remove(struct platform_device *pdev)
 
 	mmc_remove_host(mmc);
 	disable_irq(owl_host->irq);
+	dma_release_channel(owl_host->dma);
 	mmc_free_host(mmc);
 
 	return 0;
-- 
2.27.0



