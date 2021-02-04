Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1237E30F7B2
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhBDQY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:24:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237088AbhBDPE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 10:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD3864DBA;
        Thu,  4 Feb 2021 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612451056;
        bh=5wbQA0pqKCxKwBrohdwsCXvH4TBTm/K0JPHr/Ue0Dlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HO8/QAA9f3Fm69AZVQG5mrGLn/ebSPvv2XEssxdlcNXkzp9y3ptZknB219gMREw/v
         Bu7vHyvQfjEY1bpWXrpIFny2Ii9sSMgdzKEf6wG/g4/A3W1vIoF37UYilj8auz5XTL
         Wqo1JM5rMZo06v+Tfu6+yacEKPqYnq7a5oJG3IKI=
Date:   Thu, 4 Feb 2021 16:04:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
Message-ID: <YBwM7mN4TNXWHpi/@kroah.com>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
 <YBqfDdVaPurYzZM2@kroah.com>
 <20210203212826.6esa5orgnworwel6@alap3.anarazel.de>
 <YBsedX0/kLwMsgTy@kroah.com>
 <14351e91-5a5f-d742-b087-dc9ec733bbfd@kernel.dk>
 <20210203235941.2ibyrc5z3desyd2q@alap3.anarazel.de>
 <207c4fb1-a3cb-9210-e2b6-8e5490872df6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <207c4fb1-a3cb-9210-e2b6-8e5490872df6@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 07:36:18AM -0700, Jens Axboe wrote:
> On 2/3/21 4:59 PM, Andres Freund wrote:
> > Hi,
> > 
> > On 2021-02-03 15:58:33 -0700, Jens Axboe wrote:
> >> On 2/3/21 3:06 PM, Greg Kroah-Hartman wrote:
> >>> On Wed, Feb 03, 2021 at 01:28:26PM -0800, Andres Freund wrote:
> >>>> On 2021-02-03 14:03:09 +0100, Greg Kroah-Hartman wrote:
> >>>>>> On v5.4.43-101-gbba91cdba612 this fails with
> >>>>>> fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
> >>>>>> fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
> >>>>>>
> >>>>>> whereas previously it worked. libaio still works...
> >>>>>>
> >>>>>> I haven't checked which major kernel version fixed this again, but I did
> >>>>>> verify that it's still broken in 5.4.94 and that 5.10.9 works.
> >>>>>>
> >>>>>> I would suspect it's
> >>>>>>
> >>>>>> commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
> >>>>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>>>> Date:   2020-06-01 10:00:27 -0600
> >>>>>>
> >>>>>>     io_uring: catch -EIO from buffered issue request failure
> >>>>>>
> >>>>>>     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
> >>>>>>     lower level. Play it safe and treat it like -EAGAIN in terms of sync
> >>>>>>     retry, to avoid passing back an errant -EIO.
> >>>>>>
> >>>>>>     Catch some of these early for block based file, as non-mq devices
> >>>>>>     generally do not support NOWAIT. That saves us some overhead by
> >>>>>>     not first trying, then retrying from async context. We can go straight
> >>>>>>     to async punt instead.
> >>>>>>
> >>>>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>
> >>>>>>
> >>>>>> which isn't in stable/linux-5.4.y
> >>>>>
> >>>>> Can you test that if the above commit is added, all works well again?
> >>>>
> >>>> It doesn't apply cleanly, I'll try to resolve the conflict. However, I
> >>>> assume that the revert was for a concrete reason - but I can't quite
> >>>> figure out what b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e was concretely
> >>>> solving, and whether reverting the revert in 5.4 would re-introduce a
> >>>> different problem.
> >>>>
> >>>> commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e (tag: block-5.7-2020-05-29, linux-block/block-5.7)
> >>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>> Date:   2020-05-28 13:19:29 -0600
> >>>>
> >>>>     Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT"
> >>>>
> >>>>     This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
> >>>>
> >>>>     io_uring does do the right thing for this case, and we're still returning
> >>>>     -EAGAIN to userspace for the cases we don't support. Revert this change
> >>>>     to avoid doing endless spins of resubmits.
> >>>>
> >>>>     Cc: stable@vger.kernel.org # v5.6
> >>>>     Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> >>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>
> >>>> I suspect it just wasn't aimed at 5.4, and that's that, but I'm not
> >>>> sure. In which case presumably reverting
> >>>> bba91cdba612fbce4f8575c5d94d2b146fb83ea3 would be the right fix, not
> >>>> backporting 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048 et al.
> > 
> > Having looked a bit more through the history, I suspect that the reason
> > 5.6 doesn't need c58c1f83436b501d45d4050fd1296d71a9760bcb - which I have
> > confirmed - is that ext4 was converted to the iomap infrastructure in
> > 5.5, but not in 5.4.
> > 
> > I've confirmed that the repro I shared upthread triggers in
> > 378f32bab3714f04c4e0c3aee4129f6703805550^ but not in
> > 378f32bab3714f04c4e0c3aee4129f6703805550.
> 
> I checked up on this, and I do see the issue as well. As far as
> io_uring is concerned, we don't need that revert in 5.4. So I think
> the right solution here would be to... revert the revert :-)

Thanks for looking at this, I'll go revert the revert now.

greg k-h
