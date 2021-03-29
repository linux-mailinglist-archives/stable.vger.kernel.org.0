Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E3634CC2C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhC2I4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbhC2Izp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 04:55:45 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8413AC061574;
        Mon, 29 Mar 2021 01:55:43 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id g8so6089706qvx.1;
        Mon, 29 Mar 2021 01:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=crQ+ALozflpkN/wN8qWILdpBkrCoIGN+fzVrhzyu8tU=;
        b=AHMBWu5yZZ2qsOKpXR0G3k1VMdIUwGARdU6tGLAltmve1Q7wrhtMW1ipLr9M+LHeJI
         E5e+aresuDDNDuj7paj+x9ScTlwP0SXkL5gRUHGybBrEYa6quxTMj29c76mpzYdLGdw7
         Vk2SmYUqaruhdjKGegI/uxQmF+LTMW/IRsXzBRVGBWvnTRssOxgbR6CIX95xKThiQwLx
         tulkq53Y9NYP+O4y/LcPnybDwPD2qqB2kaF0QdzZAtUJ0KlvyfYaSsKoWUEmpHZWl9S7
         DCiIiLALTGYafaN/CmdAF5OWm/bMalELHDGKQlEjb0USPyugH2r7kWXPZFuUtnEqmCIk
         aKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=crQ+ALozflpkN/wN8qWILdpBkrCoIGN+fzVrhzyu8tU=;
        b=ZbJgdQEf7wYkG59pgrJjjBHowsR6rZmPwYSCqBf9b3tXreSnA2mSdxp/7HniwiKHq6
         BLB8s+JGD+VBNBnd4zokMKTzQTe7SgT94IIfUJ7tWqZnBlttUdf/feOIsnsuU6BdgX5+
         4LZfSrcWO/GzQgRCSTDunwkOpZhrcsPXbBI8DuHPFntO6h5zunriRbOFYeSId7QhYIMt
         1vOCMHfVz92LSRKuHlU/4ANxDcTyJNpxQkLFvFYz9758KWKrp0Ue8+kcDHsa/hQWjyKQ
         /GBqc/yWVHBkZIGYSRuLVjUtqioWfdehL8JPEa1QgvxxuJS/9pFxKj9Gh1WwevcVe+cM
         Lz3Q==
X-Gm-Message-State: AOAM530oOV7/buoeeWAkYezlu95fYfU+dSwy+ssfe0LG8+PWvZ//Pwhh
        AH8cq0cu2cE+1bQzUTEbtrX1TN2V6s9LCMJratV/CvzkSYSzKQ==
X-Google-Smtp-Source: ABdhPJzosR8108dXi5CPtge45m+CtRDodq1YubFStlhd0zQhobIoY+ZFqb0U/+AKvaW3w7N4Wp0bjapcxEJmlF51MFQ=
X-Received: by 2002:a0c:e2cd:: with SMTP id t13mr24263030qvl.44.1617008142817;
 Mon, 29 Mar 2021 01:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210322015902.18451-1-yunqiang.su@cipunited.com> <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
In-Reply-To: <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Mon, 29 Mar 2021 16:55:33 +0800
Message-ID: <CAKcpw6WbnCFat=ixoAm18bBqfjAsyPsjbaYiTK7rudwvKw5k1Q@mail.gmail.com>
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

YunQiang Su <wzssyqa@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8829=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=881:09=E5=86=99=E9=81=93=EF=BC=9A
>
> YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=882=
2=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8810:00=E5=86=99=E9=81=93=EF=
=BC=9A
> >
> > The MIPS FPU may have 3 mode:
> >   FR=3D0: MIPS I style, all of the FPR are single.
> >   FR=3D1: all 32 FPR can be double.
> >   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double =
FPR.
> >
> > The binary may have 3 mode:
> >   FP32: can only work with FR=3D0 and FRE mode
> >   FPXX: can work with all of FR=3D0/FR=3D1/FRE mode.
> >   FP64: can only work with FR=3D1 mode
> >
> > Some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are FP32. It is caused by the bug of design and link=
er:
> >   Object produced by pure Go has no FP annotation while in fact they ar=
e FP32;
> >   if we link them with the C module which marked as FPXX,
> >   the result will be marked as FPXX. If these fake-FPXX binaries is exe=
cuted
> >   in FR=3D1 mode, some problem will happen.
> >
> > In Golang, now we add the FP32 annotation, so the future golang program=
s
> > won't have this problem. While for the existing binaries, we need a
> > kernel workaround.
> >
>
> We meet a new problem in Debian: with the O32_FP64 enabled kernel,
> mips64el may also be affected.
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D983583
>

Sorry, it is not about O32_FP64, it is about memory segment.
Loongson 3A2000+ supports RI/XI, which stop the access of some memory regio=
n.

The problem is about Go itself: why it map the datafile writeonly.

>
>
> > Currently, FR=3D1 mode is used for all FPXX binary if O32_FP64 supporte=
d is enabled,
> > it makes some wrong behivour of the binaries.
> > Since FPXX binary can work with both FR=3D1 and FR=3D0, we force it to =
use FR=3D0.
> >
> > Reference:
> >
> > https://web.archive.org/web/20180828210612/https://dmz-portal.mips.com/=
wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking
> >
> > https://go-review.googlesource.com/c/go/+/239217
> > https://go-review.googlesource.com/c/go/+/237058
> >
> > Signed-off-by: YunQiang Su <yunqiang.su@cipunited.com>
> > Cc: stable@vger.kernel.org # 4.19+
> > ---
> > v7->v8->v9:
> >         Rollback to use FR=3D1 for FPXX on R6 CPU.
> >
> > v6->v7:
> >         Use FRE mode for pre-R6 binaries on R6 CPU.
> >
> > v5->v6:
> >         Rollback to V3, aka remove config option.
> >
> > v4->v5:
> >         Fix CONFIG_MIPS_O32_FPXX_USE_FR0 usage: if -> ifdef
> >
> > v3->v4:
> >         introduce a config option: CONFIG_MIPS_O32_FPXX_USE_FR0
> >
> > v2->v3:
> >         commit message: add Signed-off-by and Cc to stable.
> >
> > v1->v2:
> >         Fix bad commit message: in fact, we are switching to FR=3D0
> >
> >
> >  arch/mips/kernel/elf.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
> > index 7b045d2a0b51..554561d5c1f8 100644
> > --- a/arch/mips/kernel/elf.c
> > +++ b/arch/mips/kernel/elf.c
> > @@ -232,11 +232,16 @@ int arch_check_elf(void *_ehdr, bool has_interpre=
ter, void *_interp_ehdr,
> >          *   that inherently require the hybrid FP mode.
> >          * - If FR1 and FRDEFAULT is true, that means we hit the any-ab=
i or
> >          *   fpxx case. This is because, in any-ABI (or no-ABI) we have=
 no FPU
> > -        *   instructions so we don't care about the mode. We will simp=
ly use
> > -        *   the one preferred by the hardware. In fpxx case, that ABI =
can
> > -        *   handle both FR=3D1 and FR=3D0, so, again, we simply choose=
 the one
> > -        *   preferred by the hardware. Next, if we only use single-pre=
cision
> > -        *   FPU instructions, and the default ABI FPU mode is not good
> > +        *   instructions so we don't care about the mode.
> > +        *   In fpxx case, that ABI can handle all of FR=3D1/FR=3D0/FRE=
 mode.
> > +        *   Here, we need to use FR=3D0 mode instead of FR=3D1, becaus=
e some binaries
> > +        *   may be mark as FPXX by mistake due to bugs of design and l=
inker:
> > +        *      The object produced by pure Go has no FP annotation,
> > +        *      then is treated as any-ABI by linker, although in fact =
they are FP32;
> > +        *      if any-ABI object is linked with FPXX object, the resul=
t will be mark as FPXX.
> > +        *      Then the problem happens: run FP32 binaries in FR=3D1 m=
ode.
> > +        * - If we only use single-precision FPU instructions,
> > +        *   and the default ABI FPU mode is not good
> >          *   (ie single + any ABI combination), we set again the FPU mo=
de to the
> >          *   one is preferred by the hardware. Next, if we know that th=
e code
> >          *   will only use single-precision instructions, shown by sing=
le being
> > @@ -248,8 +253,9 @@ int arch_check_elf(void *_ehdr, bool has_interprete=
r, void *_interp_ehdr,
> >          */
> >         if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1)
> >                 state->overall_fp_mode =3D FP_FRE;
> > -       else if ((prog_req.fr1 && prog_req.frdefault) ||
> > -                (prog_req.single && !prog_req.frdefault))
> > +       else if (prog_req.fr1 && prog_req.frdefault)
> > +               state->overall_fp_mode =3D cpu_has_mips_r6 ? FP_FR1 : F=
P_FR0;
> > +       else if (prog_req.single && !prog_req.frdefault)
> >                 /* Make sure 64-bit MIPS III/IV/64R1 will not pick FR1 =
*/
> >                 state->overall_fp_mode =3D ((raw_current_cpu_data.fpu_i=
d & MIPS_FPIR_F64) &&
> >                                           cpu_has_mips_r2_r6) ?
> > --
> > 2.20.1
> >
>
>
> --
> YunQiang Su



--=20
YunQiang Su
