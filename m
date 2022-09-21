Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C589E5C0207
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiIUPrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiIUPqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC7F81B39;
        Wed, 21 Sep 2022 08:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE9B62C7F;
        Wed, 21 Sep 2022 15:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAE4C433D7;
        Wed, 21 Sep 2022 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775208;
        bh=uRxN/pnkVBant0KUWFnWEcMugLocOezPnMpJaeG74Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YO4lh29I+1n/zEoR1Swl+q4nQymE1ch1VXnkzHh2g617TiZJK+8xI/z9Rx1GWxGSI
         A0pv1Pj4KmnnFhDiKi9wt3z9Iy9B+mGGmTbD75FSA2Hb9QbshL2E9VWe+sNLx0NT4a
         xrHbbczRdEh0U/GtCytyadSSEJj7QxBKI2M0B0Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manasi Navare <manasi.d.navare@intel.com>,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 15/38] drm/i915/vdsc: Set VDSC PIC_HEIGHT before using for DP DSC
Date:   Wed, 21 Sep 2022 17:45:59 +0200
Message-Id: <20220921153646.768201725@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 0785691f5711a8f210bb15a5177c2999ebd3702e ]

Currently, pic_height of vdsc_cfg structure is being used to calculate
slice_height, before it is set for DP.

So taking out the lines to set pic_height from the helper
intel_dp_dsc_compute_params() to individual encoders, and setting
pic_height, before it is used to calculate slice_height for DP.

Fixes: 5a6d866f8e1b ("drm/i915: Get slice height before computing rc params")
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220902103219.1168781-1-ankit.k.nautiyal@intel.com
(cherry picked from commit e72df53dcb01ec58e0410da353551adf94c8d0f1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c    | 2 ++
 drivers/gpu/drm/i915/display/intel_dp.c   | 1 +
 drivers/gpu/drm/i915/display/intel_vdsc.c | 1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 19bf717fd4cb..5508ebb9eb43 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1629,6 +1629,8 @@ static int gen11_dsi_dsc_compute_config(struct intel_encoder *encoder,
 	/* FIXME: initialize from VBT */
 	vdsc_cfg->rc_model_size = DSC_RC_MODEL_SIZE_CONST;
 
+	vdsc_cfg->pic_height = crtc_state->hw.adjusted_mode.crtc_vdisplay;
+
 	ret = intel_dsc_compute_params(crtc_state);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 41aaa6c98114..fe8b6b72970a 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1379,6 +1379,7 @@ static int intel_dp_dsc_compute_params(struct intel_encoder *encoder,
 	 * DP_DSC_RC_BUF_SIZE for this.
 	 */
 	vdsc_cfg->rc_model_size = DSC_RC_MODEL_SIZE_CONST;
+	vdsc_cfg->pic_height = crtc_state->hw.adjusted_mode.crtc_vdisplay;
 
 	/*
 	 * Slice Height of 8 works for all currently available panels. So start
diff --git a/drivers/gpu/drm/i915/display/intel_vdsc.c b/drivers/gpu/drm/i915/display/intel_vdsc.c
index 43e1bbc1e303..ca530f0733e0 100644
--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -460,7 +460,6 @@ int intel_dsc_compute_params(struct intel_crtc_state *pipe_config)
 	u8 i = 0;
 
 	vdsc_cfg->pic_width = pipe_config->hw.adjusted_mode.crtc_hdisplay;
-	vdsc_cfg->pic_height = pipe_config->hw.adjusted_mode.crtc_vdisplay;
 	vdsc_cfg->slice_width = DIV_ROUND_UP(vdsc_cfg->pic_width,
 					     pipe_config->dsc.slice_count);
 
-- 
2.35.1



