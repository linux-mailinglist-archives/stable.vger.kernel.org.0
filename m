Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A686BB2BC
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjCOMiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjCOMh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8DA1FC9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA2EB81E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0766BC433EF;
        Wed, 15 Mar 2023 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883813;
        bh=YMkGfqhtVVRntZQtIZW6/iXzudIUL/DIYNm30z+KvM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4D+T7MIVWcuKAm/z6WN08/FsPKBE9q8IuRAuX8uOsZWfV6iZiH1LKxpkFuKA6sUS
         AEky9ytKvULX7Y3GRhfPmTz4ZJf/5rCzDXszYS/0LTA9R0kvsHHHnQgSUr5+sIpEOS
         UKRcF5Gx12/Ok83dfPxICDjNqOaCdkQDV5Xo+4jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Samson Tam <Samson.Tam@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 140/143] drm/amd/display: adjust MALL size available for DCN32 and DCN321
Date:   Wed, 15 Mar 2023 13:13:46 +0100
Message-Id: <20230315115744.882048253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samson Tam <Samson.Tam@amd.com>

commit 235fef6c7fd341026eee90cc546e6e8ff8b2c315 upstream.

[Why]
MALL size available can vary for different SKUs.
Use num_chans read from VBIOS to determine the available MALL size we can use

[How]
Define max_chans for DCN32 and DCN321.
If num_chans is max_chans, then return max_chans as we can access the
 entire MALL space.
Otherwise, define avail_chans as the number of available channels we are
 allowed instead.
Return corresponding number of channels back and use this to calculate
 available MALL size.

Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c   |   62 +++++++++++++++-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h   |    2 
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c |    9 ++
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c    |    5 +
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c  |    5 +
 5 files changed, 78 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2109,13 +2109,19 @@ static bool dcn32_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
-	dc->caps.max_cab_allocation_bytes = 67108864; // 64MB = 1024 * 1024 * 64
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_prefetch_end_to_mall_start_us = 15;
 	dc->caps.subvp_swath_height_margin_lines = 16;
@@ -2545,3 +2551,55 @@ struct pipe_ctx *dcn32_acquire_idle_pipe
 
 	return idle_pipe;
 }
+
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans)
+{
+	/*
+	 * DCN32 and DCN321 SKUs may have different sizes for MALL
+	 *  but we may not be able to access all the MALL space.
+	 *  If the num_chans is power of 2, then we can access all
+	 *  of the available MALL space.  Otherwise, we can only
+	 *  access:
+	 *
+	 *  max_cab_size_in_bytes = total_cache_size_in_bytes *
+	 *    ((2^floor(log2(num_chans)))/num_chans)
+	 *
+	 * Calculating the MALL sizes for all available SKUs, we
+	 *  have come up with the follow simplified check.
+	 * - we have max_chans which provides the max MALL size.
+	 *  Each chans supports 4MB of MALL so:
+	 *
+	 *  total_cache_size_in_bytes = max_chans * 4 MB
+	 *
+	 * - we have avail_chans which shows the number of channels
+	 *  we can use if we can't access the entire MALL space.
+	 *  It is generally half of max_chans
+	 * - so we use the following checks:
+	 *
+	 *   if (num_chans == max_chans), return max_chans
+	 *   if (num_chans < max_chans), return avail_chans
+	 *
+	 * - exception is GC_11_0_0 where we can't access max_chans,
+	 *  so we define max_avail_chans as the maximum available
+	 *  MALL space
+	 *
+	 */
+	int gc_11_0_0_max_chans = 48;
+	int gc_11_0_0_max_avail_chans = 32;
+	int gc_11_0_0_avail_chans = 16;
+	int gc_11_0_3_max_chans = 16;
+	int gc_11_0_3_avail_chans = 8;
+	int gc_11_0_2_max_chans = 8;
+	int gc_11_0_2_avail_chans = 4;
+
+	if (ASICREV_IS_GC_11_0_0(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_0_max_chans) ?
+			gc_11_0_0_max_avail_chans : gc_11_0_0_avail_chans;
+	} else if (ASICREV_IS_GC_11_0_2(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_2_max_chans) ?
+			gc_11_0_2_max_chans : gc_11_0_2_avail_chans;
+	} else { // if (ASICREV_IS_GC_11_0_3(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_3_max_chans) ?
+			gc_11_0_3_max_chans : gc_11_0_3_avail_chans;
+	}
+}
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -144,6 +144,8 @@ void dcn32_restore_mall_state(struct dc
 
 bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
 
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1697,11 +1697,18 @@ static bool dcn321_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.max_cab_allocation_bytes = 33554432; // 32MB = 1024 * 1024 * 32
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_prefetch_end_to_mall_start_us = 15;
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2381,8 +2381,11 @@ void dcn32_update_bw_bounding_box_fpu(st
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_2_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_2_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_2_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -534,8 +534,11 @@ void dcn321_update_bw_bounding_box_fpu(s
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_21_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_21_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_21_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;


