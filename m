Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3281FE6D9
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 22:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKOVIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 16:08:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58500 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726985AbfKOVIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 16:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573852084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ubEKyq0NDvgrMzhHxKyHULtH/hM1Pm9HAnCe7lcD+A=;
        b=WriJZDaAcFUP0KaMdZLUXI5dQZ682cQ9g27ad+XTfPKVsQLOvB0m7hCXQyJk/jz32H2P9G
        uCd7xWxTfnCKBdGYZaI4Nd/nW+0tA445IbrcJQxQ+i2E4Ersax2DRkSPHb5og7gbu8aW3L
        iEX73wmp4lqBP1qvuS9oPz0XOqBiaoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-wo2lr6imNyCH6r2nGOEJpQ-1; Fri, 15 Nov 2019 16:08:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0279B800686;
        Fri, 15 Nov 2019 21:08:01 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32C1B69193;
        Fri, 15 Nov 2019 21:07:54 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drm/nouveau/kms/nv50-: Limit MST BPC to 8
Date:   Fri, 15 Nov 2019 16:07:20 -0500
Message-Id: <20191115210728.3467-4-lyude@redhat.com>
In-Reply-To: <20191115210728.3467-1-lyude@redhat.com>
References: <20191115210728.3467-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: wo2lr6imNyCH6r2nGOEJpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Noticed this while working on some unrelated CRC stuff. Currently,
userspace has very little support for BPCs higher than 8. While this
doesn't matter for most things, on MST topologies we need to be careful
about ensuring that we do our best to make any given display
configuration fit within the bandwidth restraints of the topology, since
otherwise less people's monitor configurations will work.

Allowing for BPC settings higher than 8 dramatically increases the
required bandwidth for displays in most configurations, and consequently
makes it a lot less likely that said display configurations will pass
the atomic check.

In the future we want to fix this correctly by making it so that we
adjust the bpp for each display in a topology to be as high as possible,
while making sure to lower the bpp of each display in the event that we
run out of bandwidth and need to rerun our atomic check. But for now,
follow the behavior that both i915 and amdgpu are sticking to.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: <stable@vger.kernel.org> # v5.1+
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouv=
eau/dispnv50/disp.c
index 93665aecce57..9ac47fe519f8 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -798,7 +798,14 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 =09if (!state->duplicated) {
 =09=09const int clock =3D crtc_state->adjusted_mode.clock;
=20
-=09=09asyh->or.bpc =3D connector->display_info.bpc;
+=09=09/*
+=09=09 * XXX: Since we don't use HDR in userspace quite yet, limit
+=09=09 * the bpc to 8 to save bandwidth on the topology. In the
+=09=09 * future, we'll want to properly fix this by dynamically
+=09=09 * selecting the highest possible bpc that would fit in the
+=09=09 * topology
+=09=09 */
+=09=09asyh->or.bpc =3D min(connector->display_info.bpc, 8U);
 =09=09asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3);
 =09}
=20
--=20
2.21.0

