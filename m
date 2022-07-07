Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3DA56989D
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 05:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiGGDJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 23:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiGGDJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 23:09:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D381E30574;
        Wed,  6 Jul 2022 20:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ITh/kBo08G4zvJ+AcbAFvZopADq2rIsMdPM9xbzcnWU=; b=WBajSaJ9KODDVHIUU7HDjKT185
        jZfcpj60XcYVAOuWmnz5uv/JtWX194F4uCYkNrWBuGbyWskGN3nF7skwdKpTjbjM+cQARxY6Xx+3L
        oYBHt2qy2M4UwE4P+vpo9couEkEdUN6F1WLrh59oF37uZlb+ZxMlPq0G//etIVM9Ox/yNIfv4MK5j
        gKcpeXF3I4HyUmGYDo4SaKDPR8gHSWmxRfcmJAL/vDCRfkIH/2NMTAppe3ZNz90g/f8GtiHvKg55X
        u7d0bca7OEtGrv0qnz20aUkAyq/a3ZRBEPxwoJMFuaLzuQaff64jgQQi4VJYOBhpzGxz0L+HYjQV6
        49qPqXlw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o9HtR-002E3r-Tn; Thu, 07 Jul 2022 03:09:29 +0000
Date:   Thu, 7 Jul 2022 04:09:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15 v4] mm/filemap: fix UAF in find_lock_entries
Message-ID: <YsZOafRSNZWY0EpM@casper.infradead.org>
References: <20220707020938.2122198-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707020938.2122198-1-liushixin2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 07, 2022 at 10:09:38AM +0800, Liu Shixin wrote:
> Release refcount after xas_set to fix UAF which may cause panic like this:
> 
>  page:ffffea000491fa40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1247e9
>  head:ffffea000491fa00 order:3 compound_mapcount:0 compound_pincount:0
>  memcg:ffff888104f91091
>  flags: 0x2fffff80010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> ...
> page dumped because: VM_BUG_ON_PAGE(PageTail(page))
>  ------------[ cut here ]------------
>  kernel BUG at include/linux/page-flags.h:632!
>  invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
>  CPU: 1 PID: 7642 Comm: sh Not tainted 5.15.51-dirty #26
> ...
>  Call Trace:
>   <TASK>
>   __invalidate_mapping_pages+0xe7/0x540
>   drop_pagecache_sb+0x159/0x320
>   iterate_supers+0x120/0x240
>   drop_caches_sysctl_handler+0xaa/0xe0
>   proc_sys_call_handler+0x2b4/0x480
>   new_sync_write+0x3d6/0x5c0
>   vfs_write+0x446/0x7a0
>   ksys_write+0x105/0x210
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7f52b5733130
> ...
> 
> This problem has been fixed on mainline by patch 6b24ca4a1a8d ("mm: Use
> multi-index entries in the page cache") since it deletes the related code.
> 
> Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> ---
>  mm/filemap.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00e391e75880..dbc461703ff4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2090,7 +2090,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  
>  	rcu_read_lock();
>  	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
> +		unsigned long next_idx = xas.xa_index + 1;
> +
>  		if (!xa_is_value(page)) {
> +			if (PageTransHuge(page))
> +				next_idx = page->index + thp_nr_pages(page);
>  			if (page->index < start)
>  				goto put;
>  			if (page->index + thp_nr_pages(page) - 1 > end)
> @@ -2111,13 +2115,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  put:
>  		put_page(page);
>  next:
> -		if (!xa_is_value(page) && PageTransHuge(page)) {
> -			unsigned int nr_pages = thp_nr_pages(page);
> -
> +		if (next_idx != xas.xa_index + 1) {
>  			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
> -			xas_set(&xas, page->index + nr_pages);
> -			if (xas.xa_index < nr_pages)
> +			if (next_idx < xas.xa_index)
>  				break;
> +			xas_set(&xas, next_idx);
>  		}
>  	}
>  	rcu_read_unlock();
> -- 
> 2.25.1
> 
