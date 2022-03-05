Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF54CE4CD
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 13:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiCEMdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 07:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCEMdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 07:33:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E54240052
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 04:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710FA61245
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740B4C004E1;
        Sat,  5 Mar 2022 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646483543;
        bh=aFdDeOpUrKnOpni4RLbo0x0ujABVDG5a91jmHJOiuFs=;
        h=Subject:To:Cc:From:Date:From;
        b=HOQOTU6veDmmKKsSQAgCfAPqXoNk4+a9kwEUkU88jSzbd3yabg9IaqsUmjqu48XbU
         VpZw9DOOHZ+O2vYU5Yec/qdHGudmvYJ5Lp8htRD1aoms+GxxhSsbwJNU8P0UCcKBhs
         scL4o6f1idfpMMX4ZqxRmwKK5lMkQkPhkxqn6JuA=
Subject: FAILED: patch "[PATCH] drm/i915: Workaround broken BIOS DBUF configuration on" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 13:32:20 +0100
Message-ID: <16464835403018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e6f55120c7eccf6f9323bb681632e23cbcb3f3c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Fri, 4 Feb 2022 16:18:18 +0200
Subject: [PATCH] drm/i915: Workaround broken BIOS DBUF configuration on
 TGL/RKL
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index bf7ce684dd8e..bb4a85445fc6 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -10673,6 +10673,7 @@ intel_modeset_setup_hw_state(struct drm_device *dev,
 		vlv_wm_sanitize(dev_priv);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
 		skl_wm_get_hw_state(dev_priv);
+		skl_wm_sanitize(dev_priv);
 	} else if (HAS_PCH_SPLIT(dev_priv)) {
 		ilk_wm_get_hw_state(dev_priv);
 	}
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index a298846dd8cf..3edba7fd0c49 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6698,6 +6698,74 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
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
diff --git a/drivers/gpu/drm/i915/intel_pm.h b/drivers/gpu/drm/i915/intel_pm.h
index 990cdcaf85ce..d2243653a893 100644
--- a/drivers/gpu/drm/i915/intel_pm.h
+++ b/drivers/gpu/drm/i915/intel_pm.h
@@ -47,6 +47,7 @@ void skl_pipe_wm_get_hw_state(struct intel_crtc *crtc,
 			      struct skl_pipe_wm *out);
 void g4x_wm_sanitize(struct drm_i915_private *dev_priv);
 void vlv_wm_sanitize(struct drm_i915_private *dev_priv);
+void skl_wm_sanitize(struct drm_i915_private *dev_priv);
 bool intel_can_enable_sagv(struct drm_i915_private *dev_priv,
 			   const struct intel_bw_state *bw_state);
 void intel_sagv_pre_plane_update(struct intel_atomic_state *state);

