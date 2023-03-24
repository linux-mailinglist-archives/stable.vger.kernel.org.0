Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A88F6C7FEC
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 15:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCXOds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 10:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCXOdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 10:33:47 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4B310EB;
        Fri, 24 Mar 2023 07:33:46 -0700 (PDT)
Received: from [192.168.10.39] (unknown [119.155.2.20])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D14B8660311C;
        Fri, 24 Mar 2023 14:33:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679668425;
        bh=FkSmg20lGxtuqjYpseIX/FjQ1FIGEcqzgaU/zd2MrUo=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=kYLya2ajCmE2jdUIJt8TOHQreOItjwPJs1N5zpwL9g7lu3tdG+3bAw7bJVi/U7d5J
         N7gS+hwXqcwT1ieshp7bS/h/UaQl8iimcMMIxqVdOZN0HdIPe8nSTAxZ+ipZIzqzRV
         HsnysM6pQ7XBr4NFnZLNKZuSSm/s44kOiKkMj9AYX5zzspEOemZY82AAz2QRLb4zf3
         d+2eJ7+NmSSAMoWzqUhLA+pFP8GvqewE+UygnnyxoDXFa2iM4VHNyF6POgWKezuYl/
         blyo9msPI9bBZh9Kyt6KQFNkjNrZTsazOP1uBsBKd0czT4TAY34Vu/H/9mp639Fd9l
         cB3lQUt6toEDA==
Message-ID: <b8bd4fd8-8066-f921-0bec-a5e7c684db77@collabora.com>
Date:   Fri, 24 Mar 2023 19:33:38 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW
 optimization path
To:     Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20230324142620.2344140-1-peterx@redhat.com>
Content-Language: en-US
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20230324142620.2344140-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/23 7:26 PM, Peter Xu wrote:
> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> writable even with uffd-wp bit set.  It only happens with hugetlb private
> mappings, when someone firstly wr-protects a missing pte (which will
> install a pte marker), then a write to the same page without any prior
> access to the page.
> 
> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> reaching hugetlb_wp() to avoid taking more locks that userfault won't need.
> However there's one CoW optimization path that can trigger hugetlb_wp()
> inside hugetlb_no_page(), which will bypass the trap.
> 
> This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
> is detected.  The new path will only trigger in the CoW optimization path
> because generic hugetlb_fault() (e.g. when a present pte was wr-protected)
> will resolve the uffd-wp bit already.  Also make sure anonymous UNSHARE
> won't be affected and can still be resolved, IOW only skip CoW not CoR.
> 
> This patch will be needed for v5.19+ hence copy stable.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> ---
> 
> Notes:
> 
> v2 is not on the list but in an attachment in the reply; this v3 is mostly
> to make sure it's not the same as the patch used to be attached.  Sorry
> Andrew, we need to drop the queued one as I rewrote the commit message.
> 
> Muhammad, I didn't attach your T-b because of the slight functional change.
> Please feel free to re-attach if it still works for you (which I believe
> should).
Thank you for the fix.

> 
> thanks,
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfd07f4c143..a58b3739ed4b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		       struct folio *pagecache_folio, spinlock_t *ptl)
>  {
>  	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> -	pte_t pte;
> +	pte_t pte = huge_ptep_get(ptep);
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page;
>  	struct folio *new_folio;
> @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  	unsigned long haddr = address & huge_page_mask(h);
>  	struct mmu_notifier_range range;
>  
> +	/*
> +	 * Never handle CoW for uffd-wp protected pages.  It should be only
> +	 * handled when the uffd-wp protection is removed.
> +	 *
> +	 * Note that only the CoW optimization path (in hugetlb_no_page())
> +	 * can trigger this, because hugetlb_fault() will always resolve
> +	 * uffd-wp bit first.
> +	 */
> +	if (!unshare && huge_pte_uffd_wp(pte))
> +		return 0;
> +
>  	/*
>  	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
>  	 * PTE mapped R/O such as maybe_mkwrite() would do.
> @@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	pte = huge_ptep_get(ptep);
>  	old_page = pte_page(pte);
>  
>  	delayacct_wpcopy_start();

-- 
BR,
Muhammad Usama Anjum
