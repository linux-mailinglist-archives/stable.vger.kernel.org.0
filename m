Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A6D2C084F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbgKWMsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732739AbgKWMrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E8F720857;
        Mon, 23 Nov 2020 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135654;
        bh=Wx4aAopEPeMi9SyJGjP6Wf7lSuewaz+2mw/2jDpp6dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3AtSgon71LazbThIvlwuRBwA1vLjcYFJe26qY9NOUTqNAX+2W9h++EqJ7v/qoAeG
         JMHPCtwbetGJLm7ITJ8XHQ4XWIOXfOCGA9HS3tMm4Al9iUzQqjuvrrUeqzPFID37QE
         GFSevSv3pQbz5aqkde1zfr43YtxwppC+mud+3Z3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <thesven73@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 116/252] spi: fix client driver breakages when using GPIO descriptors
Date:   Mon, 23 Nov 2020 13:21:06 +0100
Message-Id: <20201123121841.191927365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 766c6b63aa044e84b045803b40b14754d69a2a1d ]

Commit f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
introduced the optional use of GPIO descriptors for chip selects.

A side-effect of this change: when a SPI bus uses GPIO descriptors,
all its client devices have SPI_CS_HIGH set in spi->mode. This flag is
required for the SPI bus to operate correctly.

This unfortunately breaks many client drivers, which use the following
pattern to configure their underlying SPI bus:

static int client_device_probe(struct spi_device *spi)
{
	...
	spi->mode = SPI_MODE_0;
	spi->bits_per_word = 8;
	err = spi_setup(spi);
	..
}

In short, many client drivers overwrite the SPI_CS_HIGH bit in
spi->mode, and break the underlying SPI bus driver.

This is especially true for Freescale/NXP imx ecspi, where large
numbers of spi client drivers now no longer work.

Proposed fix:
-------------
When using gpio descriptors, depend on gpiolib to handle CS polarity.
Existing quirks in gpiolib ensure that this is handled correctly.

Existing gpiolib behaviour will force the polarity of any chip-select
gpiod to active-high (if 'spi-active-high' devicetree prop present) or
active-low (if 'spi-active-high' absent). Irrespective of whether
the gpio is marked GPIO_ACTIVE_[HIGH|LOW] in the devicetree.

Loose ends:
-----------
If this fix is applied:
- is commit 138c9c32f090
  ("spi: spidev: Fix CS polarity if GPIO descriptors are used")
  still necessary / correct ?

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20201106150706.29089-1-TheSven73@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 0cab239d8e7fc..7566482c052c8 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -812,18 +812,16 @@ static void spi_set_cs(struct spi_device *spi, bool enable)
 		enable = !enable;
 
 	if (spi->cs_gpiod || gpio_is_valid(spi->cs_gpio)) {
-		/*
-		 * Honour the SPI_NO_CS flag and invert the enable line, as
-		 * active low is default for SPI. Execution paths that handle
-		 * polarity inversion in gpiolib (such as device tree) will
-		 * enforce active high using the SPI_CS_HIGH resulting in a
-		 * double inversion through the code above.
-		 */
 		if (!(spi->mode & SPI_NO_CS)) {
 			if (spi->cs_gpiod)
+				/* polarity handled by gpiolib */
 				gpiod_set_value_cansleep(spi->cs_gpiod,
-							 !enable);
+							 enable1);
 			else
+				/*
+				 * invert the enable line, as active low is
+				 * default for SPI.
+				 */
 				gpio_set_value_cansleep(spi->cs_gpio, !enable);
 		}
 		/* Some SPI masters need both GPIO CS & slave_select */
@@ -1992,15 +1990,6 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	}
 	spi->chip_select = value;
 
-	/*
-	 * For descriptors associated with the device, polarity inversion is
-	 * handled in the gpiolib, so all gpio chip selects are "active high"
-	 * in the logical sense, the gpiolib will invert the line if need be.
-	 */
-	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods &&
-	    ctlr->cs_gpiods[spi->chip_select])
-		spi->mode |= SPI_CS_HIGH;
-
 	/* Device speed */
 	if (!of_property_read_u32(nc, "spi-max-frequency", &value))
 		spi->max_speed_hz = value;
-- 
2.27.0



