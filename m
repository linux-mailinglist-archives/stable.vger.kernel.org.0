Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764341D8314
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbgERSB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbgERSB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15853207D3;
        Mon, 18 May 2020 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824916;
        bh=n1mz1mu8yVWyo3xoJFTGzVFj2+WDzOfgdPH4m6e8cBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcxpvjxgWmCNQuZN51UowBrmPeO83K3ELKViWD13KuOCbcMFwVD0Cai4UsNAw6Ygw
         gRj/bkMCy2qliXDEUb8vPhejlatWsHVfMC/qanPnZ9lT40kFOIc6HWdLoLBcyeC5pR
         mtY6rdeUxFim34/6ucEZjKjZtlmURbiHMzvxpIZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaodong Yan <Xiaodong.Yan@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 056/194] drm/amd/display: blank dp stream before re-train the link
Date:   Mon, 18 May 2020 19:35:46 +0200
Message-Id: <20200518173536.399457226@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



