Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6D4B8F18
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408780AbfITLmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 07:42:40 -0400
Received: from mblankhorst.nl ([141.105.120.124]:51512 "EHLO mblankhorst.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408778AbfITLmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 07:42:40 -0400
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org, Manasi Navare <manasi.d.navare@intel.com>
Subject: [PATCH 01/23] drm/i915/dp: Fix dsc bpp calculations, v2.
Date:   Fri, 20 Sep 2019 13:42:13 +0200
Message-Id: <20190920114235.22411-1-maarten.lankhorst@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There was a integer wraparound when mode_clock became too high,
and we didn't correct for the FEC overhead factor when dividing,
with the calculations breaking at HBR3.

As a result our calculated bpp was way too high, and the link width
limitation never came into effect.

Print out the resulting bpp calcululations as a sanity check, just
in case we ever have to debug it later on again.

We also used the wrong factor for FEC. While bspec mentions 2.4%,
all the calculations use 1/0.972261, and the same ratio should be
applied to data M/N as well, so use it there when FEC is enabled.

Make sure we don't break hw readout, and read out FEC enable state
and correct the DDI clock readout for the new values.

Together with the next commit, this causes FEC to work correctly
with big joiner, while also having the correct refresh rate
reported in kms_setmode.basic.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: d9218c8f6cf4 ("drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC")
Cc: <stable@vger.kernel.org> # v5.0+
Cc: Manasi Navare <manasi.d.navare@intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c     |  19 +-
 drivers/gpu/drm/i915/display/intel_display.c |   1 +
 drivers/gpu/drm/i915/display/intel_dp.c      | 195 ++++++++++---------
 drivers/gpu/drm/i915/display/intel_dp.h      |   6 +-
 4 files changed, 128 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 3e6394139964..1b59b852874b 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -1479,6 +1479,10 @@ static void ddi_dotclock_get(struct intel_crtc_state *pipe_config)
 	if (pipe_config->pixel_multiplier)
 		dotclock /= pipe_config->pixel_multiplier;
 
+	/* fec adds overhead to the data M/N values, correct for it */
+	if (pipe_config->fec_enable)
+		dotclock = intel_dp_fec_to_mode_clock(dotclock);
+
 	pipe_config->base.adjusted_mode.crtc_clock = dotclock;
 }
 
@@ -4031,7 +4035,9 @@ void intel_ddi_get_config(struct intel_encoder *encoder,
 	case TRANS_DDI_MODE_SELECT_FDI:
 		pipe_config->output_types |= BIT(INTEL_OUTPUT_ANALOG);
 		break;
-	case TRANS_DDI_MODE_SELECT_DP_SST:
+	case TRANS_DDI_MODE_SELECT_DP_SST: {
+		struct intel_dp *intel_dp = enc_to_intel_dp(&encoder->base);
+
 		if (encoder->type == INTEL_OUTPUT_EDP)
 			pipe_config->output_types |= BIT(INTEL_OUTPUT_EDP);
 		else
@@ -4039,7 +4045,18 @@ void intel_ddi_get_config(struct intel_encoder *encoder,
 		pipe_config->lane_count =
 			((temp & DDI_PORT_WIDTH_MASK) >> DDI_PORT_WIDTH_SHIFT) + 1;
 		intel_dp_get_m_n(intel_crtc, pipe_config);
+
+		if (INTEL_GEN(dev_priv) >= 11) {
+			pipe_config->fec_enable =
+				I915_READ(intel_dp->regs.dp_tp_ctl) &
+					  DP_TP_CTL_FEC_ENABLE;
+			DRM_DEBUG_KMS("[ENCODER:%d:%s] Fec status: %u\n",
+				      encoder->base.base.id, encoder->base.name,
+				      pipe_config->fec_enable);
+		}
+
 		break;
+	}
 	case TRANS_DDI_MODE_SELECT_DP_MST:
 		pipe_config->output_types |= BIT(INTEL_OUTPUT_DP_MST);
 		pipe_config->lane_count =
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index e0033d99f6e3..7996864e6f7c 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -12773,6 +12773,7 @@ intel_pipe_config_compare(const struct intel_crtc_state *current_config,
 	PIPE_CONF_CHECK_BOOL(hdmi_scrambling);
 	PIPE_CONF_CHECK_BOOL(hdmi_high_tmds_clock_ratio);
 	PIPE_CONF_CHECK_BOOL(has_infoframe);
+	PIPE_CONF_CHECK_BOOL(fec_enable);
 
 	PIPE_CONF_CHECK_BOOL_INCOMPLETE(has_audio);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index ccaf9f00b747..4dfb78dc7fa2 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -76,8 +76,8 @@
 #define DP_DSC_MAX_ENC_THROUGHPUT_0		340000
 #define DP_DSC_MAX_ENC_THROUGHPUT_1		400000
 
-/* DP DSC FEC Overhead factor = (100 - 2.4)/100 */
-#define DP_DSC_FEC_OVERHEAD_FACTOR		976
+/* DP DSC FEC Overhead factor = 1/(0.972261) */
+#define DP_DSC_FEC_OVERHEAD_FACTOR		972261
 
 /* Compliance test status bits  */
 #define INTEL_DP_RESOLUTION_SHIFT_MASK	0
@@ -492,6 +492,104 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
 	return 0;
 }
 
+static inline u32 intel_dp_mode_to_fec_clock(u32 mode_clock)
+{
+	return div_u64(mul_u32_u32(mode_clock, 1000000U),
+		       DP_DSC_FEC_OVERHEAD_FACTOR);
+}
+
+u32 intel_dp_fec_to_mode_clock(u32 fec_clock)
+{
+	return div_u64(mul_u32_u32(fec_clock,
+				   DP_DSC_FEC_OVERHEAD_FACTOR),
+		       1000000U);
+}
+
+static u16 intel_dp_dsc_get_output_bpp(u32 link_clock, u32 lane_count,
+				       u32 mode_clock, u32 mode_hdisplay)
+{
+	u32 bits_per_pixel, max_bpp_small_joiner_ram;
+	int i;
+
+	/*
+	 * Available Link Bandwidth(Kbits/sec) = (NumberOfLanes)*
+	 * (LinkSymbolClock)* 8 * (TimeSlotsPerMTP)
+	 * for SST -> TimeSlotsPerMTP is 1,
+	 * for MST -> TimeSlotsPerMTP has to be calculated
+	 */
+	bits_per_pixel = (link_clock * lane_count * 8) /
+			 intel_dp_mode_to_fec_clock(mode_clock);
+	DRM_DEBUG_KMS("Max link bpp: %u\n", bits_per_pixel);
+
+	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
+	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER / mode_hdisplay;
+	DRM_DEBUG_KMS("Max small joiner bpp: %u\n", max_bpp_small_joiner_ram);
+
+	/*
+	 * Greatest allowed DSC BPP = MIN (output BPP from available Link BW
+	 * check, output bpp from small joiner RAM check)
+	 */
+	bits_per_pixel = min(bits_per_pixel, max_bpp_small_joiner_ram);
+
+	/* Error out if the max bpp is less than smallest allowed valid bpp */
+	if (bits_per_pixel < valid_dsc_bpp[0]) {
+		DRM_DEBUG_KMS("Unsupported BPP %u, min %u\n",
+			      bits_per_pixel, valid_dsc_bpp[0]);
+		return 0;
+	}
+
+	/* Find the nearest match in the array of known BPPs from VESA */
+	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp) - 1; i++) {
+		if (bits_per_pixel < valid_dsc_bpp[i + 1])
+			break;
+	}
+	bits_per_pixel = valid_dsc_bpp[i];
+
+	/*
+	 * Compressed BPP in U6.4 format so multiply by 16, for Gen 11,
+	 * fractional part is 0
+	 */
+	return bits_per_pixel << 4;
+}
+
+static u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp,
+				       int mode_clock, int mode_hdisplay)
+{
+	u8 min_slice_count, i;
+	int max_slice_width;
+
+	if (mode_clock <= DP_DSC_PEAK_PIXEL_RATE)
+		min_slice_count = DIV_ROUND_UP(mode_clock,
+					       DP_DSC_MAX_ENC_THROUGHPUT_0);
+	else
+		min_slice_count = DIV_ROUND_UP(mode_clock,
+					       DP_DSC_MAX_ENC_THROUGHPUT_1);
+
+	max_slice_width = drm_dp_dsc_sink_max_slice_width(intel_dp->dsc_dpcd);
+	if (max_slice_width < DP_DSC_MIN_SLICE_WIDTH_VALUE) {
+		DRM_DEBUG_KMS("Unsupported slice width %d by DP DSC Sink device\n",
+			      max_slice_width);
+		return 0;
+	}
+	/* Also take into account max slice width */
+	min_slice_count = min_t(u8, min_slice_count,
+				DIV_ROUND_UP(mode_hdisplay,
+					     max_slice_width));
+
+	/* Find the closest match to the valid slice count values */
+	for (i = 0; i < ARRAY_SIZE(valid_dsc_slicecount); i++) {
+		if (valid_dsc_slicecount[i] >
+		    drm_dp_dsc_sink_max_slice_count(intel_dp->dsc_dpcd,
+						    false))
+			break;
+		if (min_slice_count  <= valid_dsc_slicecount[i])
+			return valid_dsc_slicecount[i];
+	}
+
+	DRM_DEBUG_KMS("Unsupported Slice Count %d\n", min_slice_count);
+	return 0;
+}
+
 static enum drm_mode_status
 intel_dp_mode_valid(struct drm_connector *connector,
 		    struct drm_display_mode *mode)
@@ -2182,6 +2280,7 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	bool constant_n = drm_dp_has_quirk(&intel_dp->desc,
 					   DP_DPCD_QUIRK_CONSTANT_N);
 	int ret = 0, output_bpp;
+	u32 data_clock;
 
 	if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv) && port != PORT_A)
 		pipe_config->has_pch_encoder = true;
@@ -2244,9 +2343,14 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	else
 		output_bpp = intel_dp_output_bpp(pipe_config, pipe_config->pipe_bpp);
 
+	if (pipe_config->fec_enable)
+		data_clock = intel_dp_mode_to_fec_clock(adjusted_mode->crtc_clock);
+	else
+		data_clock = adjusted_mode->crtc_clock;
+
 	intel_link_compute_m_n(output_bpp,
 			       pipe_config->lane_count,
-			       adjusted_mode->crtc_clock,
+			       data_clock,
 			       pipe_config->port_clock,
 			       &pipe_config->dp_m_n,
 			       constant_n);
@@ -4363,91 +4467,6 @@ intel_dp_get_sink_irq_esi(struct intel_dp *intel_dp, u8 *sink_irq_vector)
 		DP_DPRX_ESI_LEN;
 }
 
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay)
-{
-	u16 bits_per_pixel, max_bpp_small_joiner_ram;
-	int i;
-
-	/*
-	 * Available Link Bandwidth(Kbits/sec) = (NumberOfLanes)*
-	 * (LinkSymbolClock)* 8 * ((100-FECOverhead)/100)*(TimeSlotsPerMTP)
-	 * FECOverhead = 2.4%, for SST -> TimeSlotsPerMTP is 1,
-	 * for MST -> TimeSlotsPerMTP has to be calculated
-	 */
-	bits_per_pixel = (link_clock * lane_count * 8 *
-			  DP_DSC_FEC_OVERHEAD_FACTOR) /
-		mode_clock;
-
-	/* Small Joiner Check: output bpp <= joiner RAM (bits) / Horiz. width */
-	max_bpp_small_joiner_ram = DP_DSC_MAX_SMALL_JOINER_RAM_BUFFER /
-		mode_hdisplay;
-
-	/*
-	 * Greatest allowed DSC BPP = MIN (output BPP from avaialble Link BW
-	 * check, output bpp from small joiner RAM check)
-	 */
-	bits_per_pixel = min(bits_per_pixel, max_bpp_small_joiner_ram);
-
-	/* Error out if the max bpp is less than smallest allowed valid bpp */
-	if (bits_per_pixel < valid_dsc_bpp[0]) {
-		DRM_DEBUG_KMS("Unsupported BPP %d\n", bits_per_pixel);
-		return 0;
-	}
-
-	/* Find the nearest match in the array of known BPPs from VESA */
-	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp) - 1; i++) {
-		if (bits_per_pixel < valid_dsc_bpp[i + 1])
-			break;
-	}
-	bits_per_pixel = valid_dsc_bpp[i];
-
-	/*
-	 * Compressed BPP in U6.4 format so multiply by 16, for Gen 11,
-	 * fractional part is 0
-	 */
-	return bits_per_pixel << 4;
-}
-
-u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp,
-				int mode_clock,
-				int mode_hdisplay)
-{
-	u8 min_slice_count, i;
-	int max_slice_width;
-
-	if (mode_clock <= DP_DSC_PEAK_PIXEL_RATE)
-		min_slice_count = DIV_ROUND_UP(mode_clock,
-					       DP_DSC_MAX_ENC_THROUGHPUT_0);
-	else
-		min_slice_count = DIV_ROUND_UP(mode_clock,
-					       DP_DSC_MAX_ENC_THROUGHPUT_1);
-
-	max_slice_width = drm_dp_dsc_sink_max_slice_width(intel_dp->dsc_dpcd);
-	if (max_slice_width < DP_DSC_MIN_SLICE_WIDTH_VALUE) {
-		DRM_DEBUG_KMS("Unsupported slice width %d by DP DSC Sink device\n",
-			      max_slice_width);
-		return 0;
-	}
-	/* Also take into account max slice width */
-	min_slice_count = min_t(u8, min_slice_count,
-				DIV_ROUND_UP(mode_hdisplay,
-					     max_slice_width));
-
-	/* Find the closest match to the valid slice count values */
-	for (i = 0; i < ARRAY_SIZE(valid_dsc_slicecount); i++) {
-		if (valid_dsc_slicecount[i] >
-		    drm_dp_dsc_sink_max_slice_count(intel_dp->dsc_dpcd,
-						    false))
-			break;
-		if (min_slice_count  <= valid_dsc_slicecount[i])
-			return valid_dsc_slicecount[i];
-	}
-
-	DRM_DEBUG_KMS("Unsupported Slice Count %d\n", min_slice_count);
-	return 0;
-}
-
 static void
 intel_pixel_encoding_setup_vsc(struct intel_dp *intel_dp,
 			       const struct intel_crtc_state *crtc_state)
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index e01d1f89409d..e9f11e698697 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -103,10 +103,6 @@ bool intel_dp_source_supports_hbr2(struct intel_dp *intel_dp);
 bool intel_dp_source_supports_hbr3(struct intel_dp *intel_dp);
 bool
 intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
-u16 intel_dp_dsc_get_output_bpp(int link_clock, u8 lane_count,
-				int mode_clock, int mode_hdisplay);
-u8 intel_dp_dsc_get_slice_count(struct intel_dp *intel_dp, int mode_clock,
-				int mode_hdisplay);
 
 bool intel_dp_read_dpcd(struct intel_dp *intel_dp);
 bool intel_dp_get_colorimetry_status(struct intel_dp *intel_dp);
@@ -119,4 +115,6 @@ static inline unsigned int intel_dp_unused_lane_mask(int lane_count)
 	return ~((1 << lane_count) - 1) & 0xf;
 }
 
+u32 intel_dp_fec_to_mode_clock(u32 fec_clock);
+
 #endif /* __INTEL_DP_H__ */
-- 
2.20.1

