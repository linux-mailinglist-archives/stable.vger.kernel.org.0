Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23F62508E
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiKKCgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiKKCg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B526AED5;
        Thu, 10 Nov 2022 18:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BCF6199B;
        Fri, 11 Nov 2022 02:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3205C433C1;
        Fri, 11 Nov 2022 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134101;
        bh=Mw8TLCt2WFyOkNt3qgLi05EIYzHnLchcXcQJD7OwzqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itPxOAXU4NbnM2wr2F3/ZL9nZFImzNlmtbyfzgC7Bwx4t2Q0Ff/G2jm8r+SLoTSaz
         etgVeUmiwRzTJSR0iR3y69s7adSq2Bb/8u9nlwBUqO1m820hC/pkG6x+LeYkFoOiWr
         rOHffH/mb7LOUNE4ugZdbUpXLrHb4cdmDmHf2N0rihkHErM2Z0hKh38veHv+w/72v4
         QpikPr1qkSqfwZ6cHj+I4/K+1X9zu23bzIlChQJ1d3CXtZqUtfGOMJ5DpPG9E34wRp
         vvrIfIOk5S8DOtJOn78ZBs+USmG6hrBvWviKxH8pS3dnz6A43eqEnJeD0XmI+iHoWO
         +HocU3hDuP74Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Chaitanya Dhere <Chaitanya.Dhere@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, nathan@kernel.org,
        Alvin.Lee2@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 25/30] drm/amd/display: Investigate tool reported FCLK P-state deviations
Date:   Thu, 10 Nov 2022 21:33:33 -0500
Message-Id: <20221111023340.227279-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
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

From: Nevenko Stupar <Nevenko.Stupar@amd.com>

[ Upstream commit 7461016c5706eb8c477752bf69e5c9f5a38f502b ]

[Why]
Fix for some of the tool reported modes for FCLK
P-state deviations and UCLK P-state deviations that
are coming from DSC terms and/or Scaling terms
causing MinActiveFCLKChangeLatencySupported
and MaxActiveDRAMClockChangeLatencySupported
incorrectly calculated in DML for these configurations.

Reviewed-by: Chaitanya Dhere <Chaitanya.Dhere@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 6704465fe5b6..ea80874474e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -364,7 +364,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 	for (k = 0; k < mode_lib->vba.NumberOfActiveSurfaces; ++k) {
 		v->DSCDelay[k] = dml32_DSCDelayRequirement(mode_lib->vba.DSCEnabled[k],
 				mode_lib->vba.ODMCombineEnabled[k], mode_lib->vba.DSCInputBitPerComponent[k],
-				mode_lib->vba.OutputBpp[k], mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
+				mode_lib->vba.OutputBppPerState[mode_lib->vba.VoltageLevel][k],
+				mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
 				mode_lib->vba.NumberOfDSCSlices[k], mode_lib->vba.OutputFormat[k],
 				mode_lib->vba.Output[k], mode_lib->vba.PixelClock[k],
 				mode_lib->vba.PixelClockBackEnd[k]);
-- 
2.35.1

