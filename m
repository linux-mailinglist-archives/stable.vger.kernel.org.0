Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2988B126B58
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfLSS4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbfLSSz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB85D24676;
        Thu, 19 Dec 2019 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781757;
        bh=l20x0N8iOE800no7wscCQ9zrDlT0O+piafAQgz+VTc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWxI4bTBWNpFTK7ZKxm0w/8mcR1FyMLsE8ZJs7TK7pCOf7bfB61AUKflYiR/d1ODn
         x3uizOuBupqBz5yhMcWSZ2iceEJH41VCXomd113Iuh/zBP5uVLFH/39cPP7DeccFlR
         2YcoKIw3DJ6IyEdHraCawPYH/hImPxgWXsdGuA/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.4 67/80] drm/nouveau/kms/nv50-: Store the bpc were using in nv50_head_atom
Date:   Thu, 19 Dec 2019 19:34:59 +0100
Message-Id: <20191219183138.336254526@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit ac2d9275f371346922b31a388bbaa6a54f1154a4 upstream.

In order to be able to use bpc values that are different from what the
connector reports, we want to be able to store the bpc value we decide
on using for an atomic state in nv50_head_atom and refer to that instead
of simply using the value that the connector reports throughout the
whole atomic check phase and commit phase. This will let us (eventually)
implement the max bpc connector property, and will also be needed for
limiting the bpc we use on MST displays to 8 in the next commit.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/atom.h |    1 
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   57 ++++++++++++++++++--------------
 drivers/gpu/drm/nouveau/dispnv50/head.c |    5 +-
 3 files changed, 36 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
@@ -114,6 +114,7 @@ struct nv50_head_atom {
 		u8 nhsync:1;
 		u8 nvsync:1;
 		u8 depth:4;
+		u8 bpc;
 	} or;
 
 	/* Currently only used for MST */
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -353,10 +353,20 @@ nv50_outp_atomic_check(struct drm_encode
 		       struct drm_crtc_state *crtc_state,
 		       struct drm_connector_state *conn_state)
 {
-	struct nouveau_connector *nv_connector =
-		nouveau_connector(conn_state->connector);
-	return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
-					   nv_connector->native_mode);
+	struct drm_connector *connector = conn_state->connector;
+	struct nouveau_connector *nv_connector = nouveau_connector(connector);
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	int ret;
+
+	ret = nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
+					  nv_connector->native_mode);
+	if (ret)
+		return ret;
+
+	if (crtc_state->mode_changed || crtc_state->connectors_changed)
+		asyh->or.bpc = connector->display_info.bpc;
+
+	return 0;
 }
 
 /******************************************************************************
@@ -786,10 +796,10 @@ nv50_msto_atomic_check(struct drm_encode
 	 * may have changed after the state was duplicated
 	 */
 	if (!state->duplicated) {
-		const int bpp = connector->display_info.bpc * 3;
 		const int clock = crtc_state->adjusted_mode.clock;
 
-		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, bpp);
+		asyh->or.bpc = connector->display_info.bpc;
+		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3);
 	}
 
 	slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
@@ -802,6 +812,17 @@ nv50_msto_atomic_check(struct drm_encode
 	return 0;
 }
 
+static u8
+nv50_dp_bpc_to_depth(unsigned int bpc)
+{
+	switch (bpc) {
+	case  6: return 0x2;
+	case  8: return 0x5;
+	case 10: /* fall-through */
+	default: return 0x6;
+	}
+}
+
 static void
 nv50_msto_enable(struct drm_encoder *encoder)
 {
@@ -812,7 +833,7 @@ nv50_msto_enable(struct drm_encoder *enc
 	struct nv50_mstm *mstm = NULL;
 	struct drm_connector *connector;
 	struct drm_connector_list_iter conn_iter;
-	u8 proto, depth;
+	u8 proto;
 	bool r;
 
 	drm_connector_list_iter_begin(encoder->dev, &conn_iter);
@@ -841,14 +862,8 @@ nv50_msto_enable(struct drm_encoder *enc
 	else
 		proto = 0x9;
 
-	switch (mstc->connector.display_info.bpc) {
-	case  6: depth = 0x2; break;
-	case  8: depth = 0x5; break;
-	case 10:
-	default: depth = 0x6; break;
-	}
-
-	mstm->outp->update(mstm->outp, head->base.index, armh, proto, depth);
+	mstm->outp->update(mstm->outp, head->base.index, armh, proto,
+			   nv50_dp_bpc_to_depth(armh->or.bpc));
 
 	msto->head = head;
 	msto->mstc = mstc;
@@ -1502,20 +1517,14 @@ nv50_sor_enable(struct drm_encoder *enco
 					lvds.lvds.script |= 0x0200;
 			}
 
-			if (nv_connector->base.display_info.bpc == 8)
+			if (asyh->or.bpc == 8)
 				lvds.lvds.script |= 0x0200;
 		}
 
 		nvif_mthd(&disp->disp->object, 0, &lvds, sizeof(lvds));
 		break;
 	case DCB_OUTPUT_DP:
-		if (nv_connector->base.display_info.bpc == 6)
-			depth = 0x2;
-		else
-		if (nv_connector->base.display_info.bpc == 8)
-			depth = 0x5;
-		else
-			depth = 0x6;
+		depth = nv50_dp_bpc_to_depth(asyh->or.bpc);
 
 		if (nv_encoder->link & 1)
 			proto = 0x8;
@@ -1666,7 +1675,7 @@ nv50_pior_enable(struct drm_encoder *enc
 	nv50_outp_acquire(nv_encoder);
 
 	nv_connector = nouveau_encoder_connector_get(nv_encoder);
-	switch (nv_connector->base.display_info.bpc) {
+	switch (asyh->or.bpc) {
 	case 10: asyh->or.depth = 0x6; break;
 	case  8: asyh->or.depth = 0x5; break;
 	case  6: asyh->or.depth = 0x2; break;
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -81,18 +81,17 @@ nv50_head_atomic_check_dither(struct nv5
 			      struct nv50_head_atom *asyh,
 			      struct nouveau_conn_atom *asyc)
 {
-	struct drm_connector *connector = asyc->state.connector;
 	u32 mode = 0x00;
 
 	if (asyc->dither.mode == DITHERING_MODE_AUTO) {
-		if (asyh->base.depth > connector->display_info.bpc * 3)
+		if (asyh->base.depth > asyh->or.bpc * 3)
 			mode = DITHERING_MODE_DYNAMIC2X2;
 	} else {
 		mode = asyc->dither.mode;
 	}
 
 	if (asyc->dither.depth == DITHERING_DEPTH_AUTO) {
-		if (connector->display_info.bpc >= 8)
+		if (asyh->or.bpc >= 8)
 			mode |= DITHERING_DEPTH_8BPC;
 	} else {
 		mode |= asyc->dither.depth;


