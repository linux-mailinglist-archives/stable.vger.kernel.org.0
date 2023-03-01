Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0F46A6F12
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 16:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCAPOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 10:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCAPOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 10:14:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CA2241F0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 07:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677683655; x=1709219655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RMsuM/E0ZFT20d+Q8Vr08nWtqRiw+MY2/XACP7cFDEA=;
  b=gB07fsYSYrfqxs8cm696/FYzkwzQAkT2IEZxp16NzVaNaIKbe5/6HBwW
   BIF63926VISYlf5L0jbh/NaNslI6tNgSxaCJCMkKYCV4jjHhKR19Arkby
   Wl8A95E3rvloqM7MWNBEMSaVz0xtww0DgpDtD4fyzwVS3aB1pG9opjQ8Q
   +heAyM/kNKiVwcCDgjhPqYv4pFQsc3mjWThefEgOrTXIduCMyfhtmmj9u
   iBz6K026CGaZsa/Y3rCPbWaTftbIYjiQHEMEyahbUvhbH+q2jGxVTn824
   OsDBDWQ4+VQ7ukaOPyR2aeWvFydMtMQWhg61HtfPCNZAI8HBZ+3Q4ye8L
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="335923189"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="335923189"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 07:14:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="704873034"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="704873034"
Received: from dsvarnas-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.46.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 07:14:13 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/dsi: fix DSS CTL register offsets for TGL+
Date:   Wed,  1 Mar 2023 17:14:09 +0200
Message-Id: <20230301151409.1581574-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On TGL+ the DSS control registers are at different offsets, and there's
one per pipe. Fix the offsets to fix dual link DSI for TGL+.

There would be helpers for this in the DSC code, but just do the quick
fix now for DSI. Long term, we should probably move all the DSS handling
into intel_vdsc.c, so exporting the helpers seems counter-productive.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8232
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/icl_dsi.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index b5316715bb3b..5a17ab3f0d1a 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -277,9 +277,21 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
 {
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
+	i915_reg_t dss_ctl1_reg, dss_ctl2_reg;
 	u32 dss_ctl1;
 
-	dss_ctl1 = intel_de_read(dev_priv, DSS_CTL1);
+	/* FIXME: Move all DSS handling to intel_vdsc.c */
+	if (DISPLAY_VER(dev_priv) >= 12) {
+		struct intel_crtc *crtc = to_intel_crtc(pipe_config->uapi.crtc);
+
+		dss_ctl1_reg = ICL_PIPE_DSS_CTL1(crtc->pipe);
+		dss_ctl2_reg = ICL_PIPE_DSS_CTL2(crtc->pipe);
+	} else {
+		dss_ctl1_reg = DSS_CTL1;
+		dss_ctl2_reg = DSS_CTL2;
+	}
+
+	dss_ctl1 = intel_de_read(dev_priv, dss_ctl1_reg);
 	dss_ctl1 |= SPLITTER_ENABLE;
 	dss_ctl1 &= ~OVERLAP_PIXELS_MASK;
 	dss_ctl1 |= OVERLAP_PIXELS(intel_dsi->pixel_overlap);
@@ -299,14 +311,14 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
 
 		dss_ctl1 &= ~LEFT_DL_BUF_TARGET_DEPTH_MASK;
 		dss_ctl1 |= LEFT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
-		intel_de_rmw(dev_priv, DSS_CTL2, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
+		intel_de_rmw(dev_priv, dss_ctl2_reg, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
 			     RIGHT_DL_BUF_TARGET_DEPTH(dl_buffer_depth));
 	} else {
 		/* Interleave */
 		dss_ctl1 |= DUAL_LINK_MODE_INTERLEAVE;
 	}
 
-	intel_de_write(dev_priv, DSS_CTL1, dss_ctl1);
+	intel_de_write(dev_priv, dss_ctl1_reg, dss_ctl1);
 }
 
 /* aka DSI 8X clock */
-- 
2.39.1

