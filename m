Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A85F9981
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiJJHNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiJJHLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6C5A166;
        Mon, 10 Oct 2022 00:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF5DB80E5E;
        Mon, 10 Oct 2022 07:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA5BC433C1;
        Mon, 10 Oct 2022 07:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385623;
        bh=lPKcDtfBkw81BZ1ZRxlUP0s5ImWOvfOBFzo7y33aLBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yxa01gzVeyBP68nAmom9KKqE/sxRWZ1MoAsJNtWNB9kKz0q6TIdOoVeeb1uqgkGLN
         1sWTZ6phLfgCfibBgynTSEBJRoaR55wces7Mz6rcnA1bKlFg6V8l52UMNDU+SRBA70
         Dus68Bf+Jw3GHFlO99WyxivjIFMdEhkoLIK+5LWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, George Shen <George.Shen@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Michael Strauss <michael.strauss@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 30/48] drm/amd/display: Assume an LTTPR is always present on fixed_vs links
Date:   Mon, 10 Oct 2022 09:05:28 +0200
Message-Id: <20221010070334.481514127@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



