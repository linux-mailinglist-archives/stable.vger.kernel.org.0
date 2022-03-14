Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963D14D8369
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiCNMNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiCNMNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:13:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FA136E33;
        Mon, 14 Mar 2022 05:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D366137C;
        Mon, 14 Mar 2022 12:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31891C340EC;
        Mon, 14 Mar 2022 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259870;
        bh=ZQzY0kOoJ4xEPBHHmkNThIkdhKvGqVT89bJ2GEzGjk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlSdpFiwhqJzaNUL71pcijXVq2MKMjz0AQmvw51bPKSd/7Rrh29CefN5b4MKz0sGQ
         r4PKn/FocEb4b4O5QU3e+g1dc9FZIeJ6cHx3kMaBfu+K4pA0us1Xaq35GbqQIAeoD+
         j3BdqKVL+CJOovIJlC09EwtqT3/w5opBPosU/9as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 107/110] drm/i915: Workaround broken BIOS DBUF configuration on TGL/RKL
Date:   Mon, 14 Mar 2022 12:54:49 +0100
Message-Id: <20220314112746.013068312@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4e6f55120c7eccf6f9323bb681632e23cbcb3f3c upstream.

On TGL/RKL the BIOS likes to use some kind of bogus DBUF layout
that doesn't match what the spec recommends. With a single active
pipe that is not going to be a problem, but with multiple pipes
active skl_commit_modeset_enables() goes into an infinite loop
since it can't figure out any order in which it can commit the
pipes without causing DBUF overlaps between the planes.

We'd need some kind of extra DBUF defrag stage in between to
make the transition possible. But that is clearly way too complex
a solution, so in the name of simplicity let's just sanitize the
DBUF state by simply turning off all planes when we detect a
pipe encroaching on its neighbours' DBUF slices. We only have
to disable the primary planes as all other planes should have
already been disabled (if they somehow were enabled) by
earlier sanitization steps.

And for good measure let's also sanitize in case the DBUF
allocations of the pipes already seem to overlap each other.

Cc: <stable@vger.kernel.org> # v5.14+
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4762
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204141818.1900-3-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit 15512021eb3975a8c2366e3883337e252bb0eee5)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    5 +
 drivers/gpu/drm/i915/display/intel_display.h |    2 
 drivers/gpu/drm/i915/intel_pm.c              |   68 +++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_pm.h              |    1 
 4 files changed, 74 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1658,8 +1658,8 @@ static void fixup_plane_bitmasks(struct
 	}
 }
 
-static void intel_plane_disable_noatomic(struct intel_crtc *crtc,
-					 struct intel_plane *plane)
+void intel_plane_disable_noatomic(struct intel_crtc *crtc,
+				  struct intel_plane *plane)
 {
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	struct intel_crtc_state *crtc_state =
@@ -13217,6 +13217,7 @@ intel_modeset_setup_hw_state(struct drm_
 		vlv_wm_sanitize(dev_priv);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
 		skl_wm_get_hw_state(dev_priv);
+		skl_wm_sanitize(dev_priv);
 	} else if (HAS_PCH_SPLIT(dev_priv)) {
 		ilk_wm_get_hw_state(dev_priv);
 	}
--- a/drivers/gpu/drm/i915/display/intel_display.h
+++ b/drivers/gpu/drm/i915/display/intel_display.h
@@ -629,6 +629,8 @@ void intel_plane_unpin_fb(struct intel_p
 struct intel_encoder *
 intel_get_crtc_new_encoder(const struct intel_atomic_state *state,
 			   const struct intel_crtc_state *crtc_state);
+void intel_plane_disable_noatomic(struct intel_crtc *crtc,
+				  struct intel_plane *plane);
 
 unsigned int intel_surf_alignment(const struct drm_framebuffer *fb,
 				  int color_plane);
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6681,6 +6681,74 @@ void skl_wm_get_hw_state(struct drm_i915
 	dbuf_state->enabled_slices = dev_priv->dbuf.enabled_slices;
 }
 
+static bool skl_dbuf_is_misconfigured(struct drm_i915_private *i915)
+{
+	const struct intel_dbuf_state *dbuf_state =
+		to_intel_dbuf_state(i915->dbuf.obj.state);
+	struct skl_ddb_entry entries[I915_MAX_PIPES] = {};
+	struct intel_crtc *crtc;
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		const struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+
+		entries[crtc->pipe] = crtc_state->wm.skl.ddb;
+	}
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		const struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+		u8 slices;
+
+		slices = skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
+						 dbuf_state->joined_mbus);
+		if (dbuf_state->slices[crtc->pipe] & ~slices)
+			return true;
+
+		if (skl_ddb_allocation_overlaps(&crtc_state->wm.skl.ddb, entries,
+						I915_MAX_PIPES, crtc->pipe))
+			return true;
+	}
+
+	return false;
+}
+
+void skl_wm_sanitize(struct drm_i915_private *i915)
+{
+	struct intel_crtc *crtc;
+
+	/*
+	 * On TGL/RKL (at least) the BIOS likes to assign the planes
+	 * to the wrong DBUF slices. This will cause an infinite loop
+	 * in skl_commit_modeset_enables() as it can't find a way to
+	 * transition between the old bogus DBUF layout to the new
+	 * proper DBUF layout without DBUF allocation overlaps between
+	 * the planes (which cannot be allowed or else the hardware
+	 * may hang). If we detect a bogus DBUF layout just turn off
+	 * all the planes so that skl_commit_modeset_enables() can
+	 * simply ignore them.
+	 */
+	if (!skl_dbuf_is_misconfigured(i915))
+		return;
+
+	drm_dbg_kms(&i915->drm, "BIOS has misprogrammed the DBUF, disabling all planes\n");
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		struct intel_plane *plane = to_intel_plane(crtc->base.primary);
+		const struct intel_plane_state *plane_state =
+			to_intel_plane_state(plane->base.state);
+		struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+
+		if (plane_state->uapi.visible)
+			intel_plane_disable_noatomic(crtc, plane);
+
+		drm_WARN_ON(&i915->drm, crtc_state->active_planes != 0);
+
+		memset(&crtc_state->wm.skl.ddb, 0, sizeof(crtc_state->wm.skl.ddb));
+	}
+}
+
 static void ilk_pipe_wm_get_hw_state(struct intel_crtc *crtc)
 {
 	struct drm_device *dev = crtc->base.dev;
--- a/drivers/gpu/drm/i915/intel_pm.h
+++ b/drivers/gpu/drm/i915/intel_pm.h
@@ -48,6 +48,7 @@ void skl_pipe_wm_get_hw_state(struct int
 			      struct skl_pipe_wm *out);
 void g4x_wm_sanitize(struct drm_i915_private *dev_priv);
 void vlv_wm_sanitize(struct drm_i915_private *dev_priv);
+void skl_wm_sanitize(struct drm_i915_private *dev_priv);
 bool intel_can_enable_sagv(struct drm_i915_private *dev_priv,
 			   const struct intel_bw_state *bw_state);
 void intel_sagv_pre_plane_update(struct intel_atomic_state *state);


