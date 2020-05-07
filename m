Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13981C8E87
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEGO1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgEGO1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE18120A8B;
        Thu,  7 May 2020 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861672;
        bh=n1mz1mu8yVWyo3xoJFTGzVFj2+WDzOfgdPH4m6e8cBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHpFiZkFcID4GLw7zPYtAHdAttiPSEs4St2oh7N3TtWXYgokJ9t3HN1tZXuvfG2+e
         RHPMlwF2q6x1voyZZcIldPXjmls8c/4ySjtdXaCkGRiV9D8rtHaF9rQaFN1YBTcifq
         Jq4xwu8r9L4oY635f5kcna54l+5zVBSaFuCByORA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaodong Yan <Xiaodong.Yan@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 21/50] drm/amd/display: blank dp stream before re-train the link
Date:   Thu,  7 May 2020 10:26:57 -0400
Message-Id: <20200507142726.25751-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaodong Yan <Xiaodong.Yan@amd.com>

[ Upstream commit 718a5569b6fa6e1f49f1ae76a3c18acb4ddb74f1 ]

[Why]
When link loss happened, monitor can not light up if only re-train the
link.

[How]
Blank all the DP streams on this link before re-train the link, and then
unblank the stream

Signed-off-by: Xiaodong Yan <Xiaodong.Yan@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index fd9e69634c50a..1b6c75a4dd60a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2885,6 +2885,12 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 					sizeof(hpd_irq_dpcd_data),
 					"Status: ");
 
+		for (i = 0; i < MAX_PIPES; i++) {
+			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+			if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
+				link->dc->hwss.blank_stream(pipe_ctx);
+		}
+
 		for (i = 0; i < MAX_PIPES; i++) {
 			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
 			if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
@@ -2904,6 +2910,12 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 		if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
 			dc_link_reallocate_mst_payload(link);
 
+		for (i = 0; i < MAX_PIPES; i++) {
+			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+			if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
+				link->dc->hwss.unblank_stream(pipe_ctx, &previous_link_settings);
+		}
+
 		status = false;
 		if (out_link_loss)
 			*out_link_loss = true;
-- 
2.20.1

