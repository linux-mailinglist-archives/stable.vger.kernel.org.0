Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF7A37AC57
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhEKQum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:50:42 -0400
Received: from foss.arm.com ([217.140.110.172]:51148 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231407AbhEKQum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 12:50:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2921D6E;
        Tue, 11 May 2021 09:49:34 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E14203F718;
        Tue, 11 May 2021 09:49:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
References: <20210510094915.1909484-1-maz@kernel.org>
 <20210510094915.1909484-3-maz@kernel.org>
 <7a0f43c8-cc36-810e-0b8e-ffe66672ca82@arm.com> <87v97qociy.wl-maz@kernel.org>
 <65b5cad7-13d8-13a9-9502-7c21e0b72761@arm.com> <87o8dhogsu.wl-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8ebe6272-5053-be9f-141a-6958562178ff@arm.com>
Date:   Tue, 11 May 2021 17:50:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87o8dhogsu.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 5/11/21 8:44 AM, Marc Zyngier wrote:
> On Mon, 10 May 2021 16:14:37 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 5/10/21 4:04 PM, Marc Zyngier wrote:
>>> On Mon, 10 May 2021 15:55:28 +0100,
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>> Hi Marc,
>>>>
>>>> On 5/10/21 10:49 AM, Marc Zyngier wrote:
>>>>> KVM currently updates PC (and the corresponding exception state)
>>>>> using a two phase approach: first by setting a set of flags,
>>>>> then by converting these flags into a state update when the vcpu
>>>>> is about to enter the guest.
>>>>>
>>>>> However, this creates a disconnect with userspace if the vcpu thread
>>>>> returns there with any exception/PC flag set. In this case, the exposed
>>>> The code seems to handle only the KVM_ARM64_PENDING_EXCEPTION
>>>> flag. Is the "PC flag" a reference to the KVM_ARM64_INCREMENT_PC
>>>> flag?
>>> No, it does handle both exception and PC increment, unless I have
>>> completely bodged something (entirely possible).
>> The message is correct, my bad.
>>
>>>>> context is wrong, as userpsace doesn't have access to these flags
>>>> s/userpsace/userspace
>>>>
>>>>> (they aren't architectural). It also means that these flags are
>>>>> preserved across a reset, which isn't expected.
>>>>>
>>>>> To solve this problem, force an explicit synchronisation of the
>>>>> exception state on vcpu exit to userspace. As an optimisation
>>>>> for nVHE systems, only perform this when there is something pending.
>>>>>
>>>>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> Cc: stable@vger.kernel.org # 5.11
>>>>> ---
>>>>>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>>>>>  arch/arm64/kvm/arm.c               | 10 ++++++++++
>>>>>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>>>>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>>>>>  4 files changed, 21 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>>>> index d5b11037401d..5e9b33cbac51 100644
>>>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>>>> @@ -63,6 +63,7 @@
>>>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
>>>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
>>>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
>>>>> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
>>>>>  
>>>>>  #ifndef __ASSEMBLY__
>>>>>  
>>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>>> index 1cb39c0803a4..d62a7041ebd1 100644
>>>>> --- a/arch/arm64/kvm/arm.c
>>>>> +++ b/arch/arm64/kvm/arm.c
>>>>> @@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>>>  
>>>>>  	kvm_sigset_deactivate(vcpu);
>>>>>  
>>>>> +	/*
>>>>> +	 * In the unlikely event that we are returning to userspace
>>>>> +	 * with pending exceptions or PC adjustment, commit these
>>>> I'm going to assume "PC adjustment" means the KVM_ARM64_INCREMENT_PC
>>>> flag. Please correct me if that's not true, but if that's the case,
>>>> then the flag isn't handled below.
>>>>
>>>>> +	 * adjustments in order to give userspace a consistent view of
>>>>> +	 * the vcpu state.
>>>>> +	 */
>>>>> +	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
>>>>> +					 KVM_ARM64_EXCEPT_MASK)))
>>>> The condition seems to suggest that it is valid to set
>>>> KVM_ARM64_EXCEPT_{AA32,AA64}_* without setting
>>>> KVM_ARM64_PENDING_EXCEPTION, which looks rather odd to me.
>>>> Is that a valid use of the KVM_ARM64_EXCEPT_MASK bits? If it's not
>>>> (the existing code always sets the exception type with the
>>>> KVM_ARM64_PENDING_EXCEPTION), that I was thinking that checking only
>>>> the KVM_ARM64_PENDING_EXCEPTION flag would make the intention
>>>> clearer.
>>> No, you are missing this (subtle) comment in kvm_host.h:
>>>
>>> <quote>
>>> /*
>>>  * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
>>>  * set together with an exception...
>>>  */
>>> #define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
>>> </quote>
>>>
>>> So (KVM_ARM64_PENDING_EXCEPTION | KVM_ARM64_EXCEPT_MASK) checks for
>>> *both* an exception and a PC increment.
>> Then how about explicitly checking for the
>> KVM_ARM64_PENDING_EXCEPTION and KVM_ARM64_INCREMENT_PC flags, like
>> it's done in __kvm_adjust_pc? That would certainly make the code
>> easier to understand, as it's not immediately obvious that the
>> EXCEPT mask includes the INCREMENT_PC flag.
> Fair enough. I'll fix that in v2.
>
> Another thing I wondered about: we now rely on __kvm_adjust_pc() to be
> preemption safe. That's always the case in nVHE (we're at EL2), but
> VHE can be preempted at any point. The code we call is preemption
> safe, but it takes some effort to be convinced of it.
>
> Do you have a good suggestion on how to express this requirement?  I
> could throw a preempt_disable()/enable() at the call for the sake of
> being in the same context between VHE and nVHE, but that's not
> strictly necessary for now.

I've had another look at it, and it does look to me that __kvm_adjust_pc() is safe
to call with preemption enabled on VHE systems. I was a bit worried when I saw
that it touches some EL1 registers directly, but I then I realized that
kvm_arch_vcpu_put/load() will make sure that the values of those registers are
correct.

I do agree that it's not immediately obvious that __kvm_adjust_pc() is called with
preemption enabled. I'm a bit worried that someone will change something and make
the function unsafe from preemption. Since the patch already touches the comment
for __kvm_adjust_pc(), maybe mention that it can be called from contexts with
preemption enabled and why it's safe to do it? Something along the lines of "The
function is called with preemption enabled, and it's safe to do so because even
though it touches the hardware EL1 registers in the VHE case, those registers are
saved and restored by a vcpu_put/load pair. In the NVHE case, the code is running
at EL2 and it cannot be preempted by the host". Or something else that you fancy.

Thanks,

Alex

