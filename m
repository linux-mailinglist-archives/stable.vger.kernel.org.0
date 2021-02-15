Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28B31BCBD
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBOPe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhBOPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC41864E8C;
        Mon, 15 Feb 2021 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402980;
        bh=oDYBrxo5eY+tkf948Ydxknq6HH9kJi4HPQ+yU8/r+yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOea4U0/T/e+n4Ej8aExU4EPISZ81HESzUPPLsgzwJXkwjnI0aGHkHEjNb2PzwdeJ
         08OMutBNIQerPgM/CSuXFHXNzImfZKXEgbp0NmxRcDErdZIwMXSVdqTvjvf7pkE1QX
         Jy48AJhy4Co5MDcI2u1Fkk8z1RJCFbMBu1XNDj78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/60] drm/sun4i: tcon: set sync polarity for tcon1 channel
Date:   Mon, 15 Feb 2021 16:27:29 +0100
Message-Id: <20210215152716.684544314@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 50791f5d7b6a14b388f46c8885f71d1b98216d1d ]

Channel 1 has polarity bits for vsync and hsync signals but driver never
sets them. It turns out that with pre-HDMI2 controllers seemingly there
is no issue if polarity is not set. However, with HDMI2 controllers
(H6) there often comes to de-synchronization due to phase shift. This
causes flickering screen. It's safe to assume that similar issues might
happen also with pre-HDMI2 controllers.

Solve issue with setting vsync and hsync polarity. Note that display
stacks with tcon top have polarity bits actually in tcon0 polarity
register.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209175900.7092-3-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 25 +++++++++++++++++++++++++
 drivers/gpu/drm/sun4i/sun4i_tcon.h |  6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index ae7ae432aa4ab..6bf1425e8b0ca 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -665,6 +665,30 @@ static void sun4i_tcon1_mode_set(struct sun4i_tcon *tcon,
 		     SUN4I_TCON1_BASIC5_V_SYNC(vsync) |
 		     SUN4I_TCON1_BASIC5_H_SYNC(hsync));
 
+	/* Setup the polarity of multiple signals */
+	if (tcon->quirks->polarity_in_ch0) {
+		val = 0;
+
+		if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+			val |= SUN4I_TCON0_IO_POL_HSYNC_POSITIVE;
+
+		if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+			val |= SUN4I_TCON0_IO_POL_VSYNC_POSITIVE;
+
+		regmap_write(tcon->regs, SUN4I_TCON0_IO_POL_REG, val);
+	} else {
+		/* according to vendor driver, this bit must be always set */
+		val = SUN4I_TCON1_IO_POL_UNKNOWN;
+
+		if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+			val |= SUN4I_TCON1_IO_POL_HSYNC_POSITIVE;
+
+		if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+			val |= SUN4I_TCON1_IO_POL_VSYNC_POSITIVE;
+
+		regmap_write(tcon->regs, SUN4I_TCON1_IO_POL_REG, val);
+	}
+
 	/* Map output pins to channel 1 */
 	regmap_update_bits(tcon->regs, SUN4I_TCON_GCTL_REG,
 			   SUN4I_TCON_GCTL_IOMAP_MASK,
@@ -1482,6 +1506,7 @@ static const struct sun4i_tcon_quirks sun8i_a83t_tv_quirks = {
 
 static const struct sun4i_tcon_quirks sun8i_r40_tv_quirks = {
 	.has_channel_1		= true,
+	.polarity_in_ch0	= true,
 	.set_mux		= sun8i_r40_tcon_tv_set_mux,
 };
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.h b/drivers/gpu/drm/sun4i/sun4i_tcon.h
index a62ec826ae71e..5bdbaf0847824 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.h
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.h
@@ -153,6 +153,11 @@
 #define SUN4I_TCON1_BASIC5_V_SYNC(height)		(((height) - 1) & 0x3ff)
 
 #define SUN4I_TCON1_IO_POL_REG			0xf0
+/* there is no documentation about this bit */
+#define SUN4I_TCON1_IO_POL_UNKNOWN			BIT(26)
+#define SUN4I_TCON1_IO_POL_HSYNC_POSITIVE		BIT(25)
+#define SUN4I_TCON1_IO_POL_VSYNC_POSITIVE		BIT(24)
+
 #define SUN4I_TCON1_IO_TRI_REG			0xf4
 
 #define SUN4I_TCON_ECC_FIFO_REG			0xf8
@@ -224,6 +229,7 @@ struct sun4i_tcon_quirks {
 	bool	needs_de_be_mux; /* sun6i needs mux to select backend */
 	bool    needs_edp_reset; /* a80 edp reset needed for tcon0 access */
 	bool	supports_lvds;   /* Does the TCON support an LVDS output? */
+	bool	polarity_in_ch0; /* some tcon1 channels have polarity bits in tcon0 pol register */
 	u8	dclk_min_div;	/* minimum divider for TCON0 DCLK */
 
 	/* callback to handle tcon muxing options */
-- 
2.27.0



