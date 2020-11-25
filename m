Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75A2C4ABF
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733309AbgKYWST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 17:18:19 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56208 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730293AbgKYWST (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 17:18:19 -0500
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 17:18:17 EST
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4099758C481;
        Thu, 26 Nov 2020 08:52:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ki2iV-00F18A-J1; Thu, 26 Nov 2020 08:52:47 +1100
Date:   Thu, 26 Nov 2020 08:52:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 33/33] xfs: don't allow NOWAIT DIO across
 extent boundaries
Message-ID: <20201125215247.GD2842436@dread.disaster.area>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-33-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125153550.810101-33-sashal@kernel.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=zLXZRxuV2e5zHgAcDCcA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 10:35:50AM -0500, Sasha Levin wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit 883a790a84401f6f55992887fd7263d808d4d05d ]
> 
> Jens has reported a situation where partial direct IOs can be issued
> and completed yet still return -EAGAIN. We don't want this to report
> a short IO as we want XFS to complete user DIO entirely or not at
> all.
> 
> This partial IO situation can occur on a write IO that is split
> across an allocated extent and a hole, and the second mapping is
> returning EAGAIN because allocation would be required.
> 
> The trivial reproducer:
> 
> $ sudo xfs_io -fdt -c "pwrite 0 4k" -c "pwrite -V 1 -b 8k -N 0 8k" /mnt/scr/foo
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0001 sec (27.509 MiB/sec and 7042.2535 ops/sec)
> pwrite: Resource temporarily unavailable
> $
> 
> The pwritev2(0, 8kB, RWF_NOWAIT) call returns EAGAIN having done
> the first 4kB write:
> 
>  xfs_file_direct_write: dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 0x2000
>  iomap_apply:          dev 259:1 ino 0x83 pos 0 length 8192 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
>  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
>  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
>  xfs_iomap_found:      dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 8192 fork data startoff 0x0 startblock 24 blockcount 0x1
>  iomap_apply_dstmap:   dev 259:1 ino 0x83 bdev 259:1 addr 102400 offset 0 length 4096 type MAPPED flags DIRTY
> 
> Here the first iomap loop has mapped the first 4kB of the file and
> issued the IO, and we enter the second iomap_apply loop:
> 
>  iomap_apply: dev 259:1 ino 0x83 pos 4096 length 4096 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
>  xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
>  xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
> 
> And we exit with -EAGAIN out because we hit the allocate case trying
> to make the second 4kB block.
> 
> Then IO completes on the first 4kB and the original IO context
> completes and unlocks the inode, returning -EAGAIN to userspace:
> 
>  xfs_end_io_direct_write: dev 259:1 ino 0x83 isize 0x1000 disize 0x1000 offset 0x0 count 4096
>  xfs_iunlock:          dev 259:1 ino 0x83 flags IOLOCK_SHARED caller xfs_file_dio_aio_write
> 
> There are other vectors to the same problem when we re-enter the
> mapping code if we have to make multiple mappinfs under NOWAIT
> conditions. e.g. failing trylocks, COW extents being found,
> allocation being required, and so on.
> 
> Avoid all these potential problems by only allowing IOMAP_NOWAIT IO
> to go ahead if the mapping we retrieve for the IO spans an entire
> allocated extent. This avoids the possibility of subsequent mappings
> to complete the IO from triggering NOWAIT semantics by any means as
> NOWAIT IO will now only enter the mapping code once per NOWAIT IO.
> 
> Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)

No, please don't pick this up for stable kernels until at least 5.10
is released. This still needs some time integration testing time to
ensure that we haven't introduced any other performance regressions
with this change.

We've already had one XFS upstream kernel regression in this -rc
cycle propagated to the stable kernels in 5.9.9 because the stable
process picked up a bunch of random XFS fixes within hours of them
being merged by Linus. One of those commits was a result of a
thinko, and despite the fact we found it and reverted it within a
few days, users of stable kernels have been exposed to it for a
couple of weeks. That *should never have happened*. 

This has happened before, and *again* we were lucky this wasn't
worse than it was. We were saved by the flaw being caught by own
internal pre-write corruption verifiers (which exist because we
don't trust our code to be bug-free, let alone the collections of
random, poorly tested backports) so that it only resulted in
corruption shutdowns rather than permanent on-disk damage and data
loss.

Put simply: the stable process is flawed because it shortcuts the
necessary stabilisation testing for new code. It doesn't matter if
the merged commits have a "fixes" tag in them, that tag doesn't mean
the change is ready to be exposed to production systems. We need the
*-rc stabilisation process* to weed out thinkos, brown paper bag
bugs, etc, because we all make mistakes, and bugs in filesystem code
can *lose user data permanently*.

Hence I ask that the stable maintainers only do automated pulls of
iomap and XFS changes from upstream kernels when Linus officially
releases them rather than at random points in time in the -rc cycle.
If there is a critical fix we need to go back to stable kernels
immediately, we will let stable@kernel.org know directly that we
want this done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
