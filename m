Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9840E003
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhIPQQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240622AbhIPQOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E34613A1;
        Thu, 16 Sep 2021 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808614;
        bh=GDHq+i1T9MXWFzZU0DWjRGNi+dlsg4XppN021cgzqSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtWxp0hwN3ZfaAnulUmXpnJEZV8fsOYvF+nyoKSBqplEY9gTEdjGg6rmxwBf6CaCm
         5GEUOzb/A+G9+Z39HrNcQcez1f1WM9QT0gNiI9CguTB8m+I6+s001UlQt5+dsg7GAd
         F9WiT7vDH1EaXTGls2BOHKavNTSzd5CLGekSCuEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Oliver Logush <oliver.logush@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/306] drm/amd/display: Fix timer_per_pixel unit error
Date:   Thu, 16 Sep 2021 17:58:06 +0200
Message-Id: <20210916155758.855246092@linuxfoundation.org>
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



