Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE837C794
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhELQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237889AbhELP4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C613861461;
        Wed, 12 May 2021 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833326;
        bh=LQXZaWxdFrbx4iUlhxsh9hQfXSBcjHWTSy6hmOmnKfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akLgOfEW8wW5n09bINQtu7zcl0TL+etDklRhfpi7j2sraRA5cdhPs/jM14JZ7Fpl/
         YyS7+MrdBP84wQPS380W5OLweIjqt9hyirMcavVqOdenJbDxEYqB0uo/fgj09i8GNE
         rgE4y8ifsVC2OVEy2rpXROtsAWElyEFXnHOm4d2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Paul Cercueil <paul@crapouillou.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.11 070/601] drm: bridge/panel: Cleanup connector on bridge detach
Date:   Wed, 12 May 2021 16:42:27 +0200
Message-Id: <20210512144830.122578348@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 4d906839d321c2efbf3fed4bc31ffd9ff55b75c0 upstream.

If we don't call drm_connector_cleanup() manually in
panel_bridge_detach(), the connector will be cleaned up with the other
DRM objects in the call to drm_mode_config_cleanup(). However, since our
drm_connector is devm-allocated, by the time drm_mode_config_cleanup()
will be called, our connector will be long gone. Therefore, the
connector must be cleaned up when the bridge is detached to avoid
use-after-free conditions.

v2: Cleanup connector only if it was created

v3: Add FIXME

v4: (Use connector->dev) directly in if() block

Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper from the lvds-encoder bridge.")
Cc: <stable@vger.kernel.org> # 4.12+
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210327115742.18986-2-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/panel.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/bridge/panel.c
+++ b/drivers/gpu/drm/bridge/panel.c
@@ -87,6 +87,18 @@ static int panel_bridge_attach(struct dr
 
 static void panel_bridge_detach(struct drm_bridge *bridge)
 {
+	struct panel_bridge *panel_bridge = drm_bridge_to_panel_bridge(bridge);
+	struct drm_connector *connector = &panel_bridge->connector;
+
+	/*
+	 * Cleanup the connector if we know it was initialized.
+	 *
+	 * FIXME: This wouldn't be needed if the panel_bridge structure was
+	 * allocated with drmm_kzalloc(). This might be tricky since the
+	 * drm_device pointer can only be retrieved when the bridge is attached.
+	 */
+	if (connector->dev)
+		drm_connector_cleanup(connector);
 }
 
 static void panel_bridge_pre_enable(struct drm_bridge *bridge)


