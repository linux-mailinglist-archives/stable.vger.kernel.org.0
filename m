Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4125F3EB193
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239486AbhHMHhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 03:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhHMHhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 03:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628840216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9jbDiOkRI4hG8rWI8PngfWbG0r8FA1l1gD2sJEJot4=;
        b=hvN5mktqQzewdJOYdIyp4mkBvNqIMqUg15XyBWwPWnyd4gnfjW/Xq/buIzLys8lIeW+ulq
        MdcLhEgspax+pc9FG5ZisKTEDPrXCnaUKTa04KKsT31YIVg9R2J1rx7Nj6MwtlHi/Lw1uQ
        eYjnrC0wn3LiKQjegJYJbspF+RRU8J4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-jTKPbaMQOXe06pWI2ohf_Q-1; Fri, 13 Aug 2021 03:36:55 -0400
X-MC-Unique: jTKPbaMQOXe06pWI2ohf_Q-1
Received: by mail-ed1-f70.google.com with SMTP id d12-20020a50fe8c0000b02903a4b519b413so4460108edt.9
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 00:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s9jbDiOkRI4hG8rWI8PngfWbG0r8FA1l1gD2sJEJot4=;
        b=HpfD4VgGBhzyofn6DQLpFSEQeUKRj4NFNMQM+ubMx6sNqPfJ3BdDtrg1OwMrKHt9fw
         XSqaG6w9G5eSARiHCMEmzoZJfyzf0Xy19fN4Pum5SbCiNz4OxQ5WZR+96sFaPBOQp9zg
         n88lnE0QKwKuEckNwvJD27WjfRsJNnvWiQq3OrYEoKQNTO0tTFlIxwie1HLtFL0uYdml
         mURM9mG2fHPShTscDzRdXE6T5PXtMbqMjjq6DLwiZgj2vV7q9rLK4k+DL0g/sUNGMrpo
         X4nYZlm3K5hfhxATqbtDCKkamDtbip0DLiho63GQk6yDAEYnM+cgBJzhF57izBzcLuZ9
         zFxQ==
X-Gm-Message-State: AOAM531pEP7DPj5+wQ9CWvy49B/huMUPMFeSd8yyib6rG0gyOLGZzILe
        msTbhk0YO/iDvNHw06z7ZPCvm3ZdNH/ilvTHjn3XhfiMcKQOvoh56GtcBwDEJ9s4NlT0i0rVwT8
        vgya51Bfq/xPY0fh6
X-Received: by 2002:a05:6402:5210:: with SMTP id s16mr1419919edd.343.1628840213611;
        Fri, 13 Aug 2021 00:36:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzs156x5UWA6aAhz2Ow5auDsQISK33YKyGjaW8MbB9VdCAEZwzUE9DKpkltWnE+dcRyPta3A==
X-Received: by 2002:a05:6402:5210:: with SMTP id s16mr1419899edd.343.1628840213318;
        Fri, 13 Aug 2021 00:36:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gl2sm263738ejb.110.2021.08.13.00.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 00:36:52 -0700 (PDT)
Subject: Re: [PATCH 5.4 1/1] KVM: X86: MMU: Use the correct inherited
 permissions to get shadow page
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     laijs@linux.alibaba.com
References: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
 <20210811154629.2104425-2-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7db5d5d-b4fd-0779-8183-a0c9e5892364@redhat.com>
Date:   Fri, 13 Aug 2021 09:36:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210811154629.2104425-2-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/08/21 17:46, Ovidiu Panait wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.
> 
> When computing the access permissions of a shadow page, use the effective
> permissions of the walk up to that point, i.e. the logic AND of its parents'
> permissions.  Two guest PxE entries that point at the same table gfn need to
> be shadowed with different shadow pages if their parents' permissions are
> different.  KVM currently uses the effective permissions of the last
> non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
> full ("uwx") permissions, and the effective permissions are recorded only
> in role.access and merged into the leaves, this can lead to incorrect
> reuse of a shadow page and eventually to a missing guest protection page
> fault.
> 
> For example, here is a shared pagetable:
> 
>     pgd[]   pud[]        pmd[]            virtual address pointers
>                       /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
>          /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
>     pgd-|           (shared pmd[] as above)
>          \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
>                       \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
> 
>    pud1 and pud2 point to the same pmd table, so:
>    - ptr1 and ptr3 points to the same page.
>    - ptr2 and ptr4 points to the same page.
> 
> (pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entries)
> 
> - First, the guest reads from ptr1 first and KVM prepares a shadow
>    page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
>    "u--" comes from the effective permissions of pgd, pud1 and
>    pmd1, which are stored in pt->access.  "u--" is used also to get
>    the pagetable for pud1, instead of "uw-".
> 
> - Then the guest writes to ptr2 and KVM reuses pud1 which is present.
>    The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
>    even though the pud1 pmd (because of the incorrect argument to
>    kvm_mmu_get_page in the previous step) has role.access="u--".
> 
> - Then the guest reads from ptr3.  The hypervisor reuses pud1's
>    shadow pmd for pud2, because both use "u--" for their permissions.
>    Thus, the shadow pmd already includes entries for both pmd1 and pmd2.
> 
> - At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
>    because pud1's shadow page structures included an "uw-" page even though
>    its role.access was "u--".
> 
> Any kind of shared pagetable might have the similar problem when in
> virtual machine without TDP enabled if the permissions are different
> from different ancestors.
> 
> In order to fix the problem, we change pt->access to be an array, and
> any access in it will not include permissions ANDed from child ptes.
> 
> The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/
> Remember to test it with TDP disabled.
> 
> The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
> Fix inherited permissions for emulated guest pte updates"), and it
> is hard to find which is the culprit.  So there is no fixes tag here.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: - apply arch/x86/kvm/mmu/* changes to arch/x86/kvm
>       - apply documentation changes to Documentation/virt/kvm/mmu.txt
>       - adjusted context in arch/x86/kvm/paging_tmpl.h]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   Documentation/virt/kvm/mmu.txt |  4 ++--
>   arch/x86/kvm/paging_tmpl.h     | 14 +++++++++-----
>   2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/mmu.txt b/Documentation/virt/kvm/mmu.txt
> index ec072c6bc03f..da1ac6a6398f 100644
> --- a/Documentation/virt/kvm/mmu.txt
> +++ b/Documentation/virt/kvm/mmu.txt
> @@ -152,8 +152,8 @@ Shadow pages contain the following information:
>       shadow pages) so role.quadrant takes values in the range 0..3.  Each
>       quadrant maps 1GB virtual address space.
>     role.access:
> -    Inherited guest access permissions in the form uwx.  Note execute
> -    permission is positive, not negative.
> +    Inherited guest access permissions from the parent ptes in the form uwx.
> +    Note execute permission is positive, not negative.
>     role.invalid:
>       The page is invalid and should not be used.  It is a root page that is
>       currently pinned (by a cpu hardware register pointing to it); once it is
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index a20fc1ba607f..d4a8ad6c6a4b 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -90,8 +90,8 @@ struct guest_walker {
>   	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
>   	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
>   	bool pte_writable[PT_MAX_FULL_LEVELS];
> -	unsigned pt_access;
> -	unsigned pte_access;
> +	unsigned int pt_access[PT_MAX_FULL_LEVELS];
> +	unsigned int pte_access;
>   	gfn_t gfn;
>   	struct x86_exception fault;
>   };
> @@ -406,13 +406,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   		}
>   
>   		walker->ptes[walker->level - 1] = pte;
> +
> +		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
> +		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
>   	} while (!is_last_gpte(mmu, walker->level, pte));
>   
>   	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
>   	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
>   
>   	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
> -	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
>   	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
>   	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
>   	if (unlikely(errcode))
> @@ -451,7 +453,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	}
>   
>   	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
> +		 __func__, (u64)pte, walker->pte_access,
> +		 walker->pt_access[walker->level - 1]);
>   	return 1;
>   
>   error:
> @@ -620,7 +623,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   {
>   	struct kvm_mmu_page *sp = NULL;
>   	struct kvm_shadow_walk_iterator it;
> -	unsigned direct_access, access = gw->pt_access;
> +	unsigned int direct_access, access;
>   	int top_level, ret;
>   	gfn_t gfn, base_gfn;
>   
> @@ -652,6 +655,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   		sp = NULL;
>   		if (!is_shadow_present_pte(*it.sptep)) {
>   			table_gfn = gw->table_gfn[it.level - 2];
> +			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
>   					      false, access);
>   		}
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

