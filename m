Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0791A5EA39A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbiIZL23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiIZL1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843216AA03;
        Mon, 26 Sep 2022 03:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA08604F5;
        Mon, 26 Sep 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C20C433C1;
        Mon, 26 Sep 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188812;
        bh=Xd9c0X3QS3568Rh+Yj1HbEuidc7xksczan6ogDvhjVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rq8zWU1J7S/6JQ+ToVkfmwUDfDCrWzo2jUGHjSScLCBF4HkwiXEB2QeZu7W35OL5k
         tN4Pe+mwd1GFrjl3e73JFAkIQ+iyPMb5TQvyZ6Dg5H5fQN66JyJApXIGoaU3hPgCBw
         kdmFOv4v1RzP++p5VX/ggDiPIY1Hh13LmCrCNcE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/148] drm/amd/display: Reduce number of arguments of dml31s CalculateWatermarksAndDRAMSpeedChangeSupport()
Date:   Mon, 26 Sep 2022 12:12:44 +0200
Message-Id: <20220926100801.070398320@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 37934d4118e22bceb80141804391975078f31734 ]

Most of the arguments are identical between the two call sites and they
can be accessed through the 'struct vba_vars_st' pointer. This reduces
the total amount of stack space that
dml31_ModeSupportAndSystemConfigurationFull() uses by 240 bytes with
LLVM 16 (2216 -> 1976), helping clear up the following clang warning:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn31/display_mode_vba_31.c:3908:6: error: stack frame size (2216) exceeds limit (2048) in 'dml31_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
  void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
      ^
  1 error generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/1681
Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Tested-by: Maíra Canal <mairacanal@riseup.net>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml/dcn31/display_mode_vba_31.c        | 248 ++++--------------
 1 file changed, 52 insertions(+), 196 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index d58925cff420..a6ce22d23b26 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -319,64 +319,28 @@ static void CalculateVupdateAndDynamicMetadataParameters(
 static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		struct display_mode_lib *mode_lib,
 		unsigned int PrefetchMode,
-		unsigned int NumberOfActivePlanes,
-		unsigned int MaxLineBufferLines,
-		unsigned int LineBufferSize,
-		unsigned int WritebackInterfaceBufferSize,
 		double DCFCLK,
 		double ReturnBW,
-		bool SynchronizedVBlank,
-		unsigned int dpte_group_bytes[],
-		unsigned int MetaChunkSize,
 		double UrgentLatency,
 		double ExtraLatency,
-		double WritebackLatency,
-		double WritebackChunkSize,
 		double SOCCLK,
-		double DRAMClockChangeLatency,
-		double SRExitTime,
-		double SREnterPlusExitTime,
-		double SRExitZ8Time,
-		double SREnterPlusExitZ8Time,
 		double DCFCLKDeepSleep,
 		unsigned int DETBufferSizeY[],
 		unsigned int DETBufferSizeC[],
 		unsigned int SwathHeightY[],
 		unsigned int SwathHeightC[],
-		unsigned int LBBitPerPixel[],
 		double SwathWidthY[],
 		double SwathWidthC[],
-		double HRatio[],
-		double HRatioChroma[],
-		unsigned int vtaps[],
-		unsigned int VTAPsChroma[],
-		double VRatio[],
-		double VRatioChroma[],
-		unsigned int HTotal[],
-		double PixelClock[],
-		unsigned int BlendingAndTiming[],
 		unsigned int DPPPerPlane[],
 		double BytePerPixelDETY[],
 		double BytePerPixelDETC[],
-		double DSTXAfterScaler[],
-		double DSTYAfterScaler[],
-		bool WritebackEnable[],
-		enum source_format_class WritebackPixelFormat[],
-		double WritebackDestinationWidth[],
-		double WritebackDestinationHeight[],
-		double WritebackSourceHeight[],
 		bool UnboundedRequestEnabled,
 		int unsigned CompressedBufferSizeInkByte,
 		enum clock_change_support *DRAMClockChangeSupport,
-		double *UrgentWatermark,
-		double *WritebackUrgentWatermark,
-		double *DRAMClockChangeWatermark,
-		double *WritebackDRAMClockChangeWatermark,
 		double *StutterExitWatermark,
 		double *StutterEnterPlusExitWatermark,
 		double *Z8StutterExitWatermark,
-		double *Z8StutterEnterPlusExitWatermark,
-		double *MinActiveDRAMClockChangeLatencySupported);
+		double *Z8StutterEnterPlusExitWatermark);
 
 static void CalculateDCFCLKDeepSleep(
 		struct display_mode_lib *mode_lib,
@@ -3072,64 +3036,28 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		CalculateWatermarksAndDRAMSpeedChangeSupport(
 				mode_lib,
 				PrefetchMode,
-				v->NumberOfActivePlanes,
-				v->MaxLineBufferLines,
-				v->LineBufferSize,
-				v->WritebackInterfaceBufferSize,
 				v->DCFCLK,
 				v->ReturnBW,
-				v->SynchronizedVBlank,
-				v->dpte_group_bytes,
-				v->MetaChunkSize,
 				v->UrgentLatency,
 				v->UrgentExtraLatency,
-				v->WritebackLatency,
-				v->WritebackChunkSize,
 				v->SOCCLK,
-				v->DRAMClockChangeLatency,
-				v->SRExitTime,
-				v->SREnterPlusExitTime,
-				v->SRExitZ8Time,
-				v->SREnterPlusExitZ8Time,
 				v->DCFCLKDeepSleep,
 				v->DETBufferSizeY,
 				v->DETBufferSizeC,
 				v->SwathHeightY,
 				v->SwathHeightC,
-				v->LBBitPerPixel,
 				v->SwathWidthY,
 				v->SwathWidthC,
-				v->HRatio,
-				v->HRatioChroma,
-				v->vtaps,
-				v->VTAPsChroma,
-				v->VRatio,
-				v->VRatioChroma,
-				v->HTotal,
-				v->PixelClock,
-				v->BlendingAndTiming,
 				v->DPPPerPlane,
 				v->BytePerPixelDETY,
 				v->BytePerPixelDETC,
-				v->DSTXAfterScaler,
-				v->DSTYAfterScaler,
-				v->WritebackEnable,
-				v->WritebackPixelFormat,
-				v->WritebackDestinationWidth,
-				v->WritebackDestinationHeight,
-				v->WritebackSourceHeight,
 				v->UnboundedRequestEnabled,
 				v->CompressedBufferSizeInkByte,
 				&DRAMClockChangeSupport,
-				&v->UrgentWatermark,
-				&v->WritebackUrgentWatermark,
-				&v->DRAMClockChangeWatermark,
-				&v->WritebackDRAMClockChangeWatermark,
 				&v->StutterExitWatermark,
 				&v->StutterEnterPlusExitWatermark,
 				&v->Z8StutterExitWatermark,
-				&v->Z8StutterEnterPlusExitWatermark,
-				&v->MinActiveDRAMClockChangeLatencySupported);
+				&v->Z8StutterEnterPlusExitWatermark);
 
 		for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 			if (v->WritebackEnable[k] == true) {
@@ -5561,64 +5489,28 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			CalculateWatermarksAndDRAMSpeedChangeSupport(
 					mode_lib,
 					v->PrefetchModePerState[i][j],
-					v->NumberOfActivePlanes,
-					v->MaxLineBufferLines,
-					v->LineBufferSize,
-					v->WritebackInterfaceBufferSize,
 					v->DCFCLKState[i][j],
 					v->ReturnBWPerState[i][j],
-					v->SynchronizedVBlank,
-					v->dpte_group_bytes,
-					v->MetaChunkSize,
 					v->UrgLatency[i],
 					v->ExtraLatency,
-					v->WritebackLatency,
-					v->WritebackChunkSize,
 					v->SOCCLKPerState[i],
-					v->DRAMClockChangeLatency,
-					v->SRExitTime,
-					v->SREnterPlusExitTime,
-					v->SRExitZ8Time,
-					v->SREnterPlusExitZ8Time,
 					v->ProjectedDCFCLKDeepSleep[i][j],
 					v->DETBufferSizeYThisState,
 					v->DETBufferSizeCThisState,
 					v->SwathHeightYThisState,
 					v->SwathHeightCThisState,
-					v->LBBitPerPixel,
 					v->SwathWidthYThisState,
 					v->SwathWidthCThisState,
-					v->HRatio,
-					v->HRatioChroma,
-					v->vtaps,
-					v->VTAPsChroma,
-					v->VRatio,
-					v->VRatioChroma,
-					v->HTotal,
-					v->PixelClock,
-					v->BlendingAndTiming,
 					v->NoOfDPPThisState,
 					v->BytePerPixelInDETY,
 					v->BytePerPixelInDETC,
-					v->DSTXAfterScaler,
-					v->DSTYAfterScaler,
-					v->WritebackEnable,
-					v->WritebackPixelFormat,
-					v->WritebackDestinationWidth,
-					v->WritebackDestinationHeight,
-					v->WritebackSourceHeight,
 					UnboundedRequestEnabledThisState,
 					CompressedBufferSizeInkByteThisState,
 					&v->DRAMClockChangeSupport[i][j],
-					&v->UrgentWatermark,
-					&v->WritebackUrgentWatermark,
-					&v->DRAMClockChangeWatermark,
-					&v->WritebackDRAMClockChangeWatermark,
-					&dummy,
 					&dummy,
 					&dummy,
 					&dummy,
-					&v->MinActiveDRAMClockChangeLatencySupported);
+					&dummy);
 		}
 	}
 
@@ -5743,64 +5635,28 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		struct display_mode_lib *mode_lib,
 		unsigned int PrefetchMode,
-		unsigned int NumberOfActivePlanes,
-		unsigned int MaxLineBufferLines,
-		unsigned int LineBufferSize,
-		unsigned int WritebackInterfaceBufferSize,
 		double DCFCLK,
 		double ReturnBW,
-		bool SynchronizedVBlank,
-		unsigned int dpte_group_bytes[],
-		unsigned int MetaChunkSize,
 		double UrgentLatency,
 		double ExtraLatency,
-		double WritebackLatency,
-		double WritebackChunkSize,
 		double SOCCLK,
-		double DRAMClockChangeLatency,
-		double SRExitTime,
-		double SREnterPlusExitTime,
-		double SRExitZ8Time,
-		double SREnterPlusExitZ8Time,
 		double DCFCLKDeepSleep,
 		unsigned int DETBufferSizeY[],
 		unsigned int DETBufferSizeC[],
 		unsigned int SwathHeightY[],
 		unsigned int SwathHeightC[],
-		unsigned int LBBitPerPixel[],
 		double SwathWidthY[],
 		double SwathWidthC[],
-		double HRatio[],
-		double HRatioChroma[],
-		unsigned int vtaps[],
-		unsigned int VTAPsChroma[],
-		double VRatio[],
-		double VRatioChroma[],
-		unsigned int HTotal[],
-		double PixelClock[],
-		unsigned int BlendingAndTiming[],
 		unsigned int DPPPerPlane[],
 		double BytePerPixelDETY[],
 		double BytePerPixelDETC[],
-		double DSTXAfterScaler[],
-		double DSTYAfterScaler[],
-		bool WritebackEnable[],
-		enum source_format_class WritebackPixelFormat[],
-		double WritebackDestinationWidth[],
-		double WritebackDestinationHeight[],
-		double WritebackSourceHeight[],
 		bool UnboundedRequestEnabled,
 		int unsigned CompressedBufferSizeInkByte,
 		enum clock_change_support *DRAMClockChangeSupport,
-		double *UrgentWatermark,
-		double *WritebackUrgentWatermark,
-		double *DRAMClockChangeWatermark,
-		double *WritebackDRAMClockChangeWatermark,
 		double *StutterExitWatermark,
 		double *StutterEnterPlusExitWatermark,
 		double *Z8StutterExitWatermark,
-		double *Z8StutterEnterPlusExitWatermark,
-		double *MinActiveDRAMClockChangeLatencySupported)
+		double *Z8StutterEnterPlusExitWatermark)
 {
 	struct vba_vars_st *v = &mode_lib->vba;
 	double EffectiveLBLatencyHidingY;
@@ -5820,103 +5676,103 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 	double TotalPixelBW = 0.0;
 	int k, j;
 
-	*UrgentWatermark = UrgentLatency + ExtraLatency;
+	v->UrgentWatermark = UrgentLatency + ExtraLatency;
 
 #ifdef __DML_VBA_DEBUG__
 	dml_print("DML::%s: UrgentLatency = %f\n", __func__, UrgentLatency);
 	dml_print("DML::%s: ExtraLatency = %f\n", __func__, ExtraLatency);
-	dml_print("DML::%s: UrgentWatermark = %f\n", __func__, *UrgentWatermark);
+	dml_print("DML::%s: UrgentWatermark = %f\n", __func__, v->UrgentWatermark);
 #endif
 
-	*DRAMClockChangeWatermark = DRAMClockChangeLatency + *UrgentWatermark;
+	v->DRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->UrgentWatermark;
 
 #ifdef __DML_VBA_DEBUG__
-	dml_print("DML::%s: DRAMClockChangeLatency = %f\n", __func__, DRAMClockChangeLatency);
-	dml_print("DML::%s: DRAMClockChangeWatermark = %f\n", __func__, *DRAMClockChangeWatermark);
+	dml_print("DML::%s: v->DRAMClockChangeLatency = %f\n", __func__, v->DRAMClockChangeLatency);
+	dml_print("DML::%s: DRAMClockChangeWatermark = %f\n", __func__, v->DRAMClockChangeWatermark);
 #endif
 
 	v->TotalActiveWriteback = 0;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (WritebackEnable[k] == true) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (v->WritebackEnable[k] == true) {
 			v->TotalActiveWriteback = v->TotalActiveWriteback + 1;
 		}
 	}
 
 	if (v->TotalActiveWriteback <= 1) {
-		*WritebackUrgentWatermark = WritebackLatency;
+		v->WritebackUrgentWatermark = v->WritebackLatency;
 	} else {
-		*WritebackUrgentWatermark = WritebackLatency + WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
+		v->WritebackUrgentWatermark = v->WritebackLatency + v->WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
 	}
 
 	if (v->TotalActiveWriteback <= 1) {
-		*WritebackDRAMClockChangeWatermark = DRAMClockChangeLatency + WritebackLatency;
+		v->WritebackDRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->WritebackLatency;
 	} else {
-		*WritebackDRAMClockChangeWatermark = DRAMClockChangeLatency + WritebackLatency + WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
+		v->WritebackDRAMClockChangeWatermark = v->DRAMClockChangeLatency + v->WritebackLatency + v->WritebackChunkSize * 1024.0 / 32.0 / SOCCLK;
 	}
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		TotalPixelBW = TotalPixelBW
-				+ DPPPerPlane[k] * (SwathWidthY[k] * BytePerPixelDETY[k] * VRatio[k] + SwathWidthC[k] * BytePerPixelDETC[k] * VRatioChroma[k])
-						/ (HTotal[k] / PixelClock[k]);
+				+ DPPPerPlane[k] * (SwathWidthY[k] * BytePerPixelDETY[k] * v->VRatio[k] + SwathWidthC[k] * BytePerPixelDETC[k] * v->VRatioChroma[k])
+						/ (v->HTotal[k] / v->PixelClock[k]);
 	}
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		double EffectiveDETBufferSizeY = DETBufferSizeY[k];
 
 		v->LBLatencyHidingSourceLinesY = dml_min(
-				(double) MaxLineBufferLines,
-				dml_floor(LineBufferSize / LBBitPerPixel[k] / (SwathWidthY[k] / dml_max(HRatio[k], 1.0)), 1)) - (vtaps[k] - 1);
+				(double) v->MaxLineBufferLines,
+				dml_floor(v->LineBufferSize / v->LBBitPerPixel[k] / (SwathWidthY[k] / dml_max(v->HRatio[k], 1.0)), 1)) - (v->vtaps[k] - 1);
 
 		v->LBLatencyHidingSourceLinesC = dml_min(
-				(double) MaxLineBufferLines,
-				dml_floor(LineBufferSize / LBBitPerPixel[k] / (SwathWidthC[k] / dml_max(HRatioChroma[k], 1.0)), 1)) - (VTAPsChroma[k] - 1);
+				(double) v->MaxLineBufferLines,
+				dml_floor(v->LineBufferSize / v->LBBitPerPixel[k] / (SwathWidthC[k] / dml_max(v->HRatioChroma[k], 1.0)), 1)) - (v->VTAPsChroma[k] - 1);
 
-		EffectiveLBLatencyHidingY = v->LBLatencyHidingSourceLinesY / VRatio[k] * (HTotal[k] / PixelClock[k]);
+		EffectiveLBLatencyHidingY = v->LBLatencyHidingSourceLinesY / v->VRatio[k] * (v->HTotal[k] / v->PixelClock[k]);
 
-		EffectiveLBLatencyHidingC = v->LBLatencyHidingSourceLinesC / VRatioChroma[k] * (HTotal[k] / PixelClock[k]);
+		EffectiveLBLatencyHidingC = v->LBLatencyHidingSourceLinesC / v->VRatioChroma[k] * (v->HTotal[k] / v->PixelClock[k]);
 
 		if (UnboundedRequestEnabled) {
 			EffectiveDETBufferSizeY = EffectiveDETBufferSizeY
-					+ CompressedBufferSizeInkByte * 1024 * SwathWidthY[k] * BytePerPixelDETY[k] * VRatio[k] / (HTotal[k] / PixelClock[k]) / TotalPixelBW;
+					+ CompressedBufferSizeInkByte * 1024 * SwathWidthY[k] * BytePerPixelDETY[k] * v->VRatio[k] / (v->HTotal[k] / v->PixelClock[k]) / TotalPixelBW;
 		}
 
 		LinesInDETY[k] = (double) EffectiveDETBufferSizeY / BytePerPixelDETY[k] / SwathWidthY[k];
 		LinesInDETYRoundedDownToSwath[k] = dml_floor(LinesInDETY[k], SwathHeightY[k]);
-		FullDETBufferingTimeY = LinesInDETYRoundedDownToSwath[k] * (HTotal[k] / PixelClock[k]) / VRatio[k];
+		FullDETBufferingTimeY = LinesInDETYRoundedDownToSwath[k] * (v->HTotal[k] / v->PixelClock[k]) / v->VRatio[k];
 		if (BytePerPixelDETC[k] > 0) {
 			LinesInDETC = v->DETBufferSizeC[k] / BytePerPixelDETC[k] / SwathWidthC[k];
 			LinesInDETCRoundedDownToSwath = dml_floor(LinesInDETC, SwathHeightC[k]);
-			FullDETBufferingTimeC = LinesInDETCRoundedDownToSwath * (HTotal[k] / PixelClock[k]) / VRatioChroma[k];
+			FullDETBufferingTimeC = LinesInDETCRoundedDownToSwath * (v->HTotal[k] / v->PixelClock[k]) / v->VRatioChroma[k];
 		} else {
 			LinesInDETC = 0;
 			FullDETBufferingTimeC = 999999;
 		}
 
 		ActiveDRAMClockChangeLatencyMarginY = EffectiveLBLatencyHidingY + FullDETBufferingTimeY
-				- ((double) DSTXAfterScaler[k] / HTotal[k] + DSTYAfterScaler[k]) * HTotal[k] / PixelClock[k] - *UrgentWatermark - *DRAMClockChangeWatermark;
+				- ((double) v->DSTXAfterScaler[k] / v->HTotal[k] + v->DSTYAfterScaler[k]) * v->HTotal[k] / v->PixelClock[k] - v->UrgentWatermark - v->DRAMClockChangeWatermark;
 
-		if (NumberOfActivePlanes > 1) {
+		if (v->NumberOfActivePlanes > 1) {
 			ActiveDRAMClockChangeLatencyMarginY = ActiveDRAMClockChangeLatencyMarginY
-					- (1 - 1.0 / NumberOfActivePlanes) * SwathHeightY[k] * HTotal[k] / PixelClock[k] / VRatio[k];
+					- (1 - 1.0 / v->NumberOfActivePlanes) * SwathHeightY[k] * v->HTotal[k] / v->PixelClock[k] / v->VRatio[k];
 		}
 
 		if (BytePerPixelDETC[k] > 0) {
 			ActiveDRAMClockChangeLatencyMarginC = EffectiveLBLatencyHidingC + FullDETBufferingTimeC
-					- ((double) DSTXAfterScaler[k] / HTotal[k] + DSTYAfterScaler[k]) * HTotal[k] / PixelClock[k] - *UrgentWatermark - *DRAMClockChangeWatermark;
+					- ((double) v->DSTXAfterScaler[k] / v->HTotal[k] + v->DSTYAfterScaler[k]) * v->HTotal[k] / v->PixelClock[k] - v->UrgentWatermark - v->DRAMClockChangeWatermark;
 
-			if (NumberOfActivePlanes > 1) {
+			if (v->NumberOfActivePlanes > 1) {
 				ActiveDRAMClockChangeLatencyMarginC = ActiveDRAMClockChangeLatencyMarginC
-						- (1 - 1.0 / NumberOfActivePlanes) * SwathHeightC[k] * HTotal[k] / PixelClock[k] / VRatioChroma[k];
+						- (1 - 1.0 / v->NumberOfActivePlanes) * SwathHeightC[k] * v->HTotal[k] / v->PixelClock[k] / v->VRatioChroma[k];
 			}
 			v->ActiveDRAMClockChangeLatencyMargin[k] = dml_min(ActiveDRAMClockChangeLatencyMarginY, ActiveDRAMClockChangeLatencyMarginC);
 		} else {
 			v->ActiveDRAMClockChangeLatencyMargin[k] = ActiveDRAMClockChangeLatencyMarginY;
 		}
 
-		if (WritebackEnable[k] == true) {
-			WritebackDRAMClockChangeLatencyHiding = WritebackInterfaceBufferSize * 1024
-					/ (WritebackDestinationWidth[k] * WritebackDestinationHeight[k] / (WritebackSourceHeight[k] * HTotal[k] / PixelClock[k]) * 4);
-			if (WritebackPixelFormat[k] == dm_444_64) {
+		if (v->WritebackEnable[k] == true) {
+			WritebackDRAMClockChangeLatencyHiding = v->WritebackInterfaceBufferSize * 1024
+					/ (v->WritebackDestinationWidth[k] * v->WritebackDestinationHeight[k] / (v->WritebackSourceHeight[k] * v->HTotal[k] / v->PixelClock[k]) * 4);
+			if (v->WritebackPixelFormat[k] == dm_444_64) {
 				WritebackDRAMClockChangeLatencyHiding = WritebackDRAMClockChangeLatencyHiding / 2;
 			}
 			WritebackDRAMClockChangeLatencyMargin = WritebackDRAMClockChangeLatencyHiding - v->WritebackDRAMClockChangeWatermark;
@@ -5926,14 +5782,14 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 
 	v->MinActiveDRAMClockChangeMargin = 999999;
 	PlaneWithMinActiveDRAMClockChangeMargin = 0;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
 		if (v->ActiveDRAMClockChangeLatencyMargin[k] < v->MinActiveDRAMClockChangeMargin) {
 			v->MinActiveDRAMClockChangeMargin = v->ActiveDRAMClockChangeLatencyMargin[k];
-			if (BlendingAndTiming[k] == k) {
+			if (v->BlendingAndTiming[k] == k) {
 				PlaneWithMinActiveDRAMClockChangeMargin = k;
 			} else {
-				for (j = 0; j < NumberOfActivePlanes; ++j) {
-					if (BlendingAndTiming[k] == j) {
+				for (j = 0; j < v->NumberOfActivePlanes; ++j) {
+					if (v->BlendingAndTiming[k] == j) {
 						PlaneWithMinActiveDRAMClockChangeMargin = j;
 					}
 				}
@@ -5941,11 +5797,11 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 		}
 	}
 
-	*MinActiveDRAMClockChangeLatencySupported = v->MinActiveDRAMClockChangeMargin + DRAMClockChangeLatency;
+	v->MinActiveDRAMClockChangeLatencySupported = v->MinActiveDRAMClockChangeMargin + v->DRAMClockChangeLatency ;
 
 	SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank = 999999;
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (!((k == PlaneWithMinActiveDRAMClockChangeMargin) && (BlendingAndTiming[k] == k)) && !(BlendingAndTiming[k] == PlaneWithMinActiveDRAMClockChangeMargin)
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (!((k == PlaneWithMinActiveDRAMClockChangeMargin) && (v->BlendingAndTiming[k] == k)) && !(v->BlendingAndTiming[k] == PlaneWithMinActiveDRAMClockChangeMargin)
 				&& v->ActiveDRAMClockChangeLatencyMargin[k] < SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank) {
 			SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank = v->ActiveDRAMClockChangeLatencyMargin[k];
 		}
@@ -5953,25 +5809,25 @@ static void CalculateWatermarksAndDRAMSpeedChangeSupport(
 
 	v->TotalNumberOfActiveOTG = 0;
 
-	for (k = 0; k < NumberOfActivePlanes; ++k) {
-		if (BlendingAndTiming[k] == k) {
+	for (k = 0; k < v->NumberOfActivePlanes; ++k) {
+		if (v->BlendingAndTiming[k] == k) {
 			v->TotalNumberOfActiveOTG = v->TotalNumberOfActiveOTG + 1;
 		}
 	}
 
 	if (v->MinActiveDRAMClockChangeMargin > 0 && PrefetchMode == 0) {
 		*DRAMClockChangeSupport = dm_dram_clock_change_vactive;
-	} else if ((SynchronizedVBlank == true || v->TotalNumberOfActiveOTG == 1
+	} else if ((v->SynchronizedVBlank == true || v->TotalNumberOfActiveOTG == 1
 			|| SecondMinActiveDRAMClockChangeMarginOneDisplayInVBLank > 0) && PrefetchMode == 0) {
 		*DRAMClockChangeSupport = dm_dram_clock_change_vblank;
 	} else {
 		*DRAMClockChangeSupport = dm_dram_clock_change_unsupported;
 	}
 
-	*StutterExitWatermark = SRExitTime + ExtraLatency + 10 / DCFCLKDeepSleep;
-	*StutterEnterPlusExitWatermark = (SREnterPlusExitTime + ExtraLatency + 10 / DCFCLKDeepSleep);
-	*Z8StutterExitWatermark = SRExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
-	*Z8StutterEnterPlusExitWatermark = SREnterPlusExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*StutterExitWatermark = v->SRExitTime + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*StutterEnterPlusExitWatermark = (v->SREnterPlusExitTime + ExtraLatency + 10 / DCFCLKDeepSleep);
+	*Z8StutterExitWatermark = v->SRExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
+	*Z8StutterEnterPlusExitWatermark = v->SREnterPlusExitZ8Time + ExtraLatency + 10 / DCFCLKDeepSleep;
 
 #ifdef __DML_VBA_DEBUG__
 	dml_print("DML::%s: StutterExitWatermark = %f\n", __func__, *StutterExitWatermark);
-- 
2.35.1



