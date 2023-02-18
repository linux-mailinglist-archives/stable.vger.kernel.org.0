Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D38069BAD3
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBRQAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 11:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRQAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 11:00:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9817CC8
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 08:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YDVpwNxpWuolaa00uIGnhOy1VZXxupzYn75pxder2LA=; b=HDkhFHZ2Zxsey6d/OCYYhwxQ9Z
        PLwx6X2hOX1a5xlUcdGMK0IYd8YTIRNWFSORcuzPMbg8iVqrCSW9w2hoRf0wnucE9pqI7Gcqs50k7
        SbOlP5oqt+4NG6Ucifq/0a70Zwj3dBzunnHDUwz/94cd6/jlsW8n0oYJoBvbogcm67Ya9ol1G5IlX
        XoXQnRGVHmDxiAovevX4X9q1LAcBSTVs98rMJlnaKawPtZU4tTpORaQ1a1ZGZfSrHt4pTbN1Wtvez
        OsxFGfHA+keUtvv1eZsaSU6gi7x+jDghnfOrQ5xYLXYrHyMsuin4zDBRFqPMJ0tU9DDiiY/bCWJA+
        4i/N7IeA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pTPdl-00AGWj-Ft; Sat, 18 Feb 2023 16:00:45 +0000
Date:   Sat, 18 Feb 2023 16:00:45 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     gregkh@linuxfoundation.org
Cc:     qian@ddn.com, akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm/filemap: fix page end in
 filemap_get_read_batch" failed to apply to 5.15-stable tree
Message-ID: <Y/D2LZICIG7x+FOw@casper.infradead.org>
References: <167670736248208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167670736248208@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 18, 2023 at 09:02:42AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a patch for 5.15-stable, generated against v5.15.94


diff --git a/mm/filemap.c b/mm/filemap.c
index 30c9c2a63746..81e28722edfa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2538,18 +2538,19 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 	struct page *page;
 	int err = 0;
 
+	/* "last_index" is the index of the page beyond the end of the read */
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	filemap_get_read_batch(mapping, index, last_index, pvec);
+	filemap_get_read_batch(mapping, index, last_index - 1, pvec);
 	if (!pagevec_count(pvec)) {
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		page_cache_sync_readahead(mapping, ra, filp, index,
 				last_index - index);
-		filemap_get_read_batch(mapping, index, last_index, pvec);
+		filemap_get_read_batch(mapping, index, last_index - 1, pvec);
 	}
 	if (!pagevec_count(pvec)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))

> Possible dependencies:
> 
> 5956592ce337 ("mm/filemap: fix page end in filemap_get_read_batch")
> 25d6a23e8d28 ("filemap: Convert filemap_get_read_batch() to use a folio_batch")
> d996fc7f615f ("filemap: Convert filemap_read() to use a folio")
> 65bca53b5f63 ("filemap: Convert filemap_get_pages to use folios")
> a5d4ad098528 ("filemap: Convert filemap_create_page to folio")
> 9d427b4eb456 ("filemap: Convert filemap_read_page to take a folio")
> bdb729329769 ("filemap: Convert filemap_get_read_batch to use folios")
> 512b7931ad05 ("Merge branch 'akpm' (patches from Andrew)")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 5956592ce337330cdff0399a6f8b6a5aea397a8e Mon Sep 17 00:00:00 2001
> From: Qian Yingjin <qian@ddn.com>
> Date: Wed, 8 Feb 2023 10:24:00 +0800
> Subject: [PATCH] mm/filemap: fix page end in filemap_get_read_batch
> 
> I was running traces of the read code against an RAID storage system to
> understand why read requests were being misaligned against the underlying
> RAID strips.  I found that the page end offset calculation in
> filemap_get_read_batch() was off by one.
> 
> When a read is submitted with end offset 1048575, then it calculates the
> end page for read of 256 when it should be 255.  "last_index" is the index
> of the page beyond the end of the read and it should be skipped when get a
> batch of pages for read in @filemap_get_read_batch().
> 
> The below simple patch fixes the problem.  This code was introduced in
> kernel 5.12.
> 
> Link: https://lkml.kernel.org/r/20230208022400.28962-1-coolqyj@163.com
> Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
> Signed-off-by: Qian Yingjin <qian@ddn.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c4d4ace9cc70..0e20a8d6dd93 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2588,18 +2588,19 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
>  	struct folio *folio;
>  	int err = 0;
>  
> +	/* "last_index" is the index of the page beyond the end of the read */
>  	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
>  retry:
>  	if (fatal_signal_pending(current))
>  		return -EINTR;
>  
> -	filemap_get_read_batch(mapping, index, last_index, fbatch);
> +	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
>  	if (!folio_batch_count(fbatch)) {
>  		if (iocb->ki_flags & IOCB_NOIO)
>  			return -EAGAIN;
>  		page_cache_sync_readahead(mapping, ra, filp, index,
>  				last_index - index);
> -		filemap_get_read_batch(mapping, index, last_index, fbatch);
> +		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
>  	}
>  	if (!folio_batch_count(fbatch)) {
>  		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
> 
