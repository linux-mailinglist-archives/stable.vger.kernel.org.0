Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D629CB79
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 22:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374455AbgJ0Vtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 17:49:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33755 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374453AbgJ0Vtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 17:49:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id l20so1967659wme.0
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 14:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V8no5NLx/EPXeK3IR/DnmSVtE8r9cF0bSgSu8ZLPdMw=;
        b=aRDyobZ7krZL7Pf7BVzo8QG2FDxcmJ9CXt4MjKL+s/67M3acWl0aexo7kZUXiyHG1e
         ft6UrfT8UxfndswEBrXy8J3WJNnkao3SGzh9zQSFQP9xQCs09ullxZIeAvJ0mD/Q983a
         QsKRhHKdvA78dAun2cI/4M1yS3ykh8QDJAwI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V8no5NLx/EPXeK3IR/DnmSVtE8r9cF0bSgSu8ZLPdMw=;
        b=E/DYKtFtDrHADxY5fM48aXonRkf86eVz8dTMmZQ7yI/SzFc6zZz/h/kY/Bd1Ev6IMw
         e9tNMbHuwXk45raKv2f7zKPukbsy3kk+qkFfOK+sB/7dgyDofxoJ0yNlc9H6Fs9zCTJB
         qu81kwGLJBjFpp397MSXbQmMjWfW/mZXITE/t5+qkvi/DkajVsE40nhWBqlP8sZe5pBV
         YoIRvhBbUEQshxPMU+ETVJaElYAYjl0Zzb3xY2p8XcuQJLtGI44mmRpyvn7XhdIu73W6
         F1aezTo1xaN35esNWC+iDy6jM+4411QlE6fTgPMN4g4Y5o0CzZzWF3NQpWrpsRDLE+c1
         JOzQ==
X-Gm-Message-State: AOAM532GLEe5XyFIZOanOQ5YvQfgWFCdG/OqfZ5Em4Kegfdy+ht98l15
        tuLt7BSI/jV3fTyDD1exVRtoCw==
X-Google-Smtp-Source: ABdhPJxbLJNJ+DNsc2Vj5AgNJFuMtAN0kc4/8NmFGgYnXE7uZIMveSFMusf90xuHdaxHEKHu608YJw==
X-Received: by 2002:a05:600c:21c3:: with SMTP id x3mr4653420wmj.81.1603835378528;
        Tue, 27 Oct 2020 14:49:38 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id e11sm3444488wrj.75.2020.10.27.14.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 14:49:37 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Rob Herring <robh@kernel.org>, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, stable@vger.kernel.org,
        piotr.oniszczuk@gmail.com, Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/shme-helpers: Fix dma_buf_mmap forwarding bug
Date:   Tue, 27 Oct 2020 22:49:22 +0100
Message-Id: <20201027214922.3566743-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we forward an mmap to the dma_buf exporter, they get to own
everything. Unfortunately drm_gem_mmap_obj() overwrote
vma->vm_private_data after the driver callback, wreaking the
exporter complete. This was noticed because vb2_common_vm_close blew
up on mali gpu with panfrost after commit 26d3ac3cb04d
("drm/shmem-helpers: Redirect mmap for imported dma-buf").

Unfortunately drm_gem_mmap_obj also acquires a surplus reference that
we need to drop in shmem helpers, which is a bit of a mislayer
situation. Maybe the entire dma_buf_mmap forwarding should be pulled
into core gem code.

Note that the only two other drivers which forward mmap in their own
code (etnaviv and exynos) get this somewhat right by overwriting the
gem mmap code. But they seem to still have the leak. This might be a
good excuse to move these drivers over to shmem helpers completely.

Note to stable team: There's a trivial context conflict with
d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from
struct drm_driver"). I'm assuming it's clear where to put the first
hunk, otherwise I can send a 5.9 version of this.

Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Russell King <linux+etnaviv@armlinux.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Fixes: 26d3ac3cb04d ("drm/shmem-helpers: Redirect mmap for imported dma-buf")
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: <stable@vger.kernel.org> # v5.9+
Reported-and-tested-by: piotr.oniszczuk@gmail.com
Cc: piotr.oniszczuk@gmail.com
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_gem.c              | 4 ++--
 drivers/gpu/drm/drm_gem_shmem_helper.c | 7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 1da67d34e55d..d586068f5509 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1076,6 +1076,8 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 	 */
 	drm_gem_object_get(obj);
 
+	vma->vm_private_data = obj;
+
 	if (obj->funcs->mmap) {
 		ret = obj->funcs->mmap(obj, vma);
 		if (ret) {
@@ -1096,8 +1098,6 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	}
 
-	vma->vm_private_data = obj;
-
 	return 0;
 }
 EXPORT_SYMBOL(drm_gem_mmap_obj);
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index fb11df7aced5..8233bda4692f 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -598,8 +598,13 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	/* Remove the fake offset */
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 
-	if (obj->import_attach)
+	if (obj->import_attach) {
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		drm_gem_object_put(obj);
+		vma->vm_private_data = NULL;
+
 		return dma_buf_mmap(obj->dma_buf, vma, 0);
+	}
 
 	shmem = to_drm_gem_shmem_obj(obj);
 
-- 
2.28.0

