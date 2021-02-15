Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9461A31B62B
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 10:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBOJGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 04:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230054AbhBOJGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 04:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613379922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wYf255FsvrtCNN5Ul57Yn87duN0irZY/yWNrSljvhYM=;
        b=aMXLuoSIrZUkjQNtfgjGS/+IcdqenK8ZN5aauCGXg0Jc8Iri8irnYeR9DOe5YKKVwtRpAA
        WXmnTKhkbYUGPMLa4D+228QB82RVkuZljcrgEBewz67BSOidHtjMVHRR7Y0l9429yiQW4Y
        QpFcSijOTZ1JeGLEzow6i/JejlB+KKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-DeEMrxd1MRmdBlFKPrEJbA-1; Mon, 15 Feb 2021 04:05:18 -0500
X-MC-Unique: DeEMrxd1MRmdBlFKPrEJbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC51A107ACC7;
        Mon, 15 Feb 2021 09:05:15 +0000 (UTC)
Received: from [10.36.114.89] (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F06360875;
        Mon, 15 Feb 2021 09:05:10 +0000 (UTC)
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
To:     Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz> <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c2da1e76-d2ea-04df-d258-cf8a87a397d6@redhat.com>
Date:   Mon, 15 Feb 2021 10:05:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.21 10:00, Michal Hocko wrote:
> On Sun 14-02-21 20:00:16, Mike Rapoport wrote:
>> On Fri, Feb 12, 2021 at 02:18:20PM +0100, Michal Hocko wrote:
>>> On Fri 12-02-21 11:42:15, David Hildenbrand wrote:
>>>> On 12.02.21 11:33, Michal Hocko wrote:
>>> [...]
>>>>> I have to digest this but my first impression is that this is more heavy
>>>>> weight than it needs to. Pfn walkers should normally obey node range at
>>>>> least. The first pfn is usually excluded but I haven't seen real
>>>>
>>>> We've seen examples where this is not sufficient. Simple example:
>>>>
>>>> Have your physical memory end within a memory section. Easy via QEMU, just
>>>> do a "-m 4000M". The remaining part of the last section has fake/wrong
>>>> node/zone info.
>>>
>>> Does this really matter though. If those pages are reserved then nobody
>>> will touch them regardless of their node/zone ids.
>>>
>>>> Hotplug memory. The node/zone gets resized such that PFN walkers might
>>>> stumble over it.
>>>>
>>>> The basic idea is to make sure that any initialized/"online" pfn belongs to
>>>> exactly one node/zone and that the node/zone spans that PFN.
>>>
>>> Yeah, this sounds like a good idea but what is the poper node for hole
>>> between two ranges associated with a different nodes/zones? This will
>>> always be a random number. We should have a clear way to tell "do not
>>> touch those pages" and PageReserved sounds like a good way to tell that.
>>   
>> Nobody should touch reserved pages, but I don't think we can ensure that.
> 
> Touching a reserved page which doesn't belong to you is a bug. Sure we
> cannot enforce that rule by runtime checks. But incorrect/misleading zone/node
> association is the least of the problem when somebody already does that.
> 
>> We can correctly set the zone links for the reserved pages for holes in the
>> middle of a zone based on the architecture constraints and with only the
>> holes in the beginning/end of the memory will be not spanned by any
>> node/zone which in practice does not seem to be a problem as the VM_BUG_ON
>> in set_pfnblock_flags_mask() never triggered on pfn 0.
> 
> I really fail to see what you mean by correct zone/node for a memory
> range which is not associated with any real node.
>   
>> I believe that any improvement in memory map consistency is a step forward.
> 
> I do agree but we are talking about a subtle bug (VM_BUG_ON) which would
> be better of with a simplistic fix first. You can work on consistency
> improvements on top of that.
> 
>>>>> problems with that. The VM_BUG_ON blowing up is really bad but as said
>>>>> above we can simply make it less offensive in presence of reserved pages
>>>>> as those shouldn't reach that path AFAICS normally.
>>>>
>>>> Andrea tried tried working around if via PG_reserved pages and it resulted
>>>> in quite some ugly code. Andrea also noted that we cannot rely on any random
>>>> page walker to do the right think when it comes to messed up node/zone info.
>>>
>>> I am sorry, I haven't followed previous discussions. Has the removal of
>>> the VM_BUG_ON been considered as an immediate workaround?
>>
>> It was never discussed, but I'm not sure it's a good idea.
>>
>> Judging by the commit message that introduced the VM_BUG_ON (commit
>> 86051ca5eaf5 ("mm: fix usemap initialization")) there was yet another
>> inconsistency in the memory map that required a special care.
> 
> Can we actually explore that path before adding yet additional
> complexity and potentially a very involved fix for a subtle problem?
> 
> Mel who is author of this code might help us out. I have to say I do not
> see the point for the VM_BUG_ON other than a better debuggability. If
> there is a real incosistency problem as a result then we should be
> handling that situation for non debugging kernels as well.
> 

I have no time to summarize, you can find the complete discussion (also 
involving Mel) at

https://lkml.kernel.org/r/20201121194506.13464-1-aarcange@redhat.com

-- 
Thanks,

David / dhildenb

