Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E13C463782
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhK3OyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57796 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242832AbhK3OxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2B33CE1A44;
        Tue, 30 Nov 2021 14:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAC3C58329;
        Tue, 30 Nov 2021 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283791;
        bh=hYNxbfEimHbEDbWqSzh1CkNFIQwTJln1jdBiUDtkhaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adSssKAoZAKNg4tP0s6fNetsYtt2h1H7C2SSUr2qBtk1RLxYUICvejX28+XtIK9YR
         gInDfJYpusoGBY5/TsCyWVCLgZ37tOt4WVMXQCR9+4cTam1rnE9I+Op7TkpueR8Fag
         oeZmp4YBWs1t1inOFMxAAuQdW93I/TJNAr8gKu9aRGISN4Ihn5/IgVQDDMnVyONBDJ
         Zl2Qx9JQCrSdsCFyY+p54ZCQkIZPytZPwdtL9Dy9vIqD6l5nTLeOaTMdlvuEf//A2o
         VrZxdz3UxN0pvgtAoO3/6A90ySUoY5+6IJ9iHuF+uHRMdgOaleFpgmxk8iOYVgHam9
         U6hxecOGq4UKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi-Ling Chen <Yi-Ling.Chen2@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, aric.cyr@amd.com,
        Jun.Lei@amd.com, vladimir.stempen@amd.com, Wesley.Chalmers@amd.com,
        Jerry.Zuo@amd.com, agustin.gutierrez@amd.com, wyatt.wood@amd.com,
        paul.hsieh@amd.com, hanghong.ma@amd.com, eric.yang2@amd.com,
        dillon.varone@amd.com, haonan.wang2@amd.com, Jimmy.Kizito@amd.com,
        Derek.Lai@amd.com, Josip.Pavic@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 57/68] drm/amd/display: Fixed DSC would not PG after removing DSC stream
Date:   Tue, 30 Nov 2021 09:46:53 -0500
Message-Id: <20211130144707.944580-57-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi-Ling Chen <Yi-Ling.Chen2@amd.com>

[ Upstream commit 2da8f0beece08a5c3c2e20c0e38e1a4bbc153f9e ]

[WHY]
Due to pass the wrong parameter down to the enable_stream_gating(),
it would cause the DSC of the removing stream would not be PG.

[HOW]
To pass the correct parameter down th the enable_stream_gating().

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Yi-Ling Chen <Yi-Ling.Chen2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c        | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 3af49cdf89ebd..2e0fb2ead0a3a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1566,7 +1566,7 @@ void dcn10_reset_hw_ctx_wrap(
 
 			dcn10_reset_back_end_for_pipe(dc, pipe_ctx_old, dc->current_state);
 			if (hws->funcs.enable_stream_gating)
-				hws->funcs.enable_stream_gating(dc, pipe_ctx);
+				hws->funcs.enable_stream_gating(dc, pipe_ctx_old);
 			if (old_clk)
 				old_clk->funcs->cs_power_down(old_clk);
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a47ba1d45be92..027f221a6d7d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2262,7 +2262,7 @@ void dcn20_reset_hw_ctx_wrap(
 
 			dcn20_reset_back_end_for_pipe(dc, pipe_ctx_old, dc->current_state);
 			if (hws->funcs.enable_stream_gating)
-				hws->funcs.enable_stream_gating(dc, pipe_ctx);
+				hws->funcs.enable_stream_gating(dc, pipe_ctx_old);
 			if (old_clk)
 				old_clk->funcs->cs_power_down(old_clk);
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 3afa1159a5f7d..251414babffa3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -588,7 +588,7 @@ void dcn31_reset_hw_ctx_wrap(
 
 			dcn31_reset_back_end_for_pipe(dc, pipe_ctx_old, dc->current_state);
 			if (hws->funcs.enable_stream_gating)
-				hws->funcs.enable_stream_gating(dc, pipe_ctx);
+				hws->funcs.enable_stream_gating(dc, pipe_ctx_old);
 			if (old_clk)
 				old_clk->funcs->cs_power_down(old_clk);
 		}
-- 
2.33.0

