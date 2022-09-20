Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE05BF008
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiITWXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 18:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiITWXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 18:23:40 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1783E4F189
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 15:23:38 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id q26so4759991vsr.7
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 15:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Bmjjq9da2ZZQv+bFqrfQD4q9L5cTlcfvUlJYV0gue+Q=;
        b=kC8GcBSEzpY3ni0r7gLE0rdV1zCZyCYXgZWHDP/hxtmnrW1WDQxRM4VqgQpe8y0TKO
         zjCJFs2v9gY50RO00olwxtS7GsFOLaTahcZ1RnjMTUIcM/ilbRKt8h6olpkh2HHEBomD
         LuD3AUSauSkc56m9cM7q8UrSV7BHKxlmClLls40HrJdDYwICXqCIGDj2he6rM4xrg7Lx
         Q26JxSbuymA2G8s94MT1OjHrfBWD6PUona0GuUuu6rWvXM+bDppNwd2ickOKoGXKwwUh
         r8Pg/Dj2bxtbu65OSsbCfFhK8hIlGXLGLbdAKoJ5kglB2scI+H5/pUt2e28k3saBXBqz
         np3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Bmjjq9da2ZZQv+bFqrfQD4q9L5cTlcfvUlJYV0gue+Q=;
        b=4r95SQuGIxPd1mXiy7/for6/jHCF/GlqIXZjxH8ud5+/O0qPR7ftp4FoqO0IjjXI6m
         AHC1szHMZdhl7vYiPDL090jrTxfZ8ilFaVHCecojeBxcquVNUfc+MCzwdzKdnpzxcd17
         FGhQqqA/sX3wgOKK6y6w9/tton6nX4JJXTVmsjmDpopMQKTcOcZ9wNVBthRYQFT6pVvq
         6n3G9hTOmWMWeeUf7o98YqOFb67gwcqNJAze4WBcI272AtHKUQQ9PtjZOI7W6D8JoRUR
         DXniRev0mZmZ16PrPBQ0Ke/kRMvg146rU1/UrDkWG4HPMbhP5ydJ7o4b1/LwSrtPn23w
         Opdg==
X-Gm-Message-State: ACrzQf2lbMePrne0ZTsC2qrXjbDqeQkmDDBqsA1vYgOxT4KATIs6G44u
        4MMuXsUdKlHpWpL1Ctm8JSegKMz/zyQCR3+c5ScwPQ==
X-Google-Smtp-Source: AMsMyM7Vf/QRcnAyBz+54K5dEI3RtDnKBzaPFQ0uwrc7uBvxnfJRLEgGe8C4ePJRpBzkc96kaDDLlRGb1AzNpRFIiK8=
X-Received: by 2002:a67:ac09:0:b0:39a:eab8:a3a6 with SMTP id
 v9-20020a67ac09000000b0039aeab8a3a6mr5799386vse.9.1663712617046; Tue, 20 Sep
 2022 15:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220919201648.2250764-1-keescook@chromium.org>
In-Reply-To: <20220919201648.2250764-1-keescook@chromium.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 20 Sep 2022 16:23:00 -0600
Message-ID: <CAOUHufZpan+wVO7tHgMOkX--0JGhv-mqj2Y+QQKRB4GAGSR18w@mail.gmail.com>
Subject: Re: [PATCH v2] x86/uaccess: Avoid check_object_size() in copy_from_user_nmi()
To:     Kees Cook <keescook@chromium.org>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 2:16 PM Kees Cook <keescook@chromium.org> wrote:
>
> The check_object_size() helper under CONFIG_HARDENED_USERCOPY is
> designed to skip any checks where the length is known at compile time as
> a reasonable heuristic to avoid "likely known-good" cases. However, it can
> only do this when the copy_*_user() helpers are, themselves, inline too.
>
> Using find_vmap_area() requires taking a spinlock. The check_object_size()
> helper can call find_vmap_area() when the destination is in vmap memory.
> If show_regs() is called in interrupt context, it will attempt a call to
> copy_from_user_nmi(), which may call check_object_size() and then
> find_vmap_area(). If something in normal context happens to be in the
> middle of calling find_vmap_area() (with the spinlock held), the interrupt
> handler will hang forever.
>
> The copy_from_user_nmi() call is actually being called with a fixed-size
> length, so check_object_size() should never have been called in
> the first place. Given the narrow constraints, just replace the
> __copy_from_user_inatomic() call with an open-coded version that calls
> only into the sanitizers and not check_object_size(), followed by a call
> to raw_copy_from_user().
>
> Reported-by: Yu Zhao <yuzhao@google.com>
> Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
> Reported-by: dev@der-flo.net
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: drop the call explicitly instead of using inline to do it
> v1: https://lore.kernel.org/lkml/20220916135953.1320601-1-keescook@chromium.org
> ---
>  arch/x86/lib/usercopy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> index ad0139d25401..d2aff9b176cf 100644
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -44,7 +44,8 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>          * called from other contexts.
>          */
>         pagefault_disable();
> -       ret = __copy_from_user_inatomic(to, from, n);
> +       instrument_copy_from_user(to, from, n);

Got a build error on top of mm-unstable:

arch/x86/lib/usercopy.c:47:2: error: call to undeclared function
'instrument_copy_from_user'; ISO C99 and later do not support implicit
function declarations [-Wimplicit-function-declaration]
        instrument_copy_from_user(to, from, n);
        ^
arch/x86/lib/usercopy.c:47:2: note: did you mean 'instrument_copy_to_user'?
./include/linux/instrumented.h:117:1: note: 'instrument_copy_to_user'
declared here
instrument_copy_to_user(void __user *to, const void *from, unsigned long n)
^
1 error generated.
