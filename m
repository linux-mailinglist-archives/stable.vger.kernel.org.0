Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF13121737
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfLPSHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbfLPSHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616542072D;
        Mon, 16 Dec 2019 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519632;
        bh=oRzdRTKZzgbqeC0gBvACmOA0kK8AxkQCHINuLylhXnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k36fSczShgTuriX5Vw+y5xdBmkfm6IzFL0UHRjNVHA43Yoroyrt+GMrD7Qg4GLYgv
         w1qkEKgwTN9uBPdShqNSse3qVq108QNjRJEZ4Rx+4x1Ve01h27rLHdkYEPIT+yabEq
         tP6W9CAJA7FYjq4t+AqUjkS611Fgfe4IuO7FVd3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/140] mm/memory.c: fix a huge pud insertion race during faulting
Date:   Mon, 16 Dec 2019 18:50:07 +0100
Message-Id: <20191216174829.761116794@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 625110b5e9dae9074d8a7e67dd07f821a053eed7 ]

A huge pud page can theoretically be faulted in racing with pmd_alloc()
in __handle_mm_fault().  That will lead to pmd_alloc() returning an
invalid pmd pointer.

Fix this by adding a pud_trans_unstable() function similar to
pmd_trans_unstable() and check whether the pud is really stable before
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
write-tracking which is, I believe, a prerequisite for create_huge_pud()
falling back on thread 1, but not in thread 2.

Link: http://lkml.kernel.org/r/20191115115808.21181-2-thomas_os@shipmail.org
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/pgtable.h | 25 +++++++++++++++++++++++++
 mm/memory.c                   |  6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 15fd0277ffa69..f94c39070dcca 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -874,6 +874,31 @@ static inline int pud_trans_huge(pud_t pud)
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
diff --git a/mm/memory.c b/mm/memory.c
index bbf0cc4066c84..f910da42a1f01 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4106,6 +4106,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	vmf.pud = pud_alloc(mm, p4d, address);
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
+retry_pud:
 	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
@@ -4132,6 +4133,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
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
-- 
2.20.1



