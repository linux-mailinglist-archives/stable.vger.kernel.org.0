Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D57EB7E59
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391269AbfISPjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 11:39:47 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:38245 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390004AbfISPjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 11:39:47 -0400
X-Originating-IP: 86.207.98.53
Received: from localhost (aclermont-ferrand-651-1-259-53.w86-207.abo.wanadoo.fr [86.207.98.53])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 940441BF21B;
        Thu, 19 Sep 2019 15:39:43 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] spi: atmel: Fix crash when using more than 4 gpio CS
Date:   Thu, 19 Sep 2019 17:38:47 +0200
Message-Id: <20190919153847.7179-1-gregory.clement@bootlin.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even when using a gpio as chip select, the registers controlling the
hardware chip select have to be configured. However any of the 4
hardware CS can be controlled.

Until now, the gpio index was used to match an hardware chip select,
which limited the number of CS than can be used. Using more than 4
gpios leads to the following kernel crash:

WARNING: CPU: 0 PID: 1 at drivers/spi/spi-atmel.c:1293 atmel_spi_transfer_one_message+0x8b0/0x8ec
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 5.3.0+ #24
Hardware name: Atmel SAMA5
[<c010d914>] (unwind_backtrace) from [<c010ad84>] (show_stack+0x10/0x14)
[<c010ad84>] (show_stack) from [<c0117d28>] (__warn+0xd8/0xf0)
[<c0117d28>] (__warn) from [<c0117d80>] (warn_slowpath_null+0x40/0x48)
[<c0117d80>] (warn_slowpath_null) from [<c04b21dc>] (atmel_spi_transfer_one_message+0x8b0/0x8ec)
[<c04b21dc>] (atmel_spi_transfer_one_message) from [<c04afb20>] (__spi_pump_messages+0x330/0x510)
[<c04afb20>] (__spi_pump_messages) from [<c04afe5c>] (__spi_sync+0x150/0x158)
[<c04afe5c>] (__spi_sync) from [<c04afe88>] (spi_sync+0x24/0x3c)
[<c04afe88>] (spi_sync) from [<c04aff88>] (spi_write_then_read+0xe8/0x1a8)
[<c04aff88>] (spi_write_then_read) from [<c0454da0>] (_regmap_raw_read+0xec/0x148)
[<c0454da0>] (_regmap_raw_read) from [<c0454f6c>] (regmap_raw_read+0x110/0x238)
[<c0454f6c>] (regmap_raw_read) from [<c04551f4>] (regmap_bulk_read+0x160/0x19c)
[<c04551f4>] (regmap_bulk_read) from [<c0517744>] (rv3029_get_sr+0x28/0x64)
[<c0517744>] (rv3029_get_sr) from [<c0518184>] (rv3029_probe+0x5c/0x260)
[<c0518184>] (rv3029_probe) from [<c04acf90>] (spi_drv_probe+0x88/0xac)
[<c04acf90>] (spi_drv_probe) from [<c043fec8>] (really_probe+0xf0/0x2c8)
[<c043fec8>] (really_probe) from [<c0440214>] (driver_probe_device+0x60/0x16c)
[<c0440214>] (driver_probe_device) from [<c04404c0>] (device_driver_attach+0x58/0x60)
[<c04404c0>] (device_driver_attach) from [<c0440520>] (__driver_attach+0x58/0xcc)
[<c0440520>] (__driver_attach) from [<c043e318>] (bus_for_each_dev+0x78/0xc0)
[<c043e318>] (bus_for_each_dev) from [<c043f33c>] (bus_add_driver+0x15c/0x1e0)
[<c043f33c>] (bus_add_driver) from [<c0440d2c>] (driver_register+0x74/0x108)
[<c0440d2c>] (driver_register) from [<c0a1cb44>] (rv30x9_init+0x38/0x68)
[<c0a1cb44>] (rv30x9_init) from [<c0102608>] (do_one_initcall+0x58/0x1c0)
[<c0102608>] (do_one_initcall) from [<c0a00e88>] (kernel_init_freeable+0x124/0x1c0)
[<c0a00e88>] (kernel_init_freeable) from [<c0774dc0>] (kernel_init+0x8/0x10c)
[<c0774dc0>] (kernel_init) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xcf429fb0 to 0xcf429ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

With this patch, when using a gpio CS, the hardware CS0 is always
used. Thanks to this, there is no more limitation for the number of
gpio CS we can use.

Fixes: 754ce4f29937 ("[PATCH] SPI: atmel_spi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/spi/spi-atmel.c | 44 ++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index acf318e7330c..bb94f5927819 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -353,22 +353,28 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 {
 	struct atmel_spi_device *asd = spi->controller_state;
 	u32 mr;
+	u8 chip_select;
+
+	if (as->use_cs_gpios)
+		chip_select = 0;
+	else
+		chip_select = spi->chip_select;
 
 	if (atmel_spi_is_v2(as)) {
-		spi_writel(as, CSR0 + 4 * spi->chip_select, asd->csr);
+		spi_writel(as, CSR0 + 4 * chip_select, asd->csr);
 		/* For the low SPI version, there is a issue that PDC transfer
 		 * on CS1,2,3 needs SPI_CSR0.BITS config as SPI_CSR1,2,3.BITS
 		 */
 		spi_writel(as, CSR0, asd->csr);
 		if (as->caps.has_wdrbt) {
 			spi_writel(as, MR,
-					SPI_BF(PCS, ~(0x01 << spi->chip_select))
+					SPI_BF(PCS, ~(0x01 << chip_select))
 					| SPI_BIT(WDRBT)
 					| SPI_BIT(MODFDIS)
 					| SPI_BIT(MSTR));
 		} else {
 			spi_writel(as, MR,
-					SPI_BF(PCS, ~(0x01 << spi->chip_select))
+					SPI_BF(PCS, ~(0x01 << chip_select))
 					| SPI_BIT(MODFDIS)
 					| SPI_BIT(MSTR));
 		}
@@ -390,8 +396,8 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 		}
 
 		mr = spi_readl(as, MR);
-		mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
-		if (as->use_cs_gpios && spi->chip_select != 0)
+		mr = SPI_BFINS(PCS, ~(1 << chip_select), mr);
+		if (as->use_cs_gpios && chip_select != 0)
 			gpiod_set_value(asd->npcs_pin, 1);
 		spi_writel(as, MR, mr);
 	}
@@ -403,12 +409,18 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 {
 	struct atmel_spi_device *asd = spi->controller_state;
 	u32 mr;
+	u8 chip_select;
+
+	if (as->use_cs_gpios)
+		chip_select = 0;
+	else
+		chip_select = spi->chip_select;
 
 	/* only deactivate *this* device; sometimes transfers to
 	 * another device may be active when this routine is called.
 	 */
 	mr = spi_readl(as, MR);
-	if (~SPI_BFEXT(PCS, mr) & (1 << spi->chip_select)) {
+	if (~SPI_BFEXT(PCS, mr) & (1 << chip_select)) {
 		mr = SPI_BFINS(PCS, 0xf, mr);
 		spi_writel(as, MR, mr);
 	}
@@ -417,7 +429,7 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 
 	if (!as->use_cs_gpios)
 		spi_writel(as, CR, SPI_BIT(LASTXFER));
-	else if (atmel_spi_is_v2(as) || spi->chip_select != 0)
+	else if (atmel_spi_is_v2(as) || chip_select != 0)
 		gpiod_set_value(asd->npcs_pin, 0);
 }
 
@@ -844,6 +856,12 @@ static int atmel_spi_set_xfer_speed(struct atmel_spi *as,
 {
 	u32			scbr, csr;
 	unsigned long		bus_hz;
+	u8 chip_select;
+
+	if (as->use_cs_gpios)
+		chip_select = 0;
+	else
+		chip_select = spi->chip_select;
 
 	/* v1 chips start out at half the peripheral bus speed. */
 	bus_hz = as->spi_clk;
@@ -872,9 +890,9 @@ static int atmel_spi_set_xfer_speed(struct atmel_spi *as,
 			xfer->speed_hz, scbr, bus_hz);
 		return -EINVAL;
 	}
-	csr = spi_readl(as, CSR0 + 4 * spi->chip_select);
+	csr = spi_readl(as, CSR0 + 4 * chip_select);
 	csr = SPI_BFINS(SCBR, scbr, csr);
-	spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+	spi_writel(as, CSR0 + 4 * chip_select, csr);
 
 	return 0;
 }
@@ -1238,8 +1256,12 @@ static int atmel_spi_setup(struct spi_device *spi)
 		"setup: bpw %u mode 0x%x -> csr%d %08x\n",
 		bits, spi->mode, spi->chip_select, csr);
 
-	if (!atmel_spi_is_v2(as))
-		spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+	if (!atmel_spi_is_v2(as)) {
+		if (as->use_cs_gpios)
+			spi_writel(as, CSR0, csr);
+		else
+			spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+	}
 
 	return 0;
 }
-- 
2.23.0

