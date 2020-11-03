Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00E2A582D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgKCUt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgKCUt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64561223FD;
        Tue,  3 Nov 2020 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436564;
        bh=H/bahLUtNGlRGYIevvmapEfWHWWFAfHpFt8kL4xiXQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZNhfo31Yy6TcO9SQ1wjM64U4BOIlj6Wt1UcsqvtLGLHktjT5qTQnj1D5bHJoSzzL
         5urSeXgEO6V+Fn0upevWsZXDInHEwJQUSmzbVXFBSRsRXI0GAFJwPZhSFWRnGbWQCs
         5dLw7muACcI7fKTFgepnuXq0aF8vAxYvRb32Aa58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Rob Herring <robh@kernel.org>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        piotr.oniszczuk@gmail.com, Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.9 267/391] drm/shme-helpers: Fix dma_buf_mmap forwarding bug
Date:   Tue,  3 Nov 2020 21:35:18 +0100
Message-Id: <20201103203405.042055538@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit f49a51bfdc8ea717c97ccd4cc98b7e6daaa5553a upstream.

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

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Acked-by: Christian König <christian.koenig@amd.com>
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
Link: https://patchwork.freedesktop.org/patch/msgid/20201027214922.3566743-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_gem.c              |    4 ++--
 drivers/gpu/drm/drm_gem_shmem_helper.c |    7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1085,6 +1085,8 @@ int drm_gem_mmap_obj(struct drm_gem_obje
 	 */
 	drm_gem_object_get(obj);
 
+	vma->vm_private_data = obj;
+
 	if (obj->funcs && obj->funcs->mmap) {
 		ret = obj->funcs->mmap(obj, vma);
 		if (ret) {
@@ -1107,8 +1109,6 @@ int drm_gem_mmap_obj(struct drm_gem_obje
 		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	}
 
-	vma->vm_private_data = obj;
-
 	return 0;
 }
 EXPORT_SYMBOL(drm_gem_mmap_obj);
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -594,8 +594,13 @@ int drm_gem_shmem_mmap(struct drm_gem_ob
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
 


