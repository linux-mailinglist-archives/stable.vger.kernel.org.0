Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0943411BAAC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 18:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfLKRxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 12:53:17 -0500
Received: from foss.arm.com ([217.140.110.172]:41414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbfLKRxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 12:53:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B24331B;
        Wed, 11 Dec 2019 09:53:16 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 446DE3F6CF;
        Wed, 11 Dec 2019 09:53:15 -0800 (PST)
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device
 mappings
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        stable@vger.kernel.org
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a8dbd580-ed09-8d46-6ec5-a54bac3a6695@arm.com>
Date:   Wed, 11 Dec 2019 17:53:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211165651.7889-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/11/19 4:56 PM, Marc Zyngier wrote:
> A device mapping is normally always mapped at Stage-2, since there
> is very little gain in having it faulted in.
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
>  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  {
>  	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> @@ -1698,6 +1703,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vma_pagesize = vma_kernel_pagesize(vma);
>  	if (logging_active ||
> +	    (vma->vm_flags & VM_PFNMAP) ||
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

I've tested this patch using the scenario that you described in the commit
message. I've also tested it with the following scenarios:

- The region is mmap'ed as backed by a VFIO device fd and the memslot is created,
it is munmap'ed, then mmap'ed as anonymous.
- The region is mmap'ed as anonymous and the memslot is created, it is munmap'ed,
then mmap'ed as backed by a VFIO device fd.

Everything worked as expected, so:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Just a nitpick, but stage2_set_pte has a local variable iomap which can be
replaced with a call to is_iomap.

Thanks,
Alex
