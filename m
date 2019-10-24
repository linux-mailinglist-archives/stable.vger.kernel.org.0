Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA4AE3549
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390063AbfJXONp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:13:45 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60699 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfJXONp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 10:13:45 -0400
X-Originating-IP: 92.137.17.54
Received: from localhost (alyon-657-1-975-54.w92-137.abo.wanadoo.fr [92.137.17.54])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id EC63E240003;
        Thu, 24 Oct 2019 14:13:40 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "kernelci.org bot" <bot@kernelci.org>, stable@vger.kernel.org
Subject: [PATCH] spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS
Date:   Thu, 24 Oct 2019 16:13:09 +0200
Message-Id: <20191024141309.22434-1-gregory.clement@bootlin.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even if the flag use_gpio_descriptors is set, it is possible that
cs_gpiods was not allocated, which leads to a kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = (ptrval)
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W         5.4.0-rc3 #1
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
PC is at of_register_spi_device+0x20c/0x38c
LR is at __of_find_property+0x3c/0x60
pc : [<c09b45dc>]    lr : [<c0c47a98>]    psr: 20000013
sp : ea0b5d88  ip : aae04461  fp : ea1a8810
r10: 00000055  r9 : 00000000  r8 : ea6dc800
r7 : 00000001  r6 : c1704048  r5 : eafc8c7c  r4 : ea7fd800
r3 : 00000000  r2 : 00000000  r1 : ffffffff  r0 : 00000001
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 80204059  DAC: 00000051
Process swapper (pid: 1, stack limit = 0x(ptrval))
Stack: (0xea0b5d88 to 0xea0b6000)
5d80:                   00000000 aae04461 00000000 aae04461 ea6dc800 00000000
5da0: eafc8c7c c131fbdc ea6dc9c0 c09b4e24 ea7f4500 00000040 c09b3e24 ea7f3dc0
5dc0: ea6dc800 ea1a8800 ea1a8810 00000000 00000000 00000055 0000014b c09b5020
5de0: ea6dc800 ea6dcb80 ea1a8800 ea1a8810 00000000 c09cb884 ea1a69c0 ea6dcb80
5e00: ea1a8810 00000000 c1862448 00000000 00000000 c1862448 00000000 c08dba2c
5e20: c18e66dc ea1a8810 c18e66e0 00000000 00000000 c08d9b28 ea1a8810 c1862448
5e40: c1862448 c08da0c8 00000000 c15c5850 c18a4200 c08d9e18 00000000 c15c5850
5e60: c18a4200 ea1a8810 00000000 c1862448 c08da0c8 00000000 c15c5850 c18a4200
5e80: 0000014b c08da0c0 00000000 c1862448 ea1a8810 c08da120 ea1aa0b0 c1704048
5ea0: c1862448 c08d7ed4 c15c5850 ea0894cc ea1aa0b0 aae04461 c18522c8 c1862448
5ec0: ea7f3800 c18522c8 00000000 c08d8f14 c1321b68 c15977a0 c1862448 c1862448
5ee0: c1704048 c15977b0 c15c5830 c08daa8c c18992a0 c1704048 c15977b0 c0302ce4
5f00: ebfffcd1 c03566f0 c14031b4 c1346700 00000000 00000006 00000006 c1242794
5f20: 00000000 c1704048 c1252144 c1242808 c1655778 ebfffcc0 ebfffcc3 aae04461
5f40: 00000000 00000006 c18992a0 aae04461 c16564e8 c18992a0 c18a4200 c15c5830
5f60: c15004a8 c1501028 00000006 00000006 00000000 c15004a8 00000000 00000007
5f80: c0e01028 00000000 c0e01028 00000000 00000000 00000000 00000000 00000000
5fa0: 00000000 c0e01030 00000000 c03010e8 00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c09b45dc>] (of_register_spi_device) from [<c09b4e24>] (spi_register_controller+0x558/0x720)
[<c09b4e24>] (spi_register_controller) from [<c09b5020>] (devm_spi_register_controller+0x34/0x6c)
[<c09b5020>] (devm_spi_register_controller) from [<c09cb884>] (tegra_spi_probe+0x344/0x438)
[<c09cb884>] (tegra_spi_probe) from [<c08dba2c>] (platform_drv_probe+0x48/0x98)
[<c08dba2c>] (platform_drv_probe) from [<c08d9b28>] (really_probe+0x1e0/0x348)
[<c08d9b28>] (really_probe) from [<c08d9e18>] (driver_probe_device+0x60/0x168)
[<c08d9e18>] (driver_probe_device) from [<c08da0c0>] (device_driver_attach+0x58/0x60)
[<c08da0c0>] (device_driver_attach) from [<c08da120>] (__driver_attach+0x58/0xcc)
[<c08da120>] (__driver_attach) from [<c08d7ed4>] (bus_for_each_dev+0x74/0xb4)
[<c08d7ed4>] (bus_for_each_dev) from [<c08d8f14>] (bus_add_driver+0x1b8/0x1d8)
[<c08d8f14>] (bus_add_driver) from [<c08daa8c>] (driver_register+0x74/0x108)
[<c08daa8c>] (driver_register) from [<c0302ce4>] (do_one_initcall+0x50/0x1a8)
[<c0302ce4>] (do_one_initcall) from [<c1501028>] (kernel_init_freeable+0x15c/0x1fc)
[<c1501028>] (kernel_init_freeable) from [<c0e01030>] (kernel_init+0x8/0x10c)
[<c0e01030>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xea0b5fb0 to 0xea0b5ff8)
5fa0:                                     00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e3520000 0a000006 e59822a8 e6ef3073 (e7923103)

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
Hello,

Following the report from
https://kernelci.org/boot/id/5daa485f59b5142f647525a0/, I managed to
reproduce the bug on my platform, and fixed it.

The commit ID provided for the fixes tag is the one of the branch
for-linus on
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git

Gregory

 drivers/spi/spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1b68acc28c8f..dd7cdd996086 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1949,7 +1949,8 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	 * handled in the gpiolib, so all gpio chip selects are "active high"
 	 * in the logical sense, the gpiolib will invert the line if need be.
 	 */
-	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods[spi->chip_select])
+	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods &&
+	    ctlr->cs_gpiods[spi->chip_select])
 		spi->mode |= SPI_CS_HIGH;
 
 	/* Device speed */
-- 
2.23.0

