Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9AA2267EE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388469AbgGTQPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387764AbgGTQPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BFD2064B;
        Mon, 20 Jul 2020 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261749;
        bh=9wHZUEjyitt2CLHFphPNMO07/RHRbHsKt/XDSCoF6c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+1DZGAN+crfqPDbsucTX7b0cftaKk9sXuibj3GsRMhIfBWIAhw5xe8MHEFk0QY9a
         vKjQIUfOFRdK3ezv5AbzS+cR28gLdUPev1/GAGrTG+e+CreRLaMlfxC4rDrpgK3HMQ
         Kk+xGMNaPko0npOQPSfSXW7fhJWyhZJ+UV2bUhhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 228/244] drm/amdgpu/display: create fake mst encoders ahead of time (v4)
Date:   Mon, 20 Jul 2020 17:38:19 +0200
Message-Id: <20200720152836.689291888@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 3168470142e0a82b5732c04ed4c031a9322ae170 upstream.

Prevents a warning in the MST create connector case.

v2: create global fake encoders rather per connector fake encoders
to avoid running out of encoder indices.

v3: use the actual number of crtcs on the asic rather than the max
to conserve encoders.

v4: v3 plus missing hunk I forgot to git add.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1108
Fixes: c6385e503aeaf9 ("drm/amdgpu: drop legacy drm load and unload callbacks")
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    9 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h           |   11 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |   57 +++++-------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |    3 
 4 files changed, 50 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -956,6 +956,9 @@ static int amdgpu_dm_init(struct amdgpu_
 	/* Update the actual used number of crtc */
 	adev->mode_info.num_crtc = adev->dm.display_indexes_num;
 
+	/* create fake encoders for MST */
+	dm_dp_create_fake_mst_encoders(adev);
+
 	/* TODO: Add_display_info? */
 
 	/* TODO use dynamic cursor width */
@@ -979,6 +982,12 @@ error:
 
 static void amdgpu_dm_fini(struct amdgpu_device *adev)
 {
+	int i;
+
+	for (i = 0; i < adev->dm.display_indexes_num; i++) {
+		drm_encoder_cleanup(&adev->dm.mst_encoders[i].base);
+	}
+
 	amdgpu_dm_audio_fini(adev);
 
 	amdgpu_dm_destroy_drm_device(&adev->dm);
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -43,6 +43,9 @@
  */
 
 #define AMDGPU_DM_MAX_DISPLAY_INDEX 31
+
+#define AMDGPU_DM_MAX_CRTC 6
+
 /*
 #include "include/amdgpu_dal_power_if.h"
 #include "amdgpu_dm_irq.h"
@@ -327,6 +330,13 @@ struct amdgpu_display_manager {
 	 * available in FW
 	 */
 	const struct gpu_info_soc_bounding_box_v1_0 *soc_bounding_box;
+
+	/**
+	 * @mst_encoders:
+	 *
+	 * fake encoders used for DP MST.
+	 */
+	struct amdgpu_encoder mst_encoders[AMDGPU_DM_MAX_CRTC];
 };
 
 struct amdgpu_dm_connector {
@@ -355,7 +365,6 @@ struct amdgpu_dm_connector {
 	struct amdgpu_dm_dp_aux dm_dp_aux;
 	struct drm_dp_mst_port *port;
 	struct amdgpu_dm_connector *mst_port;
-	struct amdgpu_encoder *mst_encoder;
 	struct drm_dp_aux *dsc_aux;
 
 	/* TODO see if we can merge with ddc_bus or make a dm_connector */
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -137,13 +137,10 @@ static void
 dm_dp_mst_connector_destroy(struct drm_connector *connector)
 {
 	struct amdgpu_dm_connector *amdgpu_dm_connector = to_amdgpu_dm_connector(connector);
-	struct amdgpu_encoder *amdgpu_encoder = amdgpu_dm_connector->mst_encoder;
 
 	kfree(amdgpu_dm_connector->edid);
 	amdgpu_dm_connector->edid = NULL;
 
-	drm_encoder_cleanup(&amdgpu_encoder->base);
-	kfree(amdgpu_encoder);
 	drm_connector_cleanup(connector);
 	drm_dp_mst_put_port_malloc(amdgpu_dm_connector->port);
 	kfree(amdgpu_dm_connector);
@@ -280,7 +277,11 @@ static struct drm_encoder *
 dm_mst_atomic_best_encoder(struct drm_connector *connector,
 			   struct drm_connector_state *connector_state)
 {
-	return &to_amdgpu_dm_connector(connector)->mst_encoder->base;
+	struct drm_device *dev = connector->dev;
+	struct amdgpu_device *adev = dev->dev_private;
+	struct amdgpu_crtc *acrtc = to_amdgpu_crtc(connector_state->crtc);
+
+	return &adev->dm.mst_encoders[acrtc->crtc_id].base;
 }
 
 static int
@@ -343,31 +344,27 @@ static const struct drm_encoder_funcs am
 	.destroy = amdgpu_dm_encoder_destroy,
 };
 
-static struct amdgpu_encoder *
-dm_dp_create_fake_mst_encoder(struct amdgpu_dm_connector *connector)
+void
+dm_dp_create_fake_mst_encoders(struct amdgpu_device *adev)
 {
-	struct drm_device *dev = connector->base.dev;
-	struct amdgpu_device *adev = dev->dev_private;
-	struct amdgpu_encoder *amdgpu_encoder;
-	struct drm_encoder *encoder;
-
-	amdgpu_encoder = kzalloc(sizeof(*amdgpu_encoder), GFP_KERNEL);
-	if (!amdgpu_encoder)
-		return NULL;
+	struct drm_device *dev = adev->ddev;
+	int i;
 
-	encoder = &amdgpu_encoder->base;
-	encoder->possible_crtcs = amdgpu_dm_get_encoder_crtc_mask(adev);
+	for (i = 0; i < adev->dm.display_indexes_num; i++) {
+		struct amdgpu_encoder *amdgpu_encoder = &adev->dm.mst_encoders[i];
+		struct drm_encoder *encoder = &amdgpu_encoder->base;
+
+		encoder->possible_crtcs = amdgpu_dm_get_encoder_crtc_mask(adev);
+
+		drm_encoder_init(
+			dev,
+			&amdgpu_encoder->base,
+			&amdgpu_dm_encoder_funcs,
+			DRM_MODE_ENCODER_DPMST,
+			NULL);
 
-	drm_encoder_init(
-		dev,
-		&amdgpu_encoder->base,
-		&amdgpu_dm_encoder_funcs,
-		DRM_MODE_ENCODER_DPMST,
-		NULL);
-
-	drm_encoder_helper_add(encoder, &amdgpu_dm_encoder_helper_funcs);
-
-	return amdgpu_encoder;
+		drm_encoder_helper_add(encoder, &amdgpu_dm_encoder_helper_funcs);
+	}
 }
 
 static struct drm_connector *
@@ -380,6 +377,7 @@ dm_dp_add_mst_connector(struct drm_dp_ms
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_connector *connector;
+	int i;
 
 	aconnector = kzalloc(sizeof(*aconnector), GFP_KERNEL);
 	if (!aconnector)
@@ -406,9 +404,10 @@ dm_dp_add_mst_connector(struct drm_dp_ms
 		master->dc_link,
 		master->connector_id);
 
-	aconnector->mst_encoder = dm_dp_create_fake_mst_encoder(master);
-	drm_connector_attach_encoder(&aconnector->base,
-				     &aconnector->mst_encoder->base);
+	for (i = 0; i < adev->dm.display_indexes_num; i++) {
+		drm_connector_attach_encoder(&aconnector->base,
+					     &adev->dm.mst_encoders[i].base);
+	}
 
 	connector->max_bpc_property = master->base.max_bpc_property;
 	if (connector->max_bpc_property)
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -35,6 +35,9 @@ void amdgpu_dm_initialize_dp_connector(s
 				       struct amdgpu_dm_connector *aconnector,
 				       int link_index);
 
+void
+dm_dp_create_fake_mst_encoders(struct amdgpu_device *adev);
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 bool compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 				       struct dc_state *dc_state);


