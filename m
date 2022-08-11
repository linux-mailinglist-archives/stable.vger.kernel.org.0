Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41E59007C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiHKPlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiHKPkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E29C6EF07;
        Thu, 11 Aug 2022 08:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7CBDB82123;
        Thu, 11 Aug 2022 15:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3EEC43140;
        Thu, 11 Aug 2022 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232164;
        bh=DuTwacPrQi8SpKVCwo8IL9ID57K2gYT2UIZtXBk5aXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+pMtuG/ERjjpovv7xWF0FpXkaUNLHFxHoy8TQeXPLV9khvBUbqMi7S9DVCLMXg93
         hgLwjj40rXqok2CSO8DF7xWXT8ry0sjQyaFFGye+s7NaniUfzruLJ+hJfHY/r1Te2G
         HJQ/6YrZ8DffN6OssK1g9K+gKBwMKtqDXRtFP0XVylZsGhNH0OJUyUSsyGSfMa/dCZ
         1q12LQf6lPHFCNLBlQqZ1tMqPOZpgAYZ8mXCgX9rRsWAxlOvkd5SltHCnXU/CZKmJ2
         pbgLpCmJuV1QnhLJNvNr9N1NOvLhj1s4PHhcY5aoCPsK9YIdBRoKvwHtzO8+vF1P42
         UrS4D8HPSTlyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        qingqing.zhuo@amd.com, paul.hsieh@amd.com, Eric.Yang2@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 060/105] drm/amd/display: disable otg toggle w/a on boot
Date:   Thu, 11 Aug 2022 11:27:44 -0400
Message-Id: <20220811152851.1520029-60-sashal@kernel.org>
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

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 8a077d9caa3a274de36ee2fe7b608041f5690343 ]

This w/a has a bad interaction with seamless boot toggling an
active stream. Most panels recover, however some fail leading
to display corruption.

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index f4381725b210..36b0cd47c1c7 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -173,11 +173,14 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	}
 
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)) {
-		dcn315_disable_otg_wa(clk_mgr_base, true);
+		/* No need to apply the w/a if we haven't taken over from bios yet */
+		if (clk_mgr_base->clks.dispclk_khz)
+			dcn315_disable_otg_wa(clk_mgr_base, true);
 
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
 		dcn315_smu_set_dispclk(clk_mgr, clk_mgr_base->clks.dispclk_khz);
-		dcn315_disable_otg_wa(clk_mgr_base, false);
+		if (clk_mgr_base->clks.dispclk_khz)
+			dcn315_disable_otg_wa(clk_mgr_base, false);
 
 		update_dispclk = true;
 	}
-- 
2.35.1

