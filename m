Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3310B861
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfK0Umq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbfK0Umq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:42:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2906217D7;
        Wed, 27 Nov 2019 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887364;
        bh=beHhbE6U/9ObXAs33ms/8mvz/zJrJSElUtB3/0OmDEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ0DF3VHg85q2UyeKZFsnZjxYm4ybaR4yNlWSIs+16z4YuXyBcD+8u0OaiLn+s0sV
         vtgFotHKQhZKyKWrQ+5JOW2dZJUBlxFaPGITjwyxlnBQjE/PNuiAvD/mwHkgc3mM+a
         rCv74sXx0FxR9uKqqb0lT8KGSRoUGdjlz81nkxG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Jan Kara <jack@suse.de>, Nicholas Piggin <npiggin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/151] mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock
Date:   Wed, 27 Nov 2019 21:30:48 +0100
Message-Id: <20191127203033.822264471@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 64081362e8ff4587b4554087f3cfc73d3e0a4cd7 ]

We've recently seen a workload on XFS filesystems with a repeatable
deadlock between background writeback and a multi-process application
doing concurrent writes and fsyncs to a small range of a file.

range_cyclic
writeback		Process 1		Process 2

xfs_vm_writepages
  write_cache_pages
    writeback_index = 2
    cycled = 0
    ....
    find page 2 dirty
    lock Page 2
    ->writepage
      page 2 writeback
      page 2 clean
      page 2 added to bio
    no more pages
			write()
			locks page 1
			dirties page 1
			locks page 2
			dirties page 1
			fsync()
			....
			xfs_vm_writepages
			write_cache_pages
			  start index 0
			  find page 1 towrite
			  lock Page 1
			  ->writepage
			    page 1 writeback
			    page 1 clean
			    page 1 added to bio
			  find page 2 towrite
			  lock Page 2
			  page 2 is writeback
			  <blocks>
						write()
						locks page 1
						dirties page 1
						fsync()
						....
						xfs_vm_writepages
						write_cache_pages
						  start index 0

    !done && !cycled
      sets index to 0, restarts lookup
    find page 1 dirty
						  find page 1 towrite
						  lock Page 1
						  page 1 is writeback
						  <blocks>

    lock Page 1
    <blocks>

DEADLOCK because:

	- process 1 needs page 2 writeback to complete to make
	  enough progress to issue IO pending for page 1
	- writeback needs page 1 writeback to complete so process 2
	  can progress and unlock the page it is blocked on, then it
	  can issue the IO pending for page 2
	- process 2 can't make progress until process 1 issues IO
	  for page 1

The underlying cause of the problem here is that range_cyclic writeback is
processing pages in descending index order as we hold higher index pages
in a structure controlled from above write_cache_pages().  The
write_cache_pages() caller needs to be able to submit these pages for IO
before write_cache_pages restarts writeback at mapping index 0 to avoid
wcp inverting the page lock/writeback wait order.

generic_writepages() is not susceptible to this bug as it has no private
context held across write_cache_pages() - filesystems using this
infrastructure always submit pages in ->writepage immediately and so there
is no problem with range_cyclic going back to mapping index 0.

However:
	mpage_writepages() has a private bio context,
	exofs_writepages() has page_collect
	fuse_writepages() has fuse_fill_wb_data
	nfs_writepages() has nfs_pageio_descriptor
	xfs_vm_writepages() has xfs_writepage_ctx

All of these ->writepages implementations can hold pages under writeback
in their private structures until write_cache_pages() returns, and hence
they are all susceptible to this deadlock.

Also worth noting is that ext4 has it's own bastardised version of
write_cache_pages() and so it /may/ have an equivalent deadlock.  I looked
at the code long enough to understand that it has a similar retry loop for
range_cyclic writeback reaching the end of the file and then promptly ran
away before my eyes bled too much.  I'll leave it for the ext4 developers
to determine if their code is actually has this deadlock and how to fix it
if it has.

There's a few ways I can see avoid this deadlock.  There's probably more,
but these are the first I've though of:

1. get rid of range_cyclic altogether

2. range_cyclic always stops at EOF, and we start again from
writeback index 0 on the next call into write_cache_pages()

2a. wcp also returns EAGAIN to ->writepages implementations to
indicate range cyclic has hit EOF. writepages implementations can
then flush the current context and call wpc again to continue. i.e.
lift the retry into the ->writepages implementation

3. range_cyclic uses trylock_page() rather than lock_page(), and it
skips pages it can't lock without blocking. It will already do this
for pages under writeback, so this seems like a no-brainer

3a. all non-WB_SYNC_ALL writeback uses trylock_page() to avoid
blocking as per pages under writeback.

I don't think #1 is an option - range_cyclic prevents frequently
dirtied lower file offset from starving background writeback of
rarely touched higher file offsets.

#2 is simple, and I don't think it will have any impact on
performance as going back to the start of the file implies an
immediate seek. We'll have exactly the same number of seeks if we
switch writeback to another inode, and then come back to this one
later and restart from index 0.

#2a is pretty much "status quo without the deadlock". Moving the
retry loop up into the wcp caller means we can issue IO on the
pending pages before calling wcp again, and so avoid locking or
waiting on pages in the wrong order. I'm not convinced we need to do
this given that we get the same thing from #2 on the next writeback
call from the writeback infrastructure.

#3 is really just a band-aid - it doesn't fix the access/wait
inversion problem, just prevents it from becoming a deadlock
situation. I'd prefer we fix the inversion, not sweep it under the
carpet like this.

#3a is really an optimisation that just so happens to include the
band-aid fix of #3.

So it seems that the simplest way to fix this issue is to implement
solution #2

Link: http://lkml.kernel.org/r/20181005054526.21507-1-david@fromorbit.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page-writeback.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 281a46aeae61d..f6a376a510995 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2141,6 +2141,13 @@ EXPORT_SYMBOL(tag_pages_for_writeback);
  * not miss some pages (e.g., because some other process has cleared TOWRITE
  * tag we set). The rule we follow is that TOWRITE tag can be cleared only
  * by the process clearing the DIRTY tag (and submitting the page for IO).
+ *
+ * To avoid deadlocks between range_cyclic writeback and callers that hold
+ * pages in PageWriteback to aggregate IO until write_cache_pages() returns,
+ * we do not loop back to the start of the file. Doing so causes a page
+ * lock/page writeback access order inversion - we should only ever lock
+ * multiple pages in ascending page->index order, and looping back to the start
+ * of the file violates that rule and causes deadlocks.
  */
 int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
@@ -2155,7 +2162,6 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int cycled;
 	int range_whole = 0;
 	int tag;
 
@@ -2163,23 +2169,17 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
 		index = writeback_index;
-		if (index == 0)
-			cycled = 1;
-		else
-			cycled = 0;
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		cycled = 1; /* ignore range_cyclic tests */
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
-retry:
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
@@ -2287,17 +2287,14 @@ int write_cache_pages(struct address_space *mapping,
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled && !done) {
-		/*
-		 * range_cyclic:
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		cycled = 1;
-		index = 0;
-		end = writeback_index - 1;
-		goto retry;
-	}
+
+	/*
+	 * If we hit the last page and there is more work to be done: wrap
+	 * back the index back to the start of the file for the next
+	 * time we are called.
+	 */
+	if (wbc->range_cyclic && !done)
+		done_index = 0;
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = done_index;
 
-- 
2.20.1



