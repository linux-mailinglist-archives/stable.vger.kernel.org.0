Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E084645A0FD
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhKWLMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235703AbhKWLMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0EC361078;
        Tue, 23 Nov 2021 11:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637665762;
        bh=Z+ijR12Gg8aRxrObaUxu5BqrKVb2fFMUBMNQb1yVx6s=;
        h=Subject:To:Cc:From:Date:From;
        b=YGnhtAmj71ytepuIiDE39j6Hig4UdtJuL/y673cscY8kovkMgwCGwgO9NJ3lV9hnV
         c0vMhVIJfzfb7rmnIycyzzmvxR5ZiEdBd1MhLvcI9Ap1vxf3foXmZQrhdH8CpK8zPv
         1KiLMKesF2OilMOwmZLQIgP26neCc1bwgSu1VWak=
Subject: FAILED: patch "[PATCH] drm/amd/display: Get backlight from PWM if DMCU is not" failed to apply to 5.15-stable tree
To:     harry.wentland@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com, josip.pavic@amd.com, mikita.lipski@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:09:19 +0100
Message-ID: <1637665759195201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e0d55ae545f4a8f4c00339ad97ee2ef9e8e06ff Mon Sep 17 00:00:00 2001
From: Harry Wentland <harry.wentland@amd.com>
Date: Mon, 16 Aug 2021 15:57:12 -0400
Subject: [PATCH] drm/amd/display: Get backlight from PWM if DMCU is not
 initialized

On Carrizo/Stoney systems we set backlight through panel_cntl, i.e.
directly via the PWM registers, if DMCU is not initialized. We
always read it back through ABM registers which leads to a
mismatch and forces atomic_commit to program the backlight
each time.

Instead make sure we use the same logic for backlight readback,
i.e. read it from panel_cntl if DMCU is not initialized.

We also need to remove some extraneous and incorrect calculations
at the end of dce_get_16_bit_backlight_from_pwm.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1666
Cc: stable@vger.kernel.org

Reviewed-by: Josip Pavic <josip.pavic@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 3c8eb3e659af..61e49671fed5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2752,13 +2752,21 @@ static struct abm *get_abm_from_stream_res(const struct dc_link *link)
 
 int dc_link_get_backlight_level(const struct dc_link *link)
 {
-
 	struct abm *abm = get_abm_from_stream_res(link);
+	struct panel_cntl *panel_cntl = link->panel_cntl;
+	struct dc  *dc = link->ctx->dc;
+	struct dmcu *dmcu = dc->res_pool->dmcu;
+	bool fw_set_brightness = true;
 
-	if (abm == NULL || abm->funcs->get_current_backlight == NULL)
-		return DC_ERROR_UNEXPECTED;
+	if (dmcu)
+		fw_set_brightness = dmcu->funcs->is_dmcu_initialized(dmcu);
 
-	return (int) abm->funcs->get_current_backlight(abm);
+	if (!fw_set_brightness && panel_cntl->funcs->get_current_backlight)
+		return panel_cntl->funcs->get_current_backlight(panel_cntl);
+	else if (abm != NULL && abm->funcs->get_current_backlight != NULL)
+		return (int) abm->funcs->get_current_backlight(abm);
+	else
+		return DC_ERROR_UNEXPECTED;
 }
 
 int dc_link_get_target_backlight_pwm(const struct dc_link *link)
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
index e92339235863..e8570060d007 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c
@@ -49,7 +49,6 @@
 static unsigned int dce_get_16_bit_backlight_from_pwm(struct panel_cntl *panel_cntl)
 {
 	uint64_t current_backlight;
-	uint32_t round_result;
 	uint32_t bl_period, bl_int_count;
 	uint32_t bl_pwm, fractional_duty_cycle_en;
 	uint32_t bl_period_mask, bl_pwm_mask;
@@ -84,15 +83,6 @@ static unsigned int dce_get_16_bit_backlight_from_pwm(struct panel_cntl *panel_c
 	current_backlight = div_u64(current_backlight, bl_period);
 	current_backlight = (current_backlight + 1) >> 1;
 
-	current_backlight = (uint64_t)(current_backlight) * bl_period;
-
-	round_result = (uint32_t)(current_backlight & 0xFFFFFFFF);
-
-	round_result = (round_result >> (bl_int_count-1)) & 1;
-
-	current_backlight >>= bl_int_count;
-	current_backlight += round_result;
-
 	return (uint32_t)(current_backlight);
 }
 

