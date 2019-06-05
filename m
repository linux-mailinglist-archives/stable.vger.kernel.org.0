Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D2B354F1
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 03:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFEBZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 21:25:59 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:34580 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFEBZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 21:25:59 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5D1B53DC6C3;
        Wed,  5 Jun 2019 11:25:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hYKgZ-0003fG-MR; Wed, 05 Jun 2019 11:25:51 +1000
Date:   Wed, 5 Jun 2019 11:25:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Fix stale data exposure when read races with
 hole punch
Message-ID: <20190605012551.GJ16786@dread.disaster.area>
References: <20190603132155.20600-1-jack@suse.cz>
 <20190603132155.20600-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603132155.20600-3-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=dBuVX4ejtxO155pZRcAA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 03:21:55PM +0200, Jan Kara wrote:
> Hole puching currently evicts pages from page cache and then goes on to
> remove blocks from the inode. This happens under both i_mmap_sem and
> i_rwsem held exclusively which provides appropriate serialization with
> racing page faults. However there is currently nothing that prevents
> ordinary read(2) from racing with the hole punch and instantiating page
> cache page after hole punching has evicted page cache but before it has
> removed blocks from the inode. This page cache page will be mapping soon
> to be freed block and that can lead to returning stale data to userspace
> or even filesystem corruption.
> 
> Fix the problem by protecting reads as well as readahead requests with
> i_mmap_sem.
> 
> CC: stable@vger.kernel.org
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2c5baa5e8291..a21fa9f8fb5d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -34,6 +34,17 @@
>  #include "xattr.h"
>  #include "acl.h"
>  
> +static ssize_t ext4_file_buffered_read(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	ssize_t ret;
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +
> +	down_read(&EXT4_I(inode)->i_mmap_sem);
> +	ret = generic_file_read_iter(iocb, to);
> +	up_read(&EXT4_I(inode)->i_mmap_sem);
> +	return ret;

Isn't i_mmap_sem taken in the page fault path? What makes it safe
to take here both outside and inside the mmap_sem at the same time?
I mean, the whole reason for i_mmap_sem existing is that the inode
i_rwsem can't be taken both outside and inside the i_mmap_sem at the
same time, so what makes the i_mmap_sem different?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
