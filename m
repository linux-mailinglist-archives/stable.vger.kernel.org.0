Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D736BB2B8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjCOMiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjCOMhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8791DA18AA
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7C8861D72
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C983CC433EF;
        Wed, 15 Mar 2023 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883808;
        bh=y73/kN91RZcTHXH7B/OQeP5QDpLgQD8ettlH7/7IpvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAz//RTtCkJ5tUFOKubKTlBvbdAZKl37vlklrK9ePMT/ZxDwiu58X6Ioe+chOst0G
         HnwizyNy2UHx3unn+h74NSrPkUIFfcfOAHoGGaPWNiXeHVlVkg18NGR560dkfY12Cx
         qXgg5rWIsETA58TB0bbCSexJZbEOza1Jf+pnh81g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 139/143] drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60
Date:   Wed, 15 Mar 2023 13:13:45 +0100
Message-Id: <20230315115744.842682676@linuxfoundation.org>
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
@@ -142,6 +142,8 @@ void dcn32_restore_mall_state(struct dc
 		struct dc_state *context,
 		struct mall_temp_config *temp_config);
 
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -676,7 +676,9 @@ static bool dcn32_assign_subvp_pipe(stru
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
@@ -2558,3 +2560,30 @@ void dcn32_zero_pipe_dcc_fraction(displa
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


