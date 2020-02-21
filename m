Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D486616800B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 15:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBUOVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 09:21:18 -0500
Received: from foss.arm.com ([217.140.110.172]:40442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgBUOVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 09:21:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74370FEC;
        Fri, 21 Feb 2020 06:21:17 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFC0B3F703;
        Fri, 21 Feb 2020 06:21:16 -0800 (PST)
Date:   Fri, 21 Feb 2020 14:21:15 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Simon Han <z.han@kunbus.com>, stable@vger.kernel.org
Subject: Applied "spi: spidev: Fix CS polarity if GPIO descriptors are used" to the spi tree
In-Reply-To: <fca3ba7cdc930cd36854666ceac4fbcf01b89028.1582027457.git.lukas@wunner.de>
Message-Id: <applied-fca3ba7cdc930cd36854666ceac4fbcf01b89028.1582027457.git.lukas@wunner.de>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   spi: spidev: Fix CS polarity if GPIO descriptors are used

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.6

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

From 138c9c32f090894614899eca15e0bb7279f59865 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 18 Feb 2020 13:08:00 +0100
Subject: [PATCH] spi: spidev: Fix CS polarity if GPIO descriptors are used

Commit f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
amended of_spi_parse_dt() to always set SPI_CS_HIGH for SPI slaves whose
Chip Select is defined by a "cs-gpios" devicetree property.

This change broke userspace applications which issue an SPI_IOC_WR_MODE
ioctl() to an spidev:  Chip Select polarity will be incorrect unless the
application is changed to set SPI_CS_HIGH.  And once changed, it will be
incompatible with kernels not containing the commit.

Fix by setting SPI_CS_HIGH in spidev_ioctl() (under the same conditions
as in of_spi_parse_dt()).

Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Reported-by: Simon Han <z.han@kunbus.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/fca3ba7cdc930cd36854666ceac4fbcf01b89028.1582027457.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org # v5.1+
---
 drivers/spi/spidev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 1e217e3e9486..2ab6e782f14c 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -396,6 +396,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		else
 			retval = get_user(tmp, (u32 __user *)arg);
 		if (retval == 0) {
+			struct spi_controller *ctlr = spi->controller;
 			u32	save = spi->mode;
 
 			if (tmp & ~SPI_MODE_MASK) {
@@ -403,6 +404,10 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				break;
 			}
 
+			if (ctlr->use_gpio_descriptors && ctlr->cs_gpiods &&
+			    ctlr->cs_gpiods[spi->chip_select])
+				tmp |= SPI_CS_HIGH;
+
 			tmp |= spi->mode & ~SPI_MODE_MASK;
 			spi->mode = (u16)tmp;
 			retval = spi_setup(spi);
-- 
2.20.1

