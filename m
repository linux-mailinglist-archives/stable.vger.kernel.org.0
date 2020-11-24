Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064A92C303E
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404324AbgKXSyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:54:38 -0500
Received: from condef-04.nifty.com ([202.248.20.69]:39538 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404310AbgKXSyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 13:54:38 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 13:54:36 EST
Received: from conssluserg-02.nifty.com ([10.126.8.81])by condef-04.nifty.com with ESMTP id 0AOIjtZZ006452;
        Wed, 25 Nov 2020 03:45:55 +0900
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 0AOIjaBY023672;
        Wed, 25 Nov 2020 03:45:37 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 0AOIjaBY023672
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1606243537;
        bh=viqmAjpBDNKBM55ep9S4CFsZN2+b8yf9v5jJjKojcF8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rSx0asH0lSiArQDnjFC2er4R/FRVJXeXBlxly1vuVu9fui5fPGG/kAyE2wX6PW9sT
         gM4EneuvPD3LWnj4DkokC5PS6PVKxwckKntEhSkEGoYQEFVPx71JRT0OXVYQDMAQLv
         mY708OC1V7c2cVpAkcwP1X0GRouiz/byAxFQkzh7WPAHOUgEPxt15KcWDPobqicS84
         ZcEC27gV/itbt+IsiCdAnRueqYlLajVgTaXA7b6RXl80gKF9vhafo0HFl3cVxWAVqZ
         j4KO5UvH6BfyM66Hn/W7JGCpwPrDHioIlIkB4TToHEgK88nZMauBUIOqcszMB8ZmjF
         GxJhnnjeL1cdA==
X-Nifty-SrcIP: [209.85.215.178]
Received: by mail-pg1-f178.google.com with SMTP id m9so18262424pgb.4;
        Tue, 24 Nov 2020 10:45:36 -0800 (PST)
X-Gm-Message-State: AOAM532BI3whtecl5nieCjWaHEr+UqzNDw7YWdsTrZoVI9QyAmXEMKL3
        hURzyZ3v1BPgeB9HDR9KZvPfbZvt53IAYaPBk4k=
X-Google-Smtp-Source: ABdhPJyWFLMHlbBBpMhdEZbFshFfUlsJyMu2Mylxe1+GMMQvErCNglWmd2xP8x015lcMyx7mEFIg8a8Xv3fw1R0lZXY=
X-Received: by 2002:a17:90a:5905:: with SMTP id k5mr3606612pji.198.1606243536107;
 Tue, 24 Nov 2020 10:45:36 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOd=9iqLgdtAWe2h-9n=KUWm_rjCCJJYeop8PS6F+AA0VtA@mail.gmail.com>
 <20201109183528.1391885-1-ndesaulniers@google.com> <CAKwvOdnxAr7UdjUiuttj=bz1_voK1qUvpOvSY35qOZ60+E8LBA@mail.gmail.com>
 <CA+SOCLJTg6U+Ddop_5O-baVR42va3vGAvMQ62o9H6rd+10aKrw@mail.gmail.com> <CAKwvOdn0qoa_F-qX10Hu7Cr8eeCjcK23i10zw4fty32u1aBPSw@mail.gmail.com>
In-Reply-To: <CAKwvOdn0qoa_F-qX10Hu7Cr8eeCjcK23i10zw4fty32u1aBPSw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 25 Nov 2020 03:44:58 +0900
X-Gmail-Original-Message-ID: <CAK7LNASatgWjE7MGe-cqU135tKD_Tt31Rouw-HSz6LYrN5hyuw@mail.gmail.com>
Message-ID: <CAK7LNASatgWjE7MGe-cqU135tKD_Tt31Rouw-HSz6LYrN5hyuw@mail.gmail.com>
Subject: Re: [PATCH v3] Kbuild: do not emit debug info for assembly with LLVM_IAS=1
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 3:42 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Hi Masahiro,
> I would appreciate any feedback you have on this patch.
>

Applied to linux-kbuild. Thanks.




> On Fri, Nov 20, 2020 at 3:58 PM Jian Cai <jiancai@google.com> wrote:
> >
> > I also verified that with this patch Chrome OS devices booted with eith=
er GNU assembler or LLVM's integrated assembler. With this patch, IAS no lo=
nger produces extra warnings compared to GNU as on Chrome OS and would remo=
ve the last blocker of enabling IAS on it.
> >
> > Tested-by: Jian Cai <jiancai@google.com> # Compile-tested on mainline (=
with defconfig) and boot-tested on ChromeOS (with olddefconfig).
> >
> >
> > On Mon, Nov 16, 2020 at 3:41 PM 'Nick Desaulniers' via Clang Built Linu=
x <clang-built-linux@googlegroups.com> wrote:
> >>
> >> Hi Masahiro, have you had time to review v3 of this patch?
> >>
> >> On Mon, Nov 9, 2020 at 10:35 AM Nick Desaulniers
> >> <ndesaulniers@google.com> wrote:
> >> >
> >> > Clang's integrated assembler produces the warning for assembly files=
:
> >> >
> >> > warning: DWARF2 only supports one section per compilation unit
> >> >
> >> > If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
> >> > assembly sources (it is still emitted for C sources).  This will be
> >> > re-enabled for newer DWARF versions in a follow up patch.
> >> >
> >> > Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
> >> > LLVM=3D1 LLVM_IAS=3D1 for x86_64 and arm64.
> >> >
> >> > Cc: <stable@vger.kernel.org>
> >> > Link: https://github.com/ClangBuiltLinux/linux/issues/716
> >> > Reported-by: Dmitry Golovin <dima@golovin.in>
> >> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> >> > Suggested-by: Dmitry Golovin <dima@golovin.in>
> >> > Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
> >> > Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> > Reviewed-by: Fangrui Song <maskray@google.com>
> >> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> >> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >> > ---
> >> >  Makefile | 2 ++
> >> >  1 file changed, 2 insertions(+)
> >> >
> >> > diff --git a/Makefile b/Makefile
> >> > index f353886dbf44..7e899d356902 100644
> >> > --- a/Makefile
> >> > +++ b/Makefile
> >> > @@ -826,7 +826,9 @@ else
> >> >  DEBUG_CFLAGS   +=3D -g
> >> >  endif
> >> >
> >> > +ifneq ($(LLVM_IAS),1)
> >> >  KBUILD_AFLAGS  +=3D -Wa,-gdwarf-2
> >> > +endif
> >> >
> >> >  ifdef CONFIG_DEBUG_INFO_DWARF4
> >> >  DEBUG_CFLAGS   +=3D -gdwarf-4
> >> > --
> >> > 2.29.2.222.g5d2a92d10f8-goog
> >> >
> >>
> >>
> >> --
> >> Thanks,
> >> ~Nick Desaulniers
> >>
> >> --
> >> You received this message because you are subscribed to the Google Gro=
ups "Clang Built Linux" group.
> >> To unsubscribe from this group and stop receiving emails from it, send=
 an email to clang-built-linux+unsubscribe@googlegroups.com.
> >> To view this discussion on the web visit https://groups.google.com/d/m=
sgid/clang-built-linux/CAKwvOdnxAr7UdjUiuttj%3Dbz1_voK1qUvpOvSY35qOZ60%2BE8=
LBA%40mail.gmail.com.
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



--=20
Best Regards
Masahiro Yamada
