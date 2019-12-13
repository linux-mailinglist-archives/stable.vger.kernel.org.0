Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F71411E0BA
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 10:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLMJ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 04:29:04 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:53920 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbfLMJ3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 04:29:04 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifhFr-00024d-DZ; Fri, 13 Dec 2019 10:28:59 +0100
To:     Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device  mappings
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 13 Dec 2019 09:28:59 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <stable@vger.kernel.org>
In-Reply-To: <20191213082920.GA28840@e113682-lin.lund.arm.com>
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
 <20191213082920.GA28840@e113682-lin.lund.arm.com>
Message-ID: <7f86824f4cbd17cd75ef347473e34278@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: christoffer.dall@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christoffer,

On 2019-12-13 08:29, Christoffer Dall wrote:
> Hi Marc,
>
> On Wed, Dec 11, 2019 at 04:56:48PM +0000, Marc Zyngier wrote:
>> A device mapping is normally always mapped at Stage-2, since there
>> is very little gain in having it faulted in.
>
> It is actually becoming less clear to me what the real benefits of
> pre-populating the stage 2 page table are, especially given that we 
> can
> provoke a situation where they're faulted in anyhow.  Do you recall 
> if
> we had any specific case that motivated us to pre-fault in the pages?

It's only a minor performance optimization that was introduced by Ard 
in
8eef91239e57d. Which makes sense for platform devices that have a 
single
fixed location in memory. It makes slightly less sense for PCI, where
you can move things around.

>> Nonetheless, it is possible to end-up in a situation where the 
>> device
>> mapping has been removed from Stage-2 (userspace munmaped the VFIO
>> region, and the MMU notifier did its job), but present in a 
>> userspace
>> mapping (userpace has mapped it back at the same address). In such
>> a situation, the device mapping will be demand-paged as the guest
>> performs memory accesses.
>>
>> This requires to be careful when dealing with mapping size, cache
>> management, and to handle potential execution of a device mapping.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  virt/kvm/arm/mmu.c | 21 +++++++++++++++++----
>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index a48994af70b8..0b32a904a1bb 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -38,6 +38,11 @@ static unsigned long io_map_base;
>>  #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
>>  #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
>>
>> +static bool is_iomap(unsigned long flags)
>> +{
>> +	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
>> +}
>> +
>
> nit: I'm not really sure this indirection makes the code more 
> readable,
> but I guess that's a matter of taste.
>
>>  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>>  {
>>  	return memslot->dirty_bitmap && !(memslot->flags & 
>> KVM_MEM_READONLY);
>> @@ -1698,6 +1703,7 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>
>>  	vma_pagesize = vma_kernel_pagesize(vma);
>>  	if (logging_active ||
>> +	    (vma->vm_flags & VM_PFNMAP) ||
>
> WHat is actually the rationale for this?
>
> Why is a huge mapping not permitted to device memory?
>
> Are we guaranteed that VM_PFNMAP on the vma results in device 
> mappings?
> I'm not convinced this is the case, and it would be better if we can
> stick to a single primitive (either kvm_is_device_pfn, or VM_PFNMAP) 
> to
> detect device mappings.

For now, I've tried to keep the two paths that deal with mapping 
devices
(or rather, things that we interpret as devices) as close as possible.
If we drop the "eager" mapping, then we're at liberty to restructure
this in creative ways.

This includes potential huge mappings, but I'm not sure the rest of the
kernel uses them for devices anyway (I need to find out).

> As a subsequent patch, I'd like to make sure that at the very least 
> our
> memslot prepare function follows the exact same logic for mapping 
> device
> memory as a fault-in approach does, or that we simply always fault 
> pages
> in.

As far as I can see, the two approach are now identical. Am I missing 
something?
And yes, getting rid of the eager mapping works for me.

>
>>  	    !fault_supports_stage2_huge_mapping(memslot, hva, 
>> vma_pagesize)) {
>>  		force_pte = true;
>>  		vma_pagesize = PAGE_SIZE;
>> @@ -1760,6 +1766,9 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  			writable = false;
>>  	}
>>
>> +	if (exec_fault && is_iomap(flags))
>> +		return -ENOEXEC;
>> +
>
> nit: why don't you just do this when checking kvm_is_device_pfn() and
> avoid having logic in two places to deal with this case?

Good point. I've already sent the PR, but that could be a further 
cleanup.

>
>>  	spin_lock(&kvm->mmu_lock);
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>> @@ -1781,7 +1790,7 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  	if (writable)
>>  		kvm_set_pfn_dirty(pfn);
>>
>> -	if (fault_status != FSC_PERM)
>> +	if (fault_status != FSC_PERM && !is_iomap(flags))
>>  		clean_dcache_guest_page(pfn, vma_pagesize);
>>
>>  	if (exec_fault)
>> @@ -1948,9 +1957,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu 
>> *vcpu, struct kvm_run *run)
>>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>>  		if (is_iabt) {
>>  			/* Prefetch Abort on I/O address */
>> -			kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>> -			ret = 1;
>> -			goto out_unlock;
>> +			ret = -ENOEXEC;
>> +			goto out;
>>  		}
>>
>>  		/*
>> @@ -1992,6 +2000,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu 
>> *vcpu, struct kvm_run *run)
>>  	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
>>  	if (ret == 0)
>>  		ret = 1;
>> +out:
>> +	if (ret == -ENOEXEC) {
>> +		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>> +		ret = 1;
>> +	}
>>  out_unlock:
>>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>  	return ret;
>> --
>> 2.20.1
>>
>
> I can't seem to decide for myself if I think there's a sematic
> difference between trying to execute from somewhere the VMM has
> explicitly told us is device memory and from somewhere which we 
> happen
> to have mapped with VM_PFNMAP from user space.  But I also can't seem 
> to
> really fault it (pun intended).  Thoughts?

The issue is that the VMM never really tells us whether something is a
device mapping or not (the only exception being the GICv2 cpuif). Even
with PFNMAP, we guess it (it could well be memory that lives outside
of the linear mapping). I don't see a way to lift this ambiguity.

Ideally, faulting on executing a non-mapping should be offloaded to
userspace for emulation, in line with your patches that offload
non-emulated data accesses. That'd be a new ABI, and I can't imagine
anyone willing to deal with it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
