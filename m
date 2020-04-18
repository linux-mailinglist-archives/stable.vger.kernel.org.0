Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26281AEE2D
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgDROLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbgDROKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:10:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F6C22250;
        Sat, 18 Apr 2020 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587219035;
        bh=Glbhs5XKHS8JbLZoCXE0HbUu4H1R3R/0vs0CNEX07Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhmwXi/OJ2qCSKE0gaduOHArotaJ8kDGjdJnIPGpwmxmYc2aprjAKKQmUt0iY/SMk
         zEAwPDgP1HNezlapW3TVdhLejj2qhFSiVa00DOKYzQGako8imH4fqyXiv28ofMbKP1
         w+PrskHJRR7FwPc51jrgnYxqBRvd4/oWwTfXIHXc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Sun <yongqiang.sun@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 69/75] drm/amd/display: Not doing optimize bandwidth if flip pending.
Date:   Sat, 18 Apr 2020 10:09:04 -0400
Message-Id: <20200418140910.8280-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Sun <yongqiang.sun@amd.com>

[ Upstream commit 9941b8129030c9202aaf39114477a0e58c0d6ffc ]

[Why]
In some scenario like 1366x768 VSR enabled connected with a 4K monitor
and playing 4K video in clone mode, underflow will be observed due to
decrease dppclk when previouse surface scan isn't finished

[How]
In this use case, surface flip is switching between 4K and 1366x768,
1366x768 needs smaller dppclk, and when decrease the clk and previous
surface scan is for 4K and scan isn't done, underflow will happen.  Not
doing optimize bandwidth in case of flip pending.

Signed-off-by: Yongqiang Sun <yongqiang.sun@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index d25e0a937bf57..870e3903f02b9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1281,6 +1281,26 @@ bool dc_commit_state(struct dc *dc, struct dc_state *context)
 	return (result == DC_OK);
 }
 
+static bool is_flip_pending_in_pipes(struct dc *dc, struct dc_state *context)
+{
+	int i;
+	struct pipe_ctx *pipe;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe = &context->res_ctx.pipe_ctx[i];
+
+		if (!pipe->plane_state)
+			continue;
+
+		/* Must set to false to start with, due to OR in update function */
+		pipe->plane_state->status.is_flip_pending = false;
+		dc->hwss.update_pending_status(pipe);
+		if (pipe->plane_state->status.is_flip_pending)
+			return true;
+	}
+	return false;
+}
+
 bool dc_post_update_surfaces_to_stream(struct dc *dc)
 {
 	int i;
@@ -1291,6 +1311,9 @@ bool dc_post_update_surfaces_to_stream(struct dc *dc)
 
 	post_surface_trace(dc);
 
+	if (is_flip_pending_in_pipes(dc, context))
+		return true;
+
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
 		if (context->res_ctx.pipe_ctx[i].stream == NULL ||
 		    context->res_ctx.pipe_ctx[i].plane_state == NULL) {
-- 
2.20.1

