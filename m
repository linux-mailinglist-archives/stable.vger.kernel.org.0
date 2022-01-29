Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB8A4A2F8E
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350623AbiA2MwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352555AbiA2MwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:52:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90948C061756
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 04:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A07560C7B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3D1C340E5;
        Sat, 29 Jan 2022 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643460724;
        bh=p7r2D7mC3cw+/n1dplopnGFz2VhWF2bl5Mza/o+jZWs=;
        h=Subject:To:Cc:From:Date:From;
        b=t0WLuiivR007NVDKcg/kD0Ynhb0peefCyDiXW0FdnCRIqLLIqtMib568jpIC5m9CQ
         VKXmaWKKL5rjHioYPcLNaTLCNutVnuEB8sGMs2AZZn86CyC2jSwT11MoeG8l1e59rg
         cOs6wgmB74sijbFtGtv9TSJ1rGq3cQiuGtb9B7Y8=
Subject: FAILED: patch "[PATCH] drm/amdgpu/display: Remove t_srx_delay_us." failed to apply to 5.15-stable tree
To:     bas@basnieuwenhuizen.nl, alexander.deucher@amd.com,
        harry.wentland@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:52:01 +0100
Message-ID: <164346072136252@kroah.com>
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

From 2a807341ed1074ab83638f2fab08dffaa373f6b8 Mon Sep 17 00:00:00 2001
From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date: Sun, 23 Jan 2022 03:38:28 +0100
Subject: [PATCH] drm/amdgpu/display: Remove t_srx_delay_us.

Unused. Convert the divisions into asserts on the divisor, to
debug why it is zero. The divide by zero is suspected of causing
kernel panics.

While I have no idea where the zero is coming from I think this
patch is a positive either way.

Cc: stable@vger.kernel.org
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c b/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
index ec19678a0702..e447c74be713 100644
--- a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
@@ -503,7 +503,6 @@ static void dcn_bw_calc_rq_dlg_ttu(
 	//input[in_idx].dout.output_standard;
 
 	/*todo: soc->sr_enter_plus_exit_time??*/
-	dlg_sys_param->t_srx_delay_us = dc->dcn_ip->dcfclk_cstate_latency / v->dcf_clk_deep_sleep;
 
 	dml1_rq_dlg_get_rq_params(dml, rq_param, &input->pipe.src);
 	dml1_extract_rq_regs(dml, rq_regs, rq_param);
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
index 246071c72f6b..548cdef8a8ad 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
@@ -1576,8 +1576,6 @@ void dml20_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
index 015e7f2c0b16..0fc9f3e3ffae 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
@@ -1577,8 +1577,6 @@ void dml20v2_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
index 8bc27de4c104..618f4b682ab1 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
@@ -1688,8 +1688,6 @@ void dml21_rq_dlg_get_dlg_reg(
 			mode_lib,
 			e2e_pipe_param,
 			num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-			/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
index aef854270054..747167083dea 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
@@ -1858,8 +1858,6 @@ void dml30_rq_dlg_get_dlg_reg(struct display_mode_lib *mode_lib,
 	dlg_sys_param.total_flip_bytes = get_total_immediate_flip_bytes(mode_lib,
 		e2e_pipe_param,
 		num_pipes);
-	dlg_sys_param.t_srx_delay_us = mode_lib->ip.dcfclk_cstate_latency
-		/ dlg_sys_param.deepsleep_dcfclk_mhz; // TODO: Deprecated
 
 	print__dlg_sys_params_st(mode_lib, &dlg_sys_param);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h
index d46a2733024c..8f9f1d607f7c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_structs.h
@@ -546,7 +546,6 @@ struct _vcs_dpi_display_dlg_sys_params_st {
 	double t_sr_wm_us;
 	double t_extra_us;
 	double mem_trip_us;
-	double t_srx_delay_us;
 	double deepsleep_dcfclk_mhz;
 	double total_flip_bw;
 	unsigned int total_flip_bytes;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c b/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c
index 71ea503cb32f..412e75eb4704 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_rq_dlg_helpers.c
@@ -141,9 +141,6 @@ void print__dlg_sys_params_st(struct display_mode_lib *mode_lib, const struct _v
 	dml_print("DML_RQ_DLG_CALC:    t_urg_wm_us          = %3.2f\n", dlg_sys_param->t_urg_wm_us);
 	dml_print("DML_RQ_DLG_CALC:    t_sr_wm_us           = %3.2f\n", dlg_sys_param->t_sr_wm_us);
 	dml_print("DML_RQ_DLG_CALC:    t_extra_us           = %3.2f\n", dlg_sys_param->t_extra_us);
-	dml_print(
-			"DML_RQ_DLG_CALC:    t_srx_delay_us       = %3.2f\n",
-			dlg_sys_param->t_srx_delay_us);
 	dml_print(
 			"DML_RQ_DLG_CALC:    deepsleep_dcfclk_mhz = %3.2f\n",
 			dlg_sys_param->deepsleep_dcfclk_mhz);
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
index 59dc2c5b58dd..3df559c591f8 100644
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

