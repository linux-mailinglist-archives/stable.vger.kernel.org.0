Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40CA30E5AD
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 23:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhBCWHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 17:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233054AbhBCWHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 17:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C94764F7E;
        Wed,  3 Feb 2021 22:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612390007;
        bh=UEWOIc7PN2IjGCBOFwALkVTAoKa3FvEWV2NY+0mKd9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZB4OsQUA1qZ1utmg/wOPBGQp5sqbCBTZQjMu8JPSn7QeAd0Nkc7ILmw+zJuLBMC3b
         ZpEx1m6woyZVxdbc0jZy1pXl6z8YODXJMcS/8see8/U0xXHzVReUEErdGqhI07s0Ni
         A+ZyS/CxHr4ImRUa04vs1eje1SKB5GMxJzX+rbOM=
Date:   Wed, 3 Feb 2021 23:06:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
Message-ID: <YBsedX0/kLwMsgTy@kroah.com>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
 <YBqfDdVaPurYzZM2@kroah.com>
 <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 01:28:26PM -0800, Andres Freund wrote:
> Hi,
> 
> On 2021-02-03 14:03:09 +0100, Greg Kroah-Hartman wrote:
> > > On v5.4.43-101-gbba91cdba612 this fails with
> > > fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
> > > fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
> > >
> > > whereas previously it worked. libaio still works...
> > >
> > > I haven't checked which major kernel version fixed this again, but I did
> > > verify that it's still broken in 5.4.94 and that 5.10.9 works.
> > >
> > > I would suspect it's
> > >
> > > commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
> > > Author: Jens Axboe <axboe@kernel.dk>
> > > Date:   2020-06-01 10:00:27 -0600
> > >
> > >     io_uring: catch -EIO from buffered issue request failure
> > >
> > >     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
> > >     lower level. Play it safe and treat it like -EAGAIN in terms of sync
> > >     retry, to avoid passing back an errant -EIO.
> > >
> > >     Catch some of these early for block based file, as non-mq devices
> > >     generally do not support NOWAIT. That saves us some overhead by
> > >     not first trying, then retrying from async context. We can go straight
> > >     to async punt instead.
> > >
> > >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > >
> > >
> > > which isn't in stable/linux-5.4.y
> >
> > Can you test that if the above commit is added, all works well again?
> 
> It doesn't apply cleanly, I'll try to resolve the conflict. However, I
> assume that the revert was for a concrete reason - but I can't quite
> figure out what b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e was concretely
> solving, and whether reverting the revert in 5.4 would re-introduce a
> different problem.
> 
> commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e (tag: block-5.7-2020-05-29, linux-block/block-5.7)
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   2020-05-28 13:19:29 -0600
> 
>     Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
> 
>     This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
> 
>     io_uring does do the right thing for this case, and we're still returning
>     -EAGAIN to userspace for the cases we don't support. Revert this change
>     to avoid doing endless spins of resubmits.
> 
>     Cc: stable@vger.kernel.org # v5.6
>     Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I suspect it just wasn't aimed at 5.4, and that's that, but I'm not
> sure. In which case presumably reverting
> bba91cdba612fbce4f8575c5d94d2b146fb83ea3 would be the right fix, not
> backporting 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048 et al.

Ok, can you send a revert patch for this?

But it would be good to get Jens to weigh in on this...

thanks,

greg k-h
