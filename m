Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAED28583C
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 07:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgJGFsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 01:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGFsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 01:48:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888C7C061755;
        Tue,  6 Oct 2020 22:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BBGqLkpiWOAukT4cGbe+ekpiE16tTJaZW03Gt7ynzdI=; b=t/QSLeG7RQBiWYRnopnrssXYFK
        n3vc0rGv17CNvb8Y/WkwuC/SxjNbRnzsh5m9BRlD8G6GX7t98k1d/y8cbqRO3l5L1aMv6Ydc0Mlg5
        mI7i+pJQhT+VDALgc36DA0L/rTkp3ekxv+5aT/QsLlOv6P0LrPlMneAQMxZv5s2RdPz9PrRCSBa+T
        mSbtHJTbLCF/3NY+XJ95FcoXB62OM28dlVXti3pxX4KlwMT2J1tLLDuKyTyp1gXlUOrs/GWjXG7M9
        YPio7RcXP51/avKaLimQVw1+JGWGKFzzAB90Z4jGDaZdw3MOOzI9IPKUfE6nNI5jJkBF/BQQWeSoh
        mzhEKVAg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQ2Jl-0004NF-9U; Wed, 07 Oct 2020 05:48:49 +0000
Date:   Wed, 7 Oct 2020 06:48:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/7] 9P: Cast to loff_t before multiplying
Message-ID: <20201007054849.GA16556@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004180428.14494-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 04, 2020 at 07:04:22PM +0100, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this multiplication will overflow for files larger
> than 4GB.
> 
> Cc: stable@vger.kernel.org
> Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/9p/vfs_file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 3576123d8299..6d97b6b4d34b 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -612,9 +612,9 @@ static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
>  	struct writeback_control wbc = {
>  		.nr_to_write = LONG_MAX,
>  		.sync_mode = WB_SYNC_ALL,
> -		.range_start = vma->vm_pgoff * PAGE_SIZE,
> +		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,

Given the may places where this issue shows up I think we really need
a vma_offset or similar helper for it.  Much better than chasing missing
casts everywhere.
