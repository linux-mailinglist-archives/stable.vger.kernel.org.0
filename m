Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC703CA779
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405952AbfJCQyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406404AbfJCQxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE13A2054F;
        Thu,  3 Oct 2019 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121601;
        bh=OYnWfj8u1yoEoDPvb0spt52JZipGsPkx3S6gV3+bePI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgI7bUlcqm/iiwNK/yN5a/FWP+20CXAd0caFwTa+D3rNH4a3jJ4R3vbc2ZqVfhFuQ
         6T5WHl7+ZhZgWmZALsRNRAP7QtyRZLdKyMnCHvt7EiQVHfy59HMiy6W09rEp3FDsCc
         K960yB96UHEZSLunI5UVOQtFCGqAuOeXX6ba6j7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 338/344] drm/amd/display: dce11.x /dce12 update formula input
Date:   Thu,  3 Oct 2019 17:55:03 +0200
Message-Id: <20191003154611.884466038@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <charlene.liu@amd.com>

commit c46e5df4ac898108da66a880c4e18f69c74f6c1b upstream.

[Description]
1. OUTSTANDING_REQUEST_LIMIT update from 0xFF to 0x1F (HW doc update)
2. using memory type to convert UMC's MCLK to Yclk.

Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |    7 +++-
 drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c             |    4 +-
 drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c        |   16 ++++++----
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c        |   11 +++++-
 drivers/gpu/drm/amd/display/dc/inc/resource.h                  |    2 +
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -98,11 +98,14 @@ uint32_t dce110_get_min_vblank_time_us(c
 		struct dc_stream_state *stream = context->streams[j];
 		uint32_t vertical_blank_in_pixels = 0;
 		uint32_t vertical_blank_time = 0;
+		uint32_t vertical_total_min = stream->timing.v_total;
+		struct dc_crtc_timing_adjust adjust = stream->adjust;
+		if (adjust.v_total_max != adjust.v_total_min)
+			vertical_total_min = adjust.v_total_min;
 
 		vertical_blank_in_pixels = stream->timing.h_total *
-			(stream->timing.v_total
+			(vertical_total_min
 			 - stream->timing.v_addressable);
-
 		vertical_blank_time = vertical_blank_in_pixels
 			* 10000 / stream->timing.pix_clk_100hz;
 
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_mem_input.c
@@ -148,7 +148,7 @@ static void dce_mi_program_pte_vm(
 			pte->min_pte_before_flip_horiz_scan;
 
 	REG_UPDATE(GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT,
-			GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT, 0xff);
+			GRPH_PIPE_OUTSTANDING_REQUEST_LIMIT, 0x7f);
 
 	REG_UPDATE_3(DVMM_PTE_CONTROL,
 			DVMM_PAGE_WIDTH, page_width,
@@ -157,7 +157,7 @@ static void dce_mi_program_pte_vm(
 
 	REG_UPDATE_2(DVMM_PTE_ARB_CONTROL,
 			DVMM_PTE_REQ_PER_CHUNK, pte->pte_req_per_chunk,
-			DVMM_MAX_PTE_REQ_OUTSTANDING, 0xff);
+			DVMM_MAX_PTE_REQ_OUTSTANDING, 0x7f);
 }
 
 static void program_urgency_watermark(
--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -987,6 +987,10 @@ static void bw_calcs_data_update_from_pp
 	struct dm_pp_clock_levels_with_latency mem_clks = {0};
 	struct dm_pp_wm_sets_with_clock_ranges clk_ranges = {0};
 	struct dm_pp_clock_levels clks = {0};
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
+
+	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	/*do system clock  TODO PPLIB: after PPLIB implement,
 	 * then remove old way
@@ -1026,12 +1030,12 @@ static void bw_calcs_data_update_from_pp
 				&clks);
 
 		dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[0] * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+			clks.clocks_in_khz[0] * memory_type_multiplier, 1000);
 		dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[clks.num_levels>>1] * MEMORY_TYPE_MULTIPLIER_CZ,
+			clks.clocks_in_khz[clks.num_levels>>1] * memory_type_multiplier,
 			1000);
 		dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-			clks.clocks_in_khz[clks.num_levels-1] * MEMORY_TYPE_MULTIPLIER_CZ,
+			clks.clocks_in_khz[clks.num_levels-1] * memory_type_multiplier,
 			1000);
 
 		return;
@@ -1067,12 +1071,12 @@ static void bw_calcs_data_update_from_pp
 	 * YCLK = UMACLK*m_memoryTypeMultiplier
 	 */
 	dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-		mem_clks.data[0].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+		mem_clks.data[0].clocks_in_khz * memory_type_multiplier, 1000);
 	dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * memory_type_multiplier,
 		1000);
 	dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * memory_type_multiplier,
 		1000);
 
 	/* Now notify PPLib/SMU about which Watermarks sets they should select
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -847,6 +847,8 @@ static void bw_calcs_data_update_from_pp
 	int i;
 	unsigned int clk;
 	unsigned int latency;
+	/*original logic in dal3*/
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
 
 	/*do system clock*/
 	if (!dm_pp_get_clock_levels_by_type_with_latency(
@@ -905,13 +907,16 @@ static void bw_calcs_data_update_from_pp
 	 * ALSO always convert UMA clock (from PPLIB)  to YCLK (HW formula):
 	 * YCLK = UMACLK*m_memoryTypeMultiplier
 	 */
+	if (dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
+
 	dc->bw_vbios->low_yclk = bw_frc_to_fixed(
-		mem_clks.data[0].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ, 1000);
+		mem_clks.data[0].clocks_in_khz * memory_type_multiplier, 1000);
 	dc->bw_vbios->mid_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels>>1].clocks_in_khz * memory_type_multiplier,
 		1000);
 	dc->bw_vbios->high_yclk = bw_frc_to_fixed(
-		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * MEMORY_TYPE_MULTIPLIER_CZ,
+		mem_clks.data[mem_clks.num_levels-1].clocks_in_khz * memory_type_multiplier,
 		1000);
 
 	/* Now notify PPLib/SMU about which Watermarks sets they should select
--- a/drivers/gpu/drm/amd/display/dc/inc/resource.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/resource.h
@@ -31,6 +31,8 @@
 #include "dm_pp_smu.h"
 
 #define MEMORY_TYPE_MULTIPLIER_CZ 4
+#define MEMORY_TYPE_HBM 2
+
 
 enum dce_version resource_parse_asic_id(
 		struct hw_asic_id asic_id);


