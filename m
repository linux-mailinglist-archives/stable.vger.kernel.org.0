Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0C2EE7D0
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbhAGVrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 16:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAGVrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 16:47:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141AF23600;
        Thu,  7 Jan 2021 21:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610055999;
        bh=WqYF7Pa6ZpVpCcZ2vNf1J8/EbxAxiMgwAPAYvp5dLDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lk57fWw0z79gwMhVOUES/eP86vzr3eoEI13JEHAquGPwFwas2W3siRt/t7UyvBoKk
         0tZgiXCWpFwJhLr8shFHtvIqoKowelEXDPU6e0dZ6R1u6ARcYKOd9SNWV9g3kC5htf
         kyd9Hg9s3MnfzNZLAPo/fjFL1flAqcHiWzExB12FMq2kEedFYf8VvL20nn1L41t2fi
         pHB2i4b1dJjDkZi0tEzeZKHGdToii/3IgBBrQDDmNIiKyk9yQFabb9H0Q/rRBcRv5O
         UlxdU6I6DRf3tz3BpUzWboGLL0apdDkKuPASRbGjC7Aiv4eZLnpw459FLvyces5yDO
         cQ0QFegKNrszQ==
Date:   Thu, 7 Jan 2021 13:46:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <X/eBPZ+kLGuz2NDC@gmail.com>
References: <20210105005452.92521-1-ebiggers@kernel.org>
 <20210105005452.92521-2-ebiggers@kernel.org>
 <20210107144709.GG12990@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107144709.GG12990@quack2.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:47:09PM +0100, Jan Kara wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index acfb55834af23..081e335cdee47 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -1509,11 +1509,22 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> >  
> >  	spin_unlock(&inode->i_lock);
> >  
> > -	if (dirty & I_DIRTY_TIME)
> > -		mark_inode_dirty_sync(inode);
> >  	/* Don't write the inode if only I_DIRTY_PAGES was set */
> >  	if (dirty & ~I_DIRTY_PAGES) {
> > -		int err = write_inode(inode, wbc);
> > +		int err;
> > +
> > +		/*
> > +		 * If the inode is being written due to a lazytime timestamp
> > +		 * expiration, then the filesystem needs to be notified about it
> > +		 * so that e.g. the filesystem can update on-disk fields and
> > +		 * journal the timestamp update.  Just calling write_inode()
> > +		 * isn't enough.  Don't call mark_inode_dirty_sync(), as that
> > +		 * would put the inode back on the dirty list.
> > +		 */
> > +		if ((dirty & I_DIRTY_TIME) && inode->i_sb->s_op->dirty_inode)
> > +			inode->i_sb->s_op->dirty_inode(inode, I_DIRTY_SYNC);
> > +
> > +		err = write_inode(inode, wbc);
> >  		if (ret == 0)
> >  			ret = err;
> >  	}
> 
> I have to say I dislike this special call of ->dirty_inode(). It works but
> it makes me wonder, didn't we forget about something or won't we forget in
> the future? Because it's very easy to miss this special case...
> 
> I think attached patch (compile-tested only) should actually fix the
> problem as well without this special ->dirty_inode() call. It basically
> only moves the mark_inode_dirty_sync() before inode->i_state clearing.
> Because conceptually mark_inode_dirty_sync() is IMO the right function to
> call. It will take care of clearing I_DIRTY_TIME flag (because we are
> setting I_DIRTY_SYNC), it will also not touch inode->i_io_list if the inode
> is queued for sync (I_SYNC_QUEUED is set in that case). The only problem
> with calling it was that it was called *after* clearing dirty bits from
> i_state... What do you think?
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From 80ccc6a78d1c0532f600b98884f7a64e58333485 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 7 Jan 2021 15:36:05 +0100
> Subject: [PATCH] fs: Make sure inode is clean after __writeback_single_inode()
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fs-writeback.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index acfb55834af2..b9356f470fae 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1473,22 +1473,25 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  			ret = err;
>  	}
>  
> +	/*
> +	 * If inode has dirty timestamps and we need to write them, call
> +	 * mark_inode_dirty_sync() to notify filesystem about it.
> +	 */
> +	if (inode->i_state & I_DIRTY_TIME &&
> +	    (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL ||
> +	     time_after(jiffies, inode->dirtied_time_when +
> +			dirtytime_expire_interval * HZ))) {
> +		trace_writeback_lazytime(inode);
> +		mark_inode_dirty_sync(inode);
> +	}
> +
>  	/*
>  	 * Some filesystems may redirty the inode during the writeback
>  	 * due to delalloc, clear dirty metadata flags right before
>  	 * write_inode()
>  	 */
>  	spin_lock(&inode->i_lock);
> -
>  	dirty = inode->i_state & I_DIRTY;
> -	if ((inode->i_state & I_DIRTY_TIME) &&
> -	    ((dirty & I_DIRTY_INODE) ||
> -	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
> -	     time_after(jiffies, inode->dirtied_time_when +
> -			dirtytime_expire_interval * HZ))) {
> -		dirty |= I_DIRTY_TIME;
> -		trace_writeback_lazytime(inode);
> -	}
>  	inode->i_state &= ~dirty;
>  
>  	/*
> @@ -1509,8 +1512,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  	spin_unlock(&inode->i_lock);
>  
> -	if (dirty & I_DIRTY_TIME)
> -		mark_inode_dirty_sync(inode);
>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
>  	if (dirty & ~I_DIRTY_PAGES) {
>  		int err = write_inode(inode, wbc);

It looks like that's going to work, and it fixes the XFS bug too.

Note that if __writeback_single_inode() is called from writeback_single_inode()
(rather than writeback_sb_inodes()), then the inode might not be queued for
sync, in which case mark_inode_dirty_sync() will move it to a writeback list.

That's okay because afterwards, writeback_single_inode() will delete the inode
from any writeback list if it's been fully cleaned, right?  So clean inodes
won't get left on a writeback list.

It's confusing because there are comments in writeback_single_inode() and above
__writeback_single_inode() that say that the inode must not be moved between
writeback lists.  I take it that those comments are outdated, as they predate
I_SYNC_QUEUED being introduced by commit 5afced3bf281 ("writeback: Avoid
skipping inode writeback")?

- Eric
