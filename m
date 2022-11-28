Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F563AF8C
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiK1RnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiK1RnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:43:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B02AE10;
        Mon, 28 Nov 2022 09:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE5BB80E9D;
        Mon, 28 Nov 2022 17:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A471FC433D6;
        Mon, 28 Nov 2022 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657219;
        bh=9u5TaViKnyQ/NGo9JoowSSVSG3Gh3W9jFt6MUomJw7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVrh1Yd3LzMwJaKaModYbyFbuWTMAwd8znkIrXoLmlkGB+pjHeV4i8kD2jjJ7Ctvb
         oSvL8V1rItoYpTmwTuRo8TcRDf18SHdWF7gN+mjxPIii5Mxi2LXWW6eCPa5v5wv8uJ
         Qz9lJKx4Eg+AkZSGdpslXkBGYSQ1bilhsztrZ/XTKhG5o4DyASvhu6TXf/TRJAS/zi
         jwuyBRkIRKEV3pfI1tZ2x9M3qMbIZ2N/CBHzMj7BfLYWAzSpkXF4enaY/7hf5CvzBi
         zj3tVv1A/1WtuJizJqfrU86Kjnw3tblOVnl0SLitRzshN8h5t+gW8iznBhjj0USPpC
         50JHLV92qqCPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dillon Varone <Dillon.Varone@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Alvin.Lee2@amd.com, David.Galiffi@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 38/39] drm/amd/display: Use new num clk levels struct for max mclk index
Date:   Mon, 28 Nov 2022 12:36:18 -0500
Message-Id: <20221128173642.1441232-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit e667ee3b0c049bf0c69426879586a2572bb28d26 ]

[WHY?]
When calculating watermark and dlg values, the max mclk level index and
associated speed are needed to find the correlated dummy latency value.
Currently the incorrect index is given due to a clock manager refactor.

[HOW?]
Use num_memclk_level from num_entries_per_clk struct for getting the correct max
mem speed.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index b9d3a4000c3d..221253638b4d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1797,7 +1797,7 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 
 		if (context->bw_ctx.dml.vba.DRAMClockChangeSupport[vlevel][maxMpcComb] ==
 			dm_dram_clock_change_unsupported) {
-			int min_dram_speed_mts_offset = dc->clk_mgr->bw_params->clk_table.num_entries - 1;
+			int min_dram_speed_mts_offset = dc->clk_mgr->bw_params->clk_table.num_entries_per_clk.num_memclk_levels - 1;
 
 			min_dram_speed_mts =
 				dc->clk_mgr->bw_params->clk_table.entries[min_dram_speed_mts_offset].memclk_mhz * 16;
-- 
2.35.1

