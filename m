Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA08A8A60
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbfIDP7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731561AbfIDP7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F100022CF7;
        Wed,  4 Sep 2019 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612748;
        bh=xBkj8GB32KkFsE/GwKypiAlolOQzVn5JCvq+Tp/7DnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAdm5a6gqBhTq+AISgdaV8id3kx9FHJp/6BS1VAwqNgqfei/UPpCxd35zXL5sIqXU
         meYzuy2LunOZi9bVM+W8yn9aLF0cLoboGg96Ru2HMoQybx5BZrpVhUDxyzF8nb+IRn
         oilenJoQQL65QIWIh1rZGNmK3/k6cJinK0bssdpo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 58/94] drm/amd/powerplay: correct Vega20 dpm level related settings
Date:   Wed,  4 Sep 2019 11:57:03 -0400
Message-Id: <20190904155739.2816-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 83e09d5bddbee749fc83063890244397896a1971 ]

Correct the settings for auto mode and skip the unnecessary
settings for dcefclk and fclk.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/powerplay/hwmgr/vega20_hwmgr.c    | 60 +++++++++++++++++--
 1 file changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
index 9b9f87b84910c..d98fe481cd365 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c
@@ -2288,12 +2288,16 @@ static int vega20_force_dpm_highest(struct pp_hwmgr *hwmgr)
 		data->dpm_table.soc_table.dpm_state.soft_max_level =
 		data->dpm_table.soc_table.dpm_levels[soft_level].value;
 
-	ret = vega20_upload_dpm_min_level(hwmgr, 0xFFFFFFFF);
+	ret = vega20_upload_dpm_min_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload boot level to highest!",
 			return ret);
 
-	ret = vega20_upload_dpm_max_level(hwmgr, 0xFFFFFFFF);
+	ret = vega20_upload_dpm_max_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload dpm max level to highest!",
 			return ret);
@@ -2326,12 +2330,16 @@ static int vega20_force_dpm_lowest(struct pp_hwmgr *hwmgr)
 		data->dpm_table.soc_table.dpm_state.soft_max_level =
 		data->dpm_table.soc_table.dpm_levels[soft_level].value;
 
-	ret = vega20_upload_dpm_min_level(hwmgr, 0xFFFFFFFF);
+	ret = vega20_upload_dpm_min_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload boot level to highest!",
 			return ret);
 
-	ret = vega20_upload_dpm_max_level(hwmgr, 0xFFFFFFFF);
+	ret = vega20_upload_dpm_max_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload dpm max level to highest!",
 			return ret);
@@ -2342,14 +2350,54 @@ static int vega20_force_dpm_lowest(struct pp_hwmgr *hwmgr)
 
 static int vega20_unforce_dpm_levels(struct pp_hwmgr *hwmgr)
 {
+	struct vega20_hwmgr *data =
+			(struct vega20_hwmgr *)(hwmgr->backend);
+	uint32_t soft_min_level, soft_max_level;
 	int ret = 0;
 
-	ret = vega20_upload_dpm_min_level(hwmgr, 0xFFFFFFFF);
+	/* gfxclk soft min/max settings */
+	soft_min_level =
+		vega20_find_lowest_dpm_level(&(data->dpm_table.gfx_table));
+	soft_max_level =
+		vega20_find_highest_dpm_level(&(data->dpm_table.gfx_table));
+
+	data->dpm_table.gfx_table.dpm_state.soft_min_level =
+		data->dpm_table.gfx_table.dpm_levels[soft_min_level].value;
+	data->dpm_table.gfx_table.dpm_state.soft_max_level =
+		data->dpm_table.gfx_table.dpm_levels[soft_max_level].value;
+
+	/* uclk soft min/max settings */
+	soft_min_level =
+		vega20_find_lowest_dpm_level(&(data->dpm_table.mem_table));
+	soft_max_level =
+		vega20_find_highest_dpm_level(&(data->dpm_table.mem_table));
+
+	data->dpm_table.mem_table.dpm_state.soft_min_level =
+		data->dpm_table.mem_table.dpm_levels[soft_min_level].value;
+	data->dpm_table.mem_table.dpm_state.soft_max_level =
+		data->dpm_table.mem_table.dpm_levels[soft_max_level].value;
+
+	/* socclk soft min/max settings */
+	soft_min_level =
+		vega20_find_lowest_dpm_level(&(data->dpm_table.soc_table));
+	soft_max_level =
+		vega20_find_highest_dpm_level(&(data->dpm_table.soc_table));
+
+	data->dpm_table.soc_table.dpm_state.soft_min_level =
+		data->dpm_table.soc_table.dpm_levels[soft_min_level].value;
+	data->dpm_table.soc_table.dpm_state.soft_max_level =
+		data->dpm_table.soc_table.dpm_levels[soft_max_level].value;
+
+	ret = vega20_upload_dpm_min_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload DPM Bootup Levels!",
 			return ret);
 
-	ret = vega20_upload_dpm_max_level(hwmgr, 0xFFFFFFFF);
+	ret = vega20_upload_dpm_max_level(hwmgr, FEATURE_DPM_GFXCLK_MASK |
+						 FEATURE_DPM_UCLK_MASK |
+						 FEATURE_DPM_SOCCLK_MASK);
 	PP_ASSERT_WITH_CODE(!ret,
 			"Failed to upload DPM Max Levels!",
 			return ret);
-- 
2.20.1

