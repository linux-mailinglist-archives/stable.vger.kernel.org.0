Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B82AFE9A
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfIKOUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfIKOUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 10:20:45 -0400
Received: from X1 (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6039620863;
        Wed, 11 Sep 2019 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568211644;
        bh=rqHCenGT7KzERXERjiAqVQKmBk5iUxxQWgJir3wojnQ=;
        h=Date:From:To:Subject:From;
        b=pEvEu6x4kl33YbAjz4g9oES73d6DFVmwt4POk0RlAvYhx/aTdCtVVVDVZD3wgdKrx
         Xfh1PllJEaVzLc2oHBNWC5QE2wYrPMFToBAcDreqSXFacBny8Tx23krXXDFuBVoyaf
         2TdHHEA11fxWph7Un5CnvIkJyKSsntiTQrMPkltA=
Date:   Wed, 11 Sep 2019 07:20:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, markus.linnala@gmail.com,
        mail@maciej.szmigiero.name, henrywolfeburns@gmail.com,
        bugzilla@colorremedies.com, agustin@dallalba.com.ar,
        vitalywool@gmail.com
Subject:  + z3fold-fix-retry-mechanism-in-page-reclaim.patch added to
 -mm tree
Message-ID: <20190911142040.a5qLa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold: fix retry mechanism in page reclaim
has been added to the -mm tree.  Its filename is
     z3fold-fix-retry-mechanism-in-page-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-fix-retry-mechanism-in-page-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-fix-retry-mechanism-in-page-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix retry mechanism in page reclaim

z3fold_page_reclaim()'s retry mechanism is broken: on a second iteration
it will have zhdr from the first one so that zhdr is no longer in line
with struct page.  That leads to crashes when the system is stressed.

Fix that by moving zhdr assignment up.

While at it, protect against using already freed handles by using own
local slots structure in z3fold_page_reclaim().

Link: http://lkml.kernel.org/r/20190908162919.830388dc7404d1e2c80f4095@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Reported-by: Chris Murphy <bugzilla@colorremedies.com>
Reported-by: Agustin Dall'Alba <agustin@dallalba.com.ar>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/mm/z3fold.c~z3fold-fix-retry-mechanism-in-page-reclaim
+++ a/mm/z3fold.c
@@ -366,9 +366,10 @@ static inline int __idx(struct z3fold_he
  * Encodes the handle of a particular buddy within a z3fold page
  * Pool lock should be held as this function accesses first_num
  */
-static unsigned long encode_handle(struct z3fold_header *zhdr, enum buddy bud)
+static unsigned long __encode_handle(struct z3fold_header *zhdr,
+				struct z3fold_buddy_slots *slots,
+				enum buddy bud)
 {
-	struct z3fold_buddy_slots *slots;
 	unsigned long h = (unsigned long)zhdr;
 	int idx = 0;
 
@@ -385,11 +386,15 @@ static unsigned long encode_handle(struc
 	if (bud == LAST)
 		h |= (zhdr->last_chunks << BUDDY_SHIFT);
 
-	slots = zhdr->slots;
 	slots->slot[idx] = h;
 	return (unsigned long)&slots->slot[idx];
 }
 
+static unsigned long encode_handle(struct z3fold_header *zhdr, enum buddy bud)
+{
+	return __encode_handle(zhdr, zhdr->slots, bud);
+}
+
 /* Returns the z3fold page where a given handle is stored */
 static inline struct z3fold_header *handle_to_z3fold_header(unsigned long h)
 {
@@ -624,6 +629,7 @@ static void do_compact_page(struct z3fol
 	}
 
 	if (unlikely(PageIsolated(page) ||
+		     test_bit(PAGE_CLAIMED, &page->private) ||
 		     test_bit(PAGE_STALE, &page->private))) {
 		z3fold_page_unlock(zhdr);
 		return;
@@ -1100,6 +1106,7 @@ static int z3fold_reclaim_page(struct z3
 	struct z3fold_header *zhdr = NULL;
 	struct page *page = NULL;
 	struct list_head *pos;
+	struct z3fold_buddy_slots slots;
 	unsigned long first_handle = 0, middle_handle = 0, last_handle = 0;
 
 	spin_lock(&pool->lock);
@@ -1118,16 +1125,22 @@ static int z3fold_reclaim_page(struct z3
 			/* this bit could have been set by free, in which case
 			 * we pass over to the next page in the pool.
 			 */
-			if (test_and_set_bit(PAGE_CLAIMED, &page->private))
+			if (test_and_set_bit(PAGE_CLAIMED, &page->private)) {
+				page = NULL;
 				continue;
+			}
 
-			if (unlikely(PageIsolated(page)))
+			if (unlikely(PageIsolated(page))) {
+				clear_bit(PAGE_CLAIMED, &page->private);
+				page = NULL;
 				continue;
+			}
+			zhdr = page_address(page);
 			if (test_bit(PAGE_HEADLESS, &page->private))
 				break;
 
-			zhdr = page_address(page);
 			if (!z3fold_page_trylock(zhdr)) {
+				clear_bit(PAGE_CLAIMED, &page->private);
 				zhdr = NULL;
 				continue; /* can't evict at this point */
 			}
@@ -1145,26 +1158,30 @@ static int z3fold_reclaim_page(struct z3
 
 		if (!test_bit(PAGE_HEADLESS, &page->private)) {
 			/*
-			 * We need encode the handles before unlocking, since
-			 * we can race with free that will set
-			 * (first|last)_chunks to 0
+			 * We need encode the handles before unlocking, and
+			 * use our local slots structure because z3fold_free
+			 * can zero out zhdr->slots and we can't do much
+			 * about that
 			 */
 			first_handle = 0;
 			last_handle = 0;
 			middle_handle = 0;
 			if (zhdr->first_chunks)
-				first_handle = encode_handle(zhdr, FIRST);
+				first_handle = __encode_handle(zhdr, &slots,
+								FIRST);
 			if (zhdr->middle_chunks)
-				middle_handle = encode_handle(zhdr, MIDDLE);
+				middle_handle = __encode_handle(zhdr, &slots,
+								MIDDLE);
 			if (zhdr->last_chunks)
-				last_handle = encode_handle(zhdr, LAST);
+				last_handle = __encode_handle(zhdr, &slots,
+								LAST);
 			/*
 			 * it's safe to unlock here because we hold a
 			 * reference to this page
 			 */
 			z3fold_page_unlock(zhdr);
 		} else {
-			first_handle = encode_handle(zhdr, HEADLESS);
+			first_handle = __encode_handle(zhdr, &slots, HEADLESS);
 			last_handle = middle_handle = 0;
 		}
 
@@ -1194,9 +1211,9 @@ next:
 			spin_lock(&pool->lock);
 			list_add(&page->lru, &pool->lru);
 			spin_unlock(&pool->lock);
+			clear_bit(PAGE_CLAIMED, &page->private);
 		} else {
 			z3fold_page_lock(zhdr);
-			clear_bit(PAGE_CLAIMED, &page->private);
 			if (kref_put(&zhdr->refcount,
 					release_z3fold_page_locked)) {
 				atomic64_dec(&pool->pages_nr);
@@ -1211,6 +1228,7 @@ next:
 			list_add(&page->lru, &pool->lru);
 			spin_unlock(&pool->lock);
 			z3fold_page_unlock(zhdr);
+			clear_bit(PAGE_CLAIMED, &page->private);
 		}
 
 		/* We started off locked to we need to lock the pool back */
@@ -1315,7 +1333,8 @@ static bool z3fold_page_isolate(struct p
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
-	if (test_bit(PAGE_HEADLESS, &page->private))
+	if (test_bit(PAGE_HEADLESS, &page->private) ||
+	    test_bit(PAGE_CLAIMED, &page->private))
 		return false;
 
 	zhdr = page_address(page);
_

Patches currently in -mm which might be from vitalywool@gmail.com are

revert-mm-z3foldc-fix-race-between-migration-and-destruction.patch
z3fold-fix-retry-mechanism-in-page-reclaim.patch

