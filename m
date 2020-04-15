Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F91A9500
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 09:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635266AbgDOHoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 03:44:32 -0400
Received: from relay.sw.ru ([185.231.240.75]:40790 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2635258AbgDOHo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 03:44:27 -0400
Received: from [192.168.15.208]
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1jOciH-0001yT-Vf; Wed, 15 Apr 2020 10:44:02 +0300
Subject: Re: +
 mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch added
 to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        duanxiongchun@bytedance.com, hughd@google.com,
        imbrenda@linux.vnet.ibm.com, Markus.Elfring@web.de,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, yang.shi@linux.alibaba.com
References: <20200415015410.glIzXqR5d%akpm@linux-foundation.org>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <49e65ca7-03a2-9a82-9e1a-cf997320bcfd@virtuozzo.com>
Date:   Wed, 15 Apr 2020 10:44:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415015410.glIzXqR5d%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.04.2020 04:54, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/ksm: fix NULL pointer dereference when KSM zero page is enabled
> has been added to the -mm tree.  Its filename is
>      mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Muchun Song <songmuchun@bytedance.com>
> Subject: mm/ksm: fix NULL pointer dereference when KSM zero page is enabled
> 
> find_mergeable_vma can return NULL.  In this case, it leads to crash when
> we access vma->vm_mm(its offset is 0x40) later in write_protect_page.  And
> this case did happen on our server.  The following calltrace is captured
> in kernel 4.19 with the following patch applied and KSM zero page enabled
> on our server.
> 
>   commit e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
> 
> So add a vma check to fix it.
> 
> --------------------------------------------------------------------------
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
>   Oops: 0000 [#1] SMP NOPTI
>   CPU: 9 PID: 510 Comm: ksmd Kdump: loaded Tainted: G OE 4.19.36.bsk.9-amd64 #4.19.36.bsk.9
>   Hardware name: FOXCONN R-5111/GROOT, BIOS IC1B111F 08/17/2019
>   RIP: 0010:try_to_merge_one_page+0xc7/0x760
>   Code: 24 58 65 48 33 34 25 28 00 00 00 89 e8 0f 85 a3 06 00 00 48 83 c4
>         60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 46 08 a8 01 75 b8 <49>
>         8b 44 24 40 4c 8d 7c 24 20 b9 07 00 00 00 4c 89 e6 4c 89 ff 48
>   RSP: 0018:ffffadbdd9fffdb0 EFLAGS: 00010246
>   RAX: ffffda83ffd4be08 RBX: ffffda83ffd4be40 RCX: 0000002c6e800000
>   RDX: 0000000000000000 RSI: ffffda83ffd4be40 RDI: 0000000000000000
>   RBP: ffffa11939f02ec0 R08: 0000000094e1a447 R09: 00000000abe76577
>   R10: 0000000000000962 R11: 0000000000004e6a R12: 0000000000000000
>   R13: ffffda83b1e06380 R14: ffffa18f31f072c0 R15: ffffda83ffd4be40
>   FS: 0000000000000000(0000) GS:ffffa0da43b80000(0000) knlGS:0000000000000000
>   CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000040 CR3: 0000002c77c0a003 CR4: 00000000007626e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   PKRU: 55555554
>   Call Trace:
>     ? follow_page_pte+0x36d/0x5e0
>     ksm_scan_thread+0x115e/0x1960
>     ? remove_wait_queue+0x60/0x60
>     kthread+0xf5/0x130
>     ? try_to_merge_with_ksm_page+0x90/0x90
>     ? kthread_create_worker_on_cpu+0x70/0x70
>     ret_from_fork+0x1f/0x30
> --------------------------------------------------------------------------
> 
> Link: http://lkml.kernel.org/r/20200414132905.83819-1-songmuchun@bytedance.com
> Fixes: e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Co-developed-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> Cc: Hugh Dickins <hughd@google.com>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
> Cc: Markus Elfring <Markus.Elfring@web.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/ksm.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/mm/ksm.c~mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled
> +++ a/mm/ksm.c
> @@ -2112,8 +2112,11 @@ static void cmp_and_merge_page(struct pa
>  
>  		down_read(&mm->mmap_sem);
>  		vma = find_mergeable_vma(mm, rmap_item->address);
> -		err = try_to_merge_one_page(vma, page,
> -					    ZERO_PAGE(rmap_item->address));
> +		if (vma)
> +			err = try_to_merge_one_page(vma, page,
> +					ZERO_PAGE(rmap_item->address));
> +		else
> +			err = -EFAULT;
>  		up_read(&mm->mmap_sem);

In case of vma is out of date, we also may consider to exit this function without
calling unstable_tree_search_insert().

>  		/*
>  		 * In case of failure, the page was not really empty, so we
> _
> 
> Patches currently in -mm which might be from songmuchun@bytedance.com are
> 
> mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> 

