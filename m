Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5174C436
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfFSXwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:52:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:43650 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730831AbfFSXwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 19:52:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 16:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162363856"
Received: from anusha.jf.intel.com ([10.54.75.56])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 16:52:09 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, zardam@gmail.com,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 17/21] drm/i915/sdvo: Implement proper HDMI audio support for SDVO
Date:   Wed, 19 Jun 2019 16:42:20 -0700
Message-Id: <20190619234224.7681-18-anusha.srivatsa@intel.com>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Our SDVO audio support is pretty bogus. We can't push audio over the
SDVO bus, so trying to enable audio in the SDVO control register doesn't
do anything. In fact it looks like the SDVO encoder will always mix in
the audio coming over HDA, and there's no (at least documented) way to
disable that from our side. So HDMI audio does work currently on gen4
but only by luck really. On gen3 it got broken by the referenced commit.
And what has always been missing on every platform is the ELD.

To pass the ELD to the audio driver we need to write it to magic buffer
in the SDVO encoder hardware which then gets pulled out via HDA in the
other end. Ie. pretty much the same thing we had for native HDMI before
we started to just pass the ELD between the drivers. This sort of
explains why we even have that silly hardware buffer with native HDMI.

$ cat /proc/asound/card0/eld#1.0
-monitor_present		0
-eld_valid		0
+monitor_present		1
+eld_valid		1
+monitor_name		LG TV
+connection_type		HDMI
+...

This also fixes our state readout since we can now query the SDVO
encoder about the state of the "ELD valid" and "presence detect"
bits. As mentioned those don't actually control whether audio
gets sent over the HDMI cable, but it's the best we can do. And with
the state checker appeased we can re-enable HDMI audio for gen3.

Cc: stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: zardam@gmail.com
Tested-by: zardam@gmail.com
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108976
Fixes: de44e256b92c ("drm/i915/sdvo: Shut up state checker with hdmi cards on gen3")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190409144054.24561-3-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit dc49a56bd43bb04982e64b44436831da801d0237)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c      | 58 +++++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_sdvo_regs.h |  3 ++
 2 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 0e3d91d9ef13..9ecfba0a54a1 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -916,6 +916,13 @@ static bool intel_sdvo_set_colorimetry(struct intel_sdvo *intel_sdvo,
 	return intel_sdvo_set_value(intel_sdvo, SDVO_CMD_SET_COLORIMETRY, &mode, 1);
 }
 
+static bool intel_sdvo_set_audio_state(struct intel_sdvo *intel_sdvo,
+				       u8 audio_state)
+{
+	return intel_sdvo_set_value(intel_sdvo, SDVO_CMD_SET_AUDIO_STAT,
+				    &audio_state, 1);
+}
+
 #if 0
 static void intel_sdvo_dump_hdmi_buf(struct intel_sdvo *intel_sdvo)
 {
@@ -1487,11 +1494,6 @@ static void intel_sdvo_pre_enable(struct intel_encoder *intel_encoder,
 	else
 		sdvox |= SDVO_PIPE_SEL(crtc->pipe);
 
-	if (crtc_state->has_audio) {
-		WARN_ON_ONCE(INTEL_GEN(dev_priv) < 4);
-		sdvox |= SDVO_AUDIO_ENABLE;
-	}
-
 	if (INTEL_GEN(dev_priv) >= 4) {
 		/* done in crtc_mode_set as the dpll_md reg must be written early */
 	} else if (IS_I945G(dev_priv) || IS_I945GM(dev_priv) ||
@@ -1635,8 +1637,13 @@ static void intel_sdvo_get_config(struct intel_encoder *encoder,
 	if (sdvox & HDMI_COLOR_RANGE_16_235)
 		pipe_config->limited_color_range = true;
 
-	if (sdvox & SDVO_AUDIO_ENABLE)
-		pipe_config->has_audio = true;
+	if (intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_AUDIO_STAT,
+				 &val, 1)) {
+		u8 mask = SDVO_AUDIO_ELD_VALID | SDVO_AUDIO_PRESENCE_DETECT;
+
+		if ((val & mask) == mask)
+			pipe_config->has_audio = true;
+	}
 
 	if (intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_ENCODE,
 				 &val, 1)) {
@@ -1647,6 +1654,32 @@ static void intel_sdvo_get_config(struct intel_encoder *encoder,
 	intel_sdvo_get_avi_infoframe(intel_sdvo, pipe_config);
 }
 
+static void intel_sdvo_disable_audio(struct intel_sdvo *intel_sdvo)
+{
+	intel_sdvo_set_audio_state(intel_sdvo, 0);
+}
+
+static void intel_sdvo_enable_audio(struct intel_sdvo *intel_sdvo,
+				    const struct intel_crtc_state *crtc_state,
+				    const struct drm_connector_state *conn_state)
+{
+	const struct drm_display_mode *adjusted_mode =
+		&crtc_state->base.adjusted_mode;
+	struct drm_connector *connector = conn_state->connector;
+	u8 *eld = connector->eld;
+
+	eld[6] = drm_av_sync_delay(connector, adjusted_mode) / 2;
+
+	intel_sdvo_set_audio_state(intel_sdvo, 0);
+
+	intel_sdvo_write_infoframe(intel_sdvo, SDVO_HBUF_INDEX_ELD,
+				   SDVO_HBUF_TX_DISABLED,
+				   eld, drm_eld_size(eld));
+
+	intel_sdvo_set_audio_state(intel_sdvo, SDVO_AUDIO_ELD_VALID |
+				   SDVO_AUDIO_PRESENCE_DETECT);
+}
+
 static void intel_disable_sdvo(struct intel_encoder *encoder,
 			       const struct intel_crtc_state *old_crtc_state,
 			       const struct drm_connector_state *conn_state)
@@ -1656,6 +1689,9 @@ static void intel_disable_sdvo(struct intel_encoder *encoder,
 	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->base.crtc);
 	u32 temp;
 
+	if (old_crtc_state->has_audio)
+		intel_sdvo_disable_audio(intel_sdvo);
+
 	intel_sdvo_set_active_outputs(intel_sdvo, 0);
 	if (0)
 		intel_sdvo_set_encoder_power_state(intel_sdvo,
@@ -1741,6 +1777,9 @@ static void intel_enable_sdvo(struct intel_encoder *encoder,
 		intel_sdvo_set_encoder_power_state(intel_sdvo,
 						   DRM_MODE_DPMS_ON);
 	intel_sdvo_set_active_outputs(intel_sdvo, intel_sdvo->attached_output);
+
+	if (pipe_config->has_audio)
+		intel_sdvo_enable_audio(intel_sdvo, pipe_config, conn_state);
 }
 
 static enum drm_mode_status
@@ -2603,7 +2642,6 @@ static bool
 intel_sdvo_dvi_init(struct intel_sdvo *intel_sdvo, int device)
 {
 	struct drm_encoder *encoder = &intel_sdvo->base.base;
-	struct drm_i915_private *dev_priv = to_i915(encoder->dev);
 	struct drm_connector *connector;
 	struct intel_encoder *intel_encoder = to_intel_encoder(encoder);
 	struct intel_connector *intel_connector;
@@ -2640,9 +2678,7 @@ intel_sdvo_dvi_init(struct intel_sdvo *intel_sdvo, int device)
 	encoder->encoder_type = DRM_MODE_ENCODER_TMDS;
 	connector->connector_type = DRM_MODE_CONNECTOR_DVID;
 
-	/* gen3 doesn't do the hdmi bits in the SDVO register */
-	if (INTEL_GEN(dev_priv) >= 4 &&
-	    intel_sdvo_is_hdmi_connector(intel_sdvo, device)) {
+	if (intel_sdvo_is_hdmi_connector(intel_sdvo, device)) {
 		connector->connector_type = DRM_MODE_CONNECTOR_HDMIA;
 		intel_sdvo_connector->is_hdmi = true;
 	}
diff --git a/drivers/gpu/drm/i915/intel_sdvo_regs.h b/drivers/gpu/drm/i915/intel_sdvo_regs.h
index db0ed499268a..e9ba3b047f93 100644
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -707,6 +707,9 @@ struct intel_sdvo_enhancements_arg {
 #define SDVO_CMD_GET_AUDIO_ENCRYPT_PREFER 0x90
 #define SDVO_CMD_SET_AUDIO_STAT		0x91
 #define SDVO_CMD_GET_AUDIO_STAT		0x92
+  #define SDVO_AUDIO_ELD_VALID		(1 << 0)
+  #define SDVO_AUDIO_PRESENCE_DETECT	(1 << 1)
+  #define SDVO_AUDIO_CP_READY		(1 << 2)
 #define SDVO_CMD_SET_HBUF_INDEX		0x93
   #define SDVO_HBUF_INDEX_ELD		0
   #define SDVO_HBUF_INDEX_AVI_IF	1
