Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77426650052
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiLRQM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiLRQLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:11:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12846DF70;
        Sun, 18 Dec 2022 08:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E1760DC8;
        Sun, 18 Dec 2022 16:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524D9C433A7;
        Sun, 18 Dec 2022 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379519;
        bh=+wPILuLBCbghQ1iyYlen45uCRSTuLfYQ5KIGVelLKwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KX2ZN5WJzGd+vv7UxCshk0s8vxv8gTNHDxfwuvLWm51gFuIY1TgNCFtlwF6A3UEq1
         AuqKsk66TfbyZNoMpqoFdSV85I/bB7hRGPa657VZHdk/x13OR7D4GUvJdMOE+5NdPL
         Ki4R68b4zwg4ibbsx49fv9S0hd0ZiSLzoRTbxOg4HqiN+YW4G5jQwdudrQMBGqZXOP
         3SVRVcvHvwV0cg/LWgioPqxMVgMdOakDHfxL/HL6ExqH9WrJxv96MTG2VFiBm/jcaI
         cYFI/pUI0eKv2MG2WiCaT7ad4yvCbe+AhNOyXAIkXqLqFvJrnSiP22vtWS1XwWErP2
         /0x1wUTgmlssQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Alvin.Lee2@amd.com, aurabindo.pillai@amd.com,
        jun.lei@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 54/85] drm/amd/display: Fix display corruption w/ VSR enable
Date:   Sun, 18 Dec 2022 11:01:11 -0500
Message-Id: <20221218160142.925394-54-sashal@kernel.org>
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

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit e643cd384270fd3a4b66f65f15dafc8db0607adc ]

[Why]
Brief corruption is observed on hotplug/unplug with certain display
configurations when VSR is enabled.

[How]
Work around the issue by avoiding 2to1 ODM when stream plane_count is 0.

Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index d1598e3131f6..33ab6fdc3617 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1901,7 +1901,7 @@ int dcn32_populate_dml_pipes_from_context(
 
 		pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_dal;
 		if (context->stream_count == 1 &&
-				context->stream_status[0].plane_count <= 1 &&
+				context->stream_status[0].plane_count == 1 &&
 				!dc_is_hdmi_signal(res_ctx->pipe_ctx[i].stream->signal) &&
 				is_h_timing_divisible_by_2(res_ctx->pipe_ctx[i].stream) &&
 				pipe->stream->timing.pix_clk_100hz * 100 > DCN3_2_VMIN_DISPCLK_HZ &&
-- 
2.35.1

