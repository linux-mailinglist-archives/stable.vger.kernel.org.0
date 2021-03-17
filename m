Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0344E33E39E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCQA5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhCQA4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6780764F97;
        Wed, 17 Mar 2021 00:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942591;
        bh=cJR31kfGQQ6cjZttozJrDMs4iSToI1B1p7gYoFsNArw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tK9x+84YQecZzjG3dlc1g0xToEyjIbScUxQfGBohX0DaAbeN5X82GEzvnEdK/d+dm
         yGP0Q+OzSKrk7O4B3fAI+dtalZDQu0TSSqDb5dIxqAWpt3u6ibYM49LTiM95UIKt6V
         flZ2d8CkSjIUdbNhF6AeGMCOUgK/B73zEByxac31Q8kIZGWy+sjz1PlNNd4s/ARxEm
         XqrjarnO21nnyo4ViqbBLj2p2vcboC5B0usFKd7/zKyh7JqWV184f2E2Da0Su49AUw
         siQICTvNsOQXMRCmSDGG6MgFrHsgegBhRsYyDPWLu9PXMCi0oOUgy7Vt/vTA1x5IJb
         dZi2WLEGFw8LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dillon Varone <dillon.varone@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 45/61] drm/amd/display: Enabled pipe harvesting in dcn30
Date:   Tue, 16 Mar 2021 20:55:19 -0400
Message-Id: <20210317005536.724046-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit d2c91285958a3e77db99c352c136af4243f8f529 ]

[Why & How]
Ported logic from dcn21 for reading in pipe fusing to dcn30.
Supported configurations are 1 and 6 pipes. Invalid fusing
will revert to 1 pipe being enabled.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn30/dcn30_resource.c | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 5e126fdf6ec1..7ec8936346b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2601,6 +2601,19 @@ static const struct resource_funcs dcn30_res_pool_funcs = {
 	.patch_unknown_plane_state = dcn20_patch_unknown_plane_state,
 };
 
+#define CTX ctx
+
+#define REG(reg_name) \
+	(DCN_BASE.instance[0].segment[mm ## reg_name ## _BASE_IDX] + mm ## reg_name)
+
+static uint32_t read_pipe_fuses(struct dc_context *ctx)
+{
+	uint32_t value = REG_READ(CC_DC_PIPE_DIS);
+	/* Support for max 6 pipes */
+	value = value & 0x3f;
+	return value;
+}
+
 static bool dcn30_resource_construct(
 	uint8_t num_virtual_links,
 	struct dc *dc,
@@ -2610,6 +2623,15 @@ static bool dcn30_resource_construct(
 	struct dc_context *ctx = dc->ctx;
 	struct irq_service_init_data init_data;
 	struct ddc_service_init_data ddc_init_data;
+	uint32_t pipe_fuses = read_pipe_fuses(ctx);
+	uint32_t num_pipes = 0;
+
+	if (!(pipe_fuses == 0 || pipe_fuses == 0x3e)) {
+		BREAK_TO_DEBUGGER();
+		dm_error("DC: Unexpected fuse recipe for navi2x !\n");
+		/* fault to single pipe */
+		pipe_fuses = 0x3e;
+	}
 
 	DC_FP_START();
 
@@ -2739,6 +2761,15 @@ static bool dcn30_resource_construct(
 	/* PP Lib and SMU interfaces */
 	init_soc_bounding_box(dc, pool);
 
+	num_pipes = dcn3_0_ip.max_num_dpp;
+
+	for (i = 0; i < dcn3_0_ip.max_num_dpp; i++)
+		if (pipe_fuses & 1 << i)
+			num_pipes--;
+
+	dcn3_0_ip.max_num_dpp = num_pipes;
+	dcn3_0_ip.max_num_otg = num_pipes;
+
 	dml_init_instance(&dc->dml, &dcn3_0_soc, &dcn3_0_ip, DML_PROJECT_DCN30);
 
 	/* IRQ */
-- 
2.30.1

