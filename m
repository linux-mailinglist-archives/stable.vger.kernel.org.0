Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2481E5FD55
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 21:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfGDTOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 15:14:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDTOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 15:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gJ4k1r3b2U7nOA5YhkQuyDkuz1ZJCnXXhW6J4mla6kQ=; b=H06sPF1WwXKUIuzngHBI1706g
        CIAK+xGfXvrJwfkiQyYlgGemI4zMr4kGTJF5bVnAGSJGFC2uNNu2NfODMaVIEarQ98Ew/sVfzLDeH
        V2Y16VE3WKWnU/kILuQb3k2OWAeFjNFPjd94SKSowcUT1FuHfFGeMNwG8dQ7iz2L/tq00hpkoCmD9
        xKXMhx/0W0H2TTOQE3btMOkB41YJP3YyU5QRfDz74YtdMstAiSwTAB8Mo7CR6aVdzRUy5A6bHsGp4
        X5XWWlTvVpXSFU0Ghwu40qiEgLURssyLb52mAtvjwBX7kaFMVDxa1OKDHNKQGDHBL58jEEH6A5c2f
        F6IfDEWGQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hj7BH-0005di-Ol; Thu, 04 Jul 2019 19:14:07 +0000
Date:   Thu, 4 Jul 2019 12:14:07 -0700
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
Message-ID: <20190704191407.GM1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704165450.GH31037@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > So I think we're good for all current users.
> 
> Agreed but it is an ugly trap. As I already said, I'd rather pay the
> unnecessary cost of waiting for pte entry and have an easy to understand
> interface. If we ever have a real world use case that would care for this
> optimization, we will need to refactor functions to make this possible and
> still keep the interfaces sane. For example get_unlocked_entry() could
> return special "error code" indicating that there's no entry with matching
> order in xarray but there's a conflict with it. That would be much less
> error-prone interface.

This is an internal interface.  I think it's already a pretty gnarly
interface to use by definition -- it's going to sleep and might return
almost anything.  There's not much scope for returning an error indicator
either; value entries occupy half of the range (all odd numbers between 1
and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
I don't think that makes the interface any easier to use than returning
a locked entry.

I think this iteration of the patch makes it a little clearer.  What do you
think?

diff --git a/fs/dax.c b/fs/dax.c
index 2e48c7ebb973..398b601259f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -198,8 +198,11 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
  * if it did.
  *
  * Must be called with the i_pages lock held.
+ *
+ * If order is non-zero, then a locked smaller entry (eg a PTE entry)
+ * may be returned.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -211,7 +214,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 	for (;;) {
 		entry = xas_find_conflict(xas);
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
-				!dax_is_locked(entry))
+				!dax_is_locked(entry) ||
+				dax_entry_order(entry) < order)
 			return entry;
 
 		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
@@ -253,8 +257,12 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
-	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	/*
+	 * If we were the only waiter woken, wake the next one.
+	 * Do not wake anybody if the entry is locked; that indicates
+	 * we weren't woken.
+	 */
+	if (entry && !dax_is_locked(entry))
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -461,7 +469,7 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -469,7 +477,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 retry:
 	xas_lock_irq(xas);
-	entry = get_unlocked_entry(xas);
+	entry = get_unlocked_entry(xas, order);
 
 	if (entry) {
 		if (!xa_is_value(entry)) {
@@ -477,7 +485,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 			goto out_unlock;
 		}
 
-		if (size_flag & DAX_PMD) {
+		if (order == PMD_ORDER) {
 			if (dax_is_pte_entry(entry)) {
 				put_unlocked_entry(xas, entry);
 				goto fallback;
@@ -523,7 +531,10 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	if (entry) {
 		dax_lock_entry(xas, entry);
 	} else {
-		entry = dax_make_entry(pfn_to_pfn_t(0), size_flag | DAX_EMPTY);
+		unsigned long flags = DAX_EMPTY;
+		if (order > 0)
+			flags |= DAX_PMD;
+		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
 		if (xas_error(xas))
 			goto out_unlock;
@@ -594,7 +605,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
-			entry = get_unlocked_entry(&xas);
+			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
 		put_unlocked_entry(&xas, entry);
@@ -621,7 +632,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	void *entry;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -849,7 +860,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, dax_entry_order(entry));
 
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
@@ -861,6 +872,9 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		 */
 		if (dax_to_pfn(old_entry) != dax_to_pfn(entry))
 			goto put_unlocked;
+		/* Did a PMD entry get split? */
+		if (dax_is_locked(entry))
+			goto put_unlocked;
 		if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
 					dax_is_zero_entry(entry))) {
 			ret = -EIO;
@@ -1510,7 +1524,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1659,7 +1673,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	vm_fault_t ret;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, order);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (order == 0 && !dax_is_pte_entry(entry)) ||
