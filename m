Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E6328844
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhCARiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237815AbhCAR3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F8F65095;
        Mon,  1 Mar 2021 16:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617494;
        bh=9dxdFumsQfcaIrQcbmyhvgZUC9py9sR7JJnBMrKCEZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItmIw2XzA0oWKnL0K3XuWYQa1rG7XqxVhwOdRaZgkflD4zVf5pMg/n7uMglLDCIQ7
         6rD0JgAVu21n3wqhf0wD5CGtw4+ykUE3jQAPYH3lDuP59LlnWMVxYHBDLwkFNPWhg/
         Sv8R/y6ES8FxagUeNzPAzYYEhMSQN+15P45Wvu/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/340] drm/sun4i: tcon: fix inverted DCLK polarity
Date:   Mon,  1 Mar 2021 17:10:36 +0100
Message-Id: <20210301161052.853351528@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 6bf1425e8b0ca..eb3b2350687fb 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -545,30 +545,13 @@ static void sun4i_tcon0_mode_set_rgb(struct sun4i_tcon *tcon,
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
index 5bdbaf0847824..ce500c8dd4c72 100644
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



