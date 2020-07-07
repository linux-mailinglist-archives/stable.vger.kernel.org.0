Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC05217384
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgGGQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 12:16:46 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63503 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727079AbgGGQQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 12:16:46 -0400
X-Greylist: delayed 988 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2020 12:16:44 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21742943-1500050 
        for multiple; Tue, 07 Jul 2020 17:00:14 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Lepton Wu <ytht.net@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an import dmabuf object
Date:   Tue,  7 Jul 2020 17:00:11 +0100
Message-Id: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we assign obj->filp, we believe that the create vgem bo is native and
allow direct operations like mmap() assuming it behaves as backed by a
shmemfs inode. When imported from a dmabuf, the obj->pages are
not always meaningful and the shmemfs backing store misleading.

Note, that regular mmap access to a vgem bo is via the dumb buffer API,
and that rejects attempts to mmap an imported dmabuf,

drm_gem_dumb_map_offset():
        if (obj->import_attach) return -EINVAL;

So the only route by which we might accidentally allow mmapping of an
imported buffer is via vgem_prime_mmap(), which checked for
obj->filp assuming that it would be NULL.

Well it would had it been updated to use the common
drm_gem_dum_map_offset() helper, instead it has

vgem_gem_dumb_map():
	if (!obj->filp) return -EINVAL;

falling foul of the same trap as above.

Reported-by: Lepton Wu <ytht.net@gmail.com>
Fixes: af33a9190d02 ("drm/vgem: Enable dmabuf import interfaces")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lepton Wu <ytht.net@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Christian König <christian.koenig@amd.com>
Cc: Thomas Hellström (Intel) <thomas_os@shipmail.org>
Cc: <stable@vger.kernel.org> # v4.13+
---
 drivers/gpu/drm/vgem/vgem_drv.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 909eba43664a..eb3b7cdac941 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -91,7 +91,7 @@ static vm_fault_t vgem_gem_fault(struct vm_fault *vmf)
 		ret = 0;
 	}
 	mutex_unlock(&obj->pages_lock);
-	if (ret) {
+	if (ret && obj->base.filp) {
 		struct page *page;
 
 		page = shmem_read_mapping_page(
@@ -157,7 +157,8 @@ static void vgem_postclose(struct drm_device *dev, struct drm_file *file)
 }
 
 static struct drm_vgem_gem_object *__vgem_gem_create(struct drm_device *dev,
-						unsigned long size)
+						     struct file *shmem,
+						     unsigned long size)
 {
 	struct drm_vgem_gem_object *obj;
 	int ret;
@@ -166,11 +167,8 @@ static struct drm_vgem_gem_object *__vgem_gem_create(struct drm_device *dev,
 	if (!obj)
 		return ERR_PTR(-ENOMEM);
 
-	ret = drm_gem_object_init(dev, &obj->base, roundup(size, PAGE_SIZE));
-	if (ret) {
-		kfree(obj);
-		return ERR_PTR(ret);
-	}
+	drm_gem_private_object_init(dev, &obj->base, size);
+	obj->base.filp = shmem;
 
 	mutex_init(&obj->pages_lock);
 
@@ -189,11 +187,20 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
 					      unsigned long size)
 {
 	struct drm_vgem_gem_object *obj;
+	struct file *shmem;
 	int ret;
 
-	obj = __vgem_gem_create(dev, size);
-	if (IS_ERR(obj))
+	size = roundup(size, PAGE_SIZE);
+
+	shmem = shmem_file_setup(DRIVER_NAME, size, VM_NORESERVE);
+	if (IS_ERR(shmem))
+		return ERR_CAST(shmem);
+
+	obj = __vgem_gem_create(dev, shmem, size);
+	if (IS_ERR(obj)) {
+		fput(shmem);
 		return ERR_CAST(obj);
+	}
 
 	ret = drm_gem_handle_create(file, &obj->base, handle);
 	if (ret) {
@@ -363,7 +370,7 @@ static struct drm_gem_object *vgem_prime_import_sg_table(struct drm_device *dev,
 	struct drm_vgem_gem_object *obj;
 	int npages;
 
-	obj = __vgem_gem_create(dev, attach->dmabuf->size);
+	obj = __vgem_gem_create(dev, NULL, attach->dmabuf->size);
 	if (IS_ERR(obj))
 		return ERR_CAST(obj);
 
-- 
2.27.0

