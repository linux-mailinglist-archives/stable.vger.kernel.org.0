Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453AC60FEBD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiJ0RH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiJ0RHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E563D19C06E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7735B62369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEABC433D6;
        Thu, 27 Oct 2022 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890471;
        bh=RNGqcO69U+e9xspI/Nsjd5X/DRIkdlPMC7d6S0anhBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piWN0X+n1EqY4pGl/bO0XKplXdDEwtk36frYnrQj1pZR/Wb2lVZiEJgUmb4RW4SQT
         uijYCTWViJ57jXJtmiZdiRT1jIQ6s9L7bP9h4kJvQpVDwR63+chv53sGCjCXHTbrut
         CHfVvDpEdZwPay4DOOQq7rIRAwCf9Jaqt2d5KTj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/79] xen/gntdev: Accommodate VMA splitting
Date:   Thu, 27 Oct 2022 18:56:11 +0200
Message-Id: <20221027165056.384358616@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

[ Upstream commit 5c13a4a0291b30191eff9ead8d010e1ca43a4d0c ]

Prior to this commit, the gntdev driver code did not handle the
following scenario correctly with paravirtualized (PV) Xen domains:

* User process sets up a gntdev mapping composed of two grant mappings
  (i.e., two pages shared by another Xen domain).
* User process munmap()s one of the pages.
* User process munmap()s the remaining page.
* User process exits.

In the scenario above, the user process would cause the kernel to log
the following messages in dmesg for the first munmap(), and the second
munmap() call would result in similar log messages:

  BUG: Bad page map in process doublemap.test  pte:... pmd:...
  page:0000000057c97bff refcount:1 mapcount:-1 \
    mapping:0000000000000000 index:0x0 pfn:...
  ...
  page dumped because: bad pte
  ...
  file:gntdev fault:0x0 mmap:gntdev_mmap [xen_gntdev] readpage:0x0
  ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x46/0x5e
   print_bad_pte.cold+0x66/0xb6
   unmap_page_range+0x7e5/0xdc0
   unmap_vmas+0x78/0xf0
   unmap_region+0xa8/0x110
   __do_munmap+0x1ea/0x4e0
   __vm_munmap+0x75/0x120
   __x64_sys_munmap+0x28/0x40
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x61/0xcb
   ...

For each munmap() call, the Xen hypervisor (if built with CONFIG_DEBUG)
would print out the following and trigger a general protection fault in
the affected Xen PV domain:

  (XEN) d0v... Attempt to implicitly unmap d0's grant PTE ...
  (XEN) d0v... Attempt to implicitly unmap d0's grant PTE ...

As of this writing, gntdev_grant_map structure's vma field (referred to
as map->vma below) is mainly used for checking the start and end
addresses of mappings. However, with split VMAs, these may change, and
there could be more than one VMA associated with a gntdev mapping.
Hence, remove the use of map->vma and rely on map->pages_vm_start for
the original start address and on (map->count << PAGE_SHIFT) for the
original mapping size. Let the invalidate() and find_special_page()
hooks use these.

Also, given that there can be multiple VMAs associated with a gntdev
mapping, move the "mmu_interval_notifier_remove(&map->notifier)" call to
the end of gntdev_put_map, so that the MMU notifier is only removed
after the closing of the last remaining VMA.

Finally, use an atomic to prevent inadvertent gntdev mapping re-use,
instead of using the map->live_grants atomic counter and/or the map->vma
pointer (the latter of which is now removed). This prevents the
userspace from mmap()'ing (with MAP_FIXED) a gntdev mapping over the
same address range as a previously set up gntdev mapping. This scenario
can be summarized with the following call-trace, which was valid prior
to this commit:

  mmap
    gntdev_mmap
  mmap (repeat mmap with MAP_FIXED over the same address range)
    gntdev_invalidate
      unmap_grant_pages (sets 'being_removed' entries to true)
        gnttab_unmap_refs_async
    unmap_single_vma
    gntdev_mmap (maps the shared pages again)
  munmap
    gntdev_invalidate
      unmap_grant_pages
        (no-op because 'being_removed' entries are true)
    unmap_single_vma (For PV domains, Xen reports that a granted page
      is being unmapped and triggers a general protection fault in the
      affected domain, if Xen was built with CONFIG_DEBUG)

The fix for this last scenario could be worth its own commit, but we
opted for a single commit, because removing the gntdev_grant_map
structure's vma field requires guarding the entry to gntdev_mmap(), and
the live_grants atomic counter is not sufficient on its own to prevent
the mmap() over a pre-existing mapping.

Link: https://github.com/QubesOS/qubes-issues/issues/7631
Fixes: ab31523c2fca ("xen/gntdev: allow usermode to map granted pages")
Cc: stable@vger.kernel.org
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221002222006.2077-3-m.v.b@runbox.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-common.h |  3 +-
 drivers/xen/gntdev.c        | 58 ++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 40ef379c28ab..9c286b2a1900 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -44,9 +44,10 @@ struct gntdev_unmap_notify {
 };
 
 struct gntdev_grant_map {
+	atomic_t in_use;
 	struct mmu_interval_notifier notifier;
+	bool notifier_init;
 	struct list_head next;
-	struct vm_area_struct *vma;
 	int index;
 	int count;
 	int flags;
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 5dd9d1ac755e..ff195b571763 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -276,6 +276,9 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 		 */
 	}
 
+	if (use_ptemod && map->notifier_init)
+		mmu_interval_notifier_remove(&map->notifier);
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -288,7 +291,7 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 {
 	struct gntdev_grant_map *map = data;
-	unsigned int pgnr = (addr - map->vma->vm_start) >> PAGE_SHIFT;
+	unsigned int pgnr = (addr - map->pages_vm_start) >> PAGE_SHIFT;
 	int flags = map->flags | GNTMAP_application_map | GNTMAP_contains_pte |
 		    (1 << _GNTMAP_guest_avail0);
 	u64 pte_maddr;
@@ -478,11 +481,7 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 	struct gntdev_priv *priv = file->private_data;
 
 	pr_debug("gntdev_vma_close %p\n", vma);
-	if (use_ptemod) {
-		WARN_ON(map->vma != vma);
-		mmu_interval_notifier_remove(&map->notifier);
-		map->vma = NULL;
-	}
+
 	vma->vm_private_data = NULL;
 	gntdev_put_map(priv, map);
 }
@@ -510,29 +509,30 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
+	unsigned long map_start, map_end;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
 
+	map_start = map->pages_vm_start;
+	map_end = map->pages_vm_start + (map->count << PAGE_SHIFT);
+
 	/*
 	 * If the VMA is split or otherwise changed the notifier is not
 	 * updated, but we don't want to process VA's outside the modified
 	 * VMA. FIXME: It would be much more understandable to just prevent
 	 * modifying the VMA in the first place.
 	 */
-	if (map->vma->vm_start >= range->end ||
-	    map->vma->vm_end <= range->start)
+	if (map_start >= range->end || map_end <= range->start)
 		return true;
 
-	mstart = max(range->start, map->vma->vm_start);
-	mend = min(range->end, map->vma->vm_end);
+	mstart = max(range->start, map_start);
+	mend = min(range->end, map_end);
 	pr_debug("map %d+%d (%lx %lx), range %lx %lx, mrange %lx %lx\n",
-			map->index, map->count,
-			map->vma->vm_start, map->vma->vm_end,
-			range->start, range->end, mstart, mend);
-	unmap_grant_pages(map,
-				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
-				(mend - mstart) >> PAGE_SHIFT);
+		 map->index, map->count, map_start, map_end,
+		 range->start, range->end, mstart, mend);
+	unmap_grant_pages(map, (mstart - map_start) >> PAGE_SHIFT,
+			  (mend - mstart) >> PAGE_SHIFT);
 
 	return true;
 }
@@ -1012,18 +1012,15 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
-			index, count, vma->vm_start, vma->vm_pgoff);
+		 index, count, vma->vm_start, vma->vm_pgoff);
 
 	mutex_lock(&priv->lock);
 	map = gntdev_find_map_index(priv, index, count);
 	if (!map)
 		goto unlock_out;
-	if (use_ptemod && map->vma)
-		goto unlock_out;
-	if (atomic_read(&map->live_grants)) {
-		err = -EAGAIN;
+	if (!atomic_add_unless(&map->in_use, 1, 1))
 		goto unlock_out;
-	}
+
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
@@ -1044,15 +1041,16 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 			map->flags |= GNTMAP_readonly;
 	}
 
+	map->pages_vm_start = vma->vm_start;
+
 	if (use_ptemod) {
-		map->vma = vma;
 		err = mmu_interval_notifier_insert_locked(
 			&map->notifier, vma->vm_mm, vma->vm_start,
 			vma->vm_end - vma->vm_start, &gntdev_mmu_ops);
-		if (err) {
-			map->vma = NULL;
+		if (err)
 			goto out_unlock_put;
-		}
+
+		map->notifier_init = true;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -1069,7 +1067,6 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		 */
 		mmu_interval_read_begin(&map->notifier);
 
-		map->pages_vm_start = vma->vm_start;
 		err = apply_to_page_range(vma->vm_mm, vma->vm_start,
 					  vma->vm_end - vma->vm_start,
 					  find_grant_ptes, map);
@@ -1098,13 +1095,8 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 out_unlock_put:
 	mutex_unlock(&priv->lock);
 out_put_map:
-	if (use_ptemod) {
+	if (use_ptemod)
 		unmap_grant_pages(map, 0, map->count);
-		if (map->vma) {
-			mmu_interval_notifier_remove(&map->notifier);
-			map->vma = NULL;
-		}
-	}
 	gntdev_put_map(priv, map);
 	return err;
 }
-- 
2.35.1



