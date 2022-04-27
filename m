Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50979512400
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 22:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiD0UoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 16:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiD0UoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 16:44:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7886EBB0
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 13:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651092058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFMPjJE+QXYf1X/XGRpB326TaYnBoulTgNBrURc+les=;
        b=f6XRljMUm/13IULNSSXhIbmUzzuGz2eHkKaO55TUONQcKtazqwPdjntoNBPARWEbUt+X3Z
        E0Lv+OcseYAS8shrBYSUomJOSAa0Y1k11folylrUbh1NRPHWXx4dggqi9V20cQyWnJ7U0S
        kpusFvDELQPvZTCVDELjqP3yM1x4Hp4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-mWbQvKmbN8GaGizkGLS-GA-1; Wed, 27 Apr 2022 16:40:57 -0400
X-MC-Unique: mWbQvKmbN8GaGizkGLS-GA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C409381D8A1;
        Wed, 27 Apr 2022 20:40:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8939400E436;
        Wed, 27 Apr 2022 20:40:54 +0000 (UTC)
Message-ID: <f38141478fa37ddff287b48c146261fe7d878379.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Wed, 27 Apr 2022 23:40:53 +0300
In-Reply-To: <20220427173758.517087-2-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
         <20220427173758.517087-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-04-27 at 13:37 -0400, Paolo Bonzini wrote:
> Right now, the VMX preemption timer is special cased via the
> hv_timer_pending, but the purpose of the callback can be easily
> extended to observing any event that can occur only in non-root
> mode.  Interrupts, NMIs etc. are already handled properly by
> the *_interrupt_allowed callbacks, so what is missing is only
> MTF.  Check it in the newly-renamed callback, so that
> kvm_vcpu_running's call to kvm_check_nested_events
> becomes redundant.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/nested.c       | 7 ++++++-
>  arch/x86/kvm/x86.c              | 8 ++++----
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4ff36610af6a..e2e4f60159e9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1504,7 +1504,7 @@ struct kvm_x86_ops {
>  struct kvm_x86_nested_ops {
>  	void (*leave_nested)(struct kvm_vcpu *vcpu);
>  	int (*check_events)(struct kvm_vcpu *vcpu);
> -	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
> +	bool (*has_events)(struct kvm_vcpu *vcpu);
>  	void (*triple_fault)(struct kvm_vcpu *vcpu);
>  	int (*get_state)(struct kvm_vcpu *vcpu,
>  			 struct kvm_nested_state __user *user_kvm_nested_state,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 856c87563883..54672025c3a1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3857,6 +3857,11 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>  	       to_vmx(vcpu)->nested.preemption_timer_expired;
>  }
>  
> +static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
> +{
Typo: needs struct vcpu_vmx *vmx = to_vmx(vcpu);

> +	return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
> +}
> +
>  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6809,7 +6814,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>  struct kvm_x86_nested_ops vmx_nested_ops = {
>  	.leave_nested = vmx_leave_nested,
>  	.check_events = vmx_check_nested_events,
> -	.hv_timer_pending = nested_vmx_preemption_timer_pending,
> +	.has_events = vmx_has_nested_events,
>  	.triple_fault = nested_vmx_triple_fault,
>  	.get_state = vmx_get_nested_state,
>  	.set_state = vmx_set_nested_state,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6ab19afc638..0e73607b02bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9471,8 +9471,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  	}
>  
>  	if (is_guest_mode(vcpu) &&
> -	    kvm_x86_ops.nested_ops->hv_timer_pending &&
> -	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
> +	    kvm_x86_ops.nested_ops->has_events &&
> +	    kvm_x86_ops.nested_ops->has_events(vcpu))
>  		*req_immediate_exit = true;
>  
>  	WARN_ON(vcpu->arch.exception.pending);
> @@ -12183,8 +12183,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  		return true;
>  
>  	if (is_guest_mode(vcpu) &&
> -	    kvm_x86_ops.nested_ops->hv_timer_pending &&
> -	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
> +	    kvm_x86_ops.nested_ops->has_events &&
> +	    kvm_x86_ops.nested_ops->has_events(vcpu))
Nitpick: Won't it make sense to use conditional static call here instead?

>  		return true;
>  
>  	return false;


Besides nitpicks,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Wasn't able to test on my intel laptop, I am getting out of sudden in qemu:

'cpuid_data is full, no space for cpuid(eax:0x8000001d,ecx:0x3e)'

I will investigate tomorrow.

Best regards,
	Maxim Levitsky


