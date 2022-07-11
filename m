Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C248F56FC30
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiGKJkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiGKJjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E4B8BABA;
        Mon, 11 Jul 2022 02:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4ECFB80E7F;
        Mon, 11 Jul 2022 09:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C7C341C8;
        Mon, 11 Jul 2022 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531225;
        bh=JPi6v8SZVxEJ7mpJWPM6iNC6XWALF0V4uRUwE8A4Gzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdJqfgcGvIkt6RowjmJk6xZwTxaqNlOa6G/HewTRT65018Lu5ScEDzP5z4sjBr8pg
         A1vlyzzWVsN2ekVt5ACTcyvCAg2oGXpsG+zYevm2Gq1UHwT5lzUjKFPgJQi7KwdbZ8
         aFC+/4KO5EOSyQtB3PbdPD/2SqbYR/TAu8OWWLsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/230] Input: goodix - try not to touch the reset-pin on x86/ACPI devices
Date:   Mon, 11 Jul 2022 11:04:44 +0200
Message-Id: <20220711090604.876835870@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a2fd46cd3dbb83b373ba74f4043f8dae869c65f1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 30 +++++++++++++++++++++++++-----
 drivers/input/touchscreen/goodix.h |  1 +
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 2ca903a8af21..3667f7e51fde 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -640,10 +640,16 @@ int goodix_reset_no_int_sync(struct goodix_ts_data *ts)
 
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
 
@@ -777,6 +783,14 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
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
@@ -802,6 +816,12 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
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
@@ -839,7 +859,7 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
 	ts->gpiod_int = gpiod;
 
 	/* Get the reset line GPIO pin number */
-	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, GPIOD_IN);
+	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, ts->gpiod_rst_flags);
 	if (IS_ERR(gpiod)) {
 		error = PTR_ERR(gpiod);
 		if (error != -EPROBE_DEFER)
diff --git a/drivers/input/touchscreen/goodix.h b/drivers/input/touchscreen/goodix.h
index 0b88554ba2ae..1a1571ad2cd2 100644
--- a/drivers/input/touchscreen/goodix.h
+++ b/drivers/input/touchscreen/goodix.h
@@ -51,6 +51,7 @@ struct goodix_ts_data {
 	struct gpio_desc *gpiod_rst;
 	int gpio_count;
 	int gpio_int_idx;
+	enum gpiod_flags gpiod_rst_flags;
 	char id[GOODIX_ID_MAX_LEN + 1];
 	u16 version;
 	const char *cfg_name;
-- 
2.35.1



