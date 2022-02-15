Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8544B79B0
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243467AbiBOVdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:33:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbiBOVdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:33:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1EDEC5F4
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:33:26 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t21so498699edd.3
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSycWluZZWqMd7iobnE427mbP0AhaCWRVGk9WjPUqDI=;
        b=d9R/K5jisJICbxfnZom2J0LOpS4KfeV/NsU5gaJ4CnIRdXy1mHeW5DBBS4mMiVKV2C
         NJBeO8aYtcGael71sAhNIcWRmAui2etYm6Ip4mOurKoYCHmo+fZIIGOdeOLRgYsq1sJS
         2SJfrfRy0GCV86PMsvhkUZi9u8Z5R1izoVwLwuN+zyIUJGXOIILIiTX0cw0bQPoxqu/c
         zsXBC78Bhi+sx6ZhYZK1NQdX1fvylS2WKYxXn/VYOjdhmsVHFGTxvUEhpj/bv0r9X0dR
         ucWgIzWpfWTN3I9Pbumnwy9Z8xbwxmhySE2GSDGLsFTwsMVcWa2IVThTA0NOy6uaEhWl
         U0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSycWluZZWqMd7iobnE427mbP0AhaCWRVGk9WjPUqDI=;
        b=Fkw39/fS5sRdrcnAbfXOK0wHdgXoTTPLOnMzydO5iu2N29vdeU9B6w3SJ+pLNXFTGF
         pvjUbP9y0cVh0D/PWdMwvWY5k68dz8M9tuYEi8GSZFP55XuhYSvQ63t/FvTTszd9/SNT
         UVVGe5t8/zs+dhRm331yBt8hbYQrsVx9gKK+G7a+9w9VnHHFv+Vgjua3/sZ5n/n5XZD7
         FnFEE2Mqdnl7Pe0wd5EjxPWZLpIm7JLXzLR2k8dQZAw8YKC5hHPNEQXTEdm2cozFRIne
         VtwuV49unToXCxsuJ79lZxSo//PPm2+ZFKZOrdBO/F4lzMqPLnp3weYweIZjJS8xWJOz
         Tkhg==
X-Gm-Message-State: AOAM531hWYk51AOlOxicIUxByWFqLpngzGAtELlUO5DLpstlzzIaxRDy
        4l8cHfCBisnEVD1g81ZPUDmaaduOoBwj/QFHo+IedQ==
X-Google-Smtp-Source: ABdhPJwgruwmHU71m/kpkaKdMekQEntlupnMp63LjKSmPCsZcC3S2G0HzeAWdsNKHRieSb8vzWqlazMpvoJqRN6eAfo=
X-Received: by 2002:a05:6402:2946:: with SMTP id ed6mr904345edb.221.1644960805072;
 Tue, 15 Feb 2022 13:33:25 -0800 (PST)
MIME-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
In-Reply-To: <YgwCuGcg6adXAXIz@kroah.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 15 Feb 2022 16:32:48 -0500
Message-ID: <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
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

On Tue, Feb 15, 2022 at 2:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 15, 2022 at 11:22:33AM -0800, Brian Geffon wrote:
> > When eagerly switching PKRU in switch_fpu_finish() it checks that
> > current is not a kernel thread as kernel threads will never use PKRU.
> > It's possible that this_cpu_read_stable() on current_task
> > (ie. get_current()) is returning an old cached value. To resolve this
> > reference next_p directly rather than relying on current.
> >
> > As written it's possible when switching from a kernel thread to a
> > userspace thread to observe a cached PF_KTHREAD flag and never restore
> > the PKRU. And as a result this issue only occurs when switching
> > from a kernel thread to a userspace thread, switching from a non kernel
> > thread works perfectly fine because all that is considered in that
> > situation are the flags from some other non kernel task and the next fpu
> > is passed in to switch_fpu_finish().
> >
> > This behavior only exists between 5.2 and 5.13 when it was fixed by a
> > rewrite decoupling PKRU from xstate, in:
> >   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> >
> > Unfortunately backporting the fix from 5.13 is probably not realistic as
> > it's part of a 60+ patch series which rewrites most of the PKRU handling.
> >
> > Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> > Signed-off-by: Brian Geffon <bgeffon@google.com>
> > Signed-off-by: Willis Kung <williskung@google.com>
> > Tested-by: Willis Kung <williskung@google.com>
> > Cc: <stable@vger.kernel.org> # v5.4.x
> > Cc: <stable@vger.kernel.org> # v5.10.x
> > ---
> >  arch/x86/include/asm/fpu/internal.h | 13 ++++++++-----
> >  arch/x86/kernel/process_32.c        |  6 ++----
> >  arch/x86/kernel/process_64.c        |  6 ++----
> >  3 files changed, 12 insertions(+), 13 deletions(-)
>
> So this is ONLY for 5.4.y and 5.10.y?  I'm really really loath to take
> non-upstream changes as 95% of the time (really) it goes wrong.

That's correct, this bug was introduced in 5.2 and that code was
completely refactored in 5.13 indirectly fixing it.

>
> How was this tested, and what do the maintainers of this subsystem
> think?  And will you be around to fix the bugs in this when they are
> found?

This has been trivial to reproduce, I've used a small repro which I've
put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
, I also was able to reproduce this using the protection_keys self
tests on a 11th Gen Core i5-1135G7. I'm happy to commit to addressing
any bugs that may appear. I'll see what the maintainers say, but there
is also a smaller fix that just involves using this_cpu_read() in
switch_fpu_finish() for this specific issue, although that approach
isn't as clean.

>
> And finally, what's wrong with 60+ patches to backport to fix a severe
> issue?  What's preventing that from happening?  Did you try it and see
> what exactly is involved?

It was quite a substantial rewrite of that code with fixes layered on since.

>
> thanks,
>
> greg k-h
