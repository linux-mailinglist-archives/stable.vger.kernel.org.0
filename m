Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD695F2661
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJBWwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJBWvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E430039BA1;
        Sun,  2 Oct 2022 15:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89FC560F19;
        Sun,  2 Oct 2022 22:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF559C433B5;
        Sun,  2 Oct 2022 22:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751030;
        bh=lPKcDtfBkw81BZ1ZRxlUP0s5ImWOvfOBFzo7y33aLBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAKM8luaq3ivdRSTm8NhKTBeYtBaf+FrwaDWP4e3VGdjotM9NVRewR2aqV62vzNi8
         kLkyleTAdnzrKFcUT4yRin9U2WxppVooH3pjQeYrlbCeH63Gz8mUd+024TA4uspYD6
         wCny7sprtCAZbIY3hKD9dcr6jgYovdl2DNkVpcDektZKYeu5/kWb8rKwGF0EuZ1DYO
         zoVo3l9+SaGiX1JHmG1DQSb0u4vwYHDqBKVB+4/dR4tfoECVC8U+hC6j/xvPIBXv4B
         C9ZDo1kizV6tZmtgMNrFMKr082nxuImdtOeOvJGIE8bhQAhLJkeJy49J+gqxKwNNUO
         9LomXQ8GBcLGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Strauss <michael.strauss@amd.com>,
        George Shen <George.Shen@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, wenjing.liu@amd.com, george.shen@amd.com,
        Jun.Lei@amd.com, Jimmy.Kizito@amd.com, mikita.lipski@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 24/29] drm/amd/display: Assume an LTTPR is always present on fixed_vs links
Date:   Sun,  2 Oct 2022 18:49:17 -0400
Message-Id: <20221002224922.238837-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 29956d0fded036a570bd8e7d4ea4b1a1730307d2 ]

[WHY]
LTTPRs can in very rare instsances fail to increment DPCD LTTPR count.
This results in aux-i LTTPR requests to be sent to the wrong DPCD
address, which causes link training failure.

[HOW]
Override internal repeater count if fixed_vs flag is set for a given link

Reviewed-by: George Shen <George.Shen@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index a4fc9a6c850e..0c52506b367d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -5211,6 +5211,14 @@ bool dp_retrieve_lttpr_cap(struct dc_link *link)
 				lttpr_dpcd_data[DP_PHY_REPEATER_128B132B_RATES -
 								DP_LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV];
 
+		/* If this chip cap is set, at least one retimer must exist in the chain
+		 * Override count to 1 if we receive a known bad count (0 or an invalid value) */
+		if (link->chip_caps & EXT_DISPLAY_PATH_CAPS__DP_FIXED_VS_EN &&
+				(dp_convert_to_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt) == 0)) {
+			ASSERT(0);
+			link->dpcd_caps.lttpr_caps.phy_repeater_cnt = 0x80;
+		}
+
 		/* Attempt to train in LTTPR transparent mode if repeater count exceeds 8. */
 		is_lttpr_present = (link->dpcd_caps.lttpr_caps.max_lane_count > 0 &&
 				link->dpcd_caps.lttpr_caps.max_lane_count <= 4 &&
-- 
2.35.1

