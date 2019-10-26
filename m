Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BD7E57EE
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 03:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfJZBzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 21:55:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfJZBzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 21:55:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B5EE06AF3D3E2FC51D0A;
        Sat, 26 Oct 2019 09:54:58 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.218) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sat, 26 Oct 2019
 09:54:56 +0800
Message-ID: <5DB3A76F.3020508@huawei.com>
Date:   Sat, 26 Oct 2019 09:54:55 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Matthew Wilcox <willy@infradead.org>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <vbabka@suse.cz>, <mhocko@suse.com>, <linux-mm@kvack.org>
Subject: Re: [RPF STABLE PATCH] mm/memfd: should be lock the radix_tree when
 iterating its slot
References: <1571929400-12147-1-git-send-email-zhongjiang@huawei.com> <20191025151738.GP2963@bombadil.infradead.org>
In-Reply-To: <20191025151738.GP2963@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.218]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/10/25 23:17, Matthew Wilcox wrote:
> On Thu, Oct 24, 2019 at 11:03:20PM +0800, zhong jiang wrote:
>> +	xa_lock_irq(&mapping->i_pages);
> ...
>>  		if (need_resched()) {
>>  			slot = radix_tree_iter_resume(slot, &iter);
>> -			cond_resched_rcu();
>> +			cond_resched_lock(&mapping->i_pages.xa_lock);
> Ooh, this isn't right.  We're taking the lock, disabling interrupts,
> then dropping the lock and rescheduling without reenabling interrupts.
> If this ever triggers then we'll get a scheduling-while-atomic error.
>
> Fortunately (?) need_resched() can almost never be set while we're holding
> a spinlock with interrupts disabled (thanks to peterz for telling me that
> when I asked for a cond_resched_lock_irq() a few years ago).  So we need
> to take this patch further towards the current code.
I miss that.  Thanks you for pointing out.

Thanks,
zhong jiang
> Here's a version for 4.14.y.  Compile tested only.
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6c10f1d92251..deaea74ec1b3 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2657,11 +2657,12 @@ static void shmem_tag_pins(struct address_space *mapping)
>  	void **slot;
>  	pgoff_t start;
>  	struct page *page;
> +	unsigned int tagged = 0;
>  
>  	lru_add_drain();
>  	start = 0;
> -	rcu_read_lock();
>  
> +	spin_lock_irq(&mapping->tree_lock);
>  	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
>  		page = radix_tree_deref_slot(slot);
>  		if (!page || radix_tree_exception(page)) {
> @@ -2670,18 +2671,19 @@ static void shmem_tag_pins(struct address_space *mapping)
>  				continue;
>  			}
>  		} else if (page_count(page) - page_mapcount(page) > 1) {
> -			spin_lock_irq(&mapping->tree_lock);
>  			radix_tree_tag_set(&mapping->page_tree, iter.index,
>  					   SHMEM_TAG_PINNED);
> -			spin_unlock_irq(&mapping->tree_lock);
>  		}
>  
> -		if (need_resched()) {
> -			slot = radix_tree_iter_resume(slot, &iter);
> -			cond_resched_rcu();
> -		}
> +		if (++tagged % 1024)
> +			continue;
> +
> +		slot = radix_tree_iter_resume(slot, &iter);
> +		spin_unlock_irq(&mapping->tree_lock);
> +		cond_resched();
> +		spin_lock_irq(&mapping->tree_lock);
>  	}
> -	rcu_read_unlock();
> +	spin_unlock_irq(&mapping->tree_lock);
>  }
>  

>  /*
>
>
>
> .
>


