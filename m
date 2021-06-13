Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238AB3A582A
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFMMEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231658AbhFMMEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 08:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE4D61009;
        Sun, 13 Jun 2021 12:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623585733;
        bh=4PrBlmYIhsRCtz/l0P/oxDR+cUESCBd4bkJZgMfr7Ow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OkXmljz+d3SOym1hiNooYplEE1VKPiSEFJBZ1/HhvXxOsJ4G6ODXt7H1fH9uBKkNJ
         LbKuVFriBowehGH3FbsBriS+LTp/Cqr5dT+T+wbzQeM4wHLj1WEoqyneuinBGX20IE
         3ELwzuMOGy+MZyAfhmllhj0KtFu8ph6f5jKUALQBiKZLXhHQ2SdKl2E1BVPYaFM4lo
         ryzRF8KPoCab7omMJAbpUmF3vIwhPotHW5n41YK83JLYB4aE+0aQeJbX2OmaDmK4hw
         6J+tW7ff/9l1hYmrOjdIFwAgIG+/+9bIml3/sxTlVg2xFi1OoDwFNQ/R68Q+noWWVp
         WEq75zWf+RSGQ==
Message-ID: <a58a297994700b95c85c15bc13e830ecb7ac61e7.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: fix write_begin optimization when write is
 beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, idryomov@gmail.com, stable@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Date:   Sun, 13 Jun 2021 08:02:12 -0400
In-Reply-To: <20210613113650.8672-1-jlayton@kernel.org>
References: <YMXmRo17oy8fDn2b@casper.infradead.org>
         <20210613113650.8672-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-06-13 at 07:36 -0400, Jeff Layton wrote:
> It's not sufficient to skip reading when the pos is beyond the EOF.
> There may be data at the head of the page that we need to fill in
> before the write.
> 
> Add a new helper function that corrects and clarifies the logic.
> 
> Cc: <stable@vger.kernel.org> # v5.10+
> Cc: Matthew Wilcox <willy@infradead.org>
> Fixes: 1cc1699070bd ("ceph: fold ceph_update_writeable_page into ceph_write_begin")
> Reported-by: Andrew W Elble <aweits@rit.edu>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 63 +++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 50 insertions(+), 13 deletions(-)
> 
> This version just has a couple of future-proofing tweaks that Willy
> suggested.
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 26e66436f005..b20a17cfec42 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1302,6 +1302,54 @@ ceph_find_incompatible(struct page *page)
>  	return NULL;
>  }
>  
> +/**
> + * prep_noread_page - prep a page for writing without reading first
> + * @page: page being prepared
> + * @pos: starting position for the write
> + * @len: length of write
> + *
> + * In some cases we don't need to read at all:
> + * - full page write
> + * - file is currently zero-length
> + * - write that lies in a page that is completely beyond EOF
> + * - write that covers the the page from start to EOF or beyond it
> + *
> + * If any of these criteria are met, then zero out the unwritten parts
> + * of the page and return true. Otherwise, return false.
> + */
> +static bool prep_noread_page(struct page *page, loff_t pos, size_t len)
> +{
> +	struct inode *inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	pgoff_t index = pos / PAGE_SIZE;
> +	size_t offset = offset_in_page(pos);
> +
> +	/* clamp length to end of the current page */
> +	if (len > PAGE_SIZE)
> +		len = PAGE_SIZE - offset;

Actually, I think this should be:

	len = min(len, PAGE_SIZE - offset);

Otherwise, len could still go beyond the end of the page.

> +
> +	/* full page write */
> +	if (offset == 0 && len == PAGE_SIZE)
> +		goto zero_out;
> +
> +	/* zero-length file */
> +	if (i_size == 0)
> +		goto zero_out;
> +
> +	/* position beyond last page in the file */
> +	if (index > ((i_size - 1) / PAGE_SIZE))
> +		goto zero_out;
> +
> +	/* write that covers the the page from start to EOF or beyond it */
> +	if (offset == 0 && (pos + len) >= i_size)
> +		goto zero_out;
> +
> +	return false;
> +zero_out:
> +	zero_user_segments(page, 0, offset, offset + len, PAGE_SIZE);
> +	return true;
> +}
> +
>  /*
>   * We are only allowed to write into/dirty the page if the page is
>   * clean, or already dirty within the same snap context.
> @@ -1315,7 +1363,6 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
>  	struct ceph_snap_context *snapc;
>  	struct page *page = NULL;
>  	pgoff_t index = pos >> PAGE_SHIFT;
> -	int pos_in_page = pos & ~PAGE_MASK;
>  	int r = 0;
>  
>  	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
> @@ -1350,19 +1397,9 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
>  			break;
>  		}
>  
> -		/*
> -		 * In some cases we don't need to read at all:
> -		 * - full page write
> -		 * - write that lies completely beyond EOF
> -		 * - write that covers the the page from start to EOF or beyond it
> -		 */
> -		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> -		    (pos >= i_size_read(inode)) ||
> -		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
> -			zero_user_segments(page, 0, pos_in_page,
> -					   pos_in_page + len, PAGE_SIZE);
> +		/* No need to read in some cases */
> +		if (prep_noread_page(page, pos, len))
>  			break;
> -		}
>  
>  		/*
>  		 * We need to read it. If we get back -EINPROGRESS, then the page was

-- 
Jeff Layton <jlayton@kernel.org>

