Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0B301922
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 02:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbhAXBRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 20:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbhAXBRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 20:17:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE3B22CB9;
        Sun, 24 Jan 2021 01:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611450995;
        bh=xIou3RImhETrqee+L2bfbjzhSJvhYeJmJtP/YaY/218=;
        h=Date:From:To:Subject:From;
        b=1oljlXb3Oz1M5COMQQxAmFi/4sh+1EdVjPdfoVi993qvhy9W3EtpGR2UOkOOze9dF
         nv53vjwjGfE205Kgiyi4XpQmgRk+JnNDyw5OSHDqbt69j7AI4TVNuqwDr78qqzoMhF
         /wTkDMOr4uKZ0dtBlAQ3JL9+fGlEph0fPgw1o8Lk=
Date:   Sat, 23 Jan 2021 17:16:34 -0800
From:   akpm@linux-foundation.org
To:     dja@axtens.net, hch@lst.de, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rick.p.edgecombe@intel.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  + mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch
 added to -mm tree
Message-ID: <20210124011634.iE-2pl6zF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: separate put pages and flush VM flags
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
Subject: mm/vmalloc: separate put pages and flush VM flags

When VM_MAP_PUT_PAGES was added, it was defined with the same value as
VM_FLUSH_RESET_PERMS.  This doesn't seem like it will cause any big
functional problems other than some excess flushing for VM_MAP_PUT_PAGES
allocations.

Redefine VM_MAP_PUT_PAGES to have its own value.  Also, rearrange things
so flags are less likely to be missed in the future.

Link: https://lkml.kernel.org/r/20210122233706.9304-1-rick.p.edgecombe@intel.com
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-separate-put-pages-and-flush-vm-flags
+++ a/include/linux/vmalloc.h
@@ -24,7 +24,8 @@ struct notifier_block;		/* in notifier.h
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
-#define VM_MAP_PUT_PAGES	0x00000100	/* put pages and free array in vfree */
+#define VM_FLUSH_RESET_PERMS	0x00000100	/* reset direct map and flush TLB on unmap, can't be freed in atomic context */
+#define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 
 /*
  * VM_KASAN is used slighly differently depending on CONFIG_KASAN_VMALLOC.
@@ -37,12 +38,6 @@ struct notifier_block;		/* in notifier.h
  * determine which allocations need the module shadow freed.
  */
 
-/*
- * Memory with VM_FLUSH_RESET_PERMS cannot be freed in an interrupt or with
- * vfree_atomic().
- */
-#define VM_FLUSH_RESET_PERMS	0x00000100      /* Reset direct map and flush TLB on unmap */
-
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are

mm-vmalloc-separate-put-pages-and-flush-vm-flags.patch

