Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D993CA9FA
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbhGOTLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242367AbhGOTIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1187F613E6;
        Thu, 15 Jul 2021 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375876;
        bh=y5INbB7BhKNTobXp8zKDbun0s0xvNKCmJ4x0sSzC/yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ96qlqLznWqYhbPrfqnU+jf91kRc+zXqcq2UwdYDpA3GwQypEVPfVZ2Cs8MlU4sc
         ILNmFJXNXAX5we4TKB4Ex7qF2JXsNvygKcWw01VcR42vW8P0xrvV8BcSD2vb7FeAj/
         4FUvQ1PunOT8yWD5uNFDf6Z66vAYUfKL/uWwSg+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Chiras <robert.chiras@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 009/266] drm/bridge: nwl-dsi: Force a full modeset when crtc_state->active is changed to be true
Date:   Thu, 15 Jul 2021 20:36:04 +0200
Message-Id: <20210715182615.524107494@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 3afb2a28fa2404d11cce1956a003f2aaca4da421 ]

This patch replaces ->mode_fixup() with ->atomic_check() so that
a full modeset can be requested from there when crtc_state->active
is changed to be true(which implies only connector's DPMS is brought
out of "Off" status, though not necessarily).  Bridge functions are
added or changed to accommodate the ->atomic_check() callback.  That
full modeset is needed by the up-coming patch which gets MIPI DSI
controller and PHY ready in ->mode_set(), because it makes sure
->mode_set() and ->atomic_disable() are called in pairs.

Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Guido Günther <agx@sigxcpu.org>
Cc: Robert Chiras <robert.chiras@nxp.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1619170003-4817-2-git-send-email-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 61 ++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index 66b67402f1ac..c65ca860712d 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -21,6 +21,7 @@
 #include <linux/sys_soc.h>
 #include <linux/time64.h>
 
+#include <drm/drm_atomic_state_helper.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_mipi_dsi.h>
 #include <drm/drm_of.h>
@@ -742,7 +743,9 @@ static int nwl_dsi_disable(struct nwl_dsi *dsi)
 	return 0;
 }
 
-static void nwl_dsi_bridge_disable(struct drm_bridge *bridge)
+static void
+nwl_dsi_bridge_atomic_disable(struct drm_bridge *bridge,
+			      struct drm_bridge_state *old_bridge_state)
 {
 	struct nwl_dsi *dsi = bridge_to_dsi(bridge);
 	int ret;
@@ -803,17 +806,6 @@ static int nwl_dsi_get_dphy_params(struct nwl_dsi *dsi,
 	return 0;
 }
 
-static bool nwl_dsi_bridge_mode_fixup(struct drm_bridge *bridge,
-				      const struct drm_display_mode *mode,
-				      struct drm_display_mode *adjusted_mode)
-{
-	/* At least LCDIF + NWL needs active high sync */
-	adjusted_mode->flags |= (DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
-	adjusted_mode->flags &= ~(DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC);
-
-	return true;
-}
-
 static enum drm_mode_status
 nwl_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 			  const struct drm_display_info *info,
@@ -831,6 +823,24 @@ nwl_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	return MODE_OK;
 }
 
+static int nwl_dsi_bridge_atomic_check(struct drm_bridge *bridge,
+				       struct drm_bridge_state *bridge_state,
+				       struct drm_crtc_state *crtc_state,
+				       struct drm_connector_state *conn_state)
+{
+	struct drm_display_mode *adjusted_mode = &crtc_state->adjusted_mode;
+
+	/* At least LCDIF + NWL needs active high sync */
+	adjusted_mode->flags |= (DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
+	adjusted_mode->flags &= ~(DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC);
+
+	/* Do a full modeset if crtc_state->active is changed to be true. */
+	if (crtc_state->active_changed && crtc_state->active)
+		crtc_state->mode_changed = true;
+
+	return 0;
+}
+
 static void
 nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 			const struct drm_display_mode *mode,
@@ -862,7 +872,9 @@ nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 	drm_mode_debug_printmodeline(adjusted_mode);
 }
 
-static void nwl_dsi_bridge_pre_enable(struct drm_bridge *bridge)
+static void
+nwl_dsi_bridge_atomic_pre_enable(struct drm_bridge *bridge,
+				 struct drm_bridge_state *old_bridge_state)
 {
 	struct nwl_dsi *dsi = bridge_to_dsi(bridge);
 	int ret;
@@ -897,7 +909,9 @@ static void nwl_dsi_bridge_pre_enable(struct drm_bridge *bridge)
 	}
 }
 
-static void nwl_dsi_bridge_enable(struct drm_bridge *bridge)
+static void
+nwl_dsi_bridge_atomic_enable(struct drm_bridge *bridge,
+			     struct drm_bridge_state *old_bridge_state)
 {
 	struct nwl_dsi *dsi = bridge_to_dsi(bridge);
 	int ret;
@@ -942,14 +956,17 @@ static void nwl_dsi_bridge_detach(struct drm_bridge *bridge)
 }
 
 static const struct drm_bridge_funcs nwl_dsi_bridge_funcs = {
-	.pre_enable = nwl_dsi_bridge_pre_enable,
-	.enable     = nwl_dsi_bridge_enable,
-	.disable    = nwl_dsi_bridge_disable,
-	.mode_fixup = nwl_dsi_bridge_mode_fixup,
-	.mode_set   = nwl_dsi_bridge_mode_set,
-	.mode_valid = nwl_dsi_bridge_mode_valid,
-	.attach	    = nwl_dsi_bridge_attach,
-	.detach	    = nwl_dsi_bridge_detach,
+	.atomic_duplicate_state	= drm_atomic_helper_bridge_duplicate_state,
+	.atomic_destroy_state	= drm_atomic_helper_bridge_destroy_state,
+	.atomic_reset		= drm_atomic_helper_bridge_reset,
+	.atomic_check		= nwl_dsi_bridge_atomic_check,
+	.atomic_pre_enable	= nwl_dsi_bridge_atomic_pre_enable,
+	.atomic_enable		= nwl_dsi_bridge_atomic_enable,
+	.atomic_disable		= nwl_dsi_bridge_atomic_disable,
+	.mode_set		= nwl_dsi_bridge_mode_set,
+	.mode_valid		= nwl_dsi_bridge_mode_valid,
+	.attach			= nwl_dsi_bridge_attach,
+	.detach			= nwl_dsi_bridge_detach,
 };
 
 static int nwl_dsi_parse_dt(struct nwl_dsi *dsi)
-- 
2.30.2



