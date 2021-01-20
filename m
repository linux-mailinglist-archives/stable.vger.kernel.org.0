Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BA62FD111
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbhATNDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 08:03:23 -0500
Received: from aposti.net ([89.234.176.197]:42286 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389446AbhATMha (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 07:37:30 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Subject: [PATCH v2 1/3] drm: bridge/panel: Cleanup connector on bridge detach
Date:   Wed, 20 Jan 2021 12:35:33 +0000
Message-Id: <20210120123535.40226-2-paul@crapouillou.net>
In-Reply-To: <20210120123535.40226-1-paul@crapouillou.net>
References: <20210120123535.40226-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we don't call drm_connector_cleanup() manually in
panel_bridge_detach(), the connector will be cleaned up with the other
DRM objects in the call to drm_mode_config_cleanup(). However, since our
drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
will be called, our connector will be long gone. Therefore, the
connector must be cleaned up when the bridge is detached to avoid
use-after-free conditions.

v2: Cleanup connector only if it was created

Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper from the lvds-encoder bridge.")
Cc: <stable@vger.kernel.org> # 4.12+
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/bridge/panel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/bridge/panel.c b/drivers/gpu/drm/bridge/panel.c
index 0ddc37551194..df86b0ee0549 100644
--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -87,6 +87,12 @@ static int panel_bridge_attach(struct drm_bridge *bridge,
 
 static void panel_bridge_detach(struct drm_bridge *bridge)
 {
+	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
+	struct drm_connector *connector = &panel_bridge->connector;
+
+	/* Cleanup the connector if we know it was initialized */
+	if (!!panel_bridge->connector.dev)
+		drm_connector_cleanup(connector);
 }
 
 static void panel_bridge_pre_enable(struct drm_bridge *bridge)
-- 
2.29.2

