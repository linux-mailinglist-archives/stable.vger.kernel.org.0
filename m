Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D3DCD58
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634394AbfJRSHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 14:07:19 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45320 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505757AbfJRSHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 14:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=UWYU2hlp/17q+ZNz6t8G1ig3ksQwGbwgwvY2Lux56Yk=; b=JqPCc9ztbqfq
        YSnIrMln6LZiMJrCkj5Yq128E60d+oXbv7oWH0G0CtqD0z3X+lROeWhcIjkT10OY59dEvCKncns10
        0rZk1rwVRh1AtMJjGNWPfBzgvpN5lX1MLg1Hqd4xAQpqaAOWdOIvH9pb9QkfrBVCycfL+kW83BCEC
        mJSR0=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iLWec-0004I2-Rf; Fri, 18 Oct 2019 18:07:10 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 4E1912743259; Fri, 18 Oct 2019 19:07:10 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <stable@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Applied "spi: Fix SPI_CS_HIGH setting when using native and GPIO CS" to the spi tree
In-Reply-To: <20191018152929.3287-1-gregory.clement@bootlin.com>
X-Patchwork-Hint: ignore
Message-Id: <20191018180710.4E1912743259@ypsilon.sirena.org.uk>
Date:   Fri, 18 Oct 2019 19:07:10 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   spi: Fix SPI_CS_HIGH setting when using native and GPIO CS

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.4

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 3e5ec1db8bfee845d9f8560d1c64aeaccd586398 Mon Sep 17 00:00:00 2001
From: Gregory CLEMENT <gregory.clement@bootlin.com>
Date: Fri, 18 Oct 2019 17:29:29 +0200
Subject: [PATCH] spi: Fix SPI_CS_HIGH setting when using native and GPIO CS

When improving the CS GPIO support at core level, the SPI_CS_HIGH
has been enabled for all the CS lines used for a given SPI controller.

However, the SPI framework allows to have on the same controller native
CS and GPIO CS. The native CS may not support the SPI_CS_HIGH, so they
should not be setup automatically.

With this patch the setting is done only for the CS that will use a
GPIO as CS

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191018152929.3287-1-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index f8b4654a57d3..d07517151340 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1711,15 +1711,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 		spi->mode |= SPI_3WIRE;
 	if (of_property_read_bool(nc, "spi-lsb-first"))
 		spi->mode |= SPI_LSB_FIRST;
-
-	/*
-	 * For descriptors associated with the device, polarity inversion is
-	 * handled in the gpiolib, so all chip selects are "active high" in
-	 * the logical sense, the gpiolib will invert the line if need be.
-	 */
-	if (ctlr->use_gpio_descriptors)
-		spi->mode |= SPI_CS_HIGH;
-	else if (of_property_read_bool(nc, "spi-cs-high"))
+	if (of_property_read_bool(nc, "spi-cs-high"))
 		spi->mode |= SPI_CS_HIGH;
 
 	/* Device DUAL/QUAD mode */
@@ -1783,6 +1775,14 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	}
 	spi->chip_select = value;
 
+	/*
+	 * For descriptors associated with the device, polarity inversion is
+	 * handled in the gpiolib, so all gpio chip selects are "active high"
+	 * in the logical sense, the gpiolib will invert the line if need be.
+	 */
+	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods[spi->chip_select])
+		spi->mode |= SPI_CS_HIGH;
+
 	/* Device speed */
 	rc = of_property_read_u32(nc, "spi-max-frequency", &value);
 	if (rc) {
-- 
2.20.1

