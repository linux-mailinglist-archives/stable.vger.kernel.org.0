Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926D46649A9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbjAJSXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbjAJSWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3D25F927
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C01D061866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63B4C433D2;
        Tue, 10 Jan 2023 18:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374836;
        bh=uCYUh72vBFjzwmz50me+PrTbWUZV1WLilXeESQebrVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy2peAz7qWQUO5gwDdP4/RjTf9buzZNNgytXOCy8KQ9m1kytukr5ottnI05QnJGEQ
         yyS/k5OTJpfzHXUgyrKbEoBbzioibTeUIYjlx0Mge+wyDUQBKCMKx7Z01wQMajm9me
         1+GYDlkjzF+h/nk7w9u3xxRJrfbyNsuL8OhJV+qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Brian Chang <Brian.Chang@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/159] drm/amd/display: Add check for DET fetch latency hiding for dcn32
Date:   Tue, 10 Jan 2023 19:04:58 +0100
Message-Id: <20230110180023.290608302@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6d4727c80947de0e6fad58b196a9d215e3b32608 ]

[WHY?]
Some configurations are constructed with very marginal DET buffers relative to
the worst possible time required to fetch a swath.

[HOW?]
Add a check to see that the DET buffer allocated for each pipe can hide the
latency for all pipes to fetch at least one swath.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f3c23bea598a ("drm/amd/display: Uninitialized variables causing 4k60 UCLK to stay at DPM1 and not DPM0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml/dcn32/display_mode_vba_32.c        | 39 +++++++++++
 .../dc/dml/dcn32/display_mode_vba_util_32.c   | 69 +++++++++++++++++++
 .../dc/dml/dcn32/display_mode_vba_util_32.h   | 18 +++++
 .../drm/amd/display/dc/dml/display_mode_vba.h |  2 +
 4 files changed, 128 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 9afd9ba23fb2..820042f6aaca 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -670,6 +670,25 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		v->cursor_bw[k] = mode_lib->vba.NumberOfCursors[k] * mode_lib->vba.CursorWidth[k][0] * mode_lib->vba.CursorBPP[k][0] / 8 / (mode_lib->vba.HTotal[k] / mode_lib->vba.PixelClock[k]) * mode_lib->vba.VRatio[k];
 	}
 
+	v->NotEnoughDETSwathFillLatencyHiding = dml32_CalculateDETSwathFillLatencyHiding(
+						mode_lib->vba.NumberOfActiveSurfaces,
+						mode_lib->vba.ReturnBW,
+						v->UrgentLatency,
+						mode_lib->vba.SwathHeightY,
+						mode_lib->vba.SwathHeightC,
+						v->swath_width_luma_ub,
+						v->swath_width_chroma_ub,
+						v->BytePerPixelDETY,
+						v->BytePerPixelDETC,
+						mode_lib->vba.DETBufferSizeY,
+						mode_lib->vba.DETBufferSizeC,
+						mode_lib->vba.DPPPerPlane,
+						mode_lib->vba.HTotal,
+						mode_lib->vba.PixelClock,
+						mode_lib->vba.VRatio,
+						mode_lib->vba.VRatioChroma,
+						mode_lib->vba.UsesMALLForPStateChange);
+
 	for (k = 0; k < mode_lib->vba.NumberOfActiveSurfaces; ++k) {
 		v->MaxVStartupLines[k] = ((mode_lib->vba.Interlace[k] &&
 				!mode_lib->vba.ProgressiveToInterlaceUnitInOPP) ?
@@ -1664,6 +1683,7 @@ static void mode_support_configuration(struct vba_vars_st *v,
 				&& mode_lib->vba.PTEBufferSizeNotExceeded[i][j] == true
 				&& mode_lib->vba.DCCMetaBufferSizeNotExceeded[i][j] == true
 				&& mode_lib->vba.NonsupportedDSCInputBPC == false
+				&& mode_lib->vba.NotEnoughDETSwathFillLatencyHidingPerState[i][j] == false
 				&& !mode_lib->vba.ExceededMALLSize
 				&& ((mode_lib->vba.HostVMEnable == false
 				&& !mode_lib->vba.ImmediateFlipRequiredFinal)
@@ -3158,6 +3178,25 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					mode_lib->vba.UrgentBurstFactorChroma,
 					mode_lib->vba.UrgentBurstFactorCursor);
 
+			mode_lib->vba.NotEnoughDETSwathFillLatencyHidingPerState[i][j] = dml32_CalculateDETSwathFillLatencyHiding(
+					mode_lib->vba.NumberOfActiveSurfaces,
+					mode_lib->vba.ReturnBWPerState[i][j],
+					mode_lib->vba.UrgLatency[i],
+					mode_lib->vba.SwathHeightYThisState,
+					mode_lib->vba.SwathHeightCThisState,
+					mode_lib->vba.swath_width_luma_ub_this_state,
+					mode_lib->vba.swath_width_chroma_ub_this_state,
+					mode_lib->vba.BytePerPixelInDETY,
+					mode_lib->vba.BytePerPixelInDETC,
+					mode_lib->vba.DETBufferSizeYThisState,
+					mode_lib->vba.DETBufferSizeCThisState,
+					mode_lib->vba.NoOfDPPThisState,
+					mode_lib->vba.HTotal,
+					mode_lib->vba.PixelClock,
+					mode_lib->vba.VRatio,
+					mode_lib->vba.VRatioChroma,
+					mode_lib->vba.UsesMALLForPStateChange);
+
 			v->dummy_vars.dml32_ModeSupportAndSystemConfigurationFull.VMDataOnlyReturnBWPerState = dml32_get_return_bw_mbps_vm_only(&mode_lib->vba.soc, i,
 					mode_lib->vba.DCFCLKState[i][j], mode_lib->vba.FabricClockPerState[i],
 					mode_lib->vba.DRAMSpeedPerState[i]);
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index debe46b24a3e..5af601cff1a0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -6228,3 +6228,72 @@ void dml32_CalculateImmediateFlipBandwithSupport(unsigned int NumberOfActiveSurf
 	*ImmediateFlipBandwidthSupport = (*TotalBandwidth <= ReturnBW);
 	*FractionOfUrgentBandwidth = *TotalBandwidth / ReturnBW;
 }
+
+bool dml32_CalculateDETSwathFillLatencyHiding(unsigned int NumberOfActiveSurfaces,
+		double ReturnBW,
+		double UrgentLatency,
+		unsigned int SwathHeightY[],
+		unsigned int SwathHeightC[],
+		unsigned int SwathWidthY[],
+		unsigned int SwathWidthC[],
+		double  BytePerPixelInDETY[],
+		double  BytePerPixelInDETC[],
+		unsigned int    DETBufferSizeY[],
+		unsigned int    DETBufferSizeC[],
+		unsigned int	NumOfDPP[],
+		unsigned int	HTotal[],
+		double	PixelClock[],
+		double	VRatioY[],
+		double	VRatioC[],
+		enum dm_use_mall_for_pstate_change_mode UsesMALLForPStateChange[DC__NUM_DPP__MAX])
+{
+	int k;
+	double SwathSizeAllSurfaces = 0;
+	double SwathSizeAllSurfacesInFetchTimeUs;
+	double DETSwathLatencyHidingUs;
+	double DETSwathLatencyHidingYUs;
+	double DETSwathLatencyHidingCUs;
+	double SwathSizePerSurfaceY[DC__NUM_DPP__MAX];
+	double SwathSizePerSurfaceC[DC__NUM_DPP__MAX];
+	bool NotEnoughDETSwathFillLatencyHiding = false;
+
+	/* calculate sum of single swath size for all pipes in bytes*/
+	for (k = 0; k < NumberOfActiveSurfaces; k++) {
+		SwathSizePerSurfaceY[k] += SwathHeightY[k] * SwathWidthY[k] * BytePerPixelInDETY[k] * NumOfDPP[k];
+
+		if (SwathHeightC[k] != 0)
+			SwathSizePerSurfaceC[k] += SwathHeightC[k] * SwathWidthC[k] * BytePerPixelInDETC[k] * NumOfDPP[k];
+		else
+			SwathSizePerSurfaceC[k] = 0;
+
+		SwathSizeAllSurfaces += SwathSizePerSurfaceY[k] + SwathSizePerSurfaceC[k];
+	}
+
+	SwathSizeAllSurfacesInFetchTimeUs = SwathSizeAllSurfaces / ReturnBW + UrgentLatency;
+
+	/* ensure all DET - 1 swath can hide a fetch for all surfaces */
+	for (k = 0; k < NumberOfActiveSurfaces; k++) {
+		double LineTime = HTotal[k] / PixelClock[k];
+
+		/* only care if surface is not phantom */
+		if (UsesMALLForPStateChange[k] != dm_use_mall_pstate_change_phantom_pipe) {
+			DETSwathLatencyHidingYUs = (dml_floor(DETBufferSizeY[k] / BytePerPixelInDETY[k] / SwathWidthY[k], 1.0) - SwathHeightY[k]) / VRatioY[k] * LineTime;
+
+			if (SwathHeightC[k] != 0) {
+				DETSwathLatencyHidingCUs = (dml_floor(DETBufferSizeC[k] / BytePerPixelInDETC[k] / SwathWidthC[k], 1.0) - SwathHeightC[k]) / VRatioC[k] * LineTime;
+
+				DETSwathLatencyHidingUs = dml_min(DETSwathLatencyHidingYUs, DETSwathLatencyHidingCUs);
+			} else {
+				DETSwathLatencyHidingUs = DETSwathLatencyHidingYUs;
+			}
+
+			/* DET must be able to hide time to fetch 1 swath for each surface */
+			if (DETSwathLatencyHidingUs < SwathSizeAllSurfacesInFetchTimeUs) {
+				NotEnoughDETSwathFillLatencyHiding = true;
+				break;
+			}
+		}
+	}
+
+	return NotEnoughDETSwathFillLatencyHiding;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
index 3989c2a28fae..779c6805f599 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
@@ -1141,4 +1141,22 @@ void dml32_CalculateImmediateFlipBandwithSupport(unsigned int NumberOfActiveSurf
 		double  *FractionOfUrgentBandwidth,
 		bool *ImmediateFlipBandwidthSupport);
 
+bool dml32_CalculateDETSwathFillLatencyHiding(unsigned int NumberOfActiveSurfaces,
+		double ReturnBW,
+		double UrgentLatency,
+		unsigned int SwathHeightY[],
+		unsigned int SwathHeightC[],
+		unsigned int SwathWidthY[],
+		unsigned int SwathWidthC[],
+		double  BytePerPixelInDETY[],
+		double  BytePerPixelInDETC[],
+		unsigned int    DETBufferSizeY[],
+		unsigned int    DETBufferSizeC[],
+		unsigned int	NumOfDPP[],
+		unsigned int	HTotal[],
+		double	PixelClock[],
+		double	VRatioY[],
+		double	VRatioC[],
+		enum dm_use_mall_for_pstate_change_mode UsesMALLForPStateChange[DC__NUM_DPP__MAX]);
+
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
index a0207a8f8756..2b34b02dbd45 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
@@ -1041,6 +1041,7 @@ struct vba_vars_st {
 	double MinFullDETBufferingTime;
 	double AverageReadBandwidthGBytePerSecond;
 	bool   FirstMainPlane;
+	bool NotEnoughDETSwathFillLatencyHiding;
 
 	unsigned int ViewportWidthChroma[DC__NUM_DPP__MAX];
 	unsigned int ViewportHeightChroma[DC__NUM_DPP__MAX];
@@ -1224,6 +1225,7 @@ struct vba_vars_st {
 	unsigned int BlockWidthC[DC__NUM_DPP__MAX];
 	unsigned int SubViewportLinesNeededInMALL[DC__NUM_DPP__MAX];
 	bool VActiveBandwithSupport[DC__VOLTAGE_STATES][2];
+	bool NotEnoughDETSwathFillLatencyHidingPerState[DC__VOLTAGE_STATES][2];
 	struct dummy_vars dummy_vars;
 };
 
-- 
2.35.1



