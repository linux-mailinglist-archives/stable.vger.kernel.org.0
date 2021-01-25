Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA70C3033C0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbhAZFEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731233AbhAYSxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2EF230FE;
        Mon, 25 Jan 2021 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600775;
        bh=tFJsgbeEb1S0X6dUwi4IMz3gu1oWvrKHhcBdUUON2fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJqcdww4yrmhzY2nvV/PhOASfje6JmpiFnF7XigCfMWlpFnLF+3EWICVmyqa4Mnkb
         wrwHOH6c2RwiCGZGiQcG6Ovk58tza8hoAdyEPNrgeFs4sy/v+Lft2gyp6JixPFxcZF
         5r0FWRvSYxCVo3DYNTUONxMdhEp4kQdHKyDi/PrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 146/199] drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when outputting YCbCr 4:4:4
Date:   Mon, 25 Jan 2021 19:39:28 +0100
Message-Id: <20210125183222.378390361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
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

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2914
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111164111.13302-1-ville.syrjala@linux.intel.com
Fixes: 181567aa9f0d ("drm/i915: Do YCbCr 444->420 conversion via DP protocol converters")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 3170a21f7059c4660c469f59bf529f372a57da5f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118154355.24453-1-ville.syrjala@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    2 +-
 drivers/gpu/drm/i915/display/intel_dp.c  |    9 +++++----
 drivers/gpu/drm/i915/display/intel_dp.h  |    3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3470,7 +3470,7 @@ static void hsw_ddi_pre_enable_dp(struct
 	intel_ddi_init_dp_buf_reg(encoder);
 	if (!is_mst)
 		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, crtc_state);
 	intel_dp_sink_set_decompression_state(intel_dp, crtc_state,
 					      true);
 	intel_dp_sink_set_fec_ready(intel_dp, crtc_state);
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3856,7 +3856,8 @@ static void intel_dp_enable_port(struct
 	intel_de_posting_read(dev_priv, intel_dp->output_reg);
 }
 
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 tmp;
@@ -3875,8 +3876,8 @@ void intel_dp_configure_protocol_convert
 		drm_dbg_kms(&i915->drm, "Failed to set protocol converter HDMI mode to %s\n",
 			    enableddisabled(intel_dp->has_hdmi_sink));
 
-	tmp = intel_dp->dfp.ycbcr_444_to_420 ?
-		DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
+	tmp = crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR444 &&
+		intel_dp->dfp.ycbcr_444_to_420 ? DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
 			       DP_PROTOCOL_CONVERTER_CONTROL_1, tmp) != 1)
@@ -3930,7 +3931,7 @@ static void intel_enable_dp(struct intel
 	}
 
 	intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, pipe_config);
 	intel_dp_start_link_train(intel_dp);
 	intel_dp_stop_link_train(intel_dp);
 
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -51,7 +51,8 @@ int intel_dp_get_link_train_fallback_val
 int intel_dp_retrain_link(struct intel_encoder *encoder,
 			  struct drm_modeset_acquire_ctx *ctx);
 void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode);
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp);
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state);
 void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
 					   const struct intel_crtc_state *crtc_state,
 					   bool enable);


