Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C9011B5E9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfLKP5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbfLKPPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670A524654;
        Wed, 11 Dec 2019 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077307;
        bh=SbZl23O28K/WEd7J07V6G4jr5a1oOdJEfXTkhq256uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfBQIA3gQ0bwXF3zyG5MAb3Nt41st2SxXxXHk2H1N1pxonTBKs2kOCDigMvTOqLKq
         149AFeNo4FuO4HQIF6AsZ3AMS6CEbN63587gLt4nlM1k93cDmfhe1Hgwy+Niwt/I7I
         f+8/jjt5cK/7KCffey7Rrfou74vHnBnTapR1YHqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.3 096/105] spi: Fix SPI_CS_HIGH setting when using native and GPIO CS
Date:   Wed, 11 Dec 2019 16:06:25 +0100
Message-Id: <20191211150302.227105872@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 3e5ec1db8bfee845d9f8560d1c64aeaccd586398 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1710,15 +1710,7 @@ static int of_spi_parse_dt(struct spi_co
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
@@ -1782,6 +1774,14 @@ static int of_spi_parse_dt(struct spi_co
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


