Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94562B5D5A
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfIRGUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfIRGUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416A721928;
        Wed, 18 Sep 2019 06:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787619;
        bh=rhAte9qVBWPhJ9vWxMQxwzWyDhD0daBzEHcmYKeCx9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gv9ivrmp2OyOKcS3uo6i/obpqC3fgt6EfR6Vhsi1o1Y71fabls0/8kV9XcBRq2vk/
         nPuw98KAopBxuqKf+x8KFMhvyw4f4/EF6a4hDOF+M/XNSYUvbAl/EqyRVazIsgJRQY
         DCVbbG4YbJoORPdX4oJDnZ3wrXK1OR6gZGvLtHt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 17/45] gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist
Date:   Wed, 18 Sep 2019 08:18:55 +0200
Message-Id: <20190918061224.689119365@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 61f7f7c8f978b1c0d80e43c83b7d110ca0496eb4 upstream.

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
Link: https://lore.kernel.org/r/20190827202835.213456-1-hdegoede@redhat.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Ian W MORRISON <ianwmorrison@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
@@ -23,6 +24,11 @@
 
 #include "gpiolib.h"
 
+static int run_edge_events_on_boot = -1;
+module_param(run_edge_events_on_boot, int, 0444);
+MODULE_PARM_DESC(run_edge_events_on_boot,
+		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -231,10 +237,13 @@ static void acpi_gpiochip_request_irq(st
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
@@ -1302,3 +1311,28 @@ static int acpi_gpio_handle_deferred_req
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


