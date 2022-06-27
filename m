Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD055CCDC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiF0Lg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiF0Lfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:35:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA362DF30;
        Mon, 27 Jun 2022 04:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDF1609D0;
        Mon, 27 Jun 2022 11:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0C2C341CB;
        Mon, 27 Jun 2022 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329506;
        bh=Cn7HOCzZPBreOH/OqJgJRueEDOYd7z/1FFgplxEATAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgvHfB469juIAUiVD1QqW3G5pfNIKZmsOAVfHQzZJ/QHlwq2vxRyj6D/DE/wFjPyp
         6PdLCimuRf6ds0apg2X0/75k3lU8PFn+MZF19XKQCdUgNTAmB6nTWt9ebDobBNoupl
         WGlMK3Guk+aGIAbrJ+NzZZLJxEyEJfB2iDd/O7j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 021/135] xen/gntdev: Avoid blocking in unmap_grant_pages()
Date:   Mon, 27 Jun 2022 13:20:28 +0200
Message-Id: <20220627111938.776304843@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Demi Marie Obenour <demi@invisiblethingslab.com>

commit dbe97cff7dd9f0f75c524afdd55ad46be3d15295 upstream.

unmap_grant_pages() currently waits for the pages to no longer be used.
In https://github.com/QubesOS/qubes-issues/issues/7481, this lead to a
deadlock against i915: i915 was waiting for gntdev's MMU notifier to
finish, while gntdev was waiting for i915 to free its pages.  I also
believe this is responsible for various deadlocks I have experienced in
the past.

Avoid these problems by making unmap_grant_pages async.  This requires
making it return void, as any errors will not be available when the
function returns.  Fortunately, the only use of the return value is a
WARN_ON(), which can be replaced by a WARN_ON when the error is
detected.  Additionally, a failed call will not prevent further calls
from being made, but this is harmless.

Because unmap_grant_pages is now async, the grant handle will be sent to
INVALID_GRANT_HANDLE too late to prevent multiple unmaps of the same
handle.  Instead, a separate bool array is allocated for this purpose.
This wastes memory, but stuffing this information in padding bytes is
too fragile.  Furthermore, it is necessary to grab a reference to the
map before making the asynchronous call, and release the reference when
the call returns.

It is also necessary to guard against reentrancy in gntdev_map_put(),
and to handle the case where userspace tries to map a mapping whose
contents have not all been freed yet.

Fixes: 745282256c75 ("xen/gntdev: safely unmap grants in case they are still in use")
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220622022726.2538-1-demi@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev-common.h |    7 +
 drivers/xen/gntdev.c        |  157 +++++++++++++++++++++++++++++---------------
 2 files changed, 113 insertions(+), 51 deletions(-)

--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
 #include <xen/interface/event_channel.h>
+#include <xen/grant_table.h>
 
 struct gntdev_dmabuf_priv;
 
@@ -56,6 +57,7 @@ struct gntdev_grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
 
@@ -73,6 +75,11 @@ struct gntdev_grant_map {
 	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
 	xen_pfn_t *frames;
 #endif
+
+	/* Number of live grants */
+	atomic_t live_grants;
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -60,10 +61,11 @@ module_param(limit, uint, 0644);
 MODULE_PARM_DESC(limit,
 	"Maximum number of grants that may be mapped by one mapping request");
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -120,6 +122,7 @@ static void gntdev_free_map(struct gntde
 	kvfree(map->unmap_ops);
 	kvfree(map->kmap_ops);
 	kvfree(map->kunmap_ops);
+	kvfree(map->being_removed);
 	kfree(map);
 }
 
@@ -140,10 +143,13 @@ struct gntdev_grant_map *gntdev_alloc_ma
 	add->unmap_ops = kvmalloc_array(count, sizeof(add->unmap_ops[0]),
 					GFP_KERNEL);
 	add->pages     = kvcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kvcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 	if (use_ptemod) {
 		add->kmap_ops   = kvmalloc_array(count, sizeof(add->kmap_ops[0]),
@@ -250,9 +256,36 @@ void gntdev_put_map(struct gntdev_priv *
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
-	if (map->pages && !use_ptemod)
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * reference count greater than 1, so they will return before
+		 * this code is reached.  The recursion depth is thus limited to
+		 * 1.  Do NOT use refcount_inc() here, as it will detect that
+		 * the reference count is zero and WARN().
+		 */
+		refcount_set(&map->users, 1);
+
+		/*
+		 * Unmap the grants.  This may or may not be asynchronous, so it
+		 * is possible that the reference count is 1 on return, but it
+		 * could also be greater than 1.
+		 */
 		unmap_grant_pages(map, 0, map->count);
 
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -283,6 +316,7 @@ static int find_grant_ptes(pte_t *pte, u
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -331,97 +365,116 @@ int gntdev_map_grant_pages(struct gntdev
 			map->count);
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status == GNTST_okay)
+		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-		else if (!err)
+			if (!use_ptemod)
+				alloced++;
+		} else if (!err)
 			err = -EINVAL;
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
 		if (use_ptemod) {
-			if (map->kmap_ops[i].status == GNTST_okay)
+			if (map->kmap_ops[i].status == GNTST_okay) {
+				if (map->map_ops[i].status == GNTST_okay)
+					alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
-			else if (!err)
+			} else if (!err)
 				err = -EINVAL;
 		}
 	}
+	atomic_add(alloced, &map->live_grants);
 	return err;
 }
 
-static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			       int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
-
-	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
-		int pgno = (map->notify.addr >> PAGE_SHIFT);
-		if (pgno >= offset && pgno < offset + pages) {
-			/* No need for kmap, pages are in lowmem */
-			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
-			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
-			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
-		}
-	}
-
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
-
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
+	unsigned int i;
+	struct gntdev_grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			if (map->kunmap_ops[offset+i].status)
-				err = -EINVAL;
+			WARN_ON(map->kunmap_ops[offset+i].status);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
 			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		}
 	}
-	return err;
+	/*
+	 * Decrease the live-grant counter.  This must happen after the loop to
+	 * prevent premature reuse of the grants by gnttab_mmap().
+	 */
+	atomic_sub(data->count, &map->live_grants);
+
+	/* Release reference taken by __unmap_grant_pages */
+	gntdev_put_map(NULL, map);
 }
 
-static int unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			     int pages)
+static void __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			       int pages)
 {
-	int range, err = 0;
+	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
+		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
+		if (pgno >= offset && pgno < offset + pages) {
+			/* No need for kmap, pages are in lowmem */
+			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
+			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
+			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
+		}
+	}
+
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
+
+	gnttab_unmap_refs_async(&map->unmap_data);
+}
+
+static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			      int pages)
+{
+	int range;
+
+	if (atomic_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages &&
-		       map->unmap_ops[offset].handle == INVALID_GRANT_HANDLE) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset + range].handle ==
-			    INVALID_GRANT_HANDLE)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -473,7 +526,6 @@ static bool gntdev_invalidate(struct mmu
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -494,10 +546,9 @@ static bool gntdev_invalidate(struct mmu
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			range->start, range->end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 
 	return true;
 }
@@ -985,6 +1036,10 @@ static int gntdev_mmap(struct file *flip
 		goto unlock_out;
 	if (use_ptemod && map->vma)
 		goto unlock_out;
+	if (atomic_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;


