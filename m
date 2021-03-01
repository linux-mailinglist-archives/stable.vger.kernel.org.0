Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D4D328A31
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhCASNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239041AbhCASHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8192F65185;
        Mon,  1 Mar 2021 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618614;
        bh=JbxPQcCXfvnj9ggn8GyS0qw0U1tKTQs/Pt9cVbEbR9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JX8DJf3b4syd/Yhz/hZFS3vbobzjxVx9NExVecyUVoTGhjL2ygMpdQ6OEpxgm0tx5
         SNkBwMwhUtNZgwyhtXw5v6V7/UeDjtrNnuP2uUAt1LNTSeNGbhmBiVo/uaoy8xwK3a
         LrUQCBDX+bQvTd8mAVhvwJsejBX6V3/HDqvXo9Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/663] drm: rcar-du: Fix crash when using LVDS1 clock for CRTC
Date:   Mon,  1 Mar 2021 17:06:39 +0100
Message-Id: <20210301161149.245560452@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 53ced169373aab52d3b5da0fee6a342002d1876d ]

On D3 and E3 platforms, the LVDS encoder includes a PLL that can
generate a clock for the corresponding CRTC, used even when the CRTC
output to a non-LVDS port. This mechanism is supported by the driver,
but the implementation is broken in dual-link LVDS mode. In that case,
the LVDS1 drm_encoder is skipped, which causes a crash when trying to
access its bridge later on.

Fix this by storing bridge pointers internally instead of retrieving
them from the encoder. The rcar_du_device encoders field isn't used
anymore and can be dropped.

Fixes: 8e8fddab0d0a ("drm: rcar-du: Skip LVDS1 output on Gen3 when using dual-link LVDS mode")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 10 ++--------
 drivers/gpu/drm/rcar-du/rcar_du_drv.h     |  6 +++---
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c |  5 ++++-
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index fe86a3e677571..1b9738e44909d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -727,13 +727,10 @@ static void rcar_du_crtc_atomic_enable(struct drm_crtc *crtc,
 	 */
 	if (rcdu->info->lvds_clk_mask & BIT(rcrtc->index) &&
 	    rstate->outputs == BIT(RCAR_DU_OUTPUT_DPAD0)) {
-		struct rcar_du_encoder *encoder =
-			rcdu->encoders[RCAR_DU_OUTPUT_LVDS0 + rcrtc->index];
+		struct drm_bridge *bridge = rcdu->lvds[rcrtc->index];
 		const struct drm_display_mode *mode =
 			&crtc->state->adjusted_mode;
-		struct drm_bridge *bridge;
 
-		bridge = drm_bridge_chain_get_first_bridge(&encoder->base);
 		rcar_lvds_clk_enable(bridge, mode->clock * 1000);
 	}
 
@@ -759,15 +756,12 @@ static void rcar_du_crtc_atomic_disable(struct drm_crtc *crtc,
 
 	if (rcdu->info->lvds_clk_mask & BIT(rcrtc->index) &&
 	    rstate->outputs == BIT(RCAR_DU_OUTPUT_DPAD0)) {
-		struct rcar_du_encoder *encoder =
-			rcdu->encoders[RCAR_DU_OUTPUT_LVDS0 + rcrtc->index];
-		struct drm_bridge *bridge;
+		struct drm_bridge *bridge = rcdu->lvds[rcrtc->index];
 
 		/*
 		 * Disable the LVDS clock output, see
 		 * rcar_du_crtc_atomic_enable().
 		 */
-		bridge = drm_bridge_chain_get_first_bridge(&encoder->base);
 		rcar_lvds_clk_disable(bridge);
 	}
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index 61504c54e2ecf..3597a179bfb78 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -20,10 +20,10 @@
 
 struct clk;
 struct device;
+struct drm_bridge;
 struct drm_device;
 struct drm_property;
 struct rcar_du_device;
-struct rcar_du_encoder;
 
 #define RCAR_DU_FEATURE_CRTC_IRQ_CLOCK	BIT(0)	/* Per-CRTC IRQ and clock */
 #define RCAR_DU_FEATURE_VSP1_SOURCE	BIT(1)	/* Has inputs from VSP1 */
@@ -71,6 +71,7 @@ struct rcar_du_device_info {
 #define RCAR_DU_MAX_CRTCS		4
 #define RCAR_DU_MAX_GROUPS		DIV_ROUND_UP(RCAR_DU_MAX_CRTCS, 2)
 #define RCAR_DU_MAX_VSPS		4
+#define RCAR_DU_MAX_LVDS		2
 
 struct rcar_du_device {
 	struct device *dev;
@@ -83,11 +84,10 @@ struct rcar_du_device {
 	struct rcar_du_crtc crtcs[RCAR_DU_MAX_CRTCS];
 	unsigned int num_crtcs;
 
-	struct rcar_du_encoder *encoders[RCAR_DU_OUTPUT_MAX];
-
 	struct rcar_du_group groups[RCAR_DU_MAX_GROUPS];
 	struct platform_device *cmms[RCAR_DU_MAX_CRTCS];
 	struct rcar_du_vsp vsps[RCAR_DU_MAX_VSPS];
+	struct drm_bridge *lvds[RCAR_DU_MAX_LVDS];
 
 	struct {
 		struct drm_property *colorkey;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
index b0335da0c1614..50fc14534fa4d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
@@ -57,7 +57,6 @@ int rcar_du_encoder_init(struct rcar_du_device *rcdu,
 	if (renc == NULL)
 		return -ENOMEM;
 
-	rcdu->encoders[output] = renc;
 	renc->output = output;
 	encoder = rcar_encoder_to_drm_encoder(renc);
 
@@ -91,6 +90,10 @@ int rcar_du_encoder_init(struct rcar_du_device *rcdu,
 			ret = -EPROBE_DEFER;
 			goto done;
 		}
+
+		if (output == RCAR_DU_OUTPUT_LVDS0 ||
+		    output == RCAR_DU_OUTPUT_LVDS1)
+			rcdu->lvds[output - RCAR_DU_OUTPUT_LVDS0] = bridge;
 	}
 
 	/*
-- 
2.27.0



