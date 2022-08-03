Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B21588F27
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiHCPMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 11:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbiHCPMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 11:12:49 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55623AE6C
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 08:12:48 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o15so28691235yba.10
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 08:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XZXEy3cvHjx2bX+d6U1ZgIae2UNxoQkQn7NuGYQFw2Y=;
        b=eTkF0CuqpfS6zseV19j0r6CXBKG181mwXlnys1i2gnvTKj/TyMYrzZY9ZONUS6/YgB
         pgXCgeuoJdwWFZ0Tp8cZaTfQ9boA7FfUSKFm3CnBonoiqSMQnrjQi9lnw2O9/p+WGbEl
         ZoGY/gg4XypN8QWyIQ0GHnHTB9l1qerbVGW0PHOkkYoNLytYZb0s7cyAXUb/SgC8mrPH
         56FxDPvQjt57Cc+sE0bOCZ51QyBmSONXoMWjp65PR6BoCTnpg1aVRF1IqrtzmSwxKkTi
         8OX76ZsMiYmOH9NZSNaX1pT9mCzT1EaeWc8V001UKdGvDnCNrU+5T9YdzXrOp7lzbjwk
         SUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=XZXEy3cvHjx2bX+d6U1ZgIae2UNxoQkQn7NuGYQFw2Y=;
        b=OMwR02zXXIGCl+GbFhb9vUXfWR3tSvrQ3yE78CtbAZBIp5bxu8a7PpglR2BLWbHfKn
         FoBfODsglrvRS+5a54o2pIBQyJ7kaU5yZZOu/SUuoNmrgX4J65knUkLjOAC5W4+daEUI
         4JOohpWHpaWmkKngunPtin7IZgWWMSxy1IZ1M78JdbOSc9F70KjWmucPr6ln24Z4k5T7
         o8p8HX3LulMyrNikXnSP0KyQSAD7DFX0iQ58GCxdHEeMASSHMY6xg/cVhp68maqjTx6i
         J4UBIdaxV71bMfnGpxJ74l/L/j+cjPOdvVfzMKfoWRYPWmP41IOZjDmo7Nldh6/aw1TZ
         nirg==
X-Gm-Message-State: ACgBeo0Q2zMZLa1eUQscxVW2BJKUzx5BTDo9sQYAvn/Q53PWqlH1jg8g
        VsgwmqJjUQv+alnOJc/1Q4aebBgP4gJYLaVX2euOrg==
X-Google-Smtp-Source: AA6agR7v/HPFCTCefE30aAswl27LuEi01dCUtvdjZs8cqGMByB77wUzH4MdPg6auWGZLmUWuRbRJxX8tKh78xz8UH6o=
X-Received: by 2002:a25:9d8d:0:b0:676:a71d:edad with SMTP id
 v13-20020a259d8d000000b00676a71dedadmr19251128ybp.94.1659539567685; Wed, 03
 Aug 2022 08:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220731050342.56513-1-khuey@kylehuey.com> <Yuo59tV071/i6yhf@gmail.com>
In-Reply-To: <Yuo59tV071/i6yhf@gmail.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Wed, 3 Aug 2022 08:12:34 -0700
Message-ID: <CAP045ArF0SX84tDr=iZoK=EnXK2LsXYut3-KMkCxQO2OOhn=0A@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 3, 2022 at 2:03 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Kyle Huey <me@kylehuey.com> wrote:
>
> > From: Kyle Huey <me@kylehuey.com>
> >
> > When management of the PKRU register was moved away from XSTATE, emulation
> > of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> > for APIs that write XSTATE. This can be seen by running gdb and executing
> > `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> > write to the PKRU register (which gdb performs through ptrace) is ignored.
> >
> > There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> > sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> > make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> > down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> > and sigreturn pass in pointers to the appropriate PKRU value.
> >
> > This also adds code to initialize the PKRU value to the hardware init value
> > (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> > This is a change to the current KVM_SET_XSAVE behavior.
> >
> > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
> > Cc: stable@vger.kernel.org # 5.14+
> > Fixes: e84ba47e313dbc097bf859bb6e4f9219883d5f78
> > ---
> >  arch/x86/kernel/fpu/core.c   | 11 +----------
> >  arch/x86/kernel/fpu/regset.c |  2 +-
> >  arch/x86/kernel/fpu/signal.c |  2 +-
> >  arch/x86/kernel/fpu/xstate.c | 26 +++++++++++++++++++++-----
> >  arch/x86/kernel/fpu/xstate.h |  4 ++--
> >  5 files changed, 26 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index 0531d6a06df5..dfb79e2ee81f 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -406,16 +406,7 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
> >       if (ustate->xsave.header.xfeatures & ~xcr0)
> >               return -EINVAL;
> >
> > -     ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> > -     if (ret)
> > -             return ret;
> > -
> > -     /* Retrieve PKRU if not in init state */
> > -     if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
> > -             xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
> > -             *vpkru = xpkru->pkru;
> > -     }
> > -     return 0;
> > +     return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
> >  }
> >  EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
> >  #endif /* CONFIG_KVM */
> > diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
> > index 75ffaef8c299..6d056b68f4ed 100644
> > --- a/arch/x86/kernel/fpu/regset.c
> > +++ b/arch/x86/kernel/fpu/regset.c
> > @@ -167,7 +167,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
> >       }
> >
> >       fpu_force_restore(fpu);
> > -     ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
> > +     ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf, &target->thread.pkru);
> >
> >  out:
> >       vfree(tmpbuf);
> > diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> > index 91d4b6de58ab..558076dbde5b 100644
> > --- a/arch/x86/kernel/fpu/signal.c
> > +++ b/arch/x86/kernel/fpu/signal.c
> > @@ -396,7 +396,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
> >
> >       fpregs = &fpu->fpstate->regs;
> >       if (use_xsave() && !fx_only) {
> > -             if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
> > +             if (copy_sigframe_from_user_to_xstate(tsk, buf_fx))
> >                       return false;
> >       } else {
> >               if (__copy_from_user(&fpregs->fxsave, buf_fx,
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index c8340156bfd2..1eea7af4afd9 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
> >
> >
> >  static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> > -                            const void __user *ubuf)
> > +                            const void __user *ubuf, u32 *pkru)
> >  {
> >       struct xregs_state *xsave = &fpstate->regs.xsave;
> >       unsigned int offset, size;
> > @@ -1235,6 +1235,22 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> >       for (i = 0; i < XFEATURE_MAX; i++) {
> >               mask = BIT_ULL(i);
> >
> > +             if (i == XFEATURE_PKRU) {
> > +                     /*
> > +                      * Retrieve PKRU if not in init state, otherwise
> > +                      * initialize it.
> > +                      */
> > +                     if (hdr.xfeatures & mask) {
> > +                             struct pkru_state xpkru = {0};
> > +
> > +                             copy_from_buffer(&xpkru, xstate_offsets[i],
> > +                                              sizeof(xpkru), kbuf, ubuf);
>
> Shouldn't the failure case of copy_from_buffer() be handled?

Yes, it should be. The sigreturn case could hit it.

> Also, what's the security model for this register, do we trust all input
> values user-space provides for the PKRU field in the XSTATE? I realize that
> WRPKRU already gives user-space write access to the register - but does the
> CPU write it all into the XSTATE, with no restrictions on content
> whatsoever?

There is no security model for this register. The CPU does write
whatever is given to WRPKRU (or XRSTOR) into the PKRU register. The
pkeys(7) man page notes:

Protection keys have the potential to add a layer of security and
reliability to applications. But they have not been primarily designed
as a security feature. For instance, WRPKRU is a completely
unprivileged instruction, so pkeys are useless in any case that an
attacker controls the PKRU register or can execute arbitrary
instructions.

And the ERIM paper
(https://www.usenix.org/system/files/sec19-vahldiek-oberwagner_0.pdf)
explicitly contemplates the need to protect against the less
privileged code containing WRPKRU and XRSTOR instructions (though they
do seem to have missed the implicit XRSTOR in sigreturn).

> Thanks,
>
>         Ingo

- Kyle
