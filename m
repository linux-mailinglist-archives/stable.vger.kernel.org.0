Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651F15BF04E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 00:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiITWkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 18:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiITWky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 18:40:54 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB2460536
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 15:40:52 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id h5so2235839vkc.5
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=feF0pWZTn2Zc/IkbvC1etqQRI36KuL09kqp6iu4zVEM=;
        b=E3Pzd9jd92LDJwdyr5zf76keKKFIu6e8v0z7zmMeEPUdKua1XeY5ddHjnMZPaRtoIT
         WJVo5fW1KZvjiiNWRvRFKiBBAeLAYGaUA3q5dxZr1Q3z02tRdPCWIBtSIkBHI1TDdobB
         hbboo96dM3oLt7mZsJYFYBDFQGXklMYT3G6/dmG2DUaykbEzbs8th/SzdvnKAYwdOpOD
         PYJ6fo6A7Y1D0majAC+OTvHlcYEJXBp11JzyLWwr9pfrg1mn1Y9neQRzVzSihODmpjDH
         ba6aHcUEcwjUTFHdXgscb3T4UTEsvqPHN6FBobk1kE/hebSjJtoAfloVohqoCajwaMEt
         4nvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=feF0pWZTn2Zc/IkbvC1etqQRI36KuL09kqp6iu4zVEM=;
        b=xke32TUH+fHjuuWzZN6U59HD8UrVx2nKcwiWgOUF6MRnVD4Pzwi1ENBwQBIv+kLFiW
         Kh0Cc/VsIeOzX8FrdPAYRG45KvdDjT5bVQJsjirNbpF9MYuPvyXIozTbvQjOD5Wovz+1
         RIUIPQ3vsm4Ykbpm1X9SK+ltECacshoVy0QsmU7o6f+4zrgiqS9CF6ujhtooPAV0+mOk
         l3V5/i0upbHVh28HDQcP3jBhS0q45yDgppGhlkVl1u7j133sYQUWF0K37b25mXAiFSQJ
         3QSu4x57OFeoOD/fZnrVe7fAnJCmoPOeMIAKDPjnlp8r/hnyv3cpSIzKxSSFLlgHNjlF
         hE0g==
X-Gm-Message-State: ACrzQf1kZJgKmbz7mbcXUA26C83dr+Lp8PASGd90pMepdUi27pnciu5H
        DBb+NzgghFkP17aU9FYljOx2uBbgBv4VmplUdwV7oQ==
X-Google-Smtp-Source: AMsMyM5v56aelte8sjgWUB9Ht3q7n+YaCRvQ0ZRykToPaR3UKng1baO1qlEgoLg7jwrCjGPPno4VolniPigSx6kUcLI=
X-Received: by 2002:a05:6122:e13:b0:39e:e508:1a2e with SMTP id
 bk19-20020a0561220e1300b0039ee5081a2emr9658468vkb.11.1663713651641; Tue, 20
 Sep 2022 15:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220919201648.2250764-1-keescook@chromium.org>
 <CAOUHufZpan+wVO7tHgMOkX--0JGhv-mqj2Y+QQKRB4GAGSR18w@mail.gmail.com> <202209201529.D90CDD898@keescook>
In-Reply-To: <202209201529.D90CDD898@keescook>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 20 Sep 2022 16:40:15 -0600
Message-ID: <CAOUHufb3hcs2yX_ztDagw0Fj_r-iybhfzRs_JSo3hs-5BiRKuQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/uaccess: Avoid check_object_size() in copy_from_user_nmi()
To:     Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>, dev@der-flo.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 4:30 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Sep 20, 2022 at 04:23:00PM -0600, Yu Zhao wrote:
> > On Mon, Sep 19, 2022 at 2:16 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > The check_object_size() helper under CONFIG_HARDENED_USERCOPY is
> > > designed to skip any checks where the length is known at compile time as
> > > a reasonable heuristic to avoid "likely known-good" cases. However, it can
> > > only do this when the copy_*_user() helpers are, themselves, inline too.
> > >
> > > Using find_vmap_area() requires taking a spinlock. The check_object_size()
> > > helper can call find_vmap_area() when the destination is in vmap memory.
> > > If show_regs() is called in interrupt context, it will attempt a call to
> > > copy_from_user_nmi(), which may call check_object_size() and then
> > > find_vmap_area(). If something in normal context happens to be in the
> > > middle of calling find_vmap_area() (with the spinlock held), the interrupt
> > > handler will hang forever.
> > >
> > > The copy_from_user_nmi() call is actually being called with a fixed-size
> > > length, so check_object_size() should never have been called in
> > > the first place. Given the narrow constraints, just replace the
> > > __copy_from_user_inatomic() call with an open-coded version that calls
> > > only into the sanitizers and not check_object_size(), followed by a call
> > > to raw_copy_from_user().
> > >
> > > Reported-by: Yu Zhao <yuzhao@google.com>
> > > Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
> > > Reported-by: dev@der-flo.net
> > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > Cc: x86@kernel.org
> > > Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > > v2: drop the call explicitly instead of using inline to do it
> > > v1: https://lore.kernel.org/lkml/20220916135953.1320601-1-keescook@chromium.org
> > > ---
> > >  arch/x86/lib/usercopy.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> > > index ad0139d25401..d2aff9b176cf 100644
> > > --- a/arch/x86/lib/usercopy.c
> > > +++ b/arch/x86/lib/usercopy.c
> > > @@ -44,7 +44,8 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
> > >          * called from other contexts.
> > >          */
> > >         pagefault_disable();
> > > -       ret = __copy_from_user_inatomic(to, from, n);
> > > +       instrument_copy_from_user(to, from, n);
> >
> > Got a build error on top of mm-unstable:
> >
> > arch/x86/lib/usercopy.c:47:2: error: call to undeclared function
> > 'instrument_copy_from_user'; ISO C99 and later do not support implicit
> > function declarations [-Wimplicit-function-declaration]
> >         instrument_copy_from_user(to, from, n);
> >         ^
> > arch/x86/lib/usercopy.c:47:2: note: did you mean 'instrument_copy_to_user'?
> > ./include/linux/instrumented.h:117:1: note: 'instrument_copy_to_user'
> > declared here
> > instrument_copy_to_user(void __user *to, const void *from, unsigned long n)
> > ^
> > 1 error generated.
>
> Hm, I did test builds of this before sending. I wonder why this passed
> for me. I suppose this is needed explicitly in arch/x86/lib/usercopy.c:
>instrument_copy_to_user()
> #include <linux/instrumented.h>

It seems mm-unstable has switched to instrument_copy_from_user_{before,after}().

Adding Alex.
