Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEF204DF1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 11:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbgFWJaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 05:30:24 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46772 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731968AbgFWJaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 05:30:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=richard.weiyang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0U0V8lOr_1592904618;
Received: from localhost(mailfrom:richard.weiyang@linux.alibaba.com fp:SMTPD_---0U0V8lOr_1592904618)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Jun 2020 17:30:18 +0800
Date:   Tue, 23 Jun 2020 17:30:18 +0800
From:   Wei Yang <richard.weiyang@linux.alibaba.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Wei Yang <richard.weiyang@gmail.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Message-ID: <20200623093018.GA6069@L-31X9LVDL-1304.local>
Reply-To: Wei Yang <richard.weiyang@linux.alibaba.com>
References: <20200619125923.22602-2-david@redhat.com>
 <20200622082635.GA93552@L-31X9LVDL-1304.local>
 <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
 <20200622092221.GA96699@L-31X9LVDL-1304.local>
 <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
 <20200622131003.GA98415@L-31X9LVDL-1304.local>
 <0f4edc1f-1ce2-95b4-5866-5c4888db7c65@redhat.com>
 <20200622215520.wa6gjr2hplurwy57@master>
 <4b7ee49c-9bee-a905-3497-e3addd8896b8@redhat.com>
 <c0b62330-11d3-e628-a811-b54789d8f182@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0b62330-11d3-e628-a811-b54789d8f182@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:55:43AM +0200, David Hildenbrand wrote:
>On 23.06.20 09:39, David Hildenbrand wrote:
>>> Hmm.. I thought this is the behavior for early section, while it looks current
>>> code doesn't work like this:
>>>
>>>        if (section_is_early && memmap)
>>>                free_map_bootmem(memmap);
>>>        else
>>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>>
>>> section_is_early is always "true" for early section, while memmap is not-NULL
>>> only when sub-section map is empty.
>>>
>>> If my understanding is correct, when we remove a sub-section in early section,
>>> the code would call depopulate_section_memmap(), which in turn free related
>>> memmap. By removing the memmap, the return value from pfn_to_online_page() is
>>> not a valid one.
>> 
>> I think you're right, and pfn_valid() would also return true, as it is
>> an early section. This looks broken.
>> 
>>>
>>> Maybe we want to write the code like this:
>>>
>>>        if (section_is_early)
>>>                if (memmap)
>>>                        free_map_bootmem(memmap);
>>>        else
>>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>>
>> 
>> I guess that should be the way to go
>> 
>> @Dan, I think what Wei proposes here is correct, right? Or how does it
>> work in the VMEMMAP case with early sections?
>> 
>
>Especially, if you would re-hot-add, section_activate() would assume
>there is a memmap, it must not be removed.
>

You are right here. I didn't notice it.

>@Wei, can you send a patch?
>

Sure, let me prepare for it.

>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
