Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2181B99
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfHENGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbfHENGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:06:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398F42075B;
        Mon,  5 Aug 2019 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010376;
        bh=IoNxLXBCMtqV0FlPq4a4PRsxe+vdwsmKIiPM2OI8hdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhIKBBJXer6Zwm3Kl3M3jBUAfSb/mHqoEPQ1hltTRIOpmXoPAfTqQ6ZxiSs2ox4Hs
         nIv+6sv56FC5lEIlpyJJFRFTMJtdsbiURyJDBEjhPe1vChBGbemFqEaPVeBprbwMfe
         VW/ixx9GsVDDeh5k4S/unq45psOenG471u27n61Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 4.9 42/42] x86, mm, gup: prevent get_page() race with munmap in paravirt guest
Date:   Mon,  5 Aug 2019 15:03:08 +0200
Message-Id: <20190805124930.008720376@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

The x86 version of get_user_pages_fast() relies on disabled interrupts to
synchronize gup_pte_range() between gup_get_pte(ptep); and get_page() against
a parallel munmap. The munmap side nulls the pte, then flushes TLBs, then
releases the page. As TLB flush is done synchronously via IPI disabling
interrupts blocks the page release, and get_page(), which assumes existing
reference on page, is thus safe.
However when TLB flush is done by a hypercall, e.g. in a Xen PV guest, there is
no blocking thanks to disabled interrupts, and get_page() can succeed on a page
that was already freed or even reused.

We have recently seen this happen with our 4.4 and 4.12 based kernels, with
userspace (java) that exits a thread, where mm_release() performs a futex_wake()
on tsk->clear_child_tid, and another thread in parallel unmaps the page where
tsk->clear_child_tid points to. The spurious get_page() succeeds, but futex code
immediately releases the page again, while it's already on a freelist. Symptoms
include a bad page state warning, general protection faults acessing a poisoned
list prev/next pointer in the freelist, or free page pcplists of two cpus joined
together in a single list. Oscar has also reproduced this scenario, with a
patch inserting delays before the get_page() to make the race window larger.

Fix this by removing the dependency on TLB flush interrupts the same way as the
generic get_user_pages_fast() code by using page_cache_add_speculative() and
revalidating the PTE contents after pinning the page. Mainline is safe since
4.13 where the x86 gup code was removed in favor of the common code. Accessing
the page table itself safely also relies on disabled interrupts and TLB flush
IPIs that don't happen with hypercalls, which was acknowledged in commit
9e52fc2b50de ("x86/mm: Enable RCU based page table freeing
(CONFIG_HAVE_RCU_TABLE_FREE=y)"). That commit with follups should also be
backported for full safety, although our reproducer didn't hit a problem
without that backport.

Reproduced-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

---
 arch/x86/mm/gup.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -98,6 +98,20 @@ static inline int pte_allows_gup(unsigne
 }
 
 /*
+ * Return the compund head page with ref appropriately incremented,
+ * or NULL if that failed.
+ */
+static inline struct page *try_get_compound_head(struct page *page, int refs)
+{
+	struct page *head = compound_head(page);
+	if (WARN_ON_ONCE(page_ref_count(head) < 0))
+		return NULL;
+	if (unlikely(!page_cache_add_speculative(head, refs)))
+		return NULL;
+	return head;
+}
+
+/*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
  * register pressure.
@@ -112,7 +126,7 @@ static noinline int gup_pte_range(pmd_t
 	ptep = pte_offset_map(&pmd, addr);
 	do {
 		pte_t pte = gup_get_pte(ptep);
-		struct page *page;
+		struct page *head, *page;
 
 		/* Similar to the PMD case, NUMA hinting must take slow path */
 		if (pte_protnone(pte)) {
@@ -138,7 +152,21 @@ static noinline int gup_pte_range(pmd_t
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		get_page(page);
+
+		head = try_get_compound_head(page, 1);
+		if (!head) {
+			put_dev_pagemap(pgmap);
+			pte_unmap(ptep);
+			return 0;
+		}
+
+		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+			put_page(head);
+			put_dev_pagemap(pgmap);
+			pte_unmap(ptep);
+			return 0;
+		}
+
 		put_dev_pagemap(pgmap);
 		SetPageReferenced(page);
 		pages[*nr] = page;


