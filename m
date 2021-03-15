Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB00733B6C3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhCON6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232071AbhCON6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A9C64F38;
        Mon, 15 Mar 2021 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816689;
        bh=s0igxtKMfYxA8SVvVJiw7ZJu0AVVuctGKDjev/kC1WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzMPgJ3KjK5rRQUIqRfT0zj1kfF8ClOBYHC4UG86/hLVPcACQxNv8qeOxDAj1QREU
         MFONFfn9V+HwrIBJufYP2xjNlhnBno0Cx8ieQjr1vok3J0IhDN5ltdeV/yVIcM2suT
         o217AmVfmMaKs/7ct2oNXkyhXq8QFKd36W4ebZ1w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Roberts <nroberts@igalia.com>,
        Steven Price <steven.price@arm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.4 048/168] drm/shmem-helper: Check for purged buffers in fault handler
Date:   Mon, 15 Mar 2021 14:54:40 +0100
Message-Id: <20210315135551.941962641@linuxfoundation.org>
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
@@ -474,14 +474,24 @@ static vm_fault_t drm_gem_shmem_fault(st
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


