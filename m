Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A245D4050EB
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351978AbhIIMcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350459AbhIIM1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38FED61B03;
        Thu,  9 Sep 2021 11:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188319;
        bh=GDHq+i1T9MXWFzZU0DWjRGNi+dlsg4XppN021cgzqSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNODeWy0D194ClXJfmxriv0ectgjXxRqlTA88RVTGI6vqbwDDA4Sa0iSvpJqpFtKu
         tGGAzKYuL9bN9OYbRSQ1GDZkN+Cl3/yXCHOiETvDAIAqRdhLMiZyUX8fGpYyBYylVv
         MD+fpPD3inwyx8H+5zQKwSw6oFkfWkDHRAtjxoBPCoNmiVRUY3OHhlbmATmOM18DfD
         gR83+exfLC/RIkfzn3dEqTm/UOw4zNQsdm7sprfuTPZVxL3Sb/9GuLb5+4KYuAourx
         yBVZU844+O40p7XW9qlIP70L75VMTxFtP+gRtSujBVWcTIWQucwclcUa1zxOp/g0LT
         JA50VSlijng7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Logush <oliver.logush@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 032/176] drm/amd/display: Fix timer_per_pixel unit error
Date:   Thu,  9 Sep 2021 07:48:54 -0400
Message-Id: <20210909115118.146181-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Logush <oliver.logush@amd.com>

[ Upstream commit 23e55639b87fb16a9f0f66032ecb57060df6c46c ]

[why]
The units of the time_per_pixel variable were incorrect, this had to be
changed for the code to properly function.

[how]
The change was very straightforward, only required one line of code to
be changed where the calculation was done.

Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Oliver Logush <oliver.logush@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index cfe85ba1018e..5dbc290bcbe8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2455,7 +2455,7 @@ void dcn20_set_mcif_arb_params(
 				wb_arb_params->cli_watermark[k] = get_wm_writeback_urgent(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 				wb_arb_params->pstate_watermark[k] = get_wm_writeback_dram_clock_change(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 			}
-			wb_arb_params->time_per_pixel = 16.0 / context->res_ctx.pipe_ctx[i].stream->phy_pix_clk; /* 4 bit fraction, ms */
+			wb_arb_params->time_per_pixel = 16.0 * 1000 / (context->res_ctx.pipe_ctx[i].stream->phy_pix_clk / 1000); /* 4 bit fraction, ms */
 			wb_arb_params->slice_lines = 32;
 			wb_arb_params->arbitration_slice = 2;
 			wb_arb_params->max_scaled_time = dcn20_calc_max_scaled_time(wb_arb_params->time_per_pixel,
-- 
2.30.2

