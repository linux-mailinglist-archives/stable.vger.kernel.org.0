Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1209576358
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiGOOES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiGOOED (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:04:03 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB3A1085;
        Fri, 15 Jul 2022 07:03:58 -0700 (PDT)
Received: from zn.tnic (p200300ea972976d6329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:76d6:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D6FE1EC0230;
        Fri, 15 Jul 2022 16:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1657893833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QbGEmJveh3meLgmCPkkX0DKI0iC+qcLBcQMOHTKMAeA=;
        b=LB2MDoPtY6niEMtL5F7KecDtH4G0UZgkeTflXgMMlmXzw5ldpKCVemI9gqTPo5AbSxg4EW
        neTaQrJ9rtBNWQfLpqiya0QbagUNun22n4H4xbVnGw/H+WnaqfWZRgp/+bLcfLXcAu155u
        ALgPcfTW5UMjfnkyTyX7SUoHin+yrs0=
Date:   Fri, 15 Jul 2022 16:03:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <YtFzw2+wi9GA5qy8@zn.tnic>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
 <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
 <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
 <YtBLe5AziniDm/Wt@nazgul.tnic>
 <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:39:25PM -0700, Linus Torvalds wrote:
> On Thu, Jul 14, 2022 at 10:02 AM Borislav Petkov <bp@alien8.de> wrote:
> >
> > On Thu, Jul 14, 2022 at 09:51:40AM -0700, Linus Torvalds wrote:
> > > Oh, absolutely. Doing an -rc7 is normal.
> >
> > Good. I'm gathering all the fallout fixes and will send them to you on
> > Sunday, if nothing unexpected happens.
> 
> Btw, I assume that includes the clang fix for the
> x86_spec_ctrl_current section attribute.

Yap. Here's the current lineup:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/urgent

> That's kind of personally embarrassing that it slipped through: I do
> all my normal test builds that I actually *boot* with clang.
> 
> But since I kept all of the embargoed stuff outside my normal trees,
> it also meant that the test builds I did didn't have my "this is my
> clang tree" stuff in it.
> 
> And so I - like apparently everybody else - only did those builds with gcc.
> 
> And gcc for some reason doesn't care about this whole "you redeclared
> that variable with a different attribute" thing.

... so why does clang care? Or, why doesn't gcc care?

I guess I need to talk to gcc folks again.

> In the 'x86_spec_ctrl_current' case, that nonsensical code _worked_
> (with gcc), because despite the declaration being for a regular
> variable, the actual definition was in the proper segment.

I'm guessing this is the reason why gcc doesn't fail - it probably looks
at the declaration but doesn't care too much about it. And it is the
definition that matters.

While clang goes, uh, ah, declaration and definition mismatch, I better
warn.

> But that 'myvariable' thing above does end up being another example of
> how we are clearly missing some type checkng in this area.
> 
> I'm not sure if there's any way to get that section mismatch at
> compile-time at all.

Well, apparently, clang can:

arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]

so there's a -Wsection warning which gcc could implement too.

> For the static declarations, we could just make DECLARE_PER_CPU() add
> some prefix/postfix to the name (and obviously then do it at use time
> too).
>
> We have that '__pcpu_scope_##name' thing to make sure of globally
> unique naming due to the whole weak type thing. I wonder if we could
> do something similar to verify that "yes, this has been declared as a
> percpu variable" at use time?

But how?

We need to save the info how a var has been declared and then use that
info at access time.

Yeah, lemme bother compiler guys a bit...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
