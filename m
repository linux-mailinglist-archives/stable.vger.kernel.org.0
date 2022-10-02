Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF35F272F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJBXST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJBXSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB38633A;
        Sun,  2 Oct 2022 16:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CCCD60EE8;
        Sun,  2 Oct 2022 22:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B140C433C1;
        Sun,  2 Oct 2022 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751156;
        bh=XKpu/QrPdkOr6motgqw03iuGDVvktYnertgSyUUCT/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddIWB8djLxNBPAtYV7zXM+0z2WXG3YxFM4dTVoKYBqESKsQ2Mk9Z4vrHgLlGVnGPV
         lTY97gpYpCmSE77ltTm1FqrFPNAHyNz/8UXpFiadrYfroMu6zS1h4i0YVt985tYO1c
         aLKKgVYmf7fKkLGWouO3+Ip1FNHJK4wl+MaoRaVYgLlaHdNACG0WYNVarkZSRZ9AeN
         NpjuWjVz+T8+szqzIeF1SsMBa0SkDIEpEQ2GFA9NoykhSp4THmSHwD6htuWoqpPKVN
         dRj6MeKPN7QwrYrUlHK/H2W7hmqalsQs8oLCR6gE6IwiloyIsAMWwYeOV3NT8w6mkm
         fZ7KcYgy/fc3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhikzhai <zhikai.zhai@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Zhan.Liu@amd.com, mario.limonciello@amd.com,
        hanghong.ma@amd.com, wenjing.liu@amd.com,
        meenakshikumar.somasundaram@amd.com, Wesley.Chalmers@amd.com,
        agustin.gutierrez@amd.com, Martin.Leung@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 14/14] drm/amd/display: skip audio setup when audio stream is enabled
Date:   Sun,  2 Oct 2022 18:51:55 -0400
Message-Id: <20221002225155.239480-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225155.239480-1-sashal@kernel.org>
References: <20221002225155.239480-1-sashal@kernel.org>
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

From: zhikzhai <zhikai.zhai@amd.com>

[ Upstream commit 65fbfb02c2734cacffec5e3f492e1b4f1dabcf98 ]

[why]
We have minimal pipe split transition method to avoid pipe
allocation outage.However, this method will invoke audio setup
which cause audio output stuck once pipe reallocate.

[how]
skip audio setup for pipelines which audio stream has been enabled

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: zhikzhai <zhikai.zhai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 3ac6c7b65a45..e33fe0207b9e 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2047,7 +2047,8 @@ static void dce110_setup_audio_dto(
 			continue;
 		if (pipe_ctx->stream->signal != SIGNAL_TYPE_HDMI_TYPE_A)
 			continue;
-		if (pipe_ctx->stream_res.audio != NULL) {
+		if (pipe_ctx->stream_res.audio != NULL &&
+			pipe_ctx->stream_res.audio->enabled == false) {
 			struct audio_output audio_output;
 
 			build_audio_output(context, pipe_ctx, &audio_output);
@@ -2075,7 +2076,8 @@ static void dce110_setup_audio_dto(
 			if (!dc_is_dp_signal(pipe_ctx->stream->signal))
 				continue;
 
-			if (pipe_ctx->stream_res.audio != NULL) {
+			if (pipe_ctx->stream_res.audio != NULL &&
+				pipe_ctx->stream_res.audio->enabled == false) {
 				struct audio_output audio_output;
 
 				build_audio_output(context, pipe_ctx, &audio_output);
-- 
2.35.1

