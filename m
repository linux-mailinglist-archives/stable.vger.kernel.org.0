Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1943C7B0E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 03:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhGNBbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 21:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhGNBbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 21:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCAED6128B;
        Wed, 14 Jul 2021 01:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626226094;
        bh=1Kq4a+B3sv2xmZ3srIAChXuQ/hkTCRS9tvGxI9qxX8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XgCjkHJYFA/5vw/DvI6zk8UZ1aqrcF7YGM2yT3HL34SM9KQBwYYX32sIeboXDLaE8
         bpp+NJ9bHKY0FVX8vure3zT70Hkg2JMfIy+JRdhj91DgEv5gDdlzbka3xYxif/mmbJ
         6m0iYWhtJnBZjO2zGBr+twF+gJMOhIiFbw1376Oc=
Date:   Tue, 13 Jul 2021 18:28:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-Id: <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
In-Reply-To: <YO0zXVX9Bx9QZCTs@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
        <YO0zXVX9Bx9QZCTs@kroah.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Jul 2021 08:31:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 
> > Amongst the 2000+ patches posted today, there are a significant number
> > of them Signed-off-by Andrew, Signed-off-by Linus, Signed-off-by Sasha:
> > yet never Cc'ed to stable (nor even posted as AUTOSELs, I think).
> > 
> > Am I out of date?  I thought that had been agreed not to happen:
> > https://lore.kernel.org/linux-mm/20190808000533.7701-1-mike.kravetz@oracle.com/
> > is the thread I found when I looked for confirmation, but I believe the
> > same has been agreed before and since too.
> > 
> > Andrew goes to a lot of trouble to establish which Fixes from his tree
> > ought to go to stable.  Of course there will be exceptions which we
> > later decide should go in after all; but it's worrying when there's a
> > wholesale breach like this, and I think most of them should be dropped.
> > 
> > To pick on just one of many examples (sorry Miaohe!), a patch that
> > surprises me, but I've not had time to look into so far, and would
> > not want accelerated into X stable releases, 385/800
> > 
> > > Miaohe Lin <linmiaohe@huawei.com>
> > >     mm/shmem: fix shmem_swapin() race with swapoff
> 
> Sasha, and I, take patches from Linus's tree like the above one that
> have "Fixes:" tags in them as many many maintainers do not remember to
> put "cc: stable" on their patches.

As do many many developers.  I always check.

> The above patch says it fixes a problem in the 5.1 kernel release, so
> Sasha queued it up for 5.10, 5.12, and 5.13.  Odds are he should have
> also sent a "FAILED" notice for 5.4, but we don't always do that for
> patches only with a Fixes tag all the time as we only have so much we
> can do...
> 
> So is that tag incorrect?  If not, why was it not cc: stable?  Why is it
> not valid for a stable release?

Usually because we judged that the seriousness of the problem did not
justify the risk & churn of backporting its fix.

>  So far, all automated testing seems to
> show that there are no regressions in these releases with these commits
> in them.  If there was a problem, how would it show up?
> 
> And as far as I know, mm/ stuff is still not triggered by the AUTOSEL
> bot, but that is not what caused this commit to be added to a stable
> release.
> 
> Trying to keep a "do not apply" list for Fixes: tags only is much harder
> for both of us as we do these semi-manually and review them
> individually.  Trying to remember what subsystem only does Fixes tags
> yet really doesn't mean it is an impossible task.

Well, it shouldn't be super hard to skip all patches which have Fixes:,
Signed-off-by:akpm and no cc:stable?

I'd really really prefer this, please.  At present this -stable
promiscuity is overriding the (sometime carefully) considered decisions
of the MM developers, and that's a bit scary.  I've actually been
spending the past couple of years believing that if I left off
cc:stable, the fix wasn't going to go into -stable!

Alternatively I could just invent a new tag to replace the "Fixes:"
("Fixes-no-backport?") to be used on patches which fix a known previous
commit but which we don't want backported.


