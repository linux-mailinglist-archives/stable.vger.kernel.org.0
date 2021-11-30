Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DE6462E12
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 08:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhK3IBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:01:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234593AbhK3IBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 03:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638259096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofQ+mTAvWB+lgCzceqE6eZM4DqOGEYL7WnumgczCy5o=;
        b=QHj4XHD1IWfLWWxn3kY4kEq8kakorG6YKXQdLoI8/OE9aU9xo/9WSfcFw2wVv0qL8m3z3m
        y+emExU7EPQv98QHPGlTnvDvmFZtf6nFRq7XGCwRBegmJwofhFY9DQZ9gfMDLIb8WfVCCL
        w7M+OXr6xC+LP4zUw/4g1TuHCczu23o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-LUw9QfZNPaa6gwh_icSZSg-1; Tue, 30 Nov 2021 02:58:11 -0500
X-MC-Unique: LUw9QfZNPaa6gwh_icSZSg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3634785EE62;
        Tue, 30 Nov 2021 07:58:10 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F2221002388;
        Tue, 30 Nov 2021 07:58:08 +0000 (UTC)
Message-ID: <f73c491ce789234d92275e0529b55ebd48f4cfb6.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: check PIR even for vCPUs with disabled
 APICv
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Tue, 30 Nov 2021 09:58:07 +0200
In-Reply-To: <20211123004311.2954158-4-pbonzini@redhat.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
         <20211123004311.2954158-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-22 at 19:43 -0500, Paolo Bonzini wrote:
> The IRTE for an assigned device can trigger a POSTED_INTR_VECTOR even
> if APICv is disabled on the vCPU that receives it.  In that case, the
> interrupt will just cause a vmexit and leave the ON bit set together
> with the PIR bit corresponding to the interrupt.
> 
> Right now, the interrupt would not be delivered until APICv is re-enabled.
> However, fixing this is just a matter of always doing the PIR->IRR
> synchronization, even if the vCPU has temporarily disabled APICv.
> 
> This is not a problem for performance, or if anything it is an
> improvement.  First, in the common case where vcpu->arch.apicv_active is
> true, one fewer check has to be performed.  Second, static_call_cond will
> elide the function call if APICv is not present or disabled.  Finally,
> in the case for AMD hardware we can remove the sync_pir_to_irr callback:
> it is only needed for apic_has_interrupt_for_ppr, and that function
> already has a fallback for !APICv.
> 
> Cc: stable@vger.kernel.org
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/lapic.c   |  2 +-
>  arch/x86/kvm/svm/svm.c |  1 -
>  arch/x86/kvm/x86.c     | 18 +++++++++---------
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 759952dd1222..f206fc35deff 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -707,7 +707,7 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
>  static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
>  {
>  	int highest_irr;
> -	if (apic->vcpu->arch.apicv_active)
> +	if (kvm_x86_ops.sync_pir_to_irr)
>  		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
>  	else
>  		highest_irr = apic_find_highest_irr(apic);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5630c241d5f6..d0f68d11ec70 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4651,7 +4651,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_irr_update = svm_hwapic_irr_update,
>  	.hwapic_isr_update = svm_hwapic_isr_update,
> -	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
>  	.apicv_post_state_restore = avic_post_state_restore,
>  
>  	.set_tss_addr = svm_set_tss_addr,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 441f4769173e..a8f12c83db4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4448,8 +4448,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
>  				    struct kvm_lapic_state *s)
>  {
> -	if (vcpu->arch.apicv_active)
> -		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  	return kvm_apic_get_state(vcpu, s);
>  }
> @@ -9528,8 +9527,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  	if (irqchip_split(vcpu->kvm))
>  		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	else {
> -		if (vcpu->arch.apicv_active)
> -			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  		if (ioapic_in_kernel(vcpu->kvm))
>  			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	}
> @@ -9802,10 +9800,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * This handles the case where a posted interrupt was
> -	 * notified with kvm_vcpu_kick.
> +	 * notified with kvm_vcpu_kick.  Assigned devices can
> +	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
> +	 * so do it even if APICv is disabled on this vCPU.
>  	 */
> -	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> -		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +	if (kvm_lapic_enabled(vcpu))
> +		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  	if (kvm_vcpu_exit_request(vcpu)) {
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> @@ -9849,8 +9849,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;
>  
> -		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> -			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +		if (kvm_lapic_enabled(vcpu))
> +			static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
>  			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

