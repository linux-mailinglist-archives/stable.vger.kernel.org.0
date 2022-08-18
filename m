Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0B597C91
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 06:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243194AbiHREDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 00:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243152AbiHRECo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 00:02:44 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2DCAE9E3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:02:25 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-33387bf0c4aso9845917b3.11
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 21:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vZWaLwi4OI4P2yBOO7iHi8OjD+yrIHD7EpKzmYHp8yE=;
        b=ZOQ4yB2IP0Eyzor8G49BxvPeCy+8iVDHTBahxAt+s5kV0IEQcuNdg7y5OChPn1I/yt
         mZ9BNfPF/5YII4LVl2/5sMO0lo8j5Slx/njaEBn/r4QvzcVi25P5b0xhoIRJyzTwAUnO
         55Wo25wbv1EaQskogoX8xojQu0PfpFaAuNs+HL+N8N5zkqWrxgEwNg6wLJPSe3131AYH
         DsoiVKXd0YUpLwh2VkC4A6ySDe6HGIY+515IuIRLRCDp5Uxguq2UiOenenR0zcu5olhi
         xlSnqjNC7uRZhmEx1kJQ4PzCfHoCWCP1E1T4ZMrrdowqv0lJTC3Wxt/j+PQJ4nEQn6X7
         OKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vZWaLwi4OI4P2yBOO7iHi8OjD+yrIHD7EpKzmYHp8yE=;
        b=gLHwyu/pLXW2eNT4C+3U4816gVffle4okDO7dgrhKxGXoAgp6haV+EIy1qnaWY//I2
         zQK6pfOuT++wac6sFGqNTDskCrflwJiZ/dH0tizLMQoNO85OSRwbXHQ3abBeQDxCbf15
         AijMzpOYdCmgvGgUxr+XGMiUJM3jjgldjKqKkTA6eEHqzv497l/m0LsoSHglj9W9d4dX
         TIOBOzhCTKhB2sI98rmJznNDxrtQRJaTa64vkwanhFuI+udV9xabKlc1Uyo6BodS0ySk
         qrJtD3lTD9SdiETdbesnecxEGhtad2UeghdE0A8EDSFPYaS7m/ZQVme3m2RqD2LpRSs0
         FG7Q==
X-Gm-Message-State: ACgBeo1b+NoVM4pBofXvWedRacnLyTthtCzcu9aEyGtaCnubNKO2O8Xk
        pxpzVY0kgGtXevGR364+1yGWqxliRZM1mC9T9mC55A==
X-Google-Smtp-Source: AA6agR7omARfT2P4pD03dPpFF7DeBhVYfNaA8l6C1M1Rs4cD0bFjWaNLazg6bEL0NCQju+C5VxULU+CPWqHC3UyZ5N8=
X-Received: by 2002:a0d:ca0b:0:b0:32f:dce5:8093 with SMTP id
 m11-20020a0dca0b000000b0032fdce58093mr1191922ywd.159.1660795344363; Wed, 17
 Aug 2022 21:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220808141538.102394-1-khuey@kylehuey.com>
In-Reply-To: <20220808141538.102394-1-khuey@kylehuey.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Wed, 17 Aug 2022 21:02:00 -0700
Message-ID: <CAP045AppDqyEfwXWgoJCsH7NUEUZSoJ9pXjLR492b5k_rnYbPw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 8, 2022 at 7:15 AM Kyle Huey <me@kylehuey.com> wrote:
>
> From: Kyle Huey <me@kylehuey.com>
>
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> for APIs that write XSTATE. This can be seen by running gdb and executing
> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> write to the PKRU register (which gdb performs through ptrace) is ignored.
>
> There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> and sigreturn pass in pointers to the appropriate PKRU value.
>
> This also adds code to initialize the PKRU value to the hardware init value
> (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> This is a change to the current KVM_SET_XSAVE behavior.
>
> Changelog since v4:
> - Selftest additionally checks PKRU readbacks through ptrace.
> - Selftest flips all PKRU bits (except the key used for PROT_EXEC).
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
>
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
> Cc: stable@vger.kernel.org # 5.14+
> Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
> ---
>  arch/x86/kernel/fpu/core.c   | 13 +------------
>  arch/x86/kernel/fpu/regset.c |  2 +-
>  arch/x86/kernel/fpu/signal.c |  2 +-
>  arch/x86/kernel/fpu/xstate.c | 28 +++++++++++++++++++++++-----
>  arch/x86/kernel/fpu/xstate.h |  4 ++--
>  5 files changed, 28 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 3b28c5b25e12..46b935bc87c8 100644
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
> @@ -406,16 +404,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
>         if (ustate->xsave.header.xfeatures & ~xcr0)
>                 return -EINVAL;
>
> -       ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> -       if (ret)
> -               return ret;
> -
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
> index c8340156bfd2..e01d3514ae68 100644
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
> @@ -1235,6 +1235,24 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
>         for (i = 0; i < XFEATURE_MAX; i++) {
>                 mask = BIT_ULL(i);
>
> +               if (i == XFEATURE_PKRU) {
> +                       /*
> +                        * Retrieve PKRU if not in init state, otherwise
> +                        * initialize it.
> +                        */
> +                       if (hdr.xfeatures & mask) {
> +                               struct pkru_state xpkru = {0};
> +
> +                               if (copy_from_buffer(&xpkru, xstate_offsets[i],
> +                                                    sizeof(xpkru), kbuf, ubuf))
> +                                       return -EFAULT;
> +
> +                               *pkru = xpkru.pkru;
> +                       } else {
> +                               *pkru = 0;
> +                       }
> +               }
> +
>                 if (hdr.xfeatures & mask) {
>                         void *dst = __raw_xsave_addr(xsave, i);
>
> @@ -1264,9 +1282,9 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
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
> @@ -1274,10 +1292,10 @@ int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
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
> 2.37.1
>

Bump.

If there are no further comments/complaints, can we get this queued up
via x86/urgent (or something)? We're eager to get this moving and
eventually onto stable to fix rr users on 5.15.

- Kyle
