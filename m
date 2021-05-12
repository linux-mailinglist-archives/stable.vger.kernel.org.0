Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E551137C426
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhELP3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhELPXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:23:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 902B9619AF;
        Wed, 12 May 2021 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832178;
        bh=cM4N5uP7brzU1NXDwWlNLOAKsrLCvAENPmzXLCdGhZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wwrh6/klKw0zy00ev2Pdd9wG3eBoKawswcpyzYlG0nrqJoDROIG8WENhIJJszEVoq
         etegs4SPMO68eJNgxIZZf4dk7rVIh1zdNrAHLY+vtn2DefpzvmV8nnIWUl/EvgjCr7
         aznJvtpEujkdECr56Vk6lUHgfAw/OHi1OsamtFoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/530] usb: gadget: pch_udc: Provide a GPIO line used on Intel Minnowboard (v1)
Date:   Wed, 12 May 2021 16:44:42 +0200
Message-Id: <20210512144825.488857728@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 049d3db625a652e23488db88b6104de4d5b62f16 ]

Intel Minnowboard (v1) uses SCH GPIO line SUS7 (i.e. 12)
for VBUS sense. Provide a DMI based quirk to have it's being used.

Fixes: e20849a8c883 ("usb: gadget: pch_udc: Convert to use GPIO descriptors")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-7-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pch_udc.c | 71 +++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index a39122f01cdb..fd3656d0f760 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -7,12 +7,14 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/errno.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/machine.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
-#include <linux/gpio/consumer.h>
 #include <linux/irq.h>
 
 #define PCH_VBUS_PERIOD		3000	/* VBUS polling period (msec) */
@@ -1359,6 +1361,43 @@ static irqreturn_t pch_vbus_gpio_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static struct gpiod_lookup_table minnowboard_udc_gpios = {
+	.dev_id		= "0000:02:02.4",
+	.table		= {
+		GPIO_LOOKUP("sch_gpio.33158", 12, NULL, GPIO_ACTIVE_HIGH),
+		{}
+	},
+};
+
+static const struct dmi_system_id pch_udc_gpio_dmi_table[] = {
+	{
+		.ident = "MinnowBoard",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "MinnowBoard"),
+		},
+		.driver_data = &minnowboard_udc_gpios,
+	},
+	{ }
+};
+
+static void pch_vbus_gpio_remove_table(void *table)
+{
+	gpiod_remove_lookup_table(table);
+}
+
+static int pch_vbus_gpio_add_table(struct pch_udc_dev *dev)
+{
+	struct device *d = &dev->pdev->dev;
+	const struct dmi_system_id *dmi;
+
+	dmi = dmi_first_match(pch_udc_gpio_dmi_table);
+	if (!dmi)
+		return 0;
+
+	gpiod_add_lookup_table(dmi->driver_data);
+	return devm_add_action_or_reset(d, pch_vbus_gpio_remove_table, dmi->driver_data);
+}
+
 /**
  * pch_vbus_gpio_init() - This API initializes GPIO port detecting VBUS.
  * @dev:		Reference to the driver structure
@@ -1377,8 +1416,12 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *dev)
 	dev->vbus_gpio.port = NULL;
 	dev->vbus_gpio.intr = 0;
 
+	err = pch_vbus_gpio_add_table(dev);
+	if (err)
+		return err;
+
 	/* Retrieve the GPIO line from the USB gadget device */
-	gpiod = devm_gpiod_get(d, NULL, GPIOD_IN);
+	gpiod = devm_gpiod_get_optional(d, NULL, GPIOD_IN);
 	if (IS_ERR(gpiod))
 		return PTR_ERR(gpiod);
 	gpiod_set_consumer_name(gpiod, "pch_vbus");
@@ -2888,14 +2931,20 @@ static void pch_udc_pcd_reinit(struct pch_udc_dev *dev)
  * @dev:	Reference to the driver structure
  *
  * Return codes:
- *	0: Success
+ *	0:		Success
+ *	-%ERRNO:	All kind of errors when retrieving VBUS GPIO
  */
 static int pch_udc_pcd_init(struct pch_udc_dev *dev)
 {
+	int ret;
+
 	pch_udc_init(dev);
 	pch_udc_pcd_reinit(dev);
-	pch_vbus_gpio_init(dev);
-	return 0;
+
+	ret = pch_vbus_gpio_init(dev);
+	if (ret)
+		pch_udc_exit(dev);
+	return ret;
 }
 
 /**
@@ -3097,16 +3146,10 @@ static int pch_udc_probe(struct pci_dev *pdev,
 
 	dev->base_addr = pcim_iomap_table(pdev)[bar];
 
-	/*
-	 * FIXME: add a GPIO descriptor table to pdev.dev using
-	 * gpiod_add_descriptor_table() from <linux/gpio/machine.h> based on
-	 * the PCI subsystem ID. The system-dependent GPIO is necessary for
-	 * VBUS operation.
-	 */
-
 	/* initialize the hardware */
-	if (pch_udc_pcd_init(dev))
-		return -ENODEV;
+	retval = pch_udc_pcd_init(dev);
+	if (retval)
+		return retval;
 
 	pci_enable_msi(pdev);
 
-- 
2.30.2



