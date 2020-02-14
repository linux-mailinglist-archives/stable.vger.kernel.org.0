Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD59B15DF02
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390531AbgBNQGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390525AbgBNQGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0AD2467E;
        Fri, 14 Feb 2020 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696412;
        bh=BkeCDCXnKVwTip7iyTt+FfDyu2ATkf6VOlxlRQIttG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6qjOyJTeIbPkD10qRuxHFeaZR+lr28/EiXCG1tqLHHabW12o04J7fVxwMAWOSJt0
         VD+Gck6z7ndsNRTxDz0Z1/p083nJBSI0oNRCpuA+yIMRlaRekj+A/u5bRsgNy1X1hZ
         IQ7KGvkSuj/uYsveVLvAvozBSHhDXwftzZXGcvQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manasi Navare <manasi.d.navare@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 234/459] drm/fbdev: Fallback to non tiled mode if all tiles not present
Date:   Fri, 14 Feb 2020 10:58:04 -0500
Message-Id: <20200214160149.11681-234-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manasi Navare <manasi.d.navare@intel.com>

[ Upstream commit f25c7a006cd1c07254780e3406e45cee4842b933 ]

In case of tiled displays, if we hotplug just one connector,
fbcon currently just selects the preferred mode and if it is
tiled mode then that becomes a problem if rest of the tiles are
not present.
So in the fbdev driver on hotplug when we probe the client modeset,
if we dont find all the connectors for all tiles, then on a connector
with one tile, just fallback to the first available non tiled mode
to display over a single connector.
On the hotplug of the consecutive tiled connectors, if the tiled mode
no longer exists because of fbcon size limitation, then return
no modes for consecutive tiles but retain the non tiled mode
on the 0th tile.
Use the same logic in case of connected boot case as well.
This has been tested with Dell UP328K tiled monitor.

v2:
* Set the modes on consecutive hotplugged tiles to no mode
if tiled mode is pruned (Dave)
v1:
* Just handle the 1st connector hotplug case
* v1 Reviewed-by: Dave Airlie <airlied@redhat.com>

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Suggested-by: Dave Airlie <airlied@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191113222952.9231-1-manasi.d.navare@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client_modeset.c | 72 ++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index c8922b7cac091..12e748b202d6f 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -114,6 +114,33 @@ drm_client_find_modeset(struct drm_client_dev *client, struct drm_crtc *crtc)
 	return NULL;
 }
 
+static struct drm_display_mode *
+drm_connector_get_tiled_mode(struct drm_connector *connector)
+{
+	struct drm_display_mode *mode;
+
+	list_for_each_entry(mode, &connector->modes, head) {
+		if (mode->hdisplay == connector->tile_h_size &&
+		    mode->vdisplay == connector->tile_v_size)
+			return mode;
+	}
+	return NULL;
+}
+
+static struct drm_display_mode *
+drm_connector_fallback_non_tiled_mode(struct drm_connector *connector)
+{
+	struct drm_display_mode *mode;
+
+	list_for_each_entry(mode, &connector->modes, head) {
+		if (mode->hdisplay == connector->tile_h_size &&
+		    mode->vdisplay == connector->tile_v_size)
+			continue;
+		return mode;
+	}
+	return NULL;
+}
+
 static struct drm_display_mode *
 drm_connector_has_preferred_mode(struct drm_connector *connector, int width, int height)
 {
@@ -348,8 +375,15 @@ static bool drm_client_target_preferred(struct drm_connector **connectors,
 	struct drm_connector *connector;
 	u64 conn_configured = 0;
 	int tile_pass = 0;
+	int num_tiled_conns = 0;
 	int i;
 
+	for (i = 0; i < connector_count; i++) {
+		if (connectors[i]->has_tile &&
+		    connectors[i]->status == connector_status_connected)
+			num_tiled_conns++;
+	}
+
 retry:
 	for (i = 0; i < connector_count; i++) {
 		connector = connectors[i];
@@ -399,6 +433,28 @@ static bool drm_client_target_preferred(struct drm_connector **connectors,
 			list_for_each_entry(modes[i], &connector->modes, head)
 				break;
 		}
+		/*
+		 * In case of tiled mode if all tiles not present fallback to
+		 * first available non tiled mode.
+		 * After all tiles are present, try to find the tiled mode
+		 * for all and if tiled mode not present due to fbcon size
+		 * limitations, use first non tiled mode only for
+		 * tile 0,0 and set to no mode for all other tiles.
+		 */
+		if (connector->has_tile) {
+			if (num_tiled_conns <
+			    connector->num_h_tile * connector->num_v_tile ||
+			    (connector->tile_h_loc == 0 &&
+			     connector->tile_v_loc == 0 &&
+			     !drm_connector_get_tiled_mode(connector))) {
+				DRM_DEBUG_KMS("Falling back to non tiled mode on Connector %d\n",
+					      connector->base.id);
+				modes[i] = drm_connector_fallback_non_tiled_mode(connector);
+			} else {
+				modes[i] = drm_connector_get_tiled_mode(connector);
+			}
+		}
+
 		DRM_DEBUG_KMS("found mode %s\n", modes[i] ? modes[i]->name :
 			  "none");
 		conn_configured |= BIT_ULL(i);
@@ -516,6 +572,7 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 	bool fallback = true, ret = true;
 	int num_connectors_enabled = 0;
 	int num_connectors_detected = 0;
+	int num_tiled_conns = 0;
 	struct drm_modeset_acquire_ctx ctx;
 
 	if (!drm_drv_uses_atomic_modeset(dev))
@@ -533,6 +590,11 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 	memcpy(save_enabled, enabled, count);
 	mask = GENMASK(count - 1, 0);
 	conn_configured = 0;
+	for (i = 0; i < count; i++) {
+		if (connectors[i]->has_tile &&
+		    connectors[i]->status == connector_status_connected)
+			num_tiled_conns++;
+	}
 retry:
 	conn_seq = conn_configured;
 	for (i = 0; i < count; i++) {
@@ -632,6 +694,16 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 				      connector->name);
 			modes[i] = &connector->state->crtc->mode;
 		}
+		/*
+		 * In case of tiled modes, if all tiles are not present
+		 * then fallback to a non tiled mode.
+		 */
+		if (connector->has_tile &&
+		    num_tiled_conns < connector->num_h_tile * connector->num_v_tile) {
+			DRM_DEBUG_KMS("Falling back to non tiled mode on Connector %d\n",
+				      connector->base.id);
+			modes[i] = drm_connector_fallback_non_tiled_mode(connector);
+		}
 		crtcs[i] = new_crtc;
 
 		DRM_DEBUG_KMS("connector %s on [CRTC:%d:%s]: %dx%d%s\n",
-- 
2.20.1

