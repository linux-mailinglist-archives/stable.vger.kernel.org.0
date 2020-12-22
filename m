Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE072D9DDF
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408600AbgLNRhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408573AbgLNRhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:17 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 009/105] vhost-vdpa: fix page pinning leakage in error path (rework)
Date:   Mon, 14 Dec 2020 18:27:43 +0100
Message-Id: <20201214172555.728409672@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit ad89653f79f1882d55d9df76c9b2b94f008c4e27 ]

Pinned pages are not properly accounted particularly when
mapping error occurs on IOTLB update. Clean up dangling
pinned pages for the error path.

The memory usage for bookkeeping pinned pages is reverted
to what it was before: only one single free page is needed.
This helps reduce the host memory demand for VM with a large
amount of memory, or in the situation where host is running
short of free memory.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Link: https://lore.kernel.org/r/1604618793-4681-1-git-send-email-si-wei.liu@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 80 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 676175bd9a679..eed604fe4d215 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -567,6 +567,8 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 
 	if (r)
 		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
+	else
+		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 
 	return r;
 }
@@ -598,14 +600,16 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long locked, lock_limit, pinned, i;
+	unsigned long lock_limit, sz2pin, nchunks, i;
 	u64 iova = msg->iova;
+	long pinned;
 	int ret = 0;
 
 	if (vhost_iotlb_itree_first(iotlb, msg->iova,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
+	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
@@ -614,52 +618,75 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		gup_flags |= FOLL_WRITE;
 
 	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
-	if (!npages)
-		return -EINVAL;
+	if (!npages) {
+		ret = -EINVAL;
+		goto free;
+	}
 
 	mmap_read_lock(dev->mm);
 
-	locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (locked > lock_limit) {
+	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
 		ret = -ENOMEM;
-		goto out;
+		goto unlock;
 	}
 
 	cur_base = msg->uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
+	nchunks = 0;
 
 	while (npages) {
-		pinned = min_t(unsigned long, npages, list_size);
-		ret = pin_user_pages(cur_base, pinned,
-				     gup_flags, page_list, NULL);
-		if (ret != pinned)
+		sz2pin = min_t(unsigned long, npages, list_size);
+		pinned = pin_user_pages(cur_base, sz2pin,
+					gup_flags, page_list, NULL);
+		if (sz2pin != pinned) {
+			if (pinned < 0) {
+				ret = pinned;
+			} else {
+				unpin_user_pages(page_list, pinned);
+				ret = -ENOMEM;
+			}
 			goto out;
+		}
+		nchunks++;
 
 		if (!last_pfn)
 			map_pfn = page_to_pfn(page_list[0]);
 
-		for (i = 0; i < ret; i++) {
+		for (i = 0; i < pinned; i++) {
 			unsigned long this_pfn = page_to_pfn(page_list[i]);
 			u64 csize;
 
 			if (last_pfn && (this_pfn != last_pfn + 1)) {
 				/* Pin a contiguous chunk of memory */
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
-				if (vhost_vdpa_map(v, iova, csize,
-						   map_pfn << PAGE_SHIFT,
-						   msg->perm))
+				ret = vhost_vdpa_map(v, iova, csize,
+						     map_pfn << PAGE_SHIFT,
+						     msg->perm);
+				if (ret) {
+					/*
+					 * Unpin the pages that are left unmapped
+					 * from this point on in the current
+					 * page_list. The remaining outstanding
+					 * ones which may stride across several
+					 * chunks will be covered in the common
+					 * error path subsequently.
+					 */
+					unpin_user_pages(&page_list[i],
+							 pinned - i);
 					goto out;
+				}
+
 				map_pfn = this_pfn;
 				iova += csize;
+				nchunks = 0;
 			}
 
 			last_pfn = this_pfn;
 		}
 
-		cur_base += ret << PAGE_SHIFT;
-		npages -= ret;
+		cur_base += pinned << PAGE_SHIFT;
+		npages -= pinned;
 	}
 
 	/* Pin the rest chunk */
@@ -667,10 +694,27 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			     map_pfn << PAGE_SHIFT, msg->perm);
 out:
 	if (ret) {
+		if (nchunks) {
+			unsigned long pfn;
+
+			/*
+			 * Unpin the outstanding pages which are yet to be
+			 * mapped but haven't due to vdpa_map() or
+			 * pin_user_pages() failure.
+			 *
+			 * Mapped pages are accounted in vdpa_map(), hence
+			 * the corresponding unpinning will be handled by
+			 * vdpa_unmap().
+			 */
+			WARN_ON(!last_pfn);
+			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
+				unpin_user_page(pfn_to_page(pfn));
+		}
 		vhost_vdpa_unmap(v, msg->iova, msg->size);
-		atomic64_sub(npages, &dev->mm->pinned_vm);
 	}
+unlock:
 	mmap_read_unlock(dev->mm);
+free:
 	free_page((unsigned long)page_list);
 	return ret;
 }
-- 
2.27.0



