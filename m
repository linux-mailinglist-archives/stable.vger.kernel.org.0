Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7821C15B489
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 00:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgBLXMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 18:12:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50784 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728674AbgBLXMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 18:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581549123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jCt2P0A22WqnBmF74nxHEDQpAf5e3drV6li46of8UJE=;
        b=Zi1bgx6ZeH9mHS/2HMCkWLXWy8VkCi7CIvHFxhi2Nh2d2o9DbfhtauuPT49QYsxfNVGhG2
        3h6TkTOc4byfnRNREk9izULKgWJlakVTx8CBc6DB4/3PGqnIaUMKoG5M/7hSXT9QdFnkMF
        GSQTvX/k0bH76eiKFMe4Zjxjt815o1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-olSKgepONka81QqzzMDk9g-1; Wed, 12 Feb 2020 18:11:58 -0500
X-MC-Unique: olSKgepONka81QqzzMDk9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 600EC800D50;
        Wed, 12 Feb 2020 23:11:56 +0000 (UTC)
Received: from Ruby.bss.redhat.com (dhcp-10-20-1-196.bss.redhat.com [10.20.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50FE760BF1;
        Wed, 12 Feb 2020 23:11:52 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets
Date:   Wed, 12 Feb 2020 18:11:49 -0500
Message-Id: <20200212231150.171495-1-lyude@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While certain modeset operations on gv100+ need us to temporarily
disable the LUT, we make the mistake of sometimes neglecting to
reprogram the LUT after such modesets. In particular, moving a head from
one encoder to another seems to trigger this quite often. GV100+ is very
picky about having a LUT in most scenarios, so this causes the display
engine to hang with the following error code:

disp: chid 1 stat 00005080 reason 5 [INVALID_STATE] mthd 0200 data
00000001 code 0000002d)

So, fix this by always re-programming the LUT if we're clearing it in a
state where the wndw is still visible, and has a XLUT handle programmed.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: facaed62b4cb ("drm/nouveau/kms/gv100: initial support")
Cc: <stable@vger.kernel.org> # v4.18+
---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/no=
uveau/dispnv50/wndw.c
index 890315291b01..bb737f9281e6 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -458,6 +458,8 @@ nv50_wndw_atomic_check(struct drm_plane *plane, struc=
t drm_plane_state *state)
 		asyw->clr.ntfy =3D armw->ntfy.handle !=3D 0;
 		asyw->clr.sema =3D armw->sema.handle !=3D 0;
 		asyw->clr.xlut =3D armw->xlut.handle !=3D 0;
+		if (asyw->clr.xlut && asyw->visible)
+			asyw->set.xlut =3D asyw->xlut.handle !=3D 0;
 		asyw->clr.csc  =3D armw->csc.valid;
 		if (wndw->func->image_clr)
 			asyw->clr.image =3D armw->image.handle[0] !=3D 0;
--=20
2.24.1

