Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F407C58FF96
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiHKPbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiHKPak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:30:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF692956B1;
        Thu, 11 Aug 2022 08:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ED58B82151;
        Thu, 11 Aug 2022 15:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7824CC433C1;
        Thu, 11 Aug 2022 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231794;
        bh=Kcc3+GretIhBYyl20guPmg+/oLg7fqLFLFv/C9EO0YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hs4VMhDiZ19LEMbkWDz5wXNhS/p6wQfWq1poc2wdPVNXrEGLjcqRh2fRWcYhL6KWy
         APFm79+dgg1CZVNKHdajF7XVl31fLNdUh8EA0dUJpJoSMH+m5dbz1nAShoUQeAK1l+
         DzHNIoPWYPSrwRSCDGTOtDv2OsmfY59yhlgkj+Y+IejP+0F93RGyr9UR+33lVywZVE
         pwmUTDNZ7Jvca/CLtJU+YvTYHOfuLrpWQLzM+XCkyYikogArjrsonzHW1qLgxSyFQH
         QR7Ldlip4cH1IMaJx8L1/YfDbmykk4zgH5tYzEHnOiSdCKa6BFNRTY2rhnIt00Goom
         469HxeeEAAPvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Zhang <dingchen.zhang@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Jerry.Zuo@amd.com, nicholas.kazlauskas@amd.com,
        mikita.lipski@amd.com, Jimmy.Kizito@amd.com, dale.zhao@amd.com,
        wenjing.liu@amd.com, Anthony.Koo@amd.com,
        agustin.gutierrez@amd.com, Anson.Jacob@amd.com, po-tchen@amd.com,
        rdunlap@infradead.org, dharati.shah@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 011/105] drm/amd/display: fix system hang when PSR exits
Date:   Thu, 11 Aug 2022 11:26:55 -0400
Message-Id: <20220811152851.1520029-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Zhang <dingchen.zhang@amd.com>

[ Upstream commit 6cc5c77300afbb285c4f41e04f3435ae3c484c40 ]

[why]
When DC driver send PSR exit dmub command to DMUB FW, it might not
wait until PSR exit. Then it may hit the following deadlock situation.
1. DC driver send HW LOCK command to DMUB FW due to frame update
2. DMUB FW Set the HW lock
3. DMUB execute PSR exit sequence and stuck at polling DPG Pending
register due to the HW Lock is set
4. DC driver ask DMUB FW to unlock HW lock, but DMUB FW is polling
DPG pending register

[how]
The reason why DC driver doesn't wait until PSR exit is because some of
the PSR state machine state is not update the dc driver. So when DC
driver read back the PSR state, it take the state for PSR inactive.

Signed-off-by: David Zhang <dingchen.zhang@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h     |  7 +++++++
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 2ba9f528c0fe..f1f11b3c205f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -657,10 +657,17 @@ enum dc_psr_state {
 	PSR_STATE4b,
 	PSR_STATE4c,
 	PSR_STATE4d,
+	PSR_STATE4_FULL_FRAME,
+	PSR_STATE4a_FULL_FRAME,
+	PSR_STATE4b_FULL_FRAME,
+	PSR_STATE4c_FULL_FRAME,
+	PSR_STATE4_FULL_FRAME_POWERUP,
 	PSR_STATE5,
 	PSR_STATE5a,
 	PSR_STATE5b,
 	PSR_STATE5c,
+	PSR_STATE_HWLOCK_MGR,
+	PSR_STATE_POLLVUPDATE,
 	PSR_STATE_INVALID = 0xFF
 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 1d4f0c45b536..f941aa107dc6 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -74,6 +74,22 @@ static enum dc_psr_state convert_psr_state(uint32_t raw_state)
 		state = PSR_STATE5b;
 	else if (raw_state == 0x53)
 		state = PSR_STATE5c;
+	else if (raw_state == 0x4A)
+		state = PSR_STATE4_FULL_FRAME;
+	else if (raw_state == 0x4B)
+		state = PSR_STATE4a_FULL_FRAME;
+	else if (raw_state == 0x4C)
+		state = PSR_STATE4b_FULL_FRAME;
+	else if (raw_state == 0x4D)
+		state = PSR_STATE4c_FULL_FRAME;
+	else if (raw_state == 0x4E)
+		state = PSR_STATE4_FULL_FRAME_POWERUP;
+	else if (raw_state == 0x60)
+		state = PSR_STATE_HWLOCK_MGR;
+	else if (raw_state == 0x61)
+		state = PSR_STATE_POLLVUPDATE;
+	else
+		state = PSR_STATE_INVALID;
 
 	return state;
 }
-- 
2.35.1

