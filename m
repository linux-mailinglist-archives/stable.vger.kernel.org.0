Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5823C9EA7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhGOMeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhGOMeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C74161178;
        Thu, 15 Jul 2021 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352292;
        bh=Mh7D3kR8KNloGlcKCjm+9BlABCl9IvhpKbAnFeLlLGg=;
        h=Subject:To:Cc:From:Date:From;
        b=hQVgaFInArOfuYzI9BajlZGQX0R5ZAU93gyNFbesasZkNKO/hUXu2wfO+HsXsiuHx
         Lu4mC9n5f7/5KNeqdTpe+G6ThuDnSCuJ0iaETz3aMln8yY1ChvTKQq6tHhUdDoe4f/
         cnhgan1fk5fsMbdYJ1ekWAqVZy8vyZrERZHmsaw8=
Subject: FAILED: patch "[PATCH] drm/ingenic: Fix pixclock rate for 24-bit serial panels" failed to apply to 5.10-stable tree
To:     paul@crapouillou.net, hns@goldelico.com, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:26:26 +0200
Message-ID: <1626351986255237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60a6b73dd821e98fe958b2a83393ccd724b306b1 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Tue, 23 Mar 2021 14:40:08 +0000
Subject: [PATCH] drm/ingenic: Fix pixclock rate for 24-bit serial panels

When using a 24-bit panel on a 8-bit serial bus, the pixel clock
requested by the panel has to be multiplied by 3, since the subpixels
are shifted sequentially.

The code (in ingenic_drm_encoder_atomic_check) already computed
crtc_state->adjusted_mode->crtc_clock accordingly, but clk_set_rate()
used crtc_state->adjusted_mode->clock instead.

Fixes: 28ab7d35b6e0 ("drm/ingenic: Properly compute timings when using a 3x8-bit panel")
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>	# CI20/jz4780 (HDMI) and Alpha400/jz4730 (LCD)
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210323144008.166248-1-paul@crapouillou.net

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 09225b770bb8..389cad59e090 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -342,7 +342,7 @@ static void ingenic_drm_crtc_atomic_flush(struct drm_crtc *crtc,
 	if (priv->update_clk_rate) {
 		mutex_lock(&priv->clk_mutex);
 		clk_set_rate(priv->pix_clk,
-			     crtc_state->adjusted_mode.clock * 1000);
+			     crtc_state->adjusted_mode.crtc_clock * 1000);
 		priv->update_clk_rate = false;
 		mutex_unlock(&priv->clk_mutex);
 	}

