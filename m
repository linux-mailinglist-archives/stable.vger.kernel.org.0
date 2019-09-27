Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41BFBFEE8
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 08:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfI0GNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 02:13:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38445 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfI0GNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 02:13:07 -0400
Received: by mail-io1-f68.google.com with SMTP id u8so13325292iom.5
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 23:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6rLyBZgdgQPBTN+OLp2sJtbP71cPYzdGnLSNS6WRqeo=;
        b=jDCeqonpm7nwM70XcKvxWDUEr1bd0StHCvROhyDCJf7NoFp/MfAD+HU2+OBj84hdPL
         Blswu1oGRVy9ABVhI9WddHj+KFZMKK0CMraCa4pbUqq2cfLJVoVBqb81rf22JBboA8ba
         gX8dzM/SU/6zT4qb9sHWloMWId2CtF0gYS5ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6rLyBZgdgQPBTN+OLp2sJtbP71cPYzdGnLSNS6WRqeo=;
        b=KaI+1m4OziMJZlP/HNeCRrcAeddII7Lei5vOy4MvdH4fR7IKz151yRP7WN8hSRAT1h
         U9jCartKzMAslfHpWVYVNH2EI7tjpVydYhEcF8JnpHVhI9t2vPmbhofbyRIe4sKS7P5Y
         jYYOL+3O8V1h9GW5NiiVjKs3/gfASR2yEtqouj3r9x8Z1i/1GN5zU198UjCM9C5yXjkt
         ydW3w64AcG4X228TXeD7OJ/4rivOT9oZEr5OIzxNBmunfTkyV5zH8U38XgTX+iYQl04w
         zJIdQaY56ciNE9d8/IE+S47zItkxgvfGQnN9m1dAABPZKUzYbWC38bMjQkeAkzIJrp/F
         UGAQ==
X-Gm-Message-State: APjAAAWHMVZBwDSECvpg0jPctbRz7ZrzH68kD02vrdS7k+6m3w8IWZWg
        m52CchDtCgML3hUYVmiTjO2+d3IxtwZhFsevMiNVoJQYfZ4nRg==
X-Google-Smtp-Source: APXvYqzdaFiaPs7woG7muXEPJ9PGYdGbVpXDcQBVSVSRCKeriFLOmP9TPZdehA0ZXaxeaptft5rg0hlqgiNxc+/7+70=
X-Received: by 2002:a92:8e4f:: with SMTP id k15mr3309606ilh.108.1569564786376;
 Thu, 26 Sep 2019 23:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAC=E7cUXpUDgpvsmMaMU6sAydbfD0FEJiK25R1r=e9=YtcPjGw@mail.gmail.com>
 <20190925064414.GA1449297@kroah.com>
In-Reply-To: <20190925064414.GA1449297@kroah.com>
From:   Dave Chiluk <chiluk+linux@indeed.com>
Date:   Fri, 27 Sep 2019 01:12:40 -0500
Message-ID: <CAC=E7cXcujmbwMnmXeH2=80Lkki+j_b=WE4KCWaM1mYafDaWSA@mail.gmail.com>
Subject: Re: Please backport de53fd7aedb1 : sched/fair: Fix low cpu usage with
 high throttling by removing expiration of cpu-local slices
To:     Greg KH <greg@kroah.com>, Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 1:44 AM Greg KH <greg@kroah.com> wrote:
>
> On Wed, Sep 25, 2019 at 12:53:48AM -0500, Dave Chiluk wrote:
> > Commit de53fd7aedb1 ("sched/fair: Fix low cpu usage with high
> > throttling by removing expiration of cpu-local slices") fixes a major
> > performance issue for containerized clouds such as Kubernetes.
> >
> > Commit de53fd7aedb1 Fixes commit : 512ac999d275 ("sched/fair: Fix
> > bandwidth timer clock drift condition").
> >
> > This should be applied to all stable kernels that applied commit
> > 512ac999d275, and should probably be applied to all others as well.
>
> As this commit isn't in a released kernel just yet, we should wait to
> see what happens when it hits people's machines, right?

I think waiting till 5.4 is released would be irresponsible on this
one.  512ac999 was recently pushed back into many of the distro
kernels via the stable streams.  Additionally every major container
running cloud provider (public and private), is likely hitting this
whether they've noticed or not.  Before 512ac999 we would hit the
issue that resolved once every 10000 application deployments or so *(I
admit some providers appear to have been hit by that more often).
However, the fix implemented by 512ac999 is guaranteed to affect 100%
of cgroup cpu bandwidth constrained applications.

Our java applications are particularly hard hit as java tends to be
very thread happy.   Doing some napkin math, given the roughly 9000
applications we have running in our clouds we've had to over-allocate
each one's CPU quota by roughly .5 cpu to account for this behavior
change (worst case scenario is actually .01 cpu * cores in machine,
but not all of our applications are affected equally).
9000 applications * .5 CPU = 4500 cores
4500 Cores / 88 cores per node = 51 additional machines required to
satisfy the inflated quota requirements.
Given each 88 core machine costs roughly $30k that equates to $1.5M
that this issue is costing us.
We have been able to alleviate this somewhat of this by turning on CPU
overcommit on in the container scheduler. (Deploying more applications
per host than the CPU would generally allow for).  This however leads
to occasional overloaded machines, and regular high response
times/wide response time distributions for applications.

If you have a java or golang application running on a containerized
cloud anywhere chances are you are either paying extra to get the CPU
you need or your application is being throttled before using the quota
you've paid for.  I'm sure other languages could be affected, but
these are the two we've seen that by default generate enough threads
to regularly hit this issue.

All of these problems are leading the kubernetes community to change
the defaulrs away from the cfs bandwidth scheduling mechanisms and
towards other mechanisms or hackish workarounds. *(adjusting periods,
turning off cfs bandwidth, moving to only soft limits).
https://github.com/kubernetes/kubernetes/issues/67577
https://github.com/kubernetes/kubernetes/issues/70585
https://github.com/kubernetes/kubernetes/issues/51135

I appreciate your reluctance to accept this patch, but I strongly
believe pulling this sooner than later is the right thing to do.

> Also, always cc: all of the people involved in the patch you are asking
> for, so as to get their opinion.
Fixed.  I'll submit a change to stable-kernel-rules.rst upon my return
from vacation.

> For some reason this patch did not
> have a cc: stable tag on it, was that because the developers did not
> think it was relevant for stable kernels?

This was my fault, I was unaware I could simply cc: stable to have it
auto-submitted.  I promise I'll be better in the future.

> > It may also be prudent to also apply the not yet accepted patch that
> > fixes some introduced compiler warnings discussed here.
> > https://lkml.org/lkml/2019/9/18/925
>
> So we should wait for this to hit Linus's tree too, right?

This patch contributes nothing materially to de53fd7aedb1, and only
eliminates compiler warnings for unused variables *(which likely get
optimized out anyway).  I'm not sure what the stable policy is with
introduced compiler warnings, so I included the patch submission in
this discussion for completeness.

Thank you,
Dave Chiluk
