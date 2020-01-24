Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECC4147B14
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgAXJkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729816AbgAXJkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:45 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8CA20709;
        Fri, 24 Jan 2020 09:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858844;
        bh=FEh1asvKYX2d5QT2M+nBLZZ/po92KWCs/jgkLKOV3VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5yvWcMp2m2HXW1MocOIAHOO7uZzMdg+ZOwivYIHoPfjBcxWw6T3/ZGmKPH6LP0kf
         surpiHWoxZq7vGx/+YgzHV7TiS43WG+Dc6BYlCmKQmWVwnGLbwugx+AKtEGgyP+XMY
         5hCiHu1quXXdBEzA9CAgIT8czOnvWM7wxu2ZDZSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/102] drm/rockchip: Round up _before_ giving to the clock framework
Date:   Fri, 24 Jan 2020 10:30:57 +0100
Message-Id: <20200124092814.815114198@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 287422a95fe28e05c1952de0472e0dfdffa6caae ]

I'm embarassed to say that even though I've touched
vop_crtc_mode_fixup() twice and I swear I tested it, there's still a
stupid glaring bug in it.  Specifically, on veyron_minnie (with all
the latest display timings) we want to be setting our pixel clock to
66,666,666.67 Hz and we tell userspace that's what we set, but we're
actually choosing 66,000,000 Hz.  This is confirmed by looking at the
clock tree.

The problem is that in drm_display_mode_from_videomode() we convert
from Hz to kHz with:

  dmode->clock = vm->pixelclock / 1000;

...and drm_display_mode_from_videomode() is called from panel-simple
when we have an "override_mode" like we do on veyron_minnie.  See
commit 123643e5c40a ("ARM: dts: rockchip: Specify
rk3288-veyron-minnie's display timings").

...so when the device tree specifies a clock of 66666667 for the panel
then DRM translates that to 66666000.  The clock framework will always
pick a clock that is _lower_ than the one requested, so it will refuse
to pick 66666667 and we'll end up at 66000000.

While we could try to fix drm_display_mode_from_videomode() to round
to the nearest kHz and it would fix our problem, it wouldn't help if
the clock we actually needed was 60,000,001 Hz.  We could
alternatively have DRM always round up, but maybe this would break
someone else who already baked in the assumption that DRM rounds down.
Specifically note that clock drivers are not consistent about whether
they round up or round down when you call clk_set_rate().  We know how
Rockchip's clock driver works, but (for instance) you can see that on
most Qualcomm clocks the default is clk_rcg2_ops which rounds up.

Let's solve this by just adding 999 Hz before calling
clk_round_rate().  This should be safe and work everywhere.  As
discussed in more detail in comments in the commit, Rockchip's PLLs
are configured in a way that there shouldn't be another PLL setting
that is only a few kHz off so we won't get mixed up.

NOTE: if this is picked to stable, it's probably easiest to first pick
commit 527e4ca3b6d1 ("drm/rockchip: Base adjustments of the mode based
on prev adjustments") which shouldn't hurt in stable.

Fixes: b59b8de31497 ("drm/rockchip: return a true clock rate to adjusted_mode")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191003114726.v2.1.Ib233b3e706cf6317858384264d5b0ed35657456e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 37 +++++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 613404f86668d..84e3decb17b1f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1040,10 +1040,41 @@ static bool vop_crtc_mode_fixup(struct drm_crtc *crtc,
 				struct drm_display_mode *adjusted_mode)
 {
 	struct vop *vop = to_vop(crtc);
+	unsigned long rate;
 
-	adjusted_mode->clock =
-		DIV_ROUND_UP(clk_round_rate(vop->dclk,
-					    adjusted_mode->clock * 1000), 1000);
+	/*
+	 * Clock craziness.
+	 *
+	 * Key points:
+	 *
+	 * - DRM works in in kHz.
+	 * - Clock framework works in Hz.
+	 * - Rockchip's clock driver picks the clock rate that is the
+	 *   same _OR LOWER_ than the one requested.
+	 *
+	 * Action plan:
+	 *
+	 * 1. When DRM gives us a mode, we should add 999 Hz to it.  That way
+	 *    if the clock we need is 60000001 Hz (~60 MHz) and DRM tells us to
+	 *    make 60000 kHz then the clock framework will actually give us
+	 *    the right clock.
+	 *
+	 *    NOTE: if the PLL (maybe through a divider) could actually make
+	 *    a clock rate 999 Hz higher instead of the one we want then this
+	 *    could be a problem.  Unfortunately there's not much we can do
+	 *    since it's baked into DRM to use kHz.  It shouldn't matter in
+	 *    practice since Rockchip PLLs are controlled by tables and
+	 *    even if there is a divider in the middle I wouldn't expect PLL
+	 *    rates in the table that are just a few kHz different.
+	 *
+	 * 2. Get the clock framework to round the rate for us to tell us
+	 *    what it will actually make.
+	 *
+	 * 3. Store the rounded up rate so that we don't need to worry about
+	 *    this in the actual clk_set_rate().
+	 */
+	rate = clk_round_rate(vop->dclk, adjusted_mode->clock * 1000 + 999);
+	adjusted_mode->clock = DIV_ROUND_UP(rate, 1000);
 
 	return true;
 }
-- 
2.20.1



