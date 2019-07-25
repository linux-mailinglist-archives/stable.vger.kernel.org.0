Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B880F743FB
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 05:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbfGYD2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 23:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388961AbfGYD2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 23:28:43 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF5B22AED;
        Thu, 25 Jul 2019 03:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564025322;
        bh=/hxTeO/O1HLCwTJsXAcLsv9qwgsm7NQTTakIfDw8R5o=;
        h=Date:From:To:Subject:From;
        b=VaRFwCeYCHbib0jwheXCCHVMRut0HU8w2l/qFvyexCHUjXLxhO31kyhHZOyuvJbpJ
         hCFxGitJFxmeqgiUjYOIDHbhXwIM08Nxa0XK27sCr9WnquX3WJuHIqWeDeqfgc3BfC
         AWiwVZIC5EXDk3vI1Cgry/5FxR6hDjSGVYd/NXMM=
Date:   Wed, 24 Jul 2019 20:28:41 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, dan.j.williams@intel.com, hch@lst.de,
        j-nomura@ce.jp.nec.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        stable@vger.kernel.org, t-fukasawa@vx.jp.nec.com
Subject:  +
 proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags.patch
 added to -mm tree
Message-ID: <20190725032841.ImppBiGtK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: /proc/kpageflags: prevent an integer overflow in stable_page_flags()
has been added to the -mm tree.  Its filename is
     proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Subject: /proc/kpageflags: prevent an integer overflow in stable_page_flags()

stable_page_flags() returns kpageflags info in u64, but it uses "1 <<
KPF_*" internally which is considered as int.  This type mismatch causes
no visible problem now, but it will if you set bit 32 or more as done in a
subsequent patch.  So use BIT_ULL in order to avoid future overflow
issues.

Link: http://lkml.kernel.org/r/20190725023100.31141-2-t-fukasawa@vx.jp.nec.com
Signed-off-by: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

--- a/fs/proc/page.c~proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags
+++ a/fs/proc/page.c
@@ -95,7 +95,7 @@ u64 stable_page_flags(struct page *page)
 	 * it differentiates a memory hole from a page with no flags
 	 */
 	if (!page)
-		return 1 << KPF_NOPAGE;
+		return BIT_ULL(KPF_NOPAGE);
 
 	k = page->flags;
 	u = 0;
@@ -107,22 +107,22 @@ u64 stable_page_flags(struct page *page)
 	 * simple test in page_mapped() is not enough.
 	 */
 	if (!PageSlab(page) && page_mapped(page))
-		u |= 1 << KPF_MMAP;
+		u |= BIT_ULL(KPF_MMAP);
 	if (PageAnon(page))
-		u |= 1 << KPF_ANON;
+		u |= BIT_ULL(KPF_ANON);
 	if (PageKsm(page))
-		u |= 1 << KPF_KSM;
+		u |= BIT_ULL(KPF_KSM);
 
 	/*
 	 * compound pages: export both head/tail info
 	 * they together define a compound page's start/end pos and order
 	 */
 	if (PageHead(page))
-		u |= 1 << KPF_COMPOUND_HEAD;
+		u |= BIT_ULL(KPF_COMPOUND_HEAD);
 	if (PageTail(page))
-		u |= 1 << KPF_COMPOUND_TAIL;
+		u |= BIT_ULL(KPF_COMPOUND_TAIL);
 	if (PageHuge(page))
-		u |= 1 << KPF_HUGE;
+		u |= BIT_ULL(KPF_HUGE);
 	/*
 	 * PageTransCompound can be true for non-huge compound pages (slab
 	 * pages or pages allocated by drivers with __GFP_COMP) because it
@@ -133,14 +133,13 @@ u64 stable_page_flags(struct page *page)
 		struct page *head = compound_head(page);
 
 		if (PageLRU(head) || PageAnon(head))
-			u |= 1 << KPF_THP;
+			u |= BIT_ULL(KPF_THP);
 		else if (is_huge_zero_page(head)) {
-			u |= 1 << KPF_ZERO_PAGE;
-			u |= 1 << KPF_THP;
+			u |= BIT_ULL(KPF_ZERO_PAGE);
+			u |= BIT_ULL(KPF_THP);
 		}
 	} else if (is_zero_pfn(page_to_pfn(page)))
-		u |= 1 << KPF_ZERO_PAGE;
-
+		u |= BIT_ULL(KPF_ZERO_PAGE);
 
 	/*
 	 * Caveats on high order pages: page->_refcount will only be set
@@ -148,23 +147,23 @@ u64 stable_page_flags(struct page *page)
 	 * SLOB won't set PG_slab at all on compound pages.
 	 */
 	if (PageBuddy(page))
-		u |= 1 << KPF_BUDDY;
+		u |= BIT_ULL(KPF_BUDDY);
 	else if (page_count(page) == 0 && is_free_buddy_page(page))
-		u |= 1 << KPF_BUDDY;
+		u |= BIT_ULL(KPF_BUDDY);
 
 	if (PageOffline(page))
-		u |= 1 << KPF_OFFLINE;
+		u |= BIT_ULL(KPF_OFFLINE);
 	if (PageTable(page))
-		u |= 1 << KPF_PGTABLE;
+		u |= BIT_ULL(KPF_PGTABLE);
 
 	if (page_is_idle(page))
-		u |= 1 << KPF_IDLE;
+		u |= BIT_ULL(KPF_IDLE);
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
 	if (PageTail(page) && PageSlab(compound_head(page)))
-		u |= 1 << KPF_SLAB;
+		u |= BIT_ULL(KPF_SLAB);
 
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
@@ -177,7 +176,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
 	if (PageSwapCache(page))
-		u |= 1 << KPF_SWAPCACHE;
+		u |= BIT_ULL(KPF_SWAPCACHE);
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
_

Patches currently in -mm which might be from t-fukasawa@vx.jp.nec.com are

proc-kpageflags-prevent-an-integer-overflow-in-stable_page_flags.patch
proc-kpageflags-do-not-use-uninitialized-struct-pages.patch

