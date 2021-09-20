Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740DD4124D2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348354AbhITSiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379742AbhITSgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7739E63316;
        Mon, 20 Sep 2021 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158954;
        bh=WlDUENaZcu6jmqnQKgk0iSN2xivoTXDq/k/XPHu+/Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GO2OANMOxfgZEYn5RQLsii78yRshsUAG2EnURHv1c6yxz+VZCBM4u+gKZ2iAuXgGj
         xQ98E//XsXyQaGbBxVTeqomwNM+g31R+C4lDpzqhZ2VftNE5RPcajbUB/QRnjvM3fs
         8vcZluXiJTw/MtS0+jS8It0NBQX10Wy/pq1LmbWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josip Pavic <josip.pavic@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 010/168] drm/amd/display: Get backlight from PWM if DMCU is not initialized
Date:   Mon, 20 Sep 2021 18:42:28 +0200
Message-Id: <20210920163921.993653573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

commit 9987fbb368038d41bfdcda2a3f7f4945d7daa9a5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c       |   16 ++++++++++++----
 drivers/gpu/drm/amd/display/dc/dce/dce_panel_cntl.c |   10 ----------
 2 files changed, 12 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2578,13 +2578,21 @@ static struct abm *get_abm_from_stream_r
 
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
@@ -84,15 +83,6 @@ static unsigned int dce_get_16_bit_backl
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
 


