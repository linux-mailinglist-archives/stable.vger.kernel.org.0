Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572B86D82A6
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbjDEPwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239152AbjDEPwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:52:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA3F5FFB
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680709874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zwcds+UtbfQIbiuF3/Xn2nxiwljEp+1pjIA6S8P9CNE=;
        b=G9azVFZCWhwdNn4LnE/rilnY32ZeGjk8sY0UcLVT2zFr2E5YqrE7EBGrd48F+wRS+HvXzd
        /xAmhJef6sushlloRDNv3bj/SM2WoHzpndyIEvfWN6z+JBcbaQpQwELI6kdn6VRfKhLb7L
        ySJuDo1IPR3QKaASzUJG++INWFpUSKU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-Qyaz74wKNFizRS0W3eGWsQ-1; Wed, 05 Apr 2023 11:51:13 -0400
X-MC-Unique: Qyaz74wKNFizRS0W3eGWsQ-1
Received: by mail-wm1-f70.google.com with SMTP id n11-20020a05600c3b8b00b003f04739b77aso7372278wms.9
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709872;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwcds+UtbfQIbiuF3/Xn2nxiwljEp+1pjIA6S8P9CNE=;
        b=N0mikNikHgKQnsANIDo6hSsy2RBMnreQiWP/29mdqBeYe0mn4O5WjJzoHfOK7fiTjB
         xD74kMfmyw+NP+/dpet65wLrirmDHw5YFMZ014dUGjX+QlGhS6MR2Ymq5kx/ogVxbkVg
         lGNiWjWrjVZrBAS/Bs0GcNuACspMU84Iipz/8/pfql/sMMU8iooOEKJsge7kymS/W6k9
         we93/Ii/R4XJ5tDSeDdiLqffcjRv7oVUFZFbEzg0lPVe8snwhE9mGXgIZPUo04fyhVBv
         3g73zZ+gkOTzpS/SprJUevHGCiZUOhKPCqvzb5SdwWLM3mUfGNdosrUTgmTr5S7a8uPY
         gscQ==
X-Gm-Message-State: AAQBX9evL54jAEZ2vvmc+Hn1lfelssMQi9Tf0mgbrpcm2FTYnuzmqkzz
        cLcsJnBDGD2esRtEjO32bWTF5llaBgZ9EUhOVjGthFnnHLmibneBKEJgvmXqsDKTWqT+eq9Nht9
        Tl9tVr2e/1sX8dg4d
X-Received: by 2002:a5d:460c:0:b0:2cf:feac:1ba4 with SMTP id t12-20020a5d460c000000b002cffeac1ba4mr4489143wrq.52.1680709871734;
        Wed, 05 Apr 2023 08:51:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z0Kdl7KzMunNzgacqXrtbvhCmqrBwFwQ712057u2CU5aKnkMXlHhzmgE+1a984DLcJhQUu6w==
X-Received: by 2002:a5d:460c:0:b0:2cf:feac:1ba4 with SMTP id t12-20020a5d460c000000b002cffeac1ba4mr4489129wrq.52.1680709871360;
        Wed, 05 Apr 2023 08:51:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:d00:ca74:d9ea:11e0:dfb? (p200300cbc7030d00ca74d9ea11e00dfb.dip0.t-ipconnect.de. [2003:cb:c703:d00:ca74:d9ea:11e0:dfb])
        by smtp.gmail.com with ESMTPSA id x9-20020a5d4449000000b002e40d124460sm15350496wrr.97.2023.04.05.08.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:51:10 -0700 (PDT)
Message-ID: <062cd239-179b-d146-8f5d-735e672b3237@redhat.com>
Date:   Wed, 5 Apr 2023 17:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: fix uffd-wp handling for THP
 migration entries
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        stable@vger.kernel.org
References: <20230405142535.493854-1-david@redhat.com>
 <20230405142535.493854-2-david@redhat.com> <ZC2P7Z7S87myvSst@x1n>
 <c4c3ddb7-66fe-08e3-e59a-352f8aec6c6f@redhat.com> <ZC2XF8qLXNOqIqGw@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZC2XF8qLXNOqIqGw@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.04.23 17:43, Peter Xu wrote:
> On Wed, Apr 05, 2023 at 05:17:31PM +0200, David Hildenbrand wrote:
>> On 05.04.23 17:12, Peter Xu wrote:
>>> On Wed, Apr 05, 2023 at 04:25:34PM +0200, David Hildenbrand wrote:
>>>> Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
>>>> fix uffd-wp handling for migration entries in hugetlb_change_protection()")
>>>> similarly applies to THP.
>>>>
>>>> Setting/clearing uffd-wp on THP migration entries is not implemented
>>>> properly. Further, while removing migration PMDs considers the uffd-wp
>>>> bit, inserting migration PMDs does not consider the uffd-wp bit.
>>>>
>>>> We have to set/clear independently of the migration entry type in
>>>> change_huge_pmd() and properly copy the uffd-wp bit in
>>>> set_pmd_migration_entry().
>>>>
>>>> Verified using a simple reproducer that triggers migration of a THP, that
>>>> the set_pmd_migration_entry() no longer loses the uffd-wp bit.
>>>>
>>>> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> Reviewed-by: Peter Xu <peterx@redhat.com>
>>>
>>> Thanks, one trivial nitpick:
>>>
>>>> ---
>>>>    mm/huge_memory.c | 14 ++++++++++++--
>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 032fb0ef9cd1..bdda4f426d58 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>    	if (is_swap_pmd(*pmd)) {
>>>>    		swp_entry_t entry = pmd_to_swp_entry(*pmd);
>>>>    		struct page *page = pfn_swap_entry_to_page(entry);
>>>> +		pmd_t newpmd;
>>>>    		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
>>>>    		if (is_writable_migration_entry(entry)) {
>>>> -			pmd_t newpmd;
>>>>    			/*
>>>>    			 * A protection check is difficult so
>>>>    			 * just be safe and disable write
>>>> @@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>    				newpmd = pmd_swp_mksoft_dirty(newpmd);
>>>>    			if (pmd_swp_uffd_wp(*pmd))
>>>>    				newpmd = pmd_swp_mkuffd_wp(newpmd);
>>>> -			set_pmd_at(mm, addr, pmd, newpmd);
>>>> +		} else {
>>>> +			newpmd = *pmd;
>>>>    		}
>>>> +
>>>> +		if (uffd_wp)
>>>> +			newpmd = pmd_swp_mkuffd_wp(newpmd);
>>>> +		else if (uffd_wp_resolve)
>>>> +			newpmd = pmd_swp_clear_uffd_wp(newpmd);
>>>> +		if (!pmd_same(*pmd, newpmd))
>>>> +			set_pmd_at(mm, addr, pmd, newpmd);
>>>>    		goto unlock;
>>>>    	}
>>>>    #endif
>>>> @@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>>>    	pmdswp = swp_entry_to_pmd(entry);
>>>>    	if (pmd_soft_dirty(pmdval))
>>>>    		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
>>>> +	if (pmd_swp_uffd_wp(*pvmw->pmd))
>>>> +		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
>>>
>>> I think it's fine to use *pmd, but maybe still better to use pmdval?  I
>>> worry pmdp_invalidate()) can be something else in the future that may
>>> affect the bit.
>>
>> Wondering how I ended up with that, I realized that it's actually
>> wrong and might have worked by chance for my reproducer on x86.
>>
>> That should make it work:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index f977c965fdad..fffc953fa6ea 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3257,7 +3257,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>          pmdswp = swp_entry_to_pmd(entry);
>>          if (pmd_soft_dirty(pmdval))
>>                  pmdswp = pmd_swp_mksoft_dirty(pmdswp);
>> -       if (pmd_swp_uffd_wp(*pvmw->pmd))
>> +       if (pmd_uffd_wp(pmdval))
>>                  pmdswp = pmd_swp_mkuffd_wp(pmdswp);
>>          set_pmd_at(mm, address, pvmw->pmd, pmdswp);
>>          page_remove_rmap(page, vma, true);
> 
> I guess pmd_swp_uffd_wp() just reads the _USER bit 2 which is also set for
> a present pte, but then it sets swp uffd-wp always even if it was not set.
> 

Yes. I modified the reproducer to migrate without uffd-wp first and we 
suddenly gain a uffd-wp bit.

> Yes the change must be squashed in to be correct, with that, my R-b keeps.

Thanks, I will resend later.

-- 
Thanks,

David / dhildenb

