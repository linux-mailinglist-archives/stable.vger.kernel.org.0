Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE156E3781
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 12:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDPKkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 06:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDPKks (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 06:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C2C1BFE
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 03:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABECE60C32
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 10:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6823C433D2;
        Sun, 16 Apr 2023 10:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681641646;
        bh=r6aO0Q1kiQqoWnD8k4czBBvEENpFKVhh+Rq/3+8fQLs=;
        h=Subject:To:Cc:From:Date:From;
        b=unGOObZX8dhoKYjg8eIaMiFjIOFep7eGWqMxXQ5VnMyES68RU8In2Ck6bhJVDDg8B
         N/iaEdkQ+B+Myzzjbn1RI+M3G7K3LpYaMXhH9kNtpe36QJBIoowrI3SHbapIhvhaYv
         sePOqqFlRuv0NIoQWj5OkvE+GiKT9Si1nlc7vNpI=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix DSS CTL register offsets for TGL+" failed to apply to 5.10-stable tree
To:     jani.nikula@intel.com, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Apr 2023 12:40:43 +0200
Message-ID: <2023041642-revenue-jawline-b0b4@gregkh>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 6b8446859c971a5783a2cdc90adf32e64de3bd23
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041642-revenue-jawline-b0b4@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

6b8446859c97 ("drm/i915/dsi: fix DSS CTL register offsets for TGL+")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b8446859c971a5783a2cdc90adf32e64de3bd23 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Wed, 1 Mar 2023 17:14:09 +0200
Subject: [PATCH] drm/i915/dsi: fix DSS CTL register offsets for TGL+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 468a792e6a40..fc0eaf40dc94 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -300,9 +300,21 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
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
@@ -323,16 +335,16 @@ static void configure_dual_link_mode(struct intel_encoder *encoder,
 
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

