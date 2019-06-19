Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B74C433
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfFSXwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:52:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:43648 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbfFSXwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 19:52:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 16:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162363846"
Received: from anusha.jf.intel.com ([10.54.75.56])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 16:52:09 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 14/21] drm/i915/dsi: Use a fuzzy check for burst mode clock check
Date:   Wed, 19 Jun 2019 16:42:17 -0700
Message-Id: <20190619234224.7681-15-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619234224.7681-1-anusha.srivatsa@intel.com>
References: <20190619234224.7681-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

Prior to this commit we fail to init the DSI panel on the GPD MicroPC:
https://www.indiegogo.com/projects/gpd-micropc-6-inch-handheld-industry-laptop#/

The problem is intel_dsi_vbt_init() failing with the following error:
*ERROR* Burst mode freq is less than computed

The pclk in the VBT panel modeline is 70000, together with 24 bpp and
4 lines this results in a bitrate value of 70000 * 24 / 4 = 420000.
But the target_burst_mode_freq in the VBT is 418000.

This commit works around this problem by adding an intel_fuzzy_clock_check
when target_burst_mode_freq < bitrate and setting target_burst_mode_freq to
bitrate when that checks succeeds, fixing the panel not working.

Cc: stable@vger.kernel.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524174028.21659-2-hdegoede@redhat.com
(cherry picked from commit 2c1c55252647abd989b94f725b190c700312d053)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |  2 +-
 drivers/gpu/drm/i915/intel_drv.h     |  1 +
 drivers/gpu/drm/i915/intel_dsi_vbt.c | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5098228f1302..ceb78f44f087 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11942,7 +11942,7 @@ intel_modeset_pipe_config(struct drm_crtc *crtc,
 	return 0;
 }
 
-static bool intel_fuzzy_clock_check(int clock1, int clock2)
+bool intel_fuzzy_clock_check(int clock1, int clock2)
 {
 	int diff;
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index a38b9cff5cd0..e85cd377a652 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -1742,6 +1742,7 @@ int vlv_force_pll_on(struct drm_i915_private *dev_priv, enum pipe pipe,
 		     const struct dpll *dpll);
 void vlv_force_pll_off(struct drm_i915_private *dev_priv, enum pipe pipe);
 int lpt_get_iclkip(struct drm_i915_private *dev_priv);
+bool intel_fuzzy_clock_check(int clock1, int clock2);
 
 /* modesetting asserts */
 void assert_panel_unlocked(struct drm_i915_private *dev_priv,
diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
index 3074448446bc..4b8e48db1843 100644
--- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
@@ -853,6 +853,17 @@ bool intel_dsi_vbt_init(struct intel_dsi *intel_dsi, u16 panel_id)
 		if (mipi_config->target_burst_mode_freq) {
 			u32 bitrate = intel_dsi_bitrate(intel_dsi);
 
+			/*
+			 * Sometimes the VBT contains a slightly lower clock,
+			 * then the bitrate we have calculated, in this case
+			 * just replace it with the calculated bitrate.
+			 */
+			if (mipi_config->target_burst_mode_freq < bitrate &&
+			    intel_fuzzy_clock_check(
+					mipi_config->target_burst_mode_freq,
+					bitrate))
+				mipi_config->target_burst_mode_freq = bitrate;
+
 			if (mipi_config->target_burst_mode_freq < bitrate) {
 				DRM_ERROR("Burst mode freq is less than computed\n");
 				return false;
