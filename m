Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D726BE89
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgIPHwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgIPHwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600242760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gatuFDoANgKmG0wqNObZOOy2jkgf5G/5dsofuvphf9M=;
        b=Tg+zPzP4tLCicC27k1SWVowt3ASVXwZDR5mafYhfaG3ANWBI/Uj+TpoAXDvAdCP4Iq91BM
        nvejVsByiIofIJ5uuhehyd1zq/syPelKHWRnMYYYNG+rGoPv1Bt0Copjt0zwQ3K9OfCXxt
        4KkODix4nOtE5AGJq3/+tfndAChGGQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-oUTlp6IEP0GIft-o2b1B5A-1; Wed, 16 Sep 2020 03:52:36 -0400
X-MC-Unique: oUTlp6IEP0GIft-o2b1B5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35D7B1084C8B;
        Wed, 16 Sep 2020 07:52:34 +0000 (UTC)
Received: from [10.36.113.190] (ovpn-113-190.ams2.redhat.com [10.36.113.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AEF967CF0;
        Wed, 16 Sep 2020 07:52:31 +0000 (UTC)
Subject: Re: [PATCH v3 1/3] mm: replace memmap_context by meminit_context
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, Oscar Salvador <osalvador@suse.de>,
        mhocko@suse.com, linux-mm@kvack.org,
        "Rafael J . Wysocki" <rafael@kernel.org>, nathanl@linux.ibm.com,
        cheloha@linux.ibm.com, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200915121541.GD4649@dhcp22.suse.cz>
 <20200915132624.9723-1-ldufour@linux.ibm.com>
 <20200916063325.GK142621@kroah.com>
 <0b3f2eb1-0efa-a491-c509-d16a7e18d8e8@linux.ibm.com>
 <20200916074047.GA189144@kroah.com>
 <9e8d38b9-3875-0fd8-5f28-3502f33c2c34@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAlgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63W5Ag0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAGJAjwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <95005625-b159-0d49-8334-3c6cdbb7f27a@redhat.com>
Date:   Wed, 16 Sep 2020 09:52:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <9e8d38b9-3875-0fd8-5f28-3502f33c2c34@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.09.20 09:47, Laurent Dufour wrote:
> Le 16/09/2020 à 09:40, Greg Kroah-Hartman a écrit :
>> On Wed, Sep 16, 2020 at 09:29:22AM +0200, Laurent Dufour wrote:
>>> Le 16/09/2020 à 08:33, Greg Kroah-Hartman a écrit :
>>>> On Tue, Sep 15, 2020 at 03:26:24PM +0200, Laurent Dufour wrote:
>>>>> The memmap_context enum is used to detect whether a memory operation is due
>>>>> to a hot-add operation or happening at boot time.
>>>>>
>>>>> Make it general to the hotplug operation and rename it as meminit_context.
>>>>>
>>>>> There is no functional change introduced by this patch
>>>>>
>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>>>>> ---
>>>>>    arch/ia64/mm/init.c    |  6 +++---
>>>>>    include/linux/mm.h     |  2 +-
>>>>>    include/linux/mmzone.h | 11 ++++++++---
>>>>>    mm/memory_hotplug.c    |  2 +-
>>>>>    mm/page_alloc.c        | 10 +++++-----
>>>>>    5 files changed, 18 insertions(+), 13 deletions(-)
>>>>
>>>> <formletter>
>>>>
>>>> This is not the correct way to submit patches for inclusion in the
>>>> stable kernel tree.  Please read:
>>>>       https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>>> for how to do this properly.
>>>>
>>>> </formletter>
>>>
>>> Hi Greg,
>>>
>>> I'm sorry, I read that document few days ago before sending the series and
>>> again this morning, but I can't figure out what I missed (following option
>>> 1).
>>>
>>> Should the "Cc: stable@vger.kernel.org" tag be on each patch of the series
>>> even if the whole series has been sent to stable ?
>>
>> That should be on any patch you expect to show up in a stable kernel
>> release.
>>
>>> Should the whole series sent again (v4) instead of sending a fix as a reply to ?
>>
>> It's up to the maintainer what they want, but as it is, this patch is
>> not going to end up in stable kernel release (which it looks like is the
>> right thing to do...)
> 
> Thanks a lot Greg.
> 
> I'll send that single patch again with the Cc: stable tag.

I think Andrew can add that when sending upstream.

While a single patch to fix + backport would be nicer, I don't see an
easy (!ugly) way to achieve the same without this cleanup.

1. We could rework patch #2 to pass a simple boolean flag, and a
follow-on patch to pass the context. Not sure if that's any better.

2. We could rework patch #2 to pass memmap_context first, and modify
patch #1 to also rename this instance.

Maybe 2. might be reasonable (not sure if worth the trouble). @Greg any
preference?

> 
> I don't think the patch 3 need to be backported, it doesn't fix any issue and 
> with the patch 1 and 2 applied, the BUG_ON should no more be triggered easily.

Agreed.


-- 
Thanks,

David / dhildenb

