Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CE2033FF
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgFVJvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 05:51:49 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgFVJvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 05:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592819507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=YcUY3qEY5cRFSsafv1DoAFJJRP+uzaGGotLPOGTbb7c=;
        b=ZKcwj0v0Wi+4CrIYO55XZRL5oPR2dch26CEYGsWsy7joRM5aY8eyaqQP0fdFYVcy/oBMSh
        3m4OZ9wddsEJQcS3hzSvualAGGok+3My82GesXtzaIcki6k8kC81Lg23BAPNUWBjTGi7o9
        73Tef6HDK8VTrCiYgrC6DMrcUXCdaaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-kqOuQk6hN-m7DTcLPt_1ZQ-1; Mon, 22 Jun 2020 05:51:43 -0400
X-MC-Unique: kqOuQk6hN-m7DTcLPt_1ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD77184D140;
        Mon, 22 Jun 2020 09:51:41 +0000 (UTC)
Received: from [10.36.113.213] (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20E3419D61;
        Mon, 22 Jun 2020 09:51:35 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
To:     Wei Yang <richard.weiyang@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
References: <20200619125923.22602-1-david@redhat.com>
 <20200619125923.22602-2-david@redhat.com>
 <20200622082635.GA93552@L-31X9LVDL-1304.local>
 <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
 <20200622092221.GA96699@L-31X9LVDL-1304.local>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
Date:   Mon, 22 Jun 2020 11:51:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622092221.GA96699@L-31X9LVDL-1304.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.06.20 11:22, Wei Yang wrote:
> On Mon, Jun 22, 2020 at 10:43:11AM +0200, David Hildenbrand wrote:
>> On 22.06.20 10:26, Wei Yang wrote:
>>> On Fri, Jun 19, 2020 at 02:59:20PM +0200, David Hildenbrand wrote:
>>>> Especially with memory hotplug, we can have offline sections (with a
>>>> garbage memmap) and overlapping zones. We have to make sure to only
>>>> touch initialized memmaps (online sections managed by the buddy) and that
>>>> the zone matches, to not move pages between zones.
>>>>
>>>> To test if this can actually happen, I added a simple
>>>> 	BUG_ON(page_zone(page_i) != page_zone(page_j));
>>>> right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM and
>>>> onlining the first memory block "online_movable" and the second memory
>>>> block "online_kernel", it will trigger the BUG, as both zones (NORMAL
>>>> and MOVABLE) overlap.
>>>>
>>>> This might result in all kinds of weird situations (e.g., double
>>>> allocations, list corruptions, unmovable allocations ending up in the
>>>> movable zone).
>>>>
>>>> Fixes: e900a918b098 ("mm: shuffle initial free memory to improve memory-side-cache utilization")
>>>> Acked-by: Michal Hocko <mhocko@suse.com>
>>>> Cc: stable@vger.kernel.org # v5.2+
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>> Cc: Michal Hocko <mhocko@suse.com>
>>>> Cc: Minchan Kim <minchan@kernel.org>
>>>> Cc: Huang Ying <ying.huang@intel.com>
>>>> Cc: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Mel Gorman <mgorman@techsingularity.net>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>> mm/shuffle.c | 18 +++++++++---------
>>>> 1 file changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/shuffle.c b/mm/shuffle.c
>>>> index 44406d9977c77..dd13ab851b3ee 100644
>>>> --- a/mm/shuffle.c
>>>> +++ b/mm/shuffle.c
>>>> @@ -58,25 +58,25 @@ module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
>>>>  * For two pages to be swapped in the shuffle, they must be free (on a
>>>>  * 'free_area' lru), have the same order, and have the same migratetype.
>>>>  */
>>>> -static struct page * __meminit shuffle_valid_page(unsigned long pfn, int order)
>>>> +static struct page * __meminit shuffle_valid_page(struct zone *zone,
>>>> +						  unsigned long pfn, int order)
>>>> {
>>>> -	struct page *page;
>>>> +	struct page *page = pfn_to_online_page(pfn);
>>>
>>> Hi, David and Dan,
>>>
>>> One thing I want to confirm here is we won't have partially online section,
>>> right? We can add a sub-section to system, but we won't manage it by buddy.
>>
>> Hi,
>>
>> there is still a BUG with sub-section hot-add (devmem), which broke
>> pfn_to_online_page() in corner cases (especially, see the description in
>> include/linux/mmzone.h). We can have a boot-memory section partially
>> populated and marked online. Then, we can hot-add devmem, marking the
>> remaining pfns valid - and as the section is maked online, also as online.
> 
> Oh, yes, I see this description.
> 
> This means we could have section marked as online, but with a sub-section even
> not added.
> 
> While the good news is even the sub-section is not added, but its memmap is
> populated for an early section. So the page returned from pfn_to_online_page()
> is a valid one.
> 
> But what would happen, if the sub-section is removed after added? Would
> section_deactivate() release related memmap to this "struct page"?

If devmem is removed, the memmap will be freed and the sub-sections are
marked as non-present. So this works as expected.

-- 
Thanks,

David / dhildenb

