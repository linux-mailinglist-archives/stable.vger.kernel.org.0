Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20A52FAE82
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 02:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbhASB4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 20:56:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387968AbhASBz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 20:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611021271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8Ci0DS+3D0Reot9MShH6pqzkDoQV3FaC72g+72SfKj8=;
        b=IeYs0kznE8ohC57X+OzvazeW6jAJfCZmPU5SdX9k089sPMMcKGIqlApHD8+anjL1u3CFoS
        wBD3JCJASsgQfxag+3d8UpCnq7MHgykHiWA4B+pHz/wU8bdvOCcC4/5o2p9b2XemtT+h13
        pCqRAsfvAxUqDqnJTishnYLNjTzlGpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-ngJvBc-8NOGsHyfoCVE7bQ-1; Mon, 18 Jan 2021 20:54:30 -0500
X-MC-Unique: ngJvBc-8NOGsHyfoCVE7bQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61E651005E40;
        Tue, 19 Jan 2021 01:54:28 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-113-206.rdu2.redhat.com [10.10.113.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC8A35D9CD;
        Tue, 19 Jan 2021 01:54:26 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     James Jones <jajones@nvidia.com>,
        Martin Peres <martin.peres@free.fr>,
        Jeremy Cline <jcline@redhat.com>,
        Simon Ser <contact@emersion.fr>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] drivers/nouveau/kms/nv50-: Reject format modifiers for cursor planes
Date:   Mon, 18 Jan 2021 20:54:12 -0500
Message-Id: <20210119015415.2511028-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nvidia hardware doesn't actually support using tiling formats with the
cursor plane, only linear is allowed. In the future, we should write a
testcase for this.

Fixes: c586f30bf74c ("drm/nouveau/kms: Add format mod prop to base/ovly/nvdisp")
Cc: James Jones <jajones@nvidia.com>
Cc: Martin Peres <martin.peres@free.fr>
Cc: Jeremy Cline <jcline@redhat.com>
Cc: Simon Ser <contact@emersion.fr>
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index ce451242f79e..271de3a63f21 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -702,6 +702,11 @@ nv50_wndw_init(struct nv50_wndw *wndw)
 	nvif_notify_get(&wndw->notify);
 }
 
+static const u64 nv50_cursor_format_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID,
+};
+
 int
 nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
 	       enum drm_plane_type type, const char *name, int index,
@@ -713,6 +718,7 @@ nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
 	struct nvif_mmu *mmu = &drm->client.mmu;
 	struct nv50_disp *disp = nv50_disp(dev);
 	struct nv50_wndw *wndw;
+	const u64 *format_modifiers;
 	int nformat;
 	int ret;
 
@@ -728,10 +734,13 @@ nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
 
 	for (nformat = 0; format[nformat]; nformat++);
 
-	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw,
-				       format, nformat,
-				       nouveau_display(dev)->format_modifiers,
-				       type, "%s-%d", name, index);
+	if (type == DRM_PLANE_TYPE_CURSOR)
+		format_modifiers = nv50_cursor_format_modifiers;
+	else
+		format_modifiers = nouveau_display(dev)->format_modifiers;
+
+	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw, format, nformat,
+				       format_modifiers, type, "%s-%d", name, index);
 	if (ret) {
 		kfree(*pwndw);
 		*pwndw = NULL;
-- 
2.29.2

