Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD8B8443
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393526AbfISWJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405401AbfISWJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4342196F;
        Thu, 19 Sep 2019 22:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930961;
        bh=xBkj8GB32KkFsE/GwKypiAlolOQzVn5JCvq+Tp/7DnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVwW1cHjyyyXqYZyR0dvg8lOWOlauj/5Lh88cstGT+j9gfYJdCzve6xsS+QPfoEqx
         WiJMY7z0VkxLjfSPFoop39LUgiGZcYpw7Y9aK43cJtwGLL/zYnQFChqSjieiYMprTj
         /wBwuO/9bql1bWRC52c9MHH2COM7ipLqVbP0NKeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 078/124] drm/amd/powerplay: correct Vega20 dpm level related settings
Date:   Fri, 20 Sep 2019 00:02:46 +0200
Message-Id: <20190919214821.847203825@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



