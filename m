Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3213A600
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730705AbgANKHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgANKHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:07:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4874724680;
        Tue, 14 Jan 2020 10:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996455;
        bh=1b0Luv39zPdutEiUSX0IUUF9+gt/vZ658w3BW9a2FQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxs4QmB5dpJikfFFN+hczaIxsb03Em0P7Og4SiEEQxsVXk55zATQvrfb6ghc1am3t
         ggj3Wcv4zEhZFST9HgVY049ZtrDLdHgavE5+o3O6P8UJ0gCi1DnsGgwXzco1qFf6rR
         kJyZ6eeVqIvxaRmfHOhBlFGeFo4xuvD48KK3JT3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 23/46] gpiolib: acpi: Turn dmi_system_id table into a generic quirk table
Date:   Tue, 14 Jan 2020 11:01:40 +0100
Message-Id: <20200114094345.178892638@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 1ad1b54099c231aed8f6f257065c1b322583f264 upstream.

Turn the existing run_edge_events_on_boot_blacklist dmi_system_id table
into a generic quirk table, storing the quirks in the driver_data ptr.

This is a preparation patch for adding other types of (DMI based) quirks.

Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200105160357.97154-2-hdegoede@redhat.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -24,6 +24,8 @@
 
 #include "gpiolib.h"
 
+#define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
+
 static int run_edge_events_on_boot = -1;
 module_param(run_edge_events_on_boot, int, 0444);
 MODULE_PARM_DESC(run_edge_events_on_boot,
@@ -1263,7 +1265,7 @@ static int acpi_gpio_handle_deferred_req
 /* We must use _sync so that this runs after the first deferred_probe run */
 late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
 
-static const struct dmi_system_id run_edge_events_on_boot_blacklist[] = {
+static const struct dmi_system_id gpiolib_acpi_quirks[] = {
 	{
 		/*
 		 * The Minix Neo Z83-4 has a micro-USB-B id-pin handler for
@@ -1273,7 +1275,8 @@ static const struct dmi_system_id run_ed
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
-		}
+		},
+		.driver_data = (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
 	{
 		/*
@@ -1285,15 +1288,23 @@ static const struct dmi_system_id run_ed
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Wortmann_AG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "TERRA_PAD_1061"),
-		}
+		},
+		.driver_data = (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
 	{} /* Terminating entry */
 };
 
 static int acpi_gpio_setup_params(void)
 {
+	const struct dmi_system_id *id;
+	long quirks = 0;
+
+	id = dmi_first_match(gpiolib_acpi_quirks);
+	if (id)
+		quirks = (long)id->driver_data;
+
 	if (run_edge_events_on_boot < 0) {
-		if (dmi_check_system(run_edge_events_on_boot_blacklist))
+		if (quirks & QUIRK_NO_EDGE_EVENTS_ON_BOOT)
 			run_edge_events_on_boot = 0;
 		else
 			run_edge_events_on_boot = 1;


