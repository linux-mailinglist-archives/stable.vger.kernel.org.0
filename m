Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4594433B7A1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCOOAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhCON7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 057E564F44;
        Mon, 15 Mar 2021 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816749;
        bh=3tyspyjzAbsdhvZijLJLGF2xWOnIl0YKzRxdLyY00iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZPPZqrTSdGirJQkMxyuKiPmO26DZ1Wldz+ZtxYqNYAoy5JBmMW6zI1moqxg9MCnV
         2KqcpRKOkyE0ZoQnJ9+nlsZWBNMo6WUaulCi9Cla2rOcZKWVgIDEvNjbZ7fy8oXrd5
         W2h6iFj1TncrNrnxg7kA/40o9DxmbztpUqQSjmdI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Roberts <nroberts@igalia.com>,
        Steven Price <steven.price@arm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.10 092/290] drm/shmem-helper: Check for purged buffers in fault handler
Date:   Mon, 15 Mar 2021 14:53:05 +0100
Message-Id: <20210315135545.025811771@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Neil Roberts <nroberts@igalia.com>

commit d611b4a0907cece060699f2fd347c492451cd2aa upstream.

When a buffer is madvised as not needed and then purged, any attempts to
access the buffer from user-space should cause a bus fault. This patch
adds a check for that.

Cc: stable@vger.kernel.org
Fixes: 17acb9f35ed7 ("drm/shmem: Add madvise state and purge helpers")
Signed-off-by: Neil Roberts <nroberts@igalia.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210223155125.199577-2-nroberts@igalia.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -534,14 +534,24 @@ static vm_fault_t drm_gem_shmem_fault(st
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
 	loff_t num_pages = obj->size >> PAGE_SHIFT;
+	vm_fault_t ret;
 	struct page *page;
 
-	if (vmf->pgoff >= num_pages || WARN_ON_ONCE(!shmem->pages))
-		return VM_FAULT_SIGBUS;
+	mutex_lock(&shmem->pages_lock);
 
-	page = shmem->pages[vmf->pgoff];
+	if (vmf->pgoff >= num_pages ||
+	    WARN_ON_ONCE(!shmem->pages) ||
+	    shmem->madv < 0) {
+		ret = VM_FAULT_SIGBUS;
+	} else {
+		page = shmem->pages[vmf->pgoff];
 
-	return vmf_insert_page(vma, vmf->address, page);
+		ret = vmf_insert_page(vma, vmf->address, page);
+	}
+
+	mutex_unlock(&shmem->pages_lock);
+
+	return ret;
 }
 
 static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)


