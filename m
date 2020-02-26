Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7679E170309
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 16:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgBZPsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 10:48:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbgBZPsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 10:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582732086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=W9xkoVPCjL7OnxS3DEuB2EvUXPGbYO0cl1hdIp0HS9w=;
        b=JBvQX5Ukjv6hIj9GV0pZJTyfMdpdSP2UGcY9ylRtdlzxBxEOTL1HEFinAO7tEla3PzI/7L
        i3xt7UKWu7bPt73Oqn0ybGYOU+FzmpwGUBVfdwqXvt3KF4nBhZkv3tU46o6XiMDf5LgCOy
        /iSQ/fXWxFqCId336gw7WOL2GyB6BkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-U1DWS3_LMcWmYnFvIPwGvQ-1; Wed, 26 Feb 2020 10:48:02 -0500
X-MC-Unique: U1DWS3_LMcWmYnFvIPwGvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E2E97760;
        Wed, 26 Feb 2020 15:48:00 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-150.ams2.redhat.com [10.36.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA8C8AC42;
        Wed, 26 Feb 2020 15:47:56 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0B6FF9AA2; Wed, 26 Feb 2020 16:47:53 +0100 (CET)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     tzimmermann@suse.de, gurchetansingh@chromium.org,
        olvaffe@gmail.com, Guillaume.Gardet@arm.com,
        Gerd Hoffmann <kraxel@redhat.com>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/3] drm/shmem: add support for per object caching flags.
Date:   Wed, 26 Feb 2020 16:47:50 +0100
Message-Id: <20200226154752.24328-2-kraxel@redhat.com>
In-Reply-To: <20200226154752.24328-1-kraxel@redhat.com>
References: <20200226154752.24328-1-kraxel@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add map_cached bool to drm_gem_shmem_object, to request cached mappings
on a per-object base.  Check the flag before adding writecombine to
pgprot bits.

Cc: stable@vger.kernel.org
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/drm/drm_gem_shmem_helper.h     |  5 +++++
 drivers/gpu/drm/drm_gem_shmem_helper.c | 15 +++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index e34a7b7f848a..294b2931c4cc 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -96,6 +96,11 @@ struct drm_gem_shmem_object {
 	 * The address are un-mapped when the count reaches zero.
 	 */
 	unsigned int vmap_use_count;
+
+	/**
+	 * @map_cached: map object cached (instead of using writecombine).
+	 */
+	bool map_cached;
 };
 
 #define to_drm_gem_shmem_obj(obj) \
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index a421a2eed48a..aad9324dcf4f 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem)
 	if (ret)
 		goto err_zero_use;
 
-	if (obj->import_attach)
+	if (obj->import_attach) {
 		shmem->vaddr = dma_buf_vmap(obj->import_attach->dmabuf);
-	else
+	} else {
+		pgprot_t prot = PAGE_KERNEL;
+
+		if (!shmem->map_cached)
+			prot = pgprot_writecombine(prot);
 		shmem->vaddr = vmap(shmem->pages, obj->size >> PAGE_SHIFT,
-				    VM_MAP, pgprot_writecombine(PAGE_KERNEL));
+				    VM_MAP, prot);
+	}
 
 	if (!shmem->vaddr) {
 		DRM_DEBUG_KMS("Failed to vmap pages\n");
@@ -540,7 +545,9 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	}
 
 	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	if (!shmem->map_cached)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	vma->vm_ops = &drm_gem_shmem_vm_ops;
 
-- 
2.18.2

