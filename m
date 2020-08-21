Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5402524D0CD
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 10:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgHUIuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 04:50:19 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:55722 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727868AbgHUIuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 04:50:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22195097-1500050 
        for multiple; Fri, 21 Aug 2020 09:50:14 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     linux-mm@kvack.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] mm: Export flush_vm_area() to sync the PTEs upon construction
Date:   Fri, 21 Aug 2020 09:50:08 +0100
Message-Id: <20200821085011.28878-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The alloc_vm_area() is another method for drivers to
vmap/map_kernel_range that uses apply_to_page_range() rather than the
direct vmalloc walkers. This is missing the page table modification
tracking, and the ability to synchronize the PTE updates afterwards.
Provide flush_vm_area() for the users of alloc_vm_area() that assumes
the worst and ensures that the page directories are correctly flushed
upon construction.

The impact is most pronounced on x86_32 due to the delayed set_pmd().

Reported-by: Pavel Machek <pavel@ucw.cz>
References: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
References: 86cf69f1d893 ("x86/mm/32: implement arch_sync_kernel_mappings()")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: <stable@vger.kernel.org> # v5.8+
---
 include/linux/vmalloc.h |  1 +
 mm/vmalloc.c            | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 0221f852a7e1..a253b27df0ac 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -204,6 +204,7 @@ static inline void set_vm_flush_reset_perms(void *addr)
 
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes);
+extern void flush_vm_area(struct vm_struct *area);
 extern void free_vm_area(struct vm_struct *area);
 
 /* for /dev/kmem */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b482d240f9a2..c41934486031 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3078,6 +3078,22 @@ struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
 }
 EXPORT_SYMBOL_GPL(alloc_vm_area);
 
+void flush_vm_area(struct vm_struct *area)
+{
+	unsigned long addr = (unsigned long)area->addr;
+
+	/* apply_to_page_range() doesn't track the damage, assume the worst */
+	if (ARCH_PAGE_TABLE_SYNC_MASK & (PGTBL_PTE_MODIFIED |
+					 PGTBL_PMD_MODIFIED |
+					 PGTBL_PUD_MODIFIED |
+					 PGTBL_P4D_MODIFIED |
+					 PGTBL_PGD_MODIFIED))
+		arch_sync_kernel_mappings(addr, addr + area->size);
+
+	flush_cache_vmap(addr, area->size);
+}
+EXPORT_SYMBOL_GPL(flush_vm_area);
+
 void free_vm_area(struct vm_struct *area)
 {
 	struct vm_struct *ret;
-- 
2.20.1

