Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B842A650082
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiLRQQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiLRQPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF4310B59;
        Sun, 18 Dec 2022 08:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EBE560C58;
        Sun, 18 Dec 2022 16:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A68EC433EF;
        Sun, 18 Dec 2022 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379613;
        bh=cZNNScqHcCN606hosHGQCZoKIh6e63Zn9gRo+mJaMdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK3Lj6SLR3PY50+/ilB2We/cOiLuMeArA4Ha57ISz1WSnCR74cca1MggHTsEOVUDu
         h5cNFbmr+Kl7lprHMq33WWS6iH6rCJJgAtTks0/wKi+od85/nc2k/Hqn/04cGgNv92
         ZCzRf0GnkFVRWYJ5uyD3DNT+ebPXwMg3ahguaHmCy2QrZiYiRj1meK7OvlTpB9f6ab
         gZMJuv+Ypp7m6R+YyEmsPymaPJRIgdXPE7d0pcjt7loTMp7IXHogmOotieTWEy88nQ
         uCtwmWLMuzGc6c1EABLLG/8OBfjw9scTHCQl4MpFPk8l8iZBganXE6P8aCp3X7fu2X
         bFd0Y9HNIvOUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvin Lee <Alvin.Lee2@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, jun.lei@amd.com, samson.tam@amd.com,
        Brian.Chang@amd.com, eric.bernstein@amd.com, Syed.Hassan@amd.com,
        aurabindo.pillai@amd.com, george.shen@amd.com,
        jiapeng.chong@linux.alibaba.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 66/85] drm/amd/display: Fix DTBCLK disable requests and SRC_SEL programming
Date:   Sun, 18 Dec 2022 11:01:23 -0500
Message-Id: <20221218160142.925394-66-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit f6015da7f2410109bd2ccd2e2828f26185aeb81d ]

[Description]
- When transitioning FRL / DP2 is not required, we will always request
  DTBCLK = 0Mhz, but PMFW returns the min freq
- This causes us to make DTBCLK requests every time we call optimize
  after transitioning from FRL to non-FRL
- If DTBCLK is not required, request the min instead (then we only need
  to make 1 extra request at boot time)
- Also when programming PIPE_DTO_SRC_SEL, don't programming for DP
  first, just programming once for the required selection (programming
  DP on an HDMI connection then switching back causes corruption)

Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c           | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index 6f77d8e538ab..9eb9fe5b8d2c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -438,7 +438,7 @@ static void dcn32_update_clocks(struct clk_mgr *clk_mgr_base,
 	}
 
 	if (!new_clocks->dtbclk_en) {
-		new_clocks->ref_dtbclk_khz = 0;
+		new_clocks->ref_dtbclk_khz = clk_mgr_base->bw_params->clk_table.entries[0].dtbclk_mhz * 1000;
 	}
 
 	/* clock limits are received with MHz precision, divide by 1000 to prevent setting clocks at every call */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index df4f25119142..e4472c6be6c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -225,11 +225,7 @@ static void dccg32_set_dtbclk_dto(
 	} else {
 		REG_UPDATE_2(OTG_PIXEL_RATE_CNTL[params->otg_inst],
 				DTBCLK_DTO_ENABLE[params->otg_inst], 0,
-				PIPE_DTO_SRC_SEL[params->otg_inst], 1);
-		if (params->is_hdmi)
-			REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
-				PIPE_DTO_SRC_SEL[params->otg_inst], 0);
-
+				PIPE_DTO_SRC_SEL[params->otg_inst], params->is_hdmi ? 0 : 1);
 		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], 0);
 		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], 0);
 	}
-- 
2.35.1

