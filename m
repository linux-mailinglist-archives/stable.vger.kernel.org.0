Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA91322EDA
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 17:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhBWQfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 11:35:53 -0500
Received: from fanzine.igalia.com ([178.60.130.6]:46848 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbhBWQfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 11:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=5tI+sZNQYIETnp4rYXjL4EveSfFBxhwH4qjXFiTVuDs=;
        b=FDFgOtEWu402Gtl/VM3DyRZ0wZO8KHmnrASAVoLAmvPrdzCXSEpvjmTNJMKJI8mXn+2s5RGY8wBOhgSa8ak4a6KFKS0OE4NEMdVQh8DVtFk6qY20p9WYYO6syoc+p7QGq2uF1vNk0timdNSA0veQd9VkEHipKN3geuxoh8q8eFIZoNuyanLv26rOKNi7MB6Y6K8zfC4Fq5wFObCXvjujMr6JHAPV+adZkrqpXcLJa/wNewKHIEe7mGm2xEsuzLhAyMOwLbF7YvXguSX94UmLvBW/ZzF0Oz7/2LsBjmYo4yAuViE6z6klFYKEoVHkjIU0NESCo6fZjBn1t6d3Ghjx0A==;
Received: from lneuilly-657-1-8-171.w81-250.abo.wanadoo.fr ([81.250.147.171] helo=masxo.routerf36dc8.com)
        by fanzine.igalia.com with esmtpsa 
        (Cipher TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim)
        id 1lEZyj-00036t-Vs; Tue, 23 Feb 2021 16:52:02 +0100
From:   Neil Roberts <nroberts@igalia.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/shmem-helper: Check for purged buffers in fault handler
Date:   Tue, 23 Feb 2021 16:51:24 +0100
Message-Id: <20210223155125.199577-2-nroberts@igalia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210223155125.199577-1-nroberts@igalia.com>
References: <20210223155125.199577-1-nroberts@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a buffer is madvised as not needed and then purged, any attempts to
access the buffer from user-space should cause a bus fault. This patch
adds a check for that.

Cc: stable@vger.kernel.org
Fixes: 17acb9f35ed7 ("drm/shmem: Add madvise state and purge helpers")
Signed-off-by: Neil Roberts <nroberts@igalia.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 9825c378dfa6..b26139b1dc35 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -525,14 +525,24 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
+	vm_fault_t ret;
 	struct page *page;
 
-	if (vmf->pgoff >= num_pages || WARN_ON_ONCE(!shmem->pages))
-		return VM_FAULT_SIGBUS;
+	mutex_lock(&shmem->pages_lock);
+
+	if (vmf->pgoff >= num_pages ||
+	    WARN_ON_ONCE(!shmem->pages) ||
+	    shmem->madv < 0) {
+		ret = VM_FAULT_SIGBUS;
+	} else {
+		page = shmem->pages[vmf->pgoff];
 
-	page = shmem->pages[vmf->pgoff];
+		ret = vmf_insert_page(vma, vmf->address, page);
+	}
 
-	return vmf_insert_page(vma, vmf->address, page);
+	mutex_unlock(&shmem->pages_lock);
+
+	return ret;
 }
 
 static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
-- 
2.29.2

