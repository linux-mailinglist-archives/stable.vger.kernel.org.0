Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40874359A2
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfFEJ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:27:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:33230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726862AbfFEJ1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 05:27:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19441AEA3;
        Wed,  5 Jun 2019 09:27:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 556701E3C2F; Wed,  5 Jun 2019 11:27:28 +0200 (CEST)
Date:   Wed, 5 Jun 2019 11:27:28 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Ted Tso <tytso@mit.edu>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Fix stale data exposure when read races with
 hole punch
Message-ID: <20190605092728.GB7433@quack2.suse.cz>
References: <20190603132155.20600-1-jack@suse.cz>
 <20190603132155.20600-3-jack@suse.cz>
 <20190605012551.GJ16786@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605012551.GJ16786@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 05-06-19 11:25:51, Dave Chinner wrote:
> On Mon, Jun 03, 2019 at 03:21:55PM +0200, Jan Kara wrote:
> > Hole puching currently evicts pages from page cache and then goes on to
> > remove blocks from the inode. This happens under both i_mmap_sem and
> > i_rwsem held exclusively which provides appropriate serialization with
> > racing page faults. However there is currently nothing that prevents
> > ordinary read(2) from racing with the hole punch and instantiating page
> > cache page after hole punching has evicted page cache but before it has
> > removed blocks from the inode. This page cache page will be mapping soon
> > to be freed block and that can lead to returning stale data to userspace
> > or even filesystem corruption.
> > 
> > Fix the problem by protecting reads as well as readahead requests with
> > i_mmap_sem.
> > 
> > CC: stable@vger.kernel.org
> > Reported-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/file.c | 35 +++++++++++++++++++++++++++++++----
> >  1 file changed, 31 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 2c5baa5e8291..a21fa9f8fb5d 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -34,6 +34,17 @@
> >  #include "xattr.h"
> >  #include "acl.h"
> >  
> > +static ssize_t ext4_file_buffered_read(struct kiocb *iocb, struct iov_iter *to)
> > +{
> > +	ssize_t ret;
> > +	struct inode *inode = file_inode(iocb->ki_filp);
> > +
> > +	down_read(&EXT4_I(inode)->i_mmap_sem);
> > +	ret = generic_file_read_iter(iocb, to);
> > +	up_read(&EXT4_I(inode)->i_mmap_sem);
> > +	return ret;
> 
> Isn't i_mmap_sem taken in the page fault path? What makes it safe
> to take here both outside and inside the mmap_sem at the same time?
> I mean, the whole reason for i_mmap_sem existing is that the inode
> i_rwsem can't be taken both outside and inside the i_mmap_sem at the
> same time, so what makes the i_mmap_sem different?

Drat, you're right that read path may take page fault which will cause lock
inversion with mmap_sem. Just my xfstests run apparently didn't trigger
this as I didn't get any lockdep splat. Thanks for catching this!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
