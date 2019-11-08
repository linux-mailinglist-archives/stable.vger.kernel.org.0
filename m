Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFECF4383
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfKHJi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:39674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731147AbfKHJi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99ECAAE61;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH STABLE 4.4 8/8] x86, mm, gup: prevent get_page() race with munmap in paravirt guest
Date:   Fri,  8 Nov 2019 10:38:14 +0100
Message-Id: <20191108093814.16032-9-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108093814.16032-1-vbabka@suse.cz>
References: <20191108093814.16032-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 arch/x86/mm/gup.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 6612d532e42e..6379a4883c0a 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -9,6 +9,7 @@
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
+#include <linux/pagemap.h>
 
 #include <asm/pgtable.h>
 
@@ -95,10 +96,23 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		if (unlikely(!try_get_page(page))) {
+
+		if (WARN_ON_ONCE(page_ref_count(page) < 0)) {
+			pte_unmap(ptep);
+			return 0;
+		}
+
+		if (!page_cache_get_speculative(page)) {
 			pte_unmap(ptep);
 			return 0;
 		}
+
+		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+			put_page(page);
+			pte_unmap(ptep);
+			return 0;
+		}
+
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
-- 
2.23.0

