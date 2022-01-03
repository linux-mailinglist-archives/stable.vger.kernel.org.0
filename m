Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E487848339F
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiACOkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiACOiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:38:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5439AC08EAF9;
        Mon,  3 Jan 2022 06:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C37DEB80EBB;
        Mon,  3 Jan 2022 14:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896B3C36AEB;
        Mon,  3 Jan 2022 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220448;
        bh=Ghqy2Eixp7F2g7xL8K1/BKVDRlbOx8SdC2OYkcuRgwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuYtA7s0Z7MBmIGkZVdaU7Zdm5bmDb4peyVCdm2UIBMAteqMdtqD3bXLgMTjfYldE
         p9kHWpEIDdmtOyzVwOvQdJ+E8nVH5MYv4b9Ohn94QTMccvRST09SxURbrmQs1xrqcZ
         NLbTgYEJHvCbNDPazu2PyhmpQvO+V3iF1IALmCZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/73] drm/amd/display: Send s0i2_rdy in stream_count == 0 optimization
Date:   Mon,  3 Jan 2022 15:24:00 +0100
Message-Id: <20220103142058.166986224@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit a07f8b9983543d465b50870ab4f845d4d710ed3f ]

[Why]
Otherwise SMU won't mark Display as idle when trying to perform s2idle.

[How]
Mark the bit in the dcn31 codepath, doesn't apply to older ASIC.

It needed to be split from phy refclk off to prevent entering s2idle
when PSR was engaged but driver was not ready.

Fixes: 118a33151658 ("drm/amd/display: Add DCN3.1 clock manager support")

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
index 377c4e53a2b37..407e19412a949 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -157,6 +157,7 @@ static void dcn31_update_clocks(struct clk_mgr *clk_mgr_base,
 				union display_idle_optimization_u idle_info = { 0 };
 				idle_info.idle_info.df_request_disabled = 1;
 				idle_info.idle_info.phy_ref_clk_off = 1;
+				idle_info.idle_info.s0i2_rdy = 1;
 				dcn31_smu_set_display_idle_optimization(clk_mgr, idle_info.data);
 				/* update power state */
 				clk_mgr_base->clks.pwr_state = DCN_PWR_STATE_LOW_POWER;
-- 
2.34.1



