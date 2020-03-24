Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E04190FE9
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCXNYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbgCXNYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1067D208CA;
        Tue, 24 Mar 2020 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056245;
        bh=Do/q2I9PYs7qYwGjPxeQeS5iqniDuaprnn5AUfkpS9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhtBLf5qxfdY2iHSgDGN0kf0aTWghuyBJ1LjRRMI9VG1z0yYuxVCAshCtRVd3BdVm
         ZJx0d4RLAEFP04lzUKcWzOTqFvNbpWKr7SzCiorlYa67JSfgTDbEKb89xLMa+BgzQk
         mRUtrOCaH+tr7oOu3Dn7cIKlpSrk4Yn8qpXAEn54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 041/119] Revert "drm/fbdev: Fallback to non tiled mode if all tiles not present"
Date:   Tue, 24 Mar 2020 14:10:26 +0100
Message-Id: <20200324130812.465138274@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f053c83ad5c88427644e06746bfddcefa409c27d ]

This reverts commit f25c7a006cd1 ("drm/fbdev: Fallback to non tiled mode
if all tiles not present"). The commit causes flip done timeouts in CI.

Below are the sample errors thrown in logs:

[IGT] core_getversion: executing
[IGT] core_getversion: exiting, ret=0
Setting dangerous option reset - tainting kernel
drm:drm_atomic_helper_wait_for_dependencies] ERROR [CRTC:152:pipe B] flip_done timed out
drm:drm_atomic_helper_wait_for_dependencies] ERROR [CONNECTOR:299:DP-2] flip_done timed out
drm:drm_atomic_helper_wait_for_dependencies] ERROR [PLANE:92:plane 1B] flip_done timed out
[drm:drm_atomic_helper_wait_for_flip_done] ERROR [CRTC:152:pipe B] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] ERROR [CRTC:152:pipe B] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] ERROR [CONNECTOR:299:DP-2] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] ERROR [PLANE:92:plane 1B] flip_done timed out
[drm:drm_atomic_helper_wait_for_flip_done] ERROR [CRTC:152:pipe B] flip_done timed out
Console: switching to colour frame buffer device 480x135
[drm:drm_atomic_helper_wait_for_dependencies] ERROR [CRTC:152:pipe B] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] ERROR [CONNECTOR:299:DP-2] flip_done timed out

Reverting the change for now to unblock CI execution.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Fixes: f25c7a006cd1 ("drm/fbdev: Fallback to non tiled mode if all tiles not present")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/6
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191123091840.32382-1-uma.shankar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client_modeset.c | 72 ----------------------------
 1 file changed, 72 deletions(-)

diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index 3035584f6dc72..29367b6506a8f 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -114,33 +114,6 @@ drm_client_find_modeset(struct drm_client_dev *client, struct drm_crtc *crtc)
 	return NULL;
 }
 
-static struct drm_display_mode *
-drm_connector_get_tiled_mode(struct drm_connector *connector)
-{
-	struct drm_display_mode *mode;
-
-	list_for_each_entry(mode, &connector->modes, head) {
-		if (mode->hdisplay == connector->tile_h_size &&
-		    mode->vdisplay == connector->tile_v_size)
-			return mode;
-	}
-	return NULL;
-}
-
-static struct drm_display_mode *
-drm_connector_fallback_non_tiled_mode(struct drm_connector *connector)
-{
-	struct drm_display_mode *mode;
-
-	list_for_each_entry(mode, &connector->modes, head) {
-		if (mode->hdisplay == connector->tile_h_size &&
-		    mode->vdisplay == connector->tile_v_size)
-			continue;
-		return mode;
-	}
-	return NULL;
-}
-
 static struct drm_display_mode *
 drm_connector_has_preferred_mode(struct drm_connector *connector, int width, int height)
 {
@@ -375,15 +348,8 @@ static bool drm_client_target_preferred(struct drm_connector **connectors,
 	struct drm_connector *connector;
 	u64 conn_configured = 0;
 	int tile_pass = 0;
-	int num_tiled_conns = 0;
 	int i;
 
-	for (i = 0; i < connector_count; i++) {
-		if (connectors[i]->has_tile &&
-		    connectors[i]->status == connector_status_connected)
-			num_tiled_conns++;
-	}
-
 retry:
 	for (i = 0; i < connector_count; i++) {
 		connector = connectors[i];
@@ -433,28 +399,6 @@ static bool drm_client_target_preferred(struct drm_connector **connectors,
 			list_for_each_entry(modes[i], &connector->modes, head)
 				break;
 		}
-		/*
-		 * In case of tiled mode if all tiles not present fallback to
-		 * first available non tiled mode.
-		 * After all tiles are present, try to find the tiled mode
-		 * for all and if tiled mode not present due to fbcon size
-		 * limitations, use first non tiled mode only for
-		 * tile 0,0 and set to no mode for all other tiles.
-		 */
-		if (connector->has_tile) {
-			if (num_tiled_conns <
-			    connector->num_h_tile * connector->num_v_tile ||
-			    (connector->tile_h_loc == 0 &&
-			     connector->tile_v_loc == 0 &&
-			     !drm_connector_get_tiled_mode(connector))) {
-				DRM_DEBUG_KMS("Falling back to non tiled mode on Connector %d\n",
-					      connector->base.id);
-				modes[i] = drm_connector_fallback_non_tiled_mode(connector);
-			} else {
-				modes[i] = drm_connector_get_tiled_mode(connector);
-			}
-		}
-
 		DRM_DEBUG_KMS("found mode %s\n", modes[i] ? modes[i]->name :
 			  "none");
 		conn_configured |= BIT_ULL(i);
@@ -571,7 +515,6 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 	bool fallback = true, ret = true;
 	int num_connectors_enabled = 0;
 	int num_connectors_detected = 0;
-	int num_tiled_conns = 0;
 	struct drm_modeset_acquire_ctx ctx;
 
 	if (!drm_drv_uses_atomic_modeset(dev))
@@ -589,11 +532,6 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 	memcpy(save_enabled, enabled, count);
 	mask = GENMASK(count - 1, 0);
 	conn_configured = 0;
-	for (i = 0; i < count; i++) {
-		if (connectors[i]->has_tile &&
-		    connectors[i]->status == connector_status_connected)
-			num_tiled_conns++;
-	}
 retry:
 	conn_seq = conn_configured;
 	for (i = 0; i < count; i++) {
@@ -693,16 +631,6 @@ static bool drm_client_firmware_config(struct drm_client_dev *client,
 				      connector->name);
 			modes[i] = &connector->state->crtc->mode;
 		}
-		/*
-		 * In case of tiled modes, if all tiles are not present
-		 * then fallback to a non tiled mode.
-		 */
-		if (connector->has_tile &&
-		    num_tiled_conns < connector->num_h_tile * connector->num_v_tile) {
-			DRM_DEBUG_KMS("Falling back to non tiled mode on Connector %d\n",
-				      connector->base.id);
-			modes[i] = drm_connector_fallback_non_tiled_mode(connector);
-		}
 		crtcs[i] = new_crtc;
 
 		DRM_DEBUG_KMS("connector %s on [CRTC:%d:%s]: %dx%d%s\n",
-- 
2.20.1



