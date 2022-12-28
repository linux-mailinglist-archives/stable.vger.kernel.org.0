Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00552658402
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiL1Qx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiL1QxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575AB140B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E54666157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B06C433EF;
        Wed, 28 Dec 2022 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246093;
        bh=OLs8Pml3TqJ/V5Bzno44tCKPFZ5jtxt1IjbVGJRPehI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1NseIquFLMo1z+sk9ie1+sDWDnQAP/Fo88e/+I3zCtaqzBy5tLvgJjOm663JciF6
         CM/TCo/6us3ts55r6XvFEbVieh65QG4kyt0TocNJwbNdjrqxLfkAi0TkWH2uAiczVk
         0pYHhxpGmS3qjSuxPgOcaKFzX5TunGtqmrpB6nEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Imre Deak <imre.deak@intel.com>,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Khaled Almahallawy <khaled.almahallawy@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1011/1073] drm/i915/display: Dont disable DDI/Transcoder when setting phy test pattern
Date:   Wed, 28 Dec 2022 15:43:19 +0100
Message-Id: <20221228144355.626134099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khaled Almahallawy <khaled.almahallawy@intel.com>

[ Upstream commit 3153eebb7a76e663ac76d6670dc113296de96622 ]

Bspecs has updated recently to remove the restriction to disable
DDI/Transcoder before setting PHY test pattern. This update is to
address PHY compliance test failures observed on a port with LTTPR.
The issue is that when Transc. is disabled, the main link signals fed
to LTTPR will be dropped invalidating link training, which will affect
the quality of the phy test pattern when the transcoder is enabled again.

v2: Update commit message (Clint)
v3: Add missing Signed-off in v2
v4: Update Bspec and commit message for pre-gen12 (Jani)

Bspec: 50482, 7555
Fixes: 8cdf72711928 ("drm/i915/dp: Program vswing, pre-emphasis, test-pattern")
Cc: Imre Deak <imre.deak@intel.com>
Cc: Clint Taylor <clinton.a.taylor@intel.com>
CC: Jani Nikula <jani.nikula@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Clint Taylor <clinton.a.taylor@intel.com>
Signed-off-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221123220926.170034-1-khaled.almahallawy@intel.com
(cherry picked from commit be4a847652056b067d6dc6fe0fc024a9e2e987ca)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 59 -------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 21ba510716b6..d852cfd1d6eb 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3641,61 +3641,6 @@ static void intel_dp_phy_pattern_update(struct intel_dp *intel_dp,
 	}
 }
 
-static void
-intel_dp_autotest_phy_ddi_disable(struct intel_dp *intel_dp,
-				  const struct intel_crtc_state *crtc_state)
-{
-	struct intel_digital_port *dig_port = dp_to_dig_port(intel_dp);
-	struct drm_device *dev = dig_port->base.base.dev;
-	struct drm_i915_private *dev_priv = to_i915(dev);
-	struct intel_crtc *crtc = to_intel_crtc(dig_port->base.base.crtc);
-	enum pipe pipe = crtc->pipe;
-	u32 trans_ddi_func_ctl_value, trans_conf_value, dp_tp_ctl_value;
-
-	trans_ddi_func_ctl_value = intel_de_read(dev_priv,
-						 TRANS_DDI_FUNC_CTL(pipe));
-	trans_conf_value = intel_de_read(dev_priv, PIPECONF(pipe));
-	dp_tp_ctl_value = intel_de_read(dev_priv, TGL_DP_TP_CTL(pipe));
-
-	trans_ddi_func_ctl_value &= ~(TRANS_DDI_FUNC_ENABLE |
-				      TGL_TRANS_DDI_PORT_MASK);
-	trans_conf_value &= ~PIPECONF_ENABLE;
-	dp_tp_ctl_value &= ~DP_TP_CTL_ENABLE;
-
-	intel_de_write(dev_priv, PIPECONF(pipe), trans_conf_value);
-	intel_de_write(dev_priv, TRANS_DDI_FUNC_CTL(pipe),
-		       trans_ddi_func_ctl_value);
-	intel_de_write(dev_priv, TGL_DP_TP_CTL(pipe), dp_tp_ctl_value);
-}
-
-static void
-intel_dp_autotest_phy_ddi_enable(struct intel_dp *intel_dp,
-				 const struct intel_crtc_state *crtc_state)
-{
-	struct intel_digital_port *dig_port = dp_to_dig_port(intel_dp);
-	struct drm_device *dev = dig_port->base.base.dev;
-	struct drm_i915_private *dev_priv = to_i915(dev);
-	enum port port = dig_port->base.port;
-	struct intel_crtc *crtc = to_intel_crtc(dig_port->base.base.crtc);
-	enum pipe pipe = crtc->pipe;
-	u32 trans_ddi_func_ctl_value, trans_conf_value, dp_tp_ctl_value;
-
-	trans_ddi_func_ctl_value = intel_de_read(dev_priv,
-						 TRANS_DDI_FUNC_CTL(pipe));
-	trans_conf_value = intel_de_read(dev_priv, PIPECONF(pipe));
-	dp_tp_ctl_value = intel_de_read(dev_priv, TGL_DP_TP_CTL(pipe));
-
-	trans_ddi_func_ctl_value |= TRANS_DDI_FUNC_ENABLE |
-				    TGL_TRANS_DDI_SELECT_PORT(port);
-	trans_conf_value |= PIPECONF_ENABLE;
-	dp_tp_ctl_value |= DP_TP_CTL_ENABLE;
-
-	intel_de_write(dev_priv, PIPECONF(pipe), trans_conf_value);
-	intel_de_write(dev_priv, TGL_DP_TP_CTL(pipe), dp_tp_ctl_value);
-	intel_de_write(dev_priv, TRANS_DDI_FUNC_CTL(pipe),
-		       trans_ddi_func_ctl_value);
-}
-
 static void intel_dp_process_phy_request(struct intel_dp *intel_dp,
 					 const struct intel_crtc_state *crtc_state)
 {
@@ -3714,14 +3659,10 @@ static void intel_dp_process_phy_request(struct intel_dp *intel_dp,
 	intel_dp_get_adjust_train(intel_dp, crtc_state, DP_PHY_DPRX,
 				  link_status);
 
-	intel_dp_autotest_phy_ddi_disable(intel_dp, crtc_state);
-
 	intel_dp_set_signal_levels(intel_dp, crtc_state, DP_PHY_DPRX);
 
 	intel_dp_phy_pattern_update(intel_dp, crtc_state);
 
-	intel_dp_autotest_phy_ddi_enable(intel_dp, crtc_state);
-
 	drm_dp_dpcd_write(&intel_dp->aux, DP_TRAINING_LANE0_SET,
 			  intel_dp->train_set, crtc_state->lane_count);
 
-- 
2.35.1



