Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884A84BE9BD
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358829AbiBUNSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 08:18:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiBUNSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 08:18:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D2AA1EEDB
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 05:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645449473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jpxAHuJa9t90aXC8zU1qGrExrwiV9NbX8bXL14xuDgg=;
        b=a7FI/Hn762P+fEOXjwbbfjOlW3opxqLiOOokVWN/bOnH0b+K17C/JuIGne7Rg3UbqW7wYQ
        ilOZ7xhlAuiK6494OikgH2cFdL6fb0YkT4kz8yXRvHoRiA5pXyCcve0TuRWAYTkFWKdHoH
        zAma/GtJapBKuYHISXVLueKwuQN1fYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-rl_wM3ypPOigoSMEa4kSaA-1; Mon, 21 Feb 2022 08:17:50 -0500
X-MC-Unique: rl_wM3ypPOigoSMEa4kSaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32526814243;
        Mon, 21 Feb 2022 13:17:49 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B2B9105C884;
        Mon, 21 Feb 2022 13:17:47 +0000 (UTC)
Message-ID: <263fc33973fa6cea8001bddceed1f69153db5174.camel@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: fix nested tsc scaling when not enabled but
 MSR_AMD64_TSC_RATIO set
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?Q?D=C4=81vis_Mos=C4=81ns?= <davispuh@gmail.com>
Date:   Mon, 21 Feb 2022 15:17:46 +0200
In-Reply-To: <44604447-9686-24b3-4216-71d52eb1a6c2@redhat.com>
References: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
         <20220221103331.58956-1-mlevitsk@redhat.com>
         <44604447-9686-24b3-4216-71d52eb1a6c2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-02-21 at 13:33 +0100, Paolo Bonzini wrote:
> On 2/21/22 11:33, Maxim Levitsky wrote:
> > For compatibility with userspace the MSR_AMD64_TSC_RATIO can be set
> > even when the feature is not exposed to the guest, which breaks assumptions
> > that it has the default value in this case.
> > 
> > Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
> > Cc: stable@vger.kernel.org
> > 
> > Reported-by: Dāvis Mosāns <davispuh@gmail.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> It's not clear how QEMU ends up writing MSR_AMD64_TSC_RATIO_DEFAULT 
> rather than 0, but we clearly have a bug in KVM.  It should not allow 
> writing 0 in the first place if tsc-ratio is not available in the VM.

Qemu currently (the code is very new so it can be changed) writes the initial value of
0 to this msr if tsc scaling is disabled in the guest, or MSR_AMD64_TSC_RATIO_DEFAULT
if the tsc scaling is enabled.

The guest can change it only when TSC scaling is enabled for it.
If tsc scaling is not enabled, both guest reads or writes of this MSR get #GP.

I only allowed qemu writes of this msr because I thought that qemu might
first set the MSR and then set guest CPUID.

Also, for example the MSR_IA32_XSS uses the same logic in KVM.

As for why qemu sets this msr regardless of guest CPUID bit,
it seemed to be cleaner this way - kvm_put_msrs in qemu seems not to 
check guest CPUID but rather only check that KVM supports this msr,
which will be true regardless of guest's CPUID bit.

What do you think?

Best regards,
	Maxim Levitsky


> 
> If QEMU really can get itself in this situation, we cannot fix this 
> except with KVM_CAP_DISABLE_QUIRKS (a quirk that would accept and ignore 
> host-initiated writes if the CPUID bit is not available) or perhaps with 
> a pr_warn_ratelimited and a quick deprecation cycle, until some time 
> after 6.2.1 is released.
> 
> Hmmm... maybe the issue is actually that KVM *returns* 0 from 
> KVM_GET_MSRS?  And in this case, fixing KVM would also prevent QEMU from 
> sending the bogus KVM_SET_MSRS?
> 
> Thanks,
> 
> Paolo
> 
> > ---
> >   arch/x86/kvm/svm/nested.c | 10 ++++------
> >   arch/x86/kvm/svm/svm.c    |  5 +++--
> >   arch/x86/kvm/svm/svm.h    |  1 +
> >   3 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 1218b5a342fc..a2e2436057dc 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -574,14 +574,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
> >   	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
> >   			vcpu->arch.l1_tsc_offset,
> >   			svm->nested.ctl.tsc_offset,
> > -			svm->tsc_ratio_msr);
> > +			svm_get_l2_tsc_multiplier(vcpu));
> >   
> >   	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
> >   
> > -	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
> > -		WARN_ON(!svm->tsc_scaling_enabled);
> > +	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio)
> >   		nested_svm_update_tsc_ratio_msr(vcpu);
> > -	}
> >   
> >   	svm->vmcb->control.int_ctl             =
> >   		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
> > @@ -867,8 +865,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >   		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> >   	}
> >   
> > -	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
> > -		WARN_ON(!svm->tsc_scaling_enabled);
> > +	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio) {
> >   		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> >   		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
> >   	}
> > @@ -1264,6 +1261,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
> >   {
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> >   
> > +	WARN_ON_ONCE(!svm->tsc_scaling_enabled);
> >   	vcpu->arch.tsc_scaling_ratio =
> >   		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
> >   					       svm->tsc_ratio_msr);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 975be872cd1a..5cf6bb5bfd3e 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -911,11 +911,12 @@ static u64 svm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
> >   	return svm->nested.ctl.tsc_offset;
> >   }
> >   
> > -static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> > +u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> >   {
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> >   
> > -	return svm->tsc_ratio_msr;
> > +	return svm->tsc_scaling_enabled ? svm->tsc_ratio_msr :
> > +	       kvm_default_tsc_scaling_ratio;
> >   }
> >   
> >   static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 852b12aee03d..006571dd30df 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -542,6 +542,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> >   			       bool has_error_code, u32 error_code);
> >   int nested_svm_exit_special(struct vcpu_svm *svm);
> >   void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
> > +u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> >   void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
> >   void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
> >   				       struct vmcb_control_area *control);


