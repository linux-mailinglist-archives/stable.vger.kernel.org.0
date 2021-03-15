Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3B33B6CB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhCON6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhCON6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 670D064F40;
        Mon, 15 Mar 2021 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816690;
        bh=gFKKh/jNpof9s0wxrd+qXEE/YgPV0vgBD/KK5Wq4xts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvUe8LnCvMpIEwFI3kEUfBeLSfjjNzcK0/ZpSIWfpnU6v41FW/Bmj26opD3pIetbY
         UwHl8bMo2EH4MtIN+aNtXZeSJ9LiF0NdYYapcdW7FXlks1Y4o0axAgr8bHzUaxwYNj
         SbJ/u2JgihN5aG+DAqURclk4Dgw97tS0VN7nomcs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Roberts <nroberts@igalia.com>,
        Steven Price <steven.price@arm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.4 049/168] drm/shmem-helper: Dont remove the offset in vm_area_struct pgoff
Date:   Mon, 15 Mar 2021 14:54:41 +0100
Message-Id: <20210315135551.973574564@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Neil Roberts <nroberts@igalia.com>

commit 11d5a4745e00e73745774671dbf2fb07bd6e2363 upstream.

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
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210223155125.199577-3-nroberts@igalia.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -476,15 +476,19 @@ static vm_fault_t drm_gem_shmem_fault(st
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
@@ -559,9 +563,6 @@ int drm_gem_shmem_mmap(struct file *filp
 	vma->vm_flags &= ~VM_PFNMAP;
 	vma->vm_flags |= VM_MIXEDMAP;
 
-	/* Remove the fake offset */
-	vma->vm_pgoff -= drm_vma_node_start(&shmem->base.vma_node);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_mmap);


