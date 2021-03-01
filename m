Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3275332900E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbhCAUCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242102AbhCATux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D9C2650E9;
        Mon,  1 Mar 2021 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621129;
        bh=RKSdKI+qwVyvay4Xe+XbOhDTudYl3rSKU5nbfBq22Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3mWLj+YjIK1RTp5iQ36tHuPKLBdLaffymk3HhYjtvtQDRxKymP+gxedmxIXW6KfD
         tTP8x/JAiPtU7kfepdfD3tzvIhXsZ/tbGG7nDBea/G5f3qUlKJkSapnf6AvgMJSfOu
         axMvyG6jNY8X9oyHXWNGfsXtDUl8Kmo805gAMa/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 396/775] mmc: owl-mmc: Fix a resource leak in an error handling path and in the remove function
Date:   Mon,  1 Mar 2021 17:09:24 +0100
Message-Id: <20210301161221.162699328@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 53b81582f1afe..5490962dc8e53 100644
--- a/drivers/mmc/host/owl-mmc.c
+++ b/drivers/mmc/host/owl-mmc.c
@@ -640,7 +640,7 @@ static int owl_mmc_probe(struct platform_device *pdev)
 	owl_host->irq = platform_get_irq(pdev, 0);
 	if (owl_host->irq < 0) {
 		ret = -EINVAL;
-		goto err_free_host;
+		goto err_release_channel;
 	}
 
 	ret = devm_request_irq(&pdev->dev, owl_host->irq, owl_irq_handler,
@@ -648,19 +648,21 @@ static int owl_mmc_probe(struct platform_device *pdev)
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
 
@@ -674,6 +676,7 @@ static int owl_mmc_remove(struct platform_device *pdev)
 
 	mmc_remove_host(mmc);
 	disable_irq(owl_host->irq);
+	dma_release_channel(owl_host->dma);
 	mmc_free_host(mmc);
 
 	return 0;
-- 
2.27.0



