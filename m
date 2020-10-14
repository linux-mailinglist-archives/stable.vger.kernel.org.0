Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A2028DC6D
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgJNJJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:09:47 -0400
Received: from first.geanix.com ([116.203.34.67]:53572 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbgJNJJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:09:39 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 05:09:38 EDT
Received: from zen.localdomain (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 05D16F41496;
        Wed, 14 Oct 2020 09:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1602666165; bh=aUqpmVAAjoLv03iR1lJWlTTuq3Ra9mS4JJvcrMl80zQ=;
        h=From:To:Cc:Subject:Date;
        b=QcYSlGx8F2sB7kmz03FAAv1M7+kRXre/GguSc7U4PJJ8+IIe8Dh94yJ53k2fI8XYF
         a5sRm/MWvWXFODTETN/HObcw8Ol5k5UQj6SeZhQCd9dbs+ErMBzpluhuYnI5SEuBxi
         2P9tzE8NSOIiraaIhoufXXsiwr18KzNjHCMtYrvmoySnSNG4NzaYKjOwGKBXftW7Ae
         rT/J80Cy/ANS8+OrZKg2oIyC5xEhwAPbT2b6gy0GKro/p+diILKXmUGqBaPdpeqNiM
         EgCmac227s8YKodVqSBuCE70rwYm+4tPgvPBOaCcu3AvI/H5hl/AqLHG6cWhO7cn20
         Q1+83MApLj99w==
From:   =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Cc:     =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] spi: bcm2835: fix gpio cs level inversion
Date:   Wed, 14 Oct 2020 11:02:30 +0200
Message-Id: <20201014090230.2706810-1-martin@geanix.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The work on improving gpio chip-select in spi core, and the following
fixes, has caused the bcm2835 spi driver to use wrong levels. Fix this
by simply removing level handling in the bcm2835 driver, and let the
core do its work.

Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Martin Hundebøll <martin@geanix.com>
---
 drivers/spi/spi-bcm2835.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index b87116e9b413..9b6ba94fe878 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1259,18 +1259,6 @@ static int bcm2835_spi_setup(struct spi_device *spi)
 	if (!chip)
 		return 0;
 
-	/*
-	 * Retrieve the corresponding GPIO line used for CS.
-	 * The inversion semantics will be handled by the GPIO core
-	 * code, so we pass GPIOD_OUT_LOW for "unasserted" and
-	 * the correct flag for inversion semantics. The SPI_CS_HIGH
-	 * on spi->mode cannot be checked for polarity in this case
-	 * as the flag use_gpio_descriptors enforces SPI_CS_HIGH.
-	 */
-	if (of_property_read_bool(spi->dev.of_node, "spi-cs-high"))
-		lflags = GPIO_ACTIVE_HIGH;
-	else
-		lflags = GPIO_ACTIVE_LOW;
 	spi->cs_gpiod = gpiochip_request_own_desc(chip, 8 - spi->chip_select,
 						  DRV_NAME,
 						  lflags,
-- 
2.28.0

