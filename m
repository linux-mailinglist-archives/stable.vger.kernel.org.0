Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFDAF1C3E
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 18:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfKFRS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 12:18:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:47586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727894AbfKFRS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 12:18:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39AE2B186;
        Wed,  6 Nov 2019 17:18:25 +0000 (UTC)
Subject: Re: [PATCH STABLE 4.9] x86, mm, gup: prevent get_page() race with
 munmap in paravirt guest
To:     Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        Jann Horn <jannh@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        xen-devel@lists.xenproject.org, Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ajay Kaher <akaher@vmware.com>
References: <20190802160614.8089-1-vbabka@suse.cz>
 <d3bb280b405d6acf0bc4176d63639201ff62853f.camel@decadent.org.uk>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <9c130fa4-e52d-f8bd-c450-42341c7ab441@suse.cz>
Date:   Wed, 6 Nov 2019 18:18:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d3bb280b405d6acf0bc4176d63639201ff62853f.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/19 8:26 PM, Ben Hutchings wrote:
> On Mon, 2019-08-19 at 18:58 +0100, Vlastimil Babka wrote:
> [...]
>> Hi, I'm sending this stable-only patch for consideration because it's probably
>> unrealistic to backport the 4.13 switch to generic GUP. I can look at 4.4 and
>> 3.16 if accepted. The RCU page table freeing could be also considered.
> 
> I would be interested in backports for 3.16 and 4.4.
> 
>> Note the patch also includes page refcount protection. I found out that
>> 8fde12ca79af ("mm: prevent get_user_pages() from overflowing page refcount")
>> backport to 4.9 missed the arch-specific gup implementations:
>> https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz/
> [...]
> 
> I suppose that still needs to be addressed for 4.9, right?

Here's what is AFAIK missing for 4.9 for x86 and s390.

----8<----
From d981bbf770ca41e999115cf3b0f27dde57479df0 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 6 Nov 2019 16:32:57 +0100
Subject: [PATCH STABLE 4.9] mm, gup: add missing refcount overflow checks on x86 and s390

The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
overflowing page refcount") was backported to 4.9.y stable as commit
2ed768cfd895. The backport however missed that in 4.9, there are several
arch-specific gup.c versions with fast gup implementations, so these do not
prevent refcount overflow.

This is partially fixed for x86 in stable-only commit d73af79742e7 ("x86, mm,
gup: prevent get_page() race with munmap in paravirt guest"). This stable-only
commit adds missing parts to x86 version, as well as s390 version, both taken
from the SUSE SLES/openSUSE 4.12-based kernels.

The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
problem for those architectures, and I don't feel confident enough to patch
them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 arch/s390/mm/gup.c |  9 ++++++---
 arch/x86/mm/gup.c  | 10 ++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 97fc449a7470..33a940389a6d 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -38,7 +38,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
+		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+		    || !page_cache_get_speculative(head)))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(head);
@@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
@@ -150,7 +152,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index d7db45bdfb3b..551fc7fea046 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -202,10 +202,12 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
 			undo_dev_pagemap(nr, nr_start, pages);
 			return 0;
 		}
+		if (unlikely(!try_get_page(page))) {
+			put_dev_pagemap(pgmap);
+			return 0;
+		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
-		get_page(page);
-		put_dev_pagemap(pgmap);
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
@@ -230,6 +232,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 
 	refs = 0;
 	head = pmd_page(pmd);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
@@ -289,6 +293,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 
 	refs = 0;
 	head = pud_page(pud);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-- 
2.23.0



