Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76D3157A6B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgBJNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgBJMhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:22 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BB4208C4;
        Mon, 10 Feb 2020 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338241;
        bh=tChVLO5t1hD/U1oJ87Zqw4YfkrlE6oR1y5L0VUdR7do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqL8/hB8XTWKpAywrmVNVT3krUVEE/mCaPtPIKRUFb+/druWRuF/niM2Kx6+6cuC/
         TFXIna46NellaFnT/wUSqc9z58AFkV7qYZpgYU638XKwhltuMAmZIZ6x2ItSBiotyc
         2B5zPbH3TwQMX9HF2K927WEy3rpWVcxYcdmqAax8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/309] mmc: sdhci-of-at91: fix memleak on clk_get failure
Date:   Mon, 10 Feb 2020 04:30:52 -0800
Message-Id: <20200210122415.373322202@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit a04184ce777b46e92c2b3c93c6dcb2754cb005e1 ]

sdhci_alloc_host() does its work not using managed infrastructure, so
needs explicit free on error path. Add it where needed.

Cc: <stable@vger.kernel.org>
Fixes: bb5f8ea4d514 ("mmc: sdhci-of-at91: introduce driver for the Atmel SDMMC")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/b2a44d5be2e06ff075f32477e466598bb0f07b36.1577961679.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-at91.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-at91.c b/drivers/mmc/host/sdhci-of-at91.c
index 0ae986c42bc82..9378d5dc86c81 100644
--- a/drivers/mmc/host/sdhci-of-at91.c
+++ b/drivers/mmc/host/sdhci-of-at91.c
@@ -324,19 +324,22 @@ static int sdhci_at91_probe(struct platform_device *pdev)
 	priv->mainck = devm_clk_get(&pdev->dev, "baseclk");
 	if (IS_ERR(priv->mainck)) {
 		dev_err(&pdev->dev, "failed to get baseclk\n");
-		return PTR_ERR(priv->mainck);
+		ret = PTR_ERR(priv->mainck);
+		goto sdhci_pltfm_free;
 	}
 
 	priv->hclock = devm_clk_get(&pdev->dev, "hclock");
 	if (IS_ERR(priv->hclock)) {
 		dev_err(&pdev->dev, "failed to get hclock\n");
-		return PTR_ERR(priv->hclock);
+		ret = PTR_ERR(priv->hclock);
+		goto sdhci_pltfm_free;
 	}
 
 	priv->gck = devm_clk_get(&pdev->dev, "multclk");
 	if (IS_ERR(priv->gck)) {
 		dev_err(&pdev->dev, "failed to get multclk\n");
-		return PTR_ERR(priv->gck);
+		ret = PTR_ERR(priv->gck);
+		goto sdhci_pltfm_free;
 	}
 
 	ret = sdhci_at91_set_clks_presets(&pdev->dev);
-- 
2.20.1



