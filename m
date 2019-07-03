Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8044A5DEFE
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 09:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfGCHjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 03:39:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:5217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfGCHjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 00:39:14 -0700
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="157884803"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 00:39:11 -0700
Subject: [PATCH] dax: Fix missed PMD wakeups
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Boaz Harrosh <openosd@gmail.com>, stable@vger.kernel.org,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Wed, 03 Jul 2019 00:24:54 -0700
Message-ID: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
been encountering intermittent lockups. In the failing case a thread
that is taking a PMD-fault is awaiting a wakeup while holding the
'mmap_sem' for read. As soon as the next mmap() event occurs that tries
to take the 'mmap_sem' for write it causes ps(1)  and any new 'mmap_sem'
reader to block.

Debug shows that there are no outstanding Xarray entry-lock holders in
the hang state which indicates that a PTE lock-holder thread caused a
PMD thread to wait. When the PTE index-lock is released it may wake the
wrong waitqueue depending on how the index hashes. Brute-force fix this
by arranging for PTE-aligned indices within a PMD-span to hash to the
same waitqueue as the PMD-index.

This fix may increase waitqueue contention, but a fix for that is saved
for a larger rework. In the meantime this fix is suitable for -stable
backports.

Link: https://lore.kernel.org/linux-fsdevel/CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail>
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <openosd@gmail.com>
Cc: <stable@vger.kernel.org>
Reported-by: Robert Barror <robert.barror@intel.com>
Reported-by: Seema Pandit <seema.pandit@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9fd908f3df32..592944c522b8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -144,19 +144,14 @@ struct wait_exceptional_entry_queue {
 	struct exceptional_entry_key key;
 };
 
-static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
-		void *entry, struct exceptional_entry_key *key)
+static wait_queue_head_t *dax_index_waitqueue(struct xa_state *xas,
+		struct exceptional_entry_key *key)
 {
 	unsigned long hash;
 	unsigned long index = xas->xa_index;
 
-	/*
-	 * If 'entry' is a PMD, align the 'index' that we use for the wait
-	 * queue to the start of that PMD.  This ensures that all offsets in
-	 * the range covered by the PMD map to the same bit lock.
-	 */
-	if (dax_is_pmd_entry(entry))
-		index &= ~PG_PMD_COLOUR;
+	/* PMD-align the index to ensure PTE events wakeup PMD waiters */
+	index &= ~PG_PMD_COLOUR;
 	key->xa = xas->xa;
 	key->entry_start = index;
 
@@ -177,17 +172,12 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait,
 	return autoremove_wake_function(wait, mode, sync, NULL);
 }
 
-/*
- * @entry may no longer be the entry at the index in the mapping.
- * The important information it's conveying is whether the entry at
- * this index used to be a PMD entry.
- */
-static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
+static void dax_wake_index(struct xa_state *xas, bool wake_all)
 {
 	struct exceptional_entry_key key;
 	wait_queue_head_t *wq;
 
-	wq = dax_entry_waitqueue(xas, entry, &key);
+	wq = dax_index_waitqueue(xas, &key);
 
 	/*
 	 * Checking for locked entry and prepare_to_wait_exclusive() happens
@@ -222,7 +212,7 @@ static void *get_unlocked_entry(struct xa_state *xas)
 				!dax_is_locked(entry))
 			return entry;
 
-		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
+		wq = dax_index_waitqueue(xas, &ewait.key);
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
 		xas_unlock_irq(xas);
@@ -246,7 +236,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 	init_wait(&ewait.wait);
 	ewait.wait.func = wake_exceptional_entry_func;
 
-	wq = dax_entry_waitqueue(xas, entry, &ewait.key);
+	wq = dax_index_waitqueue(xas, &ewait.key);
 	/*
 	 * Unlike get_unlocked_entry() there is no guarantee that this
 	 * path ever successfully retrieves an unlocked entry before an
@@ -263,7 +253,7 @@ static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
 	if (entry)
-		dax_wake_entry(xas, entry, false);
+		dax_wake_index(xas, false);
 }
 
 /*
@@ -281,7 +271,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
 	old = xas_store(xas, entry);
 	xas_unlock_irq(xas);
 	BUG_ON(!dax_is_locked(old));
-	dax_wake_entry(xas, entry, false);
+	dax_wake_index(xas, false);
 }
 
 /*
@@ -522,7 +512,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
-		dax_wake_entry(xas, entry, true);
+		dax_wake_index(xas, true);
 		mapping->nrexceptional--;
 		entry = NULL;
 		xas_set(xas, index);
@@ -915,7 +905,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_lock_irq(xas);
 	xas_store(xas, entry);
 	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
-	dax_wake_entry(xas, entry, false);
+	dax_wake_index(xas, false);
 
 	trace_dax_writeback_one(mapping->host, index, count);
 	return ret;

