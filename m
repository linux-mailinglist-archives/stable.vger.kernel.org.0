Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC862C4F2E
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 08:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbgKZHNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 02:13:30 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33752 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732167AbgKZHNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 02:13:30 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9805158C639;
        Thu, 26 Nov 2020 18:13:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kiBT1-00F9UK-94; Thu, 26 Nov 2020 18:13:23 +1100
Date:   Thu, 26 Nov 2020 18:13:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 33/33] xfs: don't allow NOWAIT DIO across
 extent boundaries
Message-ID: <20201126071323.GF2842436@dread.disaster.area>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-33-sashal@kernel.org>
 <20201125215247.GD2842436@dread.disaster.area>
 <20201125234654.GN643756@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125234654.GN643756@sasha-vm>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=3N_etuhSgFmOKDSDCMsA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 06:46:54PM -0500, Sasha Levin wrote:
> On Thu, Nov 26, 2020 at 08:52:47AM +1100, Dave Chinner wrote:
> > We've already had one XFS upstream kernel regression in this -rc
> > cycle propagated to the stable kernels in 5.9.9 because the stable
> > process picked up a bunch of random XFS fixes within hours of them
> > being merged by Linus. One of those commits was a result of a
> > thinko, and despite the fact we found it and reverted it within a
> > few days, users of stable kernels have been exposed to it for a
> > couple of weeks. That *should never have happened*.
> 
> No, what shouldn't have happened is a commit that never went out for a review
> on the public mailing lists nor spending any time in linux-next ending
> up in Linus's tree.

<sigh>

I think you've got your wires crossed somewhere, Sasha, because none
of that happened here.  From the public record, the patch was first
posted here by Darrick:

https://lore.kernel.org/linux-xfs/160494584816.772693.2490433010759557816.stgit@magnolia/

on Nov 9, and was reviewed by Christoph a day later.  It was merged
into the XFS tree on Nov 10, with the rvb tag:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=6ff646b2ceb0eec916101877f38da0b73e3a5b7f

Which means it should have been in linux-next on Nov 11, 12 and 13,
when Darrick sent the pull request:

https://lore.kernel.org/linux-xfs/20201113231738.GX9695@magnolia/

It was merged into Linus's tree an hour later.

So, in contrast to your claims, the evidence is that the patch was,
in fact, publicly posted, reviewed, and spent time in linux-next
before ending up in Linus's tree.

FWIW, on November 17, GregKH sent the patch to lkml for stable review
after being selected by the stable process for a stable backport.
This was not cc'd to the XFS list, and it was committed without
comment into the  5.9.x tree is on November 18.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/xfs?h=linux-5.9.y&id=0ca9a072112b18efc9ba9d3a9b77e9dae60f93ac

IOWs, the XFS developers didn't ask for it to be backported to
stable kernels - the commit did not contain a "cc:
stable@kernel.org", nor was the original patch posting cc'd to the
stable list.

The fact is that entire decision to backport this commit was made by
stable maintainers and/or their tools, and the stable maintainers
themselves chose not to tell the XFS list they had selected it for
backport.

Hence:

> It's ridiculous that you see a failure in the maintainership workflow of
> XFS and turn around to blame it somehow on the stable process.

.... I think you really need to have another look at the evidence
before you dig yourself a deeper hole and waste more of my time....

> > This has happened before, and *again* we were lucky this wasn't
> > worse than it was. We were saved by the flaw being caught by own
> > internal pre-write corruption verifiers (which exist because we
> > don't trust our code to be bug-free, let alone the collections of
> > random, poorly tested backports) so that it only resulted in
> > corruption shutdowns rather than permanent on-disk damage and data
> > loss.
> > 
> > Put simply: the stable process is flawed because it shortcuts the
> > necessary stabilisation testing for new code. It doesn't matter if
> 
> The stable process assumes that commits that ended up upstream were
> reviewed and tested; the stable process doesn't offer much in the way of
> in-depth review of specific patches but mostly focuses on testing the
> product of backporting hundreds of patches into each stable branch.

And I've lost count of the number of times I've told the stable
maintainers that this is an invalid assumption.

Yet here we are again.

How many times do we have to make the same mistake before we learn
from it?

> Release candidate cycles are here to squash the bugs that went in during
> the merge window, not to introduce new "thinkos" in the way of pulling
> patches out of your hip in the middle of the release cycle.

"pulling patches out of your hip"

Nice insult. Avoids profanity filters and everything. But I don't
know why you're trying to insult me over something I played no part
in.

Seriously, merging critical fixes discovered in the -rc cycle
happens *all the time* and has been done for as long as we've had
-rc cycles.  Even Linus himself does this.

The fact is that the -rc process is intended to accomodate merging
fixes quickly whilst still allowing sufficient testing time to be
confident that no regressions were introduced or have been found and
addressed before release.

And that's the whole point of having an iterative integration
testing phase in the release cycle - it can be adapted in duration
to the current state of the code base and the fixes that are being
made late in the cycle.

You *should* know all this Sasha, so I'm not sure why you are
claiming that long standing, well founded software engineering
practices are suddenly a problem...

> > the merged commits have a "fixes" tag in them, that tag doesn't mean
> > the change is ready to be exposed to production systems. We need the
> > *-rc stabilisation process* to weed out thinkos, brown paper bag
> > bugs, etc, because we all make mistakes, and bugs in filesystem code
> > can *lose user data permanently*.
> 
> What needed to happen here is that XFS's internal testing story would
> run *before* this patch was merged anywhere and catch this bug. Why
> didn't it happen?

It did. It's simply that kernel unit testing didn't discover the
bug. That happens all the time, not just in XFS.  In fact, it was
XFS userspace unit testing that found the bug.

The kernel by itself didn't trigger inconsistencies because
everything it created matches what it expected, and an old userspace
checking a new kernel would ignore the bits changed by the bad
commit in the kernel.  IOWs, the typical kernel unit testing
configuration of "new kernel, stable userspace" didn't see anything
wrong.

It wasn't until a new userspace was run with an old kernel that the
problem was found. The new userspace expected bits in the keys
on disk to be set that an old kernel didn't set and that's when
inconsistencies were flagged and the problem uncovered. This was
found by the userspace XFS maintainer as when testing the
changes merged from the kernel code. Unit testing userspace is
the opposite of the kernel - "stable kernel, new userspace" - and
that's the combination that triggered the errors that made us aware
of the problem.

So, yes, our normal testing processes found the bug, it's just a the
filesystem is *much more than just the kernel code* and sometimes
bugs in the core code are found on the userspace side before they
are found in the kernel.

However, testing variations in kernel and/or userspace tool versions
is not generally part of the unit tests developers run.  It is,
however, something that we cover as the new code rolls out to
testers and developers code as part of the integration testing
process. That's when version mismatch and upgrade/downgrade bugs
tend to show up as that's when the variety of installations the code
is tested on rapidly expands.  IOWs, we caught the problem exactly
when hindsight tells us we should expect to catch such a problem.

The reality is that a single developer cannot do this sort of
testing, hence we do not expect a single developer to do this. We
don't even expect the maintainer to be able to cover such a huge
testing scope before merging commits. It's simply not realistic to
cover everything before code changes are merged. Perfection is the
enemy of good.

I'll repeat the lesson to be learned here: merging a commit into
Linus's tree does not mean it is fully tested and production ready.
It just means it's passed a wide range of unit tests without
regressions and so is considered ready for wider integration testing
by a larger population of developers and testers.

> > Hence I ask that the stable maintainers only do automated pulls of
> > iomap and XFS changes from upstream kernels when Linus officially
> > releases them rather than at random points in time in the -rc cycle.
> > If there is a critical fix we need to go back to stable kernels
> > immediately, we will let stable@kernel.org know directly that we
> > want this done.
> 
> I'll happily switch back to a model where we look only for stable tags
> from XFS, but sadly this happened only *once* in the past year. How is
> this helping to prevent the dangerous bugs that may cause users to lose
> their data permanently?

Given that the only dangerous bug that XFS users have been directly
exposed to in recent times has been caused by an automated stable
kernel backport short-circuiting our normal commit-test-release
cycle, I can't see how XFS users will be worse off by turning off
automated backports. :/

But that is not what I asked you to do or consider, it's just a
strawman you constructed.  What I want is for users to benefit from
the overall stable process, but I don't want them exposed to the
potential catastrophic risks that the current stable process exposes
them to.

As developers, the stable process gives us no margin for error. We
need at least some margin to prevent users for being exposed to
avoidable regressions in stable kernels.  So what I'm asking you to
do is back off the bots a bit to provide that margin because, as we
all known, bugs and mistakes happen.

An acceptible compromise from our perspective would be to run
automated scans on released kernels that have already run the full
test cycle.  This way the users get the benefits of both full
integration testing of the patches that get backported, and all the
changes that the stable maintainers think their kernels should be
getting end up in the stable kernel.

For the sorts of changes your process is typically backporting from
XFS, an extra couple of weeks time lag is going to make no
difference to users at all. But that extra margin means that
situations like this recent stable kernel regression do not occur,
resulting in stable kernels having a much lower risk profile for
it's users.

That seems like a win-win-win scenario to me, so rather than throw
shade and insults at the messenger, how about listening, learning
from mistakes and trying to improve the process in a way that
benefits everyone?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
