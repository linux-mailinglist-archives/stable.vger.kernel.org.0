Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB7B4FCA4D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbiDLAwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244084AbiDLAvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:51:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903CB32ED4;
        Mon, 11 Apr 2022 17:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2971FB819B5;
        Tue, 12 Apr 2022 00:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C8BC385A4;
        Tue, 12 Apr 2022 00:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724444;
        bh=6f46ygW4sXYYFSpSEOnkOKd5uLvlHXe/JGPWhFg61WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j15SGRXo/3DKfzq5oHZMMOobtZ7V8RdGAGp9MLEuNfpmdOBlO1hx/JmpQramEkZF5
         LyAtUgMc0lAU06qJzPgoZmeVXyDtyVLthTeFMqY6lzvG6ux6aN6DMpCfqECpGIVfGj
         xquqvrhneFIFHYVuInXk4lShs9UhJMcP2AX5QdYaqRy+NpxAoP0kIPnomRaq0V2kaO
         44928f2P+wFtuaOTlCUaQVp32WE9YDN7cGoQB6EnkpVjgbut3l0aIwWleIZSlMKPbl
         dUFGcWUQAOzV3rt4sEkxs27FV7OoC3lqaPosnScw0EV7AAY9j2gNb4BRullaQvWtKx
         hzCej1amCavwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charlene Liu <Charlene.Liu@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Jun.Lei@amd.com, aric.cyr@amd.com,
        Jimmy.Kizito@amd.com, wenjing.liu@amd.com,
        nicholas.kazlauskas@amd.com, mario.kleiner.de@gmail.com,
        Dmytro.Laktyushkin@amd.com, Jerry.Zuo@amd.com,
        meenakshikumar.somasundaram@amd.com, eric.bernstein@amd.com,
        Martin.Leung@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 06/41] drm/amd/display: fix audio format not updated after edid updated
Date:   Mon, 11 Apr 2022 20:46:18 -0400
Message-Id: <20220412004656.350101-6-sashal@kernel.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 5e8a71cf13bc9184fee915b2220be71b4c6cac74 ]

[why]
for the case edid change only changed audio format.
driver still need to update stream.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 7ae409f7dcf8..8c285d585249 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1623,8 +1623,8 @@ bool dc_is_stream_unchanged(
 	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
 		return false;
 
-	// Only Have Audio left to check whether it is same or not. This is a corner case for Tiled sinks
-	if (old_stream->audio_info.mode_count != stream->audio_info.mode_count)
+	/*compare audio info*/
+	if (memcmp(&old_stream->audio_info, &stream->audio_info, sizeof(stream->audio_info)) != 0)
 		return false;
 
 	return true;
-- 
2.35.1

