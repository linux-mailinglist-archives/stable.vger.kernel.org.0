Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73311338C7D
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhCLMPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:15:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:49768 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhCLMPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:15:33 -0500
IronPort-SDR: qW43aKOohwjM7SN/NdDCZPpspo7fXbQhC3Pk/k3e98TrpArfpfTqLAGXAknwQLlaMDWYXYfz0h
 WUVUFJnIKOCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188865988"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="188865988"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:15:32 -0800
IronPort-SDR: IMs7iVWf3icjznXvYKnt4ONkkIOyvX3MEL5oXYsFOQOvxuD3gz8OJNYFkBgQJP/HGn2tXzWEtr
 vW8QB8SyP0YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="431929851"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 12 Mar 2021 04:15:31 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0DE772AF; Fri, 12 Mar 2021 14:15:42 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: [PATCH v1] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk
Date:   Fri, 12 Mar 2021 14:15:42 +0200
Message-Id: <20210312121542.67389-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62d5247d239d4b48762192a251c647d7c997616a ]

On some systems the ACPI tables has wrong pin number and instead of
having a relative one it provides an absolute one in the global GPIO
number space.

Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk to cope with such cases.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-acpi.c   | 7 ++++++-
 include/linux/gpio/consumer.h | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index b1b6dee75924..49a1f8ce4baa 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -649,6 +649,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 	if (!lookup->desc) {
 		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
 		bool gpioint = agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
+		struct gpio_desc *desc;
 		int pin_index;
 
 		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ONLY_GPIOIO && gpioint)
@@ -661,8 +662,12 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 		if (pin_index >= agpio->pin_table_length)
 			return 1;
 
-		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
+		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER)
+			desc = gpio_to_desc(agpio->pin_table[pin_index]);
+		else
+			desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
 					      agpio->pin_table[pin_index]);
+		lookup->desc = desc;
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.gpioint = gpioint;
 
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 901aab89d025..79f450e93abf 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -674,6 +674,8 @@ struct acpi_gpio_mapping {
  * get GpioIo type explicitly, this quirk may be used.
  */
 #define ACPI_GPIO_QUIRK_ONLY_GPIOIO		BIT(1)
+/* Use given pin as an absolute GPIO number in the system */
+#define ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER		BIT(2)
 
 	unsigned int quirks;
 };
-- 
2.30.1

