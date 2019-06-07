Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8254639056
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfFGPuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbfFGPuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CC620840;
        Fri,  7 Jun 2019 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922620;
        bh=hGiZwCLJZ5kXx2cEqrIQ0M0cdug7o1WlyxRzqNq1Bog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfBN9L6pqbAGv1V8e2NZy+qbG/WAxjq609HgXbaGTFUB8xlAY+7nRAk1G13bc66UB
         r2dUCz/Lj5RxF/LQ/JjEL/uns9N/QMn/m7c55cstOVbuMucwSdnitHWn8PD24DJwg8
         PFQOEKcPNDs8ItRLxL+jp+QLczSJSUnXlf1zdTro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.1 79/85] drm/atomic: Wire file_priv through for property changes
Date:   Fri,  7 Jun 2019 17:40:04 +0200
Message-Id: <20190607153857.733115350@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 36e4523aaf4a35de963e190064b53839fa131653 upstream.

We need this to make sure lessees can only connect their
plane/connectors to crtc objects they own. And note that this is
irrespective of whether the lessor is atomic or not, lessor cannot
prevent lessees from enabling atomic.

Cc: stable@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190228144910.26488-7-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_atomic_uapi.c   |   32 +++++++++++++++++++-------------
 drivers/gpu/drm/drm_crtc_internal.h |    1 +
 drivers/gpu/drm/drm_mode_object.c   |    5 +++--
 3 files changed, 23 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -512,8 +512,8 @@ drm_atomic_crtc_get_property(struct drm_
 }
 
 static int drm_atomic_plane_set_property(struct drm_plane *plane,
-		struct drm_plane_state *state, struct drm_property *property,
-		uint64_t val)
+		struct drm_plane_state *state, struct drm_file *file_priv,
+		struct drm_property *property, uint64_t val)
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_mode_config *config = &dev->mode_config;
@@ -521,7 +521,8 @@ static int drm_atomic_plane_set_property
 	int ret;
 
 	if (property == config->prop_fb_id) {
-		struct drm_framebuffer *fb = drm_framebuffer_lookup(dev, NULL, val);
+		struct drm_framebuffer *fb;
+		fb = drm_framebuffer_lookup(dev, file_priv, val);
 		drm_atomic_set_fb_for_plane(state, fb);
 		if (fb)
 			drm_framebuffer_put(fb);
@@ -537,7 +538,7 @@ static int drm_atomic_plane_set_property
 			return -EINVAL;
 
 	} else if (property == config->prop_crtc_id) {
-		struct drm_crtc *crtc = drm_crtc_find(dev, NULL, val);
+		struct drm_crtc *crtc = drm_crtc_find(dev, file_priv, val);
 		return drm_atomic_set_crtc_for_plane(state, crtc);
 	} else if (property == config->prop_crtc_x) {
 		state->crtc_x = U642I64(val);
@@ -681,14 +682,14 @@ static int drm_atomic_set_writeback_fb_f
 }
 
 static int drm_atomic_connector_set_property(struct drm_connector *connector,
-		struct drm_connector_state *state, struct drm_property *property,
-		uint64_t val)
+		struct drm_connector_state *state, struct drm_file *file_priv,
+		struct drm_property *property, uint64_t val)
 {
 	struct drm_device *dev = connector->dev;
 	struct drm_mode_config *config = &dev->mode_config;
 
 	if (property == config->prop_crtc_id) {
-		struct drm_crtc *crtc = drm_crtc_find(dev, NULL, val);
+		struct drm_crtc *crtc = drm_crtc_find(dev, file_priv, val);
 		return drm_atomic_set_crtc_for_connector(state, crtc);
 	} else if (property == config->dpms_property) {
 		/* setting DPMS property requires special handling, which
@@ -747,8 +748,10 @@ static int drm_atomic_connector_set_prop
 		}
 		state->content_protection = val;
 	} else if (property == config->writeback_fb_id_property) {
-		struct drm_framebuffer *fb = drm_framebuffer_lookup(dev, NULL, val);
-		int ret = drm_atomic_set_writeback_fb_for_connector(state, fb);
+		struct drm_framebuffer *fb;
+		int ret;
+		fb = drm_framebuffer_lookup(dev, file_priv, val);
+		ret = drm_atomic_set_writeback_fb_for_connector(state, fb);
 		if (fb)
 			drm_framebuffer_put(fb);
 		return ret;
@@ -943,6 +946,7 @@ out:
 }
 
 int drm_atomic_set_property(struct drm_atomic_state *state,
+			    struct drm_file *file_priv,
 			    struct drm_mode_object *obj,
 			    struct drm_property *prop,
 			    uint64_t prop_value)
@@ -965,7 +969,8 @@ int drm_atomic_set_property(struct drm_a
 		}
 
 		ret = drm_atomic_connector_set_property(connector,
-				connector_state, prop, prop_value);
+				connector_state, file_priv,
+				prop, prop_value);
 		break;
 	}
 	case DRM_MODE_OBJECT_CRTC: {
@@ -993,7 +998,8 @@ int drm_atomic_set_property(struct drm_a
 		}
 
 		ret = drm_atomic_plane_set_property(plane,
-				plane_state, prop, prop_value);
+				plane_state, file_priv,
+				prop, prop_value);
 		break;
 	}
 	default:
@@ -1365,8 +1371,8 @@ retry:
 				goto out;
 			}
 
-			ret = drm_atomic_set_property(state, obj, prop,
-						      prop_value);
+			ret = drm_atomic_set_property(state, file_priv,
+						      obj, prop, prop_value);
 			if (ret) {
 				drm_mode_object_put(obj);
 				goto out;
--- a/drivers/gpu/drm/drm_crtc_internal.h
+++ b/drivers/gpu/drm/drm_crtc_internal.h
@@ -214,6 +214,7 @@ int drm_atomic_connector_commit_dpms(str
 				     struct drm_connector *connector,
 				     int mode);
 int drm_atomic_set_property(struct drm_atomic_state *state,
+			    struct drm_file *file_priv,
 			    struct drm_mode_object *obj,
 			    struct drm_property *prop,
 			    uint64_t prop_value);
--- a/drivers/gpu/drm/drm_mode_object.c
+++ b/drivers/gpu/drm/drm_mode_object.c
@@ -451,6 +451,7 @@ static int set_property_legacy(struct dr
 }
 
 static int set_property_atomic(struct drm_mode_object *obj,
+			       struct drm_file *file_priv,
 			       struct drm_property *prop,
 			       uint64_t prop_value)
 {
@@ -477,7 +478,7 @@ retry:
 						       obj_to_connector(obj),
 						       prop_value);
 	} else {
-		ret = drm_atomic_set_property(state, obj, prop, prop_value);
+		ret = drm_atomic_set_property(state, file_priv, obj, prop, prop_value);
 		if (ret)
 			goto out;
 		ret = drm_atomic_commit(state);
@@ -520,7 +521,7 @@ int drm_mode_obj_set_property_ioctl(stru
 		goto out_unref;
 
 	if (drm_drv_uses_atomic_modeset(property->dev))
-		ret = set_property_atomic(arg_obj, property, arg->value);
+		ret = set_property_atomic(arg_obj, file_priv, property, arg->value);
 	else
 		ret = set_property_legacy(arg_obj, property, arg->value);
 


