Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090055AB09A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbiIBMyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbiIBMx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2611BFAC7C;
        Fri,  2 Sep 2022 05:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F806220F;
        Fri,  2 Sep 2022 12:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2C8C433C1;
        Fri,  2 Sep 2022 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122290;
        bh=nhUr/88MHNCkeqrs9I8L0gz/xSyEscGNpdglzYedMMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmjAY9cH3KYPCXV0GRUclDxNHfSsjvJ3uW7FRVpzWV7klRvRioO5q9M6YccL7FDPY
         MHQRyoLmfM84tViGY0+cKyEShu/b4Hni57fwfRVMKcUF+jz3JVRNE+JxjsKF2Cat3x
         gq1UTP/GemjBH0aQ11EMGqO3R8zfu2WT7yJ65xgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sun peng Li <Sunpeng.Li@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 57/72] drm/amd/display: Fix plug/unplug external monitor will hang while playback MPO video
Date:   Fri,  2 Sep 2022 14:19:33 +0200
Message-Id: <20220902121406.640002900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit e98459c06e3d45c2229b097f7b8cdd412357fa2f ]

[Why]
Pipes for MPO primary and overlay will be power down and power up during
plug/unplug external monitor while MPO video playback.
But the pipes were the same after plug/unplug and should not need to be
power down and power up or it will make page flip interrupt disabled and
cause hang issue.

[How]
Add pipe split change condition that not only check the top pipe pointer
but also check the index of top pipe if both top pipes are available.

Reviewed-by: Sun peng Li <Sunpeng.Li@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 7d69341acca02..9dbd965d8afb3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1067,8 +1067,15 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 		struct dc_stream_state *old_stream =
 				dc->current_state->res_ctx.pipe_ctx[i].stream;
 		bool should_disable = true;
-		bool pipe_split_change =
-			context->res_ctx.pipe_ctx[i].top_pipe != dc->current_state->res_ctx.pipe_ctx[i].top_pipe;
+		bool pipe_split_change = false;
+
+		if ((context->res_ctx.pipe_ctx[i].top_pipe) &&
+			(dc->current_state->res_ctx.pipe_ctx[i].top_pipe))
+			pipe_split_change = context->res_ctx.pipe_ctx[i].top_pipe->pipe_idx !=
+				dc->current_state->res_ctx.pipe_ctx[i].top_pipe->pipe_idx;
+		else
+			pipe_split_change = context->res_ctx.pipe_ctx[i].top_pipe !=
+				dc->current_state->res_ctx.pipe_ctx[i].top_pipe;
 
 		for (j = 0; j < context->stream_count; j++) {
 			if (old_stream == context->streams[j]) {
-- 
2.35.1



