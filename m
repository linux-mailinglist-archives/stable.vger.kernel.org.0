Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC6624EA9
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKKADk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiKKADi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:03:38 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2240149B5D
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:03:37 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id f201so3049168yba.12
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PW7jLG4mkrc/DZMI9Yn7sZdLrRTaoprKkSk6ChmiPmY=;
        b=c6C1btFM2MZxmWQxc5/vk8k7xcid5VQqAm1ALT/flnD9Tg1f1i5HnY7Z71/ECip1BC
         gynNB0wkPPKLHO/jnILbEug3RrbOtPvAVC7KPwVEjTGMzaD4bJWy2WqitsON9Or4zOc8
         KeF/Euou1Fw7q0GQemCEkH7wPEw/xWryQm2dsynT09rjc3/W8HWkxvkQGiaqRqlrxQ23
         I0MVHNuin1RS5v/6A1HJ6KjXGXP6wGNPTkey3XZUuKII7ZwkGZWlnovhcFLqreWeV4RJ
         +cryv+nNZwNIunzgTWD+pBNxcP/SYRzMxaOHjqK7DivClePVz7ed3lmjeVTXS/6rhjE9
         cVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PW7jLG4mkrc/DZMI9Yn7sZdLrRTaoprKkSk6ChmiPmY=;
        b=5ty5ZRtxNTCw8f0F7xiYqPMRbhpysDVWa4z82tOZhjogpok7+fUZDRO3J2tZckYoMP
         1Y2HTovETk5OoVHrnAP+sEy6+6G8qqX79uwN8LuQnmeKTqUJReZC3u+SbWko44MTGyfW
         BpXHwSatQL9lp+yQ0+QIc+eRK18x1qzFu5HNhC8mDapy1WFzUDl0n7ByIkK7F64yJ17B
         pPCEMp/R7Krt3d+UPqNBxQ+BtHxWY6tmRQtypskcuPoz61iElgQtWQHr7o+O5mjJr8Xd
         2nSjHH5vm8rUgo+SiDXJn44K6TYXJ1s9gb50FafvLe2+GMxmE6r6zlzuLFtHCLZ2rw4N
         sSuw==
X-Gm-Message-State: ANoB5plvQpod83+3k/31ECWz5KIjpk+3QnCAsLUjFAZviuFsFH5e3CQ3
        PVrXBeh6Kyhxd5io8TJEM5FbWsgG0yBkiA6CyxQ4Eg==
X-Google-Smtp-Source: AA0mqf7fyJ1c9pMQhzHYjsI20+OgeqfNMYmXZp5Vt1mdw9h8Hxs7zRowUH06GT9ZMKuQadegWWniMKdAdiqLz14s3HM=
X-Received: by 2002:a05:6902:1509:b0:6d4:b9b0:df0b with SMTP id
 q9-20020a056902150900b006d4b9b0df0bmr29829174ybu.413.1668125016117; Thu, 10
 Nov 2022 16:03:36 -0800 (PST)
MIME-Version: 1.0
References: <20221107063807.81774-1-khuey@kylehuey.com> <20221107063807.81774-2-khuey@kylehuey.com>
 <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com>
In-Reply-To: <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Thu, 10 Nov 2022 16:03:21 -0800
Message-ID: <CAP045ArEuTmA6DGoVEgeSRd-F+oQCqRaeyzwgdxuCnOP0jgqWA@mail.gmail.com>
Subject: Re: [RESEND PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again)
 written by ptrace.
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 8, 2022 at 10:23 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> Kyle, sorry this took so long to get to.  I do really appreciate the fix
> and the selftest.  This seems like something we want to get merged
> sooner rather than later, so please bear with me.
>
> On 11/6/22 22:38, Kyle Huey wrote:
> > There are three APIs that write PKRU: sigreturn, PTRACE_SETREGSET with
> > NT_X86_XSTATE, and KVM_SET_XSAVE. sigreturn still uses XRSTOR to write to
> > PKRU. KVM_SET_XSAVE has its own special handling to make PKRU writes take
> > effect (in fpu_copy_uabi_to_guest_fpstate). Push that down into
> > copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE pass in
> > a pointer to the appropriate PKRU slot. copy_sigframe_from_user_to_xstate
> > depends on copy_uabi_to_xstate populating the PKRU field in the task's
> > XSTATE so that __fpu_restore_sig can do a XRSTOR from it, so continue doing
> > that.
>
> Please always write functions() with parenthesis to make it clear what
> you're talking about.  Also, there are much better ways to format this
> paragraph.  I probably would have said:
>
> There are three APIs that write PKRU:
> 1. sigreturn
> 2. PTRACE_SETREGSET with NT_X86_XSTATE
> 3. KVM_SET_XSAVE
>
> Then broken it up into three follow-on paragraphs.  I actually kinda had
> to do this to even make sense of what you were trying to say above.  It
> would also be nice to have a clear problem statement paired with the
> mention of these three ABIs.
>
> #1 and #3 work OK, right?  It's #2 that's broken?

Well this depends on one defines work. If you use my definition of
"behaves equivalently to a hardware XRSTOR instruction" then #1
works, #2 is totally broken, and #3 is subtly broken. But #3 has
been the way that it is for a long time and the KVM maintainers
don't want to change it, whereas #2 was broken recently (in the
commit this fixes).

> > sigreturn still uses XRSTOR to write to PKRU.
>
> ... which means?  That sigreturn is fine and does not need to be touched
> in this patch?

Yes (modulo refactoring).

> > KVM_SET_XSAVE has its own special handling to make PKRU writes take
> > effect (in fpu_copy_uabi_to_guest_fpstate()).  Push that down into
> > copy_uabi_to_xstate() and have PTRACE_SETREGSET with NT_X86_XSTATE pass in
> > a pointer to the appropriate PKRU slot.
>
> So this is the bugfix?  KVM already does it right, and we just need to
> make ptrace() share the KVM code?

Largely but not entirely, because KVM's behavior is subtly different
from XRSTOR's.
KVM doesn't reinitialize PKRU to the hardware init value if the PKRU bit is
not set in the xfeatures mask, whereas XRSTOR does (and thus ptrace previously
did).

> > copy_sigframe_from_user_to_xstate() depends on copy_uabi_to_xstate()
> > populating the PKRU field in the task's XSTATE so that
> > __fpu_restore_sig() can do a XRSTOR from it, so continue doing that.
>
> I'm not quite sure what this chunk of the changelog is trying to tell
> me.  Isn't this the sigreturn path?  Why did the paragraph above go from
> talking about sigreturn to KVM then back to sigreturn?

It's telling you that nothing really changed there. I can drop that.

> > This also adds code to initialize the PKRU value to the hardware init value
> > (namely 0) if the PKRU bit is not set in the XSTATE header provided to
> > ptrace, to match XRSTOR.
>
> The implication here is that we would like the sigreturn ABI and the
> ptrace ABI to behave in a similar fashion, right?

I don't personally care about sigreturn that much but I would like the
ptrace ABI to behave like XRSTOR (which it did before 5.14), and the
sigreturn ABI behaves like XRSTOR because it *is* XRSTOR (both
before and after 5.14), so the ptrace ABI behaving like the sigreturn ABI
arises transitively.

> At a high level, this patch does a *LOT*.  Generally, it's nice when
> bugfixes can be encapsulted in one patch, but I think there's too much
> going on here for one patch.

Ok. How about I break the first part into two pieces, one that changes the
signatures of copy_uabi_from_kernel_to_xstate() and
copy_sigframe_from_user_to_xstate(), and one that moves the relevant
KVM code from fpu_copy_uabi_to_guest_fpstate() to copy_uabi_to_xstate()
and deals with the edge case behavior of the mask?

> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index 3b28c5b25e12..c273669e8a00 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
> >  {
> >       struct fpstate *kstate = gfpu->fpstate;
> >       const union fpregs_state *ustate = buf;
> > -     struct pkru_state *xpkru;
> > -     int ret;
> >
> >       if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
> >               if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
> > @@ -406,16 +404,16 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
> >       if (ustate->xsave.header.xfeatures & ~xcr0)
> >               return -EINVAL;
> >
> > -     ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> > -     if (ret)
> > -             return ret;
> > +     /*
> > +      * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
> > +      * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> > +      * case (all other components are eventually re-initialized).
> > +      * (Not clear that this is actually necessary for compat).
> > +      */
> > +     if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
> > +             vpkru = NULL;
>
> I'm not a big fan of hunks that are part of bugfixes where it is not
> clear that the hunk is necessary.

This is necessary to avoid changing KVM's behavior at the same time
that we change
ptrace, since KVM doesn't want the same behavior as ptrace.

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
>
> I actually hadn't dug into the KVM code around this before.  It seems
> like the PKRU pointer (&target->thread.pkru) here can also be
> &vcpu->arch.pkru if it comes from the KVM side.

Right. Where we need to put PKRU to get the kernel to swap it in
varies depending
on whether this is a normal task or a VM.

> I was missing why PKRU is so special here.  I think in *both* cases,
> we're copying a potential PKRU value from userspace.  But, the fpstate
> target is a useless place to write PKRU because the kernel doesn't
> update from there.

Right.

> So, the copy-in function
> (copy_uabi_from_kernel_to_xstate()) needs a place to stash PKRU where
> the kernel will see it.  The place that the kernel wants to stash it is
> either the task PKRU field or the KVM vcpu field.  That's what the
> pointer provides.

Right.

> Also, is this getting a wee bit over 80 columns?

Probably.

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
>
> This is also changing copy_sigframe_from_user_to_xstate() to take a
> 'task_struct' instead of an 'fpstate'.  Why?  That function just turns
> it right back into an fpstate with: tsk->thread.fpu.fpstate.

So that we can also access tsk->thread.pkru at the same time.

> >       } else {
> >               if (__copy_from_user(&fpregs->fxsave, buf_fx,
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index c8340156bfd2..8f14981a3936 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -1197,7 +1197,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
> >
> >
> >  static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> > -                            const void __user *ubuf)
> > +                            const void __user *ubuf, u32 *pkru)
>
> I think this function deserves a little comment about what it expects
> from 'pkru' here.  Maybe:

Ok.

> /*
>  * The kernel will not update the actual PKRU register from the PKRU
>  * space in @fpstate.  Allow callers to pass in an alternate destination
>  * for PKRU.  This is currently either the pkru field from the
>  * task_struct or vcpu.
>  */

Or NULL, but yeah, sure.

> >  {
> >       struct xregs_state *xsave = &fpstate->regs.xsave;
> >       unsigned int offset, size;
> > @@ -1246,6 +1246,21 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> >               }
> >       }
> >
> > +     /*
> > +      * Update the user protection key storage. Allow KVM to
> > +      * pass in a NULL pkru pointer if the mask bit is unset
> > +      * for its legacy ABI behavior.
> > +      */
>
> If I read this in 5 years, do I know what the "KVM legacy ABI behavior" is?

Probably not. I'll be more specific.

> > +     if (pkru)
> > +             *pkru = 0;
> > +
> > +     if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> > +             struct pkru_state *xpkru;
> > +
> > +             xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> > +             *pkru = xpkru->pkru;
> > +     }
>
> This is a bit wonky.  The code kinda pretends that XFEATURE_MASK_PKRU
> and 'pkru' are independent.  But, it's actually impossible to have a
> pkru==NULL and have XFEATURE_MASK_PKRU set.  The code would oops in that
> case.

Right.

> Would something like this be more clear?
>
>         if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
>                 struct pkru_state *xpkru;
>
>                 xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
>                 *pkru = xpkru->pkru;
>         } else {
>                 /*
>                  * KVM may pass a NULL 'pkru' to indicate
>                  * that it does not need PKRU updated.
>                  */
>                 if (pkru)
>                         *pkru = 0;
>         }

Yeah, Sean Christopherson suggested this (with the else and if
collapsed into a single level) when I submitted this previously.

Thanks,

- Kyle
