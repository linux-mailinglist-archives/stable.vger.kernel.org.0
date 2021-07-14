Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E213C853C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhGNN0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhGNN0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 09:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DAD613B6;
        Wed, 14 Jul 2021 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626269032;
        bh=8YweS0lldK7zFXXHnB47WnsCb1i6ItUCidY2qcQq06U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFDfD23EOd+aE4fwhDT8JLwKE2CxDe2MLiSZuNk06Yt/hf9YgphVvDpqAU0w8+DWx
         CPgzi3qgJ5UoajCJI/m1jCLyu5QdLEd+9V9HF0RgClp7sXScjYAjsSay9+UZcZu4bJ
         UBpxgUx8OuQnvo6hw1gaNg+OPCqhQ/mDJ0B507Mc=
Date:   Wed, 14 Jul 2021 15:23:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Michal Hocko <mhocko@kernel.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO7lZpqC4xrMPXQg@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO6r1k7CIl16o61z@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 11:18:14AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
> > On Tue, 13 Jul 2021 08:31:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > 
> > > > Amongst the 2000+ patches posted today, there are a significant number
> > > > of them Signed-off-by Andrew, Signed-off-by Linus, Signed-off-by Sasha:
> > > > yet never Cc'ed to stable (nor even posted as AUTOSELs, I think).
> > > > 
> > > > Am I out of date?  I thought that had been agreed not to happen:
> > > > https://lore.kernel.org/linux-mm/20190808000533.7701-1-mike.kravetz@oracle.com/
> > > > is the thread I found when I looked for confirmation, but I believe the
> > > > same has been agreed before and since too.
> > > > 
> > > > Andrew goes to a lot of trouble to establish which Fixes from his tree
> > > > ought to go to stable.  Of course there will be exceptions which we
> > > > later decide should go in after all; but it's worrying when there's a
> > > > wholesale breach like this, and I think most of them should be dropped.
> > > > 
> > > > To pick on just one of many examples (sorry Miaohe!), a patch that
> > > > surprises me, but I've not had time to look into so far, and would
> > > > not want accelerated into X stable releases, 385/800
> > > > 
> > > > > Miaohe Lin <linmiaohe@huawei.com>
> > > > >     mm/shmem: fix shmem_swapin() race with swapoff
> > > 
> > > Sasha, and I, take patches from Linus's tree like the above one that
> > > have "Fixes:" tags in them as many many maintainers do not remember to
> > > put "cc: stable" on their patches.
> > 
> > As do many many developers.  I always check.
> > 
> > > The above patch says it fixes a problem in the 5.1 kernel release, so
> > > Sasha queued it up for 5.10, 5.12, and 5.13.  Odds are he should have
> > > also sent a "FAILED" notice for 5.4, but we don't always do that for
> > > patches only with a Fixes tag all the time as we only have so much we
> > > can do...
> > > 
> > > So is that tag incorrect?  If not, why was it not cc: stable?  Why is it
> > > not valid for a stable release?
> > 
> > Usually because we judged that the seriousness of the problem did not
> > justify the risk & churn of backporting its fix.
> > 
> > >  So far, all automated testing seems to
> > > show that there are no regressions in these releases with these commits
> > > in them.  If there was a problem, how would it show up?
> > > 
> > > And as far as I know, mm/ stuff is still not triggered by the AUTOSEL
> > > bot, but that is not what caused this commit to be added to a stable
> > > release.
> > > 
> > > Trying to keep a "do not apply" list for Fixes: tags only is much harder
> > > for both of us as we do these semi-manually and review them
> > > individually.  Trying to remember what subsystem only does Fixes tags
> > > yet really doesn't mean it is an impossible task.
> > 
> > Well, it shouldn't be super hard to skip all patches which have Fixes:,
> > Signed-off-by:akpm and no cc:stable?
> 
> Ok, I will do this now (goes and writes this down...)
> 
> But it really feels odd that you all take the time to add a "Hey, this
> fixes this specific commit!" tag in the changelog, yet you do not
> actually want to go and fix the kernels that have that commit in it.
> This is an odd signal to others that watch the changelogs for context
> clues.  Perhaps you might not want to do that anymore.

I looked at some of these patches and it seems really odd to me that you
all are marking them with Fixes: tags, but do not want them backported.

First example is babbbdd08af9 ("mm/huge_memory.c: don't discard hugepage
if other processes are mapping it")

Why is this not ok to backport?

Also what about e6be37b2e7bd ("mm/huge_memory.c: add missing read-only
THP checking in transparent_hugepage_enabled()")?

And 41eb5df1cbc9 ("mm: memcg/slab: properly set up gfp flags for objcg
pointer array")?

And 6acfb5ba150c ("mm: migrate: fix missing update page_private to
hugetlb_page_subpool")?

And 832b50725373 ("mm: mmap_lock: use local locks instead of disabling
preemption")? (the RT people want that...)

And f7ec104458e0 ("mm/page_alloc: fix counting of managed_pages")?

Do you want to rely on systems where these fixes are not applied?

I can understand if you all want to send them to us later after they
have been "tested out" in Linus's tree, that's fine, but to just not
want them applied at all feels odd to me.

thanks,

greg k-h
