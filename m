Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDFF33B638
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCON50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231312AbhCON4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6191E64EEE;
        Mon, 15 Mar 2021 13:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816602;
        bh=JDWgkyVioyFLxHL2pvAuXaCOGJnQuRhIUk9CHU7DCJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwIyk4ykUhnf0PE+WvgHAzDxtGWtvs013KQq3DyaelWGvBfKXfQ9ihAA51KG+taHR
         czOneoMo3juCifzVzE5pTJiKZE56CjANoBqFBNWL5IrB/Eksseug6FlPmiRAxvPeuR
         23CCsPmt+hEjMwUnAbdMnuei7/mcQx1Y0+1GhjQM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 015/306] gpiolib: acpi: Allow to find GpioInt() resource by name and index
Date:   Mon, 15 Mar 2021 14:51:18 +0100
Message-Id: <20210315135508.130392502@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 809390219fb9c2421239afe5c9eb862d73978ba0 upstream.

Currently only search by index is supported. However, in some cases
we might need to pass the quirks to the acpi_dev_gpio_irq_get().

For this, split out acpi_dev_gpio_irq_get_by() and replace
acpi_dev_gpio_irq_get() by calling above with NULL for name parameter.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   12 ++++++++----
 include/linux/acpi.h        |   10 ++++++++--
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -945,8 +945,9 @@ struct gpio_desc *acpi_node_get_gpiod(st
 }
 
 /**
- * acpi_dev_gpio_irq_get() - Find GpioInt and translate it to Linux IRQ number
+ * acpi_dev_gpio_irq_get_by() - Find GpioInt and translate it to Linux IRQ number
  * @adev: pointer to a ACPI device to get IRQ from
+ * @name: optional name of GpioInt resource
  * @index: index of GpioInt resource (starting from %0)
  *
  * If the device has one or more GpioInt resources, this function can be
@@ -956,9 +957,12 @@ struct gpio_desc *acpi_node_get_gpiod(st
  * The function is idempotent, though each time it runs it will configure GPIO
  * pin direction according to the flags in GpioInt resource.
  *
+ * The function takes optional @name parameter. If the resource has a property
+ * name, then only those will be taken into account.
+ *
  * Return: Linux IRQ number (> %0) on success, negative errno on failure.
  */
-int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
+int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int index)
 {
 	int idx, i;
 	unsigned int irq_flags;
@@ -968,7 +972,7 @@ int acpi_dev_gpio_irq_get(struct acpi_de
 		struct acpi_gpio_info info;
 		struct gpio_desc *desc;
 
-		desc = acpi_get_gpiod_by_index(adev, NULL, i, &info);
+		desc = acpi_get_gpiod_by_index(adev, name, i, &info);
 
 		/* Ignore -EPROBE_DEFER, it only matters if idx matches */
 		if (IS_ERR(desc) && PTR_ERR(desc) != -EPROBE_DEFER)
@@ -1013,7 +1017,7 @@ int acpi_dev_gpio_irq_get(struct acpi_de
 	}
 	return -ENOENT;
 }
-EXPORT_SYMBOL_GPL(acpi_dev_gpio_irq_get);
+EXPORT_SYMBOL_GPL(acpi_dev_gpio_irq_get_by);
 
 static acpi_status
 acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1072,19 +1072,25 @@ void __acpi_handle_debug(struct _ddebug
 #if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
 bool acpi_gpio_get_irq_resource(struct acpi_resource *ares,
 				struct acpi_resource_gpio **agpio);
-int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index);
+int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int index);
 #else
 static inline bool acpi_gpio_get_irq_resource(struct acpi_resource *ares,
 					      struct acpi_resource_gpio **agpio)
 {
 	return false;
 }
-static inline int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
+static inline int acpi_dev_gpio_irq_get_by(struct acpi_device *adev,
+					   const char *name, int index)
 {
 	return -ENXIO;
 }
 #endif
 
+static inline int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
+{
+	return acpi_dev_gpio_irq_get_by(adev, NULL, index);
+}
+
 /* Device properties */
 
 #ifdef CONFIG_ACPI


