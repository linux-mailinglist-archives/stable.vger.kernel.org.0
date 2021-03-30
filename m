Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E4A34E07B
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 07:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhC3E75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 00:59:57 -0400
Received: from out28-146.mail.aliyun.com ([115.124.28.146]:38054 "EHLO
        out28-146.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhC3E7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 00:59:32 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07441275|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00478279-0.00110423-0.994113;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.JsM3E1E_1617080368;
Received: from 192.168.123.38(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.JsM3E1E_1617080368)
          by smtp.aliyun-inc.com(10.147.42.22);
          Tue, 30 Mar 2021 12:59:28 +0800
Subject: Re: [PATCH v3] mm: fix race by making init_zero_pfn() early_initcall
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
References: <20210329052922.1130493-1-ilya.lipnitskiy@gmail.com>
 <20210330044208.8305-1-ilya.lipnitskiy@gmail.com>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <51e3affb-ea09-65a4-99e1-daba968e6dc8@wanyeetech.com>
Date:   Tue, 30 Mar 2021 12:59:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210330044208.8305-1-ilya.lipnitskiy@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ilya,

On 2021/3/30 下午12:42, Ilya Lipnitskiy wrote:
> There are code paths that rely on zero_pfn to be fully initialized
> before core_initcall. For example, wq_sysfs_init() is a core_initcall
> function that eventually results in a call to kernel_execve, which
> causes a page fault with a subsequent mmput. If zero_pfn is not
> initialized by then it may not get cleaned up properly and result in an
> error:
>    BUG: Bad rss-counter state mm:(ptrval) type:MM_ANONPAGES val:1
>
> Here is an analysis of the race as seen on a MIPS device. On this
> particular MT7621 device (Ubiquiti ER-X), zero_pfn is PFN 0 until
> initialized, at which point it becomes PFN 5120:
>    1. wq_sysfs_init calls into kobject_uevent_env at core_initcall:
>         [<80340dc8>] kobject_uevent_env+0x7e4/0x7ec
>         [<8033f8b8>] kset_register+0x68/0x88
>         [<803cf824>] bus_register+0xdc/0x34c
>         [<803cfac8>] subsys_virtual_register+0x34/0x78
>         [<8086afb0>] wq_sysfs_init+0x1c/0x4c
>         [<80001648>] do_one_initcall+0x50/0x1a8
>         [<8086503c>] kernel_init_freeable+0x230/0x2c8
>         [<8066bca0>] kernel_init+0x10/0x100
>         [<80003038>] ret_from_kernel_thread+0x14/0x1c
>
>    2. kobject_uevent_env() calls call_usermodehelper_exec() which executes
>       kernel_execve asynchronously.
>
>    3. Memory allocations in kernel_execve cause a page fault, bumping the
>       MM reference counter:
>         [<8015adb4>] add_mm_counter_fast+0xb4/0xc0
>         [<80160d58>] handle_mm_fault+0x6e4/0xea0
>         [<80158aa4>] __get_user_pages.part.78+0x190/0x37c
>         [<8015992c>] __get_user_pages_remote+0x128/0x360
>         [<801a6d9c>] get_arg_page+0x34/0xa0
>         [<801a7394>] copy_string_kernel+0x194/0x2a4
>         [<801a880c>] kernel_execve+0x11c/0x298
>         [<800420f4>] call_usermodehelper_exec_async+0x114/0x194
>
>    4. In case zero_pfn has not been initialized yet, zap_pte_range does
>       not decrement the MM_ANONPAGES RSS counter and the BUG message is
>       triggered shortly afterwards when __mmdrop checks the ref counters:
>         [<800285e8>] __mmdrop+0x98/0x1d0
>         [<801a6de8>] free_bprm+0x44/0x118
>         [<801a86a8>] kernel_execve+0x160/0x1d8
>         [<800420f4>] call_usermodehelper_exec_async+0x114/0x194
>         [<80003198>] ret_from_kernel_thread+0x14/0x1c
>
> To avoid races such as described above, initialize init_zero_pfn at
> early_initcall level. Depending on the architecture, ZERO_PAGE is either
> constant or gets initialized even earlier, at paging_init, so there is
> no issue with initializing zero_pfn earlier.
>
> Discussion: https://lkml.kernel.org/r/CALCv0x2YqOXEAy2Q=hafjhHCtTHVodChv1qpM=niAXOpqEbt7w@mail.gmail.com
>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: stable@vger.kernel.org
> ---
>   mm/memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)


Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com> # on 
CU1000-Neo/X1000E and CU1830-Neo/X1830


> diff --git a/mm/memory.c b/mm/memory.c
> index 5c3b29d3af66..e66b11ac1659 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -166,7 +166,7 @@ static int __init init_zero_pfn(void)
>   	zero_pfn = page_to_pfn(ZERO_PAGE(0));
>   	return 0;
>   }
> -core_initcall(init_zero_pfn);
> +early_initcall(init_zero_pfn);
>   
>   void mm_trace_rss_stat(struct mm_struct *mm, int member, long count)
>   {
