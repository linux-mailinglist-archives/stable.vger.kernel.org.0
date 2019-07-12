Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8720B669C7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfGLJRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:17:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:55298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725993AbfGLJRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 05:17:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7ABE6AC63;
        Fri, 12 Jul 2019 09:17:46 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3F1FD1E43CA; Fri, 12 Jul 2019 11:17:46 +0200 (CEST)
Date:   Fri, 12 Jul 2019 11:17:46 +0200
From:   Jan Kara <jack@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, linux-mm@kvack.org, mgorman@suse.de,
        mhocko@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-ID: <20190712091746.GB906@quack2.suse.cz>
References: <20190711125838.32565-1-jack@suse.cz>
 <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 11-07-19 17:04:55, Andrew Morton wrote:
> On Thu, 11 Jul 2019 14:58:38 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > buffer_migrate_page_norefs() can race with bh users in a following way:
> > 
> > CPU1					CPU2
> > buffer_migrate_page_norefs()
> >   buffer_migrate_lock_buffers()
> >   checks bh refs
> >   spin_unlock(&mapping->private_lock)
> > 					__find_get_block()
> > 					  spin_lock(&mapping->private_lock)
> > 					  grab bh ref
> > 					  spin_unlock(&mapping->private_lock)
> >   move page				  do bh work
> > 
> > This can result in various issues like lost updates to buffers (i.e.
> > metadata corruption) or use after free issues for the old page.
> > 
> > Closing this race window is relatively difficult. We could hold
> > mapping->private_lock in buffer_migrate_page_norefs() until we are
> > finished with migrating the page but the lock hold times would be rather
> > big. So let's revert to a more careful variant of page migration requiring
> > eviction of buffers on migrated page. This is effectively
> > fallback_migrate_page() that additionally invalidates bh LRUs in case
> > try_to_free_buffers() failed.
> 
> Is this premature optimization?  Holding ->private_lock while messing
> with the buffers would be the standard way of addressing this.  The
> longer hold times *might* be an issue, but we don't know this, do we? 
> If there are indeed such problems then they could be improved by, say,
> doing more of the newpage preparation prior to taking ->private_lock.

I didn't check how long the private_lock hold times would actually be, it
just seems there's a lot of work done before the page is fully migrated a
we could release the lock. And since the lock blocks bh lookup,
set_page_dirty(), etc. for the whole device, it just seemed as a bad idea.
I don't think much of a newpage setup can be moved outside of private_lock
- in particular page cache replacement, page copying, page state migration
all need to be there so that bh code doesn't get confused.

But I guess it's fair to measure at least ballpark numbers of what the lock
hold times would be to get idea whether the contention concern is
substantiated or not.

Finally, I guess I should mention there's one more approach to the problem
I was considering: Modify bh code to fully rely on page lock instead of
private_lock for bh lookup. That would make sense scalability-wise on its
own. The problem with it is that __find_get_block() would become a sleeping
function. There aren't that many places calling the function and most of
them seem fine with it but still it is non-trivial amount of work to do the
conversion and it can have some fallout so it didn't seem like a good
solution for a data-corruption issue that needs to go to stable...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
