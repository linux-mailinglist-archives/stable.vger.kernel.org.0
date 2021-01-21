Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933692FF80C
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 23:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbhAUWh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 17:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbhAUWhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 17:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1163E21973;
        Thu, 21 Jan 2021 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611268604;
        bh=xp35DwQ7FCeL3oCOWCT+bQc5IxE0PrGzVdBjUlH5/m8=;
        h=Date:From:To:Subject:From;
        b=lDSqAmQr/5Sk9CqCNmGeNL3wgiisMxRD2oQIBr21OWCHw9o6q+jXa19veDYGjfxlt
         6VBwOuN0ehYxIe2Fh8ybwi96EqJRl4aC7Wrm6EiDkqVMdvrlyX4CGplmO2ry6nNzOg
         EjnNYO7UyOi2EuGsXoF5kHe+b99RxP9KB3NFhTp4=
Date:   Thu, 21 Jan 2021 14:36:43 -0800
From:   akpm@linux-foundation.org
To:     dja@axtens.net, hch@lst.de, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  + mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch
 added to -mm tree
Message-ID: <20210121223643.kgpB7aWFm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: reparate put pages and flush VM flags
has been added to the -mm tree.  Its filename is
     mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

