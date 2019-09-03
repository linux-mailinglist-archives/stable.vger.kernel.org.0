Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C639AA7038
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfICQ0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730531AbfICQ0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E66C23711;
        Tue,  3 Sep 2019 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527962;
        bh=8DzK93u3leP8+ss5457ROWWffQZJNtZmAWFrX94wVjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMVAf5e1G+vk8fwfvzPqf+cM3h1knhL/v13Wv9hd/H7dyMK+vFEOGr1V4cTphCwy2
         4B2+aQjkU82Rhh+ltCt2rSfOkIjW/4v5N7mRTEh8poos89KP17QQlj2yF2HmYXKHKH
         C/qITbkwYFhVtI9cCb1qFSGdMDwFK6uSnqneiiTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rex Zhu <Rex.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 023/167] drm/amd/pp: Fix truncated clock value when set watermark
Date:   Tue,  3 Sep 2019 12:22:55 -0400
Message-Id: <20190903162519.7136-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rex Zhu <Rex.Zhu@amd.com>

[ Upstream commit 4d454e9ffdb1ef5a51ebc147b5389c96048db683 ]

the clk value should be tranferred to MHz first and
then transfer to uint16. otherwise, the clock value
will be truncated.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Rex Zhu <Rex.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/powerplay/hwmgr/smu_helper.c  | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
index a321c465b7dce..cede78cdf28db 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -669,20 +669,20 @@ int smu_set_watermarks_for_clocks_ranges(void *wt_table,
 	for (i = 0; i < wm_with_clock_ranges->num_wm_dmif_sets; i++) {
 		table->WatermarkRow[1][i].MinClock =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_dcfclk_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_dcfclk_clk_in_khz /
+			1000));
 		table->WatermarkRow[1][i].MaxClock =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_dcfclk_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_dcfclk_clk_in_khz /
+			1000));
 		table->WatermarkRow[1][i].MinUclk =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_mem_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_mem_clk_in_khz /
+			1000));
 		table->WatermarkRow[1][i].MaxUclk =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_mem_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_mem_clk_in_khz /
+			1000));
 		table->WatermarkRow[1][i].WmSetting = (uint8_t)
 				wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_set_id;
 	}
@@ -690,20 +690,20 @@ int smu_set_watermarks_for_clocks_ranges(void *wt_table,
 	for (i = 0; i < wm_with_clock_ranges->num_wm_mcif_sets; i++) {
 		table->WatermarkRow[0][i].MinClock =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_min_socclk_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_min_socclk_clk_in_khz /
+			1000));
 		table->WatermarkRow[0][i].MaxClock =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_max_socclk_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_max_socclk_clk_in_khz /
+			1000));
 		table->WatermarkRow[0][i].MinUclk =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_min_mem_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_min_mem_clk_in_khz /
+			1000));
 		table->WatermarkRow[0][i].MaxUclk =
 			cpu_to_le16((uint16_t)
-			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_max_mem_clk_in_khz) /
-			1000);
+			(wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_max_mem_clk_in_khz /
+			1000));
 		table->WatermarkRow[0][i].WmSetting = (uint8_t)
 				wm_with_clock_ranges->wm_mcif_clocks_ranges[i].wm_set_id;
 	}
-- 
2.20.1

