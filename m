Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2AC371BF8
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhECQvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233034AbhECQrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB0061364;
        Mon,  3 May 2021 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059988;
        bh=gN9GJmqlsrU4t32+jfOOugZd3Z8iZ5ZBvoL4PeSYVpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBlI2Lj1aFIhSN+Es6zyYCYd3ybXMq3YMXaXlELiDW9/Y4lpQ5xo3pYKOjYQVWUB5
         hHGdF3lRPwZVZVZ+VIYbfVpw1oTraB+hyJA11XYDKYpoEAGTFbX2Ab+uAhhqUztVQF
         mYBkvugPCFlEQWKf5nLE0ZppQoTEjdh9HJpyewBFEM9j73lHKGn0Nkfnyd2fUL9asV
         /raKCMVttNt/Km9wVtan3FBHiia+HrtCtr08MjRdmqPwlx3MRY0zR9UivsfpNBkm5o
         jEFEmyyQ5ridHYjT15EpRyAqSGDr8DQtxvidkI8O1gcGvefeD97hrcpaYDM+OEsJXX
         OfuHNFoovb9mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>, Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 04/57] drm/amd/display: Don't optimize bandwidth before disabling planes
Date:   Mon,  3 May 2021 12:38:48 -0400
Message-Id: <20210503163941.2853291-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 6ad98e8aeb0106f453bb154933e8355849244990 ]

[Why]
There is a window of time where we optimize bandwidth due to no streams
enabled will enable PSTATE changing but HUBPs are not disabled yet.
This results in underflow counter increasing in some hotplug scenarios.

[How]
Set the optimize-bandwidth flag for later processing once all the HUBPs
are properly disabled.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 68d56a91d44b..092db590087c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1961,7 +1961,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					if (pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only)
 						pipe_ctx->stream_res.audio->funcs->az_disable(pipe_ctx->stream_res.audio);
 
-					dc->hwss.optimize_bandwidth(dc, dc->current_state);
+					dc->optimized_required = true;
+
 				} else {
 					if (!dc->optimize_seamless_boot)
 						dc->hwss.prepare_bandwidth(dc, dc->current_state);
-- 
2.30.2

