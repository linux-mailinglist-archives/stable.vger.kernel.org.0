Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E342B8159
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbfISTYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404328AbfISTYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 15:24:02 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA632053B;
        Thu, 19 Sep 2019 19:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568921039;
        bh=xAWSuDsna1+cgBRwZape3d7wA4r45lyjcxXafUA0+xk=;
        h=Date:From:To:Subject:From;
        b=ygdXpCBx0RoHQcUc4N0oeBbmjySGBlHgvX6wLEg3UKgH4+1kkWYYXCCvRuFfM4K4F
         1p61U/GAaBNCLZa6KGCMXkHa2gsWjjOMqSWocVr5tEYYvRx+bocMLeFSw0uWymKfN7
         WK8J7NEqkbvtl51ohLcThOwGQtxJJ9tR8jZlxqpg=
Date:   Thu, 19 Sep 2019 12:23:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        shakeelb@google.com, markus.linnala@gmail.com,
        henrywolfeburns@gmail.com, ddstreet@ieee.org, vitalywool@gmail.com
Subject:  + z3fold-fix-memory-leak-in-kmem-cache.patch added to -mm
 tree
Message-ID: <20190919192359.hYIdQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold: fix memory leak in kmem cache
has been added to the -mm tree.  Its filename is
     z3fold-fix-memory-leak-in-kmem-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-fix-memory-leak-in-kmem-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-fix-memory-leak-in-kmem-cache.patch

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
Subject: z3fold: fix memory leak in kmem cache

Currently there is a leak in init_z3fold_page() -- it allocates handles
from kmem cache even for headless pages, but then they are never used and
never freed, so eventually kmem cache may get exhausted.  This patch
provides a fix for that.

Link: http://lkml.kernel.org/r/20190917185352.44cf285d3ebd9e64548de5de@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Tested-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/z3fold.c~z3fold-fix-memory-leak-in-kmem-cache
+++ a/mm/z3fold.c
@@ -295,14 +295,11 @@ static void z3fold_unregister_migration(
  }
 
 /* Initializes the z3fold header of a newly allocated z3fold page */
-static struct z3fold_header *init_z3fold_page(struct page *page,
+static struct z3fold_header *init_z3fold_page(struct page *page, bool headless,
 					struct z3fold_pool *pool, gfp_t gfp)
 {
 	struct z3fold_header *zhdr = page_address(page);
-	struct z3fold_buddy_slots *slots = alloc_slots(pool, gfp);
-
-	if (!slots)
-		return NULL;
+	struct z3fold_buddy_slots *slots;
 
 	INIT_LIST_HEAD(&page->lru);
 	clear_bit(PAGE_HEADLESS, &page->private);
@@ -310,6 +307,12 @@ static struct z3fold_header *init_z3fold
 	clear_bit(NEEDS_COMPACTING, &page->private);
 	clear_bit(PAGE_STALE, &page->private);
 	clear_bit(PAGE_CLAIMED, &page->private);
+	if (headless)
+		return zhdr;
+
+	slots = alloc_slots(pool, gfp);
+	if (!slots)
+		return NULL;
 
 	spin_lock_init(&zhdr->page_lock);
 	kref_init(&zhdr->refcount);
@@ -930,7 +933,7 @@ retry:
 	if (!page)
 		return -ENOMEM;
 
-	zhdr = init_z3fold_page(page, pool, gfp);
+	zhdr = init_z3fold_page(page, bud == HEADLESS, pool, gfp);
 	if (!zhdr) {
 		__free_page(page);
 		return -ENOMEM;
_

Patches currently in -mm which might be from vitalywool@gmail.com are

revert-mm-z3foldc-fix-race-between-migration-and-destruction.patch
z3fold-fix-retry-mechanism-in-page-reclaim.patch
z3fold-fix-memory-leak-in-kmem-cache.patch

