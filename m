Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5CB4FD53A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbiDLHqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357023AbiDLHjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD329C90;
        Tue, 12 Apr 2022 00:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC97B81A8F;
        Tue, 12 Apr 2022 07:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F17C385A1;
        Tue, 12 Apr 2022 07:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747446;
        bh=DNsSy1b0PI3PmwLmgzdEV6RJCPflO8LhpqM5IpcKNIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irLhlekZtN29YMhS1KqPT4m7C3BTv9fELq+gzr/rTqtDgLtsPsc/uoviAG+G31f7K
         TssRj/inGdNpLR4dVtLpxsX2LLjCMTcmKcMZzOiAlYqmmVEaEfXOmGDn5xJW446I8W
         UKx0HIPYL6PB0W+1n3md4Th2WyG1LJ3c8fD32xgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Meenakshikumar Somasundaram <Meenakshikumar.Somasundaram@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Jasdeep Dhillon <jdhillon@amd.com>,
        Sung Joon Kim <sungkim@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 082/343] drm/amd/display: reset lane settings after each PHY repeater LT
Date:   Tue, 12 Apr 2022 08:28:20 +0200
Message-Id: <20220412062953.467774112@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 61b8f29a0c30..49d5271dcfdc 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2378,22 +2378,27 @@ static enum link_training_result dp_perform_8b_10b_link_training(
 				repeater_id--) {
 			status = perform_clock_recovery_sequence(link, link_res, lt_settings, repeater_id);
 
-			if (status != LINK_TRAINING_SUCCESS)
+			if (status != LINK_TRAINING_SUCCESS) {
+				repeater_training_done(link, repeater_id);
 				break;
+			}
 
 			status = perform_channel_equalization_sequence(link,
 					link_res,
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
2.35.1



