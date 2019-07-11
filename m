Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D516E650A2
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 05:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfGKDf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 23:35:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfGKDf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 23:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2rys8I+g8LpMH+brWS98EAq+IiVVyucZRNf2IArRfdc=; b=CBngnoUImE532f2z4VYEL4/Xk
        YPDcE6PCY9MTxnphzbUz9ZsRnmCrynW55jbFy/dtajUkY1LWsSoZTeHJzdxE4zAS9dxGTCNa6WYR6
        gM4CHcbgrLrQbps762uYA774ZN2lGCEhMtDxbQIoMi0LYm0BnfF81refInBQnIRaYRgjwojtieMjv
        +vqF8LE6+S9arIDUZgY37MSHYyvkohjWJJp7wRJVMJ85dqUbiyfPSaT4wZLrRHgCQfGBrzQQ1Wrwe
        zCDM3B10vxZgwU1LT/XKmMWwaLYxwXXD4AisqhkaHhDJa4vS4cl2xJfUk47xpMYqMXq19neyAjT7/
        B/SVf1WwQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlPsB-0002of-BW; Thu, 11 Jul 2019 03:35:55 +0000
Date:   Wed, 10 Jul 2019 20:35:55 -0700
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
Message-ID: <20190711033555.GP32320@bombadil.infradead.org>
References: <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20190710190204.GB14701@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> So how about the attached patch? That keeps the interface sane and passes a
> smoketest for me (full fstest run running). Obviously it also needs a
> proper changelog...

Changelog and slightly massaged version along the lines of my two comments
attached.


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-missed-wakeup-with-PMD-faults.patch"

From 57b63fdd38e7bea7eb8d6332f0163fb028570def Mon Sep 17 00:00:00 2001
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

Cc: stable@vger.kernel.org
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/dax.c               | 47 ++++++++++++++++++++++++------------------
 include/linux/xarray.h |  4 ++--
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2e48c7ebb973..1ce1059af266 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -195,11 +195,13 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
  * Look up entry in page cache, wait for it to become unlocked if it
  * is a DAX entry and return it.  The caller must subsequently call
  * put_unlocked_entry() if it did not lock the entry or dax_unlock_entry()
- * if it did.
+ * if it did.  The entry returned may have a larger order than @order.
+ * If @order is larger than the order of the entry found in i_pages, this
+ * function returns a CONFLICT entry.
  *
  * Must be called with the i_pages lock held.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -210,6 +212,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 
 	for (;;) {
 		entry = xas_find_conflict(xas);
+		if (dax_entry_order(entry) < order)
+			return XA_DAX_CONFLICT_ENTRY;
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
 				!dax_is_locked(entry))
 			return entry;
@@ -254,7 +258,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	if (entry && entry != XA_DAX_CONFLICT_ENTRY)
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -461,7 +465,7 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -469,20 +473,17 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 retry:
 	xas_lock_irq(xas);
-	entry = get_unlocked_entry(xas);
+	entry = get_unlocked_entry(xas, order);
 
 	if (entry) {
+		if (entry == XA_DAX_CONFLICT_ENTRY)
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
@@ -523,7 +524,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
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
@@ -594,7 +599,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
-			entry = get_unlocked_entry(&xas);
+			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
 		put_unlocked_entry(&xas, entry);
@@ -621,7 +626,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	void *entry;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -849,8 +854,11 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, dax_entry_order(entry));
 
+		/* Did a PMD entry get split? */
+		if (entry == XA_DAX_CONFLICT_ENTRY)
+			goto put_unlocked;
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 			goto put_unlocked;
@@ -1510,7 +1518,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1659,11 +1667,10 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	vm_fault_t ret;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, order);
 	/* Did we race with someone splitting entry or so? */
-	if (!entry ||
-	    (order == 0 && !dax_is_pte_entry(entry)) ||
-	    (order == PMD_ORDER && !dax_is_pmd_entry(entry))) {
+	if (!entry || entry == XA_DAX_CONFLICT_ENTRY ||
+	    (order == 0 && !dax_is_pte_entry(entry))) {
 		put_unlocked_entry(&xas, entry);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 052e06ff4c36..fb25452bcfa4 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -169,7 +169,9 @@ static inline bool xa_is_internal(const void *entry)
 	return ((unsigned long)entry & 3) == 2;
 }
 
+#define XA_RETRY_ENTRY		xa_mk_internal(256)
 #define XA_ZERO_ENTRY		xa_mk_internal(257)
+#define XA_DAX_CONFLICT_ENTRY	xa_mk_internal(258)
 
 /**
  * xa_is_zero() - Is the entry a zero entry?
@@ -1213,8 +1215,6 @@ static inline bool xa_is_sibling(const void *entry)
 		(entry < xa_mk_sibling(XA_CHUNK_SIZE - 1));
 }
 
-#define XA_RETRY_ENTRY		xa_mk_internal(256)
-
 /**
  * xa_is_retry() - Is the entry a retry entry?
  * @entry: Entry retrieved from the XArray
-- 
2.20.1


--J/dobhs11T7y2rNN--
