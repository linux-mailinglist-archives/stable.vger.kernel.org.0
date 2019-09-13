Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3325B1ED7
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfIMNNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389306AbfIMNNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:19 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBFEF208C0;
        Fri, 13 Sep 2019 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380398;
        bh=w5RE/Un7t/yESkZsp1fzyJSoUfIn8yUmOCtBYjovge0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7yRjRS9C9708bW+CkCmzD6dLMEtkcgeTwh6SoYp7oA2yQehvsnaXVWLUzcJhDnbH
         XO4Oz6iMLek+PeDHTAbTfxu7flJET1z35DEfZn4EQkvSUVs+Nnr0wioJ8hMd0yHLVB
         ot5SE9izfS7QMvJb2+Q1OhLVhO6fWLauXDvobm6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>, Rex Zhu <Rex.Zhu@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/190] drm/amd/pp: Fix truncated clock value when set watermark
Date:   Fri, 13 Sep 2019 14:05:07 +0100
Message-Id: <20190913130603.941108945@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



