Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA70CA6E68
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfICQ0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbfICQZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D79723711;
        Tue,  3 Sep 2019 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527958;
        bh=HlB0kFLFJRGc5nkzsNDy3iGdtD6dK1xJYjtH+voD000=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npMS1YpbXaEj9TVharNKA4Q+6JltSwqq7jBZoQSrYfBjLVW6XYCtW0Yg5MeXa0F8g
         PR2YQlI0OQZP98nFYnqVS6+lLp4hmInNQH1wf2cH9Y/GkeYcqmY2LB2DxanQLNtPWx
         93Mb2LaDxtL7E1/haaYkc6tBXOmCZMyh1EGbyWoQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Francis <David.Francis@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 022/167] powerplay: Respect units on max dcfclk watermark
Date:   Tue,  3 Sep 2019 12:22:54 -0400
Message-Id: <20190903162519.7136-22-sashal@kernel.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit f191415b24a3ad3fa22088af7cd7fc328a2f469f ]

In a refactor, the watermark clock inputs to
powerplay from DC were changed from units of 10kHz to
kHz clocks.

One division by 100 was not converted into a division
by 1000.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
index 2aab1b4759459..a321c465b7dce 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -674,7 +674,7 @@ int smu_set_watermarks_for_clocks_ranges(void *wt_table,
 		table->WatermarkRow[1][i].MaxClock =
 			cpu_to_le16((uint16_t)
 			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_max_dcfclk_clk_in_khz) /
-			100);
+			1000);
 		table->WatermarkRow[1][i].MinUclk =
 			cpu_to_le16((uint16_t)
 			(wm_with_clock_ranges->wm_dmif_clocks_ranges[i].wm_min_mem_clk_in_khz) /
-- 
2.20.1

