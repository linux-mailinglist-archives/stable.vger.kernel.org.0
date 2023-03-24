Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137FA6C7A4E
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 09:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjCXIwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 04:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjCXIwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 04:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3174C199F5
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 01:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679647893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yv/84eJK6r5Ff9q11bolfxLRKLu7fL8hFk1vJYwSiNA=;
        b=J65b9VHTI9HvLScK61zV9eYmEJJvEbYmeY6/8942FQhrELSLRImFuqMvbqzMDOCBczRpZb
        Y4vTmJAbfsiw4S0Mi4eEdoWFRf0K3PpRadrRXRkQjKoE1n/qcAhreH2VPoC/9Kqmk0xv6A
        xctsqq2uKWKTv93oLpanVFkm7Sl0iH8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-IdySJvmVPh2EpPOSFYhbxQ-1; Fri, 24 Mar 2023 04:51:31 -0400
X-MC-Unique: IdySJvmVPh2EpPOSFYhbxQ-1
Received: by mail-wm1-f70.google.com with SMTP id j27-20020a05600c1c1b00b003edd2023418so2272539wms.4
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 01:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647890;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yv/84eJK6r5Ff9q11bolfxLRKLu7fL8hFk1vJYwSiNA=;
        b=QPKb6GjBH0pHuaZ9BxZm12peTtIPcLvOdv3xTBEbzKVgNAJSBda8AqEFMtU5I1nKsd
         R/Uq03KjvHeO2WSjt+ZB/2tCNgTrLy6BT8QuHKKduFqC4wKaO3NjzzhmS3mivoVJDMZL
         OWXmyUlKuUGmgakrXIPv6swlNn0bVoqJa9l09N+a4uKWuqPw+7pJA+Fqd3nIP83Y1i/l
         9ZS6h8Rx82T3SGn/T3oZ+Vl47odpoD22r1RohiZKNq8uAV6U5DVN+QwVsaRBUh4oIKzC
         jHetG6bPRxn57nsnbHctwGJQQE6iRIe/FvulU4998bb0GjabMiDJYukjh2ItWoflFZNN
         oclQ==
X-Gm-Message-State: AO0yUKVcmIOCZ1bjorvKay1xcIXBgoIR+aQWq++y3Pd5eawlktXIndfO
        X65kElJfhllLwjPkllUv1G1q/Pl2kxgiSQ6OsRy7myYbW3trGw6+UAkwlaPw3YA8jdcSVfgFCy1
        dE9rzb5u0xtqL9IuB
X-Received: by 2002:a7b:ce87:0:b0:3ed:2eb5:c2e8 with SMTP id q7-20020a7bce87000000b003ed2eb5c2e8mr1733446wmj.10.1679647890487;
        Fri, 24 Mar 2023 01:51:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set94n3ISseXtVNAidSp4VI7jXPw+pEShrF/SmbkuflFdjnVVKbuG4ArpgvpcAoE1zFy8qp0Tow==
X-Received: by 2002:a7b:ce87:0:b0:3ed:2eb5:c2e8 with SMTP id q7-20020a7bce87000000b003ed2eb5c2e8mr1733434wmj.10.1679647890161;
        Fri, 24 Mar 2023 01:51:30 -0700 (PDT)
Received: from [10.105.158.254] ([88.128.92.189])
        by smtp.gmail.com with ESMTPSA id h6-20020adfe986000000b002d09cba6beasm18105351wrm.72.2023.03.24.01.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 01:51:29 -0700 (PDT)
Message-ID: <bade768b-5078-1657-802d-fe20e50a5725@redhat.com>
Date:   Fri, 24 Mar 2023 09:51:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
To:     Peter Xu <peterx@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230321191840.1897940-1-peterx@redhat.com>
 <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com> <ZBoKod6+twRYvSYz@x1n>
 <f411b983-0c47-73f8-775b-928fcf61620a@collabora.com> <ZBzOqwF2wrHgBVZb@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZBzOqwF2wrHgBVZb@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.03.23 23:11, Peter Xu wrote:
> On Thu, Mar 23, 2023 at 08:33:07PM +0500, Muhammad Usama Anjum wrote:
>> Hi Peter,
>>
>> Sorry for late reply.
>>
>> On 3/22/23 12:50 AM, Peter Xu wrote:
>>> On Tue, Mar 21, 2023 at 08:36:35PM +0100, David Hildenbrand wrote:
>>>> On 21.03.23 20:18, Peter Xu wrote:
>>>>> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
>>>>> writable even with uffd-wp bit set.  It only happens with all these
>>>>> conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
>>>>> was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
>>>>> write to the page to trigger.
>>>>>
>>>>> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
>>>>> even reaching hugetlb_wp() to avoid taking more locks that userfault won't
>>>>> need.  However there's one CoW optimization path for missing hugetlb page
>>>>> that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
>>>>> userfaultfd-wp traps.
>>>>>
>>>>> A few ways to resolve this:
>>>>>
>>>>>     (1) Skip the CoW optimization for hugetlb private mapping, considering
>>>>>     that private mappings for hugetlb should be very rare, so it may not
>>>>>     really be helpful to major workloads.  The worst case is we only skip the
>>>>>     optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
>>>>>     fault anyway.
>>>>>
>>>>>     (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
>>>>>     into hugetlb_wp().  The major cons is there're a bunch of locks taken
>>>>>     when calling hugetlb_wp(), and that will make the changeset unnecessarily
>>>>>     complicated due to the lock operations.
>>>>>
>>>>>     (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
>>>>>     for uffd-wp privately mapped pages.
>>>>>
>>>>> This patch chose option (3) which contains the minimum changeset (simplest
>>>>> for backport) and also make sure hugetlb_wp() itself will start to be
>>>>> always safe with uffd-wp ptes even if called elsewhere in the future.
>>>>>
>>>>> This patch will be needed for v5.19+ hence copy stable.
>>>>>
>>>>> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>>>>> Cc: linux-stable <stable@vger.kernel.org>
>>>>> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
>>>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>>>> ---
>>>>>    mm/hugetlb.c | 8 +++++---
>>>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index 8bfd07f4c143..22337b191eae 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>>>>>    		       struct folio *pagecache_folio, spinlock_t *ptl)
>>>>>    {
>>>>>    	const bool unshare = flags & FAULT_FLAG_UNSHARE;
>>>>> -	pte_t pte;
>>>>> +	pte_t pte, newpte;
>>>>>    	struct hstate *h = hstate_vma(vma);
>>>>>    	struct page *old_page;
>>>>>    	struct folio *new_folio;
>>>>> @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>>>>>    		mmu_notifier_invalidate_range(mm, range.start, range.end);
>>>>>    		page_remove_rmap(old_page, vma, true);
>>>>>    		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
>>>>> -		set_huge_pte_at(mm, haddr, ptep,
>>>>> -				make_huge_pte(vma, &new_folio->page, !unshare));
>>>>> +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
>>>>> +		if (huge_pte_uffd_wp(pte))
>>>>> +			newpte = huge_pte_mkuffd_wp(newpte);
>>>>> +		set_huge_pte_at(mm, haddr, ptep, newpte);
>>>>>    		folio_set_hugetlb_migratable(new_folio);
>>>>>    		/* Make the old page be freed below */
>>>>>    		new_folio = page_folio(old_page);
>>>>
>>>> Looks correct to me. Do we have a reproducer?
>>>
>>> I used a reproducer for the async mode I wrote (patch 2 attached, need to
>>> change to VM_PRIVATE):
>>>
>>> https://lore.kernel.org/all/ZBNr4nohj%2FTw4Zhw@x1n/
>>>
>>> I don't think kernel kselftest can trigger it because we don't do strict
>>> checks yet with uffd-wp bits.  I've already started looking into cleanup
>>> the test cases and I do plan to add new tests to cover this.
>>>
>>> Meanwhile, let's also wait for an ack from Muhammad.  Even though the async
>>> mode is not part of the code base, it'll be a good test for verifying every
>>> single uffd-wp bit being set or cleared as expected.
>> I've tested by applying this patch. But the bug is still there. Just like
>> Peter has mentioned, we are using our in progress patches related to
>> pagemap_scan ioctl and userfaultd wp async patches to reproduce it.
>>
>> To reproduce please build kernel and run pagemap_ioctl test in mm in
>> hugetlb_mem_reproducer branch:
>> https://gitlab.collabora.com/usama.anjum/linux-mainline/-/tree/hugetlb_mem_reproducer
>>
>> In case you have any question on how to reproduce, please let me know. I'll
>> try to provide a cleaner alternative.
> 
> Hmm, I think my current fix is incomplete if not wrong.  The root cause
> should still be valid, however I overlooked another path:
> 
> 	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
> 		if (!PageAnonExclusive(old_page))
> 			page_move_anon_rmap(old_page, vma);
> 		if (likely(!unshare))
> 			set_huge_ptep_writable(vma, haddr, ptep);
> 
> 		delayacct_wpcopy_end();
> 		return 0;
> 	}
> 
> We should bail out early in this path, and it'll be even easier we always
> bail out hugetlb_wp() as long as uffd-wp is detected because userfault
> should always be handled before any decision to CoW.
> 
> v2 attached.. Please give it another shot.

Hmmm, I think you must only do that for !unshare (FAULT_FLAG_WRITE). 
Otherwise you'll never be able to resolve an unsharing request on a r/o 
mapped hugetlb page that has the uffd-wp set?

Or am I missing something?

-- 
Thanks,

David / dhildenb

