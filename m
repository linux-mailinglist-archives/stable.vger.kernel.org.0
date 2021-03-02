Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBA632AEFB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhCCAMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:12:37 -0500
Received: from foss.arm.com ([217.140.110.172]:49484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349653AbhCBLBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:01:41 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89414ED1;
        Tue,  2 Mar 2021 02:59:57 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68EE3F73C;
        Tue,  2 Mar 2021 02:59:55 -0800 (PST)
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
 <efc29f9b-22a9-06c5-9ba0-49cb0d9053b3@arm.com>
 <abd64d8f-8194-635c-307d-f47ff3dbb498@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b034d200-f190-d4dc-f7a0-4dd9e1ccfe08@arm.com>
Date:   Tue, 2 Mar 2021 11:00:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <abd64d8f-8194-635c-307d-f47ff3dbb498@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Suzuki,

On 3/2/21 10:01 AM, Suzuki K Poulose wrote:
> Hi Alex
>
> On 3/1/21 4:32 PM, Alexandru Elisei wrote:
>> Hello Suzuki,
>>
>> On 2/25/21 7:35 PM, Suzuki K Poulose wrote:
>>> The nvhe hyp saves the SPE context, flushing any unwritten
>>
>> Perhaps that can be reworded to "The nVHE world switch code saves [..]".
>>
>
> Sure
>
>> Also, according to my understanding of "context", that means saving *all* the
>> related registers. But KVM saves only *one* register, PMSCR_EL1. I think stating
>> that KVM disables sampling and drains the buffer would be more accurate.
>
> I understand that the "context" meaning could be interpreted differently. It could
> also mean necessary registers. In this case, as such the guest can't access the
> SPE,
> thus saving the "state" of the SPE only involves saving the PMSCR and restoring
> the same. But when we get to to enabling the Guest access, this would mean
> saving the other registers too. But yes, your suggestion is clearer, will use
> that.
>
>>
>>> data before we switch to the guest. But this operation is
>>> performed way too late, because :
>>>    - The ownership of the SPE is transferred to EL2. i.e,
>>
>> I think the Arm ARM defines only the ownership of the SPE *buffer* (buffer owning
>> regime), not the ownership of SPE as a whole.
>
> True. While it means the buffer ownership, all registers except the PMBIDR is
> inaccessible to an EL, if the buffer is not accessible (i.e, the ownership is
> with a higher EL).
>
>>
>>>      using EL2 translations. (MDCR_EL2_E2PB == 0)
>>
>> I think "EL2 translations" is bit too vague, EL2 stage 1 translation would be more
>> precise, since we're talking only about the nVHE case.
>
> True.
>
>>
>>>    - The guest Stage1 is loaded.
>>>
>>> Thus the flush could use the host EL1 virtual address,
>>> but use the EL2 translations instead. Fix this by
>>
>> It's not *could*, it's *will*. The SPE buffer will use the buffer pointer
>
> Well, if there was nothing to flush, or if the SPE had flushed any data before
> we entered the EL2, then there wouldn't be anything left with the flush.
>
>> programmed by the host at EL1, but will attempt to translate it using EL2 stage 1
>> translation, where it's (probably) not mapped.
>>
>>> and before we change the ownership to EL2.
>>
>> Same comment about ownership.
>>
>>> The restore path is doing the right thing.
>>>
>>> Fixes: 014c4c77aad7 ("KVM: arm64: Improve debug register save/restore flow")
>>> Cc: stable@vger.kernel.org
>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>> New patch.
>>> ---
>>>   arch/arm64/include/asm/kvm_hyp.h   |  5 +++++
>>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++++++--
>>>   arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++++++++-
>>>   3 files changed, 26 insertions(+), 3 deletions(-)
>>>
>
>>>   diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c
>>> b/arch/arm64/kvm/hyp/nvhe/switch.c
>>> index f3d0e9eca56c..10eed66136a0 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
>>> @@ -192,6 +192,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>>       pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
>>>         __sysreg_save_state_nvhe(host_ctxt);
>>> +    /*
>>> +     * For nVHE, we must save and disable any SPE
>>> +     * buffers, as the translation regime is going
>>
>> I'm not sure what "save and disable any SPE buffers" means. The code definitely
>> doesn't save anything related to the SPE buffer. Maybe you're trying to say that
>
> Agreed, this could be clearer. "save" implies the state of the SPE buffer, not the
> entire buffer as such. It does save the PMSCR_EL1, which controls where the
> profiling
> is permitted. In turn, we disable the profiling at EL1&0, preventing the any
> further
> generation of data written to the buffer.
>
>> it must drain the buffer contents to memory? Also, SPE has only *one* buffer.
>>
>
> The details on what we do exactly are already in the function where
> we take the action. So, we don't need to explain those here. The
> comment here is there to give a notice on the dependency on other context
> operations, in case someone tries to move this code around.
>
>>> +     * to be loaded with that of the guest. And we must
>>> +     * save host context for SPE, before we change the
>>> +     * ownership to EL2 (via MDCR_EL2_E2PB == 0)  and before
>>
>> Same comments about "save host context for SPE" (from what I understand that
>> "context" means, KVM doesn't do that) and ownership (SPE doesn't have an
>> ownership, the SPE buffer has an owning translation regime).
>>
>>> +     * we load guest Stage1.
>>> +     */
>>> +    __debug_save_host_buffers_nvhe(vcpu);
>>>         __adjust_pc(vcpu);
>>>   @@ -234,11 +243,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>>       if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
>>>           __fpsimd_save_fpexc32(vcpu);
>>>   +    __debug_switch_to_host(vcpu);
>>>       /*
>>>        * This must come after restoring the host sysregs, since a non-VHE
>>>        * system may enable SPE here and make use of the TTBRs.
>>>        */
>>> -    __debug_switch_to_host(vcpu);
>>> +    __debug_restore_host_buffers_nvhe(vcpu);
>>>         if (pmu_switch_needed)
>>>           __pmu_switch_to_host(host_ctxt);
>>
>> The patch looks correct to me. There are several things that are wrong with the
>> way KVM drains the SPE buffer in __debug_switch_to_guest():
>>
>> 1. The buffer is drained after the guest's stage 1 is loaded in
>> __sysreg_restore_state_nvhe() -> __sysreg_restore_el1_state().
>>
>> 2. The buffer is drained after HCR_EL2.VM is set in __activate_traps() ->
>> ___activate_traps(), which means that the buffer would have use the guest's stage
>> 1 + host's stage 2 for address translation if not 3 below.
>>
>> 3. And finally, the buffer is drained after MDCR_EL2.E2PB is set to 0b00 in
>> __activate_traps() -> __activate_traps_common() (vcpu->arch.mdcr_el2 is computed
>> in kvm_arch_vcpu_ioctl_run() -> kvm_arm_setup_debug() before __kvm_vcpu_run(),
>> which means that the buffer will end up using the EL2 stage 1 translation because
>> of the ISB after sampling is disabled.
>>
>
> Correct.
>
>> Your fix looks correct to me, we drain the buffer and disable event sampling
>> before we start restoring any of the state associated with the guest, and we
>> re-enable profiling after we restore all the host's state relevant for profiling.
>
> Thanks for the review.

I agree with your suggestions, when you respin this patch please add my R-b:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

