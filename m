Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3993C6AA0
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 08:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhGMGeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 02:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhGMGet (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 02:34:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA33E60724;
        Tue, 13 Jul 2021 06:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626157920;
        bh=iMuvmIE0kAoqY9keTpiEumLIadU2ExRBtXI7HPoxV+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZyZLJFWMbKUpdZR2ktXGQyRrkH8KUoIj3itFZpEhEsIoQEceXSfEF7LuzuEVjNA4
         UNtjwYiRjeTRWt1sERJVbSEXF2GMLgojKgW9oISVpZ5YFLKhEhD8wn+1M9lOJBv6Z8
         CjAWInjMXqODzs9pwemPaALNT/7qMibmMSDDLouE=
Date:   Tue, 13 Jul 2021 08:31:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO0zXVX9Bx9QZCTs@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 10:55:01PM -0700, Hugh Dickins wrote:
> On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 5.13.2 release.
> > There are 800 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 5.13.2-rc1
> 
> Hi Greg,
> 
> Sorry to be making waves, but please, what's up with the 5.13.2-rc,
> 5.12.17-rc, 5.10.50-rc, 5.4.132-rc stable release candidates?

They show the problem that we currently have where maintainers wait at
the end of the -rc cycle and keep valid fixes from being sent to Linus.
They "bunch up" and come out only in -rc1 and so the first few stable
releases after -rc1 comes out is huge.  It's been happening for the past
few years and only getting worse.  These stable releases are proof of
that, the 5.13.2-rc release was the largest we have ever done and it
broke one of my scripts because of it :(

I know personally I do this for my subsystems, having fixes that are
trivial things batch up for -rc1 just because they are generally not
worth getting into -final.  But that is not the case with many other
subsystems as you can see by these huge patch sequences.

> Amongst the 2000+ patches posted today, there are a significant number
> of them Signed-off-by Andrew, Signed-off-by Linus, Signed-off-by Sasha:
> yet never Cc'ed to stable (nor even posted as AUTOSELs, I think).
> 
> Am I out of date?  I thought that had been agreed not to happen:
> https://lore.kernel.org/linux-mm/20190808000533.7701-1-mike.kravetz@oracle.com/
> is the thread I found when I looked for confirmation, but I believe the
> same has been agreed before and since too.
> 
> Andrew goes to a lot of trouble to establish which Fixes from his tree
> ought to go to stable.  Of course there will be exceptions which we
> later decide should go in after all; but it's worrying when there's a
> wholesale breach like this, and I think most of them should be dropped.
> 
> To pick on just one of many examples (sorry Miaohe!), a patch that
> surprises me, but I've not had time to look into so far, and would
> not want accelerated into X stable releases, 385/800
> 
> > Miaohe Lin <linmiaohe@huawei.com>
> >     mm/shmem: fix shmem_swapin() race with swapoff

Sasha, and I, take patches from Linus's tree like the above one that
have "Fixes:" tags in them as many many maintainers do not remember to
put "cc: stable" on their patches.

The above patch says it fixes a problem in the 5.1 kernel release, so
Sasha queued it up for 5.10, 5.12, and 5.13.  Odds are he should have
also sent a "FAILED" notice for 5.4, but we don't always do that for
patches only with a Fixes tag all the time as we only have so much we
can do...

So is that tag incorrect?  If not, why was it not cc: stable?  Why is it
not valid for a stable release?  So far, all automated testing seems to
show that there are no regressions in these releases with these commits
in them.  If there was a problem, how would it show up?

And as far as I know, mm/ stuff is still not triggered by the AUTOSEL
bot, but that is not what caused this commit to be added to a stable
release.

Trying to keep a "do not apply" list for Fixes: tags only is much harder
for both of us as we do these semi-manually and review them
individually.  Trying to remember what subsystem only does Fixes tags
yet really doesn't mean it is an impossible task.

We are glad to drop any patch added to a -rc release, just let us know.
We are also glad to revert them later on if a developer/maintainer does
not catch them in time before a release happens.

thanks,

greg k-h
