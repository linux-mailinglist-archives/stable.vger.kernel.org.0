Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8931D30DA8A
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhBCND4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhBCNDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 08:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB8064E30;
        Wed,  3 Feb 2021 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612357392;
        bh=y1R4H32diHXkqOg91sW0kNhHSJoL/Qo6+iEJD0IpDVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oFTFXR1t8wx8adik09QcoaRU8MgPFF4dPPPBwpHxoVx6ytv1p8qC2FYdK81H5Ywie
         L2j8MSNrdRtkq6P5ZvJ0V2rIErbiYSYAWP8xL0wzesQrQLm61LbyHNF4Gif+x+zjmI
         K6RNnKjt1ZDP2IF6QFl2+/k1XO9ZXVb3dLPBtwCo=
Date:   Wed, 3 Feb 2021 14:03:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 103/142] Revert "block: end bio with BLK_STS_AGAIN in
 case of non-mq devs and REQ_NOWAIT"
Message-ID: <YBqfDdVaPurYzZM2@kroah.com>
References: <20200601174037.904070960@linuxfoundation.org>
 <20200601174048.647302799@linuxfoundation.org>
 <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203123729.3pfsakawrkoh6qpu@alap3.anarazel.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 04:37:29AM -0800, Andres Freund wrote:
> Hi,
> 
> On 2020-06-01 19:54:21 +0200, Greg Kroah-Hartman wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> >
> > [ Upstream commit b0beb28097fa04177b3769f4bb7a0d0d9c4ae76e ]
> >
> > This reverts commit c58c1f83436b501d45d4050fd1296d71a9760bcb.
> >
> > io_uring does do the right thing for this case, and we're still returning
> > -EAGAIN to userspace for the cases we don't support. Revert this change
> > to avoid doing endless spins of resubmits.
> >
> > Cc: stable@vger.kernel.org # v5.6
> > Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  block/blk-core.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> 
> This broke io_uring direct-io on ext4 over md.
> 
> fallocate -l $((1024*1024*1024)) /srv/part1
> fallocate -l $((1024*1024*1024)) /srv/part2
> losetup -f /srv/part1
> losetup -f /srv/part2
> losetup -a # assuming these were loop0/1
> mdadm --create -n2 -l stripe  -N fast-striped /dev/md/fast-striped /dev/loop0 /dev/loop1
> mkfs.ext4 /dev/md/fast-striped
> mount /dev/md/fast-striped /mnt/t2
> fio --directory=/mnt/t2 --ioengine io_uring --rw write --filesize 1MB --overwrite=1 --name=test --direct=1 --bs=4k
> 
> On v5.4.43-101-gbba91cdba612 this fails with
> fio: io_u error on file /mnt/t2/test.0.0: Input/output error: write offset=0, buflen=4096
> fio: pid=734, err=5/file:io_u.c:1834, func=io_u error, error=Input/output error
> 
> whereas previously it worked. libaio still works...
> 
> I haven't checked which major kernel version fixed this again, but I did
> verify that it's still broken in 5.4.94 and that 5.10.9 works.
> 
> I would suspect it's
> 
> commit 4503b7676a2e0abe69c2f2c0d8b03aec53f2f048
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   2020-06-01 10:00:27 -0600
> 
>     io_uring: catch -EIO from buffered issue request failure
> 
>     -EIO bubbles up like -EAGAIN if we fail to allocate a request at the
>     lower level. Play it safe and treat it like -EAGAIN in terms of sync
>     retry, to avoid passing back an errant -EIO.
> 
>     Catch some of these early for block based file, as non-mq devices
>     generally do not support NOWAIT. That saves us some overhead by
>     not first trying, then retrying from async context. We can go straight
>     to async punt instead.
> 
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> 
> which isn't in stable/linux-5.4.y

Can you test that if the above commit is added, all works well again?

thanks,

greg k-h
