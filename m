Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DB595A76
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiHPLnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiHPLnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:43:24 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C575CE2;
        Tue, 16 Aug 2022 04:14:16 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a7so18301656ejp.2;
        Tue, 16 Aug 2022 04:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Obe6W2yJAm2883KwIBzstZcaq5UArNoMv3/JbWe7NcE=;
        b=ol/jKLpEFbBv3BqS83UeY2qw/lnNNyBpTrK+LR+N6+Ubl+19zBCck/zs/aykIt/dlq
         Y802tRdddGBPhtYuup4sU7C/T6sSB/ENt1tJcmjz1Fkpem0vRyAkc31rDK0qyWaHJfwF
         cXZS8kkn2NwHL1VZJrTC5Ie5LeB6Tvjvwu/0V9gZrriidpA4iWKcoW0cPlcIGzDiMRrD
         8zj5JYvX2iA4CnCE2dkCx3DH5RJntpS9M9pXmZMRt4Kpu2kOK3Y4tKNIEJGYfjeufjPp
         A/tE022C38nWR19ERR6XDGHwdvaOIGnVAsoiD85QL2n2pXTF1rzLftvLX9E2RJXR8tg1
         OYEg==
X-Gm-Message-State: ACgBeo037gc+foJF9xVWFU7HGKaGvc10NdPny4PCST/PfAKY/9fsYRYQ
        TqIeusOK53RXlxTzBXiioUE=
X-Google-Smtp-Source: AA6agR63aapTjtTsBOQSR6SdrrZzwMje5fjCLEyJsk2wtM4owBuwvgHz/uPtMfJia0MrAvT9GllXWw==
X-Received: by 2002:a17:907:da4:b0:733:f44:c96d with SMTP id go36-20020a1709070da400b007330f44c96dmr13095654ejc.546.1660648455093;
        Tue, 16 Aug 2022 04:14:15 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id f25-20020a50fc99000000b004424429afd4sm8317573edq.16.2022.08.16.04.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 04:14:14 -0700 (PDT)
Message-ID: <817356d8-2a5f-56a4-ca4e-03f5a185c8af@kernel.org>
Date:   Tue, 16 Aug 2022 13:14:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 5.19 0767/1157] kasan: fix zeroing vmalloc memory with
 HW_TAGS
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180510.173732661@linuxfoundation.org>
 <9b1474ea-8568-cdb5-72dc-51d577497f8a@kernel.org>
In-Reply-To: <9b1474ea-8568-cdb5-72dc-51d577497f8a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16. 08. 22, 13:04, Jiri Slaby wrote:
> On 15. 08. 22, 20:02, Greg Kroah-Hartman wrote:
>> From: Andrey Konovalov <andreyknvl@google.com>
>>
>> [ Upstream commit 6c2f761dad7851d8088b91063ccaea3c970efe78 ]
>>
>> HW_TAGS KASAN skips zeroing page_alloc allocations backing vmalloc
>> mappings via __GFP_SKIP_ZERO.  Instead, these pages are zeroed via
>> kasan_unpoison_vmalloc() by passing the KASAN_VMALLOC_INIT flag.
>>
>> The problem is that __kasan_unpoison_vmalloc() does not zero pages when
>> either kasan_vmalloc_enabled() or is_vmalloc_or_module_addr() fail.
>>
>> Thus:
>>
>> 1. Change __vmalloc_node_range() to only set KASAN_VMALLOC_INIT when
>>     __GFP_SKIP_ZERO is set.
>>
>> 2. Change __kasan_unpoison_vmalloc() to always zero pages when the
>>     KASAN_VMALLOC_INIT flag is set.
>>
>> 3. Add WARN_ON() asserts to check that KASAN_VMALLOC_INIT cannot be set
>>     in other early return paths of __kasan_unpoison_vmalloc().
>>
>> Also clean up the comment in __kasan_unpoison_vmalloc.
>>
>> Link: 
>> https://lkml.kernel.org/r/4bc503537efdc539ffc3f461c1b70162eea31cf6.1654798516.git.andreyknvl@google.com
>> Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS")
>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>> Cc: Marco Elver <elver@google.com>
>> Cc: Alexander Potapenko <glider@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   mm/kasan/hw_tags.c | 32 +++++++++++++++++++++++---------
>>   mm/vmalloc.c       | 10 +++++-----
>>   2 files changed, 28 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
>> index 9e1b6544bfa8..9ad8eff71b28 100644
>> --- a/mm/kasan/hw_tags.c
>> +++ b/mm/kasan/hw_tags.c
>> @@ -257,27 +257,37 @@ static void unpoison_vmalloc_pages(const void 
>> *addr, u8 tag)
>>       }
>>   }
>> +static void init_vmalloc_pages(const void *start, unsigned long size)
>> +{
>> +    const void *addr;
>> +
>> +    for (addr = start; addr < start + size; addr += PAGE_SIZE) {
>> +        struct page *page = virt_to_page(addr);
>> +
>> +        clear_highpage_kasan_tagged(page);
> 
> This breaks build on aarch64:
>> mm/kasan/hw_tags.c: In function 'init_vmalloc_pages':
>> mm/kasan/hw_tags.c:267:17: error: implicit declaration of function 
>> 'clear_highpage_kasan_tagged' [-Werror=implicit-function-declaration]

Which translates into: this is missing:
commit d9da8f6cf55eeca642c021912af1890002464c64
Author: Andrey Konovalov <andreyknvl@gmail.com>
Date:   Thu Jun 9 20:18:46 2022 +0200

     mm: introduce clear_highpage_kasan_tagged

>> +    }
>> +}
>> +
>>   void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>>                   kasan_vmalloc_flags_t flags)
>>   {
>>       u8 tag;
>>       unsigned long redzone_start, redzone_size;
>> -    if (!kasan_vmalloc_enabled())
>> -        return (void *)start;
>> -
>> -    if (!is_vmalloc_or_module_addr(start))
>> +    if (!kasan_vmalloc_enabled() || !is_vmalloc_or_module_addr(start)) {
>> +        if (flags & KASAN_VMALLOC_INIT)
>> +            init_vmalloc_pages(start, size);
>>           return (void *)start;
>> +    }
>>       /*
>> -     * Skip unpoisoning and assigning a pointer tag for non-VM_ALLOC
>> -     * mappings as:
>> +     * Don't tag non-VM_ALLOC mappings, as:
>>        *
>>        * 1. Unlike the software KASAN modes, hardware tag-based KASAN 
>> only
>>        *    supports tagging physical memory. Therefore, it can only 
>> tag a
>>        *    single mapping of normal physical pages.
>>        * 2. Hardware tag-based KASAN can only tag memory mapped with 
>> special
>> -     *    mapping protection bits, see arch_vmalloc_pgprot_modify().
>> +     *    mapping protection bits, see arch_vmap_pgprot_tagged().
>>        *    As non-VM_ALLOC mappings can be mapped outside of vmalloc 
>> code,
>>        *    providing these bits would require tracking all non-VM_ALLOC
>>        *    mappers.
>> @@ -289,15 +299,19 @@ void *__kasan_unpoison_vmalloc(const void 
>> *start, unsigned long size,
>>        *
>>        * For non-VM_ALLOC allocations, page_alloc memory is tagged as 
>> usual.
>>        */
>> -    if (!(flags & KASAN_VMALLOC_VM_ALLOC))
>> +    if (!(flags & KASAN_VMALLOC_VM_ALLOC)) {
>> +        WARN_ON(flags & KASAN_VMALLOC_INIT);
>>           return (void *)start;
>> +    }
>>       /*
>>        * Don't tag executable memory.
>>        * The kernel doesn't tolerate having the PC register tagged.
>>        */
>> -    if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
>> +    if (!(flags & KASAN_VMALLOC_PROT_NORMAL)) {
>> +        WARN_ON(flags & KASAN_VMALLOC_INIT);
>>           return (void *)start;
>> +    }
>>       tag = kasan_random_tag();
>>       start = set_tag(start, tag);
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index effd1ff6a4b4..a1ab9b472571 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3168,15 +3168,15 @@ void *__vmalloc_node_range(unsigned long size, 
>> unsigned long align,
>>       /*
>>        * Mark the pages as accessible, now that they are mapped.
>> -     * The init condition should match the one in post_alloc_hook()
>> -     * (except for the should_skip_init() check) to make sure that 
>> memory
>> -     * is initialized under the same conditions regardless of the 
>> enabled
>> -     * KASAN mode.
>> +     * The condition for setting KASAN_VMALLOC_INIT should complement 
>> the
>> +     * one in post_alloc_hook() with regards to the __GFP_SKIP_ZERO 
>> check
>> +     * to make sure that memory is initialized under the same 
>> conditions.
>>        * Tag-based KASAN modes only assign tags to normal non-executable
>>        * allocations, see __kasan_unpoison_vmalloc().
>>        */
>>       kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
>> -    if (!want_init_on_free() && want_init_on_alloc(gfp_mask))
>> +    if (!want_init_on_free() && want_init_on_alloc(gfp_mask) &&
>> +        (gfp_mask & __GFP_SKIP_ZERO))
>>           kasan_flags |= KASAN_VMALLOC_INIT;
>>       /* KASAN_VMALLOC_PROT_NORMAL already set if required. */
>>       area->addr = kasan_unpoison_vmalloc(area->addr, real_size, 
>> kasan_flags);
> 

-- 
js
suse labs

