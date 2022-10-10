Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092075F98F6
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiJJHE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiJJHEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4E257214;
        Mon, 10 Oct 2022 00:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5EF60E08;
        Mon, 10 Oct 2022 07:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD1BC4347C;
        Mon, 10 Oct 2022 07:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385448;
        bh=p/a7Ck13eilhvSGzMf34OEY+FhQIKCwPRX08CU6DU38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEzVlqmaG6uWNr7+WQwA/wPTZ8bmeLJ2C8YM07Dt0WD+GIjYXheEuJDY8seivv69J
         xByNrdC0Ozun7ne/IXAGDLUR+TikqEXIeTLQ7/QuNXgnoRB/2H5i0+nHBIeBCYa+1U
         FwQ1lCUfvK44g40f2/4Pac3MwDm23Ck8PHGnlwf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.0 11/17] gpiolib: acpi: Add support to ignore programming an interrupt
Date:   Mon, 10 Oct 2022 09:04:34 +0200
Message-Id: <20221010070330.541193431@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 6b6af7bd5718f4e45a9b930533aec1158387d552 upstream.

gpiolib-acpi already had support for ignoring a pin for wakeup, but
if an OEM configures a floating pin as an interrupt source then
stopping it from being a wakeup won't do much good to stop the
interrupt storm.

Add support for a module parameter and quirk infrastructure to
ignore interrupts as well.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -32,9 +32,16 @@ MODULE_PARM_DESC(ignore_wake,
 		 "controller@pin combos on which to ignore the ACPI wake flag "
 		 "ignore_wake=controller@pin[,controller@pin[,...]]");
 
+static char *ignore_interrupt;
+module_param(ignore_interrupt, charp, 0444);
+MODULE_PARM_DESC(ignore_interrupt,
+		 "controller@pin combos on which to ignore interrupt "
+		 "ignore_interrupt=controller@pin[,controller@pin[,...]]");
+
 struct acpi_gpiolib_dmi_quirk {
 	bool no_edge_events_on_boot;
 	char *ignore_wake;
+	char *ignore_interrupt;
 };
 
 /**
@@ -317,14 +324,15 @@ static struct gpio_desc *acpi_request_ow
 	return desc;
 }
 
-static bool acpi_gpio_in_ignore_list(const char *controller_in, unsigned int pin_in)
+static bool acpi_gpio_in_ignore_list(const char *ignore_list, const char *controller_in,
+				     unsigned int pin_in)
 {
 	const char *controller, *pin_str;
 	unsigned int pin;
 	char *endp;
 	int len;
 
-	controller = ignore_wake;
+	controller = ignore_list;
 	while (controller) {
 		pin_str = strchr(controller, '@');
 		if (!pin_str)
@@ -348,7 +356,7 @@ static bool acpi_gpio_in_ignore_list(con
 
 	return false;
 err:
-	pr_err_once("Error: Invalid value for gpiolib_acpi.ignore_wake: %s\n", ignore_wake);
+	pr_err_once("Error: Invalid value for gpiolib_acpi.ignore_...: %s\n", ignore_list);
 	return false;
 }
 
@@ -360,7 +368,7 @@ static bool acpi_gpio_irq_is_wake(struct
 	if (agpio->wake_capable != ACPI_WAKE_CAPABLE)
 		return false;
 
-	if (acpi_gpio_in_ignore_list(dev_name(parent), pin)) {
+	if (acpi_gpio_in_ignore_list(ignore_wake, dev_name(parent), pin)) {
 		dev_info(parent, "Ignoring wakeup on pin %u\n", pin);
 		return false;
 	}
@@ -427,6 +435,11 @@ static acpi_status acpi_gpiochip_alloc_e
 		goto fail_unlock_irq;
 	}
 
+	if (acpi_gpio_in_ignore_list(ignore_interrupt, dev_name(chip->parent), pin)) {
+		dev_info(chip->parent, "Ignoring interrupt on pin %u\n", pin);
+		return AE_OK;
+	}
+
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
 		goto fail_unlock_irq;
@@ -1585,6 +1598,9 @@ static int __init acpi_gpio_setup_params
 	if (ignore_wake == NULL && quirk && quirk->ignore_wake)
 		ignore_wake = quirk->ignore_wake;
 
+	if (ignore_interrupt == NULL && quirk && quirk->ignore_interrupt)
+		ignore_interrupt = quirk->ignore_interrupt;
+
 	return 0;
 }
 


