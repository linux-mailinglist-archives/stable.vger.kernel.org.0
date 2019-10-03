Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6CACA901
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391340AbfJCQfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389429AbfJCQfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8FD72070B;
        Thu,  3 Oct 2019 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120551;
        bh=Q2csLGPfbPef3CuRi72M6y/BVZlrVtVLVt5CDkrmq8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqFm0teokzezRZnr2XECQVrE+PXWQD7kjpmvOHxxx5nlnJDcON6pQizFeNKR95zDQ
         BNU908FL137RkErMiI9YH50KcrVl3IR3DUHmnNwIpz/lEBlL52fM0Jihth981wLdph
         7ovCq8qlSxZqR5cAqWZeXye03i0BQ0zKNV9xcj1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
        Markus Linnala <markus.linnala@gmail.com>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Agustin DallAlba <agustin@dallalba.com.ar>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Shakeel Butt <shakeelb@google.com>,
        Henry Burns <henrywolfeburns@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 264/313] z3fold: fix retry mechanism in page reclaim
Date:   Thu,  3 Oct 2019 17:54:02 +0200
Message-Id: <20191003154559.044870572@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Wool <vitalywool@gmail.com>

commit 3f9d2b5766aea06042630ac60b7316fd0cebf06f upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -368,9 +368,10 @@ static inline int __idx(struct z3fold_he
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
 
@@ -387,11 +388,15 @@ static unsigned long encode_handle(struc
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
@@ -626,6 +631,7 @@ static void do_compact_page(struct z3fol
 	}
 
 	if (unlikely(PageIsolated(page) ||
+		     test_bit(PAGE_CLAIMED, &page->private) ||
 		     test_bit(PAGE_STALE, &page->private))) {
 		z3fold_page_unlock(zhdr);
 		return;
@@ -1102,6 +1108,7 @@ static int z3fold_reclaim_page(struct z3
 	struct z3fold_header *zhdr = NULL;
 	struct page *page = NULL;
 	struct list_head *pos;
+	struct z3fold_buddy_slots slots;
 	unsigned long first_handle = 0, middle_handle = 0, last_handle = 0;
 
 	spin_lock(&pool->lock);
@@ -1120,16 +1127,22 @@ static int z3fold_reclaim_page(struct z3
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
@@ -1147,26 +1160,30 @@ static int z3fold_reclaim_page(struct z3
 
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
 
@@ -1196,9 +1213,9 @@ next:
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
@@ -1213,6 +1230,7 @@ next:
 			list_add(&page->lru, &pool->lru);
 			spin_unlock(&pool->lock);
 			z3fold_page_unlock(zhdr);
+			clear_bit(PAGE_CLAIMED, &page->private);
 		}
 
 		/* We started off locked to we need to lock the pool back */
@@ -1317,7 +1335,8 @@ static bool z3fold_page_isolate(struct p
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
-	if (test_bit(PAGE_HEADLESS, &page->private))
+	if (test_bit(PAGE_HEADLESS, &page->private) ||
+	    test_bit(PAGE_CLAIMED, &page->private))
 		return false;
 
 	zhdr = page_address(page);


