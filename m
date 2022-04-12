Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CB4FCA76
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbiDLAyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344493AbiDLAxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DCD2FFEC;
        Mon, 11 Apr 2022 17:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23AD5B8198C;
        Tue, 12 Apr 2022 00:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9110BC385A4;
        Tue, 12 Apr 2022 00:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724508;
        bh=Xg4vLCR+8uD4OJD8sOL//NBYyh+xlZRQfw9zes0BGw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvYMvHvHLjeN5adFnMYIDWbxeRvBQEGkdB7lQJu8RTWUrjPbJ8URLq5Pfu61VaJv6
         gUu4ZPkPHelnwvYJQHcjQZr+FVP4yizGkVfpPYEv1/ykqXkQJhXsrleNeeUanwbDKr
         wOpReizY3y81KvBPYxul7an+b2WYXmOKUcM6LgAQCjzy5Czf1OvitJe1qsWkBGwmJR
         IJ8kgpMidCym/t+VQ/IG+VFdfMUF66WysdoVKya27wKtmP0xHsGClKNdRNvQyvG4Cg
         dNMngtRhqvutP6KX86NO0UlQXeEkw2HQiHr4Z1QUtGqU0LmbqDcE4gbaO0zDUY43Fp
         AGyBf2cE8wBHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <Roman.Li@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>, Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, aric.cyr@amd.com, Jun.Lei@amd.com,
        Yi-Ling.Chen2@amd.com, hanghong.ma@amd.com, Jerry.Zuo@amd.com,
        agustin.gutierrez@amd.com, wyatt.wood@amd.com, paul.hsieh@amd.com,
        Anson.Jacob@amd.com, Wesley.Chalmers@amd.com, roy.chan@amd.com,
        Martin.Leung@amd.com, haonan.wang2@amd.com,
        Bhawanpreet.Lakha@amd.com, nicholas.kazlauskas@amd.com,
        Derek.Lai@amd.com, Josip.Pavic@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 29/41] drm/amd/display: Enable power gating before init_pipes
Date:   Mon, 11 Apr 2022 20:46:41 -0400
Message-Id: <20220412004656.350101-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 58e16c752e9540b28a873c44c3bee83e022007c1 ]

[Why]
In init_hw() we call init_pipes() before enabling power gating.
init_pipes() tries to power gate dsc but it may fail because
required force-ons are not released yet.
As a result with dsc config the following errors observed on resume:
"REG_WAIT timeout 1us * 1000 tries - dcn20_dsc_pg_control"
"REG_WAIT timeout 1us * 1000 tries - dcn20_dpp_pg_control"
"REG_WAIT timeout 1us * 1000 tries - dcn20_hubp_pg_control"

[How]
Move enable_power_gating_plane() before init_pipes() in init_hw()

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c        | 5 +++--
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c        | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 3af49cdf89eb..174dd149fee7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1435,6 +1435,9 @@ void dcn10_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -1487,8 +1490,6 @@ void dcn10_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 0950784bafa4..f83457375811 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -570,6 +570,9 @@ void dcn30_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -647,8 +650,6 @@ void dcn30_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 3afa1159a5f7..b72d080b302a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -204,6 +204,9 @@ void dcn31_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -287,8 +290,6 @@ void dcn31_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
-- 
2.35.1

