Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2466E36001B
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 04:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhDOCrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 22:47:52 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38463 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhDOCrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 22:47:51 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9234282FB37;
        Thu, 15 Apr 2021 12:47:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWs2O-008X2l-84; Thu, 15 Apr 2021 12:47:24 +1000
Date:   Thu, 15 Apr 2021 12:47:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix occasional generic/418 failure
Message-ID: <20210415024724.GV1990290@dread.disaster.area>
References: <20210414131453.4945-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414131453.4945-1-jack@suse.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=gV7zzQzcnHcuDfqADMcA:9 a=CjuIK1q_8ugA:10
        a=HUqATDVKn4QA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 14, 2021 at 03:14:53PM +0200, Jan Kara wrote:
> Eric has noticed that after pagecache read rework, generic/418 is
> occasionally failing for ext4 when blocksize < pagesize. In fact, the
> pagecache rework just made hard to hit race in ext4 more likely. The
> problem is that since ext4 conversion of direct IO writes to iomap
> framework (commit 378f32bab371), we update inode size after direct IO
> write only after invalidating page cache. Thus if buffered read sneaks
> at unfortunate moment like:
> 
> CPU1 - write at offset 1k                       CPU2 - read from offset 0
> iomap_dio_rw(..., IOMAP_DIO_FORCE_WAIT);
>                                                 ext4_readpage();
> ext4_handle_inode_extension()
> 
> the read will zero out tail of the page as it still sees smaller inode
> size and thus page cache becomes inconsistent with on-disk contents with
> all the consequences.
> 
> Fix the problem by moving inode size update into end_io handler which
> gets called before the page cache is invalidated.
> 
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> Eric, can you please try whether this patch fixes the failures you are
> occasionally seeing?
> 
> Changes since v1:
> * Rewritten the fix to avoid the need for separate transaction handle for
>   orphan list update
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 194f5d00fa32..be1e80af61be 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -371,15 +371,27 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
>  static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  				 int error, unsigned int flags)
>  {
> -	loff_t offset = iocb->ki_pos;
> +	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  
>  	if (error)
>  		return error;
>  
> -	if (size && flags & IOMAP_DIO_UNWRITTEN)
> -		return ext4_convert_unwritten_extents(NULL, inode,
> -						      offset, size);
> +	if (size && flags & IOMAP_DIO_UNWRITTEN) {
> +		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
> +		if (error < 0)
> +			return error;
> +	}
> +	/*
> +	 * If we are extending the file, we have to update i_size here before
> +	 * page cache gets invalidated in iomap_dio_rw(). Otherwise racing
> +	 * buffered reads could zero out too much from page cache pages. Update
> +	 * of on-disk size will happen later in ext4_dio_write_iter() where
> +	 * we have enough information to also perform orphan list handling etc.
> +	 */
> +	pos += size;
> +	if (pos > i_size_read(inode))
> +		i_size_write(inode, pos);

Might be worth explaining why this doesn't require locking to
prevent racing completions from updating the inode size and
potentially losing an EOF update. I know why but it might not be so
obvious to others (DIO extending writes are serialised
at submission in ext4) but it's probably worth having a comment
similar to the one in xfs_dio_write_end_io() that explains why XFS
needs locking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
