Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D267FB04
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404121AbfHBNgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393342AbfHBNUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B822173E;
        Fri,  2 Aug 2019 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752020;
        bh=ZTgKVv/+41uuwfvZ4owFkNllfRpb6iuJiPPKFq1ugq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c36RQZh90jt6qkcd0pFdz8mK9sux/ztKpSZdsQ2F8g8Kd4cvl5+Vi4M+eBf5c+qgp
         TCKxWFTzswjLAMHJjSvqgv7GomTs1oWBGs7eeWq04VYkCR2B6X9NeOkYClZKko3Cid
         O0e4oyuA51lrSBBDLaBMy79egx41eCI2UAywvghM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Yang <Eric.Yang2@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Leo Li <sunpeng.li@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 21/76] drm/amd/display: put back front end initialization sequence
Date:   Fri,  2 Aug 2019 09:18:55 -0400
Message-Id: <20190802131951.11600-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Yang <Eric.Yang2@amd.com>

[ Upstream commit feb7eb522e0a7a22c1e60d386bd3c3bfa1d5e4f7 ]

[Why]
Seamless boot optimization removed proper front end power off sequence.
In driver disable enable case, this causes driver to power gate hubp
and dpp while there is still memory fetching going on, this can cause
invalid memory requests to be generated which will hang data fabric.

[How]
Put back proper front end power off sequence

Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Acked-by: Tony Cheng <Tony.Cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index c7b4c3048b71d..5cc5dabf4d652 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1120,16 +1120,7 @@ static void dcn10_init_hw(struct dc *dc)
 	 * everything down.
 	 */
 	if (dcb->funcs->is_accelerated_mode(dcb) || dc->config.power_down_display_on_boot) {
-		for (i = 0; i < dc->res_pool->pipe_count; i++) {
-			struct hubp *hubp = dc->res_pool->hubps[i];
-			struct dpp *dpp = dc->res_pool->dpps[i];
-
-			hubp->funcs->hubp_init(hubp);
-			dc->res_pool->opps[i]->mpc_tree_params.opp_id = dc->res_pool->opps[i]->inst;
-			plane_atomic_power_down(dc, dpp, hubp);
-		}
-
-		apply_DEGVIDCN10_253_wa(dc);
+		dc->hwss.init_pipes(dc, dc->current_state);
 	}
 
 	for (i = 0; i < dc->res_pool->audio_count; i++) {
@@ -1298,10 +1289,6 @@ static bool dcn10_set_input_transfer_func(struct pipe_ctx *pipe_ctx,
 	return result;
 }
 
-
-
-
-
 static bool
 dcn10_set_output_transfer_func(struct pipe_ctx *pipe_ctx,
 			       const struct dc_stream_state *stream)
-- 
2.20.1

