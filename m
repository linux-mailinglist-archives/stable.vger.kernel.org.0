Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E8927DC12
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 00:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgI2Wbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 18:31:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728124AbgI2Wbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 18:31:50 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601418708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YkwAgkWJX6QtzYei4hnlo1IwT6pmSKXCDsQMxV6UrsY=;
        b=HSVGdASkINHCgITuqAFMQ8CmahMd9uNzK28zQETI2FqHfDb4wWWSW49Oj50kex0vmXEaJO
        VqLM6yOHrpNH0Pt5saabJlGVDZ+QlO7m5Af0YsNrJnI+7HCAVPnDsds6M9DLTqxflomznK
        HZzhEkpb6CXKiwFeoMe8mEQM/nBhWvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-KEqnqiKPMZi0DBO_wJHiSA-1; Tue, 29 Sep 2020 18:31:44 -0400
X-MC-Unique: KEqnqiKPMZi0DBO_wJHiSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 144AE1018F63;
        Tue, 29 Sep 2020 22:31:43 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-121-117.rdu2.redhat.com [10.10.121.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BD355775;
        Tue, 29 Sep 2020 22:31:41 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()
Date:   Tue, 29 Sep 2020 18:31:31 -0400
Message-Id: <20200929223132.333453-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ville also pointed out that I got a lot of the logic here wrong as well, whoops.
While I don't think anyone's likely using 3D output with nouveau, the next patch
will make nouveau_conn_mode_valid() make a lot less sense. So, let's just get
rid of it and open-code it like before, while taking care to move the 3D frame
packing calculations on the dot clock into the right place.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d6a9efece724 ("drm/nouveau/kms/nv50-: Share DP SST mode_valid() handling with MST")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 36 ++++++---------------
 drivers/gpu/drm/nouveau/nouveau_dp.c        | 16 ++++++---
 2 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 49dd0cbc332f..6f21f36719fc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1023,29 +1023,6 @@ get_tmds_link_bandwidth(struct drm_connector *connector)
 		return 112000 * duallink_scale;
 }
 
-enum drm_mode_status
-nouveau_conn_mode_clock_valid(const struct drm_display_mode *mode,
-			      const unsigned min_clock,
-			      const unsigned max_clock,
-			      unsigned int *clock_out)
-{
-	unsigned int clock = mode->clock;
-
-	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) ==
-	    DRM_MODE_FLAG_3D_FRAME_PACKING)
-		clock *= 2;
-
-	if (clock < min_clock)
-		return MODE_CLOCK_LOW;
-	if (clock > max_clock)
-		return MODE_CLOCK_HIGH;
-
-	if (clock_out)
-		*clock_out = clock;
-
-	return MODE_OK;
-}
-
 static enum drm_mode_status
 nouveau_connector_mode_valid(struct drm_connector *connector,
 			     struct drm_display_mode *mode)
@@ -1053,7 +1030,7 @@ nouveau_connector_mode_valid(struct drm_connector *connector,
 	struct nouveau_connector *nv_connector = nouveau_connector(connector);
 	struct nouveau_encoder *nv_encoder = nv_connector->detected_encoder;
 	struct drm_encoder *encoder = to_drm_encoder(nv_encoder);
-	unsigned min_clock = 25000, max_clock = min_clock;
+	unsigned int min_clock = 25000, max_clock = min_clock, clock = mode->clock;
 
 	switch (nv_encoder->dcb->type) {
 	case DCB_OUTPUT_LVDS:
@@ -1082,8 +1059,15 @@ nouveau_connector_mode_valid(struct drm_connector *connector,
 		return MODE_BAD;
 	}
 
-	return nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
-					     NULL);
+	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
+		clock *= 2;
+
+	if (clock < min_clock)
+		return MODE_CLOCK_LOW;
+	if (clock > max_clock)
+		return MODE_CLOCK_HIGH;
+
+	return MODE_OK;
 }
 
 static struct drm_encoder *
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 7b640e05bd4c..93e3751ad7f1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -232,12 +232,14 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 		   unsigned *out_clock)
 {
 	const unsigned min_clock = 25000;
-	unsigned max_clock, ds_clock, clock;
-	enum drm_mode_status ret;
+	unsigned max_clock, ds_clock, clock = mode->clock;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
 
+	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
+		clock *= 2;
+
 	max_clock = outp->dp.link_nr * outp->dp.link_bw;
 	ds_clock = drm_dp_downstream_max_dotclock(outp->dp.dpcd,
 						  outp->dp.downstream_ports);
@@ -245,9 +247,13 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 		max_clock = min(max_clock, ds_clock);
 
 	clock = mode->clock * (connector->display_info.bpc * 3) / 10;
-	ret = nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
-					    &clock);
+	if (clock < min_clock)
+		return MODE_CLOCK_LOW;
+	if (clock > max_clock)
+		return MODE_CLOCK_HIGH;
+
 	if (out_clock)
 		*out_clock = clock;
-	return ret;
+
+	return MODE_OK;
 }
-- 
2.26.2

