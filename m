Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF57846002E
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 17:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhK0Qao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 11:30:44 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41396 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234599AbhK0Q2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 11:28:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.wei@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyTnH6s_1638030326;
Received: from B-N4MVMD6P-2042.local(mailfrom:yang.wei@linux.alibaba.com fp:SMTPD_---0UyTnH6s_1638030326)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 28 Nov 2021 00:25:27 +0800
Subject: Re: [PATCH 4.19] x86/mm: add cond_resched() in _set_memory_array()
 and set_memory_array_wb()
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yang Wei <albin.yangwei@alibaba-inc.com>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org
References: <1637911946-67009-1-git-send-email-albin.yangwei@alibaba-inc.com>
 <YaENEIbE8hA1h19/@kroah.com>
From:   YangWei <yang.wei@linux.alibaba.com>
Message-ID: <9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com>
Date:   Sun, 28 Nov 2021 00:25:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YaENEIbE8hA1h19/@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/11/27 00:36, Greg KH 写道:
> On Fri, Nov 26, 2021 at 03:32:26PM +0800, Yang Wei wrote:
>> From: Yang Wei <yang.wei@linux.alibaba.com>
>>
>> We found _set_memory_array() and set_memory_array_wb() takes more than
>> 500ms in kernel space in the following scenario.
>> So use this patch to trigger schedule for each page, to avoid other
>> threads getting stuck.
>>
>>      0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
>>      0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
>>      0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
>>      0xffffffff8107796f reserve_memtype  ([kernel.kallsyms])
>>      0xffffffff81075e98 _set_memory_array  ([kernel.kallsyms])
>>      0xffffffffc0ef6083 nv_alloc_system_pages  [nvidia] ([kernel.kallsyms])
>>
>>      0xffffffff810a34d2 find_next_iomem_res  ([kernel.kallsyms])
>>      0xffffffff810a3d40 walk_system_ram_range  ([kernel.kallsyms])
>>      0xffffffff810772ca pat_pagerange_is_ram  ([kernel.kallsyms])
>>      0xffffffff8107745a free_memtype.part.7  ([kernel.kallsyms])
>>      0xffffffff8107606e set_memory_array_wb  ([kernel.kallsyms])
>>      0xffffffffc0ef6291 nv_free_system_pages  [nvidia]([kernel.kallsyms])
>>
>> Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
>> Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
>> ---
>>   arch/x86/mm/pageattr.c | 2 ++
>>   1 file changed, 2 insertions(+)
> Why is this 4.19-only?
>
> What commit in Linus's tree resolved this issue?
>
> confused,
>
> greg k-h

We found that the nvidia driver calling 
nv_alloc_system_pages()/nv_free_system_pages()

takes long-time in kernel space, which makes other threads getting stuck 
on non-preemptible

kernel. And it causes the GPU to drop frames on our 4.19 host environment.

This patch can significantly reduce dropped frames. We are currently 
only testing on

4.19, but it should also workson 4.4, 4.9 and 4.14.

The set_memory_array_wb() and set_memory_array_xx() have been removed 
since 5.4, so

Linus's tree does not including the fix of this issue.


