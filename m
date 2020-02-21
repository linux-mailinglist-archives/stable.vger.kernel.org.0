Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB53167838
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgBUHr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgBUHr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13D6208C4;
        Fri, 21 Feb 2020 07:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271278;
        bh=viIBm9b3VhN1DKXhLg9bkTkhgxwWO6/AiWhtmjD5vHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADO9yyexnFvAes95NrUGY/aRemdq3FnPYt5gIGL18fKr3mi1QjFjuQBB9jrudkhoz
         mIMierxaji/5S9yMD9FSkK/fWxx8qMeKwq971KSKRU3i4ffBrN9APFqdBAKJmYmj4J
         zpQsPduzGaQ3oKbvGBQjJekrf6f/FYcbUWzyQSYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Yang <Eric.Yang2@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 104/399] drm/amd/display: Renoir chroma viewport WA
Date:   Fri, 21 Feb 2020 08:37:09 +0100
Message-Id: <20200221072412.531999562@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Yang <Eric.Yang2@amd.com>

[ Upstream commit 1cad8ff7ecc6b70a062b8e8b74a0cd08c928341d ]

[Why]
For unknown reason, immediate flip with host VM translation on NV12
surface will underflow on last row of PTE.

[How]
Hack chroma viewport height to make fetch one more row of PTE.
Note that this will cause hubp underflow on all video underlay
cases, but the underflow is not user visible since it is in
blank region.

Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h           |  2 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c | 65 ++++++++++++++++++-
 .../drm/amd/display/dc/dcn21/dcn21_resource.c |  1 +
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 0416a17b0897c..320f4eeebf84c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -417,6 +417,8 @@ struct dc_debug_options {
 	bool cm_in_bypass;
 #endif
 	int force_clock_mode;/*every mode change.*/
+
+	bool nv12_iflip_vm_wa;
 };
 
 struct dc_debug_data {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
index 2f5a5867e6749..1ddd6ae221558 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
@@ -164,6 +164,69 @@ static void hubp21_setup(
 
 }
 
+void hubp21_set_viewport(
+	struct hubp *hubp,
+	const struct rect *viewport,
+	const struct rect *viewport_c)
+{
+	struct dcn21_hubp *hubp21 = TO_DCN21_HUBP(hubp);
+	int patched_viewport_height = 0;
+	struct dc_debug_options *debug = &hubp->ctx->dc->debug;
+
+	REG_SET_2(DCSURF_PRI_VIEWPORT_DIMENSION, 0,
+		  PRI_VIEWPORT_WIDTH, viewport->width,
+		  PRI_VIEWPORT_HEIGHT, viewport->height);
+
+	REG_SET_2(DCSURF_PRI_VIEWPORT_START, 0,
+		  PRI_VIEWPORT_X_START, viewport->x,
+		  PRI_VIEWPORT_Y_START, viewport->y);
+
+	/*for stereo*/
+	REG_SET_2(DCSURF_SEC_VIEWPORT_DIMENSION, 0,
+		  SEC_VIEWPORT_WIDTH, viewport->width,
+		  SEC_VIEWPORT_HEIGHT, viewport->height);
+
+	REG_SET_2(DCSURF_SEC_VIEWPORT_START, 0,
+		  SEC_VIEWPORT_X_START, viewport->x,
+		  SEC_VIEWPORT_Y_START, viewport->y);
+
+	/*
+	 *	Work around for underflow issue with NV12 + rIOMMU translation
+	 *	+ immediate flip. This will cause hubp underflow, but will not
+	 *	be user visible since underflow is in blank region
+	 */
+	patched_viewport_height = viewport_c->height;
+	if (viewport_c->height != 0 && debug->nv12_iflip_vm_wa) {
+		int pte_row_height = 0;
+		int pte_rows = 0;
+
+		REG_GET(DCHUBP_REQ_SIZE_CONFIG,
+			PTE_ROW_HEIGHT_LINEAR, &pte_row_height);
+
+		pte_row_height = 1 << (pte_row_height + 3);
+		pte_rows = (viewport_c->height + pte_row_height - 1) / pte_row_height;
+		patched_viewport_height = pte_rows * pte_row_height + 3;
+	}
+
+
+	/* DC supports NV12 only at the moment */
+	REG_SET_2(DCSURF_PRI_VIEWPORT_DIMENSION_C, 0,
+		  PRI_VIEWPORT_WIDTH_C, viewport_c->width,
+		  PRI_VIEWPORT_HEIGHT_C, patched_viewport_height);
+
+	REG_SET_2(DCSURF_PRI_VIEWPORT_START_C, 0,
+		  PRI_VIEWPORT_X_START_C, viewport_c->x,
+		  PRI_VIEWPORT_Y_START_C, viewport_c->y);
+
+	REG_SET_2(DCSURF_SEC_VIEWPORT_DIMENSION_C, 0,
+		  SEC_VIEWPORT_WIDTH_C, viewport_c->width,
+		  SEC_VIEWPORT_HEIGHT_C, patched_viewport_height);
+
+	REG_SET_2(DCSURF_SEC_VIEWPORT_START_C, 0,
+		  SEC_VIEWPORT_X_START_C, viewport_c->x,
+		  SEC_VIEWPORT_Y_START_C, viewport_c->y);
+}
+
 void hubp21_set_vm_system_aperture_settings(struct hubp *hubp,
 		struct vm_system_aperture_param *apt)
 {
@@ -211,7 +274,7 @@ static struct hubp_funcs dcn21_hubp_funcs = {
 	.hubp_set_vm_system_aperture_settings = hubp21_set_vm_system_aperture_settings,
 	.set_blank = hubp1_set_blank,
 	.dcc_control = hubp1_dcc_control,
-	.mem_program_viewport = min_set_viewport,
+	.mem_program_viewport = hubp21_set_viewport,
 	.set_cursor_attributes	= hubp2_cursor_set_attributes,
 	.set_cursor_position	= hubp1_cursor_set_position,
 	.hubp_clk_cntl = hubp1_clk_cntl,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index b29b2c99a564e..fe0ed4c09ad0a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -847,6 +847,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 		.scl_reset_length10 = true,
 		.sanity_checks = true,
 		.disable_48mhz_pwrdwn = false,
+		.nv12_iflip_vm_wa = true
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
-- 
2.20.1



