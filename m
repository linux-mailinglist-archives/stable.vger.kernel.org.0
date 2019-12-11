Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED111C0CD
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLKXuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:50:44 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:40476 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLKXuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:50:44 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBBNoRkW006249; Thu, 12 Dec 2019 08:50:28 +0900
X-Iguazu-Qid: 34tMQJyII3CBYi1sWp
X-Iguazu-QSIG: v=2; s=0; t=1576108227; q=34tMQJyII3CBYi1sWp; m=4p+g4j2xam2YUSHpoqyygsho0cdntaFG34MarWhkTHM=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1511) id xBBNoQKg013514;
        Thu, 12 Dec 2019 08:50:26 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBBNoQuh010066;
        Thu, 12 Dec 2019 08:50:26 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBBNoQcE005547;
        Thu, 12 Dec 2019 08:50:26 +0900
Date:   Thu, 12 Dec 2019 08:50:25 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 077/243] iomap: dio data corruption and spurious
 errors when pipes fill
X-TSB-HOP: ON
Message-ID: <20191211235025.xukuecbyuub6hakt@toshiba.co.jp>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150344.304750036@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150344.304750036@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:03:59PM +0100, Greg Kroah-Hartman wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit 4721a6010990971440b4ffefbdf014976b8eda2f ]
> 
> When doing direct IO to a pipe for do_splice_direct(), then pipe is
> trivial to fill up and overflow as it can only hold 16 pages. At
> this point bio_iov_iter_get_pages() then returns -EFAULT, and we
> abort the IO submission process. Unfortunately, iomap_dio_rw()
> propagates the error back up the stack.
> 
> The error is converted from the EFAULT to EAGAIN in
> generic_file_splice_read() to tell the splice layers that the pipe
> is full. do_splice_direct() completely fails to handle EAGAIN errors
> (it aborts on error) and returns EAGAIN to the caller.
> 
> copy_file_write() then completely fails to handle EAGAIN as well,
> and so returns EAGAIN to userspace, having failed to copy the data
> it was asked to.
> 
> Avoid this whole steaming pile of fail by having iomap_dio_rw()
> silently swallow EFAULT errors and so do short reads.
> 
> To make matters worse, iomap_dio_actor() has a stale data exposure
> bug bio_iov_iter_get_pages() fails - it does not zero the tail block
> that it may have been left uncovered by partial IO. Fix the error
> handling case to drop to the sub-block zeroing rather than
> immmediately returning the -EFAULT error.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>



This commit also seems to require the following 2 commits:

commit 8f67b5adc030553fbc877124306f3f3bdab89aa8
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Sun Dec 2 08:38:07 2018 -0800

    iomap: partially revert 4721a601099 (simulated directio short read on EFAULT)

    In commit 4721a601099, we tried to fix a problem wherein directio reads
    into a splice pipe will bounce EFAULT/EAGAIN all the way out to
    userspace by simulating a zero-byte short read.  This happens because
    some directio read implementations (xfs) will call
    bio_iov_iter_get_pages to grab pipe buffer pages and issue asynchronous
    reads, but as soon as we run out of pipe buffers that _get_pages call
    returns EFAULT, which the splice code translates to EAGAIN and bounces
    out to userspace.

    In that commit, the iomap code catches the EFAULT and simulates a
    zero-byte read, but that causes assertion errors on regular splice reads
    because xfs doesn't allow short directio reads.  This causes infinite
    splice() loops and assertion failures on generic/095 on overlayfs
    because xfs only permit total success or total failure of a directio
    operation.  The underlying issue in the pipe splice code has now been
    fixed by changing the pipe splice loop to avoid avoid reading more data
    than there is space in the pipe.

    Therefore, it's no longer necessary to simulate the short directio, so
    remove the hack from iomap.

    Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
    Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
    Ranted-by: Amir Goldstein <amir73il@gmail.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
i
commit 17614445576b6af24e9cf36607c6448164719c96
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Fri Nov 30 10:37:49 2018 -0800

    splice: don't read more than available pipe space

    In commit 4721a601099, we tried to fix a problem wherein directio reads
    into a splice pipe will bounce EFAULT/EAGAIN all the way out to
    userspace by simulating a zero-byte short read.  This happens because
    some directio read implementations (xfs) will call
    bio_iov_iter_get_pages to grab pipe buffer pages and issue asynchronous
    reads, but as soon as we run out of pipe buffers that _get_pages call
    returns EFAULT, which the splice code translates to EAGAIN and bounces
    out to userspace.

    In that commit, the iomap code catches the EFAULT and simulates a
    zero-byte read, but that causes assertion errors on regular splice reads
    because xfs doesn't allow short directio reads.

    The brokenness is compounded by splice_direct_to_actor immediately
    bailing on do_splice_to returning <= 0 without ever calling ->actor
    (which empties out the pipe), so if userspace calls back we'll EFAULT
    again on the full pipe, and nothing ever gets copied.

    Therefore, teach splice_direct_to_actor to clamp its requests to the
    amount of free space in the pipe and remove the simulated short read
    from the iomap directio code.

    Fixes: 4721a601099 ("iomap: dio data corruption and spurious errors when pipes fill")
    Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
    Ranted-by: Amir Goldstein <amir73il@gmail.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Pleaase apply these commits.

Best regards.
  Nobuhiro
