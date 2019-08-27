Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186D59F419
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 22:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbfH0U2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 16:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0U2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 16:28:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47D31300C035;
        Tue, 27 Aug 2019 20:28:39 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EA8460CC0;
        Tue, 27 Aug 2019 20:28:37 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH v2] gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist
Date:   Tue, 27 Aug 2019 22:28:35 +0200
Message-Id: <20190827202835.213456-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 27 Aug 2019 20:28:39 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Another day; another DSDT bug we need to workaround...

Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
at least once on boot") we call _AEI edge handlers at boot.

In some rare cases this causes problems. One example of this is the Minix
Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
and pasted code for dealing with Micro USB-B connector host/device role
switching, while the mini PC does not even have a micro-USB connector.
This code, which should not be there, messes with the DDC data pin from
the HDMI connector (switching it to GPIO mode) breaking HDMI support.

To avoid problems like this, this commit adds a new
gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
allows disabling the running of _AEI edge event handlers at boot.

The default value is -1/auto which uses a DMI based blacklist, the initial
version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.

Cc: stable@vger.kernel.org
Cc: Daniel Drake <drake@endlessm.com>
Cc: Ian W MORRISON <ianwmorrison@gmail.com>
Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Use a module_param instead of __setup
- Do DMI check only once from a postcore_initcall
---
 drivers/gpio/gpiolib-acpi.c | 42 +++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 39f2f9035c11..bda28eb82c3f 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -7,6 +7,7 @@
  *          Mika Westerberg <mika.westerberg@linux.intel.com>
  */
 
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
@@ -19,6 +20,11 @@
 
 #include "gpiolib.h"
 
+static int run_edge_events_on_boot = -1;
+module_param(run_edge_events_on_boot, int, 0444);
+MODULE_PARM_DESC(run_edge_events_on_boot,
+		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -170,10 +176,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 	event->irq_requested = true;
 
 	/* Make sure we trigger the initial state of edge-triggered IRQs */
-	value = gpiod_get_raw_value_cansleep(event->desc);
-	if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
-	    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
-		event->handler(event->irq, event);
+	if (run_edge_events_on_boot &&
+	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
+		value = gpiod_get_raw_value_cansleep(event->desc);
+		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
+		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
+			event->handler(event->irq, event);
+	}
 }
 
 static void acpi_gpiochip_request_irqs(struct acpi_gpio_chip *acpi_gpio)
@@ -1283,3 +1292,28 @@ static int acpi_gpio_handle_deferred_request_irqs(void)
 }
 /* We must use _sync so that this runs after the first deferred_probe run */
 late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
+
+static const struct dmi_system_id run_edge_events_on_boot_blacklist[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
+		}
+	},
+	{} /* Terminating entry */
+};
+
+static int acpi_gpio_setup_params(void)
+{
+	if (run_edge_events_on_boot < 0) {
+		if (dmi_check_system(run_edge_events_on_boot_blacklist))
+			run_edge_events_on_boot = 0;
+		else
+			run_edge_events_on_boot = 1;
+	}
+
+	return 0;
+}
+
+/* Directly after dmi_setup() which runs as core_initcall() */
+postcore_initcall(acpi_gpio_setup_params);
-- 
2.23.0

