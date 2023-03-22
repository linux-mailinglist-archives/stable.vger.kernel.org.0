Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB16C559C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCVT7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjCVT7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DA55FDC;
        Wed, 22 Mar 2023 12:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FCDC6229C;
        Wed, 22 Mar 2023 19:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEEBC433D2;
        Wed, 22 Mar 2023 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515077;
        bh=NVXZZ5yC36CpYxH5yyM4z2kGumAqqmOLjTipL8mbS4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsiNOqiA3lxIx8g8vjeWDYPM+J/U3vttjOGA6Da9fbTDfs0wuF34JNuTBHF/tTAdy
         zojxYLsx+P0yEn4A7hgtS67HZiseOtW++JGA53idF4aSdqpquTy4TqJn0OVhkYCplK
         xS8EAN0s8l+CeozeELsdETEtPbS30VJzYajM8uNNKI8PZiWYLABXClODRVIHn1/DjV
         vvB1fse4ikzIjqa3GqRJ8q+oqstGQMxblTvsORXu7zLB4aXVla4X5/P1ZlkudIF/FG
         1Xo2QMO/cgYqHdlKEIRcvFjO9/8Rtgd7Ond7yBPd4VQhj3mQNwz059m8tfrxJ8Maun
         Ot6d+Tg7qOr7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        linus.walleij@linaro.org, brgl@bgdev.pl, robert.moore@intel.com,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org,
        linux-gpio@vger.kernel.org, acpica-devel@lists.linuxfoundation.org
Subject: [PATCH AUTOSEL 6.2 11/45] ACPI: x86: Introduce an acpi_quirk_skip_gpio_event_handlers() helper
Date:   Wed, 22 Mar 2023 15:56:05 -0400
Message-Id: <20230322195639.1995821-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5adc409340b1fc82bc1175e602d14ac82ac685e3 ]

x86 ACPI boards which ship with only Android as their factory image usually
have pretty broken ACPI tables, relying on everything being hardcoded in
the factory kernel image and often disabling parts of the ACPI enumeration
kernel code to avoid the broken tables causing issues.

Part of this broken ACPI code is that sometimes these boards have _AEI
ACPI GPIO event handlers which are broken.

So far this has been dealt with in the platform/x86/x86-android-tablets.c
module, which contains various workarounds for these devices, by it calling
acpi_gpiochip_free_interrupts() on gpiochip-s with troublesome handlers to
disable the handlers.

But in some cases this is too late, if the handlers are of the edge type
then gpiolib-acpi.c's code will already have run them at boot.
This can cause issues such as GPIOs ending up as owned by "ACPI:OpRegion",
making them unavailable for drivers which actually need them.

Boards with these broken ACPI tables are already listed in
drivers/acpi/x86/utils.c for e.g. acpi_quirk_skip_i2c_client_enumeration().
Extend the quirks mechanism for a new acpi_quirk_skip_gpio_event_handlers()
helper, this re-uses the DMI-ids rather then having to duplicate the same
DMI table in gpiolib-acpi.c .

Also add the new ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS quirk to existing
boards with troublesome ACPI gpio event handlers, so that the current
acpi_gpiochip_free_interrupts() hack can be removed from
x86-android-tablets.c .

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c    | 24 +++++++++++++++++++++---
 drivers/gpio/gpiolib-acpi.c |  3 +++
 include/acpi/acpi_bus.h     |  5 +++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 4e816bb402f68..4a6f3a6726d04 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -262,6 +262,7 @@ bool force_storage_d3(void)
 #define ACPI_QUIRK_UART1_TTY_UART2_SKIP				BIT(1)
 #define ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY			BIT(2)
 #define ACPI_QUIRK_USE_ACPI_AC_AND_BATTERY			BIT(3)
+#define ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS			BIT(4)
 
 static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 	/*
@@ -297,7 +298,8 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_UART1_TTY_UART2_SKIP |
-					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
 		.matches = {
@@ -305,7 +307,8 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "TF103C"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
-					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
 		/* Lenovo Yoga Tablet 2 1050F/L */
@@ -347,7 +350,8 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M890BAP"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
-					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
 		/* Whitelabel (sold as various brands) TM800A550L */
@@ -424,6 +428,20 @@ int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *s
 	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_quirk_skip_serdev_enumeration);
+
+bool acpi_quirk_skip_gpio_event_handlers(void)
+{
+	const struct dmi_system_id *dmi_id;
+	long quirks;
+
+	dmi_id = dmi_first_match(acpi_quirk_skip_dmi_ids);
+	if (!dmi_id)
+		return false;
+
+	quirks = (unsigned long)dmi_id->driver_data;
+	return (quirks & ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS);
+}
+EXPORT_SYMBOL_GPL(acpi_quirk_skip_gpio_event_handlers);
 #endif
 
 /* Lists of PMIC ACPI HIDs with an (often better) native charger driver */
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 34ff048e70d0e..7c9175619a1dc 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -536,6 +536,9 @@ void acpi_gpiochip_request_interrupts(struct gpio_chip *chip)
 	if (ACPI_FAILURE(status))
 		return;
 
+	if (acpi_quirk_skip_gpio_event_handlers())
+		return;
+
 	acpi_walk_resources(handle, METHOD_NAME__AEI,
 			    acpi_gpiochip_alloc_event, acpi_gpio);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0584e9f6e3397..57acb895c0381 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -657,6 +657,7 @@ static inline bool acpi_quirk_skip_acpi_ac_and_battery(void)
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev);
 int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip);
+bool acpi_quirk_skip_gpio_event_handlers(void);
 #else
 static inline bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev)
 {
@@ -668,6 +669,10 @@ acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
 	*skip = false;
 	return 0;
 }
+static inline bool acpi_quirk_skip_gpio_event_handlers(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_PM
-- 
2.39.2

