Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C405D4469EC
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhKEUqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:46:45 -0400
Received: from asav22.altibox.net ([109.247.116.9]:36178 "EHLO
        asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhKEUqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:46:44 -0400
Received: from localhost.localdomain (211.81-166-168.customer.lyse.net [81.166.168.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: noralf.tronnes@ebnett.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id C616520A19;
        Fri,  5 Nov 2021 21:44:00 +0100 (CET)
From:   =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-staging@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] staging/fbtft: Fix backlight
Date:   Fri,  5 Nov 2021 21:43:58 +0100
Message-Id: <20211105204358.2991-1-noralf@tronnes.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aqWc9xRV c=1 sm=1 tr=0
        a=OYZzhG0JTxDrWp/F2OJbnw==:117 a=OYZzhG0JTxDrWp/F2OJbnw==:17
        a=IkcTkHD0fZMA:10 a=M51BFTxLslgA:10 a=VwQbUJbxAAAA:8 a=SJz97ENfAAAA:8
        a=1p55k4irWVlsT-gVo68A:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=vFet0B0WnEQeilDPIY6i:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate") forgot to
update fbtft breaking its backlight support when FB_BACKLIGHT is a module.

Since FB_TFT selects FB_BACKLIGHT there's no need for this conditional
so just remove it and we're good.

Fixes: b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate")
Cc: <stable@vger.kernel.org>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---

Changes since v1:
- No need for the #ifdef at all since FB_BACKLIGHT is always selected
- Fix fb_ssd1351 as well

fb_watterott has the same problem, but I've sent a removal patch for that one.

 drivers/staging/fbtft/fb_ssd1351.c | 4 ----
 drivers/staging/fbtft/fbtft-core.c | 9 +--------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/fbtft/fb_ssd1351.c b/drivers/staging/fbtft/fb_ssd1351.c
index cf263a58a148..6fd549a424d5 100644
--- a/drivers/staging/fbtft/fb_ssd1351.c
+++ b/drivers/staging/fbtft/fb_ssd1351.c
@@ -187,7 +187,6 @@ static struct fbtft_display display = {
 	},
 };
 
-#ifdef CONFIG_FB_BACKLIGHT
 static int update_onboard_backlight(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
@@ -231,9 +230,6 @@ static void register_onboard_backlight(struct fbtft_par *par)
 	if (!par->fbtftops.unregister_backlight)
 		par->fbtftops.unregister_backlight = fbtft_unregister_backlight;
 }
-#else
-static void register_onboard_backlight(struct fbtft_par *par) { };
-#endif
 
 FBTFT_REGISTER_DRIVER(DRVNAME, "solomon,ssd1351", &display);
 
diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index ed992ca605eb..1690358b8f01 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -128,7 +128,6 @@ static int fbtft_request_gpios(struct fbtft_par *par)
 	return 0;
 }
 
-#ifdef CONFIG_FB_BACKLIGHT
 static int fbtft_backlight_update_status(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
@@ -161,6 +160,7 @@ void fbtft_unregister_backlight(struct fbtft_par *par)
 		par->info->bl_dev = NULL;
 	}
 }
+EXPORT_SYMBOL(fbtft_unregister_backlight);
 
 static const struct backlight_ops fbtft_bl_ops = {
 	.get_brightness	= fbtft_backlight_get_brightness,
@@ -198,12 +198,7 @@ void fbtft_register_backlight(struct fbtft_par *par)
 	if (!par->fbtftops.unregister_backlight)
 		par->fbtftops.unregister_backlight = fbtft_unregister_backlight;
 }
-#else
-void fbtft_register_backlight(struct fbtft_par *par) { };
-void fbtft_unregister_backlight(struct fbtft_par *par) { };
-#endif
 EXPORT_SYMBOL(fbtft_register_backlight);
-EXPORT_SYMBOL(fbtft_unregister_backlight);
 
 static void fbtft_set_addr_win(struct fbtft_par *par, int xs, int ys, int xe,
 			       int ye)
@@ -853,13 +848,11 @@ int fbtft_register_framebuffer(struct fb_info *fb_info)
 		 fb_info->fix.smem_len >> 10, text1,
 		 HZ / fb_info->fbdefio->delay, text2);
 
-#ifdef CONFIG_FB_BACKLIGHT
 	/* Turn on backlight if available */
 	if (fb_info->bl_dev) {
 		fb_info->bl_dev->props.power = FB_BLANK_UNBLANK;
 		fb_info->bl_dev->ops->update_status(fb_info->bl_dev);
 	}
-#endif
 
 	return 0;
 
-- 
2.33.0

