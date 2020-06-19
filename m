Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87A2200F64
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404165AbgFSPRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404156AbgFSPRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 695FB2158C;
        Fri, 19 Jun 2020 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579834;
        bh=UCFZxBdhCTtSOkMISHI4v+UNZnsH2SbHB6zuHhVW3k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QL9aJu4+IC63dwGqjoEfZKA/9IZRjAk0foIZlkjMgN/gFgeIutw/td0o8waUhmP+
         skPRyniPbOeTfaUoqexWLc8FJj2QKPOMfxyWMojXy2IZE0e5Dtwz8Ua3+wtCtNKxo6
         /jL3qv8/Bpy1VxW8tN1s5nV5oFtB1fBEzvDPC2c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Aberback <joshua.aberback@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 014/376] drm/amd/display: Force watermark value propagation
Date:   Fri, 19 Jun 2020 16:28:52 +0200
Message-Id: <20200619141711.039530106@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 868149c9a072cbdc22a73ce25a487f9fbfa171ef ]

[Why]
The HUBBUB watermark registers are in an area that cannot be power
gated, but the HUBP copies of the watermark values are in areas that can
be power gated. When we power on a pipe, it will not automatically take
the HUBBUB values, we need to force propagation by writing to a
watermark register.

[How]
 - new HUBBUB function to re-write current value in a WM register
 - touch WM register after enabling the plane in program_pipe

Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 5 ++++-
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h   | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a023a4d59f41..c4fa13e4eaf9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1478,8 +1478,11 @@ static void dcn20_program_pipe(
 	if (pipe_ctx->update_flags.bits.odm)
 		hws->funcs.update_odm(dc, context, pipe_ctx);
 
-	if (pipe_ctx->update_flags.bits.enable)
+	if (pipe_ctx->update_flags.bits.enable) {
 		dcn20_enable_plane(dc, pipe_ctx, context);
+		if (dc->res_pool->hubbub->funcs->force_wm_propagate_to_pipes)
+			dc->res_pool->hubbub->funcs->force_wm_propagate_to_pipes(dc->res_pool->hubbub);
+	}
 
 	if (pipe_ctx->update_flags.raw || pipe_ctx->plane_state->update_flags.raw || pipe_ctx->stream->update_flags.raw)
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
index f5dd0cc73c63..47a566d82d6e 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
@@ -144,6 +144,8 @@ struct hubbub_funcs {
 	void (*allow_self_refresh_control)(struct hubbub *hubbub, bool allow);
 
 	void (*apply_DEDCN21_147_wa)(struct hubbub *hubbub);
+
+	void (*force_wm_propagate_to_pipes)(struct hubbub *hubbub);
 };
 
 struct hubbub {
-- 
2.25.1



