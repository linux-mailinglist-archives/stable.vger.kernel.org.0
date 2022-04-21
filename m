Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39764509843
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 09:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385352AbiDUG5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 02:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355352AbiDUG5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 02:57:01 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880641573A;
        Wed, 20 Apr 2022 23:53:13 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id a10so3043988qvm.8;
        Wed, 20 Apr 2022 23:53:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJDkHKGLNQny7+nf6+dAQhj4pSl5mPJhKTIW2Wu14QI=;
        b=shpFBf9WInVCfV0s6K0AO6KIS/NaU1qw83eQ2sk8NO/39KEAaJi438icMOKafAB1He
         MQZgmFubtpJ/e3X+55RD7ANmRgHEICjrTsRuanjxmzMdO8OwiWC9j81ANxgqJ7uNROm+
         fFwoWS/pBZW3jsUJ/8j2H5dd08HptEHaBuPYRmlqZxKH/e97VPkRkE7Z1otqzCo5RQ98
         u+53OyFejpH370mVCNHcg+oAAKiIcOwZpYJzj+azQDZltKoDqtJe+3iT9NfkvIuGPi//
         4ZpUyjPLanLPSJuuvSHH49Pgg8PxhMmAkbATHUHY3WXYNGRQO/gTMN3/qiuu/T0nG1Ra
         lKPQ==
X-Gm-Message-State: AOAM5328t5MtqGld9LoXHrACLOayXKoYUuBcjlDr2wIL1LABz2v81d+J
        N+A4oe+nJwq4cnQ8QwqBD0uNTthZjJyNkBaG
X-Google-Smtp-Source: ABdhPJxAkrc4iamroPKLpa3tQkmgZXpblVdnmpT6fa++ZhcR2yYkYarZIQGcuPizOU4JTToCQNlLnQ==
X-Received: by 2002:a05:6214:769:b0:446:538f:2b86 with SMTP id f9-20020a056214076900b00446538f2b86mr14708824qvz.4.1650523992310;
        Wed, 20 Apr 2022 23:53:12 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id a190-20020a3766c7000000b0069e770524adsm2627453qkc.114.2022.04.20.23.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 23:53:11 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id p65so7014414ybp.9;
        Wed, 20 Apr 2022 23:53:11 -0700 (PDT)
X-Received: by 2002:a5b:984:0:b0:63f:8c38:676c with SMTP id
 c4-20020a5b0984000000b0063f8c38676cmr23970174ybq.393.1650523990757; Wed, 20
 Apr 2022 23:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com> <Yli8voX7hw3EZ7E/@x1-carbon>
 <81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org> <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <01b063d7-d5c2-8af0-ad90-ed6c069252c5@linux-m68k.org>
In-Reply-To: <01b063d7-d5c2-8af0-ad90-ed6c069252c5@linux-m68k.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 21 Apr 2022 08:52:59 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXd94L=766usN4WG-hK2MpQLy50mJZ=9G9NGv03kx8V8Q@mail.gmail.com>
Message-ID: <CAMuHMdXd94L=766usN4WG-hK2MpQLy50mJZ=9G9NGv03kx8V8Q@mail.gmail.com>
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 1:53 AM Greg Ungerer <gerg@linux-m68k.org> wrote:
> On 21/4/22 00:58, Eric W. Biederman wrote:
> > In a recent discussion[1] it was reported that the binfmt_flat library
> > support was only ever used on m68k and even on m68k has not been used
> > in a very long time.
> >
> > The structure of binfmt_flat is different from all of the other binfmt
> > implementations becasue of this shared library support and it made
> > life and code review more effort when I refactored the code in fs/exec.c.
> >
> > Since in practice the code is dead remove the binfmt_flat shared libarary
> > support and make maintenance of the code easier.
> >
> > [1] https://lkml.kernel.org/r/81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org
> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > ---
> >
> > Can the binfmt_flat folks please verify that the shared library support
> > really isn't used?
>
> I can definitely confirm I don't use it on m68k. And I don't know of
> anyone that has used it in many years.
>
>
> > Was binfmt_flat being enabled on arm and sh the mistake it looks like?

I think the question was intended to be

    Was *binfmt_flat_shared_flat* being enabled on arm and sh the
    mistake it looks like?

> >
> >   arch/arm/configs/lpc18xx_defconfig |   1 -
> >   arch/arm/configs/mps2_defconfig    |   1 -
> >   arch/arm/configs/stm32_defconfig   |   1 -
> >   arch/arm/configs/vf610m4_defconfig |   1 -
>
> binfmt_flat works on ARM. I use it all the time.
> According to those defconfigs those are all non-MMU systems, so
> having binfmt_flat enabled makes some sense there.
>
>
> >   arch/sh/configs/rsk7201_defconfig  |   1 -
> >   arch/sh/configs/rsk7203_defconfig  |   1 -
> >   arch/sh/configs/se7206_defconfig   |   1 -
>
> Those are all SH2 systems if I am reading the defconfigs correctly.
> SH2 is non-MMU according to the Kconfig setup. So it makes sense that
> binfmt_flat is enabled on those too.

I've checked git history, and CONFIG_BINFMT_SHARED_FLAT was enabled
in se7206_defconfig in a non-specific defconfig update, so no
further info.
The other two had it enabled since their introduction, so I guess
they were just based on the former.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
