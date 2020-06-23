Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44A2204BC0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbgFWH4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:56:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731041AbgFWH4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592899004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ukx1hacRLHii4Tr29PpWUQfn5bNHMiMZalColj3Y9os=;
        b=ap/PaUFJqB5nLN0dTQlDCciFJqJRgaIluwwTf4/7fwvFeHSNzWlw23EuY4U3fgh3GnanBE
        /RRHTWVUkRYabLYD/u+vVPzxq94oDxIO7VfIEVGfW6eOeO8nTZ4NZUyLedfFVX878M/KRR
        9skajHu02v6b4S6Le0KjWT65qeh7zSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-CeFrUHe4N1S6n9FIVEouTQ-1; Tue, 23 Jun 2020 03:56:42 -0400
X-MC-Unique: CeFrUHe4N1S6n9FIVEouTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A6B713BF2;
        Tue, 23 Jun 2020 07:55:46 +0000 (UTC)
Received: from [10.36.113.187] (ovpn-113-187.ams2.redhat.com [10.36.113.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0118A7CCEE;
        Tue, 23 Jun 2020 07:55:43 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
From:   David Hildenbrand <david@redhat.com>
To:     Wei Yang <richard.weiyang@gmail.com>
Cc:     Wei Yang <richard.weiyang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Dan Williams <dan.j.williams@intel.com>
References: <20200619125923.22602-1-david@redhat.com>
 <20200619125923.22602-2-david@redhat.com>
 <20200622082635.GA93552@L-31X9LVDL-1304.local>
 <2185539f-b210-5d3f-5da2-a497b354eebb@redhat.com>
 <20200622092221.GA96699@L-31X9LVDL-1304.local>
 <34f36733-805e-cc61-38da-2ee578ae096c@redhat.com>
 <20200622131003.GA98415@L-31X9LVDL-1304.local>
 <0f4edc1f-1ce2-95b4-5866-5c4888db7c65@redhat.com>
 <20200622215520.wa6gjr2hplurwy57@master>
 <4b7ee49c-9bee-a905-3497-e3addd8896b8@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <c0b62330-11d3-e628-a811-b54789d8f182@redhat.com>
Date:   Tue, 23 Jun 2020 09:55:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4b7ee49c-9bee-a905-3497-e3addd8896b8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.06.20 09:39, David Hildenbrand wrote:
>> Hmm.. I thought this is the behavior for early section, while it looks current
>> code doesn't work like this:
>>
>>        if (section_is_early && memmap)
>>                free_map_bootmem(memmap);
>>        else
>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>
>> section_is_early is always "true" for early section, while memmap is not-NULL
>> only when sub-section map is empty.
>>
>> If my understanding is correct, when we remove a sub-section in early section,
>> the code would call depopulate_section_memmap(), which in turn free related
>> memmap. By removing the memmap, the return value from pfn_to_online_page() is
>> not a valid one.
> 
> I think you're right, and pfn_valid() would also return true, as it is
> an early section. This looks broken.
> 
>>
>> Maybe we want to write the code like this:
>>
>>        if (section_is_early)
>>                if (memmap)
>>                        free_map_bootmem(memmap);
>>        else
>> 	       depopulate_section_memmap(pfn, nr_pages, altmap);
>>
> 
> I guess that should be the way to go
> 
> @Dan, I think what Wei proposes here is correct, right? Or how does it
> work in the VMEMMAP case with early sections?
> 

Especially, if you would re-hot-add, section_activate() would assume
there is a memmap, it must not be removed.

@Wei, can you send a patch?

-- 
Thanks,

David / dhildenb

