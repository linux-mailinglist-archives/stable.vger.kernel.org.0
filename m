Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE44B5B8006
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 06:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiINEI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 00:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiINEIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 00:08:25 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897005301E
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 21:08:22 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3454b0b1b6dso164733267b3.4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 21:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=SmSKuyvg1ON77pEQA9rZ6Akf1I0QxiG/P5GG1kyYPoI=;
        b=JAqfZVNIPzZVCv/fn1fe79Hxz3WAgNPMNsSVFu1Ck8S0K2HQn65Sv8WQRZE7hQDZdb
         TS7sblTsk2sfaqHAvRadRpAonhlUXKFCHF/iZCATAjVGhV2IM1RkPQji77S8geBS1Bpr
         J6MLMfWli3M175g5b3vGhgNDLnFqFzPwxh9MYIOoKSeb6UnAXfSLPPCo2drVazdB9jWe
         KHniu1ugMwQyL92uSJiDlcj6pqJcHjHrN+4C8TygMe39lvIKnPyHRrqyhFz9DxpZWBov
         bMiKygU8IGK5ZoT+Y7nCXA0wSWysv4sYQfyIxgPTyj84CSsUfgTnQUasw3+3nvKljBYx
         ngPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SmSKuyvg1ON77pEQA9rZ6Akf1I0QxiG/P5GG1kyYPoI=;
        b=irJYRUZTs6cwCpOVl/xIrXqFEUepJ260af3V5wmyYKqZTDc1k9qF16mgN56zEzS1zl
         pwuDOXRZ77qMNTUWNTm3TslU1ZgOMzeA0RoS5zHCCHvBDpdQWyQLRjImkmwJkijjrCdk
         wfPCzLVSRBaooPBV0OLF0YXxaAWLPq2TLcScfw/QeMMMY3jratYzHJS/LfBqs+Qjhn6X
         it+qLUcZx+A/5mbaFkIE3539yAfHeTYVY+7Q5YNfm4V13bk4t6RiMFKEVU61E7E86hlw
         XNMQUOskbL+PLJPrz/WLuC1efFUgMA/rAT/AyoVAARnv1ICsnJyMsHoW6vp4/7SGurG5
         gPlw==
X-Gm-Message-State: ACgBeo11aWyralkSbrq+hOfgExKgN0XNVe+dNjXFmE2DGR+LgaeNVa4B
        lapQOP7MfIDq+G4zDHKZwwTo5wrZx8CewcRIRtqYig==
X-Google-Smtp-Source: AA6agR7hcP80WaVlNDrV9C8tgkC7vhRRPHhedBuWia5UOUxztGfiE6rw1jk2fP2eXv/ciI82RkgPUnv4V8nZ0F8fNxo=
X-Received: by 2002:a81:d344:0:b0:345:1751:e648 with SMTP id
 d4-20020a81d344000000b003451751e648mr30906671ywl.159.1663128501693; Tue, 13
 Sep 2022 21:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220829194905.81713-1-khuey@kylehuey.com>
In-Reply-To: <20220829194905.81713-1-khuey@kylehuey.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Tue, 13 Sep 2022 21:08:02 -0700
Message-ID: <CAP045ApCZhHZgr79iie-K=xxnkT-PQcy8CqNvGbPzODcCSWdfw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 12:49 PM Kyle Huey <me@kylehuey.com> wrote:
>
> From: Kyle Huey <me@kylehuey.com>
>
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for reading PKRU through ptrace,
> but not for writing PKRU through ptrace. This can be seen by running gdb
> and executing `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected
> kernels (5.14+) the write to the PKRU register (which gdb performs through
> ptrace) is ignored.
>
> There are three APIs that write PKRU: sigreturn, PTRACE_SETREGSET with
> NT_X86_XSTATE, and KVM_SET_XSAVE. sigreturn still uses XRSTOR to write to
> PKRU. KVM_SET_XSAVE has its own special handling to make PKRU writes take
> effect (in fpu_copy_uabi_to_guest_fpstate). Push that down into
> copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE pass in
> a pointer to the appropriate PKRU slot. copy_sigframe_from_user_to_xstate
> depends on copy_uabi_to_xstate populating the PKRU field in the task's
> XSTATE so that __fpu_restore_sig can do a XRSTOR from it, so continue doing
> that.
>
> This also adds code to initialize the PKRU value to the hardware init value
> (namely 0) if the PKRU bit is not set in the XSTATE header provided to
> ptrace, to match XRSTOR.
>
> Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: stable@vger.kernel.org # 5.14+
> ---
>  arch/x86/kernel/fpu/core.c   | 20 +++++++++-----------
>  arch/x86/kernel/fpu/regset.c |  2 +-
>  arch/x86/kernel/fpu/signal.c |  2 +-
>  arch/x86/kernel/fpu/xstate.c | 25 ++++++++++++++++++++-----
>  arch/x86/kernel/fpu/xstate.h |  4 ++--
>  5 files changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 3b28c5b25e12..c273669e8a00 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>  {
>         struct fpstate *kstate = gfpu->fpstate;
>         const union fpregs_state *ustate = buf;
> -       struct pkru_state *xpkru;
> -       int ret;
>
>         if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
>                 if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
> @@ -406,16 +404,16 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>         if (ustate->xsave.header.xfeatures & ~xcr0)
>                 return -EINVAL;
>
> -       ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> -       if (ret)
> -               return ret;
> +       /*
> +        * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
> +        * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> +        * case (all other components are eventually re-initialized).
> +        * (Not clear that this is actually necessary for compat).
> +        */
> +       if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
> +               vpkru = NULL;
>
> -       /* Retrieve PKRU if not in init state */
> -       if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
> -               xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
> -               *vpkru = xpkru->pkru;
> -       }
> -       return 0;
> +       return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
>  }
>  EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
>  #endif /* CONFIG_KVM */
> diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
> index 75ffaef8c299..6d056b68f4ed 100644
> --- a/arch/x86/kernel/fpu/regset.c
> +++ b/arch/x86/kernel/fpu/regset.c
> @@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
>         }
>
>         fpu_force_restore(fpu);
> -       ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
> +       ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);
>
>  out:
>         vfree(tmpbuf);
> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index 91d4b6de58ab..558076dbde5b 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
>
>         fpregs = &fpu->fpstate->regs;
>         if (use_xsave() && !fx_only) {
> -               if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
> +               if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
>                         return false;
>         } else {
>                 if (__copy_from_user(&fpregs->fxsave, buf_fx,
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index c8340156bfd2..8f14981a3936 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
>
>
>  static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> -                              const void __user *ubuf)
> +                              const void __user *ubuf, u32 *pkru)
>  {
>         struct xregs_state *xsave = &fpstate->regs.xsave;
>         unsigned int offset, size;
> @@ -1246,6 +1246,21 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>                 }
>         }
>
> +       /*
> +        * Update the user protection key storage. Allow KVM to
> +        * pass in a NULL pkru pointer if the mask bit is unset
> +        * for its legacy ABI behavior.
> +        */
> +       if (pkru)
> +               *pkru = 0;
> +
> +       if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> +               struct pkru_state *xpkru;
> +
> +               xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> +               *pkru = xpkru->pkru;
> +       }
> +
>         /*
>          * The state that came in from userspace was user-state only.
>          * Mask all the user states out of 'xfeatures':
> @@ -1264,9 +1279,9 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>   * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
>   * format and copy to the target thread. Used by ptrace and KVM.
>   */
> -int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
> +int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru)
>  {
> -       return copy_uabi_to_xstate(fpstate, kbuf, NULL);
> +       return copy_uabi_to_xstate(fpstate, kbuf, NULL, pkru);
>  }
>
>  /*
> @@ -1274,10 +1289,10 @@ int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
>   * XSAVE[S] format and copy to the target thread. This is called from the
>   * sigreturn() and rt_sigreturn() system calls.
>   */
> -int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate,
> +int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
>                                       const void __user *ubuf)
>  {
> -       return copy_uabi_to_xstate(fpstate, NULL, ubuf);
> +       return copy_uabi_to_xstate(tsk->thread.fpu.fpstate, NULL, ubuf, &tsk->thread.pkru);
>  }
>
>  static bool validate_independent_components(u64 mask)
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index 5ad47031383b..a4ecb04d8d64 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -46,8 +46,8 @@ extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
>                                       u32 pkru_val, enum xstate_copy_mode copy_mode);
>  extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
>                                     enum xstate_copy_mode mode);
> -extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
> -extern int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate, const void __user *ubuf);
> +extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf, u32 *pkru);
> +extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void __user *ubuf);
>
>
>  extern void fpu__init_cpu_xstate(void);
> --
> 2.37.2
>
> Changelog since v5:
> - Avoids a second copy from the uabi buffer as suggested.
> - Preserves old KVM_SET_XSAVE behavior where leaving the PKRU bit in the
>   XSTATE header results in PKRU remaining unchanged instead of
>   reinitializing it.
> - Fixed up patch metadata as requested.
>
> Changelog since v4:
> - Selftest additionally checks PKRU readbacks through ptrace.
> - Selftest flips all PKRU bits (except the default key).
>
> Changelog since v3:
> - The v3 patch is now part 1 of 2.
> - Adds a selftest in part 2 of 2.
>
> Changelog since v2:
> - Removed now unused variables in fpu_copy_uabi_to_guest_fpstate
>
> Changelog since v1:
> - Handles the error case of copy_to_buffer().

tglx, could you look at this again?

- Kyle
