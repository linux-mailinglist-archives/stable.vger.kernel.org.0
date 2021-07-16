Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832713CB95E
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbhGPPJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbhGPPJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:09:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C92C061762;
        Fri, 16 Jul 2021 08:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p2jp4TKVKUbRaXkEqpueJ3r5TGVZqBxb3+WOYtKL/lo=; b=W4kk2VIp/COn5HR9jLXvO6E1r4
        V5nRtkY79aVdM8qeu1MDonnLzyTvZhnmgAKOl/Ur2osTRhkIN7QYmxqHSKGJmZG+feq77wERJstSi
        7siJjLU1rFj9z33dxKQeN2lnEvWfXnJ22CVnQL9J77UXZEicN52c/9ut0OFDA6eFcriumUQ6cQp0J
        vkEpm8qqTYQjAceIOu7ttQlDTybU5nzSh2+kCPAut4YHzLutC5JtpCUyCcJqD7pod3QvgItO4aN7e
        nr/m5sLTqkfViKMEH2oXYhcvwDYm8EvkXaQmKXqGfnijYqWqp2kUMBCd09KL4XGKWlwLyMzZMajeL
        OBj6aRuw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4PNy-004ZkD-2i; Fri, 16 Jul 2021 15:04:36 +0000
Date:   Fri, 16 Jul 2021 16:04:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
        linux-erofs@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] iomap: Add missing flush_dcache_page
Message-ID: <YPGf8o7vo6/9iTE5@infradead.org>
References: <20210716150032.1089982-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716150032.1089982-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 04:00:32PM +0100, Matthew Wilcox (Oracle) wrote:
> Inline data needs to be flushed from the kernel's view of a page before
> it's mapped by userspace.
> 
> Cc: stable@vger.kernel.org
> Fixes: 19e0c58f6552 ("iomap: generic inline data handling")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 41da4f14c00b..fe60c603f4ca 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -222,6 +222,7 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
>  	memcpy(addr, iomap->inline_data, size);
>  	memset(addr + size, 0, PAGE_SIZE - size);
>  	kunmap_atomic(addr);
> +	flush_dcache_page(page);

.. and all writes into a kmap also need such a flush, so this needs to
move a line up.  My plan was to add a memcpy_to_page_and_pad helper
ala memcpy_to_page to get various file systems and drivers out of the
business of cache flushing as much as we can.
