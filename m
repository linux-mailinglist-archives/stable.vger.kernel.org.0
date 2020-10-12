Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64A128B874
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390230AbgJLNwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9773E2222F;
        Mon, 12 Oct 2020 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510432;
        bh=OWxbgRs/0Hw/KdgS5eCiMmk3zEHX0szc26E98Uvyr5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBXottP/jysjKS1KnDh4jx1vff4stI2rXgqN3/kqSSu9jd2NzNomyvF29gdK/r66d
         zOQOBHP0n/M7DtRK4Wkkcetx/GQsLtsvokFGUjJwesEvUSEfaK66TAkc632LYudnNI
         MOhAaAZRzkFnH9te2N3ahKlfbdeynl2jtpCU1lnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 097/124] vhost-vdpa: fix page pinning leakage in error path
Date:   Mon, 12 Oct 2020 15:31:41 +0200
Message-Id: <20201012133151.551422417@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit 7ed9e3d97c32d969caded2dfb6e67c1a2cc5a0b1 ]

Pinned pages are not properly accounted particularly when
mapping error occurs on IOTLB update. Clean up dangling
pinned pages for the error path. As the inflight pinned
pages, specifically for memory region that strides across
multiple chunks, would need more than one free page for
book keeping and accounting. For simplicity, pin pages
for all memory in the IOVA range in one go rather than
have multiple pin_user_pages calls to make up the entire
region. This way it's easier to track and account the
pages already mapped, particularly for clean-up in the
error path.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Link: https://lore.kernel.org/r/1601701330-16837-3-git-send-email-si-wei.liu@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 119 ++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 48 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 5259f5210b375..e172c2efc663c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -555,21 +555,19 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
-	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
+	struct vm_area_struct **vmas;
 	unsigned int gup_flags = FOLL_LONGTERM;
-	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long locked, lock_limit, pinned, i;
+	unsigned long map_pfn, last_pfn = 0;
+	unsigned long npages, lock_limit;
+	unsigned long i, nmap = 0;
 	u64 iova = msg->iova;
+	long pinned;
 	int ret = 0;
 
 	if (vhost_iotlb_itree_first(iotlb, msg->iova,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
-	if (!page_list)
-		return -ENOMEM;
-
 	if (msg->perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
@@ -577,61 +575,86 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	if (!npages)
 		return -EINVAL;
 
+	page_list = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
+	vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
+			      GFP_KERNEL);
+	if (!page_list || !vmas) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
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
 
-	cur_base = msg->uaddr & PAGE_MASK;
-	iova &= PAGE_MASK;
+	pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
+				page_list, vmas);
+	if (npages != pinned) {
+		if (pinned < 0) {
+			ret = pinned;
+		} else {
+			unpin_user_pages(page_list, pinned);
+			ret = -ENOMEM;
+		}
+		goto unlock;
+	}
 
-	while (npages) {
-		pinned = min_t(unsigned long, npages, list_size);
-		ret = pin_user_pages(cur_base, pinned,
-				     gup_flags, page_list, NULL);
-		if (ret != pinned)
-			goto out;
-
-		if (!last_pfn)
-			map_pfn = page_to_pfn(page_list[0]);
-
-		for (i = 0; i < ret; i++) {
-			unsigned long this_pfn = page_to_pfn(page_list[i]);
-			u64 csize;
-
-			if (last_pfn && (this_pfn != last_pfn + 1)) {
-				/* Pin a contiguous chunk of memory */
-				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
-				if (vhost_vdpa_map(v, iova, csize,
-						   map_pfn << PAGE_SHIFT,
-						   msg->perm))
-					goto out;
-				map_pfn = this_pfn;
-				iova += csize;
+	iova &= PAGE_MASK;
+	map_pfn = page_to_pfn(page_list[0]);
+
+	/* One more iteration to avoid extra vdpa_map() call out of loop. */
+	for (i = 0; i <= npages; i++) {
+		unsigned long this_pfn;
+		u64 csize;
+
+		/* The last chunk may have no valid PFN next to it */
+		this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
+
+		if (last_pfn && (this_pfn == -1UL ||
+				 this_pfn != last_pfn + 1)) {
+			/* Pin a contiguous chunk of memory */
+			csize = last_pfn - map_pfn + 1;
+			ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
+					     map_pfn << PAGE_SHIFT,
+					     msg->perm);
+			if (ret) {
+				/*
+				 * Unpin the rest chunks of memory on the
+				 * flight with no corresponding vdpa_map()
+				 * calls having been made yet. On the other
+				 * hand, vdpa_unmap() in the failure path
+				 * is in charge of accounting the number of
+				 * pinned pages for its own.
+				 * This asymmetrical pattern of accounting
+				 * is for efficiency to pin all pages at
+				 * once, while there is no other callsite
+				 * of vdpa_map() than here above.
+				 */
+				unpin_user_pages(&page_list[nmap],
+						 npages - nmap);
+				goto out;
 			}
-
-			last_pfn = this_pfn;
+			atomic64_add(csize, &dev->mm->pinned_vm);
+			nmap += csize;
+			iova += csize << PAGE_SHIFT;
+			map_pfn = this_pfn;
 		}
-
-		cur_base += ret << PAGE_SHIFT;
-		npages -= ret;
+		last_pfn = this_pfn;
 	}
 
-	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+	WARN_ON(nmap != npages);
 out:
-	if (ret) {
+	if (ret)
 		vhost_vdpa_unmap(v, msg->iova, msg->size);
-		atomic64_sub(npages, &dev->mm->pinned_vm);
-	}
+unlock:
 	mmap_read_unlock(dev->mm);
-	free_page((unsigned long)page_list);
+free:
+	kvfree(vmas);
+	kvfree(page_list);
 	return ret;
 }
 
-- 
2.25.1



