Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA245B0B3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 01:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhKXA2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 19:28:01 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:39774 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233027AbhKXA2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 19:28:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uy17Q8s_1637713489;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uy17Q8s_1637713489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 08:24:49 +0800
Message-ID: <fb4fefb6-10d8-d184-9f61-f7c7ecddfa12@linux.alibaba.com>
Date:   Wed, 24 Nov 2021 08:24:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH MANUALSEL 5.15 2/8] KVM: X86: Don't reset mmu context when
 X86_CR4_PCIDE 1->0
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211123163630.289306-1-sashal@kernel.org>
 <20211123163630.289306-2-sashal@kernel.org>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <20211123163630.289306-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

[PATCH MANUALSEL 5.15 2/8] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
[PATCH MANUALSEL 5.15 3/8] KVM: X86: Don't check unsync if the original spte is writible

are pure cleanups, they don't need to backport to stable.

Thanks
Lai

On 2021/11/24 00:36, Sasha Levin wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> [ Upstream commit 552617382c197949ff965a3559da8952bf3c1fa5 ]
> 
> X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
> doesn't need to be reset.  It is only required to flush all the guest
> tlb.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20210919024246.89230-2-jiangshanlai@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0644f429f848c..98a0f3c28caec 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1042,9 +1042,10 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
>   
>   void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
>   {
> -	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
> -	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
>   		kvm_mmu_reset_context(vcpu);
> +	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
>   
> 
