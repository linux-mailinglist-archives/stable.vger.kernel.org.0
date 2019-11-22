Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A348C106E7E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfKVLCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731023AbfKVLCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD458207FA;
        Fri, 22 Nov 2019 11:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420572;
        bh=eHQG1+45UnU0f2+tIK6SyHL4QPGWNo5WyA4FhoQxtTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3nKADSxQVzPkG2n+ptOA1HEdul8Rm0arjl2MJ5KJ3cDynQjB7n2gQJYmPbJ/a4Uo
         bekQybriS15IlWUKhjal1j86v0Y6ViElMte6W+6j2ot48fiI3Vq0ZQSdIAk80A/opc
         GHEyxEfQGkNNisgPEHdvepL2Od1lSzDEAaYm3q34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/220] atmel_lcdfb: support native-mode display-timings
Date:   Fri, 22 Nov 2019 11:28:36 +0100
Message-Id: <20191122100923.595617511@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



