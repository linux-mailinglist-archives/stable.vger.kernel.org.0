Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3E106BCF
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfKVKr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:37254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729131AbfKVKr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00DA1AE00;
        Fri, 22 Nov 2019 10:47:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7AC9C1E484C; Fri, 22 Nov 2019 11:47:24 +0100 (CET)
Date:   Fri, 22 Nov 2019 11:47:24 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Fix pipe page leakage during splicing
Message-ID: <20191122104724.GA26721@quack2.suse.cz>
References: <20191121161144.30802-1-jack@suse.cz>
 <20191121161538.18445-1-jack@suse.cz>
 <20191121235528.GO6211@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121235528.GO6211@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 21-11-19 15:55:28, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 05:15:34PM +0100, Jan Kara wrote:
> > When splicing using iomap_dio_rw() to a pipe, we may leak pipe pages
> > because bio_iov_iter_get_pages() records that the pipe will have full
> > extent worth of data however if file size is not block size aligned
> > iomap_dio_rw() returns less than what bio_iov_iter_get_pages() set up
> > and splice code gets confused leaking a pipe page with the file tail.
> > 
> > Handle the situation similarly to the old direct IO implementation and
> > revert iter to actually returned read amount which makes iter consistent
> > with value returned from iomap_dio_rw() and thus the splice code is
> > happy.
> > 
> > Fixes: ff6a9292e6f6 ("iomap: implement direct I/O")
> > CC: stable@vger.kernel.org
> > Reported-by: syzbot+991400e8eba7e00a26e1@syzkaller.appspotmail.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/iomap/direct-io.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > index 1fc28c2da279..30189652c560 100644
> > --- a/fs/iomap/direct-io.c
> > +++ b/fs/iomap/direct-io.c
> > @@ -497,8 +497,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  		}
> >  		pos += ret;
> >  
> > -		if (iov_iter_rw(iter) == READ && pos >= dio->i_size)
> > +		if (iov_iter_rw(iter) == READ && pos >= dio->i_size) {
> > +			/*
> > +			 * We will report we've read data only upto i_size.
> 
> Nit: "up to"; will fix that on the way in.
> 
> > +			 * Revert iter to a state corresponding to that as
> > +			 * some callers (such as splice code) rely on it.
> > +			 */
> > +			iov_iter_revert(iter, pos - dio->i_size);
> 
> Just to make sure I'm getting this right, iov_iter_revert walks the
> iterator variables backwards through pipe buffers/bvec/iovec, which has
> the effect of undoing whatever iterator walking we've just done.
> 
> In contrast, iov_iter_reexpand undoes a previous subtraction to
> iov->count which was (presumably) done via iov_iter_truncate.
> 
> Or to put it another way, _revert walks the iteration pointer backwards,
> whereas _truncate/_reexpand modify where the iteration ends.  Right?

Correct.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
