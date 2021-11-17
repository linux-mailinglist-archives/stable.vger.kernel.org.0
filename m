Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399BA45403A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 06:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhKQFg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 00:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhKQFg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 00:36:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D4061BD4;
        Wed, 17 Nov 2021 05:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637127211;
        bh=wq7GOaak/lbqlssTRGsXmFwEGcAmFwkbDKi1AfoREN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKwdrNIkbJPBCkAFj+XkuiF1sLzUkoeQ/GsuG/JMNRpZf82KvScwqEY8igA3WDJxx
         ws5z2EEkBgHSyAGCm3eT2n7VXiw7h4DX2dSPrUKmXYhlmr5xw42nmbVZlE1zRYmeHV
         0GEQnHLYTJp7P+D1tW1TQRUfsJnuBI79tq6sjzpjymKOZ3OrxzrIdOf/NerplpPC33
         fbbZKzuxRIkoGjUeHkzNV4rNfcwlrM6KurJm7yJdTaLS5CwUa/JyjpvpoRZhsao+oK
         Fm28ArrV1stiqbXq437thBMhEnck+CowHzjFrmMB6I9rxtp14XBwvu0LfoMmbnFmPX
         3klK6fy/EzFbA==
Date:   Tue, 16 Nov 2021 21:33:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [5.15 REGRESSION v2] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <20211117053330.GU24307@magnolia>
References: <20211111161714.584718-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111161714.584718-1-agruenba@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 05:17:14PM +0100, Andreas Gruenbacher wrote:
> Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
> value for inline data"), when hitting an IOMAP_INLINE extent,
> iomap_readpage_actor would report having read the entire page.  Since
> then, it only reports having read the inline data (iomap->length).
> 
> This will force iomap_readpage into another iteration, and the
> filesystem will report an unaligned hole after the IOMAP_INLINE extent.
> But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
> deal with unaligned extents, it will get things wrong on filesystems
> with a block size smaller than the page size, and we'll eventually run
> into the following warning in iomap_iter_advance:
> 
>   WARN_ON_ONCE(iter->processed > iomap_length(iter));
> 
> Fix that by changing iomap_readpage_iter to return 0 when hitting an
> inline extent; this will cause iomap_iter to stop immediately.

I guess this means that we also only support having inline data that
ends at EOF?  IIRC this is true for the three(?) filesystems that have
expressed any interest in inline data: yours, ext4, and erofs?

> To fix readahead as well, change iomap_readahead_iter to pass on
> iomap_readpage_iter return values less than or equal to zero.
> 
> Fixes: 740499c78408 ("iomap: fix the iomap_readpage_actor return value for inline data")
> Cc: stable@vger.kernel.org # v5.15+
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 1753c26c8e76..fe10d8a30f6b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -256,8 +256,13 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  	unsigned poff, plen;
>  	sector_t sector;
>  
> -	if (iomap->type == IOMAP_INLINE)
> -		return min(iomap_read_inline_data(iter, page), length);
> +	if (iomap->type == IOMAP_INLINE) {
> +		loff_t ret = iomap_read_inline_data(iter, page);

Ew, iomap_read_inline_data returns loff_t.  I think I'll slip in a
change of return type to ssize_t, if you don't mind?

> +
> +		if (ret < 0)
> +			return ret;

...and a comment here explaining that we only support inline data that
ends at EOF?

If the answers to all /four/ questions are 'yes', then consider this:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		return 0;
> +	}
>  
>  	/* zero post-eof blocks as the page may be mapped */
>  	iop = iomap_page_create(iter->inode, page);
> @@ -370,6 +375,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
>  			ctx->cur_page_in_bio = false;
>  		}
>  		ret = iomap_readpage_iter(iter, ctx, done);
> +		if (ret <= 0)
> +			return ret;
>  	}
>  
>  	return done;
> -- 
> 2.31.1
> 
