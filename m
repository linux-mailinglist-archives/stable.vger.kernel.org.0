Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4222C08E
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGXIUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 04:20:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726617AbgGXIUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 04:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595578834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=OyYC9tZLltn2ymf26MTZQD1S0k8Nc9T/lMl10VCfjlY=;
        b=IXsMb6/qUPzi158hQ3EHI1l3MIpKfBcjccL6nz6u7huzJZxEcISJojLF9c5x3qJs379F/a
        OKuE5uLc6o3dWS7Ov+pJgs8zWNpQMa2THUgM5D6KTD/k+uX1xt1VGsE0AZpeWaK7BNfIEo
        KanT2J56kta8KPcYFIWn3hi5Mjvgh10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-58dvOyc-MRS6SZHGfgGzgg-1; Fri, 24 Jul 2020 04:20:29 -0400
X-MC-Unique: 58dvOyc-MRS6SZHGfgGzgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FC7F10CE782;
        Fri, 24 Jul 2020 08:20:27 +0000 (UTC)
Received: from [10.36.113.94] (ovpn-113-94.ams2.redhat.com [10.36.113.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 511126FEFE;
        Fri, 24 Jul 2020 08:20:24 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
To:     Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richard.weiyang@linux.alibaba.com>
Cc:     Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Dan Williams <dan.j.williams@intel.com>
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
 <20200623093018.GA6069@L-31X9LVDL-1304.local>
 <20200723200846.768513d7c122ac11b6e73538@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <d16a2f0f-6150-d41b-f44c-96e8497bee72@redhat.com>
Date:   Fri, 24 Jul 2020 10:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723200846.768513d7c122ac11b6e73538@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.07.20 05:08, Andrew Morton wrote:
> On Tue, 23 Jun 2020 17:30:18 +0800 Wei Yang <richard.weiyang@linux.alibaba.com> wrote:
> 
>> On Tue, Jun 23, 2020 at 09:55:43AM +0200, David Hildenbrand wrote:
>>> On 23.06.20 09:39, David Hildenbrand wrote:
>>>>> Hmm.. I thought this is the behavior for early section, while it looks current
>>>>> code doesn't work like this:
>>>>>
>>>>>        if (section_is_early && memmap)
>>>>>                free_map_bootmem(memmap);
>>>>>        else
>>>>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>>>>
>>>>> section_is_early is always "true" for early section, while memmap is not-NULL
>>>>> only when sub-section map is empty.
>>>>>
>>>>> If my understanding is correct, when we remove a sub-section in early section,
>>>>> the code would call depopulate_section_memmap(), which in turn free related
>>>>> memmap. By removing the memmap, the return value from pfn_to_online_page() is
>>>>> not a valid one.
>>>>
>>>> I think you're right, and pfn_valid() would also return true, as it is
>>>> an early section. This looks broken.
>>>>
>>>>>
>>>>> Maybe we want to write the code like this:
>>>>>
>>>>>        if (section_is_early)
>>>>>                if (memmap)
>>>>>                        free_map_bootmem(memmap);
>>>>>        else
>>>>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>>>>
>>>>
>>>> I guess that should be the way to go
>>>>
>>>> @Dan, I think what Wei proposes here is correct, right? Or how does it
>>>> work in the VMEMMAP case with early sections?
>>>>
>>>
>>> Especially, if you would re-hot-add, section_activate() would assume
>>> there is a memmap, it must not be removed.
>>>
>>
>> You are right here. I didn't notice it.
>>
>>> @Wei, can you send a patch?
>>>
>>
>> Sure, let me prepare for it.
> 
> Still awaiting this, and the v3 patch was identical to this v2 patch.
> 
> It's tagged for -stable, so there's some urgency.  Should we just go
> ahead with the decently-tested v2?

This patch (mm/shuffle: don't move pages between zones and don't read
garbage memmaps) is good enough for upstream. While the issue reported
by Wei was valid (and needs to be fixed), the user in this patch is just
one of many affected users. Nothing special.

-- 
Thanks,

David / dhildenb

