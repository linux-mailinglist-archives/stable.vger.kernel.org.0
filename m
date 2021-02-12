Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2D7319C7E
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBLKSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:18:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhBLKSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 05:18:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613124999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K89LA8Ozpxu/REPXjq8jdde5J4XMhRa6v2Bjz/+EfdE=;
        b=hltD04bbzSQM1rj+UyKrK27o48wWB/aJ6qFml2SOcmHTLOY8xCgIiUzzXYgiIj/6GyUarB
        m+XhDOP5Plzq+I0FNh8COE5Rjt0mi+lkixUK/mjgP4F/DTYtGhw/fZAVcaIBalb/Zc8DmF
        WFZfLEybD5nKW6CTHEsgr3jKl8gWaSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-vkweBHaqPKi87kqAwe3uCw-1; Fri, 12 Feb 2021 05:16:35 -0500
X-MC-Unique: vkweBHaqPKi87kqAwe3uCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF137801962;
        Fri, 12 Feb 2021 10:16:32 +0000 (UTC)
Received: from [10.36.114.178] (ovpn-114-178.ams2.redhat.com [10.36.114.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D34B1F456;
        Fri, 12 Feb 2021 10:16:28 +0000 (UTC)
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
References: <20210208110820.6269-1-rppt@kernel.org>
 <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
 <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
 <YCZUOf0jGyWx0IwL@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <1523f1a6-41be-1fc7-08b9-b777a5b4ef24@redhat.com>
Date:   Fri, 12 Feb 2021 11:16:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YCZUOf0jGyWx0IwL@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.02.21 11:11, Michal Hocko wrote:
> On Fri 12-02-21 10:56:19, David Hildenbrand wrote:
>> On 12.02.21 10:55, David Hildenbrand wrote:
>>> On 08.02.21 12:08, Mike Rapoport wrote:
> [...]
>>>> @@ -6519,8 +6581,19 @@ void __init get_pfn_range_for_nid(unsigned int nid,
>>>>     		*end_pfn = max(*end_pfn, this_end_pfn);
>>>>     	}
>>>> -	if (*start_pfn == -1UL)
>>>> +	if (*start_pfn == -1UL) {
>>>>     		*start_pfn = 0;
>>>> +		return;
>>>> +	}
>>>> +
>>>> +#ifdef CONFIG_SPARSEMEM
>>>> +	/*
>>>> +	 * Sections in the memory map may not match actual populated
>>>> +	 * memory, extend the node span to cover the entire section.
>>>> +	 */
>>>> +	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
>>>> +	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
>>>
>>> Does that mean that we might create overlapping zones when one node
>>
>> s/overlapping zones/overlapping nodes/
> 
> I didn't get to review the patch yet. Just wanted to note that we can
> interleave nodes/zone. Or what kind of concern do you have in mind?

I know that we can have it after boot, when hotplugging memory. How 
about during boot?

For example, which node will a PFN then actually be assigned to?

I was just wondering if this might result in issues - if that can 
already happen, then it's just fine I guess.

-- 
Thanks,

David / dhildenb

