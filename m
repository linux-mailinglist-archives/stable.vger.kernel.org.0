Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3973EA9B0
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhHLRoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236596AbhHLRoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628790219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVxspxBIf4dI6q7lz4k691Rjsi9GcI9PfQmzOKJoGec=;
        b=BNfA7EvLuFo8FJ/0yly8gihXFrSrLF1hxXaYBFT+EfdNE3VJnt6ORgNI7NnRR6ZGeOXzZq
        f8nrRWldG72Mzo9KQco1WJnYVeMB+QUkro2WLbfrPD25UlX/QTYGW+YyWxVHQnfl/zEezD
        SYlcB+T/WOttXylHKSNL5yIQp5RF9bg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-kU6RyYawPJCf3D3a-8bIBQ-1; Thu, 12 Aug 2021 13:43:38 -0400
X-MC-Unique: kU6RyYawPJCf3D3a-8bIBQ-1
Received: by mail-ed1-f71.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso3397426edh.6
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GVxspxBIf4dI6q7lz4k691Rjsi9GcI9PfQmzOKJoGec=;
        b=ATND9dc7hrwiuVPfX0366Nj3VDVAnBhVDpuiPB3bPOjtI4E4Q40Bo63a7xeQcFpClf
         ycoshVAtSzVqXL1dzALrg3Odr3qZvF2VVjzlnNK7jJWh7Y6KZOvl+avj13dGg/j4Z0XZ
         YyIFGi71YXb+23+UxBXb3aILrcLf2RWx6I686OOB2IZdkGzi1DWNbzyWh+yE1j9zjG7G
         DpvYJaGT3KYCShRvgQ9AGk4/PjrNMg9pg8oCmW71FVxksaT4VWGuWn7JimyaCJyIUq8O
         JYrqmWAQHWNWU6DfjC4x/3Bi46TLqBvKLZc3pGfKUhuj3Tach7lEblZT5M43rIiU+Jyr
         oFEQ==
X-Gm-Message-State: AOAM533l8kcTL8Kklp8aURgbIHFZ4p0MoeUyq8rBdY5lrN+1U4xflhnk
        8c1QEVFdMfVpZa5RE24xR5D/m3EoQYMXELbOG5Rz7n+f/Pl0ZT38TUnhv8YBn8uKZmtFJX95WqK
        FHvinrIOTDJ7ovs4rUEHmtlohPXpyga4ydPKhEcZ9QCMI0Xnd3wtQCGADOB+HcEcrWLXk
X-Received: by 2002:a05:6402:1d19:: with SMTP id dg25mr6813678edb.153.1628790216600;
        Thu, 12 Aug 2021 10:43:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSXvfZueEhHAbCJPwLkaQN2ZrALR+1mejnCeKzq3bpuMeNj9385PZmYHWVl4Iw6S6a1//R4A==
X-Received: by 2002:a05:6402:1d19:: with SMTP id dg25mr6813661edb.153.1628790216448;
        Thu, 12 Aug 2021 10:43:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id sa21sm1075789ejb.108.2021.08.12.10.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 10:43:35 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: MMU: Use the correct inherited permissions to
 get shadow page
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210812174140.2370680-1-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d484772-d50c-dd61-33e7-ce7c85ee22a8@redhat.com>
Date:   Thu, 12 Aug 2021 19:43:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812174140.2370680-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/08/21 19:41, Ovidiu Panait wrote:
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
>       - apply documentation changes to Documentation/virtual/kvm/mmu.txt
>       - adjusted context in arch/x86/kvm/paging_tmpl.h]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> Note: The backport was validated by running the kvm-unit-tests testcase [1]
> mentioned in the commit message (the testcase fails without the patch and
> passes with the patch applied).
> 
> [1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/47fd6bc54674fb1d8a29c55305042689e8692522
> 
>   Documentation/virtual/kvm/mmu.txt |  4 ++--
>   arch/x86/kvm/paging_tmpl.h        | 14 +++++++++-----
>   2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index e507a9e0421e..851a8abcadce 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
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
> index 8220190b0605..9e15818de973 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -93,8 +93,8 @@ struct guest_walker {
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
> @@ -388,13 +388,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
> @@ -433,7 +435,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	}
>   
>   	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
> +		 __func__, (u64)pte, walker->pte_access,
> +		 walker->pt_access[walker->level - 1]);
>   	return 1;
>   
>   error:
> @@ -602,7 +605,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   {
>   	struct kvm_mmu_page *sp = NULL;
>   	struct kvm_shadow_walk_iterator it;
> -	unsigned direct_access, access = gw->pt_access;
> +	unsigned int direct_access, access;
>   	int top_level, ret;
>   	gfn_t gfn, base_gfn;
>   
> @@ -634,6 +637,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>   		sp = NULL;
>   		if (!is_shadow_present_pte(*it.sptep)) {
>   			table_gfn = gw->table_gfn[it.level - 2];
> +			access = gw->pt_access[it.level - 2];
>   			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
>   					      false, access);
>   		}
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks very much for all these backports!

Paolo

