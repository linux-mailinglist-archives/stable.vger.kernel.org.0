Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7B29BC12
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764217AbgJ0QbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:31:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:47810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763851AbgJ0QbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 12:31:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9EACBAFF2;
        Tue, 27 Oct 2020 16:31:17 +0000 (UTC)
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20201027140926.276-1-ldufour@linux.ibm.com>
 <20201027142421.GW20500@dhcp22.suse.cz>
 <11bdd295-3ef8-fbeb-2c76-2a109fa26f19@linux.ibm.com>
 <20201027150350.GZ20500@dhcp22.suse.cz>
 <e2cea72f-d8fa-0ac7-e48d-63cc41414ed2@linux.ibm.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/slub: fix panic in slab_alloc_node()
Message-ID: <7ef64e75-2150-01a9-074d-a754348683b3@suse.cz>
Date:   Tue, 27 Oct 2020 17:31:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <e2cea72f-d8fa-0ac7-e48d-63cc41414ed2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/20 4:12 PM, Laurent Dufour wrote:
> Le 27/10/2020 à 16:03, Michal Hocko a écrit :
>> On Tue 27-10-20 15:39:46, Laurent Dufour wrote:
>>> Le 27/10/2020 à 15:24, Michal Hocko a écrit :
>>>> [Cc Vlastimil]
>>>>
>>>> On Tue 27-10-20 15:09:26, Laurent Dufour wrote:
>>>>
>>>> Could you be more specific? I am especially confused how the memory
>>>> hotplug is involved here. What kind of flush are we talking about?
>>>
>>> This happens when flush_cpu_slab() is called when a memory block is about to
>>> be offlined, see slab_mem_going_offline_callback() called by the
>>> MEM_GOING_OFFLINE's callback triggered by offline_pages().
>> 
>> This would be a very valuable information for the changelog. I have to
>> admit that a more detailed description would help somebody not really
>> familiar with slub internals like me.

Agreed, please include that.

>> I still fail to see why do we get an inconsistent state though. I
>> thought that no object is associated with an offlined page so how come
>> we have an object without any page?
> 
> The inconsistent state came from the IPI interrupt calling flush_cpu_slab()
> being taken between reading c->freelist and c->page.

Yes; also good to state explicitly.

>> How does this allocation path synchronizes with the offline callback?
> 
> My understanding is that this is done by the call to this_cpu_cmpxchg_double()
> done later, but I would let the slub experts detail that point.

Yes, cmpxchg will detect that c->freelist changed. If we managed to read both 
c->freelist and c->page before the interrupt (and thus not crash), 
cmpxchg_double will fail on the s->cpu_slab->tid part as flush_slab() will also 
bump the tid.

>>>>> In commit 6159d0f5c03e ("mm/slub.c: page is always non-NULL in
>>>>> node_match()") check on the page pointer has been removed assuming that
>>>>> page is always valid when it is called. It happens that this is not true in
>>>>> that particular case, so check for page before calling node_match() here.
>>>>>
>>>>> Fixes: 6159d0f5c03e ("mm/slub.c: page is always non-NULL in node_match()")
>>>>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

With the expanded changelog,

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Thanks!

>>>>> Cc: Christoph Lameter <cl@linux.com>
>>>>> Cc: Pekka Enberg <penberg@kernel.org>
>>>>> Cc: David Rientjes <rientjes@google.com>
>>>>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: stable@vger.kernel.org
>>>>> ---
>>>>>    mm/slub.c | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>> index 8f66de8a5ab3..7dc5c6aaf4b7 100644
>>>>> --- a/mm/slub.c
>>>>> +++ b/mm/slub.c
>>>>> @@ -2852,7 +2852,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
>>>>>    	object = c->freelist;
>>>>>    	page = c->page;
>>>>> -	if (unlikely(!object || !node_match(page, node))) {
>>>>> +	if (unlikely(!object || !page || !node_match(page, node))) {
>>>>>    		object = __slab_alloc(s, gfpflags, node, addr, c);
>>>>>    	} else {
>>>>>    		void *next_object = get_freepointer_safe(s, object);
>>>>> -- 
>>>>> 2.29.1
>>>>>
>>>>
>>>
>> 
> 
> 

