Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496E665A5D
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 17:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfGKPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 11:25:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbfGKPZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 11:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NV2y6EH+RsLYmHPSuYVTzIP51jt8A75FqEqQE1pxFgA=; b=QGg8QYDUOxVbI5xAGPVbkWISm
        k0GlBMXn3vuZ5Z1LGOET02jcIQ+f+/dIzBC+AT8UAKg+x1px5+ak/ukAZLSd7R1U8qdQuBNt9vYX5
        3+P/EZ4SfMY1iR44b37lb++YRhkVq3zbUpxqVO66oT8pJ7xS5YCZWH1oVw72LnYDRqnZtXIe/NODU
        xq4aGn/ToUhqc1Mr2lMa2L8vjfcPRyGIXAQQAKqZ2NoqHrPNWGkbB1AmNWwyGIfpnmUgyLhUoI827
        Z6Ju/POHpN5ufhFflpajagclaf/HVxlEc20fjRJ5ccg2l4obbQg2bAd4PM6R3P/iPmZ0JzJO4b5iM
        R4AO5BMKw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlaxC-0006jL-RR; Thu, 11 Jul 2019 15:25:50 +0000
Date:   Thu, 11 Jul 2019 08:25:50 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190711152550.GT32320@bombadil.infradead.org>
References: <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
 <20190711141350.GS32320@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711141350.GS32320@bombadil.infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> appear in an XArray (it may appear if you're looking at a deleted node,
> but since we're holding the lock, we can't see deleted nodes).

Updated patch (also slight updates to changelog and comments)

--- 8< ---

From af8402dacb3998d8ef23677ac35fdb72b236320c Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 3 Jul 2019 23:21:25 -0400
Subject: [PATCH] dax: Fix missed wakeup with PMD faults

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

Cc: stable@vger.kernel.org
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/dax.c | 53 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2e48c7ebb973..7a75031da644 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -123,6 +123,15 @@ static int dax_is_empty_entry(void *entry)
 	return xa_to_value(entry) & DAX_EMPTY;
 }
 
+/*
+ * true if the entry that was found is of a smaller order than the entry
+ * we were looking for
+ */
+static bool dax_is_conflict(void *entry)
+{
+	return entry == XA_RETRY_ENTRY;
+}
+
 /*
  * DAX page cache entry locking
  */
@@ -195,11 +204,13 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
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
@@ -210,6 +221,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 
 	for (;;) {
 		entry = xas_find_conflict(xas);
+		if (dax_entry_order(entry) < order)
+			return XA_RETRY_ENTRY;
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
 				!dax_is_locked(entry))
 			return entry;
@@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	if (entry && dax_is_conflict(entry))
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -461,7 +474,7 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -469,20 +482,17 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
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
@@ -523,7 +533,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
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
@@ -594,7 +608,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
-			entry = get_unlocked_entry(&xas);
+			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
 		put_unlocked_entry(&xas, entry);
@@ -621,7 +635,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	void *entry;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -849,7 +863,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, 0);
 
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
@@ -1510,7 +1524,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1659,11 +1673,10 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
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
-- 
2.20.1

