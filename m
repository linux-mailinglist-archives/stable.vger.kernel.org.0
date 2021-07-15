Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2A93CA8D8
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240699AbhGOTDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242192AbhGOTBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4400E613E9;
        Thu, 15 Jul 2021 18:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375508;
        bh=HzkaqJ8ahqU9OYMbMKA/VgYQ5vYmkdZj/qJKBcpRqV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvJlObj7mSBW4JCRIpLCH9iZ0UC3+ZDv/Gk4ncNASJVl5jrc1+XqOA9wpX1FuLL6s
         JXw+t5n7/AzS/05PPCee9dOwKnG8EtlKOk0xTYeepAnlnJkTBriDohuQ/Y3POswFSu
         ExEaCYlaJtJKVziUVu8NExRiCGzguUzKnDQ/cHgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 074/242] drm/amd/display: Fix off-by-one error in DML
Date:   Thu, 15 Jul 2021 20:37:16 +0200
Message-Id: <20210715182605.983697745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



