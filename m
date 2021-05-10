Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC94379234
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbhEJPQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:16:14 -0400
Received: from foss.arm.com ([217.140.110.172]:60792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241151AbhEJPO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 11:14:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B1CA1688;
        Mon, 10 May 2021 08:13:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 328293F719;
        Mon, 10 May 2021 08:13:52 -0700 (PDT)
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
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <65b5cad7-13d8-13a9-9502-7c21e0b72761@arm.com>
Date:   Mon, 10 May 2021 16:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87v97qociy.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 5/10/21 4:04 PM, Marc Zyngier wrote:
> On Mon, 10 May 2021 15:55:28 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 5/10/21 10:49 AM, Marc Zyngier wrote:
>>> KVM currently updates PC (and the corresponding exception state)
>>> using a two phase approach: first by setting a set of flags,
>>> then by converting these flags into a state update when the vcpu
>>> is about to enter the guest.
>>>
>>> However, this creates a disconnect with userspace if the vcpu thread
>>> returns there with any exception/PC flag set. In this case, the exposed
>> The code seems to handle only the KVM_ARM64_PENDING_EXCEPTION
>> flag. Is the "PC flag" a reference to the KVM_ARM64_INCREMENT_PC
>> flag?
> No, it does handle both exception and PC increment, unless I have
> completely bodged something (entirely possible).

The message is correct, my bad.

>
>>> context is wrong, as userpsace doesn't have access to these flags
>> s/userpsace/userspace
>>
>>> (they aren't architectural). It also means that these flags are
>>> preserved across a reset, which isn't expected.
>>>
>>> To solve this problem, force an explicit synchronisation of the
>>> exception state on vcpu exit to userspace. As an optimisation
>>> for nVHE systems, only perform this when there is something pending.
>>>
>>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Cc: stable@vger.kernel.org # 5.11
>>> ---
>>>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>>>  arch/arm64/kvm/arm.c               | 10 ++++++++++
>>>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>>>  4 files changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>> index d5b11037401d..5e9b33cbac51 100644
>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>> @@ -63,6 +63,7 @@
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
>>> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
>>>  
>>>  #ifndef __ASSEMBLY__
>>>  
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 1cb39c0803a4..d62a7041ebd1 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  
>>>  	kvm_sigset_deactivate(vcpu);
>>>  
>>> +	/*
>>> +	 * In the unlikely event that we are returning to userspace
>>> +	 * with pending exceptions or PC adjustment, commit these
>> I'm going to assume "PC adjustment" means the KVM_ARM64_INCREMENT_PC
>> flag. Please correct me if that's not true, but if that's the case,
>> then the flag isn't handled below.
>>
>>> +	 * adjustments in order to give userspace a consistent view of
>>> +	 * the vcpu state.
>>> +	 */
>>> +	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
>>> +					 KVM_ARM64_EXCEPT_MASK)))
>> The condition seems to suggest that it is valid to set
>> KVM_ARM64_EXCEPT_{AA32,AA64}_* without setting
>> KVM_ARM64_PENDING_EXCEPTION, which looks rather odd to me.
>> Is that a valid use of the KVM_ARM64_EXCEPT_MASK bits? If it's not
>> (the existing code always sets the exception type with the
>> KVM_ARM64_PENDING_EXCEPTION), that I was thinking that checking only
>> the KVM_ARM64_PENDING_EXCEPTION flag would make the intention
>> clearer.
> No, you are missing this (subtle) comment in kvm_host.h:
>
> <quote>
> /*
>  * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
>  * set together with an exception...
>  */
> #define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
> </quote>
>
> So (KVM_ARM64_PENDING_EXCEPTION | KVM_ARM64_EXCEPT_MASK) checks for
> *both* an exception and a PC increment.

Then how about explicitly checking for the KVM_ARM64_PENDING_EXCEPTION and
KVM_ARM64_INCREMENT_PC flags, like it's done in __kvm_adjust_pc? That would
certainly make the code easier to understand, as it's not immediately obvious that
the EXCEPT mask includes the INCREMENT_PC flag.

Thanks,

Alex

