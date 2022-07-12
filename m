Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2957153B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiGLJBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiGLJBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:01:18 -0400
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCFA528A2;
        Tue, 12 Jul 2022 02:01:17 -0700 (PDT)
Received: by mail-qk1-f179.google.com with SMTP id v6so5762537qkh.2;
        Tue, 12 Jul 2022 02:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9ec7iguCfy6L3waGgPnWXclPbbw0CysomvMpi7xE8A=;
        b=MpQRHXriqJl8CEJ5uxrUXpFUKUJzDR66yGyxLdjPlDFQ4XZz0bKQC2IzNiCX1UIKTB
         c9sCW/8/w/IChUZ1BDK6T6uaURGOltcmNzoqy6owg16pSuyfl28s682Kb0GUkPV0d7Ov
         1D/3X5QrAcf+vXxemv0Q5IyxMnvxOeybyde6k6CL/mFxVhDPmf5Q0EI9S9oY8/Z7dCzU
         zMLJ+Y58tBErn/6Sb7ztsY2MVTF4o6glhuZtnjZiJX8w9krw49FdbUw7A40Ckw8hufP7
         XYqBe0KhbOPkDvGQnmjdKX6qLhJGKtr4sZUIMYNISdZjah0EEE5ISxOqUsahAD+Me9gL
         nTUg==
X-Gm-Message-State: AJIora8JFJBQUAzfWvNiHCgqf2bgv/Nx+VAlurcbrTNmdMiIPKVy/B+r
        7ZA/2FAh0hELKlrYTOeX0AynKT0B6WvIvQ==
X-Google-Smtp-Source: AGRyM1tztFo824+aMEzqqd2NZUxNIBzPmbPVGe7lHojMK+TFBh2/X9vuwB6jC5Xh0NQfGEd0VpRIdA==
X-Received: by 2002:a05:620a:2805:b0:67d:5c7e:c43a with SMTP id f5-20020a05620a280500b0067d5c7ec43amr14215040qkp.84.1657616476642;
        Tue, 12 Jul 2022 02:01:16 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id r22-20020ac85e96000000b00317c3ce1f4esm6959917qtx.45.2022.07.12.02.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:01:16 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id n74so12859581yba.3;
        Tue, 12 Jul 2022 02:01:15 -0700 (PDT)
X-Received: by 2002:a05:6902:701:b0:66e:a06d:53d7 with SMTP id
 k1-20020a056902070100b0066ea06d53d7mr20596635ybt.604.1657616474618; Tue, 12
 Jul 2022 02:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn> <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
In-Reply-To: <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 12 Jul 2022 11:01:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
Message-ID: <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <monstr@monstr.eu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        loongarch@lists.linux.dev, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Huacai,

On Tue, Jul 12, 2022 at 10:53 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> On Tue, Jul 12, 2022 at 4:33 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Jul 12, 2022 at 9:53 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
> > > When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
> >
> > DEBUG_PER_CPU_MAPS depends on SMP, which is not supported on m68k,
> > and thus cannot be enabled.
> This patch is derived from MIPS and LoongArch, I search all
> architectures and change those that look the same as MIPS and
> LoongArch.
> And the warning message below is also a copy-paste from LoongArch, sorry.
>
> Since M68K doesn't support SMP, then this patch seems to make no
> difference, but does it make sense to keep consistency across all
> architectures?

Yes, having consistency is good.  But that should be mentioned in the
patch description, instead of a scary warning CCed to stable ;-)

BTW, you probably want to update the other copy of c_start() in
arch/m68k/kernel/setup_mm.c, too.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
