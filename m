Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC64124B2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381120AbhITSg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380609AbhITSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868DE6136A;
        Mon, 20 Sep 2021 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158927;
        bh=74MJXDGJ4K3AoGJVt5qkFWCkF8xXBBPjtzy3qMHCPWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0BYORuds4bFYBr7e0dAoipuqyP3nMgTdrsjxiv7W4N3uWVOgK4wNUctm/TdJAKwe
         GLB6PjoaprrKcnvI7TZaWvX4onGmcNxk8yVkTxhVvLkWGqb23zFdGYab2RBTqTH8AA
         Dus+N1o34omuER+a5Hk4iJrviaGQP/CEtQy0JpQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/122] mfd: lpc_sch: Partially revert "Add support for Intel Quark X1000"
Date:   Mon, 20 Sep 2021 18:44:51 +0200
Message-Id: <20210920163919.716089644@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 922e8ce883e59b52786b2c11656d84dc58ef084a ]

The IRQ support for SCH GPIO is not specific to the Intel Quark SoC.
Moreover the IRQ routing is quite interesting there, so while it's
needs a special support, the driver haven't it anyway yet.

Due to above remove basically redundant code of IRQ support.

This reverts commit ec689a8a8155ce8b966bd5d7737a3916f5e48be3.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lpc_sch.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index f27eb8dabc1c..428a526cbe86 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -26,9 +26,6 @@
 #define GPIO_IO_SIZE	64
 #define GPIO_IO_SIZE_CENTERTON	128
 
-/* Intel Quark X1000 GPIO IRQ Number */
-#define GPIO_IRQ_QUARK_X1000	9
-
 #define WDTBASE		0x84
 #define WDT_IO_SIZE	64
 
@@ -43,30 +40,25 @@ struct lpc_sch_info {
 	unsigned int io_size_smbus;
 	unsigned int io_size_gpio;
 	unsigned int io_size_wdt;
-	int irq_gpio;
 };
 
 static struct lpc_sch_info sch_chipset_info[] = {
 	[LPC_SCH] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE,
-		.irq_gpio = -1,
 	},
 	[LPC_ITC] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE,
 		.io_size_wdt = WDT_IO_SIZE,
-		.irq_gpio = -1,
 	},
 	[LPC_CENTERTON] = {
 		.io_size_smbus = SMBUS_IO_SIZE,
 		.io_size_gpio = GPIO_IO_SIZE_CENTERTON,
 		.io_size_wdt = WDT_IO_SIZE,
-		.irq_gpio = -1,
 	},
 	[LPC_QUARK_X1000] = {
 		.io_size_gpio = GPIO_IO_SIZE,
-		.irq_gpio = GPIO_IRQ_QUARK_X1000,
 		.io_size_wdt = WDT_IO_SIZE,
 	},
 };
@@ -113,13 +105,13 @@ static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
 }
 
 static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
-				 const char *name, int size, int irq,
-				 int id, struct mfd_cell *cell)
+				 const char *name, int size, int id,
+				 struct mfd_cell *cell)
 {
 	struct resource *res;
 	int ret;
 
-	res = devm_kcalloc(&pdev->dev, 2, sizeof(*res), GFP_KERNEL);
+	res = devm_kzalloc(&pdev->dev, sizeof(*res), GFP_KERNEL);
 	if (!res)
 		return -ENOMEM;
 
@@ -135,18 +127,6 @@ static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
 	cell->ignore_resource_conflicts = true;
 	cell->id = id;
 
-	/* Check if we need to add an IRQ resource */
-	if (irq < 0)
-		return 0;
-
-	res++;
-
-	res->start = irq;
-	res->end = irq;
-	res->flags = IORESOURCE_IRQ;
-
-	cell->num_resources++;
-
 	return 0;
 }
 
@@ -158,7 +138,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	int ret;
 
 	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus",
-				    info->io_size_smbus, -1,
+				    info->io_size_smbus,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
@@ -166,7 +146,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		cells++;
 
 	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio",
-				    info->io_size_gpio, info->irq_gpio,
+				    info->io_size_gpio,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
@@ -174,7 +154,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		cells++;
 
 	ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
-				    info->io_size_wdt, -1,
+				    info->io_size_wdt,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
 		return ret;
-- 
2.30.2



