Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9156D5F2719
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJBXLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiJBXLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:11:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2A84BA67;
        Sun,  2 Oct 2022 16:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C8AB80DAC;
        Sun,  2 Oct 2022 22:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B5EC43470;
        Sun,  2 Oct 2022 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751151;
        bh=jDTWO7/A4ILbQOGos8cOKJRfLSJ/u0dfe62xH/2E/WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIhATSwIiEYvIQ85SzuTVZyRO2368VS086XV2/GQ1EeEkymwfDjahJKnggtZyoqLl
         29tW/f3WLv6OEr3NRVfORwbsH0Tjpgyb6OWIWASv5tBRKeJ5e8YBN1UaxVhm2j5OJh
         a921zcNP7d3dVDtAgsU0kOJOoif2q9mRpa6iVDH0w8ZV5ogtEJ0BhCvmB23w744Qq4
         MXTk/XRcmrwTFt7On20iLttZA8itR6Z6YP0RxJ8czIdHEw836tffBPV/4HhyayeaOx
         UlrzTwexTI1xy+7xzgSb2e56i6u+NtiJ9eqbXFPY8C7m7AA2KzwmxG2XuVetHmRt7T
         Mc8Iabbo4vmjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugo Hu <hugo.hu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Jun.Lei@amd.com, Aric.Cyr@amd.com,
        Nicholas.Kazlauskas@amd.com, Alvin.Lee2@amd.com,
        wenjing.liu@amd.com, duncan.ma@amd.com, mwen@igalia.com,
        Yi-Ling.Chen2@amd.com, aurabindo.pillai@amd.com,
        jiapeng.chong@linux.alibaba.com, Sungjoon.Kim@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 13/14] drm/amd/display: update gamut remap if plane has changed
Date:   Sun,  2 Oct 2022 18:51:54 -0400
Message-Id: <20221002225155.239480-13-sashal@kernel.org>
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

From: Hugo Hu <hugo.hu@amd.com>

[ Upstream commit 52bb21499cf54fa65b56d97cd0d68579c90207dd ]

[Why]
The desktop plane and full-screen game plane may have different
gamut remap coefficients, if switching between desktop and
full-screen game without updating the gamut remap will cause
incorrect color.

[How]
Update gamut remap if planes change.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Hugo Hu <hugo.hu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 3d778760a3b5..8f66eef0c683 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1481,6 +1481,7 @@ static void dcn20_update_dchubp_dpp(
 	/* Any updates are handled in dc interface, just need
 	 * to apply existing for plane enable / opp change */
 	if (pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed
+			|| pipe_ctx->update_flags.bits.plane_changed
 			|| pipe_ctx->stream->update_flags.bits.gamut_remap
 			|| pipe_ctx->stream->update_flags.bits.out_csc) {
 #if defined(CONFIG_DRM_AMD_DC_DCN3_0)
-- 
2.35.1

