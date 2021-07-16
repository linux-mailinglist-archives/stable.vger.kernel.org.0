Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6073CB957
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbhGPPHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:07:46 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59269 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240717AbhGPPHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:07:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UfzeaRF_1626447887;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UfzeaRF_1626447887)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Jul 2021 23:04:48 +0800
Date:   Fri, 16 Jul 2021 23:04:46 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
        linux-erofs@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] iomap: Add missing flush_dcache_page
Message-ID: <YPGgDoyn7pgM+7Vb@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
        linux-erofs@lists.ozlabs.org, stable@vger.kernel.org
References: <20210716150032.1089982-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210716150032.1089982-1-willy@infradead.org>
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

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
(will update on my side as well)

Thanks,
Gao Xiang

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
>  	SetPageUptodate(page);
>  }
>  
> -- 
> 2.30.2
