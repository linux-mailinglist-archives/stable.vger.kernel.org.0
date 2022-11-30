Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E210163DFDE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiK3Svd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiK3SvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1B59FED9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8065B81CAD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377EBC433D7;
        Wed, 30 Nov 2022 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834264;
        bh=Nj1yVjxkyj2iKwQZ8vh5JhwE++FRLd/EVSD9B2hcqjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2j1hC7c48I+a5zoxWWVpaUAJt+rmgmxBr04FNyNyhugeGII3ko6VXJ0tYklNRABE
         ZVX/sXhdzb3sqRt52ftWF382XO2c+7Rz5pLZImA+KciXZj0tS1x18IVEq8hyraRkgh
         xxIwKDwtv6I7wTSge3eEfodrXTZIxkpqwoBGu8GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
        Wayne Lin <wayne.lin@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 189/289] drm/amd/display: Add debug option for allocating extra way for cursor
Date:   Wed, 30 Nov 2022 19:22:54 +0100
Message-Id: <20221130180548.409278066@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit 6eef37460584269b240f45aa47ebb61aae848082 ]

[Why and How]
- Add a debug option for allocating extra way for cursor
- Remove usage of cache_cursor_addr since it's not gaurenteed
  to be populated
- Include cursor size in MALL calculation if it exceeds the
  DCN cursor buffer size (and don't need extra way for cursor)

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4d2852412306 ("drm/amd/display: Fix calculation for cursor CAB allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                    |  1 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c     | 10 ++++++----
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |  1 +
 .../gpu/drm/amd/display/dc/dcn321/dcn321_resource.c    |  1 +
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index a652dec5d02f..0d4340f0f688 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -747,6 +747,7 @@ struct dc_debug_options {
 	bool force_subvp_mclk_switch;
 	bool allow_sw_cursor_fallback;
 	unsigned int force_subvp_num_ways;
+	bool alloc_extra_way_for_cursor;
 	bool force_usr_allow;
 	/* uses value at boot and disables switch */
 	bool disable_dtb_ref_clk_switch;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index c72166e096ba..0751e1202c95 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -304,7 +304,8 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 				 * using the max for calculation
 				 */
 				if (hubp->curs_attr.width > 0) {
-					cursor_size = hubp->curs_attr.width * hubp->curs_attr.height;
+					// Round cursor width to next multiple of 64
+					cursor_size = (((hubp->curs_attr.width + 63) / 64) * 64) * hubp->curs_attr.height;
 					break;
 				}
 		}
@@ -325,7 +326,8 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 			break;
 		}
 
-		if (stream->cursor_position.enable && plane->address.grph.cursor_cache_addr.quad_part) {
+		if (stream->cursor_position.enable && !dc->debug.alloc_extra_way_for_cursor &&
+				cursor_size > 16384) {
 			cache_lines_used += dcn32_cache_lines_for_surface(dc, cursor_size,
 					plane->address.grph.cursor_cache_addr.quad_part);
 		}
@@ -345,8 +347,8 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 			plane = ctx->stream_status[i].plane_states[j];
 
 			if (stream->cursor_position.enable && plane &&
-				!plane->address.grph.cursor_cache_addr.quad_part &&
-				cursor_size > 16384) {
+					dc->debug.alloc_extra_way_for_cursor &&
+					cursor_size > 16384) {
 				/* Cursor caching is not supported since it won't be on the same line.
 				 * So we need an extra line to accommodate it. With large cursors and a single 4k monitor
 				 * this case triggers corruption. If we're at the edge, then dont trigger display refresh
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index c3b783cea8a0..6f1bcb45a3b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -872,6 +872,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.enable_single_display_2to1_odm_policy = true,
 	.enable_dp_dig_pixel_rate_div_policy = 1,
 	.allow_sw_cursor_fallback = false,
+	.alloc_extra_way_for_cursor = true,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index 7309eed33a61..d074716dc197 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -873,6 +873,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.enable_single_display_2to1_odm_policy = true,
 	.enable_dp_dig_pixel_rate_div_policy = 1,
 	.allow_sw_cursor_fallback = false,
+	.alloc_extra_way_for_cursor = true,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
-- 
2.35.1



