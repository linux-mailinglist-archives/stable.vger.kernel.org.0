Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E03BCF85
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhGFLak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhGFL1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77BC361C7C;
        Tue,  6 Jul 2021 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570406;
        bh=X0w02puo77F68+8le7QE3kDrHw1VQlrHjRjPb7+KKDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvxTMteZ7sG2Wn8IVoghULViS3253iUUbS7kzTiktaWTLBss0vsw1mhBeTlVw9Ggk
         BLfwuNltUBCPmvLY8wqgpEToelzhLEwPO2dBUAf1vYa908RlNq3/SoJ9O/urIm+l+l
         fD4zBi1CgSVq7AhB/XD1trTYai8FDXNyJZyUb+k47oo3cKplLo8NbcZ797jGToszia
         3ri1S9lHy6mLWa2sdDuryYD7ZIPlMW1/W9jZvylwJcnGqbUQXdwugpZ6+01XWFiamu
         huFPrJOlrKcbvD9N99W8Ofro4gUgzsBMb7I6Z9tJuodNJJuHgDFrlU+6LdDndKI6nu
         azvjKiFelrq7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 075/160] drm/amd/display: Fix DCN 3.01 DSCCLK validation
Date:   Tue,  6 Jul 2021 07:17:01 -0400
Message-Id: <20210706111827.2060499-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 346cf627fb27c0fea63a041cedbaa4f31784e504 ]

[why]
DSCCLK validation is not necessary because DSCCLK is derrived from
DISPCLK, therefore if DISPCLK validation passes, DSCCLK is valid, too.
Doing DSCLK validation in addition to DISPCLK leads to modes being
wrongly rejected when DSCCLK was incorrectly set outside of DML.

[how]
Remove DSCCLK validation because it's implicitly validated under DISPCLK

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml/dcn30/display_mode_vba_30.c        | 64 ++++++-------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index bc07082c1357..da93694ec7cf 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -64,6 +64,7 @@ typedef struct {
 #define BPP_INVALID 0
 #define BPP_BLENDED_PIPE 0xffffffff
 #define DCN30_MAX_DSC_IMAGE_WIDTH 5184
+#define DCN30_MAX_FMT_420_BUFFER_WIDTH 4096
 
 static void DisplayPipeConfiguration(struct display_mode_lib *mode_lib);
 static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation(
@@ -3987,19 +3988,30 @@ void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				} else if (v->PlaneRequiredDISPCLKWithoutODMCombine > v->MaxDispclkRoundedDownToDFSGranularity) {
 					v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 					v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine2To1;
-				} else if (v->DSCEnabled[k] && (v->HActive[k] > DCN30_MAX_DSC_IMAGE_WIDTH)) {
-					v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
-					v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine2To1;
 				} else {
 					v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithoutODMCombine;
-					/*420 format workaround*/
-					if (v->HActive[k] > 4096 && v->OutputFormat[k] == dm_420) {
+				}
+				if (v->DSCEnabled[k] && v->HActive[k] > DCN30_MAX_DSC_IMAGE_WIDTH
+						&& v->ODMCombineEnablePerState[i][k] != dm_odm_combine_mode_4to1) {
+					if (v->HActive[k] / 2 > DCN30_MAX_DSC_IMAGE_WIDTH) {
+						v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_4to1;
+						v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine4To1;
+					} else {
+						v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
+						v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine2To1;
+					}
+				}
+				if (v->OutputFormat[k] == dm_420 && v->HActive[k] > DCN30_MAX_FMT_420_BUFFER_WIDTH
+						&& v->ODMCombineEnablePerState[i][k] != dm_odm_combine_mode_4to1) {
+					if (v->HActive[k] / 2 > DCN30_MAX_FMT_420_BUFFER_WIDTH) {
+						v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_4to1;
+						v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine4To1;
+					} else {
 						v->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						v->PlaneRequiredDISPCLK = v->PlaneRequiredDISPCLKWithODMCombine2To1;
 					}
 				}
-
 				if (v->ODMCombineEnablePerState[i][k] == dm_odm_combine_mode_4to1) {
 					v->MPCCombine[i][j][k] = false;
 					v->NoOfDPP[i][j][k] = 4;
@@ -4281,42 +4293,8 @@ void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 		}
 	}
 
-	for (i = 0; i < v->soc.num_states; i++) {
-		v->DSCCLKRequiredMoreThanSupported[i] = false;
-		for (k = 0; k <= v->NumberOfActivePlanes - 1; k++) {
-			if (v->BlendingAndTiming[k] == k) {
-				if (v->Output[k] == dm_dp || v->Output[k] == dm_edp) {
-					if (v->OutputFormat[k] == dm_420) {
-						v->DSCFormatFactor = 2;
-					} else if (v->OutputFormat[k] == dm_444) {
-						v->DSCFormatFactor = 1;
-					} else if (v->OutputFormat[k] == dm_n422) {
-						v->DSCFormatFactor = 2;
-					} else {
-						v->DSCFormatFactor = 1;
-					}
-					if (v->RequiresDSC[i][k] == true) {
-						if (v->ODMCombineEnablePerState[i][k] == dm_odm_combine_mode_4to1) {
-							if (v->PixelClockBackEnd[k] / 12.0 / v->DSCFormatFactor
-									> (1.0 - v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0) * v->MaxDSCCLK[i]) {
-								v->DSCCLKRequiredMoreThanSupported[i] = true;
-							}
-						} else if (v->ODMCombineEnablePerState[i][k] == dm_odm_combine_mode_2to1) {
-							if (v->PixelClockBackEnd[k] / 6.0 / v->DSCFormatFactor
-									> (1.0 - v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0) * v->MaxDSCCLK[i]) {
-								v->DSCCLKRequiredMoreThanSupported[i] = true;
-							}
-						} else {
-							if (v->PixelClockBackEnd[k] / 3.0 / v->DSCFormatFactor
-									> (1.0 - v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0) * v->MaxDSCCLK[i]) {
-								v->DSCCLKRequiredMoreThanSupported[i] = true;
-							}
-						}
-					}
-				}
-			}
-		}
-	}
+	/* Skip dscclk validation: as long as dispclk is supported, dscclk is also implicitly supported */
+
 	for (i = 0; i < v->soc.num_states; i++) {
 		v->NotEnoughDSCUnits[i] = false;
 		v->TotalDSCUnitsRequired = 0.0;
@@ -5319,7 +5297,7 @@ void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 		for (j = 0; j < 2; j++) {
 			if (v->ScaleRatioAndTapsSupport == 1 && v->SourceFormatPixelAndScanSupport == 1 && v->ViewportSizeSupport[i][j] == 1
 					&& v->DIOSupport[i] == 1 && v->ODMCombine4To1SupportCheckOK[i] == 1
-					&& v->NotEnoughDSCUnits[i] == 0 && v->DSCCLKRequiredMoreThanSupported[i] == 0
+					&& v->NotEnoughDSCUnits[i] == 0
 					&& v->DTBCLKRequiredMoreThanSupported[i] == 0
 					&& v->ROBSupport[i][j] == 1 && v->DISPCLK_DPPCLK_Support[i][j] == 1 && v->TotalAvailablePipesSupport[i][j] == 1
 					&& EnoughWritebackUnits == 1 && WritebackModeSupport == 1
-- 
2.30.2

