Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4874124D3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381525AbhITSia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346515AbhITSgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA9D63328;
        Mon, 20 Sep 2021 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158957;
        bh=ed9cXxt/vhkXSggDU989xkBMUm6E0abFzXDqamQdFIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7v6Q8pVxRYv5WGsGHLuP7OS0IQi2WOnSJ6FqujCNYv+4uyJbFkAfYpFDEH+dB9PH
         c7bGRWfV/OC3GEciAetolqxdG1ZGeyTvBoYAIAjkp+JYTIYiSOQILSqHQpQ5tAPxPS
         jfD0Tuax+htD+vIdtt5qXkLKmlxkQknSrf6MjiSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Foster <Scott.Foster@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Hersen Wu <hersenwu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 011/168] drm/amd/display: dsc mst 2 4K displays go dark with 2 lane HBR3
Date:   Mon, 20 Sep 2021 18:42:29 +0200
Message-Id: <20210920163922.024666197@linuxfoundation.org>
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

From: Hersen Wu <hersenwu@amd.com>

commit 90517c9838602846daa0feec7b37382fed61b001 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   22 ++++++++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   18 ++++-----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |   11 +++++-
 3 files changed, 34 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6778,14 +6778,15 @@ const struct drm_encoder_helper_funcs am
 
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
@@ -6824,9 +6825,15 @@ static int dm_update_mst_vcpi_slots_for_
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
@@ -10208,6 +10215,9 @@ static int amdgpu_dm_atomic_check(struct
 	int ret, i;
 	bool lock_and_validation_needed = false;
 	struct dm_crtc_state *dm_old_crtc_state;
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct dsc_mst_fairness_vars vars[MAX_PIPES];
+#endif
 
 	trace_amdgpu_dm_atomic_check_begin(state);
 
@@ -10438,10 +10448,10 @@ static int amdgpu_dm_atomic_check(struct
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
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -495,12 +495,7 @@ struct dsc_mst_fairness_params {
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
@@ -727,12 +722,12 @@ static void try_disable_dsc(struct drm_a
 
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
@@ -753,6 +748,7 @@ static bool compute_mst_dsc_configs_for_
 		params[count].timing = &stream->timing;
 		params[count].sink = stream->sink;
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
+		params[count].aconnector = aconnector;
 		params[count].port = aconnector->port;
 		params[count].clock_force_enable = aconnector->dsc_settings.dsc_force_enable;
 		if (params[count].clock_force_enable == DSC_CLK_FORCE_ENABLE)
@@ -775,6 +771,7 @@ static bool compute_mst_dsc_configs_for_
 	}
 	/* Try no compression */
 	for (i = 0; i < count; i++) {
+		vars[i].aconnector = params[i].aconnector;
 		vars[i].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
 		vars[i].dsc_enabled = false;
 		vars[i].bpp_x16 = 0;
@@ -828,7 +825,8 @@ static bool compute_mst_dsc_configs_for_
 }
 
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
-				       struct dc_state *dc_state)
+				       struct dc_state *dc_state,
+				       struct dsc_mst_fairness_vars *vars)
 {
 	int i, j;
 	struct dc_stream_state *stream;
@@ -859,7 +857,7 @@ bool compute_mst_dsc_configs_for_state(s
 			return false;
 
 		mutex_lock(&aconnector->mst_mgr.lock);
-		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link)) {
+		if (!compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars)) {
 			mutex_unlock(&aconnector->mst_mgr.lock);
 			return false;
 		}
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


