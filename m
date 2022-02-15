Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31F64B79AD
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244438AbiBOVhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:37:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243578AbiBOVhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:37:01 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E15FFBA52
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:36:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w3so476618edu.8
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o/RjAcnj/P9iFyycjmIpcPmKzDn80maylg4OrK5xRPo=;
        b=cNGFpCJ+0b+KbIXxTB+YwkIJ4mUOxAOlFnAx+3bK16/dN7GMf9kDzvOWRP0vz07z8w
         C4uezKMMkI3csmVrY+Uts5zmT69fX8Jy73IewfTjwbjlh62ceeYRdg6gfhz4sq1Gbrkr
         T1i87AKL0vuj/NDYZtlhrF9Xu/AziOS7k5k9ZaF/4voyBwqRxMALHRud0tg9m28AY4nW
         ZiI+Pjbzcbe6SLEQNC3wecFlFiILFr4Ma1xLV0uw1aF7Di107zwPJ8vBERT+mNVSTGdw
         8EXZy974+7YikEpYEGMTc/0W0gKGDtUCPRNZfW7DmNZtogLVYj0V1QM2MdaXNNyR1G/f
         XN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o/RjAcnj/P9iFyycjmIpcPmKzDn80maylg4OrK5xRPo=;
        b=JmzaTIsqG8DEgWLU4yRaZadNcxUWywRwUenmOgL7GyhcGaoa5nzD46fXXB6s9KZ2Fd
         4LPi/PdWJ4t0yZZRqp+KAC2G0yFCEwAcb4ovWHRMREeXNz0fS6NZcUSShbNEXsylCFr9
         4Z7HjTwN6VWRyAjaobbmNZZmxiZHuwv5BY1O0Cfo4RX366xidsyKPaGEXmfXVlX/9QO0
         fLs55QrLTEMGUzhe+Zs49SzAAkW/SpHlXFG9jssCIpVYYs1BjAYRZiEwkc2cOpMXmOO5
         p5SnqGnoiWWEWZyJs2PV81rs5UCv4pjc2gga7DOnLMU3NE27P7tKyVtXTkOSDrh6c0nK
         fPlg==
X-Gm-Message-State: AOAM533s0B1agUlrwpAjutXpjqePrdC62yVc70LUGHrTiI7kXSKXFyOZ
        vIt5yQ70iVZdRM3LXcRoSdYBzmdIJSAOLscX8uqRoQ==
X-Google-Smtp-Source: ABdhPJzHpa3ym9OOwzeV7u/rAZWOtejaunMqDOOM0tA3wPN6dBl5ljtfJT7Th2pT6ZlhURSDVHYWLaz/nQccMQ69678=
X-Received: by 2002:a05:6402:33a:: with SMTP id q26mr943424edw.432.1644961008444;
 Tue, 15 Feb 2022 13:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20220215153644.3654582-1-bgeffon@google.com> <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
 <CABXOdTcU1eLLzjRdJiwfVpoJi8WqYXj5bTrJ_-tm4pgRZK0uYw@mail.gmail.com>
In-Reply-To: <CABXOdTcU1eLLzjRdJiwfVpoJi8WqYXj5bTrJ_-tm4pgRZK0uYw@mail.gmail.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 15 Feb 2022 16:36:12 -0500
Message-ID: <CADyq12xG=mRcdkBU9Y=4dW5j8U8xuzU4x+1d_qSy-opcJHZduw@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
To:     Guenter Roeck <groeck@google.com>
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

On Tue, Feb 15, 2022 at 4:14 PM Guenter Roeck <groeck@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 9:13 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 2/15/22 07:36, Brian Geffon wrote:
> > > There are two issues with PKRU handling prior to 5.13.
> >
> > Are you sure both of these issues were introduced by 0cecca9d03c?  I'm
> > surprised that the get_xsave_addr() issue is not older.
> >
> > Should this be two patches?
> >
> > > The first is that when eagerly switching PKRU we check that current
> >
> > Don't forget to write in imperative mood.  No "we's", please.
> >
> > https://www.kernel.org/doc/html/latest/process/maintainer-tip.html
> >
> > This goes for changelogs and comments too.
> >
> > > is not a kernel thread as kernel threads will never use PKRU. It's
> > > possible that this_cpu_read_stable() on current_task (ie.
> > > get_current()) is returning an old cached value. By forcing the read
> > > with this_cpu_read() the correct task is used. Without this it's
> > > possible when switching from a kernel thread to a userspace thread
> > > that we'll still observe the PF_KTHREAD flag and never restore the
> > > PKRU. And as a result this issue only occurs when switching from a
> > > kernel thread to a userspace thread, switching from a non kernel
> > > thread works perfectly fine because all we consider in that situation
> > > is the flags from some other non kernel task and the next fpu is
> > > passed in to switch_fpu_finish().
> >
> > It makes *sense* that there would be a place in the context switch code
> > where 'current' is wonky, but I never realized this.  This seems really
> > fragile, but *also* trivially detectable.
> >
> > Is the PKRU code really the only code to use 'current' in a buggy way
> > like this?
> >
> > > The second issue is when using write_pkru() we only write to the
> > > xstate when the feature bit is set because get_xsave_addr() returns
> > > NULL when the feature bit is not set. This is problematic as the CPU
> > > is free to clear the feature bit when it observes the xstate in the
> > > init state, this behavior seems to be documented a few places throughout
> > > the kernel. If the bit was cleared then in write_pkru() we would happily
> > > write to PKRU without ever updating the xstate, and the FPU restore on
> > > return to userspace would load the old value agian.
> >
> >
> >                                                 ^ again
> >
> > It's probably worth noting that the AMD init tracker is a lot more
> > aggressive than Intel's.  On Intel, I think XRSTOR is the only way to
> > get back to the init state.  You're obviously hitting this on AMD.
> >
>
> Brian should correct me here, but I think we have seen this with one
> specific Intel CPU.
>
> Brian, would it make sense to list the affected CPU model(s), or at
> least the ones where we have observed the problem ?

The only CPU I have access to at the moment with OSPKE is an 11th Gen
Core i5-1135G7, so that's the only one I've observed it on. I can try
to search around for other hardware.

Brian

>
> Thanks,
> Guenter
>
> > It's also *very* unlikely that PKRU gets back to a value of 0.  I think
> > we added a selftest for this case in later kernels.
> >
> > That helps explain why this bug hung around for so long.
> >
> > > diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> > > index 03b3de491b5e..540bda5bdd28 100644
> > > --- a/arch/x86/include/asm/fpu/internal.h
> > > +++ b/arch/x86/include/asm/fpu/internal.h
> > > @@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
> > >        * PKRU state is switched eagerly because it needs to be valid before we
> > >        * return to userland e.g. for a copy_to_user() operation.
> > >        */
> > > -     if (!(current->flags & PF_KTHREAD)) {
> > > +     if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {
> >
> > This really deserves a specific comment.
> >
> > >               /*
> > >                * If the PKRU bit in xsave.header.xfeatures is not set,
> > >                * then the PKRU component was in init state, which means
> > > diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> > > index 9e71bf86d8d0..aa381b530de0 100644
> > > --- a/arch/x86/include/asm/pgtable.h
> > > +++ b/arch/x86/include/asm/pgtable.h
> > > @@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
> > >       if (!boot_cpu_has(X86_FEATURE_OSPKE))
> > >               return;
> > >
> > > -     pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > > -
> > >       /*
> > >        * The PKRU value in xstate needs to be in sync with the value that is
> > >        * written to the CPU. The FPU restore on return to userland would
> > >        * otherwise load the previous value again.
> > >        */
> > >       fpregs_lock();
> > > -     if (pk)
> > > -             pk->pkru = pkru;
> > > +     /*
> > > +      * The CPU is free to clear the feature bit when the xstate is in the
> > > +      * init state. For this reason, we need to make sure the feature bit is
> > > +      * reset when we're explicitly writing to pkru. If we did not then we
> > > +      * would write to pkru and it would not be saved on a context switch.
> > > +      */
> > > +     current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
> >
> > I don't think we need to describe how the init optimization works again.
> >  I'm also not sure it's worth mentioning context switches here.  It's a
> > wider problem than that.  Maybe:
> >
> >         /*
> >          * All fpregs will be XRSTOR'd from this buffer before returning
> >          * to userspace.  Ensure that XRSTOR does not init PKRU and that
> >          * get_xsave_addr() will work.
> >          */
> >
> > > +     pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > > +     BUG_ON(!pk);
> >
> > A BUG_ON() a line before a NULL pointer dereference doesn't tend to do
> > much good.
> >
> > > +     pk->pkru = pkru;
> > >       __write_pkru(pkru);
> > >       fpregs_unlock();
> > >  }
> >
