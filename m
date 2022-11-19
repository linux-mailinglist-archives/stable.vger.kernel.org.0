Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3373E6309B0
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiKSCQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiKSCPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:15:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156046DFD5;
        Fri, 18 Nov 2022 18:12:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8528FB82676;
        Sat, 19 Nov 2022 02:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06514C433C1;
        Sat, 19 Nov 2022 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823974;
        bh=6/ZcM18fIGlzYOv/MUHM9W2R6Q5LbIMHQh70HdVGb9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSPddijIcbn7Qz+Y2F8tWf8NAMdRzx20mXzDg3v2nn86/MgtAOvTlP9SUsdM4mZoj
         +RbmpulQ4vRNA4kdOofMLLau0sT6B/yD1mNtmyPDxsoQZUy5AR5U/RwGtD34YFmurA
         AA/VoW2qXGgkTGU7IodT7GsTt5uRuVJsGJRcUw+pUTksp2NhtlL/sqCS52YyJw+O4f
         IgNRFanKJh1fQ7/LWyvWxgL5wcB5E2rjGJjAX7zwajyYc787ITcjXjRxYByN+H3DeH
         6BMXOYh5oAHsiAzhSknj2HLzTlaPcAWW+NGK/UMA2jbCZem7hWsYajrMAZwksGlYFW
         VgyXH+1bJv0NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Dhere <chaitanya.dhere@amd.com>,
        Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, nathan@kernel.org, yang.lee@linux.alibaba.com,
        jun.lei@amd.com, george.shen@amd.com, aurabindo.pillai@amd.com,
        chris.park@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 35/44] drm/amd/display: Fix FCLK deviation and tool compile issues
Date:   Fri, 18 Nov 2022 21:11:15 -0500
Message-Id: <20221119021124.1773699-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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
index 365d290bba99..d0f3f2414fb8 100644
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

