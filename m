Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2CCFA4FC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfKMByP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbfKMByP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A244222D4;
        Wed, 13 Nov 2019 01:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610054;
        bh=eHQG1+45UnU0f2+tIK6SyHL4QPGWNo5WyA4FhoQxtTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLswZrtJqORMUQf/Cqs3YmnI48Ykf0eoje1KmUp+eb+jAX7CBnxfT7apNrS5f/Ibn
         Pd77R3dbjxv8bmW0Cq5htR1YIDxkO+WB2ILMT6j3slnBbceSD1a8KNNlGJ8K4dihfT
         Wnw5Zge6DJM5gmK2MGbksdug7hWeCx672zUAqSKc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 140/209] atmel_lcdfb: support native-mode display-timings
Date:   Tue, 12 Nov 2019 20:49:16 -0500
Message-Id: <20191113015025.9685-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit 60e5e48dba72c6b59a7a9c7686ba320766913368 ]

When a device tree set a display-timing using native-mode
then according to the bindings doc this should:

    native-mode:
    The native mode for the display, in case multiple
    modes are provided.
    When omitted, assume the first node is the native.

The atmel_lcdfb used the last timing subnode and did not
respect the timing mode specified with native-mode.

Introduce use of of_get_videomode() which allowed
a nice simplification of the code while also
added support for native-mode.

As a nice side-effect this fixes a memory leak where the
data used for timings and the display_np was not freed.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atmel_lcdfb.c | 43 +++++++------------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index 076d24afbd728..4ed55e6bbb840 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <video/of_videomode.h>
 #include <video/of_display_timing.h>
 #include <linux/regulator/consumer.h>
 #include <video/videomode.h>
@@ -1028,11 +1029,11 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 	struct device *dev = &sinfo->pdev->dev;
 	struct device_node *np =dev->of_node;
 	struct device_node *display_np;
-	struct device_node *timings_np;
-	struct display_timings *timings;
 	struct atmel_lcdfb_power_ctrl_gpio *og;
 	bool is_gpio_power = false;
+	struct fb_videomode fb_vm;
 	struct gpio_desc *gpiod;
+	struct videomode vm;
 	int ret = -ENOENT;
 	int i;
 
@@ -1105,44 +1106,18 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 	pdata->lcdcon_is_backlight = of_property_read_bool(display_np, "atmel,lcdcon-backlight");
 	pdata->lcdcon_pol_negative = of_property_read_bool(display_np, "atmel,lcdcon-backlight-inverted");
 
-	timings = of_get_display_timings(display_np);
-	if (!timings) {
-		dev_err(dev, "failed to get display timings\n");
-		ret = -EINVAL;
+	ret = of_get_videomode(display_np, &vm, OF_USE_NATIVE_MODE);
+	if (ret) {
+		dev_err(dev, "failed to get videomode from DT\n");
 		goto put_display_node;
 	}
 
-	timings_np = of_get_child_by_name(display_np, "display-timings");
-	if (!timings_np) {
-		dev_err(dev, "failed to find display-timings node\n");
-		ret = -ENODEV;
+	ret = fb_videomode_from_videomode(&vm, &fb_vm);
+	if (ret < 0)
 		goto put_display_node;
-	}
 
-	for (i = 0; i < of_get_child_count(timings_np); i++) {
-		struct videomode vm;
-		struct fb_videomode fb_vm;
-
-		ret = videomode_from_timings(timings, &vm, i);
-		if (ret < 0)
-			goto put_timings_node;
-		ret = fb_videomode_from_videomode(&vm, &fb_vm);
-		if (ret < 0)
-			goto put_timings_node;
-
-		fb_add_videomode(&fb_vm, &info->modelist);
-	}
-
-	/*
-	 * FIXME: Make sure we are not referencing any fields in display_np
-	 * and timings_np and drop our references to them before returning to
-	 * avoid leaking the nodes on probe deferral and driver unbind.
-	 */
-
-	return 0;
+	fb_add_videomode(&fb_vm, &info->modelist);
 
-put_timings_node:
-	of_node_put(timings_np);
 put_display_node:
 	of_node_put(display_np);
 	return ret;
-- 
2.20.1

