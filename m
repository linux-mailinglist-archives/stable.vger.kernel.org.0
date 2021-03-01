Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5A328FAA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhCATyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242315AbhCATo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6800165192;
        Mon,  1 Mar 2021 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618672;
        bh=nHulc3qNJOD32dHhJbh76NFZMYWASY3FofVxMqXy6bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgVS2TEUYbYcuuZ5Y5I9kjziW4z4b6ypb3QKFCCOClkHQFIALm68t2mRsQCNMSQGf
         y1mTiuN0FrHiM1l4n3CQSStbf3VDqGP76oXXijP3GSLUdzKev+zgf1bn98C+FnBeS9
         TqNo8p+8FTT88MzI8Bpa6H360HYIBf70bfosIieA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/663] drm/sun4i: tcon: fix inverted DCLK polarity
Date:   Mon,  1 Mar 2021 17:07:03 +0100
Message-Id: <20210301161150.445161377@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giulio Benetti <giulio.benetti@micronovasrl.com>

[ Upstream commit 67f4aeb2b41a0629abde3794d463547f60b0cbdd ]

During commit 88bc4178568b ("drm: Use new
DRM_BUS_FLAG_*_(DRIVE|SAMPLE)_(POS|NEG)EDGE flags") DRM_BUS_FLAG_*
macros have been changed to avoid ambiguity but just because of this
ambiguity previous DRM_BUS_FLAG_PIXDATA_(POS/NEG)EDGE were used meaning
_SAMPLE_ not _DRIVE_. This leads to DLCK inversion and need to fix but
instead of swapping phase values, let's adopt an easier approach Maxime
suggested:
It turned out that bit 26 of SUN4I_TCON0_IO_POL_REG is dedicated to
invert DCLK polarity and this makes things really easier than before. So
let's handle DCLK polarity by adding SUN4I_TCON0_IO_POL_DCLK_DRIVE_NEGEDGE
as bit 26 and activating according to bus_flags the same way it is done
for all the other signals polarity.

Fixes: 88bc4178568b ("drm: Use new DRM_BUS_FLAG_*_(DRIVE|SAMPLE)_(POS|NEG)EDGE flags")
Suggested-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Giulio Benetti <giulio.benetti@micronovasrl.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210114081732.9386-1-giulio.benetti@benettiengineering.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 21 ++-------------------
 drivers/gpu/drm/sun4i/sun4i_tcon.h |  1 +
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 1e643bc7e786a..9f06dec0fc61d 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -569,30 +569,13 @@ static void sun4i_tcon0_mode_set_rgb(struct sun4i_tcon *tcon,
 	if (info->bus_flags & DRM_BUS_FLAG_DE_LOW)
 		val |= SUN4I_TCON0_IO_POL_DE_NEGATIVE;
 
-	/*
-	 * On A20 and similar SoCs, the only way to achieve Positive Edge
-	 * (Rising Edge), is setting dclk clock phase to 2/3(240°).
-	 * By default TCON works in Negative Edge(Falling Edge),
-	 * this is why phase is set to 0 in that case.
-	 * Unfortunately there's no way to logically invert dclk through
-	 * IO_POL register.
-	 * The only acceptable way to work, triple checked with scope,
-	 * is using clock phase set to 0° for Negative Edge and set to 240°
-	 * for Positive Edge.
-	 * On A33 and similar SoCs there would be a 90° phase option,
-	 * but it divides also dclk by 2.
-	 * Following code is a way to avoid quirks all around TCON
-	 * and DOTCLOCK drivers.
-	 */
-	if (info->bus_flags & DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE)
-		clk_set_phase(tcon->dclk, 240);
-
 	if (info->bus_flags & DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)
-		clk_set_phase(tcon->dclk, 0);
+		val |= SUN4I_TCON0_IO_POL_DCLK_DRIVE_NEGEDGE;
 
 	regmap_update_bits(tcon->regs, SUN4I_TCON0_IO_POL_REG,
 			   SUN4I_TCON0_IO_POL_HSYNC_POSITIVE |
 			   SUN4I_TCON0_IO_POL_VSYNC_POSITIVE |
+			   SUN4I_TCON0_IO_POL_DCLK_DRIVE_NEGEDGE |
 			   SUN4I_TCON0_IO_POL_DE_NEGATIVE,
 			   val);
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.h b/drivers/gpu/drm/sun4i/sun4i_tcon.h
index ee555318e3c2f..e624f6977eb84 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.h
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.h
@@ -113,6 +113,7 @@
 #define SUN4I_TCON0_IO_POL_REG			0x88
 #define SUN4I_TCON0_IO_POL_DCLK_PHASE(phase)		((phase & 3) << 28)
 #define SUN4I_TCON0_IO_POL_DE_NEGATIVE			BIT(27)
+#define SUN4I_TCON0_IO_POL_DCLK_DRIVE_NEGEDGE		BIT(26)
 #define SUN4I_TCON0_IO_POL_HSYNC_POSITIVE		BIT(25)
 #define SUN4I_TCON0_IO_POL_VSYNC_POSITIVE		BIT(24)
 
-- 
2.27.0



