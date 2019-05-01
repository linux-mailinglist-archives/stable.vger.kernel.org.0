Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578C7105B3
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 09:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfEAHIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 03:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfEAHIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 03:08:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96EE21670;
        Wed,  1 May 2019 07:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556694509;
        bh=LjaSbFGdJMYyqMP/LYmqkc3M0s9It00Wl9zPbdMYG6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nlhArq9im/zZcwzudlJveYGevf1GGzHzxPR2GgvVC7nhIPeLvq0Jsb4r+3VHBuERH
         e4JlXB7RM/3Ql5qqv4Tq+59M+dpZ9+XXn6pgSHVA3XBfHI2xWXak8pr1p3KB0DB07y
         oS2NbFBXfY74u64yE3SsGxJmN5s/1DKJOFei0R2I=
Date:   Wed, 1 May 2019 09:08:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     stable@vger.kernel.org, hannes@cmpxchg.org, tj@kernel.org,
        mhocko@suse.com, vdavydov.dev@gmail.com, guro@fb.com,
        riel@surriel.com, sfr@canb.auug.org.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, Aditya Kali <adityakali@google.com>
Subject: Re: [For Stable] mm: memcontrol: fix excessive complexity in
 memory.stat reporting
Message-ID: <20190501070827.GB30616@kroah.com>
References: <CAMVonLhjzv-DWgKV82gDMCACML14UmE3zCqsffuiMKOSGfajhQ@mail.gmail.com>
 <20190424165009.GE21916@kroah.com>
 <CAMVonLhmPhcTVSAbZzCbmYQxRECWK+6bychxFzg232dtAXeqEA@mail.gmail.com>
 <20190424183419.GB10495@kroah.com>
 <CAMVonLiXfX8r=1-fwQCk275wrkBmxjXuyWJSAmW=7hjvy7YPyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVonLiXfX8r=1-fwQCk275wrkBmxjXuyWJSAmW=7hjvy7YPyg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:41:16PM -0700, Vaibhav Rustagi wrote:
> On Wed, Apr 24, 2019 at 11:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> >
> > A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > A: Top-posting.
> > Q: What is the most annoying thing in e-mail?
> >
> > A: No.
> > Q: Should I include quotations after my reply?
> >
> > http://daringfireball.net/2007/07/on_top
> >
> > On Wed, Apr 24, 2019 at 10:35:51AM -0700, Vaibhav Rustagi wrote:
> > > Apologies for sending a non-plain text e-mail previously.
> > >
> > > This issue is encountered in the actual production environment by our
> > > customers where they are constantly creating containers
> > > and tearing them down (using kubernetes for the workload).  Kubernetes
> > > constantly reads the memory.stat file for accounting memory
> > > information and over time (around a week) the memcg's got accumulated
> > > and the response time for reading memory.stat increases and
> > > customer applications get affected.
> >
> > Please define "affected".  Their apps still run properly, so all should
> > be fine, it would be kubernetes that sees the slowdowns, not the
> > application.  How exactly does this show up to an end-user?
> >
> 
> Over time as the zombie cgroups get accumulated, kubelet (process
> doing frequent memory.stat) becomes more cpu resource intensive and
> all other user containers running on the same machine will starve for
> cpu. It affects the user containers in at-least 2 ways that we know
> of: (1) User experience liveness probe failures where there
> applications are not completed in expected amount of time.

"expected amount of time" is interesting to claim in a shared
environment :)

> (2) new user jobs cannot be schedule,

Really?  This slows down starting new processes?  Or is this just
slowing down your system overall?

> There certainly is a possibilty of reducing the adverse affect at
> Kubernetes level as well, and we are investigating that as well. But,
> the kernel patches requested helps in not exacerbating the problem.

I understand this is a kernel issue, but if you see this happen, just
updating to a modern kernel should be fine.

> > > The repro steps mentioned previously was just used for testing the
> > > patches locally.
> > >
> > > Yes, we are moving to 4.19 but are also supporting 4.14 till Jan 2020
> > > (so production environment will still contain 4.14 kernel)
> >
> > If you are already moving to 4.19, this seems like a good as reason as
> > any (hint, I can give you more) to move off of 4.14 at this point in
> > time.  There's no real need to keep 4.14 around, given that you don't
> > have any out-of-tree code in your kernels, so all should be simple to
> > just update the next reboot, right?
> >
> 
> Based on the past experiences, major kernel upgrade sometime
> introduces new regressions as well. So while we are working to roll
> out kernel 4.19, it may not be a practical solution for all the users.

If you are not doing the same exact testing senario for a new 4.14.y
kernel release as you are doing for a move to 4.19.y, then your "roll
out" process is broken.

Given that 4.19.y is now 6 months old, I would have expected any "new
regressions" to have already been reported.  Please just use a new
kernel, and if you have regressions, we will work to address them.

thanks,

greg k-h
