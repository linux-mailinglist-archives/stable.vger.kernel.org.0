Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E467058B019
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240945AbiHES5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiHES5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:57:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 549D351A3A
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 11:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659725824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38HMOlpiHz3hAI7+jcYvoHMIUhKTjvFP/aWFO5JyZUs=;
        b=KzdEMa2zGbIlGSU8KBqa5S67Q4HZXzaTMJrlOd+CqtlqtEB8BZYi1s1Gu9QbBe9xg7QWEb
        3GxMfKVRtLRpNSjc2zlI1F+0D8y+nGuIg3331nQhQXkRkV4DwAJi+YLaMeU86t7EmU8KiE
        G+Qz5gf3v/Hv5iRIgxpczg3h06WvcAo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-j3iSl2gIN8uQDSN9X_6QDw-1; Fri, 05 Aug 2022 14:57:03 -0400
X-MC-Unique: j3iSl2gIN8uQDSN9X_6QDw-1
Received: by mail-wr1-f72.google.com with SMTP id d6-20020adfa346000000b002206e4c29caso648424wrb.8
        for <stable@vger.kernel.org>; Fri, 05 Aug 2022 11:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=38HMOlpiHz3hAI7+jcYvoHMIUhKTjvFP/aWFO5JyZUs=;
        b=WtZt17omwfJB3r9q9WgM2ZA4Rl6QnJ7QoQQAlrlx7ooT1tmWvW8kouiaZ0v6Yez/Fp
         KA4o4q+eIHYLouuynJfkpEC5f7ROBOtMCRbUAtjYX5xAVZE7Qcv5zXP4gp75iAMrVC73
         cHJF1w8PFeVmkLZgWDCAO4Y4qP7TbbHwU2i1a3F7zzTN54HJ4+7DoYehZuiChMyO3EXm
         lhrUK8sWgavMRqxK8M3E3VKgn/02hGGjUiqIwha0aNu4YqGrIAoG358DWMOBdRvbdjYW
         /Bvo9XLCtumjYgRFcTdLtxsOxu83vYnZpelF6XhPTK/8wfFIOgpD4KQ/0nQ2GjHIeBC6
         4lIA==
X-Gm-Message-State: ACgBeo1Wq/+Q0rd3glokKV+P3nbFgd3ukB+8H44t5OxAOzczQpLKCXfK
        75oUypqQSIZEDyzmeSlAc9yuHpEjz5UjTKzzmcEZ1B3OY4z3ovOfsT06kRh7DOVNkWqjfI/aNsK
        0vcH30vtY7bX8Cig4
X-Received: by 2002:a5d:5081:0:b0:220:6262:be0b with SMTP id a1-20020a5d5081000000b002206262be0bmr4863601wrt.228.1659725822067;
        Fri, 05 Aug 2022 11:57:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4KFDPpXTnLc9xcWmV5EbrjJoKCLSsWZAX9+Qv0fALjuvgGAb/bq9BvB7bwLwfeM2udXcmh0A==
X-Received: by 2002:a5d:5081:0:b0:220:6262:be0b with SMTP id a1-20020a5d5081000000b002206262be0bmr4863590wrt.228.1659725821805;
        Fri, 05 Aug 2022 11:57:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:fb00:f5c3:24b2:3d03:9d52? (p200300cbc706fb00f5c324b23d039d52.dip0.t-ipconnect.de. [2003:cb:c706:fb00:f5c3:24b2:3d03:9d52])
        by smtp.gmail.com with ESMTPSA id b4-20020adff904000000b0021e9fafa601sm4458360wrr.22.2022.08.05.11.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 11:57:01 -0700 (PDT)
Message-ID: <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
Date:   Fri, 5 Aug 2022 20:57:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com> <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey> <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
In-Reply-To: <Yu1ie559zt8VvDc1@monkey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.08.22 20:33, Mike Kravetz wrote:
> On 08/05/22 20:25, David Hildenbrand wrote:
>> On 05.08.22 20:23, Mike Kravetz wrote:
>>> On 08/05/22 14:14, Peter Xu wrote:
>>>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
>>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>>> index 61e6135c54ef..462a6b0344ac 100644
>>>>> --- a/mm/mmap.c
>>>>> +++ b/mm/mmap.c
>>>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>>>>>  		return 0;
>>>>>  
>>>>> +	/*
>>>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
>>>>> +	 * support softdirty tracking.
>>>>> +	 */
>>>>> +	if (is_vm_hugetlb_page(vma))
>>>>> +		return 0;
>>>>
>>>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
>>>> hugetlb but here it's explicitly forbidden.
>>>>
>>>> Could you explain a bit more on why this patch is needed if (assume
>>>> there'll be a working) patch 2 being provided?
>>>>
>>>
>>> No comments on the patch, but ...
>>>
>>> Since it required little thought, I ran the test program on next-20220802 and
>>> was surprised that the issue did not recreate.  Even added a simple printk
>>> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
>>> We were.
>>
>>
>> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
>>
> 
> No, Duh!
> 
> FYI - Some time back, I started looking at adding soft dirty support for
> hugetlb mappings.  I did not finish that work.  But, I seem to recall
> places where code was operating on hugetlb mappings when perhaps it should
> not.
> 
> Perhaps, it would also be good to just disable soft dirty for hugetlb at
> the source?

I thought about that as well. But I came to the conclusion that without
patch #2, hugetlb VMAs cannot possibly support write-notify, so there is
no need to bother in vma_wants_writenotify() at all.

The "root" would be places where we clear VM_SOFTDIRTY. That should only
be fs/proc/task_mmu.c:clear_refs_write() IIRC.

So I don't particularly care, I consider this patch a bit cleaner and
more generic, but I can adjust clear_refs_write() instead of there is a
preference.

-- 
Thanks,

David / dhildenb

