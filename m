Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF3E541228
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357083AbiFGToX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiFGTl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AB71B1F62;
        Tue,  7 Jun 2022 11:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77437608CD;
        Tue,  7 Jun 2022 18:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87980C34115;
        Tue,  7 Jun 2022 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625694;
        bh=tgODfi+gRHj0Fd3l9puJo3xP/s51i+HPf2rAmZCL/Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZ5pVw+AeDEGVlchIl+55TWwOm9CEGi0XzLK0vQbafKiz5g4rH8SCNmNUmgzoMxf3
         zo2exRBftgOefJsZpq0U8jDqO0HeR0Ukr3yI3bCOG9RWgBDEkowdXtevlQAa1eeRu7
         po4rYkA6SnLfjHE6nWp0nw7CBHuReohX/nD0l/uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 109/772] scsi: target: tcmu: Fix possible data corruption
Date:   Tue,  7 Jun 2022 18:55:01 +0200
Message-Id: <20220607164952.258326760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit bb9b9eb0ae2e9d3f6036f0ad907c3a83dcd43485 ]

When tcmu_vma_fault() gets a page successfully, before the current context
completes page fault procedure, find_free_blocks() may run and call
unmap_mapping_range() to unmap the page. Assume that when
find_free_blocks() initially completes and the previous page fault
procedure starts to run again and completes, then one truncated page has
been mapped to userspace. But note that tcmu_vma_fault() has gotten a
refcount for the page so any other subsystem won't be able to use the page
unless the userspace address is unmapped later.

If another command subsequently runs and needs to extend dbi_thresh it may
reuse the corresponding slot for the previous page in data_bitmap. Then
though we'll allocate new page for this slot in data_area, no page fault
will happen because we have a valid map and the real request's data will be
lost.

Filesystem implementations will also run into this issue but they usually
lock the page when vm_operations_struct->fault gets a page and unlock the
page after finish_fault() completes. For truncate filesystems lock pages in
truncate_inode_pages() to protect against racing wrt. page faults.

To fix this possible data corruption scenario we can apply a method similar
to the filesystems.  For pages that are to be freed, tcmu_blocks_release()
locks and unlocks. Make tcmu_vma_fault() also lock found page under
cmdr_lock. At the same time, since tcmu_vma_fault() gets an extra page
refcount, tcmu_blocks_release() won't free pages if pages are in page fault
procedure, which means it is safe to call tcmu_blocks_release() before
unmap_mapping_range().

With these changes tcmu_blocks_release() will wait for all page faults to
be completed before calling unmap_mapping_range(). And later, if
unmap_mapping_range() is called, it will ensure stale mappings are removed.

Link: https://lore.kernel.org/r/20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 40 ++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 06a5c4086551..f26767a55d38 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -20,6 +20,7 @@
 #include <linux/configfs.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/pagemap.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -1666,6 +1667,26 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 	xas_lock(&xas);
 	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
 		xas_store(&xas, NULL);
+		/*
+		 * While reaching here there may be page faults occurring on
+		 * the to-be-released pages. A race condition may occur if
+		 * unmap_mapping_range() is called before page faults on these
+		 * pages have completed; a valid but stale map is created.
+		 *
+		 * If another command subsequently runs and needs to extend
+		 * dbi_thresh, it may reuse the slot corresponding to the
+		 * previous page in data_bitmap. Though we will allocate a new
+		 * page for the slot in data_area, no page fault will happen
+		 * because we have a valid map. Therefore the command's data
+		 * will be lost.
+		 *
+		 * We lock and unlock pages that are to be released to ensure
+		 * all page faults have completed. This way
+		 * unmap_mapping_range() can ensure stale maps are cleanly
+		 * removed.
+		 */
+		lock_page(page);
+		unlock_page(page);
 		__free_page(page);
 		pages_freed++;
 	}
@@ -1821,6 +1842,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
 		get_page(page);
+		lock_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1862,6 +1884,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 	struct page *page;
 	unsigned long offset;
 	void *addr;
+	vm_fault_t ret = 0;
 
 	int mi = tcmu_find_mem_index(vmf->vma);
 	if (mi < 0)
@@ -1886,10 +1909,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		page = tcmu_try_get_data_page(udev, dpi);
 		if (!page)
 			return VM_FAULT_SIGBUS;
+		ret = VM_FAULT_LOCKED;
 	}
 
 	vmf->page = page;
-	return 0;
+	return ret;
 }
 
 static const struct vm_operations_struct tcmu_vm_ops = {
@@ -3152,12 +3176,22 @@ static void find_free_blocks(void)
 			udev->dbi_max = block;
 		}
 
+		/*
+		 * Release the block pages.
+		 *
+		 * Also note that since tcmu_vma_fault() gets an extra page
+		 * refcount, tcmu_blocks_release() won't free pages if pages
+		 * are mapped. This means it is safe to call
+		 * tcmu_blocks_release() before unmap_mapping_range() which
+		 * drops the refcount of any pages it unmaps and thus releases
+		 * them.
+		 */
+		pages_freed = tcmu_blocks_release(udev, start, end - 1);
+
 		/* Here will truncate the data area from off */
 		off = udev->data_off + (loff_t)start * udev->data_blk_size;
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
-		/* Release the block pages */
-		pages_freed = tcmu_blocks_release(udev, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_pages_freed += pages_freed;
-- 
2.35.1



