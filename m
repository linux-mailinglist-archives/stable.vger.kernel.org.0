Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ABD380BB0
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhENOWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 10:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhENOWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 10:22:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B4A60FEE;
        Fri, 14 May 2021 14:21:32 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lhYh0-001PKV-8j; Fri, 14 May 2021 15:21:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 May 2021 15:21:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Zenghui Yu <yuzenghui@huawei.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
In-Reply-To: <c28efbe5-a269-fbf4-2a7e-b905386457bd@arm.com>
References: <20210514104042.1929168-1-maz@kernel.org>
 <20210514104042.1929168-3-maz@kernel.org>
 <c28efbe5-a269-fbf4-2a7e-b905386457bd@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <17ecd812940d854534fe9c24e6bbd655@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, tabba@google.com, james.morse@arm.com, suzuki.poulose@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-14 15:08, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 5/14/21 11:40 AM, Marc Zyngier wrote:
>> KVM currently updates PC (and the corresponding exception state)
>> using a two phase approach: first by setting a set of flags,
>> then by converting these flags into a state update when the vcpu
>> is about to enter the guest.
>> 
>> However, this creates a disconnect with userspace if the vcpu thread
>> returns there with any exception/PC flag set. In this case, the 
>> exposed
>> context is wrong, as userpsace doesn't have access to these flags
> 
> Nitpick: s/userpsace/userspace

Ah, forgot that one.

> 
>> (they aren't architectural). It also means that these flags are
>> preserved across a reset, which isn't expected.
>> 
>> To solve this problem, force an explicit synchronisation of the
>> exception state on vcpu exit to userspace. As an optimisation
>> for nVHE systems, only perform this when there is something pending.
>> 
>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org # 5.11
>> ---
>>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>>  arch/arm64/kvm/arm.c               | 10 ++++++++++
>>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>>  4 files changed, 21 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/kvm_asm.h 
>> b/arch/arm64/include/asm/kvm_asm.h
>> index d5b11037401d..5e9b33cbac51 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -63,6 +63,7 @@
>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
>> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
>> 
>>  #ifndef __ASSEMBLY__
>> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 1cb39c0803a4..c4fe2b71f429 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu 
>> *vcpu)
>> 
>>  	kvm_sigset_deactivate(vcpu);
>> 
>> +	/*
>> +	 * In the unlikely event that we are returning to userspace
>> +	 * with pending exceptions or PC adjustment, commit these
>> +	 * adjustments in order to give userspace a consistent view of
>> +	 * the vcpu state.

I didn't managed to commit this:

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4fe2b71f429..1126eae27400 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -901,7 +901,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
          * In the unlikely event that we are returning to userspace
          * with pending exceptions or PC adjustment, commit these
          * adjustments in order to give userspace a consistent view of
-        * the vcpu state.
+        * the vcpu state. Note that this relies on __kvm_adjust_pc()
+        * being preempt-safe on VHE.
          */
         if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
                                          KVM_ARM64_INCREMENT_PC)))

I promise I'll fold that in!

>> +	 */
>> +	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
>> +					 KVM_ARM64_INCREMENT_PC)))
>> +		kvm_call_hyp(__kvm_adjust_pc, vcpu);
>> +
>>  	vcpu_put(vcpu);
>>  	return ret;
>>  }
>> diff --git a/arch/arm64/kvm/hyp/exception.c 
>> b/arch/arm64/kvm/hyp/exception.c
>> index 0812a496725f..11541b94b328 100644
>> --- a/arch/arm64/kvm/hyp/exception.c
>> +++ b/arch/arm64/kvm/hyp/exception.c
>> @@ -331,8 +331,8 @@ static void kvm_inject_exception(struct kvm_vcpu 
>> *vcpu)
>>  }
>> 
>>  /*
>> - * Adjust the guest PC on entry, depending on flags provided by EL1
>> - * for the purpose of emulation (MMIO, sysreg) or exception 
>> injection.
>> + * Adjust the guest PC (and potentially exception state) depending on
>> + * flags provided by the emulation code.
>>   */
>>  void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
>>  {
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c 
>> b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> index f36420a80474..1632f001f4ed 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> @@ -28,6 +28,13 @@ static void handle___kvm_vcpu_run(struct 
>> kvm_cpu_context *host_ctxt)
>>  	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
>>  }
>> 
>> +static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>> +{
>> +	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
>> +
>> +	__kvm_adjust_pc(kern_hyp_va(vcpu));
>> +}
>> +
>>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context 
>> *host_ctxt)
>>  {
>>  	__kvm_flush_vm_context();
>> @@ -170,6 +177,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
>> 
>>  static const hcall_t host_hcall[] = {
>>  	HANDLE_FUNC(__kvm_vcpu_run),
>> +	HANDLE_FUNC(__kvm_adjust_pc),
>>  	HANDLE_FUNC(__kvm_flush_vm_context),
>>  	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
>>  	HANDLE_FUNC(__kvm_tlb_flush_vmid),
> 
> I'm guessing that the comment mentioned in the cover letter should be 
> in this
> patch, right? Or is the changelog from the cover letter stale?
> 
> Regardless, I trust your judgement regarding the comment and the patch
> looks correct:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
