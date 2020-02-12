Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DCA15B43C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgBLXBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 18:01:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58533 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729225AbgBLXBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 18:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581548466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7ssd3WUg57xOpsdw6H7Y8SPEq2D0xhwPC+MXaKd81Y=;
        b=f02/7MQusYBrbvu24ihhaqbAWazCuK06FY1o49KZ943sw4dw5AtIcfwgFtilaLrrkFu6MO
        zeVAUsn1GQqXhsn7PfVOx/g+ps6InQXEljLLskeQnisyNiC0th2GZs6wmGu5vwx7lRCzNl
        eirmb1wEeURdgnH0/seNMSo9V0IXny0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-KAfS8exQMqun0Pn3GMSzMg-1; Wed, 12 Feb 2020 18:00:52 -0500
X-MC-Unique: KAfS8exQMqun0Pn3GMSzMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8117800D48;
        Wed, 12 Feb 2020 23:00:50 +0000 (UTC)
Received: from Ruby.bss.redhat.com (dhcp-10-20-1-196.bss.redhat.com [10.20.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E6A15C109;
        Wed, 12 Feb 2020 23:00:49 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Takashi Iwai <tiwai@suse.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drm/nouveau/kms/nv50-: Probe SOR caps for DP interlacing support
Date:   Wed, 12 Feb 2020 18:00:35 -0500
Message-Id: <20200212230043.170477-2-lyude@redhat.com>
In-Reply-To: <20200212230043.170477-1-lyude@redhat.com>
References: <20200212230043.170477-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Right now, we make the mistake of allowing interlacing on all
connectors. Nvidia hardware does not always support interlacing with DP
though, so we need to make sure that we don't allow interlaced modes to
be set in such situations as otherwise we'll end up accidentally hanging
the display HW.

This fixes some hangs with Turing, which would be caused by attempting
to set an interlaced mode on hardware that doesn't support it. This
patch likely fixes other hardware hanging in the same way as well.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c     | 21 ++++++++++++++-------
 drivers/gpu/drm/nouveau/nouveau_connector.c | 10 +++++++++-
 drivers/gpu/drm/nouveau/nouveau_encoder.h   |  3 +++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
index a3dc2ba19fb2..32a1c4221f1e 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1714,6 +1714,9 @@ nv50_sor_create(struct drm_connector *connector, st=
ruct dcb_output *dcbe)
 		struct nv50_disp *disp =3D nv50_disp(encoder->dev);
 		struct nvkm_i2c_aux *aux =3D
 			nvkm_i2c_aux_find(i2c, dcbe->i2c_index);
+		u32 caps =3D nvif_rd32(&disp->disp->object,
+				     0x00640144 + (nv_encoder->or * 8));
+
 		if (aux) {
 			if (disp->disp->object.oclass < GF110_DISP) {
 				/* HW has no support for address-only
@@ -1727,13 +1730,17 @@ nv50_sor_create(struct drm_connector *connector, =
struct dcb_output *dcbe)
 			nv_encoder->aux =3D aux;
 		}
=20
-		if (nv_connector->type !=3D DCB_CONNECTOR_eDP &&
-		    nv50_has_mst(drm)) {
-			ret =3D nv50_mstm_new(nv_encoder, &nv_connector->aux,
-					    16, nv_connector->base.base.id,
-					    &nv_encoder->dp.mstm);
-			if (ret)
-				return ret;
+		if (nv_connector->type !=3D DCB_CONNECTOR_eDP) {
+			if (nv50_has_mst(drm)) {
+				ret =3D nv50_mstm_new(nv_encoder,
+						    &nv_connector->aux,
+						    16,
+						    connector->base.id,
+						    &nv_encoder->dp.mstm);
+				if (ret)
+					return ret;
+			}
+			nv_encoder->dp.caps.interlace =3D !!(caps & 0x04000000);
 		}
 	} else {
 		struct nvkm_i2c_bus *bus =3D
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/dr=
m/nouveau/nouveau_connector.c
index 9a9a7f5003d3..97a84daf8eab 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -509,7 +509,11 @@ nouveau_connector_set_encoder(struct drm_connector *=
connector,
 	nv_connector->detected_encoder =3D nv_encoder;
=20
 	if (drm->client.device.info.family >=3D NV_DEVICE_INFO_V0_TESLA) {
-		connector->interlace_allowed =3D true;
+		if (nv_encoder->dcb->type =3D=3D DCB_OUTPUT_DP)
+			connector->interlace_allowed =3D
+				nv_encoder->dp.caps.interlace;
+		else
+			connector->interlace_allowed =3D true;
 		connector->doublescan_allowed =3D true;
 	} else
 	if (nv_encoder->dcb->type =3D=3D DCB_OUTPUT_LVDS ||
@@ -1060,6 +1064,10 @@ nouveau_connector_mode_valid(struct drm_connector =
*connector,
 	case DCB_OUTPUT_TV:
 		return get_slave_funcs(encoder)->mode_valid(encoder, mode);
 	case DCB_OUTPUT_DP:
+		if (mode->flags & DRM_MODE_FLAG_INTERLACE &&
+		    !nv_encoder->dp.caps.interlace)
+			return MODE_NO_INTERLACE;
+
 		max_clock  =3D nv_encoder->dp.link_nr;
 		max_clock *=3D nv_encoder->dp.link_bw;
 		clock =3D clock * (connector->display_info.bpc * 3) / 10;
diff --git a/drivers/gpu/drm/nouveau/nouveau_encoder.h b/drivers/gpu/drm/=
nouveau/nouveau_encoder.h
index 3517f920bf89..2a8a7aec48c4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_encoder.h
+++ b/drivers/gpu/drm/nouveau/nouveau_encoder.h
@@ -63,6 +63,9 @@ struct nouveau_encoder {
 			struct nv50_mstm *mstm;
 			int link_nr;
 			int link_bw;
+			struct {
+				bool interlace : 1;
+			} caps;
 		} dp;
 	};
=20
--=20
2.24.1

