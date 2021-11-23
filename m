Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8D345A0F9
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKWLMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhKWLMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE4460F5B;
        Tue, 23 Nov 2021 11:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637665747;
        bh=s3qKq1BzDWLoyHyG+R1alrVEFd7H4tvdev8myQ6DrZU=;
        h=Subject:To:Cc:From:Date:From;
        b=o+YnHbpY6HypFZAJ25OrgsEK+9i6FVbnVeyV7tMSUEps6ghADt0098u9Ere+QNIP4
         9y513ZJUyA7TD3vLyOublUwPQDYpAxs6s6H8xTGI33b9h9+hbSzmxmHflsPkFc3DXx
         1Exz3IQEdI00enjy8q2NPXIH97+MY0lc5uF2w/9s=
Subject: FAILED: patch "[PATCH] drm/amd/display: dsc mst 2 4K displays go dark with 2 lane" failed to apply to 5.15-stable tree
To:     hersenwu@amd.com, Scott.Foster@amd.com, alexander.deucher@amd.com,
        daniel.wheeler@amd.com, mikita.lipski@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:09:04 +0100
Message-ID: <163766574435143@kroah.com>
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

From 6513104ba4a808de07722ef4ffb960f0229752b4 Mon Sep 17 00:00:00 2001
From: Hersen Wu <hersenwu@amd.com>
Date: Wed, 25 Aug 2021 16:27:47 -0400
Subject: [PATCH] drm/amd/display: dsc mst 2 4K displays go dark with 2 lane
 HBR3

[Why]
call stack of amdgpu dsc mst pbn, slot num calculation is as below:
-compute_bpp_x16_from_target_bandwidth
-decide_dsc_target_bpp_x16
-setup_dsc_config
-dc_dsc_compute_bandwidth_range
-compute_mst_dsc_configs_for_link
-compute_mst_dsc_configs_for_state

from pbn -> dsc target bpp_x16

bpp_x16 is calulated by compute_bpp_x16_from_target_bandwidth.
Beside pixel clock and bpp, num_slices_h and bpp_increment_div
will also affect bpp_x16.

from dsc target bpp_x16 -> pbn

within dm_update_mst_vcpi_slots_for_dsc,
pbn = drm_dp_calc_pbn_mode(clock, bpp_x16, true);

drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc)
{
  return DIV_ROUND_UP_ULL(mul_u32_u32(clock * (bpp / 16), 64 * 1006),
            8 * 54 * 1000 * 1000);
}

bpp / 16 trunc digits after decimal point. This will cause calculation
delta. drm_dp_calc_pbn_mode does not have other informations,
like num_slices_h, bpp_increment_div. therefore, it does not do revese
calcuation properly from bpp_x16 to pbn.

pbn from drm_dp_calc_pbn_mode is less than pbn from
compute_mst_dsc_configs_for_state. This cause not enough mst slot
allocated to display. display could not visually light up.

[How]
pass pbn from compute_mst_dsc_configs_for_state to
dm_update_mst_vcpi_slots_for_dsc

Cc: stable@vger.kernel.org

Reviewed-by: Scott Foster <Scott.Foster@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Hersen Wu <hersenwu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 283d660a0a66..24cd4c819e99 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7092,14 +7092,15 @@ const struct drm_encoder_helper_funcs amdgpu_dm_encoder_helper_funcs = {
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
-					    struct dc_state *dc_state)
+					    struct dc_state *dc_state,
+					    struct dsc_mst_fairness_vars *vars)
 {
 	struct dc_stream_state *stream = NULL;
 	struct drm_connector *connector;
 	struct drm_connector_state *new_con_state;
 	struct amdgpu_dm_connector *aconnector;
 	struct dm_connector_state *dm_conn_state;
-	int i, j, clock, bpp;
+	int i, j, clock;
 	int vcpi, pbn_div, pbn = 0;
 
 	for_each_new_connector_in_state(state, connector, new_con_state, i) {
@@ -7138,9 +7139,15 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 		}
 
 		pbn_div = dm_mst_get_pbn_divider(stream->link);
-		bpp = stream->timing.dsc_cfg.bits_per_pixel;
 		clock = stream->timing.pix_clk_100hz / 10;
-		pbn = drm_dp_calc_pbn_mode(clock, bpp, true);
+		/* pbn is calculated by compute_mst_dsc_configs_for_state*/
+		for (j = 0; j < dc_state->stream_count; j++) {
+			if (vars[j].aconnector == aconnector) {
+				pbn = vars[j].pbn;
+				break;
+			}
+		}
+
 		vcpi = drm_dp_mst_atomic_enable_dsc(state,
 						    aconnector->port,
 						    pbn, pbn_div,
@@ -10546,6 +10553,9 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	int ret, i;
 	bool lock_and_validation_needed = false;
 	struct dm_crtc_state *dm_old_crtc_state;
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct dsc_mst_fairness_vars vars[MAX_PIPES];
+#endif
 
 	trace_amdgpu_dm_atomic_check_begin(state);
 
@@ -10776,10 +10786,10 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
-		if (!compute_mst_dsc_configs_for_state(state, dm_state->context))
+		if (!compute_mst_dsc_configs_for_state(state, dm_state->context, vars))
 			goto fail;
 
-		ret = dm_update_mst_vcpi_slots_for_dsc(state, dm_state->context);
+		ret = dm_update_mst_vcpi_slots_for_dsc(state, dm_state->context, vars);
 		if (ret)
 			goto fail;
 #endif
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 705f2e67edb5..1a99fcc27078 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -518,12 +518,7 @@ struct dsc_mst_fairness_params {
 	uint32_t num_slices_h;
 	uint32_t num_slices_v;
 	uint32_t bpp_overwrite;
-};
-
-struct dsc_mst_fairness_vars {
-	int pbn;
-	bool dsc_enabled;
-	int bpp_x16;
+	struct amdgpu_dm_connector *aconnector;
 };
 
 static int kbps_to_peak_pbn(int kbps)
@@ -750,12 +745,12 @@ static void try_disable_dsc(struct drm_atomic_state *state,
 
 static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 					     struct dc_state *dc_state,
-					     struct dc_link *dc_link)
+					     struct dc_link *dc_link,
+					     struct dsc_mst_fairness_vars *vars)
 {
 	int i;
 	struct dc_stream_state *stream;
 	struct dsc_mst_fairness_params params[MAX_PIPES];
-	struct dsc_mst_fairness_vars vars[MAX_PIPES];
 	struct amdgpu_dm_connector *aconnector;
 	int count = 0;
 	bool debugfs_overwrite = false;
@@ -776,6 +771,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		params[count].timing = &stream->timing;
 		params[count].sink = stream->sink;
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
+		params[count].aconnector = aconnector;
 		params[count].port = aconnector->port;
 		params[count].clock_force_enable = aconnector->dsc_settings.dsc_force_enable;
 		if (params[count].clock_force_enable == DSC_CLK_FORCE_ENABLE)
@@ -798,6 +794,7 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	}
 	/* Try no compression */
 	for (i = 0; i < count; i++) {
+		vars[i].aconnector = params[i].aconnector;
 		vars[i].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 		vars[i].dsc_enabled = false;
 		vars[i].bpp_x16 = 0;
@@ -851,7 +848,8 @@ static bool compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 }
 
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state)
+				       struct dc_state *dc_state,
+				       struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
@@ -882,7 +880,7 @@ bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 			return false;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link)) {
+		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars)) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
 			return false;
 		}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b38bd68121ce..900d3f7a8498 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -39,8 +39,17 @@ void
 dm_dp_create_fake_mst_encoders(struct amdgpu_device *adev);
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
+
+struct dsc_mst_fairness_vars {
+	int pbn;
+	bool dsc_enabled;
+	int bpp_x16;
+	struct amdgpu_dm_connector *aconnector;
+};
+
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state);
+				       struct dc_state *dc_state,
+				       struct dsc_mst_fairness_vars *vars);
 #endif
 
 #endif

