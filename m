Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52970640BDC
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiLBRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiLBRMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:12:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3776BE7877
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 09:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670001082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Usmp2CDAvNfy2M2omAE7j3vT3EFJoDk3WrwAZjTClPA=;
        b=HKMZQphsszwE4Zv8uPwdzuyq6Hvzlg4UA9cmuQC0f0nx0+YdLhHW0E1/+d3uFv3BgciWHo
        7joDQ8rljYIOSptt5L17X0lcOUT6vUxqYz+eup1E6cZLrku9oaCW/kXs4enmUxKtKHmVs9
        wth1s/uz/U0+/ikXH6cpg5CBjQW9q3E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-a-7oCnquMDOBSzekCLIhZA-1; Fri, 02 Dec 2022 12:11:21 -0500
X-MC-Unique: a-7oCnquMDOBSzekCLIhZA-1
Received: by mail-wr1-f69.google.com with SMTP id q13-20020adfab0d000000b002420132f543so1229117wrc.19
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 09:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Usmp2CDAvNfy2M2omAE7j3vT3EFJoDk3WrwAZjTClPA=;
        b=SCaIuYIz8DMwWzbl0CemJXwFo22isSDACvLu5anuWkDKVwkJVbhYMFULlmlwbRRJS8
         PQZ9lGcNai+Vl5CP1fX4XESugHGSSiexbrjQW/r/ex4ooboU/I6SRyQAsmdu/lzy4i5E
         cT2g44jvWrlcKiSSYltd2qWSrl03JRkn0ICtvUfemn01uuYvsusAoAMZgL8qlrgvqdg2
         kDUmTKWfSc42s55Fy76v0Yk+YtifLsxiCKzB9F54w2aufDlsvEm0wp/2p/MbOeMIiHHm
         srYn/MzOVWvszGBsn0dDYnrUYnsXKpP5KsGwEIX9MtQ2WHePmIjA61LGR8gqAhbTFXeA
         LqXQ==
X-Gm-Message-State: ANoB5pkeK51jRFVmiXJEPcDzwoZfheoZmdhxjGKIkihwIi8PBhjZQn/0
        Y7kEAk2zC/Y5W511M7LsIAeNLtXeH2hn1waSwdeSPmsSmcPW5WJffqR/cqFTUA1JrGv1l9tGVwb
        caTH6dDRPXF3s5gi6
X-Received: by 2002:a05:600c:4e09:b0:3cf:55bd:4944 with SMTP id b9-20020a05600c4e0900b003cf55bd4944mr55175176wmq.64.1670001079840;
        Fri, 02 Dec 2022 09:11:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5x3wkkVzcb4HhqTzh3nzX1sXgFuCWZUpG5xrlEzmhIcsg9cFkabOgq2bh23ViczIQ35ByNfQ==
X-Received: by 2002:a05:600c:4e09:b0:3cf:55bd:4944 with SMTP id b9-20020a05600c4e0900b003cf55bd4944mr55175147wmq.64.1670001079507;
        Fri, 02 Dec 2022 09:11:19 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:7a00:852e:72cd:ed76:d72f? (p200300cbc7037a00852e72cded76d72f.dip0.t-ipconnect.de. [2003:cb:c703:7a00:852e:72cd:ed76:d72f])
        by smtp.gmail.com with ESMTPSA id e18-20020a5d4e92000000b0024206ed539fsm7307560wru.66.2022.12.02.09.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 09:11:19 -0800 (PST)
Message-ID: <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
Date:   Fri, 2 Dec 2022 18:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
From:   David Hildenbrand <david@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221202122748.113774-1-david@redhat.com> <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
Content-Language: en-US
Organization: Red Hat
In-Reply-To: <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.12.22 17:56, David Hildenbrand wrote:
> On 02.12.22 17:33, Peter Xu wrote:
>> On Fri, Dec 02, 2022 at 01:27:48PM +0100, David Hildenbrand wrote:
>>> Currently, we don't enable writenotify when enabling userfaultfd-wp on
>>> a shared writable mapping (for now we only support SHMEM). The consequence
>>
>> and hugetlbfs
>>
>>> is that vma->vm_page_prot will still include write permissions, to be set
>>> as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
>>> page migration, ...).
>>
>> The thing is by default I think we want the write bit..
>>
>> The simple example is (1) register UFFD_WP on shmem writable, (2) write a
>> page.  Here we didn't wr-protect anything, so we want the write bit there.
>>
>> Or the other example is when UFFDIO_COPY with flags==0 even if with
>> VM_UFFD_WP.  We definitely wants the write bit.
>>
>> We only doesn't want the write bit when uffd-wp is explicitly set.
>>
>> I think fundamentally the core is uffd-wp is pte-based, so the information
>> resides in pte not vma.  I'm not strongly objecting this patch, especially
>> you mentioned auto-numa so I need to have a closer look later there.
>> However I do think uffd-wp is slightly special because we always need to
>> consider pte information anyway, so a per-vma information doesn't hugely
>> help, IMHO.
> 
> That's the same as softdirty tracking, IMHO.
> 
> [...]
> 
>>> Running the mprotect() reproducer [1] without this commit:
>>>     $ ./uffd-wp-mprotect
>>>     FAIL: uffd-wp did not fire
>>> Running the mprotect() reproducer with this commit:
>>>     $ ./uffd-wp-mprotect
>>>     PASS: uffd-wp fired
>>>
>>> [1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u
>>
>> I still hope for a formal patch (non-rfc) we can have a reproducer outside
>> mprotect().  IMHO mprotect() is really ambiguously here being used with
>> uffd-wp, so not a good example IMO as I explained in the other thread [1].
> 
> I took the low hanging fruit to showcase that this is a more generic problem.
> The reproducer is IMHO nice because it's simple and race-free.
> 
>>
>> I'll need to off-work most of the rest of today, but maybe I can also have
>> a look in the weekend or Monday more on the numa paths.  Before that, can
>> we first reach a consensus that we have the mm/migrate patch there to be
>> merged first?  These are two issues, IMHO.
>>
>> I know you're against me for some reason, but until now I sincerely don't
>> know why.  That patch sololy recovers write bit status (by removing it for
>> read-only) for a migration entry and that definitely makes sense to me.  As
>> I also mentioned in the old version of that thread, we can rework migration
>> entries and merge READ|WRITE entries into a GENERIC entry one day if you
>> think proper, but that's for later.
> 
> I'm not against you. I'm against changing well-working, common code
> when it doesn't make any sense to me to change it. And now we have proof that
> mprotect() just behaves exactly the same way, using the basic rules of vma->vm_page_prot.
> 
> Yes, there is broken sparc64 (below), but that shouldn't dictate our implementation.
> 
> 
> What *would* make sense to me, as I raised, is:
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dff333593a8a..9fc181fd3c5a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -213,8 +213,10 @@ static bool remove_migration_pte(struct folio *folio,
>                           pte = pte_mkdirty(pte);
>                   if (is_writable_migration_entry(entry))
>                           pte = maybe_mkwrite(pte, vma);
> -               else if (pte_swp_uffd_wp(*pvmw.pte))
> +               else if (pte_swp_uffd_wp(*pvmw.pte)) {
>                           pte = pte_mkuffd_wp(pte);
> +                       pt = pte_wrprotect(pte);
> +               }
>    
>                   if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
>                           rmap_flags |= RMAP_EXCLUSIVE;
> 
> 
> It still requires patch each and every possible code location, which I dislike as
> described in the patch description. The fact that there are still uffd-wp bugs
> with your patch makes that hopefully clear. I'd be interested if they can be
> reproduced witht his patch.
> 

And if NUMA hinting is indeed the problem, without this patch what would
be required would most probably be:


diff --git a/mm/memory.c b/mm/memory.c
index 8a6d5c823f91..869d35ef0e24 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4808,6 +4808,8 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
         pte = pte_mkyoung(pte);
         if (was_writable)
                 pte = pte_mkwrite(pte);
+       if (pte_uffd_wp(pte))
+               pte = pte_wrprotect(pte);
         ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
         update_mmu_cache(vma, vmf->address, vmf->pte);
         pte_unmap_unlock(vmf->pte, vmf->ptl);


And just to make my point about the migration path clearer: doing it your way
would be:

diff --git a/mm/memory.c b/mm/memory.c
index 8a6d5c823f91..a7c4c1a57f6a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4808,6 +4808,8 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
         pte = pte_mkyoung(pte);
         if (was_writable)
                 pte = pte_mkwrite(pte);
+       else
+               pte = pte_wrprotect(pte);
         ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
         update_mmu_cache(vma, vmf->address, vmf->pte);
         pte_unmap_unlock(vmf->pte, vmf->ptl);


And I don't think that's the right approach.


-- 
Thanks,

David / dhildenb

