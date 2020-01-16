Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A194913E2D0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbgAPQ6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733199AbgAPQ5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D298B2467E;
        Thu, 16 Jan 2020 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193867;
        bh=50JiBXz4aVsgDputPHW/Z9vKrc8bWmLSNSFpXsJ2W3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbooVXytUOfMlwpkbNcF/6yCAheKfY/C6luzYdVAzb0SC/dCJ12XdSLkoS9zy8Cfb
         oBVKT51n0F0kfUKnANpPYo0vhYrlW3gM9fZSwTwa5vnE4WC1NeZ99mCVIYNDshaswL
         m+CDmuFN61VYhIRrgYoyvMLDBq9GE6kGOnBvBMRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 113/671] spi: cadence: Correct initialisation of runtime PM
Date:   Thu, 16 Jan 2020 11:45:44 -0500
Message-Id: <20200116165502.8838-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 734882a8bf984c2ac8a57d8ac3ee53230bd0bed8 ]

Currently the driver calls pm_runtime_put_autosuspend but without ever
having done a pm_runtime_get, this causes the reference count in the pm
runtime core to become -1. The bad reference count causes the core to
sometimes suspend whilst an active SPI transfer is in progress.

arizona spi0.1: SPI transfer timed out
spi_master spi0: failed to transfer one message from queue

The correct proceedure is to do all the initialisation that requires the
hardware to be powered up before enabling the PM runtime, then enable
the PM runtime having called pm_runtime_set_active to inform it that the
hardware is currently powered up. The core will then power it down at
it's leisure and no explicit pm_runtime_put is required.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 7c88f74f7f47..94cc0a152449 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -584,11 +584,6 @@ static int cdns_spi_probe(struct platform_device *pdev)
 		goto clk_dis_apb;
 	}
 
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	ret = of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs);
 	if (ret < 0)
 		master->num_chipselect = CDNS_SPI_DEFAULT_NUM_CS;
@@ -603,8 +598,10 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	/* SPI controller initializations */
 	cdns_spi_init_hw(xspi);
 
-	pm_runtime_mark_last_busy(&pdev->dev);
-	pm_runtime_put_autosuspend(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
-- 
2.20.1

