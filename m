Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3988A4B797F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbiBOVPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:15:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbiBOVPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:15:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0957ED9E
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:14:57 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw13so18408818ejc.9
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SOESlV2s6ZwCllfQeNa8evJBNbO1odv7aNzYs4NXHeE=;
        b=Gj2Jg9IaholauJKgsi2qxw70XeHf2lRTlaQON8YobEMcYWbMg3wXnqfCORFUf1urpD
         0vF+eiEdcqtpVPXKmjmC8LZqRwFnxOYz4dAaSB4wDjvt8F4YHbFcnfFTYFMV6v3AUuXX
         8cDQmWDO8X1dmJfiyF+mZd2G7Djx+5HIPachZnLdjtB2W5skdyVU9uAH1UJIdUHF/+Ft
         mrBbIZwSrpiV2W5mMEjt36UYXj/9kqdP3T0ni6kIWQ5AlQ6pbfQ3CrYpRMeOcM84h9t9
         toAjzRB1+PVToxIzNics0/psPRNC32ZcnLTvOMwavxSTac6hKaj/jot/Z/XASlm+4ShV
         ilKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOESlV2s6ZwCllfQeNa8evJBNbO1odv7aNzYs4NXHeE=;
        b=HC+IohLEskaxJzpexy4/cu8aUqcaSY25ktoeTtVIZfMkbCO6H24XRuYkOoaVy2PIAC
         IfLhmVM76Owv6lSZ2jCQZrtJKur0Xqq1E5ny/ABSHWR/Fl4WgbiLD3eyU3E4EJJEZa3B
         v5uywIcuVG/OggnsVNfzz9SXRpv7ZzhcUNtKHPj4uyXM0V64egoN2a8EZy1ioTznwzsE
         xhoUkDZQuac2wG8gEEqRiYgsQQcBTlFY8Vyssk2Tboo4Ql/7Z9wxly0Q+m1u2xz5RIGK
         AI3o3/Ty4+2k3Hb/SnQWwaC+ZtIDhiFdraZQbJvAOhTp6m8CyPkJSthA96GT4Ljia24i
         QNFQ==
X-Gm-Message-State: AOAM530GDbjvI38XMlwGkFR9MW+QvN1qe2HDKE5mldSlrDEKphWQu8XE
        Fzf8QzvGZBTIVFFrRsYuS+yU1fBvf9J8dyIcNEM40Q==
X-Google-Smtp-Source: ABdhPJyoZAixW+aB10cycT90fPdgth70NFV7Bu4ziUqzGkm8HfDb8pzX1Wq3ZeRNIwKYpJ9uPhsTFsiL9qm/vERfNRE=
X-Received: by 2002:a17:906:74d2:: with SMTP id z18mr833705ejl.618.1644959695408;
 Tue, 15 Feb 2022 13:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20220215153644.3654582-1-bgeffon@google.com> <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
In-Reply-To: <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 15 Feb 2022 13:14:43 -0800
Message-ID: <CABXOdTcU1eLLzjRdJiwfVpoJi8WqYXj5bTrJ_-tm4pgRZK0uYw@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brian Geffon <bgeffon@google.com>,
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

On Tue, Feb 15, 2022 at 9:13 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/15/22 07:36, Brian Geffon wrote:
> > There are two issues with PKRU handling prior to 5.13.
>
> Are you sure both of these issues were introduced by 0cecca9d03c?  I'm
> surprised that the get_xsave_addr() issue is not older.
>
> Should this be two patches?
>
> > The first is that when eagerly switching PKRU we check that current
>
> Don't forget to write in imperative mood.  No "we's", please.
>
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html
>
> This goes for changelogs and comments too.
>
> > is not a kernel thread as kernel threads will never use PKRU. It's
> > possible that this_cpu_read_stable() on current_task (ie.
> > get_current()) is returning an old cached value. By forcing the read
> > with this_cpu_read() the correct task is used. Without this it's
> > possible when switching from a kernel thread to a userspace thread
> > that we'll still observe the PF_KTHREAD flag and never restore the
> > PKRU. And as a result this issue only occurs when switching from a
> > kernel thread to a userspace thread, switching from a non kernel
> > thread works perfectly fine because all we consider in that situation
> > is the flags from some other non kernel task and the next fpu is
> > passed in to switch_fpu_finish().
>
> It makes *sense* that there would be a place in the context switch code
> where 'current' is wonky, but I never realized this.  This seems really
> fragile, but *also* trivially detectable.
>
> Is the PKRU code really the only code to use 'current' in a buggy way
> like this?
>
> > The second issue is when using write_pkru() we only write to the
> > xstate when the feature bit is set because get_xsave_addr() returns
> > NULL when the feature bit is not set. This is problematic as the CPU
> > is free to clear the feature bit when it observes the xstate in the
> > init state, this behavior seems to be documented a few places throughout
> > the kernel. If the bit was cleared then in write_pkru() we would happily
> > write to PKRU without ever updating the xstate, and the FPU restore on
> > return to userspace would load the old value agian.
>
>
>                                                 ^ again
>
> It's probably worth noting that the AMD init tracker is a lot more
> aggressive than Intel's.  On Intel, I think XRSTOR is the only way to
> get back to the init state.  You're obviously hitting this on AMD.
>

Brian should correct me here, but I think we have seen this with one
specific Intel CPU.

Brian, would it make sense to list the affected CPU model(s), or at
least the ones where we have observed the problem ?

Thanks,
Guenter

> It's also *very* unlikely that PKRU gets back to a value of 0.  I think
> we added a selftest for this case in later kernels.
>
> That helps explain why this bug hung around for so long.
>
> > diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> > index 03b3de491b5e..540bda5bdd28 100644
> > --- a/arch/x86/include/asm/fpu/internal.h
> > +++ b/arch/x86/include/asm/fpu/internal.h
> > @@ -598,7 +598,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
> >        * PKRU state is switched eagerly because it needs to be valid before we
> >        * return to userland e.g. for a copy_to_user() operation.
> >        */
> > -     if (!(current->flags & PF_KTHREAD)) {
> > +     if (!(this_cpu_read(current_task)->flags & PF_KTHREAD)) {
>
> This really deserves a specific comment.
>
> >               /*
> >                * If the PKRU bit in xsave.header.xfeatures is not set,
> >                * then the PKRU component was in init state, which means
> > diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> > index 9e71bf86d8d0..aa381b530de0 100644
> > --- a/arch/x86/include/asm/pgtable.h
> > +++ b/arch/x86/include/asm/pgtable.h
> > @@ -140,16 +140,22 @@ static inline void write_pkru(u32 pkru)
> >       if (!boot_cpu_has(X86_FEATURE_OSPKE))
> >               return;
> >
> > -     pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > -
> >       /*
> >        * The PKRU value in xstate needs to be in sync with the value that is
> >        * written to the CPU. The FPU restore on return to userland would
> >        * otherwise load the previous value again.
> >        */
> >       fpregs_lock();
> > -     if (pk)
> > -             pk->pkru = pkru;
> > +     /*
> > +      * The CPU is free to clear the feature bit when the xstate is in the
> > +      * init state. For this reason, we need to make sure the feature bit is
> > +      * reset when we're explicitly writing to pkru. If we did not then we
> > +      * would write to pkru and it would not be saved on a context switch.
> > +      */
> > +     current->thread.fpu.state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;
>
> I don't think we need to describe how the init optimization works again.
>  I'm also not sure it's worth mentioning context switches here.  It's a
> wider problem than that.  Maybe:
>
>         /*
>          * All fpregs will be XRSTOR'd from this buffer before returning
>          * to userspace.  Ensure that XRSTOR does not init PKRU and that
>          * get_xsave_addr() will work.
>          */
>
> > +     pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> > +     BUG_ON(!pk);
>
> A BUG_ON() a line before a NULL pointer dereference doesn't tend to do
> much good.
>
> > +     pk->pkru = pkru;
> >       __write_pkru(pkru);
> >       fpregs_unlock();
> >  }
>
