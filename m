Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B386BB384
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjCOMpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjCOMpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FAEA42CC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B54D061D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4A0C433D2;
        Wed, 15 Mar 2023 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884207;
        bh=6G7p9lEv71Gh3ozSCWRmrRxEqrVSHa/E/DG4F4N2gV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2q/dlOK74Ee9v03oULsZHdur/5MhWfGqtC45TdRR5YPtZ0bu8RjuFjlxQDxYSnaI
         9gUZUDuchhyw/tm/x3xFKbwwHdl5XXZV50nNE9Shy9i8ZKyePeE1eVxSK4q/5Ul894
         3Zs0XZn004xXS9hUsSDNEUQzf3A/bPx1k0XxFUPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 136/141] drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60
Date:   Wed, 15 Mar 2023 13:13:59 +0100
Message-Id: <20230315115744.135663050@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Alvin Lee <Alvin.Lee2@amd.com>

commit 2ebd1036209c2e7b61e6bc6e5bee4b67c1684ac6 upstream.

Enable subvp on specifically 1440p@60hz displays even though it can
switch in vactive.

Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h |    2 +
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  |   31 +++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -134,6 +134,8 @@ void dcn32_restore_mall_state(struct dc
 		struct dc_state *context,
 		struct mall_temp_config *temp_config);
 
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -693,7 +693,9 @@ static bool dcn32_assign_subvp_pipe(stru
 		 */
 		if (pipe->plane_state && !pipe->top_pipe &&
 				pipe->stream->mall_stream_config.type == SUBVP_NONE && refresh_rate < 120 && !pipe->plane_state->address.tmz_surface &&
-				vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0) {
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0 ||
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] > 0 &&
+						dcn32_allow_subvp_with_active_margin(pipe)))) {
 			while (pipe) {
 				num_pipes++;
 				pipe = pipe->bottom_pipe;
@@ -2630,3 +2632,30 @@ void dcn32_zero_pipe_dcc_fraction(displa
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
 }
+
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe)
+{
+	bool allow = false;
+	uint32_t refresh_rate = 0;
+
+	/* Allow subvp on displays that have active margin for 2560x1440@60hz displays
+	 * only for now. There must be no scaling as well.
+	 *
+	 * For now we only enable on 2560x1440@60hz displays to enable 4K60 + 1440p60 configs
+	 * for p-state switching.
+	 */
+	if (pipe->stream && pipe->plane_state) {
+		refresh_rate = (pipe->stream->timing.pix_clk_100hz * 100 +
+						pipe->stream->timing.v_total * pipe->stream->timing.h_total - 1)
+						/ (double)(pipe->stream->timing.v_total * pipe->stream->timing.h_total);
+		if (pipe->stream->timing.v_addressable == 1440 &&
+				pipe->stream->timing.h_addressable == 2560 &&
+				refresh_rate >= 55 && refresh_rate <= 65 &&
+				pipe->plane_state->src_rect.height == 1440 &&
+				pipe->plane_state->src_rect.width == 2560 &&
+				pipe->plane_state->dst_rect.height == 1440 &&
+				pipe->plane_state->dst_rect.width == 2560)
+			allow = true;
+	}
+	return allow;
+}


