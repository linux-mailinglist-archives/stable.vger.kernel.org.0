Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10650301920
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 02:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhAXBQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 20:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAXBQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 20:16:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD09C22CB9;
        Sun, 24 Jan 2021 01:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450937;
        bh=GWtpz8VHGWR5UOTww5kW6j6E0tkD7p9dquPQZcaCqx8=;
        h=Date:From:To:Subject:From;
        b=DDflMACx1+Wpf32URHKeoMAha/SP+W3V37Reic0w/7TmdMI4RCEpxRgQie8/8Tx0+
         rYzFTGnx4I1Gmh9YkUWThc+9TzEUYgaQLti9mF6oqmTagdyXfAntNeu6TaRkVyFo23
         G3I6i18JloLnlwhreVXhXnIjJa2m4aJASxnF4aIY=
Date:   Sat, 23 Jan 2021 17:15:36 -0800
From:   akpm@linux-foundation.org
To:     dja@axtens.net, hch@lst.de, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [to-be-updated]
 mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch removed from -mm
 tree
Message-ID: <20210124011536.gnMEJzkWm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: reparate put pages and flush VM flags
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: mm/vmalloc: reparate put pages and flush VM flags

When VM_MAP_PUT_PAGES was added, it was defined with the same value as
VM_FLUSH_RESET_PERMS.  This doesn't seem like it will cause any big
functional problems other than some excess flushing for VM_MAP_PUT_PAGES
allocations.

Redefine VM_MAP_PUT_PAGES to have its own value.  Also, move the comment
and remove whitespace for VM_KASAN such that the flags lower down are less
likely to be missed in the future.

Link: https://lkml.kernel.org/r/20210121014118.31922-1-rick.p.edgecombe@intel.com
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-separate-put-pages-and-flush-vm-flags
+++ a/include/linux/vmalloc.h
@@ -23,9 +23,6 @@ struct notifier_block;		/* in notifier.h
 #define VM_DMA_COHERENT		0x00000010	/* dma_alloc_coherent */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
-#define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
-#define VM_MAP_PUT_PAGES	0x00000100	/* put pages and free array in vfree */
-
 /*
  * VM_KASAN is used slighly differently depending on CONFIG_KASAN_VMALLOC.
  *
@@ -36,12 +33,13 @@ struct notifier_block;		/* in notifier.h
  * Otherwise, VM_KASAN is set for kasan_module_alloc() allocations and used to
  * determine which allocations need the module shadow freed.
  */
-
+#define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
 /*
  * Memory with VM_FLUSH_RESET_PERMS cannot be freed in an interrupt or with
  * vfree_atomic().
  */
 #define VM_FLUSH_RESET_PERMS	0x00000100      /* Reset direct map and flush TLB on unmap */
+#define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 
 /* bits [20..32] reserved for arch specific ioremap internals */
 
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


