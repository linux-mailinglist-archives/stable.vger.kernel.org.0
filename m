Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89221BC5B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 19:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgGJRgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 13:36:06 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:46326 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727078AbgGJRgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 13:36:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0U2JRgj0_1594402558;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0U2JRgj0_1594402558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Jul 2020 01:36:00 +0800
Subject: Re: [PATCH] mm: Close race between munmap() and
 expand_upwards()/downwards()
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20200709105309.42495-1-kirill.shutemov@linux.intel.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <cacf4768-f7f2-ccb3-f4cc-0e7338045642@linux.alibaba.com>
Date:   Fri, 10 Jul 2020 10:35:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200709105309.42495-1-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/20 3:53 AM, Kirill A. Shutemov wrote:
> VMA with VM_GROWSDOWN or VM_GROWSUP flag set can change their size under
> mmap_read_lock(). It can lead to race with __do_munmap():
>
> 	Thread A			Thread B
> __do_munmap()
>    detach_vmas_to_be_unmapped()
>    mmap_write_downgrade()
> 				expand_downwards()
> 				  vma->vm_start = address;
> 				  // The VMA now overlaps with
> 				  // VMAs detached by the Thread A
> 				// page fault populates expanded part
> 				// of the VMA
>    unmap_region()
>      // Zaps pagetables partly
>      // populated by Thread B
>
> Similar race exists for expand_upwards().
>
> The fix is to avoid downgrading mmap_lock in __do_munmap() if detached
> VMAs are next to VM_GROWSDOWN or VM_GROWSUP VMA.

Thanks for catching this. The fix makes sense to me. Reviewed-by: Yang 
Shi <yang.shi@linux.alibaba.com>

>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Jann Horn <jannh@google.com>
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Cc: <stable@vger.kernel.org> # 4.20
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> ---
>   mm/mmap.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 59a4682ebf3f..71df4b36b42a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2620,7 +2620,7 @@ static void unmap_region(struct mm_struct *mm,
>    * Create a list of vma's touched by the unmap, removing them from the mm's
>    * vma list as we go..
>    */
> -static void
> +static bool
>   detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>   	struct vm_area_struct *prev, unsigned long end)
>   {
> @@ -2645,6 +2645,17 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>   
>   	/* Kill the cache */
>   	vmacache_invalidate(mm);
> +
> +	/*
> +	 * Do not downgrade mmap_sem if we are next to VM_GROWSDOWN or
> +	 * VM_GROWSUP VMA. Such VMAs can change their size under
> +	 * down_read(mmap_sem) and collide with the VMA we are about to unmap.
> +	 */
> +	if (vma && (vma->vm_flags & VM_GROWSDOWN))
> +		return false;
> +	if (prev && (prev->vm_flags & VM_GROWSUP))
> +		return false;
> +	return true;
>   }
>   
>   /*
> @@ -2825,7 +2836,8 @@ int __do_munmap(struct mm_struct *mm, unsigned long start, size_t len,
>   	}
>   
>   	/* Detach vmas from rbtree */
> -	detach_vmas_to_be_unmapped(mm, vma, prev, end);
> +	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
> +		downgrade = false;
>   
>   	if (downgrade)
>   		mmap_write_downgrade(mm);

