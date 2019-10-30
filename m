Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295D8EA31A
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 19:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfJ3SPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 14:15:11 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:42174 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbfJ3SPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 14:15:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Tgir3np_1572459299;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tgir3np_1572459299)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 31 Oct 2019 02:15:07 +0800
Subject: Re: [PATCH] mm: mempolicy: fix the wrong return value and potential
 pages leak of mbind
To:     lixinhai.lxh@gmail.com, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1572454731-3925-1-git-send-email-yang.shi@linux.alibaba.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <12ac5b41-27a6-5a5b-0d07-7e9cb847829d@linux.alibaba.com>
Date:   Wed, 30 Oct 2019 11:14:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1572454731-3925-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/30/19 9:58 AM, Yang Shi wrote:
> The commit d883544515aa ("mm: mempolicy: make the behavior consistent
> when MPOL_MF_MOVE* and MPOL_MF_STRICT were specified") fixed the return
> value of mbind() for a couple of corner cases.  But, it altered the
> errno for some other cases, for example, mbind() should return -EFAULT
> when part or all of the memory range specified by nodemask and maxnode
> points  outside your accessible address space, or there was an unmapped
> hole in the specified memory range specified by addr and len.
>
> Fixed this by preserving the errno returned by queue_pages_range().
> And, the pagelist may be not empty even though queue_pages_range()
> returns error, put the pages back to LRU since mbind_range() is not called
> to really apply the policy so those pages should not be migrated, this
> is also the old behavior before the problematic commit.
Forgot fixes tag.

Fixes: d883544515aa ("mm: mempolicy: make the behavior consistent when 
MPOL_MF_MOVE* and MPOL_MF_STRICT were specified")

> Reported-by: Li Xinhai <lixinhai.lxh@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> v4.19 and v5.2+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
>   mm/mempolicy.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4ae967b..e08c941 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -672,7 +672,9 @@ static int queue_pages_test_walk(unsigned long start, unsigned long end,
>    * 1 - there is unmovable page, but MPOL_MF_MOVE* & MPOL_MF_STRICT were
>    *     specified.
>    * 0 - queue pages successfully or no misplaced page.
> - * -EIO - there is misplaced page and only MPOL_MF_STRICT was specified.
> + * errno - i.e. misplaced pages with MPOL_MF_STRICT specified (-EIO) or
> + *         memory range specified by nodemask and maxnode points outside
> + *         your accessible address space (-EFAULT)
>    */
>   static int
>   queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
> @@ -1286,7 +1288,7 @@ static long do_mbind(unsigned long start, unsigned long len,
>   			  flags | MPOL_MF_INVERT, &pagelist);
>   
>   	if (ret < 0) {
> -		err = -EIO;
> +		err = ret;
>   		goto up_out;
>   	}
>   
> @@ -1305,10 +1307,12 @@ static long do_mbind(unsigned long start, unsigned long len,
>   
>   		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
>   			err = -EIO;
> -	} else
> -		putback_movable_pages(&pagelist);
> -
> +	} else {
>   up_out:
> +		if (!list_empty(&pagelist))
> +			putback_movable_pages(&pagelist);
> +	}
> +
>   	up_write(&mm->mmap_sem);
>   mpol_out:
>   	mpol_put(new);

