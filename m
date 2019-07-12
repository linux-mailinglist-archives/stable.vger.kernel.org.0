Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B116682E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 10:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfGLIEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 04:04:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:37854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfGLIEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 04:04:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30666AE37;
        Fri, 12 Jul 2019 08:04:51 +0000 (UTC)
Date:   Fri, 12 Jul 2019 09:04:49 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, linux-mm@kvack.org, mhocko@suse.cz,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC] mm: migrate: Fix races of __find_get_block() and
 page migration
Message-ID: <20190712080449.GG13484@suse.de>
References: <20190711125838.32565-1-jack@suse.cz>
 <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190711170455.5a9ae6e659cab1a85f9aa30c@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 05:04:55PM -0700, Andrew Morton wrote:
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
> 

To some extent, we do not know how much of a problem this patch will
be either or what impact avoiding dirty block pages during migration
is either. So both approaches have their downsides.

However, failing a high-order allocation is typically benign and it is an
inevitable problem that depends on the workload. I don't think we could
ever hit a case whereby there was enough spinning to cause a soft lockup
but on the other hand, I don't think there is much scope for doing more
of the preparation steps before acquiring private_lock either.

-- 
Mel Gorman
SUSE Labs
