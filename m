Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE18D6A3795
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjB0CKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjB0CKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:10:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201AF17CDB;
        Sun, 26 Feb 2023 18:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15657B80D0D;
        Mon, 27 Feb 2023 02:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5663DC433EF;
        Mon, 27 Feb 2023 02:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463739;
        bh=Dv42nZBeQIxGpp6TCs3+Rp7mbtqYQkNzOek0Ww1+Jlc=;
        h=From:To:Cc:Subject:Date:From;
        b=fsKD5/RPQrtGSaewsjY6OO96q0iOVw7ygirLWNcmBarIX/gkisOaJkZ4ghBDbmYYf
         aFZGlDtiKiGZGYmTa2iiSocpPsdvpcWCq1jGi8ClveZms/oPBb7rCJWswUBHrHTPTx
         MRK+UwsZ4h6+FKnsZ515RbP6l5ImGIk6W2BpZxn5qbVY2G449winRu0VKJ+sFDHUrB
         dd33C3S25LEqUbBIrrtp5kBL2WNX5OGnhAY/ppv1ou24q+cxk9CtBdjQPCtpfe4Rb2
         zuG1K0dBNUc68/jxKQJhzO5LOPNVSD7/IV8yhm110MkSK5suNH23Uxglr5h9zdYoe6
         U0otRiJA7S6YA==
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
        Evgenii.Krasnikov@amd.com, Iswara.Nagulendran@amd.com,
        Jimmy.Kizito@amd.com, michael.strauss@amd.com, Anthony.Koo@amd.com,
        sungkim@amd.com, arnd@arndb.de, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/25] drm/amd/display: Revert Reduce delay when sink device not able to ACK 00340h write
Date:   Sun, 26 Feb 2023 21:08:24 -0500
Message-Id: <20230227020855.1051605-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
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
index 3c4205248efc2..b727bd7e039d7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1665,12 +1665,6 @@ struct dc_link *link_create(const struct link_init_data *init_params)
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
index a6ff1b17fd22a..6777adb66f9d7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4841,18 +4841,10 @@ void dpcd_set_source_specific_data(struct dc_link *link)
 
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
index 4f54bde1bb1c7..1948cd9427d7e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -109,7 +109,6 @@ struct dc_link_settings {
 	enum dc_link_spread link_spread;
 	bool use_link_rate_set;
 	uint8_t link_rate_set;
-	bool dpcd_source_device_specific_field_support;
 };
 
 struct dc_lane_settings {
-- 
2.39.0

