Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE525B6C
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 03:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEVBAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 21:00:53 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40672 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfEVBAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 21:00:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TSLG0uI_1558486838;
Received: from 192.168.1.105(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TSLG0uI_1558486838)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 May 2019 09:00:47 +0800
Subject: Re: [v3 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     jstancek@redhat.com, peterz@infradead.org, will.deacon@arm.com,
        npiggin@gmail.com, aneesh.kumar@linux.ibm.com, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1558322252-113575-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190521161826.029782de0750c8f5cd2e5dd6@linux-foundation.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <9c27f777-3330-8e43-e4cf-cc4d9c3e0229@linux.alibaba.com>
Date:   Wed, 22 May 2019 09:00:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190521161826.029782de0750c8f5cd2e5dd6@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/22/19 7:18 AM, Andrew Morton wrote:
> On Mon, 20 May 2019 11:17:32 +0800 Yang Shi <yang.shi@linux.alibaba.com> wrote:
>
>> A few new fields were added to mmu_gather to make TLB flush smarter for
>> huge page by telling what level of page table is changed.
>>
>> __tlb_reset_range() is used to reset all these page table state to
>> unchanged, which is called by TLB flush for parallel mapping changes for
>> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
>> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
>> munmap"), the syscalls (e.g. MADV_DONTNEED, MADV_FREE) which may update
>> PTEs in parallel don't remove page tables.  But, the forementioned
>> commit may do munmap() under read mmap_sem and free page tables.  This
>> may result in program hang on aarch64 reported by Jan Stancek.  The
>> problem could be reproduced by his test program with slightly modified
>> below.
>>
>> ...
>>
>> Use fullmm flush since it yields much better performance on aarch64 and
>> non-fullmm doesn't yields significant difference on x86.
>>
>> The original proposed fix came from Jan Stancek who mainly debugged this
>> issue, I just wrapped up everything together.
> Thanks.  I'll add
>
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
>
> to this.

Thanks, Andrew.


