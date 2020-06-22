Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0346920430A
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgFVVzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgFVVzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 17:55:23 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8FC061573;
        Mon, 22 Jun 2020 14:55:23 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id cy7so8347507edb.5;
        Mon, 22 Jun 2020 14:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nmfIOoEWXQO5UWb+x+hANhrwfKmxtwc9Q6sKQna/1nE=;
        b=sUTCrE3XZcHOHhseT6Y556ECknuW8UzGRbGvF/PeTsQJv5nHMVp8C+CzbsAthKHDek
         Xn7AxhjKalej5xjICem+AzkKwcZd+/8PLK1QuEU8qeL8tcG1bpUvcd1ULVs61cE/QNGQ
         cSUQ/SkN1O4ktrEBtLRCYptPUa3QbLdlQPo7OojCrfDS5i9/O5bd1aFf4z4oPOMYcy5T
         liveyfCQSAGBOhsx1bnIPv+zMjLUVuJ+RU6IKEQP3J7CEYc4UMVQ+Gy4DSJmxte+8cr2
         vZ9+E3wKwFCJWdgYeoOEEMgNszKF6J2nn3nGVtGfOmarhThQNDbs8di/jELfovfT7Ahn
         Jb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nmfIOoEWXQO5UWb+x+hANhrwfKmxtwc9Q6sKQna/1nE=;
        b=hDY7RqX6UnC2n762WgvdUyacrD9r5KsYsE4XA1pvbF7eUgPuwyLCWO4gOhQXCDAejA
         0A8lbsRfvB0bbrDoIjyXpOPDq+CbfZLniLd922ZQAkf10k0E5hByGmexNVDNeaAevzeL
         N4+sjaaTW7TA2dFZsvUCbzhXvPDVs42PJnwS51dmpRMTPxBwJW7RlcozztpnDhc7qwpE
         /MkuVBodJT3YgIvQK94//6m1lhxHsjCjtOkk4qv4InE7bmQSEvCBs73RygSelr3zondq
         nQPbIITARkn7IQJ8R3yCrsZ14zZu0GbMIpnV3SGgLRMeyeGTwU+VF9+PN4EJYRwYYA4a
         AA2g==
X-Gm-Message-State: AOAM530JqgPlAq2Dj1eDFklynXEmYK9mYYXDU674Z+OfHGCUVBm+qcpe
        yzlZaOjnaCZ/5H3cB5DMvVY=
X-Google-Smtp-Source: ABdhPJwwzYAjzPJc9JcvFrneSsdHo8tneX8UZylPARKhvEl31XokOrUWK7ELxb31eXR3WO3LqlgNzQ==
X-Received: by 2002:a05:6402:228a:: with SMTP id cw10mr18284650edb.147.1592862922100;
        Mon, 22 Jun 2020 14:55:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id s2sm13470122edu.39.2020.06.22.14.55.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2020 14:55:21 -0700 (PDT)
Date:   Mon, 22 Jun 2020 21:55:20 +0000
From:   Wei Yang <richard.weiyang@gmail.com>
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
Message-ID: <20200622215520.wa6gjr2hplurwy57@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20200619125923.22602-1-david@redhat.com>
 <20200619125923.22602-2-david@redhat.com>
 <20200622082635.GA93552@L-31X9LVDL-1304.local>
 <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
 <20200622092221.GA96699@L-31X9LVDL-1304.local>
 <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
 <20200622131003.GA98415@L-31X9LVDL-1304.local>
 <0f4edc1f-1ce2-95b4-5866-5c4888db7c65@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f4edc1f-1ce2-95b4-5866-5c4888db7c65@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 04:06:15PM +0200, David Hildenbrand wrote:
>On 22.06.20 15:10, Wei Yang wrote:
>> On Mon, Jun 22, 2020 at 11:51:34AM +0200, David Hildenbrand wrote:
>>> On 22.06.20 11:22, Wei Yang wrote:
>>>> On Mon, Jun 22, 2020 at 10:43:11AM +0200, David Hildenbrand wrote:
>>>>> On 22.06.20 10:26, Wei Yang wrote:
>>>>>> On Fri, Jun 19, 2020 at 02:59:20PM +0200, David Hildenbrand wrote:
>>>>>>> Especially with memory hotplug, we can have offline sections (with a
>>>>>>> garbage memmap) and overlapping zones. We have to make sure to only
>>>>>>> touch initialized memmaps (online sections managed by the buddy) and that
>>>>>>> the zone matches, to not move pages between zones.
>>>>>>>
>>>>>>> To test if this can actually happen, I added a simple
>>>>>>> 	BUG_ON(page_zone(page_i) != page_zone(page_j));
>>>>>>> right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM and
>>>>>>> onlining the first memory block "online_movable" and the second memory
>>>>>>> block "online_kernel", it will trigger the BUG, as both zones (NORMAL
>>>>>>> and MOVABLE) overlap.
>>>>>>>
>>>>>>> This might result in all kinds of weird situations (e.g., double
>>>>>>> allocations, list corruptions, unmovable allocations ending up in the
>>>>>>> movable zone).
>>>>>>>
>>>>>>> Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
>>>>>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>>>>> Cc: stable@vger.kernel.org # v5.2+
>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>>>>> Cc: Minchan Kim <minchan@kernel.org>
>>>>>>> Cc: Huang Ying <ying.huang@intel.com>
>>>>>>> Cc: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Cc: Mel Gorman <mgorman@techsingularity.net>
>>>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>>>> ---
>>>>>>> mm/shuffle.c | 18 +++++++++---------
>>>>>>> 1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/shuffle.c b/mm/shuffle.c
>>>>>>> index 44406d9977c77..dd13ab851b3ee 100644
>>>>>>> --- a/mm/shuffle.c
>>>>>>> +++ b/mm/shuffle.c
>>>>>>> @@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
>>>>>>>  * For two pages to be swapped in the shuffle, they must be free (on a
>>>>>>>  * 'free_area' lru), have the same order, and have the same migratetype.
>>>>>>>  */
>>>>>>> -static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
>>>>>>> +static struct page * __meminit shuffle_valid_page(struct zone *zone,
>>>>>>> +						  unsigned long pfn, int order)
>>>>>>> {
>>>>>>> -	struct page *page;
>>>>>>> +	struct page *page = pfn_to_online_page(pfn);
>>>>>>
>>>>>> Hi, David and Dan,
>>>>>>
>>>>>> One thing I want to confirm here is we won't have partially online section,
>>>>>> right? We can add a sub-section to system, but we won't manage it by buddy.
>>>>>
>>>>> Hi,
>>>>>
>>>>> there is still a BUG with sub-section hot-add (devmem), which broke
>>>>> pfn_to_online_page() in corner cases (especially, see the description in
>>>>> include/linux/mmzone.h). We can have a boot-memory section partially
>>>>> populated and marked online. Then, we can hot-add devmem, marking the
>>>>> remaining pfns valid - and as the section is maked online, also as online.
>>>>
>>>> Oh, yes, I see this description.
>>>>
>>>> This means we could have section marked as online, but with a sub-section even
>>>> not added.
>>>>
>>>> While the good news is even the sub-section is not added, but its memmap is
>>>> populated for an early section. So the page returned from pfn_to_online_page()
>>>> is a valid one.
>>>>
>>>> But what would happen, if the sub-section is removed after added? Would
>>>> section_deactivate() release related memmap to this "struct page"?
>>>
>>> If devmem is removed, the memmap will be freed and the sub-sections are
>>> marked as non-present. So this works as expected.
>>>
>> 
>> Sorry, I may not catch your point. If my understanding is correct, the
>> above behavior happens in function section_deactivate().
>> 
>> Let me draw my understanding of function section_deactivate():
>> 
>>     section_deactivate(pfn, nr_pages)
>>         clear_subsection_map(pfn, nr_pages)
>> 	depopulate_section_memmap(pfn, nr_pages)
>> 
>> Since we just remove a sub-section, I skipped some un-related codes. These two
>> functions would:
>> 
>>   * clear bitmap in ms->usage->subsection_map
>>   * free memmap for the sub-section
>> 
>> While since the section is not empty, ms->section_mem_map is not set no null.
>
>Let me clarify, sub-section hotremove works differently when overlying
>with (online) boot memory within a section.
>
>Early sections (IOW, boot memory) are never partially removed. See

Thanks for your time and patience. 

Looked into the comment of section_deactivate():

 * 1. deactivation of a partial hot-added section (only possible in
 *    the SPARSEMEM_VMEMMAP=y case).
 *      a) section was present at memory init.
 *      b) section was hot-added post memory init.

Case a) seems do partial remove for an early section?

>mm/sparse.c:section_deactivate(). We only free a early memmap when the
>section is completely empty. Also see how

Hmm.. I thought this is the behavior for early section, while it looks current
code doesn't work like this:

       if (section_is_early && memmap)
               free_map_bootmem(memmap);
       else
	       depopulate_section_memmap(pfn, nr_pages, altmap);

section_is_early is always "true" for early section, while memmap is not-NULL
only when sub-section map is empty.

If my understanding is correct, when we remove a sub-section in early section,
the code would call depopulate_section_memmap(), which in turn free related
memmap. By removing the memmap, the return value from pfn_to_online_page() is
not a valid one.

Maybe we want to write the code like this:

       if (section_is_early)
               if (memmap)
                       free_map_bootmem(memmap);
       else
	       depopulate_section_memmap(pfn, nr_pages, altmap);

This makes sure we only free memmap for early section only when the whole
section is removed.

>include/linux/mmzone.h:pfn_valid() handles early sections.
>
>So when we have a partially present section with boot memory, we
>a) marked the whole section present and online (there is only a single
>   bit)
>b) allocated the memmap for the whole section
>c) Only exposed the relevant pages to the buddy. The memmap of non-
>   present parts in a section were initialized and are reserved.
>
>pfn_valid() will return for all non-present pfns valid, because there is
>a memmap. pfn_to_online_page() will return for all pfns "true", because
>we only have a single bit for the whole section. This has been the case
>before sub-section hotplug and is still the case. It simply looks like
>just another memory hole for which we have a memmap.
>
>Now, with devmem it is possible to suddenly change these sub-section
>holes (memmaps) to become ZONE_DEVICE memory. pfn_to_online_page() would
>have to detect that and report a "false". Possible fixes were already
>discussed (e.g., sub-section online map instead of a single bit).
>
>Again, the zone check safes us from the worst, just as in the case of
>all other pfn walkers that use (as documented) pfn_to_online_page(). It
>still needs a fix as dicussed, but it seems to work reasonably fine like
>that for now.
>
>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
