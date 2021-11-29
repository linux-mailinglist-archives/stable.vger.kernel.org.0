Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234F14626D0
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhK2W5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbhK2W5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2D0C127B42;
        Mon, 29 Nov 2021 10:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25475B815AE;
        Mon, 29 Nov 2021 18:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516E3C53FAD;
        Mon, 29 Nov 2021 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210514;
        bh=AVC4NzuDwVGGflKPXSXPFCoQKWU2pLlAqmf3QcFWFQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1Qi5sZkoxdx5O5ZV8KhFXdNGUIFc78fFzRS/vjkOb3WOz9idpczr+2rE51QL7vxk
         x86nF0/BAvLUlQsP/MlQGu7uyyUreeMeY3Z4mUz/6PMXP06hFuoZFQ9c/v/bZdbQFO
         fDH7NgPB9wm3c5PwcSX2LQQkujxvqN4UZcG1LJBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: [PATCH 5.10 022/121] staging/fbtft: Fix backlight
Date:   Mon, 29 Nov 2021 19:17:33 +0100
Message-Id: <20211129181712.393378407@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

commit 7865dd24934ad580d1bcde8f63c39f324211a23b upstream.

Commit b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate") forgot to
update fbtft breaking its backlight support when FB_BACKLIGHT is a module.

Since FB_TFT selects FB_BACKLIGHT there's no need for this conditional
so just remove it and we're good.

Fixes: b4a1ed0cd18b ("fbdev: make FB_BACKLIGHT a tristate")
Cc: <stable@vger.kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://lore.kernel.org/r/20211105204358.2991-1-noralf@tronnes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/fb_ssd1351.c |    4 ----
 drivers/staging/fbtft/fbtft-core.c |    9 +--------
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/staging/fbtft/fb_ssd1351.c
+++ b/drivers/staging/fbtft/fb_ssd1351.c
@@ -187,7 +187,6 @@ static struct fbtft_display display = {
 	},
 };
 
-#ifdef CONFIG_FB_BACKLIGHT
 static int update_onboard_backlight(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
@@ -231,9 +230,6 @@ static void register_onboard_backlight(s
 	if (!par->fbtftops.unregister_backlight)
 		par->fbtftops.unregister_backlight = fbtft_unregister_backlight;
 }
-#else
-static void register_onboard_backlight(struct fbtft_par *par) { };
-#endif
 
 FBTFT_REGISTER_DRIVER(DRVNAME, "solomon,ssd1351", &display);
 
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -128,7 +128,6 @@ static int fbtft_request_gpios(struct fb
 	return 0;
 }
 
-#ifdef CONFIG_FB_BACKLIGHT
 static int fbtft_backlight_update_status(struct backlight_device *bd)
 {
 	struct fbtft_par *par = bl_get_data(bd);
@@ -161,6 +160,7 @@ void fbtft_unregister_backlight(struct f
 		par->info->bl_dev = NULL;
 	}
 }
+EXPORT_SYMBOL(fbtft_unregister_backlight);
 
 static const struct backlight_ops fbtft_bl_ops = {
 	.get_brightness	= fbtft_backlight_get_brightness,
@@ -198,12 +198,7 @@ void fbtft_register_backlight(struct fbt
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
@@ -853,13 +848,11 @@ int fbtft_register_framebuffer(struct fb
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
 


