Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383576A3701
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjB0CGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjB0CFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:05:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8687A1515F;
        Sun, 26 Feb 2023 18:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5857F60CA3;
        Mon, 27 Feb 2023 02:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB4C433EF;
        Mon, 27 Feb 2023 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463518;
        bh=0YbTeatYVoRy6wBiD7V7YnTmgobF/jqXCme7BFEi39c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6uEn3IADBEF6bhG86ox0fcevn9kX2S1Ld2XpAjdVxwds/cfFAVAjymj0aM7MuHc4
         lB5XMjQsAovVqcoq7FpumjsGCszl4+wTe7tgcDc5DjuaNE/al6JfLsgsojiisq7mCn
         qj2lhMyAbgsX9yudBEzDoyuwJGhkpYrpTdOUoQjeQHoxOFoxCYZT4p47VkwMUdVNBR
         qUQJubJloc2Le5G7ROT7IzYhXKFg1t5xT7cwsHfCD4CYujRAb40WGmm4KhGk2COWnD
         Maid1a7cF1jWjzSOW+UhDH09RWrZPZPiaRaAyPp3NzIcuL+tlV25SHNvFTKQDisjlI
         BgDw6JPcYxalQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Chen <ian.chen@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, wenjing.liu@amd.com, HaoPing.Liu@amd.com,
        George.Shen@amd.com, dingchen.zhang@amd.com,
        Iswara.Nagulendran@amd.com, Evgenii.Krasnikov@amd.com,
        michael.strauss@amd.com, Jimmy.Kizito@amd.com,
        qingqing.zhuo@amd.com, arnd@arndb.de, sungkim@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 04/58] drm/amd/display: Revert Reduce delay when sink device not able to ACK 00340h write
Date:   Sun, 26 Feb 2023 21:04:02 -0500
Message-Id: <20230227020457.1048737-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Chen <ian.chen@amd.com>

[ Upstream commit 639f6ad6df7f47db48b59956b469a6917a136afb ]

[WHY]
It causes regression AMD source will not write DPCD 340.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Ian Chen <ian.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c    |  6 ------
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 14 +++-----------
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h     |  1 -
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 40b9d2ce08e66..328c5e33cc66b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1916,12 +1916,6 @@ struct dc_link *link_create(const struct link_init_data *init_params)
 	if (false == dc_link_construct(link, init_params))
 		goto construct_fail;
 
-	/*
-	 * Must use preferred_link_setting, not reported_link_cap or verified_link_cap,
-	 * since struct preferred_link_setting won't be reset after S3.
-	 */
-	link->preferred_link_setting.dpcd_source_device_specific_field_support = true;
-
 	return link;
 
 construct_fail:
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 1254d38f1778a..24f1aba4ae133 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -6591,18 +6591,10 @@ void dpcd_set_source_specific_data(struct dc_link *link)
 
 			uint8_t hblank_size = (uint8_t)link->dc->caps.min_horizontal_blanking_period;
 
-			if (link->preferred_link_setting.dpcd_source_device_specific_field_support) {
-				result_write_min_hblank = core_link_write_dpcd(link,
-					DP_SOURCE_MINIMUM_HBLANK_SUPPORTED, (uint8_t *)(&hblank_size),
-					sizeof(hblank_size));
-
-				if (result_write_min_hblank == DC_ERROR_UNEXPECTED)
-					link->preferred_link_setting.dpcd_source_device_specific_field_support = false;
-			} else {
-				DC_LOG_DC("Sink device does not support 00340h DPCD write. Skipping on purpose.\n");
-			}
+			result_write_min_hblank = core_link_write_dpcd(link,
+				DP_SOURCE_MINIMUM_HBLANK_SUPPORTED, (uint8_t *)(&hblank_size),
+				sizeof(hblank_size));
 		}
-
 		DC_TRACE_LEVEL_MESSAGE(DAL_TRACE_LEVEL_INFORMATION,
 							WPP_BIT_FLAG_DC_DETECTION_DP_CAPS,
 							"result=%u link_index=%u enum dce_version=%d DPCD=0x%04X min_hblank=%u branch_dev_id=0x%x branch_dev_name='%c%c%c%c%c%c'",
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 2c54b6e0498bf..296793d8b2bf2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -149,7 +149,6 @@ struct dc_link_settings {
 	enum dc_link_spread link_spread;
 	bool use_link_rate_set;
 	uint8_t link_rate_set;
-	bool dpcd_source_device_specific_field_support;
 };
 
 union dc_dp_ffe_preset {
-- 
2.39.0

