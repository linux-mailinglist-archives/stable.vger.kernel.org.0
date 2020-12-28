Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533A12E3FBE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503657AbgL1O0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503733AbgL1O0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E19922B45;
        Mon, 28 Dec 2020 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165531;
        bh=u6HTCJZ5KCwRQ1790OJ5qNNvQFU9SonzL94TWj4G4hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/lDKD/UYBt5IKmjUa+Ia94JckD16/Bz5uopqv2iM4WZdKrjY8r7aLmihK3GfZjvY
         EHt1qnRK3+aImO82aQQ2yxLxJxZAqwL9mZ9Qmc3cMmJ/fDRZfbZCT3zGy+ZaWF1sf/
         WQgcd1uYx7rptYi8fCoM1eex/BDB8dYt4we9lBAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Wool <vitaly.wool@konsulko.com>,
        Mike Galbraith <efault@gmx.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 564/717] z3fold: simplify freeing slots
Date:   Mon, 28 Dec 2020 13:49:22 +0100
Message-Id: <20201228125047.942969654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Wool <vitaly.wool@konsulko.com>

commit fc5488651c7d840c9cad9b0f273f2f31bd03413a upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   55 +++++++++++++------------------------------------------
 1 file changed, 13 insertions(+), 42 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
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


