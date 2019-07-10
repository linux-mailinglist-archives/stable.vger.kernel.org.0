Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC2764C77
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 21:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfGJTCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 15:02:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbfGJTCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 15:02:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B052B030;
        Wed, 10 Jul 2019 19:02:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4AAE71E43B7; Wed, 10 Jul 2019 21:02:04 +0200 (CEST)
Date:   Wed, 10 Jul 2019 21:02:04 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190710190204.GB14701@quack2.suse.cz>
References: <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 05-07-19 13:47:02, Dan Williams wrote:
> On Fri, Jul 5, 2019 at 12:10 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Jul 04, 2019 at 04:27:14PM -0700, Dan Williams wrote:
> > > On Thu, Jul 4, 2019 at 12:14 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> > > > > On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > > > > > So I think we're good for all current users.
> > > > >
> > > > > Agreed but it is an ugly trap. As I already said, I'd rather pay the
> > > > > unnecessary cost of waiting for pte entry and have an easy to understand
> > > > > interface. If we ever have a real world use case that would care for this
> > > > > optimization, we will need to refactor functions to make this possible and
> > > > > still keep the interfaces sane. For example get_unlocked_entry() could
> > > > > return special "error code" indicating that there's no entry with matching
> > > > > order in xarray but there's a conflict with it. That would be much less
> > > > > error-prone interface.
> > > >
> > > > This is an internal interface.  I think it's already a pretty gnarly
> > > > interface to use by definition -- it's going to sleep and might return
> > > > almost anything.  There's not much scope for returning an error indicator
> > > > either; value entries occupy half of the range (all odd numbers between 1
> > > > and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
> > > > I don't think that makes the interface any easier to use than returning
> > > > a locked entry.
> > > >
> > > > I think this iteration of the patch makes it a little clearer.  What do you
> > > > think?
> > > >
> > >
> > > Not much clearer to me. get_unlocked_entry() is now misnamed and this
> >
> > misnamed?  You'd rather it was called "try_get_unlocked_entry()"?
> 
> I was thinking more along the lines of
> get_unlocked_but_sometimes_locked_entry(), i.e. per Jan's feedback to
> keep the interface simple.

So how about the attached patch? That keeps the interface sane and passes a
smoketest for me (full fstest run running). Obviously it also needs a
proper changelog...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-missed-PMD-wakeups.patch"

From 1aeaba0e061b2bf38143f21d054e66853543a680 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 10 Jul 2019 20:28:37 +0200
Subject: [PATCH] dax: Fix missed PMD wakeups

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fe5e33810cd4..3fe655d38c7a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -191,15 +191,18 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
 		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
 }
 
+#define DAX_ENTRY_CONFLICT dax_make_entry(pfn_to_pfn_t(1), DAX_EMPTY)
 /*
  * Look up entry in page cache, wait for it to become unlocked if it
  * is a DAX entry and return it.  The caller must subsequently call
  * put_unlocked_entry() if it did not lock the entry or dax_unlock_entry()
- * if it did.
+ * if it did. 'order' is the minimum order of entry to return. If there's no
+ * entry of sufficiently large order but there are some entries of lower order
+ * in the range described by xas, return special DAX_ENTRY_CONFLICT value.
  *
  * Must be called with the i_pages lock held.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -210,6 +213,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 
 	for (;;) {
 		entry = xas_find_conflict(xas);
+		if (dax_entry_order(entry) < order)
+			return DAX_ENTRY_CONFLICT;
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
 				!dax_is_locked(entry))
 			return entry;
@@ -254,7 +259,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	if (entry && entry != DAX_ENTRY_CONFLICT)
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -461,7 +466,7 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -469,20 +474,16 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 retry:
 	xas_lock_irq(xas);
-	entry = get_unlocked_entry(xas);
-
+	entry = get_unlocked_entry(xas, order);
+	if (entry == DAX_ENTRY_CONFLICT)
+		goto fallback;
 	if (entry) {
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
@@ -848,7 +853,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, 0);
 
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
@@ -1509,7 +1514,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1658,11 +1663,10 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	vm_fault_t ret;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, order);
 	/* Did we race with someone splitting entry or so? */
-	if (!entry ||
-	    (order == 0 && !dax_is_pte_entry(entry)) ||
-	    (order == PMD_ORDER && !dax_is_pmd_entry(entry))) {
+	if (!entry || entry == DAX_ENTRY_CONFLICT ||
+	    (order == 0 && !dax_is_pte_entry(entry))) {
 		put_unlocked_entry(&xas, entry);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
-- 
2.16.4


--Nq2Wo0NMKNjxTN9z--
