Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB2347FC23
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhL0LTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:19:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39290 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhL0LTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:19:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0A1E60F15
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A19C36AE7;
        Mon, 27 Dec 2021 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640603952;
        bh=W9Sa5ywbb8AmTzRNkEHYAHwNh2nXfPqpB3R2SJrTgtI=;
        h=Subject:To:Cc:From:Date:From;
        b=y5hy9Ct99uUruESaqfC0IEtI9c9LF2VqDg120mcrVDP/jjfx+BmxMSf7zCSIT8N7B
         luMRR/vG5RsKtFxn8IXEYnSqB4a//dgNGsXDGCYfS2Op8bOzxYrDIjsxckqKytoQtq
         +r5x7AxVmsdcNhZlHrhq4h6Z1tYKpslUC0HgB6sc=
Subject: FAILED: patch "[PATCH] Input: goodix - try not to touch the reset-pin on x86/ACPI" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com, dmitry.torokhov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 12:19:01 +0100
Message-ID: <164060394184243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a2fd46cd3dbb83b373ba74f4043f8dae869c65f1 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 6 Dec 2021 23:15:09 -0800
Subject: [PATCH] Input: goodix - try not to touch the reset-pin on x86/ACPI
 devices

Unless the controller is not responding at boot or after suspend/resume,
the driver never resets the controller on x86/ACPI platforms. The driver
still requesting the reset pin at probe() though in case it needs it.

Until now the driver has always requested the reset pin with GPIOD_IN
as type. The idea being to put the pin in high-impedance mode to save
power until the driver actually wants to issue a reset.

But this means that just requesting the pin can cause issues, since
requesting it in another mode then GPIOD_ASIS may cause the pinctrl
driver to touch the pin settings. We have already had issues before
due to a bug in the pinctrl-cherryview.c driver which has been fixed in
commit 921daeeca91b ("pinctrl: cherryview: Preserve
CHV_PADCTRL1_INVRXTX_TXDATA flag on GPIOs").

And now it turns out that requesting the reset-pin as GPIOD_IN also stops
the touchscreen from working on the GPD P2 max mini-laptop. The behavior
of putting the pin in high-impedance mode relies on there being some
external pull-up to keep it high and there seems to be no pull-up on the
GPD P2 max, causing things to break.

This commit fixes this by requesting the reset pin as is when using
the x86/ACPI code paths to lookup the GPIOs; and by not dropping it
back into input-mode in case the driver does end up issuing a reset
for error-recovery.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209061
Fixes: a7d4b171660c ("Input: goodix - add support for getting IRQ + reset GPIOs on Cherry Trail devices")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211206091116.44466-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 906b5a6b52d1..e7efc32043e7 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -695,10 +695,16 @@ int goodix_reset_no_int_sync(struct goodix_ts_data *ts)
 
 	usleep_range(6000, 10000);		/* T4: > 5ms */
 
-	/* end select I2C slave addr */
-	error = gpiod_direction_input(ts->gpiod_rst);
-	if (error)
-		goto error;
+	/*
+	 * Put the reset pin back in to input / high-impedance mode to save
+	 * power. Only do this in the non ACPI case since some ACPI boards
+	 * don't have a pull-up, so there the reset pin must stay active-high.
+	 */
+	if (ts->irq_pin_access_method == IRQ_PIN_ACCESS_GPIO) {
+		error = gpiod_direction_input(ts->gpiod_rst);
+		if (error)
+			goto error;
+	}
 
 	return 0;
 
@@ -832,6 +838,14 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		return -EINVAL;
 	}
 
+	/*
+	 * Normally we put the reset pin in input / high-impedance mode to save
+	 * power. But some x86/ACPI boards don't have a pull-up, so for the ACPI
+	 * case, leave the pin as is. This results in the pin not being touched
+	 * at all on x86/ACPI boards, except when needed for error-recover.
+	 */
+	ts->gpiod_rst_flags = GPIOD_ASIS;
+
 	return devm_acpi_dev_add_driver_gpios(dev, gpio_mapping);
 }
 #else
@@ -857,6 +871,12 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
 		return -EINVAL;
 	dev = &ts->client->dev;
 
+	/*
+	 * By default we request the reset pin as input, leaving it in
+	 * high-impedance when not resetting the controller to save power.
+	 */
+	ts->gpiod_rst_flags = GPIOD_IN;
+
 	ts->avdd28 = devm_regulator_get(dev, "AVDD28");
 	if (IS_ERR(ts->avdd28)) {
 		error = PTR_ERR(ts->avdd28);
@@ -894,7 +914,7 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
 	ts->gpiod_int = gpiod;
 
 	/* Get the reset line GPIO pin number */
-	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, GPIOD_IN);
+	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, ts->gpiod_rst_flags);
 	if (IS_ERR(gpiod)) {
 		error = PTR_ERR(gpiod);
 		if (error != -EPROBE_DEFER)
diff --git a/drivers/input/touchscreen/goodix.h b/drivers/input/touchscreen/goodix.h
index 62138f930d1a..02065d1c3263 100644
--- a/drivers/input/touchscreen/goodix.h
+++ b/drivers/input/touchscreen/goodix.h
@@ -87,6 +87,7 @@ struct goodix_ts_data {
 	struct gpio_desc *gpiod_rst;
 	int gpio_count;
 	int gpio_int_idx;
+	enum gpiod_flags gpiod_rst_flags;
 	char id[GOODIX_ID_MAX_LEN + 1];
 	char cfg_name[64];
 	u16 version;

