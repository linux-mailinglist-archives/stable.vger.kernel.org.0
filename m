Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA5361538
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhDOWTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:19:42 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46095 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237368AbhDOWTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:19:05 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 18:19:05 EDT
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 376301AEBCB;
        Fri, 16 Apr 2021 08:01:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lXA37-009m6A-H1; Fri, 16 Apr 2021 08:01:21 +1000
Date:   Fri, 16 Apr 2021 08:01:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: Fix occasional generic/418 failure
Message-ID: <20210415220121.GX1990290@dread.disaster.area>
References: <20210415155417.4734-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415155417.4734-1-jack@suse.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=BVGimuPS_KFzXVpvEk4A:9
        a=CjuIK1q_8ugA:10 a=HUqATDVKn4QA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 05:54:17PM +0200, Jan Kara wrote:
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
> Reported-and-tested-by: Eric Whitney <enwlinux@gmail.com>
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 194f5d00fa32..7924634ab0bf 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -371,15 +371,32 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
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
> +	 * Note that we perform all extending writes synchronously under
> +	 * i_rwsem held exclusively so i_size update is safe here in that case.
> +	 * If the write was not extending, we cannot see pos > i_size here
> +	 * because operations reducing i_size like truncate wait for all
> +	 * outstanding DIO before updating i_size.
> +	 */
> +	pos += size;
> +	if (pos > i_size_read(inode))
> +		i_size_write(inode, pos);
>  
>  	return 0;
>  }

Thanks for updating the comment, Jan!

Acked-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
