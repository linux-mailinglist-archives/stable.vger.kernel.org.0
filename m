Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8A761FDCD
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiKGSpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiKGSpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:45:44 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4715A2715B
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 10:45:42 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id t62so13085828oib.12
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 10:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkWAOUOhQk6gVAhMXkMhhoFYVpz+sE1WIEuw3gtFhA0=;
        b=ZunaYDPw7c8/bhbMogn9O05VcaN/gWNZv5vVBP6OLr3kqLxcTL93uaaFCOtpBuCrdi
         hssY18raOh8aVfgE5ZHAgd0ZSpk2b5kZvcuyIi4w9SItSKsQUn1InnV8wHk040cOBoI7
         Uq70h68hWGMsTeW4y+CL1AjcG8nph4na2mxaMLIdlA8gLZkkY/Y0FjS2WnC5IKNg/24Z
         B5jYANEsUQ8zF7caLR1vZ4OewAwSkDeNJ4SkNUUAcMpSpQDIzL8NwOe/z5rUj2uDVzqS
         4TN7TdAo+6Yi76q1vQnwIPVqah1L9JzVVUE7hu6qCXHsau6SJIBZMZzHxptO8ed3Dy2C
         2B1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkWAOUOhQk6gVAhMXkMhhoFYVpz+sE1WIEuw3gtFhA0=;
        b=T1lmVWv+upWS12Q8oQaW6unUsSvRVbeBW2g1W6d/7aAhGbXyhoLvv+vSU5EaAsURiJ
         kLU66o3rBVsPvwGiolSSkAZytPUvhcTgOthYukWZj+lhc1dsv1TuzeBhbYVKAxzXCCUI
         GFh2fokuHiTgjPbDRlKRuZrT5QfQW9VIAn9cFzQDlRyB62Yb4SSziU2k4Hx3DPNr/h+a
         SKTdXsble3MbAG7AVq0iUnGi9+Yfm1ygL71gYtSh9E+EzV9Y75Dwp6DniNdTqulMQqB2
         gQU97KfzMezfqT73xOQ3ZUcgW/jcOAEsIln/szp2jdgMyVa6OSIaUJGfLJrPPhtw6oXM
         lUIA==
X-Gm-Message-State: ACrzQf0Y5pL+3O+86GH1QO77rBo2SZYUtvGkJ3WrJ3AHYAWXjCpYWUnn
        tAwJafk74gqPtTmtAlg9QquEEQELicwcL5+3S8zutPaYXSo=
X-Google-Smtp-Source: AMsMyM5M9vHb7ur0ocW2M7xZqHnT//wf/xuTIn8Pt/t6rFoYAkF7RaqIfJKOhcor5ZaCrPjjunsjNWFxfwFvpvJv/rc=
X-Received: by 2002:aca:6007:0:b0:35a:1bda:d213 with SMTP id
 u7-20020aca6007000000b0035a1bdad213mr21438008oib.181.1667846741344; Mon, 07
 Nov 2022 10:45:41 -0800 (PST)
MIME-Version: 1.0
References: <20221107145436.276079-1-pbonzini@redhat.com> <20221107145436.276079-8-pbonzini@redhat.com>
In-Reply-To: <20221107145436.276079-8-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 7 Nov 2022 10:45:30 -0800
Message-ID: <CALMp9eRDehmWC1gZmSjxjwCvm4VXf_FnR-MiFkHxkTn4_DJ4aA@mail.gmail.com>
Subject: Re: [PATCH 7/8] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, seanjc@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 7, 2022 at 6:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Restoration of the host IA32_SPEC_CTRL value is probably too late
> with respect to the return thunk training sequence.
>
> With respect to the user/kernel boundary, AMD says, "If software chooses
> to toggle STIBP (e.g., set STIBP on kernel entry, and clear it on kernel
> exit), software should set STIBP to 1 before executing the return thunk
> training sequence." I assume the same requirements apply to the guest/host
> boundary. The return thunk training sequence is in vmenter.S, quite close
> to the VM-exit. On hosts without V_SPEC_CTRL, however, the host's
> IA32_SPEC_CTRL value is not restored until much later.
>
> To avoid this, move the restoration of host SPEC_CTRL to assembly and,
> for consistency, move the restoration of the guest SPEC_CTRL as well.
> This is not particularly difficult, apart from some care to cover both
> 32- and 64-bit, and to share code between SEV-ES and normal vmentry.
>
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kernel/asm-offsets.c |  1 +
>  arch/x86/kernel/cpu/bugs.c    | 13 ++---
>  arch/x86/kvm/svm/svm.c        | 38 ++++++---------
>  arch/x86/kvm/svm/svm.h        |  4 +-
>  arch/x86/kvm/svm/vmenter.S    | 92 ++++++++++++++++++++++++++++++++++-
>  5 files changed, 111 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
> index 69d1fed51086..d0bd68af0a5a 100644
> --- a/arch/x86/kernel/asm-offsets.c
> +++ b/arch/x86/kernel/asm-offsets.c
> @@ -115,6 +115,7 @@ static void __used common(void)
>                 OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
>                 OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
>                 OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
> +               OFFSET(SVM_spec_ctrl, vcpu_svm, spec_ctrl);
>                 OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
>         }
>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index da7c361f47e0..6ec0b7ce7453 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -196,22 +196,15 @@ void __init check_bugs(void)
>  }
>
>  /*
> - * NOTE: This function is *only* called for SVM.  VMX spec_ctrl handling is
> - * done in vmenter.S.
> + * NOTE: This function is *only* called for SVM, since Intel uses
> + * MSR_IA32_SPEC_CTRL for SSBD.
>   */
>  void
>  x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
>  {
> -       u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
> +       u64 guestval, hostval;
>         struct thread_info *ti = current_thread_info();
>
> -       if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
> -               if (hostval != guestval) {
> -                       msrval = setguest ? guestval : hostval;
> -                       wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
> -               }
> -       }
> -
>         /*
>          * If SSBD is not handled in MSR_SPEC_CTRL on AMD, update
>          * MSR_AMD64_L2_CFG or MSR_VIRT_SPEC_CTRL if supported.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 381c7dcffe25..31aa158a2e10 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -731,6 +731,15 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
>         u32 offset;
>         u32 *msrpm;
>
> +       /*
> +        * For non-nested case:
> +        * If the L01 MSR bitmap does not intercept the MSR, then we need to
> +        * save it.
> +        *
> +        * For nested case:
> +        * If the L02 MSR bitmap does not intercept the MSR, then we need to
> +        * save it.
> +        */
>         msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
>                                       to_svm(vcpu)->msrpm;
>
> @@ -3912,18 +3921,19 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>         return EXIT_FASTPATH_NONE;
>  }
>
> -static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> +static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
>
>         guest_state_enter_irqoff();
>
>         if (sev_es_guest(vcpu->kvm)) {
> -               __svm_sev_es_vcpu_run(svm);
> +               __svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
>         } else {
>                 struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
>
> -               __svm_vcpu_run(svm, __sme_page_pa(sd->save_area));
> +               __svm_vcpu_run(svm, __sme_page_pa(sd->save_area),
> +                              spec_ctrl_intercepted);
>         }
>
>         guest_state_exit_irqoff();
> @@ -3932,6 +3942,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> +       bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
>
>         trace_kvm_entry(vcpu);
>
> @@ -3990,26 +4001,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>         if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>                 x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>
> -       svm_vcpu_enter_exit(vcpu);
> -
> -       /*
> -        * We do not use IBRS in the kernel. If this vCPU has used the
> -        * SPEC_CTRL MSR it may have left it on; save the value and
> -        * turn it off. This is much more efficient than blindly adding
> -        * it to the atomic save/restore list. Especially as the former
> -        * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
> -        *
> -        * For non-nested case:
> -        * If the L01 MSR bitmap does not intercept the MSR, then we need to
> -        * save it.
> -        *
> -        * For nested case:
> -        * If the L02 MSR bitmap does not intercept the MSR, then we need to
> -        * save it.
> -        */
> -       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> -           unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> -               svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> +       svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
>
>         if (!sev_es_guest(vcpu->kvm))
>                 reload_tss(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 99410651f2a5..9d940d8736f0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -483,7 +483,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>
>  /* vmenter.S */
>
> -void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
> -void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa);
> +void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
> +void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa, bool spec_ctrl_intercepted);
>
>  #endif
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 45a4bd002494..9e381386ffdc 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -32,10 +32,64 @@
>
>  .section .noinstr.text, "ax"
>
> +.macro RESTORE_GUEST_SPEC_CTRL
> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
> +       ALTERNATIVE_2 "jmp 999f", \
> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
> +
> +       /*
> +        * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
> +        * host's, write the MSR.
> +        *
> +        * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
> +        * there must not be any returns or indirect branches between this code
> +        * and vmentry.
> +        */
> +       movl SVM_spec_ctrl(%_ASM_DI), %eax
> +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> +       je 999f
> +       mov $MSR_IA32_SPEC_CTRL, %ecx
> +       xor %edx, %edx
> +       wrmsr
> +999:
> +
> +.endm
> +
> +.macro RESTORE_HOST_SPEC_CTRL
> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
> +       ALTERNATIVE_2 "jmp 999f", \
> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
> +
> +       mov $MSR_IA32_SPEC_CTRL, %ecx
> +
> +       /*
> +        * Load the value that the guest had written into MSR_IA32_SPEC_CTRL,
> +        * if it was not intercepted during guest execution.
> +        */
> +       cmpb $0, (%_ASM_SP)
> +       jnz 998f
> +       rdmsr
> +       movl %eax, SVM_spec_ctrl(%_ASM_DI)
> +998:
> +
> +       /* Now restore the host value of the MSR if different from the guest's.  */
> +       movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> +       cmp SVM_spec_ctrl(%_ASM_DI), %eax
> +       je 999f
> +       xor %edx, %edx
> +       wrmsr
> +999:
> +
> +.endm
> +
> +

It seems unfortunate to have the unconditional branches in the more
common cases.
