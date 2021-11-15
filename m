Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A10451E29
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345601AbhKPAfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344654AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50565636A7;
        Mon, 15 Nov 2021 19:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002893;
        bh=1dHm21T4UeTtSEIeJiM96XflCawUHcWq5TUazqyfz2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVoeYcqnSBnHd4zzLmmpP+JkCs620LIpIBdreDvNEWByf/Z9EwW5o2mHNLlem7FW0
         3tI/8qvg5tTcY/ugfb+A1hOEzdXUh+sQk2uxuZ4LPsx7/BQtZ5QZ887e+OP5KJDOQ4
         4PFr/ZJVelvizVyIHJoRfxGMCo8zGuau0XTaUpt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Robin van der Gracht <robin@protonic.nl>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 734/917] auxdisplay: ht16k33: Connect backlight to fbdev
Date:   Mon, 15 Nov 2021 18:03:49 +0100
Message-Id: <20211115165453.807810344@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 80f9eb70fd9276938f0a131f76d438021bfd8b34 ]

Currently /sys/class/graphics/fb0/bl_curve is not accessible (-ENODEV),
as the driver does not connect the backlight to the frame buffer device.
Fix this moving backlight initialization up, and filling in
fb_info.bl_dev.

Fixes: 8992da44c6805d53 ("auxdisplay: ht16k33: Driver for LED controller")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Robin van der Gracht <robin@protonic.nl>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 56 ++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index 1e69cc6d21a0d..2b630e194570f 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -413,6 +413,33 @@ static int ht16k33_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
+	/* Backlight */
+	memset(&bl_props, 0, sizeof(struct backlight_properties));
+	bl_props.type = BACKLIGHT_RAW;
+	bl_props.max_brightness = MAX_BRIGHTNESS;
+
+	bl = devm_backlight_device_register(&client->dev, DRIVER_NAME"-bl",
+					    &client->dev, priv,
+					    &ht16k33_bl_ops, &bl_props);
+	if (IS_ERR(bl)) {
+		dev_err(&client->dev, "failed to register backlight\n");
+		return PTR_ERR(bl);
+	}
+
+	err = of_property_read_u32(node, "default-brightness-level",
+				   &dft_brightness);
+	if (err) {
+		dft_brightness = MAX_BRIGHTNESS;
+	} else if (dft_brightness > MAX_BRIGHTNESS) {
+		dev_warn(&client->dev,
+			 "invalid default brightness level: %u, using %u\n",
+			 dft_brightness, MAX_BRIGHTNESS);
+		dft_brightness = MAX_BRIGHTNESS;
+	}
+
+	bl->props.brightness = dft_brightness;
+	ht16k33_bl_update_status(bl);
+
 	/* Framebuffer (2 bytes per column) */
 	BUILD_BUG_ON(PAGE_SIZE < HT16K33_FB_SIZE);
 	fbdev->buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
@@ -445,6 +472,7 @@ static int ht16k33_probe(struct i2c_client *client,
 	fbdev->info->screen_size = HT16K33_FB_SIZE;
 	fbdev->info->fix = ht16k33_fb_fix;
 	fbdev->info->var = ht16k33_fb_var;
+	fbdev->info->bl_dev = bl;
 	fbdev->info->pseudo_palette = NULL;
 	fbdev->info->flags = FBINFO_FLAG_DEFAULT;
 	fbdev->info->par = priv;
@@ -460,34 +488,6 @@ static int ht16k33_probe(struct i2c_client *client,
 			goto err_fbdev_unregister;
 	}
 
-	/* Backlight */
-	memset(&bl_props, 0, sizeof(struct backlight_properties));
-	bl_props.type = BACKLIGHT_RAW;
-	bl_props.max_brightness = MAX_BRIGHTNESS;
-
-	bl = devm_backlight_device_register(&client->dev, DRIVER_NAME"-bl",
-					    &client->dev, priv,
-					    &ht16k33_bl_ops, &bl_props);
-	if (IS_ERR(bl)) {
-		dev_err(&client->dev, "failed to register backlight\n");
-		err = PTR_ERR(bl);
-		goto err_fbdev_unregister;
-	}
-
-	err = of_property_read_u32(node, "default-brightness-level",
-				   &dft_brightness);
-	if (err) {
-		dft_brightness = MAX_BRIGHTNESS;
-	} else if (dft_brightness > MAX_BRIGHTNESS) {
-		dev_warn(&client->dev,
-			 "invalid default brightness level: %u, using %u\n",
-			 dft_brightness, MAX_BRIGHTNESS);
-		dft_brightness = MAX_BRIGHTNESS;
-	}
-
-	bl->props.brightness = dft_brightness;
-	ht16k33_bl_update_status(bl);
-
 	ht16k33_fb_queue(priv);
 	return 0;
 
-- 
2.33.0



