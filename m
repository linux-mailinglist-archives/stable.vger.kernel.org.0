Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF69303253
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 04:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbhAYN3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 08:29:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:3912 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbhAYN3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 08:29:44 -0500
IronPort-SDR: nJhJz92L0GExsLTfkDzzxl3MhjgNf0nh268p+O9XxaYGtGxM1sXiUiXN8FrQAyy9pzOmVEScc0
 nI+GLEqV1AoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178946539"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178946539"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 05:27:14 -0800
IronPort-SDR: S5bg89KAdvZDk8Vi7afXb41gONrAaaUqhTczgH0QbTLMiLSa/aktduxQY0R5oqSUxOH51PfOAw
 JLLA8X34MQcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="387378719"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga008.jf.intel.com with SMTP; 25 Jan 2021 05:27:11 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 25 Jan 2021 15:27:11 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH stable-5.10] drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when outputting YCbCr 4:4:4
Date:   Mon, 25 Jan 2021 15:27:11 +0200
Message-Id: <20210125132711.27101-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <161149524220215@kroah.com>
References: <161149524220215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 1c4995b0a576d24bb7ead991fb037c8b47ab6e32 upstream.

Let's not enable the 4:4:4->4:2:0 conversion bit in the DFP unless we're
actually outputting YCbCr 4:4:4. It would appear some protocol
converters blindy consult this bit even when the source is outputting
RGB, resulting in a visual mess.

Cc: <stable@vger.kernel.org> # 0e634efd858e: drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/
Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2914
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111164111.13302-1-ville.syrjala@linux.intel.com
Fixes: 181567aa9f0d ("drm/i915: Do YCbCr 444->420 conversion via DP protocol converters")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 3170a21f7059c4660c469f59bf529f372a57da5f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118154355.24453-1-ville.syrjala@linux.intel.com
(cherry picked from commit 1c4995b0a576d24bb7ead991fb037c8b47ab6e32)
---
Note the extra depdendency on commit 0e634efd858e
("drm/i915: s/intel_dp_sink_dpms/intel_dp_set_power/").

 drivers/gpu/drm/i915/display/intel_ddi.c | 2 +-
 drivers/gpu/drm/i915/display/intel_dp.c  | 9 +++++----
 drivers/gpu/drm/i915/display/intel_dp.h  | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 80b7491f6bee..3f2bbd9370a8 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3470,7 +3470,7 @@ static void hsw_ddi_pre_enable_dp(struct intel_atomic_state *state,
 	intel_ddi_init_dp_buf_reg(encoder);
 	if (!is_mst)
 		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, crtc_state);
 	intel_dp_sink_set_decompression_state(intel_dp, crtc_state,
 					      true);
 	intel_dp_sink_set_fec_ready(intel_dp, crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 7804750b1ca7..1937b3d6342a 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3856,7 +3856,8 @@ static void intel_dp_enable_port(struct intel_dp *intel_dp,
 	intel_de_posting_read(dev_priv, intel_dp->output_reg);
 }
 
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 tmp;
@@ -3875,8 +3876,8 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
 		drm_dbg_kms(&i915->drm, "Failed to set protocol converter HDMI mode to %s\n",
 			    enableddisabled(intel_dp->has_hdmi_sink));
 
-	tmp = intel_dp->dfp.ycbcr_444_to_420 ?
-		DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
+	tmp = crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR444 &&
+		intel_dp->dfp.ycbcr_444_to_420 ? DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
 			       DP_PROTOCOL_CONVERTER_CONTROL_1, tmp) != 1)
@@ -3930,7 +3931,7 @@ static void intel_enable_dp(struct intel_atomic_state *state,
 	}
 
 	intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, pipe_config);
 	intel_dp_start_link_train(intel_dp);
 	intel_dp_stop_link_train(intel_dp);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index 9aa8d5a590f9..2dd934182471 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -51,7 +51,8 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
 int intel_dp_retrain_link(struct intel_encoder *encoder,
 			  struct drm_modeset_acquire_ctx *ctx);
 void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode);
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp);
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state);
 void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
 					   const struct intel_crtc_state *crtc_state,
 					   bool enable);
-- 
2.26.2

