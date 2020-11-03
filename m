Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3318A2A586B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgKCVvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbgKCUs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13B5822404;
        Tue,  3 Nov 2020 20:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436505;
        bh=dqfSLO+/CBVVEPM5kB4ykciUWzIfWATuxS+Q0cNJzzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmLI4Z6Ky8mNV15Qe8S9w+xLfTyeqyV7dZtn1XduT1AzLmPE3gobLeAd5s9REyIzb
         D5WWkHveH2Buz+a40RPahePgTTeGYOrw6Ou5lxnjg5ZPkKH8Fw66lkirsvwLcGKp6g
         HsqM+jqHaWR7bSlIXubgg2iww7Hi6EEZCWmEhRFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.9 262/391] Revert "vhost-vdpa: fix page pinning leakage in error path"
Date:   Tue,  3 Nov 2020 21:35:13 +0100
Message-Id: <20201103203404.702588488@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 5e1a3149eec8675c2767cc465903f5e4829de5b0 upstream.

This reverts commit 7ed9e3d97c32d969caded2dfb6e67c1a2cc5a0b1.

The patch creates a DoS risk since it can result in a high order memory
allocation.

Fixes: 7ed9e3d97c32d ("vhost-vdpa: fix page pinning leakage in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vdpa.c |  117 ++++++++++++++++++++-------------------------------
 1 file changed, 47 insertions(+), 70 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -595,19 +595,21 @@ static int vhost_vdpa_process_iotlb_upda
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
-	struct vm_area_struct **vmas;
+	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
-	unsigned long map_pfn, last_pfn = 0;
-	unsigned long npages, lock_limit;
-	unsigned long i, nmap = 0;
+	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
+	unsigned long locked, lock_limit, pinned, i;
 	u64 iova = msg->iova;
-	long pinned;
 	int ret = 0;
 
 	if (vhost_iotlb_itree_first(iotlb, msg->iova,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
+	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
 	if (msg->perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
@@ -615,86 +617,61 @@ static int vhost_vdpa_process_iotlb_upda
 	if (!npages)
 		return -EINVAL;
 
-	page_list = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
-	vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!page_list || !vmas) {
-		ret = -ENOMEM;
-		goto free;
-	}
-
 	mmap_read_lock(dev->mm);
 
+	locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
 
-	pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
-				page_list, vmas);
-	if (npages != pinned) {
-		if (pinned < 0) {
-			ret = pinned;
-		} else {
-			unpin_user_pages(page_list, pinned);
-			ret = -ENOMEM;
-		}
-		goto unlock;
+	if (locked > lock_limit) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
+	cur_base = msg->uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
-	map_pfn = page_to_pfn(page_list[0]);
 
-	/* One more iteration to avoid extra vdpa_map() call out of loop. */
-	for (i = 0; i <= npages; i++) {
-		unsigned long this_pfn;
-		u64 csize;
-
-		/* The last chunk may have no valid PFN next to it */
-		this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
-
-		if (last_pfn && (this_pfn == -1UL ||
-				 this_pfn != last_pfn + 1)) {
-			/* Pin a contiguous chunk of memory */
-			csize = last_pfn - map_pfn + 1;
-			ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
-					     map_pfn << PAGE_SHIFT,
-					     msg->perm);
-			if (ret) {
-				/*
-				 * Unpin the rest chunks of memory on the
-				 * flight with no corresponding vdpa_map()
-				 * calls having been made yet. On the other
-				 * hand, vdpa_unmap() in the failure path
-				 * is in charge of accounting the number of
-				 * pinned pages for its own.
-				 * This asymmetrical pattern of accounting
-				 * is for efficiency to pin all pages at
-				 * once, while there is no other callsite
-				 * of vdpa_map() than here above.
-				 */
-				unpin_user_pages(&page_list[nmap],
-						 npages - nmap);
-				goto out;
+	while (npages) {
+		pinned = min_t(unsigned long, npages, list_size);
+		ret = pin_user_pages(cur_base, pinned,
+				     gup_flags, page_list, NULL);
+		if (ret != pinned)
+			goto out;
+
+		if (!last_pfn)
+			map_pfn = page_to_pfn(page_list[0]);
+
+		for (i = 0; i < ret; i++) {
+			unsigned long this_pfn = page_to_pfn(page_list[i]);
+			u64 csize;
+
+			if (last_pfn && (this_pfn != last_pfn + 1)) {
+				/* Pin a contiguous chunk of memory */
+				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
+				if (vhost_vdpa_map(v, iova, csize,
+						   map_pfn << PAGE_SHIFT,
+						   msg->perm))
+					goto out;
+				map_pfn = this_pfn;
+				iova += csize;
 			}
-			atomic64_add(csize, &dev->mm->pinned_vm);
-			nmap += csize;
-			iova += csize << PAGE_SHIFT;
-			map_pfn = this_pfn;
+
+			last_pfn = this_pfn;
 		}
-		last_pfn = this_pfn;
+
+		cur_base += ret << PAGE_SHIFT;
+		npages -= ret;
 	}
 
-	WARN_ON(nmap != npages);
+	/* Pin the rest chunk */
+	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
+			     map_pfn << PAGE_SHIFT, msg->perm);
 out:
-	if (ret)
+	if (ret) {
 		vhost_vdpa_unmap(v, msg->iova, msg->size);
-unlock:
+		atomic64_sub(npages, &dev->mm->pinned_vm);
+	}
 	mmap_read_unlock(dev->mm);
-free:
-	kvfree(vmas);
-	kvfree(page_list);
+	free_page((unsigned long)page_list);
 	return ret;
 }
 


