Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0818B6C0BFB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 09:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCTIQY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 04:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjCTIQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 04:16:22 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2FC49F9;
        Mon, 20 Mar 2023 01:16:21 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id hf2so7974770qtb.3;
        Mon, 20 Mar 2023 01:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679300180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=of0Yq9oX571KG+30Jsu+T/kTQEXBZMPc6/flv0sgCcc=;
        b=HUU7juWqy9ANW4k2EKlWz4EqHy5MS854M0XzEG+vOrzAV6cOBJuepl2Y5ocGhi1mOR
         cOG6h84XT/CtVP3RvOfujB7MCVYwNQgNuXdTQguyRG3wNo4oNwyD3ichur9enfWrGkY2
         wrbLoZLVCtpSW3Xec/KF8fuBEnSM3wu8CeBNfTLC+xuB0iOXwQWvvpoEnSj1pVe0pyXl
         tXNXk5HP6tyeTHnzKdnTigR4aiBEbbPfqx3Jy+EWgHZbp2lgSr0REdOYwK253nkuDVLf
         du+47oLEO0snsCsfjQtY9AfjO7hHCOVnb9hoehSb9095bTeanfFVTJMsdJLATAvJ3f61
         d93A==
X-Gm-Message-State: AO0yUKWfcp2flK3L0XQFHnHxsWFVPgT7srQ5NDxbKU8HtWd2woB1zTOz
        R+1CuAF0aJE3f3833i9Ks9eyQgKHK/CIDA==
X-Google-Smtp-Source: AK7set+5KqjDZNdTBX85fx4pmZAoTLj/pxtHhSyU9/pTsUGoQ/OY7UkE6HIc4HfoVFTz9hUldKSthg==
X-Received: by 2002:a05:622a:190f:b0:3d6:d055:72af with SMTP id w15-20020a05622a190f00b003d6d05572afmr26625968qtc.53.1679300180521;
        Mon, 20 Mar 2023 01:16:20 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a0d4a00b0074281812276sm406360qkl.97.2023.03.20.01.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 01:16:20 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id z83so11969943ybb.2;
        Mon, 20 Mar 2023 01:16:20 -0700 (PDT)
X-Received: by 2002:a25:3249:0:b0:a02:a3a6:78fa with SMTP id
 y70-20020a253249000000b00a02a3a678famr3648557yby.12.1679300179806; Mon, 20
 Mar 2023 01:16:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230306040037.20350-1-rdunlap@infradead.org> <20230306040037.20350-8-rdunlap@infradead.org>
 <056df6d548ad0e4f7f4ccb2782744b165ce20578.camel@physik.fu-berlin.de>
In-Reply-To: <056df6d548ad0e4f7f4ccb2782744b165ce20578.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Mar 2023 09:16:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU+tsKuONm9iPqqTFSnRT2zaV3zogYgc-+vCp6x-ruQ_w@mail.gmail.com>
Message-ID: <CAMuHMdU+tsKuONm9iPqqTFSnRT2zaV3zogYgc-+vCp6x-ruQ_w@mail.gmail.com>
Subject: Re: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is not enabled
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Adrian,

On Sun, Mar 19, 2023 at 9:49 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> > Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
> > Fixes this build error:
> >
> > sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
> > (.text+0xec): undefined reference to `dump_stack'
> >
> > Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Rich Felker <dalias@libc.org>
> > Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: stable@vger.kernel.org
> > ---
> > v2: add PRINTK to STACK_DEBUG dependency (thanks, Geert)
> > v3: skipped
> > v4: refresh & resend
> >
> >  arch/sh/Kconfig.debug |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff -- a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
> > --- a/arch/sh/Kconfig.debug
> > +++ b/arch/sh/Kconfig.debug
> > @@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
> >
> >  config STACK_DEBUG
> >       bool "Check for stack overflows"
> > -     depends on DEBUG_KERNEL
> > +     depends on DEBUG_KERNEL && PRINTK
> >       help
> >         This option will cause messages to be printed if free stack space
> >         drops below a certain limit. Saying Y here will add overhead to
>
> I can't really test this change as the moment I am enabling CONFIG_STACK_DEBUG,
> the build fails with:
>
>   CC      scripts/mod/devicetable-offsets.s
> sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> make[1]: *** [scripts/Makefile.build:252: scripts/mod/empty.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> make[1]: *** [scripts/Makefile.build:114: scripts/mod/devicetable-offsets.s] Error 1
> make: *** [Makefile:1286: prepare0] Error 2
>
> So, I assume we need to strip -fomit-frame-pointer from KBUILD_CFLAGS, correct?
>
> I tried this change, but that doesn't fix it for me:
>
> diff --git a/arch/sh/Makefile b/arch/sh/Makefile
> index 5c8776482530..83f535b73835 100644
> --- a/arch/sh/Makefile
> +++ b/arch/sh/Makefile
> @@ -173,6 +173,7 @@ KBUILD_AFLAGS               += $(cflags-y)
>
>  ifeq ($(CONFIG_MCOUNT),y)
>    KBUILD_CFLAGS += -pg
> +  KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS))
>  endif
>
>  ifeq ($(CONFIG_DWARF_UNWINDER),y)
>
> Any ideas?

Please try with "+=" instead of ":=".

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
