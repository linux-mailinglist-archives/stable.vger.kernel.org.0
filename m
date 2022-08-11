Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EFD590199
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiHKPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiHKPvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:51:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E304D836;
        Thu, 11 Aug 2022 08:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D44B82156;
        Thu, 11 Aug 2022 15:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00FC433D6;
        Thu, 11 Aug 2022 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232625;
        bh=72luzlplpZ7E5lm35ayQDFraJYaLrAERVLdTT67D/rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ki9yLpmjwXGUqS9cSj2AH4LmkyXCTBMs3X4EZrtKDBpy0jFZxUffj7yOPcAPlHQJD
         M+FMUzrVG32W54pX2tcVgz0T42uZKzYbstIf1WLgV5Fd0m7fMD87mARfF49MRwa8DK
         sORVj0UYRUPK4qFO8WCGjx3E4ICTGWHuh2p5qJmwwz5ZbBjEnahe49D35Ly6wo7P2b
         K5vyx3lcgYj3MgBgt5Gmp7TJsiDK4aAuoReh+kgnysyAqMrZXd9GCo3QtH3tlypIAw
         848l7RRchEj+0ed8xiV5ooPhdKEdtXz1ySNmaYOgUqwtE9WNUqoCbsaS0t+5DJeR40
         LqLQDMMvJ0htw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Zhang <dingchen.zhang@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, Jerry.Zuo@amd.com,
        mikita.lipski@amd.com, Jimmy.Kizito@amd.com, dale.zhao@amd.com,
        wenjing.liu@amd.com, Anthony.Koo@amd.com, Anson.Jacob@amd.com,
        po-tchen@amd.com, dharati.shah@amd.com, rdunlap@infradead.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 11/93] drm/amd/display: fix system hang when PSR exits
Date:   Thu, 11 Aug 2022 11:41:05 -0400
Message-Id: <20220811154237.1531313-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 312c68172689..ce2f70134669 100644
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

