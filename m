Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6490B3461A6
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 15:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhCWOk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 10:40:56 -0400
Received: from aposti.net ([89.234.176.197]:56082 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhCWOkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 10:40:36 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] drm/ingenic: Fix pixclock rate for 24-bit serial panels
Date:   Tue, 23 Mar 2021 14:40:08 +0000
Message-Id: <20210323144008.166248-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using a 24-bit panel on a 8-bit serial bus, the pixel clock
requested by the panel has to be multiplied by 3, since the subpixels
are shifted sequentially.

The code (in ingenic_drm_encoder_atomic_check) already computed
crtc_state->adjusted_mode->crtc_clock accordingly, but clk_set_rate()
used crtc_state->adjusted_mode->clock instead.

Fixes: 28ab7d35b6e0 ("drm/ingenic: Properly compute timings when using a 3x8-bit panel")
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index d60e1eefc9d1..cba68bf52ec5 100644
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
-- 
2.30.2

