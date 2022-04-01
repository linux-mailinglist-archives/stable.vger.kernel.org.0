Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281DB4EF450
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346200AbiDAOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352206AbiDAOuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:50:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BFB2B19C6;
        Fri,  1 Apr 2022 07:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E64CB82500;
        Fri,  1 Apr 2022 14:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3897C340EE;
        Fri,  1 Apr 2022 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823720;
        bh=wVy5NP4YCSoyEzZjb6vJTotOF7bMrwyo1S8x1rMxh4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wx/uy+wCWHZIcsR2R8bw+EPTcQ8xLUCg6YZPEWFThS2hs8nwu0V50tQYyKEXXpXli
         3O98M/oRJG8YbuDH0c0DNzgr9HNf2Sw4q765y84PWtM78A2MwpK9rHTusFI1hvuRm2
         q7JbWXDFBNrdrkdlLlN2Z6bFWJ7RIGIGdrraUZclXDWpiSBImkRh40h+2l+klIXyFh
         YD/zNxR9bRvlEowzLpqiPnWVhVlvquWSI/ffDjSXmaWP1ZAfAZ+4axnHvXw4QVxe72
         MuVK8HOVyCmkdGLivfnA7ZZ0Zp5uQaV/N3r3+oX/bea9mkPZ8g/a4K6j0PX5anzHlY
         JNANsALIDj/8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Joon Kim <sungkim@amd.com>,
        Meenakshikumar Somasundaram <Meenakshikumar.Somasundaram@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, wenjing.liu@amd.com, george.shen@amd.com,
        Jimmy.Kizito@amd.com, Wesley.Chalmers@amd.com, Jerry.Zuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 050/109] drm/amd/display: reset lane settings after each PHY repeater LT
Date:   Fri,  1 Apr 2022 10:31:57 -0400
Message-Id: <20220401143256.1950537-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Joon Kim <sungkim@amd.com>

[ Upstream commit 3b853c316c9321e195414a6fb121d1c2d45b1e87 ]

[why]
In LTTPR non-transparent mode, we need
to reset the cached lane settings before performing
link training on the next PHY repeater. Otherwise,
the cached lane settings will be used for the next
clock recovery e.g. VS = MAX (3) which should not be
the case according to the DP specs. We expect to use
minimum lane settings on each clock recovery sequence.

[how]
Reset DPCD and HW lane settings on each repeater LT.
Set training pattern to 0 for the repeater that failed LT
at the proper place.

Reviewed-by: Meenakshikumar Somasundaram <Meenakshikumar.Somasundaram@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Sung Joon Kim <sungkim@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 135ea1c422f2..f46aa7f8c35d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2124,21 +2124,26 @@ static enum link_training_result dp_perform_8b_10b_link_training(
 				repeater_id--) {
 			status = perform_clock_recovery_sequence(link, lt_settings, repeater_id);
 
-			if (status != LINK_TRAINING_SUCCESS)
+			if (status != LINK_TRAINING_SUCCESS) {
+				repeater_training_done(link, repeater_id);
 				break;
+			}
 
 			status = perform_channel_equalization_sequence(link,
 					lt_settings,
 					repeater_id);
 
+			repeater_training_done(link, repeater_id);
+
 			if (status != LINK_TRAINING_SUCCESS)
 				break;
 
-			repeater_training_done(link, repeater_id);
+			for (lane = 0; lane < LANE_COUNT_DP_MAX; lane++) {
+				lt_settings->dpcd_lane_settings[lane].raw = 0;
+				lt_settings->hw_lane_settings[lane].VOLTAGE_SWING = 0;
+				lt_settings->hw_lane_settings[lane].PRE_EMPHASIS = 0;
+			}
 		}
-
-		for (lane = 0; lane < (uint8_t)lt_settings->link_settings.lane_count; lane++)
-			lt_settings->dpcd_lane_settings[lane].raw = 0;
 	}
 
 	if (status == LINK_TRAINING_SUCCESS) {
-- 
2.34.1

