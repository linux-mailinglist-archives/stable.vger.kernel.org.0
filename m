Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D36657C76
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiL1PdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiL1Pci (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F416480
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42C661553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC13C433EF;
        Wed, 28 Dec 2022 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241557;
        bh=oH3Yn3RG1RL7+LAJRrVN/24gat48NxpxvU3vePCLfmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdE3YW+UbSG+1eu5CCKc73Dx+NR3kQIBvQpLkAnAp0GjwyQC7zUUbEOHVx2j77yqO
         CztgNWiqnXNZCfzZeKp2hd9ZW+IeDbsyiyWP1fLdHzST/SLd7pfFW4LptJOFX+7bIz
         AxcoSqEVTc9g5yYtkTcv/pImjr9fWDjBwfi2sVP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Haiyi Zhou <Haiyi.Zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0260/1146] drm/amd/display: wait for vblank during pipe programming
Date:   Wed, 28 Dec 2022 15:29:59 +0100
Message-Id: <20221228144337.199217914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Haiyi Zhou <Haiyi.Zhou@amd.com>

[ Upstream commit 203ccaf586446b578909de1b763278033fb74b51 ]

[WHY]
Skipping vblank during global sync update request can result in
underflow on certain displays.

[HOW]
Roll back to the previous behavior where DC waits for vblank during pipe
programming.

Fixes: 5d3e14421410 ("drm/amd/display: do not wait for vblank during pipe programming")
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Haiyi Zhou <Haiyi.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a7e0001a8f46..a34c2cd78dd5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1640,10 +1640,8 @@ static void dcn20_program_pipe(
 				pipe_ctx->pipe_dlg_param.vupdate_width);
 
 		if (pipe_ctx->stream->mall_stream_config.type != SUBVP_PHANTOM) {
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(
-				pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(
-				pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
 		}
 
 		pipe_ctx->stream_res.tg->funcs->set_vtg_params(
-- 
2.35.1



