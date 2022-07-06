Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45D567E3D
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGFGOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGFGOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:14:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D779E21B;
        Tue,  5 Jul 2022 23:14:14 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ld8Km6VJfzTgVJ;
        Wed,  6 Jul 2022 14:10:36 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 14:13:51 +0800
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemm100009.china.huawei.com (7.185.36.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 14:13:51 +0800
Subject: Re: [PATCH 5.15] mm/filemap: fix UAF in find_lock_entries
To:     Matthew Wilcox <willy@infradead.org>
References: <20220706032434.579610-1-liushixin2@huawei.com>
 <YsT/qAPruIimH3+R@casper.infradead.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Christoph Hellwig <hch@lst.de>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
From:   Liu Shixin <liushixin2@huawei.com>
Message-ID: <d2040de8-a9f7-a8c4-2d31-c47e88233dfa@huawei.com>
Date:   Wed, 6 Jul 2022 14:13:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YsT/qAPruIimH3+R@casper.infradead.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2022/7/6 11:21, Matthew Wilcox wrote:
> On Wed, Jul 06, 2022 at 11:24:34AM +0800, Liu Shixin wrote:
>> Release refcount after xas_set to fix UAF which may cause panic like this:
> I think we can do better.  How about this?
Thank you for your idea, it looks more concise.
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00e391e75880..11ae38cc4fd3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2090,7 +2090,9 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  
>  	rcu_read_lock();
>  	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
> +		unsigned long next_idx = xas.xa_index + 1;
>  		if (!xa_is_value(page)) {
> +			next_idx = page->index + thp_nr_pages(page);
>  			if (page->index < start)
>  				goto put;
>  			if (page->index + thp_nr_pages(page) - 1 > end)
> @@ -2111,14 +2113,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
>  put:
>  		put_page(page);
>  next:
> -		if (!xa_is_value(page) && PageTransHuge(page)) {
> -			unsigned int nr_pages = thp_nr_pages(page);
> -
> -			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
> -			xas_set(&xas, page->index + nr_pages);
> -			if (xas.xa_index < nr_pages)
> -				break;
> -		}
> +		/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
> +		if (next_idx < xas.xa_index)
> +			break;
> +		if (next_idx != xas.xa_index + 1)
> +			xas_set(&xas, next_idx);
>  	}
>  	rcu_read_unlock();
>  
>
> .
>

