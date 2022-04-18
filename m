Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35150510D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbiDRMa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiDRM3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB75C23174;
        Mon, 18 Apr 2022 05:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DCC7B80ED6;
        Mon, 18 Apr 2022 12:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCEFC385A8;
        Mon, 18 Apr 2022 12:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284591;
        bh=Baju3h8I6ftmB2znulzDklc3kpii9XeoY0YmYHSSxk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZliK3l4liWjTMUNNASSTvbfOAaFf0G90TduOGXVoUTzNMnXbrxS2Tr+5LWI6d94e
         FjljkXXMl2hu9An1U1EihWH0jDOVG1yKQIa5Zh3bSoGiwmnMM4eE55s3ja+0pHm1qb
         gKMAz2QmAF8dV+r/rUzySepB90eb1mlHG7VUnHOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>, Alex Hung <alex.hung@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 163/219] drm/amd/display: Enable power gating before init_pipes
Date:   Mon, 18 Apr 2022 14:12:12 +0200
Message-Id: <20220418121211.446404520@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 58e16c752e9540b28a873c44c3bee83e022007c1 ]

[Why]
In init_hw() we call init_pipes() before enabling power gating.
init_pipes() tries to power gate dsc but it may fail because
required force-ons are not released yet.
As a result with dsc config the following errors observed on resume:
"REG_WAIT timeout 1us * 1000 tries - dcn20_dsc_pg_control"
"REG_WAIT timeout 1us * 1000 tries - dcn20_dpp_pg_control"
"REG_WAIT timeout 1us * 1000 tries - dcn20_hubp_pg_control"

[How]
Move enable_power_gating_plane() before init_pipes() in init_hw()

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c        | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c        | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index a6703d17fcb6..c6a0daa56fa0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1501,6 +1501,9 @@ void dcn10_init_hw(struct dc *dc)
 	if (dc->config.power_down_display_on_boot)
 		dc_link_blank_all_dp_displays(dc);
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -1553,8 +1556,6 @@ void dcn10_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 1db1ca19411d..05dc0a3ae2a3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -548,6 +548,9 @@ void dcn30_init_hw(struct dc *dc)
 	if (dc->config.power_down_display_on_boot)
 		dc_link_blank_all_dp_displays(dc);
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -625,8 +628,6 @@ void dcn30_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 1e156f398065..bdc4467b40d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -200,6 +200,9 @@ void dcn31_init_hw(struct dc *dc)
 	if (dc->config.power_down_display_on_boot)
 		dc_link_blank_all_dp_displays(dc);
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -249,8 +252,6 @@ void dcn31_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
-- 
2.35.1



