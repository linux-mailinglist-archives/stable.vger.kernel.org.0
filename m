Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D036E6320
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjDRMiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjDRMiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:38:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B453E1385B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466536104D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCABC433D2;
        Tue, 18 Apr 2023 12:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821479;
        bh=bWEL/jbx3Z92iSIHHt17nMB/y83auh3Q2U7Oys5J5Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydBjXYSwiXveUI5KDBr8xD663c4TxjQw4CUriAAbTTafYmA3Ltw+Ad02hcS+e0OQ6
         TiuFzkd+4+ZwZGpRMR4AbIBbmBPYuBB6N9/vxzkz8keBqQSPF/rEAgNqFX/J8Ld6f5
         BQ/JVmaW79kg1ACSwP8gSlblAWohJ3sAEOwYf8sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 18/91] drm/i915/dsi: fix DSS CTL register offsets for TGL+
Date:   Tue, 18 Apr 2023 14:21:22 +0200
Message-Id: <20230418120306.207143957@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 6b8446859c971a5783a2cdc90adf32e64de3bd23 upstream.

On TGL+ the DSS control registers are at different offsets, and there's
one per pipe. Fix the offsets to fix dual link DSI for TGL+.

There would be helpers for this in the DSC code, but just do the quick
fix now for DSI. Long term, we should probably move all the DSS handling
into intel_vdsc.c, so exporting the helpers seems counter-productive.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8232
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230301151409.1581574-1-jani.nikula@intel.com
(cherry picked from commit 1a62dd9895dca78bee28bba3a36f08836fdd143d)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -307,9 +307,21 @@ static void configure_dual_link_mode(str
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
@@ -330,16 +342,16 @@ static void configure_dual_link_mode(str
 
 		dss_ctl1 &= ~LEFT_DL_BUF_TARGET_DEPTH_MASK;
 		dss_ctl1 |= LEFT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
-		dss_ctl2 = intel_de_read(dev_priv, DSS_CTL2);
+		dss_ctl2 = intel_de_read(dev_priv, dss_ctl2_reg);
 		dss_ctl2 &= ~RIGHT_DL_BUF_TARGET_DEPTH_MASK;
 		dss_ctl2 |= RIGHT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
-		intel_de_write(dev_priv, DSS_CTL2, dss_ctl2);
+		intel_de_write(dev_priv, dss_ctl2_reg, dss_ctl2);
 	} else {
 		/* Interleave */
 		dss_ctl1 |= DUAL_LINK_MODE_INTERLEAVE;
 	}
 
-	intel_de_write(dev_priv, DSS_CTL1, dss_ctl1);
+	intel_de_write(dev_priv, dss_ctl1_reg, dss_ctl1);
 }
 
 /* aka DSI 8X clock */


