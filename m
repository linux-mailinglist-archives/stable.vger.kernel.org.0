Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF16AB484
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 03:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCFCGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 21:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFCGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 21:06:00 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAB91284A;
        Sun,  5 Mar 2023 18:05:59 -0800 (PST)
Received: from dggpemm500001.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PVMNV2v6CzrSRF;
        Mon,  6 Mar 2023 10:05:14 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 10:05:57 +0800
Message-ID: <51e294bd-c241-ec7e-97d0-b1a7f3534578@huawei.com>
Date:   Mon, 6 Mar 2023 10:05:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/2] mm/damon/paddr: fix folio_nr_pages() after
 folio_put() in damon_pa_mark_accessed_or_deactivate()
Content-Language: en-US
To:     SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        <damon@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20230304193949.296391-1-sj@kernel.org>
 <20230304193949.296391-3-sj@kernel.org>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20230304193949.296391-3-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/3/5 3:39, SeongJae Park wrote:
> damon_pa_mark_accessed_or_deactivate() is accessing a folio via
> folio_nr_pages() after folio_put() for the folio has invoked.  Fix it.
> 

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> Fixes: f70da5ee8fe1 ("mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios")
> Cc: <stable@vger.kernel.org> # 6.3.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   mm/damon/paddr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 10f159b315ea..0db724aec5cb 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -277,8 +277,8 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
>   			folio_mark_accessed(folio);
>   		else
>   			folio_deactivate(folio);
> -		folio_put(folio);
>   		applied += folio_nr_pages(folio);
> +		folio_put(folio);
>   	}
>   	return applied * PAGE_SIZE;
>   }
