Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9119513A61F
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgANKJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729817AbgANKJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:09:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61ED5207FF;
        Tue, 14 Jan 2020 10:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996566;
        bh=gKvv+/SrsS+y93wpbqPaEa5gVBCDz92L2kQPTaV/LFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOUkZC+odxFGkCeXaTYUgANLd2aooNp9yCXUaoR0gJYdmkxPNeMwPMby/FgqN4ebC
         LDCKpiuEKbo0TodONo1rmwMTbg22QM2v9kggrRGQyT5z3ohXDmT4BceLcx8hGVGBgF
         RxTh04cIqQ2zYWXsKiMCx8KLUICNuFj09q/Ke3FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 14/39] gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism
Date:   Tue, 14 Jan 2020 11:01:48 +0100
Message-Id: <20200114094342.309028889@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit aa23ca3d98f756d5b1e503fb140665fb24a41a38 upstream.

On some laptops enabling wakeup on the GPIO interrupts used for ACPI _AEI
event handling causes spurious wakeups.

This commit adds a new honor_wakeup option, defaulting to true (our current
behavior), which can be used to disable wakeup on troublesome hardware
to avoid these spurious wakeups.

This is a workaround for an architectural problem with s2idle under Linux
where we do not have any mechanism to immediately go back to sleep after
wakeup events, other then for embedded-controller events using the standard
ACPI EC interface, for details see:
https://lore.kernel.org/linux-acpi/61450f9b-cbc6-0c09-8b3a-aff6bf9a0b3c@redhat.com/

One series of laptops which is not able to suspend without this workaround
is the HP x2 10 Cherry Trail models, this commit adds a DMI based quirk
which makes sets honor_wakeup to false on these models.

Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200105160357.97154-3-hdegoede@redhat.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -25,12 +25,18 @@
 #include "gpiolib.h"
 
 #define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
+#define QUIRK_NO_WAKEUP				0x02l
 
 static int run_edge_events_on_boot = -1;
 module_param(run_edge_events_on_boot, int, 0444);
 MODULE_PARM_DESC(run_edge_events_on_boot,
 		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
 
+static int honor_wakeup = -1;
+module_param(honor_wakeup, int, 0444);
+MODULE_PARM_DESC(honor_wakeup,
+		 "Honor the ACPI wake-capable flag: 0=no, 1=yes, -1=auto");
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -341,7 +347,7 @@ static acpi_status acpi_gpiochip_alloc_e
 	event->handle = evt_handle;
 	event->handler = handler;
 	event->irq = irq;
-	event->irq_is_wake = agpio->wake_capable == ACPI_WAKE_CAPABLE;
+	event->irq_is_wake = honor_wakeup && agpio->wake_capable == ACPI_WAKE_CAPABLE;
 	event->pin = pin;
 	event->desc = desc;
 
@@ -1340,6 +1346,23 @@ static const struct dmi_system_id gpioli
 		},
 		.driver_data = (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
+	{
+		/*
+		 * Various HP X2 10 Cherry Trail models use an external
+		 * embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler. The embedded controller generates various
+		 * spurious wakeup events when suspended. So disable wakeup
+		 * for its handler (it uses the only ACPI GPIO event handler).
+		 * This breaks wakeup when opening the lid, the user needs
+		 * to press the power-button to wakeup the system. The
+		 * alternative is suspend simply not working, which is worse.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP x2 Detachable 10-p0XX"),
+		},
+		.driver_data = (void *)QUIRK_NO_WAKEUP,
+	},
 	{} /* Terminating entry */
 };
 
@@ -1359,6 +1382,13 @@ static int acpi_gpio_setup_params(void)
 			run_edge_events_on_boot = 1;
 	}
 
+	if (honor_wakeup < 0) {
+		if (quirks & QUIRK_NO_WAKEUP)
+			honor_wakeup = 0;
+		else
+			honor_wakeup = 1;
+	}
+
 	return 0;
 }
 


