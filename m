Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC83510E01B
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 02:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLABve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Nov 2019 20:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbfLABve (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Nov 2019 20:51:34 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0102215A5;
        Sun,  1 Dec 2019 01:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575165093;
        bh=5YG5SJgJYRkpy/Jj3Zis4wmBxE1XZBfNejKoHe/VckI=;
        h=Date:From:To:Subject:From;
        b=THT/rLMxIS3YchSgfxZz5Oh8h0BG/75EblcSjLXA2wQcK/Us5+xX8aJngbmv6uxAp
         YKZx7+OCYsQnOacpLv7wud6vZjmFBNfaaBjUAp9gIr0uacqeIwuwadh61cyOXtjfvq
         VBIS+WypFFnQ8FHZVtOODQXuCHgWMZKSfClKfChw=
Date:   Sat, 30 Nov 2019 17:51:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        thellstrom@vmware.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 045/158] mm/memory.c: fix a huge pud insertion
 race during faulting
Message-ID: <20191201015132.LxbEPLRfg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: mm/memory.c: fix a huge pud insertion race during faulting

A huge pud page can theoretically be faulted in racing with pmd_alloc() in
__handle_mm_fault().  That will lead to pmd_alloc() returning an invalid
pmd pointer.  Fix this by adding a pud_trans_unstable() function similar
to pmd_trans_unstable() and check whether the pud is really stable before
using the pmd pointer.

Race:
Thread 1:             Thread 2:                 Comment
create_huge_pud()                               Fallback - not taken.
		      create_huge_pud()         Taken.
pmd_alloc()                                     Returns an invalid pointer.

This will result in user-visible huge page data corruption.

Note that this was caught during a code audit rather than a real
experienced problem.  It looks to me like the only implementation that
currently creates huge pud pagetable entries is dev_dax_huge_fault()
which doesn't appear to care much about private (COW) mappings or
write-tracking which is, I believe, a prerequisite for
create_huge_pud() falling back on thread 1, but not in thread 2.

Link: http://lkml.kernel.org/r/20191115115808.21181-2-thomas_os@shipmail.org
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   25 +++++++++++++++++++++++++
 mm/memory.c                   |    6 ++++++
 2 files changed, 31 insertions(+)

--- a/include/asm-generic/pgtable.h~mm-fix-a-huge-pud-insertion-race-during-faulting
+++ a/include/asm-generic/pgtable.h
@@ -938,6 +938,31 @@ static inline int pud_trans_huge(pud_t p
 }
 #endif
 
+/* See pmd_none_or_trans_huge_or_clear_bad for discussion. */
+static inline int pud_none_or_trans_huge_or_dev_or_clear_bad(pud_t *pud)
+{
+	pud_t pudval = READ_ONCE(*pud);
+
+	if (pud_none(pudval) || pud_trans_huge(pudval) || pud_devmap(pudval))
+		return 1;
+	if (unlikely(pud_bad(pudval))) {
+		pud_clear_bad(pud);
+		return 1;
+	}
+	return 0;
+}
+
+/* See pmd_trans_unstable for discussion. */
+static inline int pud_trans_unstable(pud_t *pud)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	return pud_none_or_trans_huge_or_dev_or_clear_bad(pud);
+#else
+	return 0;
+#endif
+}
+
 #ifndef pmd_read_atomic
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
--- a/mm/memory.c~mm-fix-a-huge-pud-insertion-race-during-faulting
+++ a/mm/memory.c
@@ -4010,6 +4010,7 @@ static vm_fault_t __handle_mm_fault(stru
 	vmf.pud = pud_alloc(mm, p4d, address);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
+retry_pud:
 	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
@@ -4036,6 +4037,11 @@ static vm_fault_t __handle_mm_fault(stru
 	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
 	if (!vmf.pmd)
 		return VM_FAULT_OOM;
+
+	/* Huge pud page fault raced with pmd_alloc? */
+	if (pud_trans_unstable(vmf.pud))
+		goto retry_pud;
+
 	if (pmd_none(*vmf.pmd) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
_
