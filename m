Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EED32C82C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355535AbhCDAeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350181AbhCCTFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 14:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614798216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UoLMKstBrKdSmL1aXA1VyV0RNHRz4sF2B9MnCUrQmn0=;
        b=caJTaH9jJR9HW0Hez6Cd8sQ4tlv8qihyigkP/4GGQlv6y6830jZi+AbFKrGmqI5MOKOvcR
        echxg0uEQf48ZyY9KlbwXikBRflM3w47yNHrjvZNslvKzQgini0BP9ICC6kDia75f9lzkb
        PYcu+5Ggjyx7LbG8rmMCy0Ql1tnXdEE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-q20MGnBKMHyjjlAMPgs5Bw-1; Wed, 03 Mar 2021 14:03:34 -0500
X-MC-Unique: q20MGnBKMHyjjlAMPgs5Bw-1
Received: by mail-qv1-f71.google.com with SMTP id u15so17504084qvo.13
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 11:03:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UoLMKstBrKdSmL1aXA1VyV0RNHRz4sF2B9MnCUrQmn0=;
        b=ukx2F8Coj1R89bvJQWKYE4RijaHxuyVGaHQBEnBRBlM4MwmonyLKWEiPSvUc4LZBWv
         CiNU+5tuxdM5+EgLOglXcnLocQduMlyRpba0S/bsrPV4RCda0yDOiCyBNHgev36G5OvA
         ph4PJ6EQZjCEIWiE4SY3FkUcuBUw+O5gaAzhOTgckagT0jHzjSPjoKaJVIf8Mfi9Nca/
         Pgiub26gwmbHzBK+7aQJK4p08IYhb5ehogIU/SZGImqwHc9MTj9DMaHtpFKbZVqGtSLi
         rAos9UsxrWMVwmzBHdD8un6uF3EdodK6CCgCNZVoCH41K+XI74yb2LhTp6r4CPHfSGoV
         NCFg==
X-Gm-Message-State: AOAM533tht5IwcDtP+7YyxtoiX3RCNFNpPNQeT0yAyo9+o+9zZMmgoyF
        SGvsK/ynx6a6ShCKTYWoWWpAtdCR65uOohPWUfTzuTHZu1WlK3TqJ08UbMaXK5voVYwWaU9dS9T
        tkfe+DnQIiofXorQr
X-Received: by 2002:a0c:b49f:: with SMTP id c31mr604256qve.35.1614798213377;
        Wed, 03 Mar 2021 11:03:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5PF37P+ynLvSYll0RMVL0A9E5K1GNnpbcQIBu/Q3dkFlUVNkM/Ivi1uWHgnQdBHCXB/sDwA==
X-Received: by 2002:a0c:b49f:: with SMTP id c31mr603966qve.35.1614798209781;
        Wed, 03 Mar 2021 11:03:29 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id z65sm15976988qtd.15.2021.03.03.11.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 11:03:28 -0800 (PST)
Date:   Wed, 3 Mar 2021 14:03:27 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH RESEND v3] mm/userfaultfd: fix memory corruption due to
 writeprotect
Message-ID: <20210303190327.GV397383@xz-x1>
References: <20210303095702.3814618-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303095702.3814618-1-namit@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 01:57:02AM -0800, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Userfaultfd self-test fails occasionally, indicating a memory
> corruption.

It's failing very constantly now for me after I got it run on a 40 cores
system...  While indeed not easy to fail on my laptop.

[...]

> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
> Signed-off-by: Nadav Amit <namit@vmware.com>
> 
> ---
> v2->v3:
> * Do not acquire mmap_lock for write, flush conditionally instead [Yu]
> * Change the fixes tag to the patch that made the race apparent [Yu]

Did you forget about this one?  It would still be good to point to 09854ba94c6a
just to show that 5.7/5.8 stable branches shouldn't need this patch as they're
not prone to the tlb data curruption.  Maybe also cc stable with 5.9+?

> * Removing patch to avoid write-protect on uffd unprotect. More
>   comprehensive solution to follow (and avoid the TLB flush as well).
> ---
>  mm/memory.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 9e8576a83147..06da04f98936 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3092,6 +3092,13 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
>  		return handle_userfault(vmf, VM_UFFD_WP);
>  	}
>  
> +	/*
> +	 * Userfaultfd write-protect can defer flushes. Ensure the TLB
> +	 * is flushed in this case before copying.
> +	 */
> +	if (userfaultfd_wp(vmf->vma) && mm_tlb_flush_pending(vmf->vma->vm_mm))
> +		flush_tlb_page(vmf->vma, vmf->address);
> +
>  	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
>  	if (!vmf->page) {
>  		/*
> -- 
> 2.25.1
> 

Thanks for being consistent on fixing this problem.

Maybe it's even better to put that into a "unlikely" to reduce the affect of
normal do_wp_page as much as possible?  But I'll leave it to others.

If with the fixes tag modified:

Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

