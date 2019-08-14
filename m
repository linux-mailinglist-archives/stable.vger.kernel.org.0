Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714D78D907
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfHNREx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbfHNREw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2D421852;
        Wed, 14 Aug 2019 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802291;
        bh=Mzf1tfHHTh5RL/PRu3VQJ/WizmV6du3nA1sieXUlaUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN/1QTTS1ab+kUDw8V9YPq7xhtFdwBx/nZVf62GZ4fkZLnKsOjpEspmeQM+Qv+iEn
         2T74rAnSre85OQxNd+aq7NQ0ynfYnWCCgV9Pe64MuSfNoehLHxLL/RLy71sLh6imYH
         or4VCpQQDANrGbNxVz1JwQMzuN06spAVNAWrqPXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Yang <Eric.Yang2@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 069/144] drm/amd/display: put back front end initialization sequence
Date:   Wed, 14 Aug 2019 19:00:25 +0200
Message-Id: <20190814165802.735263887@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



