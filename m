Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9554B8C32
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiBPPPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:15:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiBPPPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:15:48 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56032A229C
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 07:15:35 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id d10so5287877eje.10
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 07:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8yWtnRDmiBWo6FCFDEEJqCLqRrHkWjRAVi+s2lLvSo=;
        b=f3BAJ3dmwr6zzbFGmJ1HHs6XNKfX2cnRHac2LOuMblS+kKXgin+3mpVmJPnogMaLRf
         66LRYY89f9h/mtVellTbQy7ovV/L9QoA5GlYu2vTk25iirrtcx+xBih3GxkY7bqwPzhe
         LdY1iDVoEVR5IVbVqFUAH+oBTC/zcXdvuw+DPR7mMnbwezq1SEVrMtz4kr1s2c+4GlJe
         A0izkNiPQum40m5xPDgOQEQBQu3HvpenKgh3Z5XOqNhxjwOYDEP+j2eu0utMsqX0Ud+C
         78ZW4jsF03+fDmeodT7K2ieDUaBhMKOeU6HAg2d7rz8WUdQOe5ZtGo9kyfF7qtfw/IhD
         zXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8yWtnRDmiBWo6FCFDEEJqCLqRrHkWjRAVi+s2lLvSo=;
        b=g4aEzJU2y/6bAp3iuX46xnT/5KsMr1EWkVvr6iQbfGN8CFWVl0tHGEHXM/Rty7Duls
         7Q33IOkrAxcKsPKziqaoMtWDmuTfp5uWMwM2dRhxT0SdKpo9ElEDCzIyxIN6KFtXO7aG
         7LoAEqaqIt/6hulMLTiyKuw8VSqbmbt3aMOEJRYIvuICeCO70rFoIts/K+ZdDHdyPcfL
         zc6e++FGX+BirMMVgnmd/IrjKkn8Es75TeSxequ1+hDegcGEcw1JYsEN1coeB3WPZwAe
         6SVIUMhrU3iFol3+7E5BYJYX0bf5888aT9+sdjLEknLZZSfvhDWTB2NGO6tuRbSzwbcw
         PvEg==
X-Gm-Message-State: AOAM530aAr72ycTt7QaapvZE8w85/o/FPO0BS2kxIrUhHTLr3iFBi/31
        ol9LHAqePxyZnODMrXhwdWm+XLxIKNQVKEBtM3Aw/Q==
X-Google-Smtp-Source: ABdhPJy0CGS84sjL2SjZudEL5ngyzOt2m9B79Og1r9toUHuFOPMSR7rbgPdAC8J/lBTx18bnsymSv3yQyOuGj1IQE9I=
X-Received: by 2002:a17:907:72c3:b0:6ce:5256:1125 with SMTP id
 du3-20020a17090772c300b006ce52561125mr2616388ejc.697.1645024534258; Wed, 16
 Feb 2022 07:15:34 -0800 (PST)
MIME-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com> <YgzMTrVMCVt+n7cE@kroah.com>
In-Reply-To: <YgzMTrVMCVt+n7cE@kroah.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Wed, 16 Feb 2022 10:14:58 -0500
Message-ID: <CADyq12xwzZG+RZYvXdeB=XT_gyo-YHqqS==91=2=WOmJd4mxiQ@mail.gmail.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate inconsistency
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 5:05 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 15, 2022 at 04:32:48PM -0500, Brian Geffon wrote:
> > On Tue, Feb 15, 2022 at 2:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Feb 15, 2022 at 11:22:33AM -0800, Brian Geffon wrote:
> > > > When eagerly switching PKRU in switch_fpu_finish() it checks that
> > > > current is not a kernel thread as kernel threads will never use PKRU.
> > > > It's possible that this_cpu_read_stable() on current_task
> > > > (ie. get_current()) is returning an old cached value. To resolve this
> > > > reference next_p directly rather than relying on current.
> > > >
> > > > As written it's possible when switching from a kernel thread to a
> > > > userspace thread to observe a cached PF_KTHREAD flag and never restore
> > > > the PKRU. And as a result this issue only occurs when switching
> > > > from a kernel thread to a userspace thread, switching from a non kernel
> > > > thread works perfectly fine because all that is considered in that
> > > > situation are the flags from some other non kernel task and the next fpu
> > > > is passed in to switch_fpu_finish().
> > > >
> > > > This behavior only exists between 5.2 and 5.13 when it was fixed by a
> > > > rewrite decoupling PKRU from xstate, in:
> > > >   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> > > >
> > > > Unfortunately backporting the fix from 5.13 is probably not realistic as
> > > > it's part of a 60+ patch series which rewrites most of the PKRU handling.
> > > >
> > > > Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> > > > Signed-off-by: Brian Geffon <bgeffon@google.com>
> > > > Signed-off-by: Willis Kung <williskung@google.com>
> > > > Tested-by: Willis Kung <williskung@google.com>
> > > > Cc: <stable@vger.kernel.org> # v5.4.x
> > > > Cc: <stable@vger.kernel.org> # v5.10.x
> > > > ---
> > > >  arch/x86/include/asm/fpu/internal.h | 13 ++++++++-----
> > > >  arch/x86/kernel/process_32.c        |  6 ++----
> > > >  arch/x86/kernel/process_64.c        |  6 ++----
> > > >  3 files changed, 12 insertions(+), 13 deletions(-)
> > >
> > > So this is ONLY for 5.4.y and 5.10.y?  I'm really really loath to take
> > > non-upstream changes as 95% of the time (really) it goes wrong.
> >
> > That's correct, this bug was introduced in 5.2 and that code was
> > completely refactored in 5.13 indirectly fixing it.
>

Hi Greg,

> What series of commits contain that work?

This is the series,
https://lore.kernel.org/all/20210623120127.327154589@linutronix.de/,
it does quite a bit of cleanup to correct the larger problem of having
pkru merged into xstate.

> And again, why not just take them?  What is wrong with that if this is
> such a big issue?

Anything is possible I suppose but looking through the series it seems
that it's not going to apply cleanly so we're going to end up with
something that, if we made it work, would look very different and
would touch a much larger cross section of code. If the concern here
is risk of things going wrong, attempting to pull back or cherry-pick
parts of this series seems riskier. However, if we don't attempt to
pull back all those patches I will likely be proposing at least one
more small patch for 5.4 and 5.10 to fix PKRU in these kernels because
right now it's broken, particularly on AMD processors as Dave
mentioned.

>
> > > How was this tested, and what do the maintainers of this subsystem
> > > think?  And will you be around to fix the bugs in this when they are
> > > found?
> >
> > This has been trivial to reproduce, I've used a small repro which I've
> > put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> > , I also was able to reproduce this using the protection_keys self
> > tests on a 11th Gen Core i5-1135G7. I'm happy to commit to addressing
> > any bugs that may appear. I'll see what the maintainers say, but there
> > is also a smaller fix that just involves using this_cpu_read() in
> > switch_fpu_finish() for this specific issue, although that approach
> > isn't as clean.
>
> Can you add the test to the in-kernel tests so that we make sure it is
> fixed and never comes back?

I'm already able to reproduce it with the kernel selftests. To be
honest, I'm not sure why this hasn't been reported yet. I could be
doing something horribly wrong. But it seems the likely reason is that
my compiler is doing what it's allowed to do, which is optimize the
load of current_task. current -> get_current() ->
this_cpu_read_stable(current_task) is allowed to read a cached value.
Perhaps gcc is just not taking advantage of that optimization, I'm not
sure. But writing to current_task and then immediately reading it back
via this_cpu_read_stable() can be problematic for this reason, and the
disassembled code shows that this happening.

Brian

>
> thanks,
>
> greg k-h
