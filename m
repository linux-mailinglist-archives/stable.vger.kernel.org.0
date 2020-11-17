Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E752B629B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgKQNaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbgKQNaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 313C420781;
        Tue, 17 Nov 2020 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619809;
        bh=Em5WUFkmAWqEgK4Bmo8LEscV7lul/VN0uP1DAaO++Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rSvqtxw8/IpkvcfqZF1c3kxiv76gxJDc/P4reYG3NgQnAhIIsBPls/wJLsHO0Wb3
         aXDrgLSUsjYq0cY1bRT0HNStyIV8mWq2oytoU3psfCGSInmAo5Ze/Q/xpSiTSqgrlz
         bdUEqfKKXKVOgNSuKEqlukHduNeHum/UMNh6OSLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [PATCH 5.9 012/255] spi: imx: fix runtime pm support for !CONFIG_PM
Date:   Tue, 17 Nov 2020 14:02:32 +0100
Message-Id: <20201117122139.535251813@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 43b6bf406cd0319e522638f97c9086b7beebaeaa ]

525c9e5a32bd introduced pm_runtime support for the i.MX SPI driver. With
this pm_runtime is used to bring up the clocks initially. When CONFIG_PM
is disabled the clocks are no longer enabled and the driver doesn't work
anymore. Fix this by enabling the clocks in the probe function and
telling pm_runtime that the device is active using
pm_runtime_set_active().

Fixes: 525c9e5a32bd spi: imx: enable runtime pm support
Tested-by: Christian Eggers <ceggers@arri.de> [tested for !CONFIG_PM only]
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20201021104513.21560-1-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index e38e5ad3c7068..9aac515b718c8 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1674,15 +1674,18 @@ static int spi_imx_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	pm_runtime_enable(spi_imx->dev);
+	ret = clk_prepare_enable(spi_imx->clk_per);
+	if (ret)
+		goto out_master_put;
+
+	ret = clk_prepare_enable(spi_imx->clk_ipg);
+	if (ret)
+		goto out_put_per;
+
 	pm_runtime_set_autosuspend_delay(spi_imx->dev, MXC_RPM_TIMEOUT);
 	pm_runtime_use_autosuspend(spi_imx->dev);
-
-	ret = pm_runtime_get_sync(spi_imx->dev);
-	if (ret < 0) {
-		dev_err(spi_imx->dev, "failed to enable clock\n");
-		goto out_runtime_pm_put;
-	}
+	pm_runtime_set_active(spi_imx->dev);
+	pm_runtime_enable(spi_imx->dev);
 
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
 	/*
@@ -1722,8 +1725,12 @@ out_bitbang_start:
 		spi_imx_sdma_exit(spi_imx);
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
-	pm_runtime_put_sync(spi_imx->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(spi_imx->dev);
+
+	clk_disable_unprepare(spi_imx->clk_ipg);
+out_put_per:
+	clk_disable_unprepare(spi_imx->clk_per);
 out_master_put:
 	spi_master_put(master);
 
-- 
2.27.0



