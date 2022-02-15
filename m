Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB84B78BB
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiBORvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:51:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiBORvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:51:37 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AB0E7F
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:51:25 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z13so681870edc.12
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rsKrphKAL3/1CC5z6jH9OwpoMXOTNr6E2gqOnqAmfTc=;
        b=di68p0dyAx2HAO0bzn3kYS0zIYH26Jthhw3M6EEVlFzSZVY06lp2Cw+SdejpV20zJS
         PvnrJ2eL7y6A8bcN8WOsFYxgRrmy8oZfQUE/wYBuIbr3Z/HwOKA63bEvyPxBIcvTa4YP
         SkIO+0UzfHDguIb4nERzUc9E1FEv/9e0yhyKGdjqzTF7ohFgn98wGEvVT2Czjojm0WSg
         GdN+fGLLUUfIcs36YXBgSEylQATagUod4GTQFyQGWb747fzfcAOZkEghOgTgC1XZCRVY
         y0DQ1ua10TvjUvuHjghm/gurzjxiBnO0ewb/A+cV+buVK19BNy/xHCUr8lecHytOvclx
         vJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rsKrphKAL3/1CC5z6jH9OwpoMXOTNr6E2gqOnqAmfTc=;
        b=BLEOc3MzEGqx5/KjMs+PpqF7tdOlepMHHmKrwqfSLI5E2n0JiAjRaGtCETGdIeK4e0
         jubMVjoe38l9kodydWzRAG/CfJ/vA3KGqbwPWZUyWoo4D1WP6VArNaHfr8kHroDdz1HC
         V3Tk5G23ECM/ajMLXRIn3w70+BQOq0+pKE3nGawj+J8ysfO1o/G5pf5NRgzbXENU6OMK
         1bQhg1CI7TRv43WjtJ8vDuzGVfU92fjONeL7zU5DCicAyA+sNDvCP8yfffaWkVbdikkJ
         zIS1m4jqDOyL70QHmX9RCfj+fKML2KDJ0pDvg1iuYk6WpnCDu5KfiuSzxCCTgHglDyOf
         vV+g==
X-Gm-Message-State: AOAM533Zdw+puSuFd17gNYRbSehcJEA6PhICRH6n5keJrh3mipktJnEo
        T4rSRGrLNLC5lsq0oIrSg6CogTwyEOaQq+es4ogZDg==
X-Google-Smtp-Source: ABdhPJxYWQtVg69hMTMN/KE/xcMVmWwMsszjl5iQESyEBZ4RK9a0p44BaheDzmUurwnoS53jfoYxATRKAREhX25m2wI=
X-Received: by 2002:a05:6402:2993:: with SMTP id eq19mr37686edb.233.1644947483392;
 Tue, 15 Feb 2022 09:51:23 -0800 (PST)
MIME-Version: 1.0
References: <20220215153644.3654582-1-bgeffon@google.com> <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
In-Reply-To: <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 15 Feb 2022 12:50:47 -0500
Message-ID: <CADyq12x2sd4hrfX9XeG7pCbJx8ZHGb9FZo=9G1BavkrAUX7r-g@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dave,
Thank you for taking a look at this.

On Tue, Feb 15, 2022 at 12:13 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/15/22 07:36, Brian Geffon wrote:
> > There are two issues with PKRU handling prior to 5.13.
>
> Are you sure both of these issues were introduced by 0cecca9d03c?  I'm
> surprised that the get_xsave_addr() issue is not older.
>
> Should this be two patches?

You're right, the get_xsave_addr() issue is much older than the eager
reloading of PKRU. I'll split this out into two patches.

>
> > The first is that when eagerly switching PKRU we check that current
>
> Don't forget to write in imperative mood.  No "we's", please.
>
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html
>
> This goes for changelogs and comments too.

This will be corrected in future patches.

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

Yes, because the remaining code in __switch_to() references the next
task as next_p rather than current. Technically, it might be more
correct to pass next_p to switch_fpu_finish(), what do you think? This
may make sense since we're also passing the next fpu anyway.

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

Brian
