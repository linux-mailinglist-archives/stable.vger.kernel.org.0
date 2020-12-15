Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E532DB74A
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 01:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgLPAB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 19:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbgLOXZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:08 -0500
Date:   Tue, 15 Dec 2020 15:22:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074575;
        bh=J2shlmZsdXPbGb2RljlaslCWqrIua0dSAqtezLUNEwM=;
        h=From:To:Subject:From;
        b=cPQBiJjq5HPhESY+rvdm4xh4fJlWxArQs+3czHGkxaZxmxFw3h997LOkbmU5SnL7W
         HqDAirjEwBDuO13kwvfdeho0RHXCKFY1WQLQJogDmZyQuGGROZEf8oLutDUy1TNKCP
         tmxcpGES+lDQNqbT2dSi6lF3zd5V/3f9xfNmglio=
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, efault@gmx.de, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vitaly.wool@konsulko.com
Subject:  [merged] z3fold-simplify-freeing-slots.patch removed from
 -mm tree
Message-ID: <20201215232255.0cBe5KVGv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: z3fold: simplify freeing slots
has been removed from the -mm tree.  Its filename was
     z3fold-simplify-freeing-slots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.com>
Subject: z3fold: simplify freeing slots

Patch series "z3fold: stability / rt fixes".

Address z3fold stability issues under stress load, primarily in the
reclaim and free aspects.  Besides, it fixes the locking problems that
were only seen in real-time kernel configuration.


This patch (of 3):

There used to be two places in the code where slots could be freed, namely
when freeing the last allocated handle from the slots and when releasing
the z3fold header these slots aree linked to.  The logic to decide on
whether to free certain slots was complicated and error prone in both
functions and it led to failures in RT case.

To fix that, make free_handle() the single point of freeing slots.

Link: https://lkml.kernel.org/r/20201209145151.18994-1-vitaly.wool@konsulko.com
Link: https://lkml.kernel.org/r/20201209145151.18994-2-vitaly.wool@konsulko.com
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Tested-by: Mike Galbraith <efault@gmx.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   55 +++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 42 deletions(-)

--- a/mm/z3fold.c~z3fold-simplify-freeing-slots
+++ a/mm/z3fold.c
@@ -90,7 +90,7 @@ struct z3fold_buddy_slots {
 	 * be enough slots to hold all possible variants
 	 */
 	unsigned long slot[BUDDY_MASK + 1];
-	unsigned long pool; /* back link + flags */
+	unsigned long pool; /* back link */
 	rwlock_t lock;
 };
 #define HANDLE_FLAG_MASK	(0x03)
@@ -182,13 +182,6 @@ enum z3fold_page_flags {
 };
 
 /*
- * handle flags, go under HANDLE_FLAG_MASK
- */
-enum z3fold_handle_flags {
-	HANDLES_ORPHANED = 0,
-};
-
-/*
  * Forward declarations
  */
 static struct z3fold_header *__z3fold_alloc(struct z3fold_pool *, size_t, bool);
@@ -303,10 +296,9 @@ static inline void put_z3fold_header(str
 		z3fold_page_unlock(zhdr);
 }
 
-static inline void free_handle(unsigned long handle)
+static inline void free_handle(unsigned long handle, struct z3fold_header *zhdr)
 {
 	struct z3fold_buddy_slots *slots;
-	struct z3fold_header *zhdr;
 	int i;
 	bool is_free;
 
@@ -316,22 +308,13 @@ static inline void free_handle(unsigned
 	if (WARN_ON(*(unsigned long *)handle == 0))
 		return;
 
-	zhdr = handle_to_z3fold_header(handle);
 	slots = handle_to_slots(handle);
 	write_lock(&slots->lock);
 	*(unsigned long *)handle = 0;
-	if (zhdr->slots == slots) {
-		write_unlock(&slots->lock);
-		return; /* simple case, nothing else to do */
-	}
+	if (zhdr->slots != slots)
+		zhdr->foreign_handles--;
 
-	/* we are freeing a foreign handle if we are here */
-	zhdr->foreign_handles--;
 	is_free = true;
-	if (!test_bit(HANDLES_ORPHANED, &slots->pool)) {
-		write_unlock(&slots->lock);
-		return;
-	}
 	for (i = 0; i <= BUDDY_MASK; i++) {
 		if (slots->slot[i]) {
 			is_free = false;
@@ -343,6 +326,8 @@ static inline void free_handle(unsigned
 	if (is_free) {
 		struct z3fold_pool *pool = slots_to_pool(slots);
 
+		if (zhdr->slots == slots)
+			zhdr->slots = NULL;
 		kmem_cache_free(pool->c_handle, slots);
 	}
 }
@@ -525,8 +510,6 @@ static void __release_z3fold_page(struct
 {
 	struct page *page = virt_to_page(zhdr);
 	struct z3fold_pool *pool = zhdr_to_pool(zhdr);
-	bool is_free = true;
-	int i;
 
 	WARN_ON(!list_empty(&zhdr->buddy));
 	set_bit(PAGE_STALE, &page->private);
@@ -536,21 +519,6 @@ static void __release_z3fold_page(struct
 		list_del_init(&page->lru);
 	spin_unlock(&pool->lock);
 
-	/* If there are no foreign handles, free the handles array */
-	read_lock(&zhdr->slots->lock);
-	for (i = 0; i <= BUDDY_MASK; i++) {
-		if (zhdr->slots->slot[i]) {
-			is_free = false;
-			break;
-		}
-	}
-	if (!is_free)
-		set_bit(HANDLES_ORPHANED, &zhdr->slots->pool);
-	read_unlock(&zhdr->slots->lock);
-
-	if (is_free)
-		kmem_cache_free(pool->c_handle, zhdr->slots);
-
 	if (locked)
 		z3fold_page_unlock(zhdr);
 
@@ -973,6 +941,9 @@ lookup:
 		}
 	}
 
+	if (zhdr && !zhdr->slots)
+		zhdr->slots = alloc_slots(pool,
+					can_sleep ? GFP_NOIO : GFP_ATOMIC);
 	return zhdr;
 }
 
@@ -1270,7 +1241,7 @@ static void z3fold_free(struct z3fold_po
 	}
 
 	if (!page_claimed)
-		free_handle(handle);
+		free_handle(handle, zhdr);
 	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list)) {
 		atomic64_dec(&pool->pages_nr);
 		return;
@@ -1429,19 +1400,19 @@ static int z3fold_reclaim_page(struct z3
 			ret = pool->ops->evict(pool, middle_handle);
 			if (ret)
 				goto next;
-			free_handle(middle_handle);
+			free_handle(middle_handle, zhdr);
 		}
 		if (first_handle) {
 			ret = pool->ops->evict(pool, first_handle);
 			if (ret)
 				goto next;
-			free_handle(first_handle);
+			free_handle(first_handle, zhdr);
 		}
 		if (last_handle) {
 			ret = pool->ops->evict(pool, last_handle);
 			if (ret)
 				goto next;
-			free_handle(last_handle);
+			free_handle(last_handle, zhdr);
 		}
 next:
 		if (test_bit(PAGE_HEADLESS, &page->private)) {
_

Patches currently in -mm which might be from vitaly.wool@konsulko.com are


