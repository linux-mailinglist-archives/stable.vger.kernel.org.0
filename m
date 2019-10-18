Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F346FDC875
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 17:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404777AbfJRP3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 11:29:37 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:48873 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393138AbfJRP3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 11:29:37 -0400
Received: from localhost (aclermont-ferrand-651-1-259-53.w86-207.abo.wanadoo.fr [86.207.98.53])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A7A76200004;
        Fri, 18 Oct 2019 15:29:33 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] spi: Fix SPI_CS_HIGH setting when using native and GPIO CS
Date:   Fri, 18 Oct 2019 17:29:29 +0200
Message-Id: <20191018152929.3287-1-gregory.clement@bootlin.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/spi/spi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5414a10afd65..1b68acc28c8f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1880,15 +1880,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
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
@@ -1952,6 +1944,14 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
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
2.23.0

