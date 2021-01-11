Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DC52F189F
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbhAKOqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:46:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:58876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbhAKOqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 09:46:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99D83AB3E;
        Mon, 11 Jan 2021 14:46:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 509B81E0807; Mon, 11 Jan 2021 15:46:00 +0100 (CET)
Date:   Mon, 11 Jan 2021 15:46:00 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 01/12] fs: fix lazytime expiration handling in
 __writeback_single_inode()
Message-ID: <20210111144600.GC808@quack2.suse.cz>
References: <20210109075903.208222-1-ebiggers@kernel.org>
 <20210109075903.208222-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109075903.208222-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 08-01-21 23:58:52, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When lazytime is enabled and an inode is being written due to its
> in-memory updated timestamps having expired, either due to a sync() or
> syncfs() system call or due to dirtytime_expire_interval having elapsed,
> the VFS needs to inform the filesystem so that the filesystem can copy
> the inode's timestamps out to the on-disk data structures.
> 
> This is done by __writeback_single_inode() calling
> mark_inode_dirty_sync(), which then calls ->dirty_inode(I_DIRTY_SYNC).
> 
> However, this occurs after __writeback_single_inode() has already
> cleared the dirty flags from ->i_state.  This causes two bugs:
> 
> - mark_inode_dirty_sync() redirties the inode, causing it to remain
>   dirty.  This wastefully causes the inode to be written twice.  But
>   more importantly, it breaks cases where sync_filesystem() is expected
>   to clean dirty inodes.  This includes the FS_IOC_REMOVE_ENCRYPTION_KEY
>   ioctl (as reported at
>   https://lore.kernel.org/r/20200306004555.GB225345@gmail.com), as well
>   as possibly filesystem freezing (freeze_super()).
> 
> - Since ->i_state doesn't contain I_DIRTY_TIME when ->dirty_inode() is
>   called from __writeback_single_inode() for lazytime expiration,
>   xfs_fs_dirty_inode() ignores the notification.  (XFS only cares about
>   lazytime expirations, and it assumes that I_DIRTY_TIME will contain
>   i_state during those.)  Therefore, lazy timestamps aren't persisted by
>   sync(), syncfs(), or dirtytime_expire_interval on XFS.
> 
> Fix this by moving the call to mark_inode_dirty_sync() to earlier in
> __writeback_single_inode(), before the dirty flags are cleared from
> i_state.  This makes filesystems be properly notified of the timestamp
> expiration, and it avoids incorrectly redirtying the inode.
> 
> This fixes xfstest generic/580 (which tests
> FS_IOC_REMOVE_ENCRYPTION_KEY) when run on ext4 or f2fs with lazytime
> enabled.  It also fixes the new lazytime xfstest I've proposed, which
> reproduces the above-mentioned XFS bug
> (https://lore.kernel.org/r/20210105005818.92978-1-ebiggers@kernel.org).
> 
> Alternatively, we could call ->dirty_inode(I_DIRTY_SYNC) directly.  But
> due to the introduction of I_SYNC_QUEUED, mark_inode_dirty_sync() is the
> right thing to do because mark_inode_dirty_sync() now knows not to move
> the inode to a writeback list if it is currently queued for sync.
> 
> Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
> Cc: stable@vger.kernel.org
> Depends-on: 5afced3bf281 ("writeback: Avoid skipping inode writeback")
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for writing this fix! It looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index acfb55834af23..c41cb887eb7d3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1474,21 +1474,25 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	}
>  
>  	/*
> -	 * Some filesystems may redirty the inode during the writeback
> -	 * due to delalloc, clear dirty metadata flags right before
> -	 * write_inode()
> +	 * If the inode has dirty timestamps and we need to write them, call
> +	 * mark_inode_dirty_sync() to notify the filesystem about it and to
> +	 * change I_DIRTY_TIME into I_DIRTY_SYNC.
>  	 */
> -	spin_lock(&inode->i_lock);
> -
> -	dirty = inode->i_state & I_DIRTY;
>  	if ((inode->i_state & I_DIRTY_TIME) &&
> -	    ((dirty & I_DIRTY_INODE) ||
> -	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
> +	    (wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
>  	     time_after(jiffies, inode->dirtied_time_when +
>  			dirtytime_expire_interval * HZ))) {
> -		dirty |= I_DIRTY_TIME;
>  		trace_writeback_lazytime(inode);
> +		mark_inode_dirty_sync(inode);
>  	}
> +
> +	/*
> +	 * Some filesystems may redirty the inode during the writeback
> +	 * due to delalloc, clear dirty metadata flags right before
> +	 * write_inode()
> +	 */
> +	spin_lock(&inode->i_lock);
> +	dirty = inode->i_state & I_DIRTY;
>  	inode->i_state &= ~dirty;
>  
>  	/*
> @@ -1509,8 +1513,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  	spin_unlock(&inode->i_lock);
>  
> -	if (dirty & I_DIRTY_TIME)
> -		mark_inode_dirty_sync(inode);
>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
>  	if (dirty & ~I_DIRTY_PAGES) {
>  		int err = write_inode(inode, wbc);
> -- 
> 2.30.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
