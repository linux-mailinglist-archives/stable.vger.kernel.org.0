Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FD49A5B2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371084AbiAYAG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360963AbiAXXip (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:38:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11129C07850B;
        Mon, 24 Jan 2022 13:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E5CDB81243;
        Mon, 24 Jan 2022 21:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA800C340E4;
        Mon, 24 Jan 2022 21:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060303;
        bh=s05JzdmOxIzc9HaITbzO0W37kq6LqIy/2UOUNHkgETw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPpjAhd0LRZ7STT5njLNk6TPvcRk5QbCFHZUSb4LOJjlNf0zRRbfHBRxwh8eubx2S
         1PuHu2b2lWZqa98RBefN6C0wn9bz00ZbykezfcigP6tH5x5ijDzjq5egk/lEbc/c8u
         /q4Xrzhp3WinZ1hDsWHEoCbH7WmoJAaiieN2/4wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Scott Bruce <smbruce@gmail.com>,
        Chris Hixon <linux-kernel-bugs@hixontech.com>,
        spasswolf@web.de,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 0870/1039] drm/amd/display: Revert W/A for hard hangs on DCN20/DCN21
Date:   Mon, 24 Jan 2022 19:44:19 +0100
Message-Id: <20220124184154.546440522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit c4849f88164b13dd141885e28210f599741b304b upstream.

The WA from commit 2a50edbf10c8 ("drm/amd/display: Apply w/a for hard hang
on HPD") and commit 1bd3bc745e7f ("drm/amd/display: Extend w/a for hard
hang on HPD to dcn20") causes a regression in s0ix where the system will
fail to resume properly on many laptops.  Pull the workarounds out to
avoid that s0ix regression in the common case.  This HPD hang happens with
an external device in special circumstances and a new W/A will need to be
developed for this in the future.

Cc: stable@vger.kernel.org
Cc: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reported-by: Scott Bruce <smbruce@gmail.com>
Reported-by: Chris Hixon <linux-kernel-bugs@hixontech.com>
Reported-by: spasswolf@web.de
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215436
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1821
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1852
Fixes: 2a50edbf10c8 ("drm/amd/display: Apply w/a for hard hang on HPD")
Fixes: 1bd3bc745e7f ("drm/amd/display: Extend w/a for hard hang on HPD to dcn20")
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c |   11 ----
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c    |   11 ----
 drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c |   25 -----------
 drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.h |    2 
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c |   25 -----------
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.h |    2 
 drivers/gpu/drm/amd/display/dc/irq/irq_service.c             |    2 
 drivers/gpu/drm/amd/display/dc/irq/irq_service.h             |    4 -
 8 files changed, 3 insertions(+), 79 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -38,7 +38,6 @@
 #include "clk/clk_11_0_0_offset.h"
 #include "clk/clk_11_0_0_sh_mask.h"
 
-#include "irq/dcn20/irq_service_dcn20.h"
 
 #undef FN
 #define FN(reg_name, field_name) \
@@ -223,8 +222,6 @@ void dcn2_update_clocks(struct clk_mgr *
 	bool force_reset = false;
 	bool p_state_change_support;
 	int total_plane_count;
-	int irq_src;
-	uint32_t hpd_state;
 
 	if (dc->work_arounds.skip_clock_update)
 		return;
@@ -242,13 +239,7 @@ void dcn2_update_clocks(struct clk_mgr *
 	if (dc->res_pool->pp_smu)
 		pp_smu = &dc->res_pool->pp_smu->nv_funcs;
 
-	for (irq_src = DC_IRQ_SOURCE_HPD1; irq_src <= DC_IRQ_SOURCE_HPD6; irq_src++) {
-		hpd_state = dc_get_hpd_state_dcn20(dc->res_pool->irqs, irq_src);
-		if (hpd_state)
-			break;
-	}
-
-	if (display_count == 0 && !hpd_state)
+	if (display_count == 0)
 		enter_display_off = true;
 
 	if (enter_display_off == safe_to_lower) {
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -42,7 +42,6 @@
 #include "clk/clk_10_0_2_sh_mask.h"
 #include "renoir_ip_offset.h"
 
-#include "irq/dcn21/irq_service_dcn21.h"
 
 /* Constants */
 
@@ -130,11 +129,9 @@ void rn_update_clocks(struct clk_mgr *cl
 	struct dc_clocks *new_clocks = &context->bw_ctx.bw.dcn.clk;
 	struct dc *dc = clk_mgr_base->ctx->dc;
 	int display_count;
-	int irq_src;
 	bool update_dppclk = false;
 	bool update_dispclk = false;
 	bool dpp_clock_lowered = false;
-	uint32_t hpd_state;
 
 	struct dmcu *dmcu = clk_mgr_base->ctx->dc->res_pool->dmcu;
 
@@ -151,14 +148,8 @@ void rn_update_clocks(struct clk_mgr *cl
 
 			display_count = rn_get_active_display_cnt_wa(dc, context);
 
-			for (irq_src = DC_IRQ_SOURCE_HPD1; irq_src <= DC_IRQ_SOURCE_HPD5; irq_src++) {
-				hpd_state = dc_get_hpd_state_dcn21(dc->res_pool->irqs, irq_src);
-				if (hpd_state)
-					break;
-			}
-
 			/* if we can go lower, go lower */
-			if (display_count == 0 && !hpd_state) {
+			if (display_count == 0) {
 				rn_vbios_smu_set_dcn_low_power_state(clk_mgr, DCN_PWR_STATE_LOW_POWER);
 				/* update power state */
 				clk_mgr_base->clks.pwr_state = DCN_PWR_STATE_LOW_POWER;
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
@@ -132,31 +132,6 @@ enum dc_irq_source to_dal_irq_source_dcn
 	}
 }
 
-uint32_t dc_get_hpd_state_dcn20(struct irq_service *irq_service, enum dc_irq_source source)
-{
-	const struct irq_source_info *info;
-	uint32_t addr;
-	uint32_t value;
-	uint32_t current_status;
-
-	info = find_irq_source_info(irq_service, source);
-	if (!info)
-		return 0;
-
-	addr = info->status_reg;
-	if (!addr)
-		return 0;
-
-	value = dm_read_reg(irq_service->ctx, addr);
-	current_status =
-		get_reg_field_value(
-			value,
-			HPD0_DC_HPD_INT_STATUS,
-			DC_HPD_SENSE);
-
-	return current_status;
-}
-
 static bool hpd_ack(
 	struct irq_service *irq_service,
 	const struct irq_source_info *info)
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.h
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.h
@@ -31,6 +31,4 @@
 struct irq_service *dal_irq_service_dcn20_create(
 	struct irq_service_init_data *init_data);
 
-uint32_t dc_get_hpd_state_dcn20(struct irq_service *irq_service, enum dc_irq_source source);
-
 #endif
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
@@ -135,31 +135,6 @@ enum dc_irq_source to_dal_irq_source_dcn
 	return DC_IRQ_SOURCE_INVALID;
 }
 
-uint32_t dc_get_hpd_state_dcn21(struct irq_service *irq_service, enum dc_irq_source source)
-{
-	const struct irq_source_info *info;
-	uint32_t addr;
-	uint32_t value;
-	uint32_t current_status;
-
-	info = find_irq_source_info(irq_service, source);
-	if (!info)
-		return 0;
-
-	addr = info->status_reg;
-	if (!addr)
-		return 0;
-
-	value = dm_read_reg(irq_service->ctx, addr);
-	current_status =
-		get_reg_field_value(
-			value,
-			HPD0_DC_HPD_INT_STATUS,
-			DC_HPD_SENSE);
-
-	return current_status;
-}
-
 static bool hpd_ack(
 	struct irq_service *irq_service,
 	const struct irq_source_info *info)
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.h
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.h
@@ -31,6 +31,4 @@
 struct irq_service *dal_irq_service_dcn21_create(
 	struct irq_service_init_data *init_data);
 
-uint32_t dc_get_hpd_state_dcn21(struct irq_service *irq_service, enum dc_irq_source source);
-
 #endif
--- a/drivers/gpu/drm/amd/display/dc/irq/irq_service.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/irq_service.c
@@ -79,7 +79,7 @@ void dal_irq_service_destroy(struct irq_
 	*irq_service = NULL;
 }
 
-const struct irq_source_info *find_irq_source_info(
+static const struct irq_source_info *find_irq_source_info(
 	struct irq_service *irq_service,
 	enum dc_irq_source source)
 {
--- a/drivers/gpu/drm/amd/display/dc/irq/irq_service.h
+++ b/drivers/gpu/drm/amd/display/dc/irq/irq_service.h
@@ -69,10 +69,6 @@ struct irq_service {
 	const struct irq_service_funcs *funcs;
 };
 
-const struct irq_source_info *find_irq_source_info(
-	struct irq_service *irq_service,
-	enum dc_irq_source source);
-
 void dal_irq_service_construct(
 	struct irq_service *irq_service,
 	struct irq_service_init_data *init_data);


