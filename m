Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCA4B7639
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242080AbiBORCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:02:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbiBORCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:02:31 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB10119F3C
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:02:21 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qk11so25222170ejb.2
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4/hO7i+9TuReApbQDnNP9UXUufP0f5FKklN52ak2RA=;
        b=klo0CSe8TONrXKnQV+JX0In+nvFzhVHuV+eES2/GzQt1m/li+K1tQeiWKejRQ+jMPk
         qhwO3jUFHcYokRtqUMikf3cptwh3wvmMpvfKjKUhEVIuGBE1mrDSp1GG20Kh0bMxPZxp
         wwvmPTgNtP26S4iyBXX/RoJ2O4Bf2nJLBaCtQp/Q7KHEDmPbCKCRzpPWwXKXBWJ8M5gF
         OoRCfdCXvCddI7Y3gPVUQEURrGk8qFPv0zAB0gj0EOEugyy0wjJ/ycu60/XeopZK/sU+
         mi2LC/2I8GWFYTtZzUbPaR8f44vfkWyn/2DZoZsiK8JCU5Hsmatxlx/8qJqdU8m71wwf
         Gc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4/hO7i+9TuReApbQDnNP9UXUufP0f5FKklN52ak2RA=;
        b=hVKNSKpfkU8TdaHCnzEjn7x4t1jWSpAqgKz7HfOetEJxcN5af3WDERaot446iWQtLn
         ePTfOEoZoE74x00zxWdT6N97s5H8RweHsMASjny9J6TaHK+vgQeliod5wdSbEUNCbN0n
         2mS9AmeE2rPewBrH7leU5f0dhZ/p4hBSpyxMdMth+bU+NLxS1rtxSRd1g992OvH+wpIR
         uy7IyBAMnSf+SSx5Rhg0UNi1+rmYhPueoKrrxiMpvXZQY2XC1GjBRfP08i7BJfO/Sguq
         qrFRAIc0yz0he8o2+zfxEsvjO3D4waGF1zZjTd6S0Y3Dy33YF5WJZuF06Oai1MwIyKoU
         Vlyw==
X-Gm-Message-State: AOAM533g5WslAD0rSB8rZscbBtxQecuDygsydluWcgLsJ6kGDzN5pl+f
        8Ou+u5meFqFXW/9JtUM9byFrtjQSIs6y8Il+cJGX7g==
X-Google-Smtp-Source: ABdhPJyaH2HPyAuLWEJyQgmS+rVxw1l7UX5a6P2LGJ6CR7KOrab20ONi1S7DBKfvc+p+rlXe6MHzz3ZfdjBCXG2OBTQ=
X-Received: by 2002:a17:907:a42a:: with SMTP id sg42mr3829217ejc.723.1644944539361;
 Tue, 15 Feb 2022 09:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20220215153644.3654582-1-bgeffon@google.com> <CABXOdTe09SxzEpJE_BJO5=4NTjZt2a6zMviMzDH47X5MZao7WA@mail.gmail.com>
 <CADyq12x0CXu_0Cs4At8GVqxWW6tvDGKzhESQpvL8cztHLnBG2w@mail.gmail.com>
In-Reply-To: <CADyq12x0CXu_0Cs4At8GVqxWW6tvDGKzhESQpvL8cztHLnBG2w@mail.gmail.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 15 Feb 2022 09:02:07 -0800
Message-ID: <CABXOdTcE4w8Pxz4a5kdjuqjGWbQUx2CgyGn2AMa+MT-a4GwaNQ@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 8:20 AM Brian Geffon <bgeffon@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 10:57 AM Guenter Roeck <groeck@google.com> wrote:
> >
> > Hi Brian,
> >
> > On Tue, Feb 15, 2022 at 7:37 AM Brian Geffon <bgeffon@google.com> wrote:
> > >
> > > There are two issues with PKRU handling prior to 5.13. The first is that
> >
> > Nice catch and work. One question, though: From the above, it seems
> > like this patch only applies to kernels earlier than v5.13 or, more
> > specifically, to v5.4.y and v5.10.y. Is this correct, or should it be
> > applied to the upstream kernel and to all applicable stable releases ?
>
> This only applies before 5.13, so 5.10.y and 5.4.y, the behavior
> decoupled PKRU from xstate in a long series from Thomas Gleixner, but
> the first commit where this would have been fixed in 5.13 would be:
>

Thought so. You'll have to explain that clarly in both subject and
description to get the patch accepted to the affected stable releases.

Thanks,
Guenter

>   commit 954436989cc550dd91aab98363240c9c0a4b7e23
>   Author: Thomas Gleixner <tglx@linutronix.de>
>   Date:   Wed Jun 23 14:02:21 2021 +0200
>
>     x86/fpu: Remove PKRU handling from switch_fpu_finish()
>
> >
> > Thanks,
> > Guenter
> >
> > > when eagerly switching PKRU we check that current is not a kernel
> > > thread as kernel threads will never use PKRU. It's possible that
> > > this_cpu_read_stable() on current_task (ie. get_current()) is returning
> > > an old cached value. By forcing the read with this_cpu_read() the
> > > correct task is used. Without this it's possible when switching from
> > > a kernel thread to a userspace thread that we'll still observe the
> > > PF_KTHREAD flag and never restore the PKRU. And as a result this
> > > issue only occurs when switching from a kernel thread to a userspace
> > > thread, switching from a non kernel thread works perfectly fine because
> > > all we consider in that situation is the flags from some other non
> > > kernel task and the next fpu is passed in to switch_fpu_finish().
> > >
> > > Without reloading the value finish_fpu_load() after being inlined into
> > > __switch_to() uses a stale value of current:
> > >
> > >   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
> > >   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
> > >   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
> > >   bb2:   41 f6 45 3e 20          testb  $0x20,0x3e(%r13)
> > >   bb7:   75 1c                   jne    bd5 <__switch_to+0x20e>
> > >
> > > By using this_cpu_read() and avoiding the cached value the compiler does
> > > insert an additional load instruction and observes the correct value now:
> > >
> > >   ba1:   8b 35 00 00 00 00       mov    0x0(%rip),%esi
> > >   ba7:   f0 41 80 4d 01 40       lock orb $0x40,0x1(%r13)
> > >   bad:   e9 00 00 00 00          jmp    bb2 <__switch_to+0x1eb>
> > >   bb2:   65 48 8b 05 00 00 00    mov    %gs:0x0(%rip),%rax
> > >   bb9:   00
> > >   bba:   f6 40 3e 20             testb  $0x20,0x3e(%rax)
> > >   bbe:   75 1c                   jne    bdc <__switch_to+0x215>
> > >
> > > The second issue is when using write_pkru() we only write to the
> > > xstate when the feature bit is set because get_xsave_addr() returns
> > > NULL when the feature bit is not set. This is problematic as the CPU
> > > is free to clear the feature bit when it observes the xstate in the
> > > init state, this behavior seems to be documented a few places throughout
> > > the kernel. If the bit was cleared then in write_pkru() we would happily
> > > write to PKRU without ever updating the xstate, and the FPU restore on
> > > return to userspace would load the old value agian.
> > >
> > > Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> > > Signed-off-by: Brian Geffon <bgeffon@google.com>
> > > Signed-off-by: Willis Kung <williskung@google.com>
> > > Tested-by: Willis Kung <williskung@google.com>
> > > ---
> > >  arch/x86/include/asm/fpu/internal.h |  2 +-
> > >  arch/x86/include/asm/pgtable.h      | 14 ++++++++++----
> > >  2 files changed, 11 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> > > index 03b3de491b5e..540bda5bdd28 100644
> > > --- a/arch/x86/include/asm/fpu/internal.h
> > > +++ b/arch/x86/include/asm/fpu/internal.h
> > > @@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
> > >          * PKRU state is switched eagerly because it needs to be valid before we
> > >          * return to userland e.g. for a copy_to_user() operation.
> > >          */
> > > -       if (!(current->flags & PF_KTHREAD)) {
> > > +       if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {
> > >                 /*
> > >                  * If the PKRU bit in xsave.header.xfeatures is not set,
> > >                  * then the PKRU component was in init state, which means
> > > diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> > > index 9e71bf86d8d0..aa381b530de0 100644
> > > --- a/arch/x86/include/asm/pgtable.h
> > > +++ b/arch/x86/include/asm/pgtable.h
> > > @@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
> > >         if (!boot_cpu_has(X86_FEATURE_OSPKE))
> > >                 return;
> > >
> > > -       pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > > -
> > >         /*
> > >          * The PKRU value in xstate needs to be in sync with the value that is
> > >          * written to the CPU. The FPU restore on return to userland would
> > >          * otherwise load the previous value again.
> > >          */
> > >         fpregs_lock();
> > > -       if (pk)
> > > -               pk->pkru = pkru;
> > > +       /*
> > > +        * The CPU is free to clear the feature bit when the xstate is in the
> > > +        * init state. For this reason, we need to make sure the feature bit is
> > > +        * reset when we're explicitly writing to pkru. If we did not then we
> > > +        * would write to pkru and it would not be saved on a context switch.
> > > +        */
> > > +       current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
> > > +       pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > > +       BUG_ON(!pk);
> > > +       pk->pkru = pkru;
> > >         __write_pkru(pkru);
> > >         fpregs_unlock();
> > >  }
> > > --
> > > 2.35.1.265.g69c8d7142f-goog
> > >
