Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF46813E
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 23:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbfGNVUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 17:20:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:45814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728654AbfGNVUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 17:20:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D23E8AC91;
        Sun, 14 Jul 2019 21:20:17 +0000 (UTC)
Date:   Sun, 14 Jul 2019 22:20:15 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, linux-mm@kvack.org, mhocko@suse.cz,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-ID: <20190714212015.GM13484@suse.de>
References: <20190711125838.32565-1-jack@suse.cz>
 <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
 <20190712091746.GB906@quack2.suse.cz>
 <20190712101042.GJ13484@suse.de>
 <20190712112056.GA24009@quack2.suse.cz>
 <20190712123935.GK13484@suse.de>
 <20190712142111.eac6322eea55f7e8f75b7b33@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190712142111.eac6322eea55f7e8f75b7b33@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:21:11PM -0700, Andrew Morton wrote:
> On Fri, 12 Jul 2019 13:39:35 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > > So although I still think that just failing the migration if we cannot
> > > invalidate buffer heads is a safer choice, just extending the private_lock
> > > protected section does not seem as bad as I was afraid.
> > > 
> > 
> > That does not seem too bad and your revised patch looks functionally
> > fine. I'd leave out the tracepoints though because a perf probe would have
> > got roughly the same data and the tracepoint may be too specific to track
> > another class of problem. Whether the tracepoint survives or not and
> > with a changelog added;
> > 
> > Acked-by: Mel Gorman <mgorman@techsingularity.net>
> > 
> > Andrew, which version do you want to go with, the original version or
> > this one that holds private_lock for slightly longer during migration?
> 
> The revised version looks much more appealing for a -stable backport. 
> I expect any mild performance issues can be address in the usual
> fashion.  My main concern is not to put a large performance regression
> into mainline and stable kernels.  How confident are we that this is
> (will be) sufficiently tested from that point of view?
> 

Fairly confident. If we agree on this patch in principle (build tested
only), I'll make sure it gets tested from a functional point of view
and queue up a few migration-intensive tests while a metadata workload
is running in the background to see what falls out. Furthermore, not all
filesystems even take this path even for migration-intensive situations
so some setups will never notice a difference.

---8<---
From a4f07d789ba5742cd2fe6bcfb635502f2a1de004 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 10 Jul 2019 11:31:01 +0200
Subject: [PATCH] mm: migrate: Fix race with __find_get_block()

buffer_migrate_page_norefs() can race with bh users in a following way:

CPU1                                    CPU2
buffer_migrate_page_norefs()
  buffer_migrate_lock_buffers()
  checks bh refs
  spin_unlock(&mapping->private_lock)
                                        __find_get_block()
                                          spin_lock(&mapping->private_lock)
                                          grab bh ref
                                          spin_unlock(&mapping->private_lock)
  move page                               do bh work

This can result in various issues like lost updates to buffers (i.e.
metadata corruption) or use after free issues for the old page.

This patch closes the race by holding mapping->private_lock while the
mapping is being moved to a new page. Ordinarily, a reference can be taken
outside of the private_lock using the per-cpu BH LRU but the references
are checked and the LRU invalidated if necessary. The private_lock is held
once the references are known so the buffer lookup slow path will spin
on the private_lock. Between the page lock and private_lock, it should
be impossible for other references to be acquired and updates to happen
during the migration.

[mgorman@techsingularity.net: Changelog, removed tracing]
Fixes: 89cb0888ca14 "mm: migrate: provide buffer_migrate_page_norefs()"
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 mm/migrate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e9594bc0d406..a59e4aed6d2e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -771,12 +771,12 @@ static int __buffer_migrate_page(struct address_space *mapping,
 			}
 			bh = bh->b_this_page;
 		} while (bh != head);
-		spin_unlock(&mapping->private_lock);
 		if (busy) {
 			if (invalidated) {
 				rc = -EAGAIN;
 				goto unlock_buffers;
 			}
+			spin_unlock(&mapping->private_lock);
 			invalidate_bh_lrus();
 			invalidated = true;
 			goto recheck_buffers;
@@ -809,6 +809,8 @@ static int __buffer_migrate_page(struct address_space *mapping,
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
+	if (check_refs)
+		spin_unlock(&mapping->private_lock);
 	bh = head;
 	do {
 		unlock_buffer(bh);

-- 
Mel Gorman
SUSE Labs
