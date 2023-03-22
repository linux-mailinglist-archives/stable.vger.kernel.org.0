Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9F6C505F
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 17:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCVQU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 12:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCVQU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 12:20:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F873A867
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 09:20:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54463468d06so191939637b3.7
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 09:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679502023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gW+4nkrtvrpqD1DYdSpd9Q5E1HZhIqm3BROgAyQCa7U=;
        b=M8w/J5hwKrNpQJt4fou1FrsYAMsyxUuW7NVIZQGfzfyw3hUNoJHvatMCnH0lwXWjND
         jitzGv7U/0Vz8ipDuUdWaYJ1SJO6/xoEpainNpchrKP2S2VBgXnaKIE3n2Xb4V/HhyF9
         cRQ2NiI6AqWFIYWBhFMMnvv4LqGhbDW4+8UBHw5/nXG3lhhdRcc8DROeTupXkN8gjgCI
         VagMCsjvT61O3Uyxqqfx4vFBlZ9VEHwic2PQ35DTVTubGiHUeQIvKTPm6lP2oMa8Dxwy
         fpuqfJqugXRPPnboBvYnqOYYhPr0rfFN/jSAbqHbS7B/EnFuu0BO3VFLcXjgIzQym5gc
         TbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679502023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gW+4nkrtvrpqD1DYdSpd9Q5E1HZhIqm3BROgAyQCa7U=;
        b=PyL/UBuM/Z7vZNzPEV47gPidf6F2gE3OU4bUmuv/P8rQ46uzo368ld853Ep+a/ucig
         WRW0mIa0WmWY2Uy9aliMCN9grIViw54Fo7P+c+MZXHni9GlBfyzz9XQEDlO3gijqZGF7
         BOK/LNh4L+sa0QENvLWe6pW5oMyP416SEXJwy+IwDAn7JH3tTTMoX6TTHcmcpVtU8Tix
         vgkrc1cBH9S65LCPHBi0qvkKp2G+NiPX6cAmF5qlQCmEHKpa8KZM78QaDMCA/tXUBrfU
         6iRx8Urthc2IfSSnSJUJysioZiZibjg84r+4ComaOfMx48AxHEXpKeVSVfoZZhrwx2cz
         cpVw==
X-Gm-Message-State: AAQBX9cNTMnm5q+bg8iCAbyGE+hfTPnE2JSGCo/feGkb53BwUo46VrmN
        TrobuuGxFmbngh+xZXECdzfvIbzQKZE=
X-Google-Smtp-Source: AKy350bSMJy9P0JW71a8nrVsm2ruBEsdB6aubGOIi2r2ruMX0d/JVOnKBvzZTJIc0F5aif7z4y4sA664j3I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:688:b0:b6e:850b:77d3 with SMTP id
 i8-20020a056902068800b00b6e850b77d3mr284207ybt.0.1679502023402; Wed, 22 Mar
 2023 09:20:23 -0700 (PDT)
Date:   Wed, 22 Mar 2023 09:20:21 -0700
In-Reply-To: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
Mime-Version: 1.0
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
Message-ID: <ZBsqxeRDh+iV8qmm@google.com>
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023, Jeremi Piotrowski wrote:
> ---
>  arch/x86/kvm/kvm_onhyperv.c | 23 +++++++++++++++++++++++
>  arch/x86/kvm/kvm_onhyperv.h |  5 +++++
>  arch/x86/kvm/svm/svm.c      | 18 +++++++++++++++---
>  3 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> index 482d6639ef88..036e04c0a161 100644
> --- a/arch/x86/kvm/kvm_onhyperv.c
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -94,6 +94,29 @@ int hv_remote_flush_tlb(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
>  
> +void hv_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
> +	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
> +
> +	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb && VALID_PAGE(root_tdp)) {
> +		spin_lock(&kvm_arch->hv_root_tdp_lock);
> +		if (kvm_arch->hv_root_tdp != root_tdp) {
> +			hyperv_flush_guest_mapping(root_tdp);
> +			kvm_arch->hv_root_tdp = root_tdp;

In a vacuum, accessing kvm_arch->hv_root_tdp in the flush path is wrong.  This
likely fixes the issues you are seeing because the KVM bug only affects the case
when KVM is loading a new root (that used to be valid), in which case hv_root_tdp
is guaranteed to be different.  But KVM should not rely on that behavior, i.e. if
KVM says flush, then we flush.  There might be scenarios where the flush is
unnecessary, but those flushes should be elided by the code that knows the flush
is unnecessary, not in this common code just because the target root is the
globally shared root.

Somewhat of a moot point, but setting hv_root_tdp to root_tdp is also wrong.  KVM's
behavior is that hv_root_tdp points at a valid root if and only if all vCPUs share
said root.  E.g. invoking this when vCPUs have different roots will "corrupt"
hv_root_tdp and possibly cause a remote flush to do the wrong thing.

> +		}
> +		spin_unlock(&kvm_arch->hv_root_tdp_lock);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(hv_flush_tlb_current);
> +
> +void hv_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	if (WARN_ON_ONCE(kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb))

Hmm, looking at the KVM code, AFAICT KVM only enables enlightened_npt_tlb for L1
(L1 from KVM's perspective) as svm_hv_init_vmcb() is only ever called with vmcb01,
never with vmcb02.  I don't know if that's intentional, but I do think it means
KVM can skip the Hyper-V flush for vmcb02 and instead rely on the ASID flush,
i.e. KVM can do the Hyper-V iff enlightened_npt_tlb is set in the current VMCB.
And that should continue to work if KVM does ever enabled enlightened_npt_tlb for L2.

> +		hv_remote_flush_tlb(vcpu->kvm);
> +}
> +EXPORT_SYMBOL_GPL(hv_flush_tlb_all);

I'd rather not add helpers to the common KVM code.  I do like minimizing the amount
of #ifdeffery, but defining these as common helpers makes it seem like VMX-on-HyperV
is broken, i.e. raises the question of why VMX doesn't use these helpers when running
on Hyper-V.

I'm thinking this?

---
 arch/x86/kvm/svm/svm.c          | 39 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm_onhyperv.h |  7 ++++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 70183d2271b5..ab97fe8f1d81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3746,7 +3746,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3770,6 +3770,39 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->asid_generation--;
 }
 
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
+	 * flush the NPT mappings via hypercall as flushing the ASID only
+	 * affects virtual to physical mappings, it does not invalidate guest
+	 * physical to host physical mappings.
+	 */
+	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
+		hyperv_flush_guest_mapping(root_tdp);
+#endif
+	svm_flush_tlb_asid(vcpu);
+}
+
+static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
+	 * flushes should be routed to hv_remote_flush_tlb() without requesting
+	 * a "regular" remote flush.  Reaching this point means either there's
+	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
+	 * which might be fatal to the the guest.  Yell, but try to recover.
+	 */
+	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
+		hv_remote_flush_tlb(vcpu->kvm);
+#endif
+	svm_flush_tlb_asid(vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4762,10 +4795,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
-	.flush_tlb_all = svm_flush_tlb_current,
+	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_current,
+	.flush_tlb_guest = svm_flush_tlb_asid,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index cff838f15db5..d91e019fb7da 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -15,6 +15,13 @@ static struct kvm_x86_ops svm_x86_ops;
 
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
+static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
+{
+	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
+
+	return !!hve->hv_enlightenments_control.enlightened_npt_tlb;
+}
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;

base-commit: 50f13998451effea5c5fdc70fe576f8b435d6224
-- 

