Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E0FE6CE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 22:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKOVHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 16:07:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26652 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726599AbfKOVHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 16:07:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573852072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99C9DdpWoNeWvAM/k6T9CAEG7JR/+DsOeDA4+LGqn/w=;
        b=Kn/sU9wgk7IZcn/+qNKFYG/B+PuQl1IcHS8V2dfm21d07tOuE/RJl9AccrokJ66w6GQzbe
        1P5piIXH3fyD2Tk4SH5+JhWQLU605J10MUXK5d6lXMTEjUfOjKQ+rFl2D+WfI5dVAQsD10
        MIlXCRIvW+gQq08pcIh5MLq4gTwhVUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-MredWJhJMy6M4kxd31DseA-1; Fri, 15 Nov 2019 16:07:50 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E790800686;
        Fri, 15 Nov 2019 21:07:46 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A534169191;
        Fri, 15 Nov 2019 21:07:43 +0000 (UTC)
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
        Sam Ravnborg <sam@ravnborg.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drm/nouveau/kms/nv50-: Call outp_atomic_check_view() before handling PBN
Date:   Fri, 15 Nov 2019 16:07:18 -0500
Message-Id: <20191115210728.3467-2-lyude@redhat.com>
In-Reply-To: <20191115210728.3467-1-lyude@redhat.com>
References: <20191115210728.3467-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: MredWJhJMy6M4kxd31DseA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since nv50_outp_atomic_check_view() can set crtc_state->mode_changed, we
probably should be calling it before handling any PBN changes. Just a
precaution.

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
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 44 ++++++++++++++-----------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouv=
eau/dispnv50/disp.c
index 549486f1d937..6327aaf37c08 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -770,32 +770,36 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 =09struct nv50_mstm *mstm =3D mstc->mstm;
 =09struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
 =09int slots;
+=09int ret;
=20
-=09if (crtc_state->mode_changed || crtc_state->connectors_changed) {
-=09=09/*
-=09=09 * When restoring duplicated states, we need to make sure that
-=09=09 * the bw remains the same and avoid recalculating it, as the
-=09=09 * connector's bpc may have changed after the state was
-=09=09 * duplicated
-=09=09 */
-=09=09if (!state->duplicated) {
-=09=09=09const int bpp =3D connector->display_info.bpc * 3;
-=09=09=09const int clock =3D crtc_state->adjusted_mode.clock;
+=09ret =3D nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
+=09=09=09=09=09  mstc->native);
+=09if (ret)
+=09=09return ret;
=20
-=09=09=09asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
-=09=09}
+=09if (!crtc_state->mode_changed && !crtc_state->connectors_changed)
+=09=09return 0;
=20
-=09=09slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
-=09=09=09=09=09=09      mstc->port,
-=09=09=09=09=09=09      asyh->dp.pbn);
-=09=09if (slots < 0)
-=09=09=09return slots;
+=09/*
+=09 * When restoring duplicated states, we need to make sure that the bw
+=09 * remains the same and avoid recalculating it, as the connector's bpc
+=09 * may have changed after the state was duplicated
+=09 */
+=09if (!state->duplicated) {
+=09=09const int bpp =3D connector->display_info.bpc * 3;
+=09=09const int clock =3D crtc_state->adjusted_mode.clock;
=20
-=09=09asyh->dp.tu =3D slots;
+=09=09asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp);
 =09}
=20
-=09return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
-=09=09=09=09=09   mstc->native);
+=09slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
+=09=09=09=09=09      asyh->dp.pbn);
+=09if (slots < 0)
+=09=09return slots;
+
+=09asyh->dp.tu =3D slots;
+
+=09return 0;
 }
=20
 static void
--=20
2.21.0

