Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631AD203786
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgFVNKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 09:10:09 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41738 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728318AbgFVNKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 09:10:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=richard.weiyang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0U0OSU9i_1592831403;
Received: from localhost(mailfrom:richard.weiyang@linux.alibaba.com fp:SMTPD_---0U0OSU9i_1592831403)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Jun 2020 21:10:04 +0800
Date:   Mon, 22 Jun 2020 21:10:03 +0800
From:   Wei Yang <richard.weiyang@linux.alibaba.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Wei Yang <richard.weiyang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Message-ID: <20200622131003.GA98415@L-31X9LVDL-1304.local>
Reply-To: Wei Yang <richard.weiyang@linux.alibaba.com>
References: <20200619125923.22602-1-david@redhat.com>
 <20200619125923.22602-2-david@redhat.com>
 <20200622082635.GA93552@L-31X9LVDL-1304.local>
 <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
 <20200622092221.GA96699@L-31X9LVDL-1304.local>
 <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 11:51:34AM +0200, David Hildenbrand wrote:
>On 22.06.20 11:22, Wei Yang wrote:
>> On Mon, Jun 22, 2020 at 10:43:11AM +0200, David Hildenbrand wrote:
>>> On 22.06.20 10:26, Wei Yang wrote:
>>>> On Fri, Jun 19, 2020 at 02:59:20PM +0200, David Hildenbrand wrote:
>>>>> Especially with memory hotplug, we can have offline sections (with a
>>>>> garbage memmap) and overlapping zones. We have to make sure to only
>>>>> touch initialized memmaps (online sections managed by the buddy) and that
>>>>> the zone matches, to not move pages between zones.
>>>>>
>>>>> To test if this can actually happen, I added a simple
>>>>> 	BUG_ON(page_zone(page_i) != page_zone(page_j));
>>>>> right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM and
>>>>> onlining the first memory block "online_movable" and the second memory
>>>>> block "online_kernel", it will trigger the BUG, as both zones (NORMAL
>>>>> and MOVABLE) overlap.
>>>>>
>>>>> This might result in all kinds of weird situations (e.g., double
>>>>> allocations, list corruptions, unmovable allocations ending up in the
>>>>> movable zone).
>>>>>
>>>>> Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
>>>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>>> Cc: stable@vger.kernel.org # v5.2+
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>>> Cc: Minchan Kim <minchan@kernel.org>
>>>>> Cc: Huang Ying <ying.huang@intel.com>
>>>>> Cc: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Mel Gorman <mgorman@techsingularity.net>
>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>> ---
>>>>> mm/shuffle.c | 18 +++++++++---------
>>>>> 1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/mm/shuffle.c b/mm/shuffle.c
>>>>> index 44406d9977c77..dd13ab851b3ee 100644
>>>>> --- a/mm/shuffle.c
>>>>> +++ b/mm/shuffle.c
>>>>> @@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
>>>>>  * For two pages to be swapped in the shuffle, they must be free (on a
>>>>>  * 'free_area' lru), have the same order, and have the same migratetype.
>>>>>  */
>>>>> -static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
>>>>> +static struct page * __meminit shuffle_valid_page(struct zone *zone,
>>>>> +						  unsigned long pfn, int order)
>>>>> {
>>>>> -	struct page *page;
>>>>> +	struct page *page = pfn_to_online_page(pfn);
>>>>
>>>> Hi, David and Dan,
>>>>
>>>> One thing I want to confirm here is we won't have partially online section,
>>>> right? We can add a sub-section to system, but we won't manage it by buddy.
>>>
>>> Hi,
>>>
>>> there is still a BUG with sub-section hot-add (devmem), which broke
>>> pfn_to_online_page() in corner cases (especially, see the description in
>>> include/linux/mmzone.h). We can have a boot-memory section partially
>>> populated and marked online. Then, we can hot-add devmem, marking the
>>> remaining pfns valid - and as the section is maked online, also as online.
>> 
>> Oh, yes, I see this description.
>> 
>> This means we could have section marked as online, but with a sub-section even
>> not added.
>> 
>> While the good news is even the sub-section is not added, but its memmap is
>> populated for an early section. So the page returned from pfn_to_online_page()
>> is a valid one.
>> 
>> But what would happen, if the sub-section is removed after added? Would
>> section_deactivate() release related memmap to this "struct page"?
>
>If devmem is removed, the memmap will be freed and the sub-sections are
>marked as non-present. So this works as expected.
>

Sorry, I may not catch your point. If my understanding is correct, the
above behavior happens in function section_deactivate().

Let me draw my understanding of function section_deactivate():

    section_deactivate(pfn, nr_pages)
        clear_subsection_map(pfn, nr_pages)
	depopulate_section_memmap(pfn, nr_pages)

Since we just remove a sub-section, I skipped some un-related codes. These two
functions would:

  * clear bitmap in ms->usage->subsection_map
  * free memmap for the sub-section

While since the section is not empty, ms->section_mem_map is not set no null.

Per my understanding, the section present state is set in ms->section_mem_map
with SECTION_MARKED_PRESENT. It looks we don't clear it when just remote a
sub-section.

Do I miss something?

>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
