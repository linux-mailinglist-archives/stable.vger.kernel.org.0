Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6602ED2FE
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhAGOrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:47:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:47166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbhAGOrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:47:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2B85BAE47;
        Thu,  7 Jan 2021 14:47:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D16991E0872; Thu,  7 Jan 2021 15:47:09 +0100 (CET)
Date:   Thu, 7 Jan 2021 15:47:09 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <20210107144709.GG12990@quack2.suse.cz>
References: <20210105005452.92521-1-ebiggers@kernel.org>
 <20210105005452.92521-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20210105005452.92521-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 04-01-21 16:54:40, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When lazytime is enabled and an inode with dirty timestamps is being
> expired, either due to dirtytime_expire_interval being exceeded or due
> to a sync or syncfs system call, we need to inform the filesystem that
> the inode is dirty so that the inode's timestamps can be copied out to
> the on-disk data structures.  That's because if the filesystem supports
> lazytime, it will have ignored the ->dirty_inode(inode, I_DIRTY_TIME)
> notification when the timestamp was modified in memory.
> 
> Currently this is accomplished by calling mark_inode_dirty_sync() from
> __writeback_single_inode().  However, this has the unfortunate side
> effect of also putting the inode the writeback list.  That's not
> appropriate in this case, since the inode is already being written.
> 
> That causes the inode to remain dirty after a sync.  Normally that's
> just wasteful, as it causes the inode to be written twice.  But when
> fscrypt is used this bug also partially breaks the
> FS_IOC_REMOVE_ENCRYPTION_KEY ioctl, as the ioctl reports that files are
> still in-use when they aren't.  For more details, see the original
> report at https://lore.kernel.org/r/20200306004555.GB225345@gmail.com
> 
> Fix this by calling ->dirty_inode(inode, I_DIRTY_SYNC) directly instead
> of mark_inode_dirty_sync().
> 
> This fixes xfstest generic/580 when lazytime is enabled.
> 
> A later patch will introduce a ->lazytime_expired method to cleanly
> separate out the lazytime expiration case, in particular for XFS which
> uses the VFS-level dirtiness tracking only for lazytime.  But that's
> separate from fixing this bug.  Also, note that XFS will incorrectly
> ignore the I_DIRTY_SYNC notification from __writeback_single_inode()
> both before and after this patch, as I_DIRTY_TIME was already cleared in
> i_state.  Later patches will fix this separate bug.
> 
> Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Good catch! It could also cause issues with filesystem freezing which kind
of assumes that the filesystem will be clean after sync_filesystem()
(otherwise writeback threads can get stalled on frozen filesystem while
holding some locks and generally the system behavior becomes kind of
awkward).

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index acfb55834af23..081e335cdee47 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1509,11 +1509,22 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  	spin_unlock(&inode->i_lock);
>  
> -	if (dirty & I_DIRTY_TIME)
> -		mark_inode_dirty_sync(inode);
>  	/* Don't write the inode if only I_DIRTY_PAGES was set */
>  	if (dirty & ~I_DIRTY_PAGES) {
> -		int err = write_inode(inode, wbc);
> +		int err;
> +
> +		/*
> +		 * If the inode is being written due to a lazytime timestamp
> +		 * expiration, then the filesystem needs to be notified about it
> +		 * so that e.g. the filesystem can update on-disk fields and
> +		 * journal the timestamp update.  Just calling write_inode()
> +		 * isn't enough.  Don't call mark_inode_dirty_sync(), as that
> +		 * would put the inode back on the dirty list.
> +		 */
> +		if ((dirty & I_DIRTY_TIME) && inode->i_sb->s_op->dirty_inode)
> +			inode->i_sb->s_op->dirty_inode(inode, I_DIRTY_SYNC);
> +
> +		err = write_inode(inode, wbc);
>  		if (ret == 0)
>  			ret = err;
>  	}

I have to say I dislike this special call of ->dirty_inode(). It works but
it makes me wonder, didn't we forget about something or won't we forget in
the future? Because it's very easy to miss this special case...

I think attached patch (compile-tested only) should actually fix the
problem as well without this special ->dirty_inode() call. It basically
only moves the mark_inode_dirty_sync() before inode->i_state clearing.
Because conceptually mark_inode_dirty_sync() is IMO the right function to
call. It will take care of clearing I_DIRTY_TIME flag (because we are
setting I_DIRTY_SYNC), it will also not touch inode->i_io_list if the inode
is queued for sync (I_SYNC_QUEUED is set in that case). The only problem
with calling it was that it was called *after* clearing dirty bits from
i_state... What do you think?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--YZ5djTAD1cGYuMQK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-Make-sure-inode-is-clean-after-__writeback_single.patch"

From 80ccc6a78d1c0532f600b98884f7a64e58333485 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 7 Jan 2021 15:36:05 +0100
Subject: [PATCH] fs: Make sure inode is clean after __writeback_single_inode()

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index acfb55834af2..b9356f470fae 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1473,22 +1473,25 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 			ret = err;
 	}
 
+	/*
+	 * If inode has dirty timestamps and we need to write them, call
+	 * mark_inode_dirty_sync() to notify filesystem about it.
+	 */
+	if (inode->i_state & I_DIRTY_TIME &&
+	    (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL ||
+	     time_after(jiffies, inode->dirtied_time_when +
+			dirtytime_expire_interval * HZ))) {
+		trace_writeback_lazytime(inode);
+		mark_inode_dirty_sync(inode);
+	}
+
 	/*
 	 * Some filesystems may redirty the inode during the writeback
 	 * due to delalloc, clear dirty metadata flags right before
 	 * write_inode()
 	 */
 	spin_lock(&inode->i_lock);
-
 	dirty = inode->i_state & I_DIRTY;
-	if ((inode->i_state & I_DIRTY_TIME) &&
-	    ((dirty & I_DIRTY_INODE) ||
-	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
-	     time_after(jiffies, inode->dirtied_time_when +
-			dirtytime_expire_interval * HZ))) {
-		dirty |= I_DIRTY_TIME;
-		trace_writeback_lazytime(inode);
-	}
 	inode->i_state &= ~dirty;
 
 	/*
@@ -1509,8 +1512,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	spin_unlock(&inode->i_lock);
 
-	if (dirty & I_DIRTY_TIME)
-		mark_inode_dirty_sync(inode);
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & ~I_DIRTY_PAGES) {
 		int err = write_inode(inode, wbc);
-- 
2.26.2


--YZ5djTAD1cGYuMQK--
