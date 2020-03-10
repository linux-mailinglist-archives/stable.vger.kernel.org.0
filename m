Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8D17F9DD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgCJNAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbgCJNAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:00:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8522253D;
        Tue, 10 Mar 2020 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845240;
        bh=YdL6srul3R7Y6m6aFXkHfEa6dkbwy5CkfR5vAKHotE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oos0ro4ZlyuWezXCc/+QPI63x3HtM9Ca1Pdj1A750tJAiVXkfakTNiFzZF7xbN3h4
         eA+W4Tk3dRIgMNlNZfZ7H5MTURECYftfuo2RJ8o0Tory/H651WeocXhWV/7LRbrBq9
         1nu46cO3CezLZVj0y5ihYSx73zAggG827fqEleDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Guillaume Gardet <Guillaume.Gardet@arm.com>
Subject: [PATCH 5.5 111/189] drm/shmem: add support for per object caching flags.
Date:   Tue, 10 Mar 2020 13:39:08 +0100
Message-Id: <20200310123650.922870835@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

commit 1cad629257e76025bcbf490c58de550fb67d4d0e upstream.

Add map_cached bool to drm_gem_shmem_object, to request cached mappings
on a per-object base.  Check the flag before adding writecombine to
pgprot bits.

Cc: stable@vger.kernel.org
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Gurchetan Singh <gurchetansingh@chromium.org>
Tested-by: Guillaume Gardet <Guillaume.Gardet@arm.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200226154752.24328-2-kraxel@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_gem_shmem_helper.c |   15 +++++++++++----
 include/drm/drm_gem_shmem_helper.h     |    5 +++++
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(s
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
@@ -537,7 +542,9 @@ int drm_gem_shmem_mmap(struct drm_gem_ob
 	}
 
 	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	if (!shmem->map_cached)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	vma->vm_ops = &drm_gem_shmem_vm_ops;
 
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


