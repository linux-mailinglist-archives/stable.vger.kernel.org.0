Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8469B3BCFEB
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhGFLbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhGFL2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE91D61D69;
        Tue,  6 Jul 2021 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570412;
        bh=HzkaqJ8ahqU9OYMbMKA/VgYQ5vYmkdZj/qJKBcpRqV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUyeRknb3dzOYkL2hskydAU13uC5RvcfikEgn+BdfY1iH3AdAVoNg+3L59ShVt4s7
         9AWJAPjD8MkqOQsktNQhWeWFZ/Q9VqN1vrQytqxAUA3I6wHOuUr3Ms4AtXe0d8J4db
         Qfq7suFcvoXDR6TmRpc0/vQTLRwkJA7I3WCSa2gib+k50wUmXZc7Lf2/xEcRZzxnM5
         QwtXWKCx/qgb4piMIYJjN8zuqNcVYXEjGDeFwKNPxrZlGVVqUOr6yLirlOwYLFb8iL
         k+3Ko+78EwT9cUKV3XB3+CFuBDHTnhQlMwwU6MbAVLrBSpiUlX0SdgMTJIqiWJiFnY
         K14PpBQhZxG/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 079/160] drm/amd/display: Fix off-by-one error in DML
Date:   Tue,  6 Jul 2021 07:17:05 -0400
Message-Id: <20210706111827.2060499-79-sashal@kernel.org>
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

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit e4e3678260e9734f6f41b4325aac0b171833a618 ]

[WHY]
For DCN30 and later, there is no data in DML arrays indexed by state at
index num_states.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index da93694ec7cf..6e326290f214 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -2053,7 +2053,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 			v->DISPCLKWithoutRamping,
 			v->DISPCLKDPPCLKVCOSpeed);
 	v->MaxDispclkRoundedToDFSGranularity = RoundToDFSGranularityDown(
-			v->soc.clock_limits[mode_lib->soc.num_states].dispclk_mhz,
+			v->soc.clock_limits[mode_lib->soc.num_states - 1].dispclk_mhz,
 			v->DISPCLKDPPCLKVCOSpeed);
 	if (v->DISPCLKWithoutRampingRoundedToDFSGranularity
 			> v->MaxDispclkRoundedToDFSGranularity) {
@@ -3958,20 +3958,20 @@ void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			for (k = 0; k <= v->NumberOfActivePlanes - 1; k++) {
 				v->PlaneRequiredDISPCLKWithoutODMCombine = v->PixelClock[k] * (1.0 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0)
 						* (1.0 + v->DISPCLKRampingMargin / 100.0);
-				if ((v->PlaneRequiredDISPCLKWithoutODMCombine >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states]
-						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states])) {
+				if ((v->PlaneRequiredDISPCLKWithoutODMCombine >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states - 1]
+						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states - 1])) {
 					v->PlaneRequiredDISPCLKWithoutODMCombine = v->PixelClock[k] * (1 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 				}
 				v->PlaneRequiredDISPCLKWithODMCombine2To1 = v->PixelClock[k] / 2 * (1 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0)
 						* (1 + v->DISPCLKRampingMargin / 100.0);
-				if ((v->PlaneRequiredDISPCLKWithODMCombine2To1 >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states]
-						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states])) {
+				if ((v->PlaneRequiredDISPCLKWithODMCombine2To1 >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states - 1]
+						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states - 1])) {
 					v->PlaneRequiredDISPCLKWithODMCombine2To1 = v->PixelClock[k] / 2 * (1 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 				}
 				v->PlaneRequiredDISPCLKWithODMCombine4To1 = v->PixelClock[k] / 4 * (1 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0)
 						* (1 + v->DISPCLKRampingMargin / 100.0);
-				if ((v->PlaneRequiredDISPCLKWithODMCombine4To1 >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states]
-						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states])) {
+				if ((v->PlaneRequiredDISPCLKWithODMCombine4To1 >= v->MaxDispclk[i] && v->MaxDispclk[i] == v->MaxDispclk[mode_lib->soc.num_states - 1]
+						&& v->MaxDppclk[i] == v->MaxDppclk[mode_lib->soc.num_states - 1])) {
 					v->PlaneRequiredDISPCLKWithODMCombine4To1 = v->PixelClock[k] / 4 * (1 + v->DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 				}
 
-- 
2.30.2

