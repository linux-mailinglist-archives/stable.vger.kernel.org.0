Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A258B5F99A1
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiJJHOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiJJHMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:12:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05D121273;
        Mon, 10 Oct 2022 00:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1FBD60AB4;
        Mon, 10 Oct 2022 07:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC2C433C1;
        Mon, 10 Oct 2022 07:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385634;
        bh=qBwQs3ScO9mSEiaUzW1hR+6DZafv70x1M0qGHdT/LRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo4vjLx7ANL3Eg/esM+cwxtk1D4ItxGlJSox/rH4WS89sWCwHPyjXAk2aOkeXUVJx
         pKL8Fcqgnr4EmxUPFgx4j+HKfacmB/vvpfKK7HV+9ZfwotCykyLTG66cknByeWKe9y
         YFmiYxA8EXTRKI3bFRM+STTqmxLUG/xJqFWFWzbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Lei <Jun.Lei@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Cruise Hung <Cruise.Hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 33/48] drm/amd/display: Fix DP MST timeslot issue when fallback happened
Date:   Mon, 10 Oct 2022 09:05:31 +0200
Message-Id: <20221010070334.554937962@linuxfoundation.org>
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

From: Cruise Hung <Cruise.Hung@amd.com>

[ Upstream commit 20c6168b3c8aadef7d2853c925d99eb546bd5e1c ]

[Why]
When USB4 DP link training failed and fell back to lower link rate,
the time slot calculation uses the verified_link_cap.
And the verified_link_cap was not updated to the new one.
It caused the wrong VC payload time-slot was allocated.

[How]
Updated verified_link_cap with the new one from cur_link_settings
after the LT completes successfully.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 0c52506b367d..b4203a812c4b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2857,8 +2857,14 @@ bool perform_link_training_with_retries(
 						skip_video_pattern);
 
 				/* Transmit idle pattern once training successful. */
-				if (status == LINK_TRAINING_SUCCESS && !is_link_bw_low)
+				if (status == LINK_TRAINING_SUCCESS && !is_link_bw_low) {
 					dp_set_hw_test_pattern(link, &pipe_ctx->link_res, DP_TEST_PATTERN_VIDEO_MODE, NULL, 0);
+					/* Update verified link settings to current one
+					 * Because DPIA LT might fallback to lower link setting.
+					 */
+					link->verified_link_cap.link_rate = link->cur_link_settings.link_rate;
+					link->verified_link_cap.lane_count = link->cur_link_settings.lane_count;
+				}
 			} else {
 				status = dc_link_dp_perform_link_training(link,
 						&pipe_ctx->link_res,
-- 
2.35.1



