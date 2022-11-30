Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3B563DF28
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiK3Soj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiK3SoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3253599F23
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBAD0B81CAB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBDDC433C1;
        Wed, 30 Nov 2022 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833843;
        bh=UuJVd50U7DKZemqUL0pDyfxboKHFDPxvTZzcZeq8Sio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmjOk08rWD4KHzgNE8zr7oao8vVSIv9BDuXleP+nzcfNsVRMpUC24XIZKFpim5jkr
         Ou2ZVDOgi7DZSYE8slOKF7HCz1FTI2ICxxY8opkA0LKiOgtnHM031bTJ/oaYYSlv6C
         JrE+vhmITOsFG/VhhblRE5XH21gsb4VMPhzHBMkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Alan Liu <HaoPing.Liu@amd.com>,
        Chaitanya Dhere <chaitanya.dhere@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/289] drm/amd/display: Fix FCLK deviation and tool compile issues
Date:   Wed, 30 Nov 2022 19:20:20 +0100
Message-Id: <20221130180544.928797658@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Chaitanya Dhere <chaitanya.dhere@amd.com>

[ Upstream commit 0d5c5c210a4d4e655feb93b379647f0b179cdafe ]

[Why]
Recent backports from open source do not have header inclusion pattern
that is consistent with inclusion style in the rest of the file. This
breaks the internal tool builds as well. A recent commit erronously
modified the original DML formula for calculating
ActiveClockChangeLatencyHidingY. This resulted in a FCLK deviation
from the golden values.

[How]
Change the way in which display_mode_vba.h is included so that it is
consistent with the inclusion style in rest of the file which also fixes
the tool build. Restore the DML formula to its original state to fix the
FCLK deviation.

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c | 2 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index 67af8f4df8b8..d9141ef2fefd 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -4396,7 +4396,7 @@ void dml32_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport(
 
 		if (v->NumberOfActiveSurfaces > 1) {
 			ActiveClockChangeLatencyHidingY = ActiveClockChangeLatencyHidingY
-					- (1 - 1 / v->NumberOfActiveSurfaces) * SwathHeightY[k] * v->HTotal[k]
+					- (1.0 - 1.0 / v->NumberOfActiveSurfaces) * SwathHeightY[k] * v->HTotal[k]
 							/ v->PixelClock[k] / v->VRatio[k];
 		}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
index 0b427d89b3c5..f174f5c5ff92 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h
@@ -30,7 +30,7 @@
 #include "os_types.h"
 #include "../dc_features.h"
 #include "../display_mode_structs.h"
-#include "dml/display_mode_vba.h"
+#include "../display_mode_vba.h"
 
 unsigned int dml32_dscceComputeDelay(
 		unsigned int bpc,
-- 
2.35.1



