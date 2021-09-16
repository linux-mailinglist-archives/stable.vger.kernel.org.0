Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0651D40E120
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhIPQ1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241629AbhIPQZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 282A861283;
        Thu, 16 Sep 2021 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809004;
        bh=PXURHF48EWTCkfkX8k0wFAaIOg2I+wWauTCiRzG1kbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eff+TsFPmF52URRPIEzZJMlVqWQ3H68rRZwTiBN3PHRybO879pK+MXeroVVqYCb0H
         ra8dryAaWunxZS2lYdzE7MM9XLAvvvScplqW399vwAqRM08V4oX1qEehNzwoHsKZQr
         3QZsQJRzOgJ6JbkkgApuklTJtePRCxNDYgKPGJQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 302/306] drm/amd/display: Update bounding box states (v2)
Date:   Thu, 16 Sep 2021 18:00:47 +0200
Message-Id: <20210916155804.379303465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>

commit a7a9d11e12fcc32160d55e8612e72e5ab51b15dc upstream.

[Why]
Drop hardcoded dispclk, dppclk, phyclk

[How]
Read the corresponding values from clock table entries already populated.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1403
Cc: stable@vger.kernel.org
Signed-off-by: Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c |   41 +++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2455,16 +2455,37 @@ void dcn30_update_bw_bounding_box(struct
 	dc->dml.soc.dispclk_dppclk_vco_speed_mhz = dc->clk_mgr->dentist_vco_freq_khz / 1000.0;
 
 	if (bw_params->clk_table.entries[0].memclk_mhz) {
+		int max_dcfclk_mhz = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0, max_phyclk_mhz = 0;
 
-		if (bw_params->clk_table.entries[1].dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		for (i = 0; i < MAX_NUM_DPM_LVL; i++) {
+			if (bw_params->clk_table.entries[i].dcfclk_mhz > max_dcfclk_mhz)
+				max_dcfclk_mhz = bw_params->clk_table.entries[i].dcfclk_mhz;
+			if (bw_params->clk_table.entries[i].dispclk_mhz > max_dispclk_mhz)
+				max_dispclk_mhz = bw_params->clk_table.entries[i].dispclk_mhz;
+			if (bw_params->clk_table.entries[i].dppclk_mhz > max_dppclk_mhz)
+				max_dppclk_mhz = bw_params->clk_table.entries[i].dppclk_mhz;
+			if (bw_params->clk_table.entries[i].phyclk_mhz > max_phyclk_mhz)
+				max_phyclk_mhz = bw_params->clk_table.entries[i].phyclk_mhz;
+		}
+
+		if (!max_dcfclk_mhz)
+			max_dcfclk_mhz = dcn3_0_soc.clock_limits[0].dcfclk_mhz;
+		if (!max_dispclk_mhz)
+			max_dispclk_mhz = dcn3_0_soc.clock_limits[0].dispclk_mhz;
+		if (!max_dppclk_mhz)
+			max_dppclk_mhz = dcn3_0_soc.clock_limits[0].dppclk_mhz;
+		if (!max_phyclk_mhz)
+			max_phyclk_mhz = dcn3_0_soc.clock_limits[0].phyclk_mhz;
+
+		if (max_dcfclk_mhz > dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is greater than the max DCFCLK STA target, insert into the DCFCLK STA target array
-			dcfclk_sta_targets[num_dcfclk_sta_targets] = bw_params->clk_table.entries[1].dcfclk_mhz;
+			dcfclk_sta_targets[num_dcfclk_sta_targets] = max_dcfclk_mhz;
 			num_dcfclk_sta_targets++;
-		} else if (bw_params->clk_table.entries[1].dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
+		} else if (max_dcfclk_mhz < dcfclk_sta_targets[num_dcfclk_sta_targets-1]) {
 			// If max DCFCLK is less than the max DCFCLK STA target, cap values and remove duplicates
 			for (i = 0; i < num_dcfclk_sta_targets; i++) {
-				if (dcfclk_sta_targets[i] > bw_params->clk_table.entries[1].dcfclk_mhz) {
-					dcfclk_sta_targets[i] = bw_params->clk_table.entries[1].dcfclk_mhz;
+				if (dcfclk_sta_targets[i] > max_dcfclk_mhz) {
+					dcfclk_sta_targets[i] = max_dcfclk_mhz;
 					break;
 				}
 			}
@@ -2502,7 +2523,7 @@ void dcn30_update_bw_bounding_box(struct
 				dcfclk_mhz[num_states] = dcfclk_sta_targets[i];
 				dram_speed_mts[num_states++] = optimal_uclk_for_dcfclk_sta_targets[i++];
 			} else {
-				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				if (j < num_uclk_states && optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 					dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 					dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 				} else {
@@ -2517,7 +2538,7 @@ void dcn30_update_bw_bounding_box(struct
 		}
 
 		while (j < num_uclk_states && num_states < DC__VOLTAGE_STATES &&
-				optimal_dcfclk_for_uclk[j] <= bw_params->clk_table.entries[1].dcfclk_mhz) {
+				optimal_dcfclk_for_uclk[j] <= max_dcfclk_mhz) {
 			dcfclk_mhz[num_states] = optimal_dcfclk_for_uclk[j];
 			dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
 		}
@@ -2530,9 +2551,9 @@ void dcn30_update_bw_bounding_box(struct
 			dcn3_0_soc.clock_limits[i].dram_speed_mts = dram_speed_mts[i];
 
 			/* Fill all states with max values of all other clocks */
-			dcn3_0_soc.clock_limits[i].dispclk_mhz = bw_params->clk_table.entries[1].dispclk_mhz;
-			dcn3_0_soc.clock_limits[i].dppclk_mhz  = bw_params->clk_table.entries[1].dppclk_mhz;
-			dcn3_0_soc.clock_limits[i].phyclk_mhz  = bw_params->clk_table.entries[1].phyclk_mhz;
+			dcn3_0_soc.clock_limits[i].dispclk_mhz = max_dispclk_mhz;
+			dcn3_0_soc.clock_limits[i].dppclk_mhz  = max_dppclk_mhz;
+			dcn3_0_soc.clock_limits[i].phyclk_mhz  = max_phyclk_mhz;
 			dcn3_0_soc.clock_limits[i].dtbclk_mhz = dcn3_0_soc.clock_limits[0].dtbclk_mhz;
 			/* These clocks cannot come from bw_params, always fill from dcn3_0_soc[1] */
 			/* FCLK, PHYCLK_D18, SOCCLK, DSCCLK */


