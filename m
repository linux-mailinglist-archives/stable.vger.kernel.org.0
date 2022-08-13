Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3078B591A56
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbiHMMuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbiHMMuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B06591
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F50FB8013C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9832FC433D6;
        Sat, 13 Aug 2022 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395015;
        bh=zrjkjgYhzSDRT0Do/eA4BG2lPnXgzK60PT93FTABtGk=;
        h=Subject:To:Cc:From:Date:From;
        b=1RNIctJX9GcwIDxYkOTnYbi51Y5nd5ytOACufyKKhOg1KCopLeDbKvCaEewFxrASo
         3FnVX9Iat1YlY3FYaop2c5NZj+NwCGP3lYmGwHid0Nx7mbiXASwZCqr8Gz3Mt1GLcB
         7eu4FQnObfDxh0rJT/AUw4HUfBhd72hU/XLGo1Po=
Subject: FAILED: patch "[PATCH] drm/ingenic: Use the highest possible DMA burst size" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, cbranchereau@gmail.com, sam@ravnborg.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:50:03 +0200
Message-ID: <1660395003220206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0dce5c4fdaf9e98dd2755ffb1363822854b6287 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sun, 3 Jul 2022 00:07:27 +0100
Subject: [PATCH] drm/ingenic: Use the highest possible DMA burst size

Until now, when running at the maximum resolution of 1280x720 at 32bpp
on the JZ4770 SoC the output was garbled, the X/Y position of the
top-left corner of the framebuffer warping to a random position with
the whole image being offset accordingly, every time a new frame was
being submitted.

This problem can be eliminated by using a bigger burst size for the DMA.

Set in each soc_info structure the maximum burst size supported by the
corresponding SoC, and use it in the driver.

Set the new value using regmap_update_bits() instead of
regmap_set_bits(), since we do want to override the old value of the
burst size. (Note that regmap_set_bits() wasn't really valid before for
the same reason, but it never seemed to be a problem).

Cc: <stable@vger.kernel.org>
Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20220702230727.66704-1-paul@crapouillou.net
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Christophe Branchereau <cbranchereau@gmail.com>

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 2c559885347a..8ad6080b32b2 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -70,6 +70,7 @@ struct jz_soc_info {
 	bool map_noncoherent;
 	bool use_extended_hwdesc;
 	bool plane_f0_not_working;
+	u32 max_burst;
 	unsigned int max_width, max_height;
 	const u32 *formats_f0, *formats_f1;
 	unsigned int num_formats_f0, num_formats_f1;
@@ -319,8 +320,9 @@ static void ingenic_drm_crtc_update_timings(struct ingenic_drm *priv,
 		regmap_write(priv->map, JZ_REG_LCD_REV, mode->htotal << 16);
 	}
 
-	regmap_set_bits(priv->map, JZ_REG_LCD_CTRL,
-			JZ_LCD_CTRL_OFUP | JZ_LCD_CTRL_BURST_16);
+	regmap_update_bits(priv->map, JZ_REG_LCD_CTRL,
+			   JZ_LCD_CTRL_OFUP | JZ_LCD_CTRL_BURST_MASK,
+			   JZ_LCD_CTRL_OFUP | priv->soc_info->max_burst);
 
 	/*
 	 * IPU restart - specify how much time the LCDC will wait before
@@ -1519,6 +1521,7 @@ static const struct jz_soc_info jz4740_soc_info = {
 	.map_noncoherent = false,
 	.max_width = 800,
 	.max_height = 600,
+	.max_burst = JZ_LCD_CTRL_BURST_16,
 	.formats_f1 = jz4740_formats,
 	.num_formats_f1 = ARRAY_SIZE(jz4740_formats),
 	/* JZ4740 has only one plane */
@@ -1530,6 +1533,7 @@ static const struct jz_soc_info jz4725b_soc_info = {
 	.map_noncoherent = false,
 	.max_width = 800,
 	.max_height = 600,
+	.max_burst = JZ_LCD_CTRL_BURST_16,
 	.formats_f1 = jz4725b_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4725b_formats_f1),
 	.formats_f0 = jz4725b_formats_f0,
@@ -1542,6 +1546,7 @@ static const struct jz_soc_info jz4770_soc_info = {
 	.map_noncoherent = true,
 	.max_width = 1280,
 	.max_height = 720,
+	.max_burst = JZ_LCD_CTRL_BURST_64,
 	.formats_f1 = jz4770_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4770_formats_f1),
 	.formats_f0 = jz4770_formats_f0,
@@ -1556,6 +1561,7 @@ static const struct jz_soc_info jz4780_soc_info = {
 	.plane_f0_not_working = true,	/* REVISIT */
 	.max_width = 4096,
 	.max_height = 2048,
+	.max_burst = JZ_LCD_CTRL_BURST_64,
 	.formats_f1 = jz4770_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4770_formats_f1),
 	.formats_f0 = jz4770_formats_f0,
diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.h b/drivers/gpu/drm/ingenic/ingenic-drm.h
index cb1d09b62588..e5bd007ea93d 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.h
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.h
@@ -106,6 +106,9 @@
 #define JZ_LCD_CTRL_BURST_4			(0x0 << 28)
 #define JZ_LCD_CTRL_BURST_8			(0x1 << 28)
 #define JZ_LCD_CTRL_BURST_16			(0x2 << 28)
+#define JZ_LCD_CTRL_BURST_32			(0x3 << 28)
+#define JZ_LCD_CTRL_BURST_64			(0x4 << 28)
+#define JZ_LCD_CTRL_BURST_MASK			(0x7 << 28)
 #define JZ_LCD_CTRL_RGB555			BIT(27)
 #define JZ_LCD_CTRL_OFUP			BIT(26)
 #define JZ_LCD_CTRL_FRC_GRAYSCALE_16		(0x0 << 24)

