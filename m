Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5221CA770
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393051AbfJCQx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406443AbfJCQx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0BC2054F;
        Thu,  3 Oct 2019 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121636;
        bh=wUWc9RLD1V6Lhh3kGLLd9MEEK7g7Idjqgx2h8Gpux1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JePEnEOJB4gi2Zf9bK8QxAqp1BiA8O0eAT2TdNtJj5K8pxXYykXCeqiZ+i3vUB7c+
         W3P9SrsfWjV9Ahdk+7Cc8ESlpBBDda6orjmp0L0WioXfVTIw8QvhxtTdgKf77bbu4c
         XVjGCDjpU309OhUvl5pegmuFTXC1Ru5zhaEUm4Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Roman Li <Roman.Li@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 339/344] drm/amd/display: Add missing HBM support and raise Vega20s uclk.
Date:   Thu,  3 Oct 2019 17:55:04 +0200
Message-Id: <20191003154611.953015208@linuxfoundation.org>
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

From: Zhan Liu <zhan.liu@amd.com>

commit c02d6a161395dfc0c2fdabb9e976a229017288d8 upstream.

[Why]
When more than 2 displays are connected to the graphics card,
only the minimum memory clock is needed. However, when more
displays are connected, the minimum memory clock is not
sufficient enough to support the overwhelming bandwidth.
System will hang under this circumstance.

Also, the old code didn't address HBM cards, which has 2
pseudo channels. We need to add the HBM part here.

[How]
When graphics card connects to 2 or more displays,
switch to high memory clock. Also, choose memory
multiplier based on whether its regular DRAM or HBM.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   18 ++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -174,6 +174,10 @@ void dce11_pplib_apply_display_requireme
 	struct dc_state *context)
 {
 	struct dm_pp_display_configuration *pp_display_cfg = &context->pp_display_cfg;
+	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
+
+	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	pp_display_cfg->all_displays_in_sync =
 		context->bw_ctx.bw.dce.all_displays_in_sync;
@@ -186,8 +190,18 @@ void dce11_pplib_apply_display_requireme
 	pp_display_cfg->cpu_pstate_separation_time =
 			context->bw_ctx.bw.dce.blackout_recovery_time_us;
 
-	pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
-		/ MEMORY_TYPE_MULTIPLIER_CZ;
+	/*
+	 * TODO: determine whether the bandwidth has reached memory's limitation
+	 * , then change minimum memory clock based on real-time bandwidth
+	 * limitation.
+	 */
+	if (ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
+		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
+			(uint32_t) (dc->bw_vbios->high_yclk.value / memory_type_multiplier / 10000));
+	} else {
+		pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
+			/ memory_type_multiplier;
+	}
 
 	pp_display_cfg->min_engine_clock_khz = determine_sclk_from_bounding_box(
 			dc,


