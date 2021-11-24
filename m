Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEEE45C0E5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348077AbhKXNMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347598AbhKXNKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:10:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EEF6121D;
        Wed, 24 Nov 2021 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757688;
        bh=fCqoMLll5hUI6sPzR7Jco/XfASlsujsfWai++crthlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Woy1z8GXgkAVeCa4o/J4AvSg/vb/lyRdrbwvttUHHmeiGWZe/ujQ5FyKsKqTI2bj/
         AOdapdTFNV0hrnQpdRsfXIzwudBmAvkd8WozCXwFYH+JQ1u+8TpNYoK8kPW3SEJhJG
         Dl28eAb4Q9uGZXdATi0y34h18lifo0MG/vW43Ayg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 244/323] backlight: gpio-backlight: Correct initial power state handling
Date:   Wed, 24 Nov 2021 12:57:14 +0100
Message-Id: <20211124115727.147089219@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit ec665b756e6f79c60078b00dbdabea3aa8a4b787 upstream.

The default-on property - or the def_value via legacy pdata) should be
handled as:
if it is 1, the backlight must be enabled (kept enabled)
if it is 0, the backlight must be disabled (kept disabled)

This only works for the case when default-on is set. If it is not set then
the brightness of the backlight is set to 0. Now if the backlight is
enabled by external driver (graphics) the backlight will stay disabled since
the brightness is configured as 0. The backlight will not turn on.

In order to minimize screen flickering during device boot:

The initial brightness should be set to 1.

If booted in non DT mode or no phandle link to the backlight node:
follow the def_value/default-on to select UNBLANK or POWERDOWN

If in DT boot we have phandle link then leave the GPIO in a state which the
bootloader left it and let the user of the backlight to configure it
further.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/gpio_backlight.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -62,13 +62,11 @@ static int gpio_backlight_probe_dt(struc
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
-	enum gpiod_flags flags;
 	int ret;
 
 	gbl->def_value = of_property_read_bool(np, "default-on");
-	flags = gbl->def_value ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW;
 
-	gbl->gpiod = devm_gpiod_get(dev, NULL, flags);
+	gbl->gpiod = devm_gpiod_get(dev, NULL, GPIOD_ASIS);
 	if (IS_ERR(gbl->gpiod)) {
 		ret = PTR_ERR(gbl->gpiod);
 
@@ -82,6 +80,22 @@ static int gpio_backlight_probe_dt(struc
 	return 0;
 }
 
+static int gpio_backlight_initial_power_state(struct gpio_backlight *gbl)
+{
+	struct device_node *node = gbl->dev->of_node;
+
+	/* Not booted with device tree or no phandle link to the node */
+	if (!node || !node->phandle)
+		return gbl->def_value ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
+
+	/* if the enable GPIO is disabled, do not enable the backlight */
+	if (gpiod_get_value_cansleep(gbl->gpiod) == 0)
+		return FB_BLANK_POWERDOWN;
+
+	return FB_BLANK_UNBLANK;
+}
+
+
 static int gpio_backlight_probe(struct platform_device *pdev)
 {
 	struct gpio_backlight_platform_data *pdata =
@@ -142,7 +156,9 @@ static int gpio_backlight_probe(struct p
 		return PTR_ERR(bl);
 	}
 
-	bl->props.brightness = gbl->def_value;
+	bl->props.power = gpio_backlight_initial_power_state(gbl);
+	bl->props.brightness = 1;
+
 	backlight_update_status(bl);
 
 	platform_set_drvdata(pdev, bl);


