Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F97D6DEFB9
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjDLIxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjDLIxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE09ECF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D106310E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3AFC4339E;
        Wed, 12 Apr 2023 08:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289240;
        bh=ZwWzCoWqRtee3WK+9ne5c5HfcjA5A939EML7leNsb6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiJBY0HcCz3snEaP92EbWcsHB4URboUKsLJs0sizgApOutMp9kOZ9sXOzXL8fWTc9
         r7uM0/nBKwfem/zgVrElQBah64HVDQa888ZRo3ZAKmoK81GTT863/4kqUDxIGnBdI5
         jJR888CJQBZ4rrd365gcYcxAxS8IA9Fz7GSqM+jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 005/173] drm/i915: Move the DSB setup/cleaup into the color code
Date:   Wed, 12 Apr 2023 10:32:11 +0200
Message-Id: <20230412082838.356197188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit efb2b57edf20c32b08eee4ce8b436c459fe4caea ]

Since the color management code is the only user of the DSB
at the moment move the DSB prepare/cleanup there too. The
code has to anyway make decisions on whether to use the DSB
or not (and how to use it). Also we'll need a place where we
actually generate the DSB command buffer ahead of time rather
than the current situation where it gets generated too late
during the mmio programming of the hardware.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221123152638.20622-9-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Stable-dep-of: c880f855d1e2 ("drm/i915: Add a .color_post_update() hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_color.c   | 10 ++++++++
 drivers/gpu/drm/i915/display/intel_color.h   |  2 ++
 drivers/gpu/drm/i915/display/intel_display.c | 25 ++++++++------------
 drivers/gpu/drm/i915/display/intel_display.h |  8 +++++++
 4 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index c3928d28cd443..ff6b8aaaa2194 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -1220,6 +1220,16 @@ void intel_color_commit_arm(const struct intel_crtc_state *crtc_state)
 	i915->display.funcs.color->color_commit_arm(crtc_state);
 }
 
+void intel_color_prepare_commit(struct intel_crtc_state *crtc_state)
+{
+	intel_dsb_prepare(crtc_state);
+}
+
+void intel_color_cleanup_commit(struct intel_crtc_state *crtc_state)
+{
+	intel_dsb_cleanup(crtc_state);
+}
+
 static bool intel_can_preload_luts(const struct intel_crtc_state *new_crtc_state)
 {
 	struct intel_crtc *crtc = to_intel_crtc(new_crtc_state->uapi.crtc);
diff --git a/drivers/gpu/drm/i915/display/intel_color.h b/drivers/gpu/drm/i915/display/intel_color.h
index 2a5ada67774d0..0e85406036b54 100644
--- a/drivers/gpu/drm/i915/display/intel_color.h
+++ b/drivers/gpu/drm/i915/display/intel_color.h
@@ -17,6 +17,8 @@ void intel_color_init_hooks(struct drm_i915_private *i915);
 int intel_color_init(struct drm_i915_private *i915);
 void intel_color_crtc_init(struct intel_crtc *crtc);
 int intel_color_check(struct intel_crtc_state *crtc_state);
+void intel_color_prepare_commit(struct intel_crtc_state *crtc_state);
+void intel_color_cleanup_commit(struct intel_crtc_state *crtc_state);
 void intel_color_commit_noarm(const struct intel_crtc_state *crtc_state);
 void intel_color_commit_arm(const struct intel_crtc_state *crtc_state);
 void intel_color_load_luts(const struct intel_crtc_state *crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index f0aad2403109b..ca76408b99b38 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -93,7 +93,6 @@
 #include "intel_dp_link_training.h"
 #include "intel_dpio_phy.h"
 #include "intel_dpt.h"
-#include "intel_dsb.h"
 #include "intel_fbc.h"
 #include "intel_fbdev.h"
 #include "intel_fdi.h"
@@ -6946,7 +6945,7 @@ static int intel_atomic_prepare_commit(struct intel_atomic_state *state)
 
 	for_each_new_intel_crtc_in_state(state, crtc, crtc_state, i) {
 		if (intel_crtc_needs_color_update(crtc_state))
-			intel_dsb_prepare(crtc_state);
+			intel_color_prepare_commit(crtc_state);
 	}
 
 	return 0;
@@ -7399,24 +7398,18 @@ static void intel_atomic_commit_fence_wait(struct intel_atomic_state *intel_stat
 		    &wait_reset);
 }
 
-static void intel_cleanup_dsbs(struct intel_atomic_state *state)
-{
-	struct intel_crtc_state *old_crtc_state, *new_crtc_state;
-	struct intel_crtc *crtc;
-	int i;
-
-	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
-					    new_crtc_state, i)
-		intel_dsb_cleanup(old_crtc_state);
-}
-
 static void intel_atomic_cleanup_work(struct work_struct *work)
 {
 	struct intel_atomic_state *state =
 		container_of(work, struct intel_atomic_state, base.commit_work);
 	struct drm_i915_private *i915 = to_i915(state->base.dev);
+	struct intel_crtc_state *old_crtc_state;
+	struct intel_crtc *crtc;
+	int i;
+
+	for_each_old_intel_crtc_in_state(state, crtc, old_crtc_state, i)
+		intel_color_cleanup_commit(old_crtc_state);
 
-	intel_cleanup_dsbs(state);
 	drm_atomic_helper_cleanup_planes(&i915->drm, &state->base);
 	drm_atomic_helper_commit_cleanup_done(&state->base);
 	drm_atomic_state_put(&state->base);
@@ -7624,6 +7617,8 @@ static void intel_atomic_commit_tail(struct intel_atomic_state *state)
 		 * DSB cleanup is done in cleanup_work aligning with framebuffer
 		 * cleanup. So copy and reset the dsb structure to sync with
 		 * commit_done and later do dsb cleanup in cleanup_work.
+		 *
+		 * FIXME get rid of this funny new->old swapping
 		 */
 		old_crtc_state->dsb = fetch_and_zero(&new_crtc_state->dsb);
 	}
@@ -7774,7 +7769,7 @@ static int intel_atomic_commit(struct drm_device *dev,
 		i915_sw_fence_commit(&state->commit_ready);
 
 		for_each_new_intel_crtc_in_state(state, crtc, new_crtc_state, i)
-			intel_dsb_cleanup(new_crtc_state);
+			intel_color_cleanup_commit(new_crtc_state);
 
 		drm_atomic_helper_cleanup_planes(dev, &state->base);
 		intel_runtime_pm_put(&dev_priv->runtime_pm, state->wakeref);
diff --git a/drivers/gpu/drm/i915/display/intel_display.h b/drivers/gpu/drm/i915/display/intel_display.h
index 714030136b7f2..ef73730f32b09 100644
--- a/drivers/gpu/drm/i915/display/intel_display.h
+++ b/drivers/gpu/drm/i915/display/intel_display.h
@@ -440,6 +440,14 @@ enum hpd_pin {
 	     (__i)++) \
 		for_each_if(plane)
 
+#define for_each_old_intel_crtc_in_state(__state, crtc, old_crtc_state, __i) \
+	for ((__i) = 0; \
+	     (__i) < (__state)->base.dev->mode_config.num_crtc && \
+		     ((crtc) = to_intel_crtc((__state)->base.crtcs[__i].ptr), \
+		      (old_crtc_state) = to_intel_crtc_state((__state)->base.crtcs[__i].old_state), 1); \
+	     (__i)++) \
+		for_each_if(crtc)
+
 #define for_each_new_intel_plane_in_state(__state, plane, new_plane_state, __i) \
 	for ((__i) = 0; \
 	     (__i) < (__state)->base.dev->mode_config.num_total_plane && \
-- 
2.39.2



