Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A944451365
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348222AbhKOTvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245722AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3850C61163;
        Mon, 15 Nov 2021 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001613;
        bh=KRBRcvBIADkWd5b/8yUGmrKBfzHqsh2rZjSTMHekt2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8sCpOn17H743gda10AR86ansTvSzrU5Nv4i3Ch/mH+Oib1ai0HiVxZdSaTL1LZxZ
         gWFRtbXdEIjeeG4fbRm0MazFoGlmjvRZqLda+zResVJTIjbOjjZJWDoJulCr+NiA1C
         UJzHEDHgP9zT2uzLzwc8NgC9osTjD0Pzv3xWerVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/917] drm/amd/display: fix null pointer deref when plugging in display
Date:   Mon, 15 Nov 2021 17:55:51 +0100
Message-Id: <20211115165437.469000071@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 1f3b22e4eb162e0b1d423106a47484943a22a309 ]

[Why&How]
When system boots in headless mode, connecting a 4k display creates a
null pointer dereference due to hubp for a certain plane being null.
Add a condition to check for null hubp before dereferencing it.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index fafed1e4a998d..0950784bafa49 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -1002,7 +1002,8 @@ void dcn30_set_disp_pattern_generator(const struct dc *dc,
 		/* turning off DPG */
 		pipe_ctx->plane_res.hubp->funcs->set_blank(pipe_ctx->plane_res.hubp, false);
 		for (mpcc_pipe = pipe_ctx->bottom_pipe; mpcc_pipe; mpcc_pipe = mpcc_pipe->bottom_pipe)
-			mpcc_pipe->plane_res.hubp->funcs->set_blank(mpcc_pipe->plane_res.hubp, false);
+			if (mpcc_pipe->plane_res.hubp)
+				mpcc_pipe->plane_res.hubp->funcs->set_blank(mpcc_pipe->plane_res.hubp, false);
 
 		stream_res->opp->funcs->opp_set_disp_pattern_generator(stream_res->opp, test_pattern, color_space,
 				color_depth, solid_color, width, height, offset);
-- 
2.33.0



