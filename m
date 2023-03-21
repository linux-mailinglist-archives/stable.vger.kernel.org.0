Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9256C3ACE
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCUTjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCUTjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446A852911
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679427399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IufgFsRJpEMxp/FKffUoEQzZ0rl2Zjr3udyfqAjAgP8=;
        b=PJOCRJ8ju1hrrJ2iYAzzor0tOsqPZOZCV+1zKsivmKmkn4j8FEoTAPqOvAcme/4jLkuUtf
        p5WfyxOrD7wz3vZ8kJF55n5lSz1JX/3zgkTIOF0sta52vzjooiv1fVZ5bLd701sM4uGmbF
        JpmXvk7zpBj0mTTVHRbd5PuXWwceC2c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-fBfbDWhAMrGlwF1wdW1Dog-1; Tue, 21 Mar 2023 15:36:38 -0400
X-MC-Unique: fBfbDWhAMrGlwF1wdW1Dog-1
Received: by mail-wm1-f70.google.com with SMTP id k29-20020a05600c1c9d00b003ee3a8d547eso1261665wms.2
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427397;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IufgFsRJpEMxp/FKffUoEQzZ0rl2Zjr3udyfqAjAgP8=;
        b=cvLK/5UvEfXHFcr6luzZ10OSqKtjs0MM43SrtAxOww2DhhW5N0Nr4q2U/c7qtEe0JX
         5DzYz1fIR8IT8Y1JaoOpWDsEH00xdIzjtPN/YQkrjSE6p5OtQqpsOnEJOqQ7CLwwqNsf
         Z2K+hBKJmL6EQ7gVclrfCGbi8JLpQ6fW3AqmvaL1T90G9JMHVniDic/V1SIFQyajA/K+
         s+oYbED3YpUDYAbxF0y04M74qOKy8oG8qs2iN4T0FvVLexNPqG+BYyaXtWZILHw04YRD
         SOmzAzpILvueFVG0I73BI4Fq1eQXWFxVYl6EVqv+UOviaQSzwIyN8FWs1NG1uWpl9S4I
         8nVg==
X-Gm-Message-State: AO0yUKUM/k9EHUnDbwVW46OmpqJ3esFUsWYA57iWomB6LVxYpi3uveEU
        WNXhHDDzgw1LMuepbPd8RdAjhrIT9C6SC5ITAnQG1fJuA5L6TF6DDyBoNJo7olCoBWi1sapIymq
        v3zXCIXEIBs9QA62S
X-Received: by 2002:a05:600c:2312:b0:3df:e6bb:768 with SMTP id 18-20020a05600c231200b003dfe6bb0768mr3535118wmo.24.1679427397708;
        Tue, 21 Mar 2023 12:36:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9h8fPjflOzdypqi76qNk4yHTBoYHiz6YZoSnbVedGSf90r++ZgffqBF0e1cmjLWKc7IGJH5w==
X-Received: by 2002:a05:600c:2312:b0:3df:e6bb:768 with SMTP id 18-20020a05600c231200b003dfe6bb0768mr3535095wmo.24.1679427397062;
        Tue, 21 Mar 2023 12:36:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7f00:8245:d031:7f8b:e004? (p200300cbc7057f008245d0317f8be004.dip0.t-ipconnect.de. [2003:cb:c705:7f00:8245:d031:7f8b:e004])
        by smtp.gmail.com with ESMTPSA id d8-20020a1c7308000000b003ed1f6878a5sm14589794wmb.5.2023.03.21.12.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:36:36 -0700 (PDT)
Message-ID: <44aae7fc-fb1f-b38e-bc17-504abf054e3f@redhat.com>
Date:   Tue, 21 Mar 2023 20:36:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230321191840.1897940-1-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230321191840.1897940-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.03.23 20:18, Peter Xu wrote:
> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> writable even with uffd-wp bit set.  It only happens with all these
> conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
> write to the page to trigger.
> 
> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> need.  However there's one CoW optimization path for missing hugetlb page
> that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> userfaultfd-wp traps.
> 
> A few ways to resolve this:
> 
>    (1) Skip the CoW optimization for hugetlb private mapping, considering
>    that private mappings for hugetlb should be very rare, so it may not
>    really be helpful to major workloads.  The worst case is we only skip the
>    optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
>    fault anyway.
> 
>    (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
>    into hugetlb_wp().  The major cons is there're a bunch of locks taken
>    when calling hugetlb_wp(), and that will make the changeset unnecessarily
>    complicated due to the lock operations.
> 
>    (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
>    for uffd-wp privately mapped pages.
> 
> This patch chose option (3) which contains the minimum changeset (simplest
> for backport) and also make sure hugetlb_wp() itself will start to be
> always safe with uffd-wp ptes even if called elsewhere in the future.
> 
> This patch will be needed for v5.19+ hence copy stable.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/hugetlb.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfd07f4c143..22337b191eae 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>   		       struct folio *pagecache_folio, spinlock_t *ptl)
>   {
>   	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> -	pte_t pte;
> +	pte_t pte, newpte;
>   	struct hstate *h = hstate_vma(vma);
>   	struct page *old_page;
>   	struct folio *new_folio;
> @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>   		mmu_notifier_invalidate_range(mm, range.start, range.end);
>   		page_remove_rmap(old_page, vma, true);
>   		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> -		set_huge_pte_at(mm, haddr, ptep,
> -				make_huge_pte(vma, &new_folio->page, !unshare));
> +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> +		if (huge_pte_uffd_wp(pte))
> +			newpte = huge_pte_mkuffd_wp(newpte);
> +		set_huge_pte_at(mm, haddr, ptep, newpte);
>   		folio_set_hugetlb_migratable(new_folio);
>   		/* Make the old page be freed below */
>   		new_folio = page_folio(old_page);

Looks correct to me. Do we have a reproducer?

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

