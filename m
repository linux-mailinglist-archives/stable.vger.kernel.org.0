Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484205A29F1
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 16:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344593AbiHZOrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 10:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344607AbiHZOra (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 10:47:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF18FD8E10
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661525247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99JWd2r7uI+NtQEfMTMU0psWdgteknoK0WTYvTciCxY=;
        b=YGy7Al/yIDUPXKq1aR4YxdLc0JQUPxs/ZMzouTh3+WrVC6wOOMnIzys4+tOY8m8n1EpqhW
        2HR6EWUuwjI/IGSj2rMXlRpUO5XfZJhX1//u08q+EU8ebtZJPQ5SkqigaoBnu1RuT+GETo
        RGzyRSxx6u4iFuRX6gDwTSjG8sV1XBs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-vgWjflRmMWCcGxOjtZyGAQ-1; Fri, 26 Aug 2022 10:47:25 -0400
X-MC-Unique: vgWjflRmMWCcGxOjtZyGAQ-1
Received: by mail-wm1-f72.google.com with SMTP id r131-20020a1c4489000000b003a7b679981cso775559wma.6
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 07:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=99JWd2r7uI+NtQEfMTMU0psWdgteknoK0WTYvTciCxY=;
        b=VxDyzMHdeRM3/t3mSFSP2gX21eYH4RRks6MfSJk1Y0vtoMqImlE/sM2dVcxehoFP0o
         F/9GFja9BjZA6KKVkxAqOBxODxUNtNXWoZF1dd9ChpPLkG+sL0dwwMag1ikxp2dakAE1
         jqz5fwRTuTmUpjkoI+pw4qgjbqnLxeVdmqwBpvdpACMxzp8dDKfHR9PmQYmgQyDAApqr
         O00KJyPMJChBVe08XcGMCM0N4uqYQDt7f3ixtXfrUNKOq4d9EeMaW/L6YeXL/+O90+QH
         uKACJz2AzWLzgKzH1i3Z1l55SSEVZTA775f6eGZZyWcT7J999eKIp8WdKbXuAvLsOHPM
         ktLg==
X-Gm-Message-State: ACgBeo0z3Q+0ZJF9CJeIenKCInboqSWFg9Siw1TjBbPcJgMU44s9WQOX
        I5+dH0Iph36aYDkOPH1vlhqr+wolN7ej9IFCi/oJwHHXZSZRw0/GyaB1vD1ekqcavN7YvHefhz1
        ReO0Apf/VleKaa09o
X-Received: by 2002:a5d:5985:0:b0:222:c827:11d5 with SMTP id n5-20020a5d5985000000b00222c82711d5mr524wri.323.1661525243922;
        Fri, 26 Aug 2022 07:47:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6DwZULOBS0dk+aCd9iIC0MR/e4UA3DRO6z9TwsFVCvv46I7xo6Oq/KhO+SKX3jNfwHlL+UnQ==
X-Received: by 2002:a5d:5985:0:b0:222:c827:11d5 with SMTP id n5-20020a5d5985000000b00222c82711d5mr499wri.323.1661525243581;
        Fri, 26 Aug 2022 07:47:23 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id l25-20020a05600c1d1900b003a62052053csm10503423wms.18.2022.08.26.07.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:47:23 -0700 (PDT)
Message-ID: <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
Date:   Fri, 26 Aug 2022 16:47:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local> <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local> <8735dj7qwb.fsf@nvdebian.thelocal>
 <YwjZamk4n/dz+Y/M@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YwjZamk4n/dz+Y/M@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.08.22 16:32, Peter Xu wrote:
> On Fri, Aug 26, 2022 at 11:02:58AM +1000, Alistair Popple wrote:
>>
>> Peter Xu <peterx@redhat.com> writes:
>>
>>> On Fri, Aug 26, 2022 at 08:21:44AM +1000, Alistair Popple wrote:
>>>>
>>>> Peter Xu <peterx@redhat.com> writes:
>>>>
>>>>> On Wed, Aug 24, 2022 at 01:03:38PM +1000, Alistair Popple wrote:
>>>>>> migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
>>>>>> installs migration entries directly if it can lock the migrating page.
>>>>>> When removing a dirty pte the dirty bit is supposed to be carried over
>>>>>> to the underlying page to prevent it being lost.
>>>>>>
>>>>>> Currently migrate_vma_*() can only be used for private anonymous
>>>>>> mappings. That means loss of the dirty bit usually doesn't result in
>>>>>> data loss because these pages are typically not file-backed. However
>>>>>> pages may be backed by swap storage which can result in data loss if an
>>>>>> attempt is made to migrate a dirty page that doesn't yet have the
>>>>>> PageDirty flag set.
>>>>>>
>>>>>> In this case migration will fail due to unexpected references but the
>>>>>> dirty pte bit will be lost. If the page is subsequently reclaimed data
>>>>>> won't be written back to swap storage as it is considered uptodate,
>>>>>> resulting in data loss if the page is subsequently accessed.
>>>>>>
>>>>>> Prevent this by copying the dirty bit to the page when removing the pte
>>>>>> to match what try_to_migrate_one() does.
>>>>>>
>>>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>>>> Acked-by: Peter Xu <peterx@redhat.com>
>>>>>> Reported-by: Huang Ying <ying.huang@intel.com>
>>>>>> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
>>>>>> Cc: stable@vger.kernel.org
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> Changes for v3:
>>>>>>
>>>>>>  - Defer TLB flushing
>>>>>>  - Split a TLB flushing fix into a separate change.
>>>>>>
>>>>>> Changes for v2:
>>>>>>
>>>>>>  - Fixed up Reported-by tag.
>>>>>>  - Added Peter's Acked-by.
>>>>>>  - Atomically read and clear the pte to prevent the dirty bit getting
>>>>>>    set after reading it.
>>>>>>  - Added fixes tag
>>>>>> ---
>>>>>>  mm/migrate_device.c |  9 +++++++--
>>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>> index 6a5ef9f..51d9afa 100644
>>>>>> --- a/mm/migrate_device.c
>>>>>> +++ b/mm/migrate_device.c
>>>>>> @@ -7,6 +7,7 @@
>>>>>>  #include <linux/export.h>
>>>>>>  #include <linux/memremap.h>
>>>>>>  #include <linux/migrate.h>
>>>>>> +#include <linux/mm.h>
>>>>>>  #include <linux/mm_inline.h>
>>>>>>  #include <linux/mmu_notifier.h>
>>>>>>  #include <linux/oom.h>
>>>>>> @@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>>>>>>  			if (anon_exclusive) {
>>>>>>  				flush_cache_page(vma, addr, pte_pfn(*ptep));
>>>>>> -				ptep_clear_flush(vma, addr, ptep);
>>>>>> +				pte = ptep_clear_flush(vma, addr, ptep);
>>>>>>
>>>>>>  				if (page_try_share_anon_rmap(page)) {
>>>>>>  					set_pte_at(mm, addr, ptep, pte);
>>>>>> @@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>>  					goto next;
>>>>>>  				}
>>>>>>  			} else {
>>>>>> -				ptep_get_and_clear(mm, addr, ptep);
>>>>>> +				pte = ptep_get_and_clear(mm, addr, ptep);
>>>>>>  			}
>>>>>
>>>>> I remember that in v2 both flush_cache_page() and ptep_get_and_clear() are
>>>>> moved above the condition check so they're called unconditionally.  Could
>>>>> you explain the rational on why it's changed back (since I think v2 was the
>>>>> correct approach)?
>>>>
>>>> Mainly because I agree with your original comments, that it would be
>>>> better to keep the batching of TLB flushing if possible. After the
>>>> discussion I don't think there is any issues with HW pte dirty bits
>>>> here. There are already other cases where HW needs to get that right
>>>> anyway (eg. zap_pte_range).
>>>
>>> Yes tlb batching was kept, thanks for doing that way.  Though if only apply
>>> patch 1 we'll have both ptep_clear_flush() and batched flush which seems to
>>> be redundant.
>>>
>>>>
>>>>> The other question is if we want to split the patch, would it be better to
>>>>> move the tlb changes to patch 1, and leave the dirty bit fix in patch 2?
>>>>
>>>> Isn't that already the case? Patch 1 moves the TLB flush before the PTL
>>>> as suggested, patch 2 atomically copies the dirty bit without changing
>>>> any TLB flushing.
>>>
>>> IMHO it's cleaner to have patch 1 fix batch flush, replace
>>> ptep_clear_flush() with ptep_get_and_clear() and update pte properly.
>>
>> Which ptep_clear_flush() are you referring to? This one?
>>
>> 			if (anon_exclusive) {
>> 				flush_cache_page(vma, addr, pte_pfn(*ptep));
>> 				ptep_clear_flush(vma, addr, ptep);
> 
> Correct.
> 
>>
>> My understanding is that we need to do a flush for anon_exclusive.
> 
> To me anon exclusive only shows this mm exclusively owns this page. I
> didn't quickly figure out why that requires different handling on tlb
> flushs.  Did I perhaps miss something?

GUP-fast is the magic bit, we have to make sure that we won't see new
GUP pins, thus the TLB flush.

include/linux/mm.h:gup_must_unshare() contains documentation.

Without GUP-fast, some things would be significantly easier to handle.


-- 
Thanks,

David / dhildenb

