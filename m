Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA662C4BB2
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 00:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgKYXq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 18:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbgKYXq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 18:46:56 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F2D2083E;
        Wed, 25 Nov 2020 23:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606348015;
        bh=k5mfYhu4cStQ0eVyazwzjH/RQTlUxOm2HJAPEYv+r1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8ICzEZG21cC0KQzZV617ny9Ymon7LqUGz367nmqn/uX7ejVEUqokPisHnQa3i6Qa
         RWu7ilx+7SlDWRWJARSJtCMTzqWr17NCQu9MGpFP4CiYtLAMW65zpOoL5eaUh9Ca/D
         A9E69H33nj/dSYfasdssmJLoD/bPJsuB+iKHQ6R4=
Date:   Wed, 25 Nov 2020 18:46:54 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 33/33] xfs: don't allow NOWAIT DIO across
 extent boundaries
Message-ID: <20201125234654.GN643756@sasha-vm>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-33-sashal@kernel.org>
 <20201125215247.GD2842436@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201125215247.GD2842436@dread.disaster.area>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 08:52:47AM +1100, Dave Chinner wrote:
>We've already had one XFS upstream kernel regression in this -rc
>cycle propagated to the stable kernels in 5.9.9 because the stable
>process picked up a bunch of random XFS fixes within hours of them
>being merged by Linus. One of those commits was a result of a
>thinko, and despite the fact we found it and reverted it within a
>few days, users of stable kernels have been exposed to it for a
>couple of weeks. That *should never have happened*.

No, what shouldn't have happened is a commit that never went out for a review
on the public mailing lists nor spending any time in linux-next ending
up in Linus's tree.

It's ridiculous that you see a failure in the maintainership workflow of
XFS and turn around to blame it somehow on the stable process.

>This has happened before, and *again* we were lucky this wasn't
>worse than it was. We were saved by the flaw being caught by own
>internal pre-write corruption verifiers (which exist because we
>don't trust our code to be bug-free, let alone the collections of
>random, poorly tested backports) so that it only resulted in
>corruption shutdowns rather than permanent on-disk damage and data
>loss.
>
>Put simply: the stable process is flawed because it shortcuts the
>necessary stabilisation testing for new code. It doesn't matter if

The stable process assumes that commits that ended up upstream were
reviewed and tested; the stable process doesn't offer much in the way of
in-depth review of specific patches but mostly focuses on testing the
product of backporting hundreds of patches into each stable branch.

Release candidate cycles are here to squash the bugs that went in during
the merge window, not to introduce new "thinkos" in the way of pulling
patches out of your hip in the middle of the release cycle.

>the merged commits have a "fixes" tag in them, that tag doesn't mean
>the change is ready to be exposed to production systems. We need the
>*-rc stabilisation process* to weed out thinkos, brown paper bag
>bugs, etc, because we all make mistakes, and bugs in filesystem code
>can *lose user data permanently*.

What needed to happen here is that XFS's internal testing story would
run *before* this patch was merged anywhere and catch this bug. Why
didn't it happen?

>Hence I ask that the stable maintainers only do automated pulls of
>iomap and XFS changes from upstream kernels when Linus officially
>releases them rather than at random points in time in the -rc cycle.
>If there is a critical fix we need to go back to stable kernels
>immediately, we will let stable@kernel.org know directly that we
>want this done.

I'll happily switch back to a model where we look only for stable tags
from XFS, but sadly this happened only *once* in the past year. How is
this helping to prevent the dangerous bugs that may cause users to lose
their data permanently?

-- 
Thanks,
Sasha
