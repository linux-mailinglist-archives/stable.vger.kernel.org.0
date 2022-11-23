Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572AF63579B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbiKWJoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbiKWJoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B570374ABC
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6609CB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC86C433D6;
        Wed, 23 Nov 2022 09:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196528;
        bh=Mw8TLCt2WFyOkNt3qgLi05EIYzHnLchcXcQJD7OwzqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiz8BQrrD+Mtr5s5z7aV2zupCsBg/1Wc33VpoGu5BxS+l3+MWOb+BPdRN4Yu+rkXT
         Mvibjns6OnUaKHGQZMxa4lMoHIFlA765TaOgsWxr/u0OO3il7JZyJQ99kiRf4FBKk2
         +/qcGAaEIdJ3J/wUXqLn6Uc9rqE8c8FLYq+ZGRIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chaitanya Dhere <Chaitanya.Dhere@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 056/314] drm/amd/display: Investigate tool reported FCLK P-state deviations
Date:   Wed, 23 Nov 2022 09:48:21 +0100
Message-Id: <20221123084628.038013005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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



