Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8946C322ED4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 17:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhBWQfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 11:35:08 -0500
Received: from fanzine.igalia.com ([178.60.130.6]:46809 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhBWQfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 11:35:08 -0500
X-Greylist: delayed 2540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 11:35:06 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=wamqjZa0SAbTM42buHnqYxhDZBvIJUuqCANGvQUXpDc=;
        b=HLghZADHb3TKsezTpfWaIkYk61kFTcQizhzpAmqXed1RqLjKCPGpf9kpM5EVdOIWiZnNuDQYFb+qHLHQhqto5bdDlAZ9qx1xB4lM/68P8as7HcuJ2Xi+NGB2A5fyod2Z+L1fSwUA1iueNu82TrR68p432045wOGcjwvDQAa0VvKtUP55fMq9kxRpxf/RrzF0+fTxbL+cButTg/6LWfmtTrRh0iNKLZhR1KE1kWXn89bXGxveZbAuzrtI3FnU5QxS426qhW1hqhpyAB9jabEgMaUroue1ViYsWFbIv2BMtb0Lt7hEb/+oyYON3eiN+jWjJ9Nj6oKkDl3NZlBakXq+qQ==;
Received: from lneuilly-657-1-8-171.w81-250.abo.wanadoo.fr ([81.250.147.171] helo=masxo.routerf36dc8.com)
        by fanzine.igalia.com with esmtpsa 
        (Cipher TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim)
        id 1lEZyq-00036t-4H; Tue, 23 Feb 2021 16:52:08 +0100
From:   Neil Roberts <nroberts@igalia.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH v2 2/2] drm/shmem-helper: Don't remove the offset in vm_area_struct pgoff
Date:   Tue, 23 Feb 2021 16:51:25 +0100
Message-Id: <20210223155125.199577-3-nroberts@igalia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210223155125.199577-1-nroberts@igalia.com>
References: <20210223155125.199577-1-nroberts@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When mmapping the shmem, it would previously adjust the pgoff in the
vm_area_struct to remove the fake offset that is added to be able to
identify the buffer. This patch removes the adjustment and makes the
fault handler use the vm_fault address to calculate the page offset
instead. Although using this address is apparently discouraged, several
DRM drivers seem to be doing it anyway.

The problem with removing the pgoff is that it prevents
drm_vma_node_unmap from working because that searches the mapping tree
by address. That doesn't work because all of the mappings are at offset
0. drm_vma_node_unmap is being used by the shmem helpers when purging
the buffer.

This fixes a bug in Panfrost which is using drm_gem_shmem_purge. Without
this the mapping for the purged buffer can still be accessed which might
mean it would access random pages from other buffers

v2: Don't check whether the unsigned page_offset is less than 0.

Cc: stable@vger.kernel.org
Fixes: 17acb9f35ed7 ("drm/shmem: Add madvise state and purge helpers")
Signed-off-by: Neil Roberts <nroberts@igalia.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index b26139b1dc35..5b5c095e86a9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -527,15 +527,19 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
 	vm_fault_t ret;
 	struct page *page;
+	pgoff_t page_offset;
+
+	/* We don't use vmf->pgoff since that has the fake offset */
+	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
 
 	mutex_lock(&shmem->pages_lock);
 
-	if (vmf->pgoff >= num_pages ||
+	if (page_offset >= num_pages ||
 	    WARN_ON_ONCE(!shmem->pages) ||
 	    shmem->madv < 0) {
 		ret = VM_FAULT_SIGBUS;
 	} else {
-		page = shmem->pages[vmf->pgoff];
+		page = shmem->pages[page_offset];
 
 		ret = vmf_insert_page(vma, vmf->address, page);
 	}
@@ -591,9 +595,6 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	struct drm_gem_shmem_object *shmem;
 	int ret;
 
-	/* Remove the fake offset */
-	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
-
 	if (obj->import_attach) {
 		/* Drop the reference drm_gem_mmap_obj() acquired.*/
 		drm_gem_object_put(obj);
-- 
2.29.2

