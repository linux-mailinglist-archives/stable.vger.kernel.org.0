Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465E9D00A3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 20:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJHSUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 14:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 14:20:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA3A217D7;
        Tue,  8 Oct 2019 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570558832;
        bh=BiwBA9C0DR0h/CKEVQkHu9kkyAvnt3wxcjcso4wDyRE=;
        h=Date:From:To:Subject:From;
        b=D434keaOVv8vFD5csIaI/QX3JvEF3l5oxmAMIhNAM0yDExhUOeE6NbLGqV/giF7HW
         WJ1mG0/dezjm3Kd6oSTIOj4Wsiff/6WYlZvxLc3rOjXu0XsB6lLSZGAaYLBnfqw1Nh
         xKGB5QEp0/Ziy5KsfuOWoYKDZSwCtRrQb2FOA7Yc=
Date:   Tue, 08 Oct 2019 11:20:32 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, henrywolfeburns@gmail.com,
        markus.linnala@gmail.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, stable@vger.kernel.org, vbabka@suse.cz,
        vitalywool@gmail.com
Subject:  [merged] z3fold-claim-page-in-the-beginning-of-free.patch
 removed from -mm tree
Message-ID: <20191008182032.N_XVt4Rzq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: claim page in the beginning of free
has been removed from the -mm tree.  Its filename was
     z3fold-claim-page-in-the-beginning-of-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: claim page in the beginning of free

There's a really hard to reproduce race in z3fold between z3fold_free()
and z3fold_reclaim_page().  z3fold_reclaim_page() can claim the page after
z3fold_free() has checked if the page was claimed and z3fold_free() will
then schedule this page for compaction which may in turn lead to random
page faults (since that page would have been reclaimed by then).  Fix that
by claiming page in the beginning of z3fold_free() and not forgetting to
clear the claim in the end.

[vitalywool@gmail.com: v2]
  Link: http://lkml.kernel.org/r/20190928113456.152742cf@bigdell
Link: http://lkml.kernel.org/r/20190926104844.4f0c6efa1366b8f5741eaba9@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reported-by: Markus Linnala <markus.linnala@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Henry Burns <henrywolfeburns@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Markus Linnala <markus.linnala@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~z3fold-claim-page-in-the-beginning-of-free
+++ a/mm/z3fold.c
@@ -998,9 +998,11 @@ static void z3fold_free(struct z3fold_po
 	struct z3fold_header *zhdr;
 	struct page *page;
 	enum buddy bud;
+	bool page_claimed;
 
 	zhdr = handle_to_z3fold_header(handle);
 	page = virt_to_page(zhdr);
+	page_claimed = test_and_set_bit(PAGE_CLAIMED, &page->private);
 
 	if (test_bit(PAGE_HEADLESS, &page->private)) {
 		/* if a headless page is under reclaim, just leave.
@@ -1008,7 +1010,7 @@ static void z3fold_free(struct z3fold_po
 		 * has not been set before, we release this page
 		 * immediately so we don't care about its value any more.
 		 */
-		if (!test_and_set_bit(PAGE_CLAIMED, &page->private)) {
+		if (!page_claimed) {
 			spin_lock(&pool->lock);
 			list_del(&page->lru);
 			spin_unlock(&pool->lock);
@@ -1044,13 +1046,15 @@ static void z3fold_free(struct z3fold_po
 		atomic64_dec(&pool->pages_nr);
 		return;
 	}
-	if (test_bit(PAGE_CLAIMED, &page->private)) {
+	if (page_claimed) {
+		/* the page has not been claimed by us */
 		z3fold_page_unlock(zhdr);
 		return;
 	}
 	if (unlikely(PageIsolated(page)) ||
 	    test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
 		z3fold_page_unlock(zhdr);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	if (zhdr->cpu < 0 || !cpu_online(zhdr->cpu)) {
@@ -1060,10 +1064,12 @@ static void z3fold_free(struct z3fold_po
 		zhdr->cpu = -1;
 		kref_get(&zhdr->refcount);
 		do_compact_page(zhdr, true);
+		clear_bit(PAGE_CLAIMED, &page->private);
 		return;
 	}
 	kref_get(&zhdr->refcount);
 	queue_work_on(zhdr->cpu, pool->compact_wq, &zhdr->work);
+	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
 }
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are


