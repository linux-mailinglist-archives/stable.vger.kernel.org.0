Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B64E383A
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503528AbfJXQin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 12:38:43 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39745 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503426AbfJXQim (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 12:38:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Tg4pDHR_1571934793;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg4pDHR_1571934793)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Oct 2019 00:33:16 +0800
Subject: Re: [v4 PATCH] mm: thp: handle page cache THP correctly in
 PageTransCompoundMap
To:     Matthew Wilcox <willy@infradead.org>
Cc:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com>
 <20191024135547.GH2963@bombadil.infradead.org>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <c3932146-1b91-fa90-b947-9d4ebe5c5135@linux.alibaba.com>
Date:   Thu, 24 Oct 2019 09:33:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20191024135547.GH2963@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/24/19 6:55 AM, Matthew Wilcox wrote:
> On Thu, Oct 24, 2019 at 05:19:35AM +0800, Yang Shi wrote:
>> We have usecase to use tmpfs as QEMU memory backend and we would like to
>> take the advantage of THP as well.  But, our test shows the EPT is not
>> PMD mapped even though the underlying THP are PMD mapped on host.
>> The number showed by /sys/kernel/debug/kvm/largepage is much less than
>> the number of PMD mapped shmem pages as the below:
>>
>> 7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
>> Size:            4194304 kB
>> [snip]
>> AnonHugePages:         0 kB
>> ShmemPmdMapped:   579584 kB
>> [snip]
>> Locked:                0 kB
>>
>> cat /sys/kernel/debug/kvm/largepages
>> 12
>>
>> And some benchmarks do worse than with anonymous THPs.
>>
>> By digging into the code we figured out that commit 127393fbe597 ("mm:
>> thp: kvm: fix memory corruption in KVM with THP enabled") checks if
>> there is a single PTE mapping on the page for anonymous THP when
>> setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
>> cache THP since every subpage of page cache THP would get _mapcount
>> inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
>> false for page cache THP.  This would prevent KVM from setting up PMD
>> mapped EPT entry.
>>
>> So we need handle page cache THP correctly.  However, when page cache
>> THP's PMD gets split, kernel just remove the map instead of setting up
>> PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
>> the subpages may get PTE mapped even though it is still a THP since the
>> page cache THP may be mapped by other processes at the mean time.
>>
>> Checking its _mapcount and whether the THP has PTE mapped or not.
>> Although this may report some false negative cases (PTE mapped by other
>> processes), it looks not trivial to make this accurate.
> I don't understand why you care how it's mapped into userspace.  If there
> is a PMD-sized page in the page cache, then you can use a PMD mapping
> in the EPT tables to map it.  Why would another process having a PTE
> mapping on the page cause you to not use a PMD mapping?

We don't care if the THP is PTE mapped by other process, but either 
PageDoubleMap flag or _mapcount/compound_mapcount can't tell us if the 
PTE map comes from the current process or other process unless gup could 
return pmd's status.

I think the commit 127393fbe597 ("mm: thp: kvm: fix memory corruption in 
KVM with THP enabled") elaborates the trade-off clearly (not full commit 
log, just paste the most related part):

    Ideally instead of the page->_mapcount < 1 check, get_user_pages()
     should return the granularity of the "page" mapping in the "mm" passed
     to get_user_pages().  However it's non trivial change to pass the "pmd"
     status belonging to the "mm" walked by get_user_pages up the stack (up
     to the caller of get_user_pages).  So the fix just checks if there is
     not a single pte mapping on the page returned by get_user_pages, and in
     turn if the caller can assume that the whole compound page is mapped in
     the current "mm" (in a pmd_trans_huge()).  In such case the entire
     compound page is safe to map into the secondary MMU without additional
     get_user_pages() calls on the surrounding tail/head pages.  In addition
     of being faster, not having to run other get_user_pages() calls also
     reduces the memory footprint of the secondary MMU fault in case the pmd
     split happened as result of memory pressure.


