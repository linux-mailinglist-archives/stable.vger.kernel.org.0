Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0C5F265F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJBWwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBWvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA75399F3;
        Sun,  2 Oct 2022 15:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE1260F0B;
        Sun,  2 Oct 2022 22:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECC2C433C1;
        Sun,  2 Oct 2022 22:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751034;
        bh=uqE5ur36D/j3wyibxM/2VFbnUp+W6l2mwUdymFR+0BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTnkP8b5uBXpNU94sWKg76bOR2mYsnQz7DBparleEzTjEIgwgIUbpDSgh/0toX1dD
         KTkkGlM/PxUsz7lAohzqGPG97JIXkuvXI6ozFV70R3bIotqaZfaZ5Aj7hAWQ7qrPdY
         rQxLZy1UPFNwDBYugPewrwXD1Hv4vLfsEFQjwAM1lN0xFw2oXOk1aD1AjRvQi/S/md
         f75FoGx2HZxEY3EtVju7FstK/F0lakKDXVA8toaB6GpPoG9I6YCf1mZXXADu3u4LDP
         VQyjA+YphiC7xaQNwwn7F81exI799MTde2o9x0NagqhhbXuqoN06N4GiRkFsB6ZOrF
         mV9gaCJeM8o+A==
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
        Nicholas.Kazlauskas@amd.com, wenjing.liu@amd.com,
        Alvin.Lee2@amd.com, mwen@igalia.com, Yi-Ling.Chen2@amd.com,
        duncan.ma@amd.com, aurabindo.pillai@amd.com,
        jiapeng.chong@linux.alibaba.com, Sungjoon.Kim@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 25/29] drm/amd/display: update gamut remap if plane has changed
Date:   Sun,  2 Oct 2022 18:49:18 -0400
Message-Id: <20221002224922.238837-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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
index ec6aa8d8b251..213a02a769d4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1520,6 +1520,7 @@ static void dcn20_update_dchubp_dpp(
 	/* Any updates are handled in dc interface, just need
 	 * to apply existing for plane enable / opp change */
 	if (pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed
+			|| pipe_ctx->update_flags.bits.plane_changed
 			|| pipe_ctx->stream->update_flags.bits.gamut_remap
 			|| pipe_ctx->stream->update_flags.bits.out_csc) {
 		/* dpp/cm gamut remap*/
-- 
2.35.1

