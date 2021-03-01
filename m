Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EB33284A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhCAQkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:40:15 -0500
Received: from foss.arm.com ([217.140.110.172]:33520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhCAQdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:33:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 231561042;
        Mon,  1 Mar 2021 08:32:17 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 220633F73C;
        Mon,  1 Mar 2021 08:32:14 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 04/19] kvm: arm64: nvhe: Save the SPE context early
To:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, mathieu.poirier@linaro.org,
        mike.leach@linaro.org, anshuman.khandual@arm.com,
        leo.yan@linaro.org, stable@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
References: <20210225193543.2920532-1-suzuki.poulose@arm.com>
 <20210225193543.2920532-5-suzuki.poulose@arm.com>
Message-ID: <efc29f9b-22a9-06c5-9ba0-49cb0d9053b3@arm.com>
Date:   Mon, 1 Mar 2021 16:32:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225193543.2920532-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Suzuki,

On 2/25/21 7:35 PM, Suzuki K Poulose wrote:
> The nvhe hyp saves the SPE context, flushing any unwritten

Perhaps that can be reworded to "The nVHE world switch code saves [..]".

Also, according to my understanding of "context", that means saving *all* the
related registers. But KVM saves only *one* register, PMSCR_EL1. I think stating
that KVM disables sampling and drains the buffer would be more accurate.

> data before we switch to the guest. But this operation is
> performed way too late, because :
>   - The ownership of the SPE is transferred to EL2. i.e,

I think the Arm ARM defines only the ownership of the SPE *buffer* (buffer owning
regime), not the ownership of SPE as a whole.

>     using EL2 translations. (MDCR_EL2_E2PB == 0)

I think "EL2 translations" is bit too vague, EL2 stage 1 translation would be more
precise, since we're talking only about the nVHE case.

>   - The guest Stage1 is loaded.
>
> Thus the flush could use the host EL1 virtual address,
> but use the EL2 translations instead. Fix this by

It's not *could*, it's *will*. The SPE buffer will use the buffer pointer
programmed by the host at EL1, but will attempt to translate it using EL2 stage 1
translation, where it's (probably) not mapped.

> and before we change the ownership to EL2.

Same comment about ownership.

> The restore path is doing the right thing.
>
> Fixes: 014c4c77aad7 ("KVM: arm64: Improve debug register save/restore flow")
> Cc: stable@vger.kernel.org
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> New patch.
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |  5 +++++
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++++++--
>  arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++++++++-
>  3 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index c0450828378b..385bd7dd3d39 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -83,6 +83,11 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
>  void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
>  void __debug_switch_to_host(struct kvm_vcpu *vcpu);
>  
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
> +void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
> +#endif
> +
>  void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 91a711aa8382..f401724f12ef 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -58,16 +58,24 @@ static void __debug_restore_spe(u64 pmscr_el1)
>  	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
>  }
>  
> -void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> +void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	/* Disable and flush SPE data generation */
>  	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
> +}
> +
> +void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
>  	__debug_switch_to_guest_common(vcpu);
>  }
>  
> -void __debug_switch_to_host(struct kvm_vcpu *vcpu)
> +void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> +}
> +
> +void __debug_switch_to_host(struct kvm_vcpu *vcpu)
> +{
>  	__debug_switch_to_host_common(vcpu);
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f3d0e9eca56c..10eed66136a0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -192,6 +192,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
>  
>  	__sysreg_save_state_nvhe(host_ctxt);
> +	/*
> +	 * For nVHE, we must save and disable any SPE
> +	 * buffers, as the translation regime is going

I'm not sure what "save and disable any SPE buffers" means. The code definitely
doesn't save anything related to the SPE buffer. Maybe you're trying to say that
it must drain the buffer contents to memory? Also, SPE has only *one* buffer.

> +	 * to be loaded with that of the guest. And we must
> +	 * save host context for SPE, before we change the
> +	 * ownership to EL2 (via MDCR_EL2_E2PB == 0)  and before

Same comments about "save host context for SPE" (from what I understand that
"context" means, KVM doesn't do that) and ownership (SPE doesn't have an
ownership, the SPE buffer has an owning translation regime).

> +	 * we load guest Stage1.
> +	 */
> +	__debug_save_host_buffers_nvhe(vcpu);
>  
>  	__adjust_pc(vcpu);
>  
> @@ -234,11 +243,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
>  		__fpsimd_save_fpexc32(vcpu);
>  
> +	__debug_switch_to_host(vcpu);
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE
>  	 * system may enable SPE here and make use of the TTBRs.
>  	 */
> -	__debug_switch_to_host(vcpu);
> +	__debug_restore_host_buffers_nvhe(vcpu);
>  
>  	if (pmu_switch_needed)
>  		__pmu_switch_to_host(host_ctxt);

The patch looks correct to me. There are several things that are wrong with the
way KVM drains the SPE buffer in __debug_switch_to_guest():

1. The buffer is drained after the guest's stage 1 is loaded in
__sysreg_restore_state_nvhe() -> __sysreg_restore_el1_state().

2. The buffer is drained after HCR_EL2.VM is set in __activate_traps() ->
___activate_traps(), which means that the buffer would have use the guest's stage
1 + host's stage 2 for address translation if not 3 below.

3. And finally, the buffer is drained after MDCR_EL2.E2PB is set to 0b00 in
__activate_traps() -> __activate_traps_common() (vcpu->arch.mdcr_el2 is computed
in kvm_arch_vcpu_ioctl_run() -> kvm_arm_setup_debug() before __kvm_vcpu_run(),
which means that the buffer will end up using the EL2 stage 1 translation because
of the ISB after sampling is disabled.

Your fix looks correct to me, we drain the buffer and disable event sampling
before we start restoring any of the state associated with the guest, and we
re-enable profiling after we restore all the host's state relevant for profiling.

Thanks,

Alex

