Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BB58CC31
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244016AbiHHQh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 12:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHHQh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 12:37:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC74AB8B
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 09:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659976644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cA+tWpFYH37Xk4WdfAkkskGhzNmVqVyB+oL1jeFLj/8=;
        b=Q9qRkHXReMZhCJmfsFMpFKTevtZxBnNkJwHnI+FUN5up1GXeBZThE1iFAukZp7m/6R1+IG
        vGWbjQMVyGhzveDCwoESfgpOavA6adas4SKv5qFVGdcDwBDFpzNej7mF7nnMpU5gdzY4Mm
        fehCYvF3Hnn/+nqgVpEVLJ64w/jYbKk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-TKgtja54NNy6G9VvApgtUQ-1; Mon, 08 Aug 2022 12:37:22 -0400
X-MC-Unique: TKgtja54NNy6G9VvApgtUQ-1
Received: by mail-wr1-f72.google.com with SMTP id w17-20020adfbad1000000b0021f0acd5398so1535055wrg.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 09:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=cA+tWpFYH37Xk4WdfAkkskGhzNmVqVyB+oL1jeFLj/8=;
        b=UlIfxiv4ROwrjl5Xx7N1XYRQILzTZDN5k3PzGivgJBNkmVoSRgpsYaHkSnpbLIblt2
         knLU6mGsqpZWVJdeb57MrlooS0A9L3DsY5fbO1DfUL8SDrim546CueKPWCI/pIrz6rqS
         B6PDinPo6xv8U32jQSZtL83lpqr6Uvor+tly7ZivqNvgJkpsmZEqU7CLQU6ywkgKWZvX
         r9M1/lBpzcwevSyifTSxn2aj5qA3Efcv0pE7j+HLn7W/8n2PBVumkVdIRDKhVTOwKVIF
         tFatcbZdZyt8mFhr3sxoveDd+lkqnfqFCAhhZaZW9xN+XA0mECJXMdyg+LFV5o+BZBnW
         bQ2A==
X-Gm-Message-State: ACgBeo3VSCEo3tTv++fDyel5+2dWnMv1Vgz/Hvm6nWxb7632iwHYoLNJ
        3X4J+/m1qOLYoqbppIu4BYEbshbGrtk2VrKzCx+oMwjrnyEToS1nJzTj8KEdX/tIucRkXTJB4lX
        /pjuGsBhIbv/xV8kR
X-Received: by 2002:a7b:c7d4:0:b0:3a5:737:3e1e with SMTP id z20-20020a7bc7d4000000b003a507373e1emr13014145wmk.123.1659976641128;
        Mon, 08 Aug 2022 09:37:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR57tWxR4tXtNGBWeL/q+gvRDaa+lSWgrtHN+Pb/jUpCj+x4GI86pB/BkmHalgM+OXLEE6Eh9g==
X-Received: by 2002:a7b:c7d4:0:b0:3a5:737:3e1e with SMTP id z20-20020a7bc7d4000000b003a507373e1emr13014137wmk.123.1659976640790;
        Mon, 08 Aug 2022 09:37:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f15:c300:d2ce:1fb5:2460:179a? (p200300d82f15c300d2ce1fb52460179a.dip0.t-ipconnect.de. [2003:d8:2f15:c300:d2ce:1fb5:2460:179a])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b003a319b67f64sm44866965wmq.0.2022.08.08.09.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 09:37:20 -0700 (PDT)
Message-ID: <36bcc1f5-40e9-2d2b-3e94-18994bf62ca4@redhat.com>
Date:   Mon, 8 Aug 2022 18:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com> <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey> <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey> <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey> <Yu2kK6s8m8NLDjuV@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yu2kK6s8m8NLDjuV@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.08.22 01:13, Peter Xu wrote:
> On Fri, Aug 05, 2022 at 01:48:35PM -0700, Mike Kravetz wrote:
>> On 08/05/22 20:57, David Hildenbrand wrote:
>>> On 05.08.22 20:33, Mike Kravetz wrote:
>>>> On 08/05/22 20:25, David Hildenbrand wrote:
>>>>> On 05.08.22 20:23, Mike Kravetz wrote:
>>>>>> On 08/05/22 14:14, Peter Xu wrote:
>>>>>>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
>>>>>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>>>>>> index 61e6135c54ef..462a6b0344ac 100644
>>>>>>>> --- a/mm/mmap.c
>>>>>>>> +++ b/mm/mmap.c
>>>>>>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>>>>>>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
>>>>>>>>  		return 0;
>>>>>>>>  
>>>>>>>> +	/*
>>>>>>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
>>>>>>>> +	 * support softdirty tracking.
>>>>>>>> +	 */
>>>>>>>> +	if (is_vm_hugetlb_page(vma))
>>>>>>>> +		return 0;
>>>>>>>
>>>>>>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
>>>>>>> hugetlb but here it's explicitly forbidden.
>>>>>>>
>>>>>>> Could you explain a bit more on why this patch is needed if (assume
>>>>>>> there'll be a working) patch 2 being provided?
>>>>>>>
>>>>>>
>>>>>> No comments on the patch, but ...
>>>>>>
>>>>>> Since it required little thought, I ran the test program on next-20220802 and
>>>>>> was surprised that the issue did not recreate.  Even added a simple printk
>>>>>> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
>>>>>> We were.
>>>>>
>>>>>
>>>>> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
>>>>>
>>>>
>>>> No, Duh!
>>>>
>>>> FYI - Some time back, I started looking at adding soft dirty support for
>>>> hugetlb mappings.  I did not finish that work.  But, I seem to recall
>>>> places where code was operating on hugetlb mappings when perhaps it should
>>>> not.
>>>>
>>>> Perhaps, it would also be good to just disable soft dirty for hugetlb at
>>>> the source?
>>>
>>> I thought about that as well. But I came to the conclusion that without
>>> patch #2, hugetlb VMAs cannot possibly support write-notify, so there is
>>> no need to bother in vma_wants_writenotify() at all.
>>>
>>> The "root" would be places where we clear VM_SOFTDIRTY. That should only
>>> be fs/proc/task_mmu.c:clear_refs_write() IIRC.
>>>
>>> So I don't particularly care, I consider this patch a bit cleaner and
>>> more generic, but I can adjust clear_refs_write() instead of there is a
>>> preference.
>>>
>>
>> After a closer look, I agree that this may be the simplest/cleanest way to
>> proceed.  I was going to suggest that you note hugetlb does not support
>> softdirty, but see you did in the comment.
>>
>> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
> Filtering out hugetlbfs in vma_wants_writenotify() is still a bit hard to
> follow to me, since it's not clear why hugetlbfs never wants writenotify.

Well, because the write-fault handler as is cannot deal with
write-faults in shared mappings. It cannot possibly work or ever have
worked.

> 
> If it's only about soft-dirty, we could have added the hugetlbfs check into
> vma_soft_dirty_enabled(), then I think it'll achieve the same thing and
> much clearer - with the soft-dirty check constantly returning false for it,
> hugetlbfs shared vmas should have vma_wants_writenotify() naturally return
> 0 already.

I considered that an option, but went with this approach for simplicity
and because I don't see a need to check for hugetlb in other code paths
(especially, in the !hugetlb mprotect variant).

I mean, with patch #2 we can remove it anytime we do support softdirty
tracking -- or if there is need for write-notify we can move it into the
softdirty check only.

> 
> For the long term - shouldn't we just enable soft-dirty for hugetlbfs?  I
> remember Mike used to have that in todo.  Since we've got patch 2 already,
> I feel like that's really much close (is the only missing piece the clear
> refs write part? or maybe some more that I didn't notice).

My gut feeling is that there isn't too much missing to have it working.
Define a PTE bit, implement hugetlb variant of clearing, and set it when
setting the PTE dirty.

Thanks!

-- 
Thanks,

David / dhildenb

