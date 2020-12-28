Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5852E412A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439898AbgL1OMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439892AbgL1OMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3098720791;
        Mon, 28 Dec 2020 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164738;
        bh=gSS2vlDOAi6OYsuXe17tLsbwFm5CEC6ChWEJjmiHSAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XIC5NpvN9xPmNdklhIFdsREE97rksNsHs/OZC85nMvZM9mDf7xTv2Y7NONvXwpGn
         pAFSfUnqOL51BdN6knBu0SCuvb0K6BBnQBwmv2rX+z2WnMS+DGSvii7k8oS80pyPPs
         A4qDfmnjw+Z1FUwPZExBmOJKO7WEo/jCn+FLO5Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/717] spi: spi-fsl-dspi: Use max_native_cs instead of num_chipselect to set SPI_MCR
Date:   Mon, 28 Dec 2020 13:44:07 +0100
Message-Id: <20201228125032.916685247@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit 2c2b3ad2c4c801bab1eec7264ea6991b1e4e8f2c ]

If cs-gpios property is used in devicetree then ctlr->num_chipselect value
may be changed by spi_get_gpio_descs().
So use ctlr->max_native_cs instead of ctlr->num_chipselect to set SPI_MCR

Fixes: 4fcc7c2292de (spi: spi-fsl-dspi: Don't access reserved fields in SPI_MCR)
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Link: https://lore.kernel.org/r/20201201085916.63543-1-fido_max@inbox.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 1a08c1d584abe..0287366874882 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1165,7 +1165,7 @@ static int dspi_init(struct fsl_dspi *dspi)
 	unsigned int mcr;
 
 	/* Set idle states for all chip select signals to high */
-	mcr = SPI_MCR_PCSIS(GENMASK(dspi->ctlr->num_chipselect - 1, 0));
+	mcr = SPI_MCR_PCSIS(GENMASK(dspi->ctlr->max_native_cs - 1, 0));
 
 	if (dspi->devtype_data->trans_mode == DSPI_XSPI_MODE)
 		mcr |= SPI_MCR_XSPI;
@@ -1250,7 +1250,7 @@ static int dspi_probe(struct platform_device *pdev)
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata) {
-		ctlr->num_chipselect = pdata->cs_num;
+		ctlr->num_chipselect = ctlr->max_native_cs = pdata->cs_num;
 		ctlr->bus_num = pdata->bus_num;
 
 		/* Only Coldfire uses platform data */
@@ -1263,7 +1263,7 @@ static int dspi_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "can't get spi-num-chipselects\n");
 			goto out_ctlr_put;
 		}
-		ctlr->num_chipselect = cs_num;
+		ctlr->num_chipselect = ctlr->max_native_cs = cs_num;
 
 		of_property_read_u32(np, "bus-num", &bus_num);
 		ctlr->bus_num = bus_num;
-- 
2.27.0



