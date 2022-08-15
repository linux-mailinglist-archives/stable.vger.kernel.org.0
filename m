Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25697593C2D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiHOUOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346652AbiHOULy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C86E49B4A;
        Mon, 15 Aug 2022 11:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF4B3CE129B;
        Mon, 15 Aug 2022 18:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974D5C433C1;
        Mon, 15 Aug 2022 18:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589879;
        bh=DlTQ8VDIbg09Ihg4xGaCCRBq46cuKg5QQPnMUByFDZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vj0HfIDBTrCRqSMUgSPcKzM0bMCWHMNX45xuSdd3SSs1dENItYyU8H7qaWqwt1lLS
         oIXHlzzI3XAT8WcMJmYlw0yHDGuxie8y3tjtQ38izColecYYiLOhTCf1hYCJKJnMz7
         iKdRp1xp/1pKdXRgWop6QhvXXzP+2JnWv8EUy5CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Christophe Branchereau <cbranchereau@gmail.com>
Subject: [PATCH 5.18 0078/1095] drm/ingenic: Use the highest possible DMA burst size
Date:   Mon, 15 Aug 2022 19:51:17 +0200
Message-Id: <20220815180432.756102850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit f0dce5c4fdaf9e98dd2755ffb1363822854b6287 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |   10 ++++++++--
 drivers/gpu/drm/ingenic/ingenic-drm.h     |    3 +++
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -69,6 +69,7 @@ struct jz_soc_info {
 	bool map_noncoherent;
 	bool use_extended_hwdesc;
 	bool plane_f0_not_working;
+	u32 max_burst;
 	unsigned int max_width, max_height;
 	const u32 *formats_f0, *formats_f1;
 	unsigned int num_formats_f0, num_formats_f1;
@@ -308,8 +309,9 @@ static void ingenic_drm_crtc_update_timi
 		regmap_write(priv->map, JZ_REG_LCD_REV, mode->htotal << 16);
 	}
 
-	regmap_set_bits(priv->map, JZ_REG_LCD_CTRL,
-			JZ_LCD_CTRL_OFUP | JZ_LCD_CTRL_BURST_16);
+	regmap_update_bits(priv->map, JZ_REG_LCD_CTRL,
+			   JZ_LCD_CTRL_OFUP | JZ_LCD_CTRL_BURST_MASK,
+			   JZ_LCD_CTRL_OFUP | priv->soc_info->max_burst);
 
 	/*
 	 * IPU restart - specify how much time the LCDC will wait before
@@ -1480,6 +1482,7 @@ static const struct jz_soc_info jz4740_s
 	.map_noncoherent = false,
 	.max_width = 800,
 	.max_height = 600,
+	.max_burst = JZ_LCD_CTRL_BURST_16,
 	.formats_f1 = jz4740_formats,
 	.num_formats_f1 = ARRAY_SIZE(jz4740_formats),
 	/* JZ4740 has only one plane */
@@ -1491,6 +1494,7 @@ static const struct jz_soc_info jz4725b_
 	.map_noncoherent = false,
 	.max_width = 800,
 	.max_height = 600,
+	.max_burst = JZ_LCD_CTRL_BURST_16,
 	.formats_f1 = jz4725b_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4725b_formats_f1),
 	.formats_f0 = jz4725b_formats_f0,
@@ -1503,6 +1507,7 @@ static const struct jz_soc_info jz4770_s
 	.map_noncoherent = true,
 	.max_width = 1280,
 	.max_height = 720,
+	.max_burst = JZ_LCD_CTRL_BURST_64,
 	.formats_f1 = jz4770_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4770_formats_f1),
 	.formats_f0 = jz4770_formats_f0,
@@ -1517,6 +1522,7 @@ static const struct jz_soc_info jz4780_s
 	.plane_f0_not_working = true,	/* REVISIT */
 	.max_width = 4096,
 	.max_height = 2048,
+	.max_burst = JZ_LCD_CTRL_BURST_64,
 	.formats_f1 = jz4770_formats_f1,
 	.num_formats_f1 = ARRAY_SIZE(jz4770_formats_f1),
 	.formats_f0 = jz4770_formats_f0,
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


