Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3D127C90
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfLTOaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfLTOaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6DC5206CB;
        Fri, 20 Dec 2019 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852204;
        bh=Wnhq2dkFTn8OU/FjGAcQtJk5oK5O3rmGFMjRCEfGvAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHSLH4xRx650kz68UbtsKqCUJOX8Bn/1bArdRH/tIex/uaQ2bA2C/JHa9hdq9sFMZ
         mdbOBItnruWr4Emf/0t8XoCYrkdN5HxtQgwVpn/9b7Z7LSwKzCfYuRs9HPUsHfF6JD
         0Xu2KEZ8G7SNVlpYqbfh31A2zGvu7jW2+5Ymw8m8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 07/52] drm/amd/display: Map DSC resources 1-to-1 if numbers of OPPs and DSCs are equal
Date:   Fri, 20 Dec 2019 09:29:09 -0500
Message-Id: <20191220142954.9500-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit a1fc44b609b4e9c0941f0e4a1fc69d367af5ab69 ]

[why]
On ASICs where number of DSCs is the same as OPPs there's no need
for DSC resource management. Mappping 1-to-1 fixes mode-set- or S3-
-related issues for such platforms.

[how]
Map DSC resources 1-to-1 to pipes only if number of OPPs is the same
as number of DSCs. This will still keep other ASICs working.
A follow-up patch to fix mode-set issues on those ASICs will be
required if testing shows issues with mode set.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c   | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 6b2f2f1a1c9ce..d95b265ae9b85 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1419,13 +1419,20 @@ enum dc_status dcn20_build_mapped_resource(const struct dc *dc, struct dc_state
 
 static void acquire_dsc(struct resource_context *res_ctx,
 			const struct resource_pool *pool,
-			struct display_stream_compressor **dsc)
+			struct display_stream_compressor **dsc,
+			int pipe_idx)
 {
 	int i;
 
 	ASSERT(*dsc == NULL);
 	*dsc = NULL;
 
+	if (pool->res_cap->num_dsc == pool->res_cap->num_opp) {
+		*dsc = pool->dscs[pipe_idx];
+		res_ctx->is_dsc_acquired[pipe_idx] = true;
+		return;
+	}
+
 	/* Find first free DSC */
 	for (i = 0; i < pool->res_cap->num_dsc; i++)
 		if (!res_ctx->is_dsc_acquired[i]) {
@@ -1468,7 +1475,7 @@ static enum dc_status add_dsc_to_stream_resource(struct dc *dc,
 		if (pipe_ctx->stream != dc_stream)
 			continue;
 
-		acquire_dsc(&dc_ctx->res_ctx, pool, &pipe_ctx->stream_res.dsc);
+		acquire_dsc(&dc_ctx->res_ctx, pool, &pipe_ctx->stream_res.dsc, i);
 
 		/* The number of DSCs can be less than the number of pipes */
 		if (!pipe_ctx->stream_res.dsc) {
@@ -1669,7 +1676,7 @@ static bool dcn20_split_stream_for_odm(
 	next_odm_pipe->stream_res.opp = pool->opps[next_odm_pipe->pipe_idx];
 #ifdef CONFIG_DRM_AMD_DC_DSC_SUPPORT
 	if (next_odm_pipe->stream->timing.flags.DSC == 1) {
-		acquire_dsc(res_ctx, pool, &next_odm_pipe->stream_res.dsc);
+		acquire_dsc(res_ctx, pool, &next_odm_pipe->stream_res.dsc, next_odm_pipe->pipe_idx);
 		ASSERT(next_odm_pipe->stream_res.dsc);
 		if (next_odm_pipe->stream_res.dsc == NULL)
 			return false;
-- 
2.20.1

