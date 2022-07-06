Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEED567F8C
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiGFHIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGFHIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:08:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAFCD5A;
        Wed,  6 Jul 2022 00:08:12 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ld9Yw0X2JzkX5l;
        Wed,  6 Jul 2022 15:06:12 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 15:07:32 +0800
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemm100009.china.huawei.com (7.185.36.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 15:07:32 +0800
Subject: Re: [PATCH 5.15 v2] mm/filemap: fix UAF in find_lock_entries
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        "Christoph Hellwig" <hch@lst.de>
References: <20220706073045.1398379-1-liushixin2@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
From:   Liu Shixin <liushixin2@huawei.com>
Message-ID: <904d2d5a-c39a-928e-55f2-58d1c1fa737e@huawei.com>
Date:   Wed, 6 Jul 2022 15:07:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220706073045.1398379-1-liushixin2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch has a compilation problem, please ignore it.


On 2022/7/6 15:30, Liu Shixin wrote:
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
> ---
>  mm/filemap.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00e391e75880..2c65dd314c49 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2090,7 +2090,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  
>  	rcu_read_lock();
>  	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
> +		unsigned long next_idx = xas.xa_index;
> +
>  		if (!xa_is_value(page)) {
> +			if (PageTransHuge(page))
> +				next_idx = page->index + thp_nr_pages(page);
>  			if (page->index < start)
>  				goto put;
>  			if (page->index + thp_nr_pages(page) - 1 > end)
> @@ -2111,11 +2115,9 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  put:
>  		put_page(page);
>  next:
> -		if (!xa_is_value(page) && PageTransHuge(page)) {
> -			unsigned int nr_pages = thp_nr_pages(page);
> -
> +		if (next_idx != xas.xa_index) {
>  			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
> -			xas_set(&xas, page->index + nr_pages);
> +			xas_set(&xas, next_idx);
>  			if (xas.xa_index < nr_pages)
>  				break;
>  		}

