Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A622ABA4B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732096AbgKINRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387600AbgKINRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279A1206D8;
        Mon,  9 Nov 2020 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927850;
        bh=k+ciKGmdAaWHmNFCpirppe+yWEkX+BhcNsI0sA/QUvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVcebLvNIntlg6M6CMnMYYZ9LyDEBRpXVmmgoGM836Ji4rvTLVCU6am8F3eF5TGnG
         OoV1Dp7XOcC78XQ/zuvCcfj6xcXuu0aOIHfPt+L4J1IorrrlcMWBL+xoNahMRSpAbq
         ZGCImh0UXM41EdNGWenjPR9v5J9gFBzqJGvrBhXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.9 043/133] drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()
Date:   Mon,  9 Nov 2020 13:55:05 +0100
Message-Id: <20201109125032.780880244@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 2d831155cf0607566e43d8465da33774b2dc7221 upstream.

Ville also pointed out that I got a lot of the logic here wrong as well, whoops.
While I don't think anyone's likely using 3D output with nouveau, the next patch
will make nouveau_conn_mode_valid() make a lot less sense. So, let's just get
rid of it and open-code it like before, while taking care to move the 3D frame
packing calculations on the dot clock into the right place.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: d6a9efece724 ("drm/nouveau/kms/nv50-: Share DP SST mode_valid() handling with MST")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_connector.c |   36 +++++++---------------------
 drivers/gpu/drm/nouveau/nouveau_dp.c        |   15 +++++++----
 2 files changed, 20 insertions(+), 31 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1035,29 +1035,6 @@ get_tmds_link_bandwidth(struct drm_conne
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
@@ -1065,7 +1042,7 @@ nouveau_connector_mode_valid(struct drm_
 	struct nouveau_connector *nv_connector = nouveau_connector(connector);
 	struct nouveau_encoder *nv_encoder = nv_connector->detected_encoder;
 	struct drm_encoder *encoder = to_drm_encoder(nv_encoder);
-	unsigned min_clock = 25000, max_clock = min_clock;
+	unsigned int min_clock = 25000, max_clock = min_clock, clock = mode->clock;
 
 	switch (nv_encoder->dcb->type) {
 	case DCB_OUTPUT_LVDS:
@@ -1094,8 +1071,15 @@ nouveau_connector_mode_valid(struct drm_
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
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -114,18 +114,23 @@ nv50_dp_mode_valid(struct drm_connector
 		   unsigned *out_clock)
 {
 	const unsigned min_clock = 25000;
-	unsigned max_clock, clock;
-	enum drm_mode_status ret;
+	unsigned max_clock, clock = mode->clock;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
 
+	if ((mode->flags & DRM_MODE_FLAG_3D_MASK) == DRM_MODE_FLAG_3D_FRAME_PACKING)
+		clock *= 2;
+
 	max_clock = outp->dp.link_nr * outp->dp.link_bw;
 	clock = mode->clock * (connector->display_info.bpc * 3) / 10;
+	if (clock < min_clock)
+		return MODE_CLOCK_LOW;
+	if (clock > max_clock)
+		return MODE_CLOCK_HIGH;
 
-	ret = nouveau_conn_mode_clock_valid(mode, min_clock, max_clock,
-					    &clock);
 	if (out_clock)
 		*out_clock = clock;
-	return ret;
+
+	return MODE_OK;
 }


