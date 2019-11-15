Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F702FE6D3
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 22:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKOVH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 16:07:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbfKOVH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 16:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573852076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HmOhCKKMWRxv4wemJ97qJrxNMoZbSfaKT4swvCCkCRQ=;
        b=WavH8sfasAG7JBglvmAPsAlMSNT+DTowGLW39n+7Q5A4B3ab+RlcE5BhjJSpuMxQFyBCdR
        yhHO7A9awC5G71/wZ02PpKdAvjGarfEsW9i8whGGNCgWq2zNe0T6Id9UI6ueYicZ2+WFcx
        JNetI7dVFI2v9tZkD76kp2xcIIV3z54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-Xdi1G-7AOfe_K69KOqKFXQ-1; Fri, 15 Nov 2019 16:07:55 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B1282F29;
        Fri, 15 Nov 2019 21:07:52 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAC4E69191;
        Fri, 15 Nov 2019 21:07:50 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Peteris Rudzusiks <peteris.rudzusiks@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drm/nouveau/kms/nv50-: Store the bpc we're using in nv50_head_atom
Date:   Fri, 15 Nov 2019 16:07:19 -0500
Message-Id: <20191115210728.3467-3-lyude@redhat.com>
In-Reply-To: <20191115210728.3467-1-lyude@redhat.com>
References: <20191115210728.3467-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Xdi1G-7AOfe_K69KOqKFXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/nouveau/dispnv50/atom.h |  1 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 57 ++++++++++++++-----------
 drivers/gpu/drm/nouveau/dispnv50/head.c |  5 +--
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/atom.h b/drivers/gpu/drm/nouv=
eau/dispnv50/atom.h
index 43df86c38f58..24f7700768da 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
@@ -114,6 +114,7 @@ struct nv50_head_atom {
 =09=09u8 nhsync:1;
 =09=09u8 nvsync:1;
 =09=09u8 depth:4;
+=09=09u8 bpc;
 =09} or;
=20
 =09/* Currently only used for MST */
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouv=
eau/dispnv50/disp.c
index 6327aaf37c08..93665aecce57 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -353,10 +353,20 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
 =09=09       struct drm_crtc_state *crtc_state,
 =09=09       struct drm_connector_state *conn_state)
 {
-=09struct nouveau_connector *nv_connector =3D
-=09=09nouveau_connector(conn_state->connector);
-=09return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
-=09=09=09=09=09   nv_connector->native_mode);
+=09struct drm_connector *connector =3D conn_state->connector;
+=09struct nouveau_connector *nv_connector =3D nouveau_connector(connector)=
;
+=09struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
+=09int ret;
+
+=09ret =3D nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
+=09=09=09=09=09  nv_connector->native_mode);
+=09if (ret)
+=09=09return ret;
+
+=09if (crtc_state->mode_changed || crtc_state->connectors_changed)
+=09=09asyh->or.bpc =3D connector->display_info.bpc;
+
+=09return 0;
 }
=20
 /*************************************************************************=
*****
@@ -786,10 +796,10 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 =09 * may have changed after the state was duplicated
 =09 */
 =09if (!state->duplicated) {
-=09=09const int bpp =3D connector->display_info.bpc * 3;
 =09=09const int clock =3D crtc_state->adjusted_mode.clock;
=20
-=09=09asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
+=09=09asyh->or.bpc =3D connector->display_info.bpc;
+=09=09asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3);
 =09}
=20
 =09slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
@@ -802,6 +812,17 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 =09return 0;
 }
=20
+static u8
+nv50_dp_bpc_to_depth(unsigned int bpc)
+{
+=09switch (bpc) {
+=09case  6: return 0x2;
+=09case  8: return 0x5;
+=09case 10: /* fall-through */
+=09default: return 0x6;
+=09}
+}
+
 static void
 nv50_msto_enable(struct drm_encoder *encoder)
 {
@@ -812,7 +833,7 @@ nv50_msto_enable(struct drm_encoder *encoder)
 =09struct nv50_mstm *mstm =3D NULL;
 =09struct drm_connector *connector;
 =09struct drm_connector_list_iter conn_iter;
-=09u8 proto, depth;
+=09u8 proto;
 =09bool r;
=20
 =09drm_connector_list_iter_begin(encoder->dev, &conn_iter);
@@ -841,14 +862,8 @@ nv50_msto_enable(struct drm_encoder *encoder)
 =09else
 =09=09proto =3D 0x9;
=20
-=09switch (mstc->connector.display_info.bpc) {
-=09case  6: depth =3D 0x2; break;
-=09case  8: depth =3D 0x5; break;
-=09case 10:
-=09default: depth =3D 0x6; break;
-=09}
-
-=09mstm->outp->update(mstm->outp, head->base.index, armh, proto, depth);
+=09mstm->outp->update(mstm->outp, head->base.index, armh, proto,
+=09=09=09   nv50_dp_bpc_to_depth(armh->or.bpc));
=20
 =09msto->head =3D head;
 =09msto->mstc =3D mstc;
@@ -1502,20 +1517,14 @@ nv50_sor_enable(struct drm_encoder *encoder)
 =09=09=09=09=09lvds.lvds.script |=3D 0x0200;
 =09=09=09}
=20
-=09=09=09if (nv_connector->base.display_info.bpc =3D=3D 8)
+=09=09=09if (asyh->or.bpc =3D=3D 8)
 =09=09=09=09lvds.lvds.script |=3D 0x0200;
 =09=09}
=20
 =09=09nvif_mthd(&disp->disp->object, 0, &lvds, sizeof(lvds));
 =09=09break;
 =09case DCB_OUTPUT_DP:
-=09=09if (nv_connector->base.display_info.bpc =3D=3D 6)
-=09=09=09depth =3D 0x2;
-=09=09else
-=09=09if (nv_connector->base.display_info.bpc =3D=3D 8)
-=09=09=09depth =3D 0x5;
-=09=09else
-=09=09=09depth =3D 0x6;
+=09=09depth =3D nv50_dp_bpc_to_depth(asyh->or.bpc);
=20
 =09=09if (nv_encoder->link & 1)
 =09=09=09proto =3D 0x8;
@@ -1666,7 +1675,7 @@ nv50_pior_enable(struct drm_encoder *encoder)
 =09nv50_outp_acquire(nv_encoder);
=20
 =09nv_connector =3D nouveau_encoder_connector_get(nv_encoder);
-=09switch (nv_connector->base.display_info.bpc) {
+=09switch (asyh->or.bpc) {
 =09case 10: asyh->or.depth =3D 0x6; break;
 =09case  8: asyh->or.depth =3D 0x5; break;
 =09case  6: asyh->or.depth =3D 0x2; break;
diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouv=
eau/dispnv50/head.c
index 71c23bf1fe25..c9692df2b76c 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -81,18 +81,17 @@ nv50_head_atomic_check_dither(struct nv50_head_atom *ar=
mh,
 =09=09=09      struct nv50_head_atom *asyh,
 =09=09=09      struct nouveau_conn_atom *asyc)
 {
-=09struct drm_connector *connector =3D asyc->state.connector;
 =09u32 mode =3D 0x00;
=20
 =09if (asyc->dither.mode =3D=3D DITHERING_MODE_AUTO) {
-=09=09if (asyh->base.depth > connector->display_info.bpc * 3)
+=09=09if (asyh->base.depth > asyh->or.bpc * 3)
 =09=09=09mode =3D DITHERING_MODE_DYNAMIC2X2;
 =09} else {
 =09=09mode =3D asyc->dither.mode;
 =09}
=20
 =09if (asyc->dither.depth =3D=3D DITHERING_DEPTH_AUTO) {
-=09=09if (connector->display_info.bpc >=3D 8)
+=09=09if (asyh->or.bpc >=3D 8)
 =09=09=09mode |=3D DITHERING_DEPTH_8BPC;
 =09} else {
 =09=09mode |=3D asyc->dither.depth;
--=20
2.21.0

