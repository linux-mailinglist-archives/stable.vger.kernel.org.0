Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A18B6C1214
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 13:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCTMnC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 08:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCTMnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 08:43:01 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFEA10263;
        Mon, 20 Mar 2023 05:42:57 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id i24so12778425qtm.6;
        Mon, 20 Mar 2023 05:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679316176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//iKM8WVSdTXQc3NnhUQiu6Eif/KvpjKLv29xeD+zvo=;
        b=R6VkeLDSE6HjxGrNFV7Tl8nWkInxTTCCwLIrvIwyHicgnT3LICnaDm/lVeZnZ8oaaj
         rCYpWXwbtDWtpAG2QijQGFsNJpzeDY8IRW26CfRigUsRHCZb2w1x1ovlBEAGLWjyZPxT
         a2tx+EQnPVjddK5VyHtY23vuS6BrRlXAn63AfOhKB9XxoblkHZN0Wq6u8Y7NQL4MulHa
         +a+bfI4tgPhDpbra1/E9O7pmUcgXPK8iCKU8YL40lucmqld3+FP/j/M9BZUeFxxYSMYv
         a4sTlI3MJ71qjaAy6IFNjPZV7/78QpLUlFFSZU291vfXiA2hnRnoLqDiAVogF0asPHe8
         urSw==
X-Gm-Message-State: AO0yUKWgYwDuSpOrM0nSH350MjRvePbTsP9fO8gjuY11aoKKCCllFNuK
        BccUFTsmbim32A+te5fpIxTnkrhO2OmdKA==
X-Google-Smtp-Source: AK7set91qQVVDWqrLQwdgARRsRvtjQyGR3O2u7aLS7S3h7iInfJ+oJ230bq4ENVWyYd8IKQmh+7tCA==
X-Received: by 2002:a05:622a:174c:b0:3bf:d0c7:12df with SMTP id l12-20020a05622a174c00b003bfd0c712dfmr25493480qtk.63.1679316175894;
        Mon, 20 Mar 2023 05:42:55 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id x16-20020ae9e910000000b007435a646354sm528189qkf.0.2023.03.20.05.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 05:42:55 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id e194so12861160ybf.1;
        Mon, 20 Mar 2023 05:42:55 -0700 (PDT)
X-Received: by 2002:a5b:c47:0:b0:b56:1f24:7e9f with SMTP id
 d7-20020a5b0c47000000b00b561f247e9fmr5448318ybr.12.1679316174827; Mon, 20 Mar
 2023 05:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230306040037.20350-1-rdunlap@infradead.org> <20230306040037.20350-8-rdunlap@infradead.org>
 <056df6d548ad0e4f7f4ccb2782744b165ce20578.camel@physik.fu-berlin.de>
 <CAMuHMdU+tsKuONm9iPqqTFSnRT2zaV3zogYgc-+vCp6x-ruQ_w@mail.gmail.com> <01f84314b2499b6859a4826ecf7363635e66a4fc.camel@physik.fu-berlin.de>
In-Reply-To: <01f84314b2499b6859a4826ecf7363635e66a4fc.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Mar 2023 13:42:43 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVR78EXTVd7ThUEv6rxL8aHSyAoC_5z8KyAPmiTyww85w@mail.gmail.com>
Message-ID: <CAMuHMdVR78EXTVd7ThUEv6rxL8aHSyAoC_5z8KyAPmiTyww85w@mail.gmail.com>
Subject: Re: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is not enabled
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Adrian,

On Mon, Mar 20, 2023 at 10:13 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Mon, 2023-03-20 at 09:16 +0100, Geert Uytterhoeven wrote:
> > On Sun, Mar 19, 2023 at 9:49 PM John Paul Adrian Glaubitz
> > <glaubitz@physik.fu-berlin.de> wrote:
> > > On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> > > > Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
> > > > Fixes this build error:
> > > >
> > > > sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
> > > > (.text+0xec): undefined reference to `dump_stack'
> > > >
> > > > Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
> > > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > > > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > > > Cc: Rich Felker <dalias@libc.org>
> > > > Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > > v2: add PRINTK to STACK_DEBUG dependency (thanks, Geert)
> > > > v3: skipped
> > > > v4: refresh & resend
> > > >
> > > >  arch/sh/Kconfig.debug |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff -- a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
> > > > --- a/arch/sh/Kconfig.debug
> > > > +++ b/arch/sh/Kconfig.debug
> > > > @@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
> > > >
> > > >  config STACK_DEBUG
> > > >       bool "Check for stack overflows"
> > > > -     depends on DEBUG_KERNEL
> > > > +     depends on DEBUG_KERNEL && PRINTK
> > > >       help
> > > >         This option will cause messages to be printed if free stack space
> > > >         drops below a certain limit. Saying Y here will add overhead to
> > >
> > > I can't really test this change as the moment I am enabling CONFIG_STACK_DEBUG,
> > > the build fails with:
> > >
> > >   CC      scripts/mod/devicetable-offsets.s
> > > sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> > > make[1]: *** [scripts/Makefile.build:252: scripts/mod/empty.o] Error 1
> > > make[1]: *** Waiting for unfinished jobs....
> > > sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> > > make[1]: *** [scripts/Makefile.build:114: scripts/mod/devicetable-offsets.s] Error 1
> > > make: *** [Makefile:1286: prepare0] Error 2
> > >
> > > So, I assume we need to strip -fomit-frame-pointer from KBUILD_CFLAGS, correct?
> > >
> > > I tried this change, but that doesn't fix it for me:
> > >
> > > diff --git a/arch/sh/Makefile b/arch/sh/Makefile
> > > index 5c8776482530..83f535b73835 100644
> > > --- a/arch/sh/Makefile
> > > +++ b/arch/sh/Makefile
> > > @@ -173,6 +173,7 @@ KBUILD_AFLAGS               += $(cflags-y)
> > >
> > >  ifeq ($(CONFIG_MCOUNT),y)
> > >    KBUILD_CFLAGS += -pg
> > > +  KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS))
> > >  endif
> > >
> > >  ifeq ($(CONFIG_DWARF_UNWINDER),y)
> > >
> > > Any ideas?
> >
> > Please try with "+=" instead of ":=".
>
> That doesn't work either. I tried the following, but that didn't strip -fomit-frame-pointer:

Oops, obviously all of that happened before my morning coffee ;-)

Makefile has:

    ifdef CONFIG_FRAME_POINTER
    KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
    KBUILD_RUSTFLAGS += -Cforce-frame-pointers=y
    else
    # Some targets (ARM with Thumb2, for example), can't be built with frame
    # pointers.  For those, we don't have FUNCTION_TRACER automatically
    # select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
    # incompatible with -fomit-frame-pointer with current GCC, so we don't use
    # -fomit-frame-pointer with FUNCTION_TRACER.
    # In the Rust target specification, "frame-pointer" is set explicitly
    # to "may-omit".
    ifndef CONFIG_FUNCTION_TRACER
    KBUILD_CFLAGS   += -fomit-frame-pointer
    endif
    endif

Your config probably has CONFIG_FRAME_POINTER set?

    arch/sh/Kconfig.debug=config DWARF_UNWINDER
    arch/sh/Kconfig.debug-  bool "Enable the DWARF unwinder for stacktraces"
    arch/sh/Kconfig.debug-  depends on DEBUG_KERNEL
    arch/sh/Kconfig.debug:  select FRAME_POINTER

You should make sure that cannot happen when CONFIG_FUNCTION_TRACER
is enabled. I.e. make DWARF_UNWINDER depend on !FUNCTION_TRACER?

Other architectures do something similar:

    arch/sparc/Kconfig.debug:config FRAME_POINTER
    arch/sparc/Kconfig.debug-       bool
    arch/sparc/Kconfig.debug-       depends on MCOUNT

    arch/x86/Kconfig.debug:config FRAME_POINTER
    arch/x86/Kconfig.debug- depends on !UNWINDER_ORC && !UNWINDER_GUESS
    arch/x86/Kconfig.debug- bool

Probably you need to adjust the following, too:

    lib/Kconfig.debug:config FRAME_POINTER
    lib/Kconfig.debug-      bool "Compile the kernel with frame pointers"
    lib/Kconfig.debug-      depends on DEBUG_KERNEL && (M68K || UML ||
SUPERH) || ARCH_WANT_FRAME_POINTERS
    lib/Kconfig.debug-      default y if (DEBUG_INFO && UML) ||
ARCH_WANT_FRAME_POINTERS

i.e. drop SUPERH from the list above, and select ARCH_WANT_FRAME_POINTERS
if !FUNCTION_TRACER.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
