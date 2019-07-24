Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5773C7D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbfGXUJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405246AbfGXUAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D78206BA;
        Wed, 24 Jul 2019 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998429;
        bh=V1E6d5xmR/uqGrG65KV8olrucbrmJCDZb6Vl9/dZarI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLV6jy2PxCAjmLWVdfxv8g0zhLBMeoJxSuu9dDaj4UzZaRfoOTxByXtj5qvYlFgQr
         tlToNY9FS06Nga0jVY7M//kshlEQG22oZQQhOuHtqhlhZ0t4MOjGgm48oBW24pm5xM
         atJwFt/qZyjv5Ydclbs/QDYjziCBGEqGQskUFgFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.1 362/371] dax: Fix missed wakeup with PMD faults
Date:   Wed, 24 Jul 2019 21:21:54 +0200
Message-Id: <20190724191751.392909664@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 23c84eb7837514e16d79ed6d849b13745e0ce688 upstream.

RocksDB can hang indefinitely when using a DAX file.  This is due to
a bug in the XArray conversion when handling a PMD fault and finding a
PTE entry.  We use the wrong index in the hash and end up waiting on
the wrong waitqueue.

There's actually no need to wait; if we find a PTE entry while looking
for a PMD entry, we can return immediately as we know we should fall
back to a PTE fault (which may not conflict with the lock held).

We reuse the XA_RETRY_ENTRY to signal a conflicting entry was found.
This value can never be found in an XArray while holding its lock, so
it does not create an ambiguity.

Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Robert Barror <robert.barror@intel.com>
Reported-by: Seema Pandit <seema.pandit@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dax.c |   53 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -132,6 +132,15 @@ static int dax_is_empty_entry(void *entr
 }
 
 /*
+ * true if the entry that was found is of a smaller order than the entry
+ * we were looking for
+ */
+static bool dax_is_conflict(void *entry)
+{
+	return entry == XA_RETRY_ENTRY;
+}
+
+/*
  * DAX page cache entry locking
  */
 struct exceptional_entry_key {
@@ -203,11 +212,13 @@ static void dax_wake_entry(struct xa_sta
  * Look up entry in page cache, wait for it to become unlocked if it
  * is a DAX entry and return it.  The caller must subsequently call
  * put_unlocked_entry() if it did not lock the entry or dax_unlock_entry()
- * if it did.
+ * if it did.  The entry returned may have a larger order than @order.
+ * If @order is larger than the order of the entry found in i_pages, this
+ * function returns a dax_is_conflict entry.
  *
  * Must be called with the i_pages lock held.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -218,6 +229,8 @@ static void *get_unlocked_entry(struct x
 
 	for (;;) {
 		entry = xas_find_conflict(xas);
+		if (dax_entry_order(entry) < order)
+			return XA_RETRY_ENTRY;
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
 				!dax_is_locked(entry))
 			return entry;
@@ -262,7 +275,7 @@ static void wait_entry_unlocked(struct x
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	if (entry && dax_is_conflict(entry))
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -469,7 +482,7 @@ void dax_unlock_page(struct page *page,
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -477,20 +490,17 @@ static void *grab_mapping_entry(struct x
 
 retry:
 	xas_lock_irq(xas);
-	entry = get_unlocked_entry(xas);
+	entry = get_unlocked_entry(xas, order);
 
 	if (entry) {
+		if (dax_is_conflict(entry))
+			goto fallback;
 		if (!xa_is_value(entry)) {
 			xas_set_err(xas, EIO);
 			goto out_unlock;
 		}
 
-		if (size_flag & DAX_PMD) {
-			if (dax_is_pte_entry(entry)) {
-				put_unlocked_entry(xas, entry);
-				goto fallback;
-			}
-		} else { /* trying to grab a PTE entry */
+		if (order == 0) {
 			if (dax_is_pmd_entry(entry) &&
 			    (dax_is_zero_entry(entry) ||
 			     dax_is_empty_entry(entry))) {
@@ -531,7 +541,11 @@ retry:
 	if (entry) {
 		dax_lock_entry(xas, entry);
 	} else {
-		entry = dax_make_entry(pfn_to_pfn_t(0), size_flag | DAX_EMPTY);
+		unsigned long flags = DAX_EMPTY;
+
+		if (order > 0)
+			flags |= DAX_PMD;
+		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
 		if (xas_error(xas))
 			goto out_unlock;
@@ -602,7 +616,7 @@ struct page *dax_layout_busy_page(struct
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
-			entry = get_unlocked_entry(&xas);
+			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
 		put_unlocked_entry(&xas, entry);
@@ -629,7 +643,7 @@ static int __dax_invalidate_entry(struct
 	void *entry;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -856,7 +870,7 @@ static int dax_writeback_one(struct xa_s
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, 0);
 
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
@@ -1517,7 +1531,7 @@ static vm_fault_t dax_iomap_pmd_fault(st
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1666,11 +1680,10 @@ dax_insert_pfn_mkwrite(struct vm_fault *
 	vm_fault_t ret;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, order);
 	/* Did we race with someone splitting entry or so? */
-	if (!entry ||
-	    (order == 0 && !dax_is_pte_entry(entry)) ||
-	    (order == PMD_ORDER && !dax_is_pmd_entry(entry))) {
+	if (!entry || dax_is_conflict(entry) ||
+	    (order == 0 && !dax_is_pte_entry(entry))) {
 		put_unlocked_entry(&xas, entry);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,


