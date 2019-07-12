Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2A566B82
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 13:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfGLLU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 07:20:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:37454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbfGLLU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 07:20:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6E2AB030;
        Fri, 12 Jul 2019 11:20:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 18AE51E4340; Fri, 12 Jul 2019 13:20:56 +0200 (CEST)
Date:   Fri, 12 Jul 2019 13:20:56 +0200
From:   Jan Kara <jack@suse.cz>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, mhocko@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-ID: <20190712112056.GA24009@quack2.suse.cz>
References: <20190711125838.32565-1-jack@suse.cz>
 <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
 <20190712091746.GB906@quack2.suse.cz>
 <20190712101042.GJ13484@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20190712101042.GJ13484@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 12-07-19 11:10:43, Mel Gorman wrote:
> On Fri, Jul 12, 2019 at 11:17:46AM +0200, Jan Kara wrote:
> > On Thu 11-07-19 17:04:55, Andrew Morton wrote:
> > > On Thu, 11 Jul 2019 14:58:38 +0200 Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > buffer_migrate_page_norefs() can race with bh users in a following way:
> > > > 
> > > > CPU1					CPU2
> > > > buffer_migrate_page_norefs()
> > > >   buffer_migrate_lock_buffers()
> > > >   checks bh refs
> > > >   spin_unlock(&mapping->private_lock)
> > > > 					__find_get_block()
> > > > 					  spin_lock(&mapping->private_lock)
> > > > 					  grab bh ref
> > > > 					  spin_unlock(&mapping->private_lock)
> > > >   move page				  do bh work
> > > > 
> > > > This can result in various issues like lost updates to buffers (i.e.
> > > > metadata corruption) or use after free issues for the old page.
> > > > 
> > > > Closing this race window is relatively difficult. We could hold
> > > > mapping->private_lock in buffer_migrate_page_norefs() until we are
> > > > finished with migrating the page but the lock hold times would be rather
> > > > big. So let's revert to a more careful variant of page migration requiring
> > > > eviction of buffers on migrated page. This is effectively
> > > > fallback_migrate_page() that additionally invalidates bh LRUs in case
> > > > try_to_free_buffers() failed.
> > > 
> > > Is this premature optimization?  Holding ->private_lock while messing
> > > with the buffers would be the standard way of addressing this.  The
> > > longer hold times *might* be an issue, but we don't know this, do we? 
> > > If there are indeed such problems then they could be improved by, say,
> > > doing more of the newpage preparation prior to taking ->private_lock.
> > 
> > I didn't check how long the private_lock hold times would actually be, it
> > just seems there's a lot of work done before the page is fully migrated a
> > we could release the lock. And since the lock blocks bh lookup,
> > set_page_dirty(), etc. for the whole device, it just seemed as a bad idea.
> > I don't think much of a newpage setup can be moved outside of private_lock
> > - in particular page cache replacement, page copying, page state migration
> > all need to be there so that bh code doesn't get confused.
> > 
> > But I guess it's fair to measure at least ballpark numbers of what the lock
> > hold times would be to get idea whether the contention concern is
> > substantiated or not.
> > 
> 
> I think it would be tricky to measure and quantify how much the contention
> is an issue. While it would be possible to construct a microbenchmark that
> should illustrate the problem, it would tell us relatively little about
> how much of a problem it is generally. It would be relatively difficult
> to detect the contention and stalls in block lookups due to migration
> would be tricky to spot. Careful use of lock_stat might help but
> enabling that has consequences of its own.
> 
> However, a rise in allocation failures due to dirty pages not being
> migrated is relatively easy to detect and the consequences are relatively
> benign -- failed high-order allocation that is usually ok versus a stall
> on block lookups that could have a wider general impact.
> 
> On that basis, I think the patch you proposed is the more appropriate as
> a fix for the race which has the potential for data corruption. So;
> 
> Acked-by: Mel Gorman <mgorman@techsingularity.net>

Thanks. And I agree with you that detecting failed migrations is generally
easier than detecting private_lock contention. Anyway, out of curiosity, I
did run thpfioscale workload in mmtests with some additional metadata
workload on the system to increase proportion of bdev page cache and added
tracepoints to see how long the relevant part of __buffer_migrate_page()
lasts (patch attached). The longest duration of the critical section was
311 us which is significant. But that was an outlier by far. The most of
times critical section lasted couple of us. The full histogram is here:

[min - 0.000006]: 2907 93.202950%
(0.000006 - 0.000011]: 105 3.366464%
(0.000011 - 0.000016]: 36 1.154216%
(0.000016 - 0.000021]: 45 1.442770%
(0.000021 - 0.000026]: 13 0.416800%
(0.000026 - 0.000031]: 4 0.128246%
(0.000031 - 0.000036]: 2 0.064123%
(0.000036 - 0.000041]: 2 0.064123%
(0.000041 - 0.000046]: 1 0.032062%
(0.000046 - 0.000050]: 1 0.032062%
(0.000050 - 0.000055]: 0 0.000000%
(0.000055 - 0.000060]: 0 0.000000%
(0.000060 - 0.000065]: 0 0.000000%
(0.000065 - 0.000070]: 0 0.000000%
(0.000070 - 0.000075]: 2 0.064123%
(0.000075 - 0.000080]: 0 0.000000%
(0.000080 - 0.000085]: 0 0.000000%
(0.000085 - 0.000090]: 0 0.000000%
(0.000090 - 0.000095]: 0 0.000000%
(0.000095 - max]: 1 0.032062%

So although I still think that just failing the migration if we cannot
invalidate buffer heads is a safer choice, just extending the private_lock
protected section does not seem as bad as I was afraid.

> > Finally, I guess I should mention there's one more approach to the problem
> > I was considering: Modify bh code to fully rely on page lock instead of
> > private_lock for bh lookup. That would make sense scalability-wise on its
> > own. The problem with it is that __find_get_block() would become a sleeping
> > function. There aren't that many places calling the function and most of
> > them seem fine with it but still it is non-trivial amount of work to do the
> > conversion and it can have some fallout so it didn't seem like a good
> > solution for a data-corruption issue that needs to go to stable...
> > 
> 
> Maybe *if* it's shown there is a major issue with increased high-order
> allocation failures, it would be worth looking into but right now, I
> think it's overkill with relatively high risk and closing the potential
> race is more important.

Agreed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--sdtB3X0nJg68CQEu
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-migrate-Fix-race-with-__find_get_block.patch"

From fd584fb6fa6d48e1fae1077d2ab0021ae9c98edf Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 10 Jul 2019 11:31:01 +0200
Subject: [PATCH] mm: migrate: Fix race with __find_get_block()

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/migrate.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 mm/migrate.c                   |  8 +++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 705b33d1e395..15473a508216 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -70,6 +70,48 @@ TRACE_EVENT(mm_migrate_pages,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
+
+TRACE_EVENT(mm_migrate_buffers_begin,
+
+	TP_PROTO(struct address_space *mapping, unsigned long index),
+
+	TP_ARGS(mapping, index),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	mapping)
+		__field(unsigned long,	index)
+	),
+
+	TP_fast_assign(
+		__entry->mapping	= (unsigned long)mapping;
+		__entry->index		= index;
+	),
+
+	TP_printk("mapping=%lx index=%lu", __entry->mapping, __entry->index)
+);
+
+TRACE_EVENT(mm_migrate_buffers_end,
+
+	TP_PROTO(struct address_space *mapping, unsigned long index, int rc),
+
+	TP_ARGS(mapping, index, rc),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	mapping)
+		__field(unsigned long,	index)
+		__field(int,		rc)
+	),
+
+	TP_fast_assign(
+		__entry->mapping	= (unsigned long)mapping;
+		__entry->index		= index;
+		__entry->rc		= rc;
+	),
+
+	TP_printk("mapping=%lx index=%lu rc=%d", __entry->mapping, __entry->index, __entry->rc)
+);
+
+
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
diff --git a/mm/migrate.c b/mm/migrate.c
index e9594bc0d406..bce0f1b03a60 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -763,6 +763,7 @@ static int __buffer_migrate_page(struct address_space *mapping,
 recheck_buffers:
 		busy = false;
 		spin_lock(&mapping->private_lock);
+		trace_mm_migrate_buffers_begin(mapping, page->index);
 		bh = head;
 		do {
 			if (atomic_read(&bh->b_count)) {
@@ -771,12 +772,13 @@ static int __buffer_migrate_page(struct address_space *mapping,
 			}
 			bh = bh->b_this_page;
 		} while (bh != head);
-		spin_unlock(&mapping->private_lock);
 		if (busy) {
 			if (invalidated) {
 				rc = -EAGAIN;
 				goto unlock_buffers;
 			}
+			trace_mm_migrate_buffers_end(mapping, page->index, -EAGAIN);
+			spin_unlock(&mapping->private_lock);
 			invalidate_bh_lrus();
 			invalidated = true;
 			goto recheck_buffers;
@@ -809,6 +811,10 @@ static int __buffer_migrate_page(struct address_space *mapping,
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
+	if (check_refs) {
+		trace_mm_migrate_buffers_end(mapping, page->index, rc);
+		spin_unlock(&mapping->private_lock);
+	}
 	bh = head;
 	do {
 		unlock_buffer(bh);
-- 
2.16.4


--sdtB3X0nJg68CQEu--
