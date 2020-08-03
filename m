Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F352523AE34
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 22:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgHCUeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 16:34:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38691 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgHCUeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 16:34:11 -0400
Received: by mail-ot1-f68.google.com with SMTP id q9so13267395oth.5;
        Mon, 03 Aug 2020 13:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjA7iT6k7T3UICRKqIEcmmELA9u5uRqayG52kES09s0=;
        b=PrPjXx4JBBbSMLlxvA202YHfSm5xoqGoLG4a/EXNBkM7UOGpA7pscjAF+h9oYmW0xW
         WCC4WWDJBt+pYtpcz0nSONHLObIkWhiHNpO+NT7GXnHf806Ls2nPGM4UUI001VTwd2Zi
         B8kC97ULEnuMc+Sk8Pf7qQ+mrbElxUI30ijzspSH5TVd0zrJ/lDpzucZWYa2QG9aNBMT
         e7OUtJ8C7VrkQ1eB06QT38uuJlIxlwZRPOfqh/PcXlffjPxdmPQR2gSZcoawxUUrberG
         84jTq+li84jJQ7QMedMup9FGeHkOLedooRHJ118QVUSIajhzbUKvlBPVIZ/vw8BfcvUc
         KXHw==
X-Gm-Message-State: AOAM531i204rHPk58MwmEbiOP1FNAuy3c/l86/6fuLSs52sBuUx3tlSs
        JKsViQmRwlCens/tfFIrzGywsbeSsiEqSS0QC3BveA==
X-Google-Smtp-Source: ABdhPJygp/6Y+Xp19D2UVJnG0yqVw6bti301myD5f15br10CxzwiyLNIBgbLDG5iBZREPkPdHaJztQr7BIU2Exoe/tA=
X-Received: by 2002:a9d:1b0d:: with SMTP id l13mr14657662otl.145.1596486850954;
 Mon, 03 Aug 2020 13:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200803121902.860751811@linuxfoundation.org> <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
In-Reply-To: <20200803173330.GA1186998@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 3 Aug 2020 22:33:59 +0200
Message-ID: <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 3, 2020 at 7:35 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Aug 03, 2020 at 08:58:20AM -0700, Guenter Roeck wrote:
> > On Mon, Aug 03, 2020 at 02:17:38PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.7.13 release.  There
> > > are 120 patches in this series, all will be posted as a response to this one.
> > > If anyone has any issues with these being applied, please let me know.
> > >
> > > Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.  Anything
> > > received after that time might be too late.
> > >
> >
> > Building sparc64:allmodconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > In file included from arch/sparc/include/asm/percpu_64.h:11,
> >                  from arch/sparc/include/asm/percpu.h:5,
> >                  from include/linux/random.h:14,
> >                  from fs/crypto/policy.c:13:
> > arch/sparc/include/asm/trap_block.h:54:39: error: 'NR_CPUS' undeclared here (not in a function)
> >    54 | extern struct trap_per_cpu trap_block[NR_CPUS];
> >
> > Inherited from mainline. Builds are not complete yet;
> > we may see a few more failures (powerpc:ppc64e_defconfig
> > fails to build in mainline as well).
>
> If it gets fixed upstream, I'll fix it here :)

And else you'll release a known-broken v5.7.13?

Perhaps backporting should be a bit less aggressive?
This breakage was introduced in between v5.8-rc7 and v5.8, and backported
before people had the time to properly look into the v5.8 build bot logs.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
