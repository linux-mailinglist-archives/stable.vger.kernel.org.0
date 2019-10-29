Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E609E8481
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJ2Jca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:32:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:47870 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbfJ2Jc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:32:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E24A2B277;
        Tue, 29 Oct 2019 09:32:27 +0000 (UTC)
Date:   Tue, 29 Oct 2019 10:32:26 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow
 paging is active
Message-ID: <20191029093226.GE838@suse.de>
References: <20191027152323.24326-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027152323.24326-1-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paolo,

On Sun, Oct 27, 2019 at 04:23:23PM +0100, Paolo Bonzini wrote:
> VMX already does so if the host has SMEP, in order to support the combination of
> CR0.WP=1 and CR4.SMEP=1.  However, it is perfectly safe to always do so, and in
> fact VMX already ends up running with EFER.NXE=1 on old processors that lack the
> "load EFER" controls, because it may help avoiding a slow MSR write.  Removing
> all the conditionals simplifies the code.
> 
> SVM does not have similar code, but it should since recent AMD processors do
> support SMEP.  So this patch also makes the code for the two vendors more similar
> while fixing NPT=0, CR0.WP=1 and CR4.SMEP=1 on AMD processors.
> 
> Cc: stable@vger.kernel.org
> Cc: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Looks good to me.

Reviewed-by: Joerg Roedel <jroedel@suse.de>

> ---
>  arch/x86/kvm/svm.c     | 10 ++++++++--
>  arch/x86/kvm/vmx/vmx.c | 14 +++-----------
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b6feb6a11a8d..2c452293c7cc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -732,8 +732,14 @@ static int get_npt_level(struct kvm_vcpu *vcpu)
>  static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  {
>  	vcpu->arch.efer = efer;
> -	if (!npt_enabled && !(efer & EFER_LMA))
> -		efer &= ~EFER_LME;
> +
> +	if (!npt_enabled) {
> +		/* Shadow paging assumes NX to be available.  */
> +		efer |= EFER_NX;
> +
> +		if (!(efer & EFER_LMA))
> +			efer &= ~EFER_LME;
> +	}
>  
>  	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
>  	mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2a2ba277c676..e191d41afb34 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -896,17 +896,9 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
>  	u64 guest_efer = vmx->vcpu.arch.efer;
>  	u64 ignore_bits = 0;
>  
> -	if (!enable_ept) {
> -		/*
> -		 * NX is needed to handle CR0.WP=1, CR4.SMEP=1.  Testing
> -		 * host CPUID is more efficient than testing guest CPUID
> -		 * or CR4.  Host SMEP is anyway a requirement for guest SMEP.
> -		 */
> -		if (boot_cpu_has(X86_FEATURE_SMEP))
> -			guest_efer |= EFER_NX;
> -		else if (!(guest_efer & EFER_NX))
> -			ignore_bits |= EFER_NX;
> -	}
> +	/* Shadow paging assumes NX to be available.  */
> +	if (!enable_ept)
> +		guest_efer |= EFER_NX;
>  
>  	/*
>  	 * LMA and LME handled by hardware; SCE meaningless outside long mode.
> -- 
> 2.21.0
