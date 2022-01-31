Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DECD4A4355
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358911AbiAaLU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37288 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377048AbiAaLRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14E90B82A74;
        Mon, 31 Jan 2022 11:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CB4C340EE;
        Mon, 31 Jan 2022 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627851;
        bh=7GqUqIsUYSAlU1UXi3GkXPyF0UziS1avSMLfAsGx6XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRw3vwjz8Kz4/AbgHeNWZ9GNpQpbbJB1bwBoDaytufymMzofe4uHYM+VXcERoCWxU
         FQ+LiHjdZavXD7yTiYNqSw3vcPrP5xtoZjqZuxsC33/nlsS2UvthlI5GghUtQgx6/q
         AqhsrVU0gkmR0OBn9dWDEXPTWHaicZG5UiJJuHuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 045/200] drm/amdgpu/display: Remove t_srx_delay_us.
Date:   Mon, 31 Jan 2022 11:55:08 +0100
Message-Id: <20220131105235.073629689@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 2a807341ed1074ab83638f2fab08dffaa373f6b8 upstream.

Unused. Convert the divisions into asserts on the divisor, to
debug why it is zero. The divide by zero is suspected of causing
kernel panics.

While I have no idea where the zero is coming from I think this
patch is a positive either way.

Cc: stable@vger.kernel.org
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c                    |    1 -
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c   |    2 --
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c |    2 --
 drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c   |    2 --
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c   |    2 --
 drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h           |    1 -
 drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c         |    3 ---
 drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c       |    4 ----
 8 files changed, 17 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
@@ -503,7 +503,6 @@ static void dcn_bw_calc_rq_dlg_ttu(
 	//input[in_idx].dout.output_standard;
 
 	/*todo: soc->sr_enter_plus_exit_time??*/
-	dlg_sys_param->t_srx_delay_us = dc->dcn_ip->dcfclk_cstate_latency / v->dcf_clk_deep_sleep;
 
 	dml1_rq_dlg_get_rq_params(dml, rq_param, &input->pipe.src);
 	dml1_extract_rq_regs(dml, rq_regs, rq_param);
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
@@ -1576,8 +1576,6 @@ void dml20_rq_dlg_get_dlg_reg(struct dis
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
@@ -1577,8 +1577,6 @@ void dml20v2_rq_dlg_get_dlg_reg(struct d
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
@@ -1688,8 +1688,6 @@ void dml21_rq_dlg_get_dlg_reg(
 			mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
@@ -1858,8 +1858,6 @@ void dml30_rq_dlg_get_dlg_reg(struct dis
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 		e2e_pipe_param,
 		num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-		/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h
@@ -546,7 +546,6 @@ struct _vcs_dpi_display_dlg_sys_params_s
 	double t_sr_wm_us;
 	double t_extra_us;
 	double mem_trip_us;
-	double t_srx_delay_us;
 	double deepsleep_dcfclk_mhz;
 	double total_flip_bw;
 	unsigned int total_flip_bytes;
--- a/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c
@@ -142,9 +142,6 @@ void print__dlg_sys_params_st(struct dis
 	dml_print("DML_RQ_DLG_CALC:    t_sr_wm_us           = %3.2f\n", dlg_sys_param->t_sr_wm_us);
 	dml_print("DML_RQ_DLG_CALC:    t_extra_us           = %3.2f\n", dlg_sys_param->t_extra_us);
 	dml_print(
-			"DML_RQ_DLG_CALC:    t_srx_delay_us       = %3.2f\n",
-			dlg_sys_param->t_srx_delay_us);
-	dml_print(
 			"DML_RQ_DLG_CALC:    deepsleep_dcfclk_mhz = %3.2f\n",
 			dlg_sys_param->deepsleep_dcfclk_mhz);
 	dml_print(
--- a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
@@ -1331,10 +1331,6 @@ void dml1_rq_dlg_get_dlg_params(
 	if (dual_plane)
 		DTRACE("DLG: %s: swath_height_c     = %d", __func__, swath_height_c);
 
-	DTRACE(
-			"DLG: %s: t_srx_delay_us     = %3.2f",
-			__func__,
-			(double) dlg_sys_param->t_srx_delay_us);
 	DTRACE("DLG: %s: line_time_in_us    = %3.2f", __func__, (double) line_time_in_us);
 	DTRACE("DLG: %s: vupdate_offset     = %d", __func__, vupdate_offset);
 	DTRACE("DLG: %s: vupdate_width      = %d", __func__, vupdate_width);


