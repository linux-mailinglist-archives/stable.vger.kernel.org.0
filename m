Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C493C311465
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhBEWFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232946AbhBEO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08E7E65024;
        Fri,  5 Feb 2021 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534273;
        bh=Tn1QHHcsJqiutpk3sC7RqJ7WncRkDf7SD0f8luhEqt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBZSwXZ6yaebD9lWDXOinoMcQ26CuL1Q3Dmmz8lA8/782ztZ95DhpZR/OSC3Y7Zq/
         sTwlOcZx+BjN4FxCklLxqDjkphBY6QyHYuj3GCPJo7XbpB6aeu4PUwxjwZlWK2j5l6
         W4DEyR3odkmPBu5hcwrlo7/HtPlzZUC7RKyWqV+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Vladimir Stempen <vladimir.stempen@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/57] drm/amd/display: Fixed corruptions on HPDRX link loss restore
Date:   Fri,  5 Feb 2021 15:07:16 +0100
Message-Id: <20210205140658.127197314@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 4b08d8c78360241d270396a9de6eb774e88acd00 ]

[why]
Heavy corruption or blank screen reported on wake,
with 6k display connected and FEC enabled

[how]
When Disable/Enable stream for display pipes on HPDRX,
DC should take into account ODM split pipes.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 004e2b32e02fa..17e6fd8201395 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3023,14 +3023,14 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 		for (i = 0; i < MAX_PIPES; i++) {
 			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
 			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link)
+					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
 				core_link_disable_stream(pipe_ctx);
 		}
 
 		for (i = 0; i < MAX_PIPES; i++) {
 			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
 			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link)
+					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
 				core_link_enable_stream(link->dc->current_state, pipe_ctx);
 		}
 
-- 
2.27.0



