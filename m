Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD1D3A8CDF
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFOXtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 19:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhFOXta (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 19:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C5D60E09;
        Tue, 15 Jun 2021 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623800845;
        bh=GwZ9/OKuJ5aRrVDAIiUAMVkm0Hg2mZ46YKAjvKYXDzs=;
        h=Date:From:To:Subject:From;
        b=aYsQPNYAmQ6Zke5/ySMOB4vVgEPqUKb2trbgjO6NSwSARBVIPhVcN+oCg7j03O9nk
         i4wgefUG/aX2u3pFi9qH4aXaaS3pkVA+SpYknm9GaaTz97gmTbDX6wY7m+WQp2JB0S
         c67NL0lKD5vCChy1XmN/G5JrYVPzxs4CmiJ+2tnY=
Date:   Tue, 15 Jun 2021 16:47:24 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com
Subject:  +
 =?US-ASCII?Q?mm-hwpoison-do-not-lock-page-again-when-me=5Fhuge=5Fpage-suc?=
 =?US-ASCII?Q?cessfully-recovers.patch?= added to -mm tree
Message-ID: <20210615234724.SqmLIUVe-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: do not lock page again when me_huge_page() successfully recovers
has been added to the -mm tree.  Its filename is
     mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: do not lock page again when me_huge_page() successfully recovers

Currently me_huge_page() temporary unlocks page to perform some actions
then locks it again later.  My testcase (which calls hard-offline on some
tail page in a hugetlb, then accesses the address of the hugetlb range)
showed that page allocation code detects this page lock on buddy page and
printed out "BUG: Bad page state" message.

check_new_page_bad() does not consider a page with __PG_HWPOISON as bad
page, so this flag works as kind of filter, but this filtering doesn't
work in this case because the "bad page" is not the actual hwpoisoned
page.  So stop locking page again.  Actions to be taken depend on the page
type of the error, so page unlocking should be done in ->action()
callbacks.  So let's make it assumed and change all existing callbacks
that way.

Link: https://lkml.kernel.org/r/20210609072029.74645-1-nao.horiguchi@gmail.com
Fixes: commit 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in un=
recoverable memory error")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   44 ++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers
+++ a/mm/memory-failure.c
@@ -658,6 +658,7 @@ static int truncate_error_page(struct pa
  */
 static int me_kernel(struct page *p, unsigned long pfn)
 {
+	unlock_page(p);
 	return MF_IGNORED;
 }
 
@@ -667,6 +668,7 @@ static int me_kernel(struct page *p, uns
 static int me_unknown(struct page *p, unsigned long pfn)
 {
 	pr_err("Memory failure: %#lx: Unknown page state\n", pfn);
+	unlock_page(p);
 	return MF_FAILED;
 }
 
@@ -675,6 +677,7 @@ static int me_unknown(struct page *p, un
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -683,8 +686,10 @@ static int me_pagecache_clean(struct pag
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
 	 */
-	if (PageAnon(p))
-		return MF_RECOVERED;
+	if (PageAnon(p)) {
+		ret = MF_RECOVERED;
+		goto out;
+	}
 
 	/*
 	 * Now truncate the page in the page cache. This is really
@@ -698,7 +703,8 @@ static int me_pagecache_clean(struct pag
 		/*
 		 * Page has been teared down in the meanwhile
 		 */
-		return MF_FAILED;
+		ret = MF_FAILED;
+		goto out;
 	}
 
 	/*
@@ -706,7 +712,10 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_mutex or not for this? Right now we don't.
 	 */
-	return truncate_error_page(p, pfn, mapping);
+	ret = truncate_error_page(p, pfn, mapping);
+out:
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -782,24 +791,26 @@ static int me_pagecache_dirty(struct pag
  */
 static int me_swapcache_dirty(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_DELAYED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+	unlock_page(p);
+	return ret;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	delete_from_swap_cache(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_RECOVERED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -820,6 +831,7 @@ static int me_huge_page(struct page *p,
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
+		unlock_page(hpage);
 	} else {
 		res = MF_FAILED;
 		unlock_page(hpage);
@@ -834,7 +846,6 @@ static int me_huge_page(struct page *p,
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
-		lock_page(hpage);
 	}
 
 	return res;
@@ -866,6 +877,8 @@ static struct page_state {
 	unsigned long mask;
 	unsigned long res;
 	enum mf_action_page_type type;
+
+	/* Callback ->action() has to unlock the relevant page inside it. */
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
@@ -929,6 +942,7 @@ static int page_action(struct page_state
 	int result;
 	int count;
 
+	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(p, pfn);
 
 	count = page_count(p) - 1;
@@ -1313,7 +1327,7 @@ static int memory_failure_hugetlb(unsign
 		goto out;
 	}
 
-	res = identify_page_state(pfn, p, page_flags);
+	return identify_page_state(pfn, p, page_flags);
 out:
 	unlock_page(head);
 	return res;
@@ -1596,6 +1610,8 @@ try_again:
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
+	mutex_unlock(&mf_mutex);
+	return res;
 unlock_page:
 	unlock_page(p);
 unlock_mutex:
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-fix-race-with-hugetlb-page-allocation.patch
mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch
mmhwpoison-send-sigbus-with-error-virutal-address.patch
mmhwpoison-send-sigbus-with-error-virutal-address-fix.patch
mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch

