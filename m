Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2330513E63E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbgAPRT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390013AbgAPRS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:18:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8779920728;
        Thu, 16 Jan 2020 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195106;
        bh=OcyjwP9xy+dQFPo7oxtaVghCK0aZ2i39FwzIKaUQLv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9agKYm3Iy1q7BPIFy+V9CmBolNu5r2nU/zkJ32hyLb5YFOq2wpco7LrpwuybtRli
         A8VRkWO5CLK7+JNDyzkDGHrfPCsxchKEv/N/0y/dL6/OpVGBXqIHvLVPsqDcsN14g5
         vjMDY2DiRtkKFFbv+tiozfDBVUd7bfNl2MXzFByU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Paul Burton <paul.burton@mips.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 049/371] MIPS: BCM63XX: drop unused and broken DSP platform device
Date:   Thu, 16 Jan 2020 12:11:57 -0500
Message-Id: <20200116171719.16965-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 682fee802843b332f9c51ffc8e062de5ff773f2e ]

Trying to register the DSP platform device results in a null pointer
access:

[    0.124184] CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 804e305c, ra == 804e6f20
[    0.135208] Oops[#1]:
[    0.137514] CPU: 0 PID: 1 Comm: swapper Not tainted 4.14.87
...
[    0.197117] epc   : 804e305c bcm63xx_dsp_register+0x80/0xa4
[    0.202838] ra    : 804e6f20 board_register_devices+0x258/0x390
...

This happens because it tries to copy the passed platform data over the
platform_device's unpopulated platform_data.

Since this code has been broken since its submission, no driver was ever
submitted for it, and apparently nobody was using it, just remove it
instead of trying to fix it.

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs.")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/Makefile                    |  6 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c     | 20 -------
 arch/mips/bcm63xx/dev-dsp.c                   | 56 -------------------
 .../asm/mach-bcm63xx/bcm63xx_dev_dsp.h        | 14 -----
 .../include/asm/mach-bcm63xx/board_bcm963xx.h |  5 --
 5 files changed, 3 insertions(+), 98 deletions(-)
 delete mode 100644 arch/mips/bcm63xx/dev-dsp.c
 delete mode 100644 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h

diff --git a/arch/mips/bcm63xx/Makefile b/arch/mips/bcm63xx/Makefile
index c69f297fc1df..d89651e538f6 100644
--- a/arch/mips/bcm63xx/Makefile
+++ b/arch/mips/bcm63xx/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y		+= clk.o cpu.o cs.o gpio.o irq.o nvram.o prom.o reset.o \
-		   setup.o timer.o dev-dsp.o dev-enet.o dev-flash.o \
-		   dev-pcmcia.o dev-rng.o dev-spi.o dev-hsspi.o dev-uart.o \
-		   dev-wdt.o dev-usb-usbd.o
+		   setup.o timer.o dev-enet.o dev-flash.o dev-pcmcia.o \
+		   dev-rng.o dev-spi.o dev-hsspi.o dev-uart.o dev-wdt.o \
+		   dev-usb-usbd.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-y		+= boards/
diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index b2097c0d2ed7..36ec3dc2c999 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -23,7 +23,6 @@
 #include <bcm63xx_nvram.h>
 #include <bcm63xx_dev_pci.h>
 #include <bcm63xx_dev_enet.h>
-#include <bcm63xx_dev_dsp.h>
 #include <bcm63xx_dev_flash.h>
 #include <bcm63xx_dev_hsspi.h>
 #include <bcm63xx_dev_pcmcia.h>
@@ -289,14 +288,6 @@ static struct board_info __initdata board_96348gw_10 = {
 	.has_pccard			= 1,
 	.has_ehci0			= 1,
 
-	.has_dsp			= 1,
-	.dsp = {
-		.gpio_rst		= 6,
-		.gpio_int		= 34,
-		.cs			= 2,
-		.ext_irq		= 2,
-	},
-
 	.leds = {
 		{
 			.name		= "adsl-fail",
@@ -401,14 +392,6 @@ static struct board_info __initdata board_96348gw = {
 
 	.has_ohci0 = 1,
 
-	.has_dsp			= 1,
-	.dsp = {
-		.gpio_rst		= 6,
-		.gpio_int		= 34,
-		.ext_irq		= 2,
-		.cs			= 2,
-	},
-
 	.leds = {
 		{
 			.name		= "adsl-fail",
@@ -898,9 +881,6 @@ int __init board_register_devices(void)
 	if (board.has_usbd)
 		bcm63xx_usbd_register(&board.usbd);
 
-	if (board.has_dsp)
-		bcm63xx_dsp_register(&board.dsp);
-
 	/* Generate MAC address for WLAN and register our SPROM,
 	 * do this after registering enet devices
 	 */
diff --git a/arch/mips/bcm63xx/dev-dsp.c b/arch/mips/bcm63xx/dev-dsp.c
deleted file mode 100644
index 5bb5b154c9bd..000000000000
--- a/arch/mips/bcm63xx/dev-dsp.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Broadcom BCM63xx VoIP DSP registration
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2009 Florian Fainelli <florian@openwrt.org>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-
-#include <bcm63xx_cpu.h>
-#include <bcm63xx_dev_dsp.h>
-#include <bcm63xx_regs.h>
-#include <bcm63xx_io.h>
-
-static struct resource voip_dsp_resources[] = {
-	{
-		.start		= -1, /* filled at runtime */
-		.end		= -1, /* filled at runtime */
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= -1, /* filled at runtime */
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bcm63xx_voip_dsp_device = {
-	.name		= "bcm63xx-voip-dsp",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(voip_dsp_resources),
-	.resource	= voip_dsp_resources,
-};
-
-int __init bcm63xx_dsp_register(const struct bcm63xx_dsp_platform_data *pd)
-{
-	struct bcm63xx_dsp_platform_data *dpd;
-	u32 val;
-
-	/* Get the memory window */
-	val = bcm_mpi_readl(MPI_CSBASE_REG(pd->cs - 1));
-	val &= MPI_CSBASE_BASE_MASK;
-	voip_dsp_resources[0].start = val;
-	voip_dsp_resources[0].end = val + 0xFFFFFFF;
-	voip_dsp_resources[1].start = pd->ext_irq;
-
-	/* copy given platform data */
-	dpd = bcm63xx_voip_dsp_device.dev.platform_data;
-	memcpy(dpd, pd, sizeof (*pd));
-
-	return platform_device_register(&bcm63xx_voip_dsp_device);
-}
diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h
deleted file mode 100644
index 4e4970787371..000000000000
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __BCM63XX_DSP_H
-#define __BCM63XX_DSP_H
-
-struct bcm63xx_dsp_platform_data {
-	unsigned gpio_rst;
-	unsigned gpio_int;
-	unsigned cs;
-	unsigned ext_irq;
-};
-
-int __init bcm63xx_dsp_register(const struct bcm63xx_dsp_platform_data *pd);
-
-#endif /* __BCM63XX_DSP_H */
diff --git a/arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h b/arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h
index 5e5b1bc4a324..830f53f28e3f 100644
--- a/arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h
+++ b/arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h
@@ -7,7 +7,6 @@
 #include <linux/leds.h>
 #include <bcm63xx_dev_enet.h>
 #include <bcm63xx_dev_usb_usbd.h>
-#include <bcm63xx_dev_dsp.h>
 
 /*
  * flash mapping
@@ -31,7 +30,6 @@ struct board_info {
 	unsigned int	has_ohci0:1;
 	unsigned int	has_ehci0:1;
 	unsigned int	has_usbd:1;
-	unsigned int	has_dsp:1;
 	unsigned int	has_uart0:1;
 	unsigned int	has_uart1:1;
 
@@ -43,9 +41,6 @@ struct board_info {
 	/* USB config */
 	struct bcm63xx_usbd_platform_data usbd;
 
-	/* DSP config */
-	struct bcm63xx_dsp_platform_data dsp;
-
 	/* GPIO LEDs */
 	struct gpio_led leds[5];
 
-- 
2.20.1

