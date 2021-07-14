Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3643C8155
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 11:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbhGNJVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 05:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238189AbhGNJVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 05:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78FC361370;
        Wed, 14 Jul 2021 09:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626254298;
        bh=TaQMEAMiqW5ftXExwf1yrkJI+SslnJWeSCkRVn4NqSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4lGqiJB0Ge6QP1LDnusUIRfmL1dsAT0/rUkEMH5n8Yf3vspME4x08nh2OS08T31K
         Uo/egFjhyyY3YuzXS/RnJu3WEdtbL2V7l3i9G8KxcsbKg4FTsZKd03We97jVVBMR5n
         ycrBXBZsvuCyIdzk03FUSlq3NfQaW34/Dwma9yQI=
Date:   Wed, 14 Jul 2021 11:18:14 +0200
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
Message-ID: <YO6r1k7CIl16o61z@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
> On Tue, 13 Jul 2021 08:31:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 
> > > Amongst the 2000+ patches posted today, there are a significant number
> > > of them Signed-off-by Andrew, Signed-off-by Linus, Signed-off-by Sasha:
> > > yet never Cc'ed to stable (nor even posted as AUTOSELs, I think).
> > > 
> > > Am I out of date?  I thought that had been agreed not to happen:
> > > https://lore.kernel.org/linux-mm/20190808000533.7701-1-mike.kravetz@oracle.com/
> > > is the thread I found when I looked for confirmation, but I believe the
> > > same has been agreed before and since too.
> > > 
> > > Andrew goes to a lot of trouble to establish which Fixes from his tree
> > > ought to go to stable.  Of course there will be exceptions which we
> > > later decide should go in after all; but it's worrying when there's a
> > > wholesale breach like this, and I think most of them should be dropped.
> > > 
> > > To pick on just one of many examples (sorry Miaohe!), a patch that
> > > surprises me, but I've not had time to look into so far, and would
> > > not want accelerated into X stable releases, 385/800
> > > 
> > > > Miaohe Lin <linmiaohe@huawei.com>
> > > >     mm/shmem: fix shmem_swapin() race with swapoff
> > 
> > Sasha, and I, take patches from Linus's tree like the above one that
> > have "Fixes:" tags in them as many many maintainers do not remember to
> > put "cc: stable" on their patches.
> 
> As do many many developers.  I always check.
> 
> > The above patch says it fixes a problem in the 5.1 kernel release, so
> > Sasha queued it up for 5.10, 5.12, and 5.13.  Odds are he should have
> > also sent a "FAILED" notice for 5.4, but we don't always do that for
> > patches only with a Fixes tag all the time as we only have so much we
> > can do...
> > 
> > So is that tag incorrect?  If not, why was it not cc: stable?  Why is it
> > not valid for a stable release?
> 
> Usually because we judged that the seriousness of the problem did not
> justify the risk & churn of backporting its fix.
> 
> >  So far, all automated testing seems to
> > show that there are no regressions in these releases with these commits
> > in them.  If there was a problem, how would it show up?
> > 
> > And as far as I know, mm/ stuff is still not triggered by the AUTOSEL
> > bot, but that is not what caused this commit to be added to a stable
> > release.
> > 
> > Trying to keep a "do not apply" list for Fixes: tags only is much harder
> > for both of us as we do these semi-manually and review them
> > individually.  Trying to remember what subsystem only does Fixes tags
> > yet really doesn't mean it is an impossible task.
> 
> Well, it shouldn't be super hard to skip all patches which have Fixes:,
> Signed-off-by:akpm and no cc:stable?

Ok, I will do this now (goes and writes this down...)

But it really feels odd that you all take the time to add a "Hey, this
fixes this specific commit!" tag in the changelog, yet you do not
actually want to go and fix the kernels that have that commit in it.
This is an odd signal to others that watch the changelogs for context
clues.  Perhaps you might not want to do that anymore.

> I'd really really prefer this, please.  At present this -stable
> promiscuity is overriding the (sometime carefully) considered decisions
> of the MM developers, and that's a bit scary.  I've actually been
> spending the past couple of years believing that if I left off
> cc:stable, the fix wasn't going to go into -stable!

That used to be the case, but we have had to deal with all of the
subsystems where people were NOT putting cc: stable on them, and only
Fixes: tags.  It's slowly getting better, but some subsystems refuse to
do this for some reason (it's hard to wrangle 4000 people to all do the
same thing...)

> Alternatively I could just invent a new tag to replace the "Fixes:"
> ("Fixes-no-backport?") to be used on patches which fix a known previous
> commit but which we don't want backported.

No please, that's not needed, I'll just ignore these types of patches
now, and will go drop these from the queues.

Sasha, can you also add these to your "do not apply" script as well?

thanks,

greg k-h
