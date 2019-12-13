Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA2A11DF72
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 09:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfLMI3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 03:29:23 -0500
Received: from foss.arm.com ([217.140.110.172]:49962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMI3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 03:29:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11AF8328;
        Fri, 13 Dec 2019 00:29:22 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75CA43F52E;
        Fri, 13 Dec 2019 00:32:35 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:29:20 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device
 mappings
Message-ID: <20191213082920.GA28840@e113682-lin.lund.arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211165651.7889-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Wed, Dec 11, 2019 at 04:56:48PM +0000, Marc Zyngier wrote:
> A device mapping is normally always mapped at Stage-2, since there
> is very little gain in having it faulted in.

It is actually becoming less clear to me what the real benefits of
pre-populating the stage 2 page table are, especially given that we can
provoke a situation where they're faulted in anyhow.  Do you recall if
we had any specific case that motivated us to pre-fault in the pages?

> 
> Nonetheless, it is possible to end-up in a situation where the device
> mapping has been removed from Stage-2 (userspace munmaped the VFIO
> region, and the MMU notifier did its job), but present in a userspace
> mapping (userpace has mapped it back at the same address). In such
> a situation, the device mapping will be demand-paged as the guest
> performs memory accesses.
> 
> This requires to be careful when dealing with mapping size, cache
> management, and to handle potential execution of a device mapping.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/mmu.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index a48994af70b8..0b32a904a1bb 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -38,6 +38,11 @@ static unsigned long io_map_base;
>  #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
>  #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
>  
> +static bool is_iomap(unsigned long flags)
> +{
> +	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
> +}
> +

nit: I'm not really sure this indirection makes the code more readable,
but I guess that's a matter of taste.

>  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  {
>  	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> @@ -1698,6 +1703,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vma_pagesize = vma_kernel_pagesize(vma);
>  	if (logging_active ||
> +	    (vma->vm_flags & VM_PFNMAP) ||

WHat is actually the rationale for this?

Why is a huge mapping not permitted to device memory?

Are we guaranteed that VM_PFNMAP on the vma results in device mappings?
I'm not convinced this is the case, and it would be better if we can
stick to a single primitive (either kvm_is_device_pfn, or VM_PFNMAP) to
detect device mappings.

As a subsequent patch, I'd like to make sure that at the very least our
memslot prepare function follows the exact same logic for mapping device
memory as a fault-in approach does, or that we simply always fault pages
in.

>  	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
>  		force_pte = true;
>  		vma_pagesize = PAGE_SIZE;
> @@ -1760,6 +1766,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			writable = false;
>  	}
>  
> +	if (exec_fault && is_iomap(flags))
> +		return -ENOEXEC;
> +

nit: why don't you just do this when checking kvm_is_device_pfn() and
avoid having logic in two places to deal with this case?

>  	spin_lock(&kvm->mmu_lock);
>  	if (mmu_notifier_retry(kvm, mmu_seq))
>  		goto out_unlock;
> @@ -1781,7 +1790,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (writable)
>  		kvm_set_pfn_dirty(pfn);
>  
> -	if (fault_status != FSC_PERM)
> +	if (fault_status != FSC_PERM && !is_iomap(flags))
>  		clean_dcache_guest_page(pfn, vma_pagesize);
>  
>  	if (exec_fault)
> @@ -1948,9 +1957,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>  		if (is_iabt) {
>  			/* Prefetch Abort on I/O address */
> -			kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> -			ret = 1;
> -			goto out_unlock;
> +			ret = -ENOEXEC;
> +			goto out;
>  		}
>  
>  		/*
> @@ -1992,6 +2000,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
>  	if (ret == 0)
>  		ret = 1;
> +out:
> +	if (ret == -ENOEXEC) {
> +		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> +		ret = 1;
> +	}
>  out_unlock:
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	return ret;
> -- 
> 2.20.1
> 

I can't seem to decide for myself if I think there's a sematic
difference between trying to execute from somewhere the VMM has
explicitly told us is device memory and from somewhere which we happen
to have mapped with VM_PFNMAP from user space.  But I also can't seem to
really fault it (pun intended).  Thoughts?


Thanks,

    Christoffer
