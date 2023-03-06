Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7F06AB486
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 03:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCFCJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 21:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFCJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 21:09:20 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206529745;
        Sun,  5 Mar 2023 18:09:19 -0800 (PST)
Received: from dggpemm500001.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PVMQ00Gqxz16NjN;
        Mon,  6 Mar 2023 10:06:32 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 10:09:16 +0800
Message-ID: <90d30f18-68e7-d295-7a42-c33554fd8b17@huawei.com>
Date:   Mon, 6 Mar 2023 10:09:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] mm/damon/paddr: fix folio_size() call after
 folio_put() in damon_pa_young()
Content-Language: en-US
To:     SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <damon@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20230304193949.296391-1-sj@kernel.org>
 <20230304193949.296391-2-sj@kernel.org>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20230304193949.296391-2-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/3/5 3:39, SeongJae Park wrote:
> damon_pa_young() is accessing a folio via folio_size() after folio_put()
> for the folio has invoked.  Fix it.
> 

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> Fixes: 397b0c3a584b ("mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result")
> Cc: <stable@vger.kernel.org> # 6.3.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   mm/damon/paddr.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 3fda00a0f786..10f159b315ea 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -130,7 +130,6 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
>   			accessed = false;
>   		else
>   			accessed = true;
> -		folio_put(folio);
>   		goto out;
>   	}
>   
> @@ -144,10 +143,10 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
>   
>   	if (need_lock)
>   		folio_unlock(folio);
> -	folio_put(folio);
>   
>   out:
>   	*folio_sz = folio_size(folio);
> +	folio_put(folio);
>   	return accessed;
>   }
>   
