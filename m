Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9011941A10
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 03:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407565AbfFLBwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 21:52:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18132 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406607AbfFLBwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 21:52:00 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 37B9F17F8941DD2D9381;
        Wed, 12 Jun 2019 09:51:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.120) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Jun 2019
 09:51:54 +0800
Subject: Re: [PATCH] futex: Fix futex lock the wrong page
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <peterz@infradead.org>,
        <dvhart@infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1560304465-68966-1-git-send-email-zhangxiaoxu5@huawei.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Message-ID: <d00fc9d7-ea10-1577-40e9-03df1578acbe@huawei.com>
Date:   Wed, 12 Jun 2019 09:50:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1560304465-68966-1-git-send-email-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.120]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is for stable branch linux-4.4-y.

On 2019/6/12 9:54, ZhangXiaoxu wrote:
> The upstram commit 65d8fc777f6d ("futex: Remove requirement
> for lock_page() in get_futex_key()") use variable 'page' as
> the page head, when merge it to stable branch, the variable
> `page_head` is page head.
> 
> In the stable branch, the variable `page` not means the page
> head, when lock the page head, we should lock 'page_head',
> rather than 'page'.
> 
> It maybe lead a hung task problem.
> 
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>   kernel/futex.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index ec9df5b..15d850f 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -593,8 +593,8 @@ again:
>   		 * applies. If this is really a shmem page then the page lock
>   		 * will prevent unexpected transitions.
>   		 */
> -		lock_page(page);
> -		shmem_swizzled = PageSwapCache(page) || page->mapping;
> +		lock_page(page_head);
> +		shmem_swizzled = PageSwapCache(page_head) || page_head->mapping;
>   		unlock_page(page_head);
>   		put_page(page_head);
>   
> 

