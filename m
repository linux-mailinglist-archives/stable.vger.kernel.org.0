Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE8BFB86
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 00:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbfIZWwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 18:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbfIZWwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 18:52:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 983EF3082137;
        Thu, 26 Sep 2019 22:52:14 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-34.bss.redhat.com [10.20.1.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A144A600C1;
        Thu, 26 Sep 2019 22:52:10 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        David Francis <David.Francis@amd.com>,
        "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        Thomas Lim <Thomas.Lim@amd.com>,
        =?UTF-8?q?Mathias=20Fr=C3=B6hlich?= <Mathias.Froehlich@web.de>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        Dingchen Zhang <dingchen.zhang@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drm/amdgpu/dm/mst: Make MST encoders per-CRTC and fix encoder usage
Date:   Thu, 26 Sep 2019 18:51:06 -0400
Message-Id: <20190926225122.31455-5-lyude@redhat.com>
In-Reply-To: <20190926225122.31455-1-lyude@redhat.com>
References: <20190926225122.31455-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 26 Sep 2019 22:52:14 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While this commit certainly will result in creating less fake MST
encoders, the main purpose of this is actually to fix amdgpu's incorrect
usage of the drm_encoder API in it's MST code. Currently we create one
encoder per-MST connector. However, MST connectors can and usually do
get created at basically any point before or after driver device
registration. Thus, this means we've been creating and destroying
drm_encoder structs every time we create or destroy an MST connector.

This behavior likely is just leftover from when we made amdgpu stop
reusing DRM connectors for MST. Since this will definitely break things,
let's fix it by being a bit more efficient with our MST encoders by
creating one per-CRTC, which allows us to have just the right number of
encoders and do so before we've called drm_dev_register().

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 0e6613e46fed ("drm/amd/display: Drop reusing drm connector for MST")
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: David Francis <David.Francis@amd.com>
Cc: "Jerry (Fangzhi) Zuo" <Jerry.Zuo@amd.com>
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Thomas Lim <Thomas.Lim@amd.com>
Cc: "Mathias Fröhlich" <Mathias.Froehlich@web.de>
Cc: <stable@vger.kernel.org> # v4.20+
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h      |  3 ++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 +++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  1 -
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 28 ++++++++++---------
 .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  3 ++
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
index eb9975f4decb..b54a6f4e392e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
@@ -427,6 +427,9 @@ struct amdgpu_crtc {
 
 	int otg_inst;
 	struct drm_pending_vblank_event *event;
+
+	/* Fake encoder to use for MST */
+	struct amdgpu_encoder *mst_encoder;
 };
 
 struct amdgpu_encoder_atom_dig {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f4e0f27a76de..b404f1ae6df7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4803,6 +4803,10 @@ static int amdgpu_dm_crtc_init(struct amdgpu_display_manager *dm,
 				   true, MAX_COLOR_LUT_ENTRIES);
 	drm_mode_crtc_set_gamma_size(&acrtc->base, MAX_COLOR_LEGACY_LUT_ENTRIES);
 
+	acrtc->mst_encoder = amdgpu_dm_dp_create_fake_mst_encoder(acrtc);
+	if (!acrtc->mst_encoder)
+		goto fail;
+
 	return 0;
 
 fail:
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index c8c525a2b505..bcd9115c4923 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -267,7 +267,6 @@ struct amdgpu_dm_connector {
 	struct amdgpu_dm_dp_aux dm_dp_aux;
 	struct drm_dp_mst_port *port;
 	struct amdgpu_dm_connector *mst_port;
-	struct amdgpu_encoder *mst_encoder;
 
 	/* TODO see if we can merge with ddc_bus or make a dm_connector */
 	struct amdgpu_i2c_adapter *i2c;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index d9113ce0be09..d680f32cf625 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -141,14 +141,12 @@ dm_dp_mst_detect(struct drm_connector *connector, bool force)
 static void
 dm_dp_mst_connector_destroy(struct drm_connector *connector)
 {
-	struct amdgpu_dm_connector *amdgpu_dm_connector = to_amdgpu_dm_connector(connector);
-	struct amdgpu_encoder *amdgpu_encoder = amdgpu_dm_connector->mst_encoder;
+	struct amdgpu_dm_connector *amdgpu_dm_connector =
+		to_amdgpu_dm_connector(connector);
 
 	kfree(amdgpu_dm_connector->edid);
 	amdgpu_dm_connector->edid = NULL;
 
-	drm_encoder_cleanup(&amdgpu_encoder->base);
-	kfree(amdgpu_encoder);
 	drm_connector_cleanup(connector);
 	drm_dp_mst_put_port_malloc(amdgpu_dm_connector->port);
 	kfree(amdgpu_dm_connector);
@@ -247,7 +245,7 @@ static struct drm_encoder *
 dm_mst_atomic_best_encoder(struct drm_connector *connector,
 			   struct drm_connector_state *connector_state)
 {
-	return &to_amdgpu_dm_connector(connector)->mst_encoder->base;
+	return &to_amdgpu_crtc(connector_state->crtc)->mst_encoder->base;
 }
 
 static const struct drm_connector_helper_funcs dm_dp_mst_connector_helper_funcs = {
@@ -266,11 +264,10 @@ static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
 	.destroy = amdgpu_dm_encoder_destroy,
 };
 
-static struct amdgpu_encoder *
-dm_dp_create_fake_mst_encoder(struct amdgpu_dm_connector *connector)
+struct amdgpu_encoder *
+amdgpu_dm_dp_create_fake_mst_encoder(struct amdgpu_crtc *acrtc)
 {
-	struct drm_device *dev = connector->base.dev;
-	struct amdgpu_device *adev = dev->dev_private;
+	struct drm_device *dev = acrtc->base.dev;
 	struct amdgpu_encoder *amdgpu_encoder;
 	struct drm_encoder *encoder;
 
@@ -279,7 +276,7 @@ dm_dp_create_fake_mst_encoder(struct amdgpu_dm_connector *connector)
 		return NULL;
 
 	encoder = &amdgpu_encoder->base;
-	encoder->possible_crtcs = amdgpu_dm_get_encoder_crtc_mask(adev);
+	encoder->possible_crtcs = drm_crtc_mask(&acrtc->base);
 
 	drm_encoder_init(
 		dev,
@@ -302,6 +299,7 @@ dm_dp_add_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 	struct drm_device *dev = master->base.dev;
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_dm_connector *aconnector;
+	struct drm_crtc *crtc;
 	struct drm_connector *connector;
 
 	aconnector = kzalloc(sizeof(*aconnector), GFP_KERNEL);
@@ -329,9 +327,13 @@ dm_dp_add_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 		master->dc_link,
 		master->connector_id);
 
-	aconnector->mst_encoder = dm_dp_create_fake_mst_encoder(master);
-	drm_connector_attach_encoder(&aconnector->base,
-				     &aconnector->mst_encoder->base);
+	/* Attach fake MST encoders */
+	drm_for_each_crtc(crtc, dev) {
+		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(crtc);
+
+		drm_connector_attach_encoder(connector,
+					     &acrtc->mst_encoder->base);
+	}
 
 	drm_object_attach_property(
 		&connector->base,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index 2da851b40042..ce84d9db83e5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -28,8 +28,11 @@
 
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
+struct amdgpu_crtc;
 
 void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 				       struct amdgpu_dm_connector *aconnector);
+struct amdgpu_encoder *
+amdgpu_dm_dp_create_fake_mst_encoder(struct amdgpu_crtc *acrtc);
 
 #endif
-- 
2.21.0

