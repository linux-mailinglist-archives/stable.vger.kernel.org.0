Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4483E87A6
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 03:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhHKBZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 21:25:25 -0400
Received: from condef-10.nifty.com ([202.248.20.75]:30577 "EHLO
        condef-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhHKBZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 21:25:25 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 21:25:24 EDT
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-10.nifty.com with ESMTP id 17B1GVXw008288
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 10:16:31 +0900
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 17B1G1VR027666;
        Wed, 11 Aug 2021 10:16:01 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 17B1G1VR027666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1628644562;
        bh=8bL++FzbW+iwNZKOVMvOV5/xAfw+q27dBcGVL5F8KxU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WjZB/wsL77swPlcH8l+3YvModdYjPdXkYdgDa4qtNqYPoG0/xZUric2OVi6/S/POT
         jokcqcigGTCyDdKxDTqv7HRNpI+phvGk3xRqITncb46o+YrHjLe1iazvpLVuUnHTSA
         DOBL+119owoG6hmuSDbtbOZHepgIK7nkP2vZCBAhNutDK4ivHDls8AJISrpGa3JjJf
         oEl8qkXhOkkaBViHl3PY2eaYchS5KlIRxnjyy4KSUucuqMbnyW+3ciuIAu7rpsJwtk
         UOBuafcvx4JwoXEfXTr8zqVga4alcL9YXlk9ONY2IxYCG3IYn5Y2JB3NFZUtQzbYGc
         6EsrDDLLDqM+w==
X-Nifty-SrcIP: [209.85.216.41]
Received: by mail-pj1-f41.google.com with SMTP id a8so825065pjk.4;
        Tue, 10 Aug 2021 18:16:01 -0700 (PDT)
X-Gm-Message-State: AOAM533VRaj4X7YOu9sgSTMVGSwwUSzDNQzRzdrpbP9ahmLPca+wHq+q
        2c6fha1hjy8PHnkwffrvHSoPf3XzTaLzN9loT6Y=
X-Google-Smtp-Source: ABdhPJyEmVV4nbI+CmPMlJIetQI+oOnkGVahZBRS5N4nCm7rxyIj7gTyFwW8oZbB0fN+CZ1F8TI45dlX3+xwBiyd4Ms=
X-Received: by 2002:a63:a58:: with SMTP id z24mr437441pgk.175.1628644560976;
 Tue, 10 Aug 2021 18:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210809191414.3572827-1-adelg@google.com> <20210810135236.GA3101@willie-the-truck>
In-Reply-To: <20210810135236.GA3101@willie-the-truck>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 11 Aug 2021 10:15:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR2Wxvujh5USqWsrTMfupKeKhb0zzbP+SDOY6McR3O25A@mail.gmail.com>
Message-ID: <CAK7LNAR2Wxvujh5USqWsrTMfupKeKhb0zzbP+SDOY6McR3O25A@mail.gmail.com>
Subject: Re: [PATCH] arm64: clean vdso files
To:     Will Deacon <will@kernel.org>
Cc:     Andrew Delgadillo <adelg@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 10:52 PM Will Deacon <will@kernel.org> wrote:
>
> [+Masahiro]
>
> On Mon, Aug 09, 2021 at 07:14:14PM +0000, Andrew Delgadillo wrote:
> > commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
> > changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
> > vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':
> >
> > $ make defconfig ARCH=arm64
> > $ make ARCH=arm64
> > $ make mrproper ARCH=arm64
> > $ git clean -nxdf
> > Would remove arch/arm64/kernel/vdso/vdso.lds
> > Would remove arch/arm64/kernel/vdso/vdso.so
> > Would remove arch/arm64/kernel/vdso/vdso.so.dbg
> >
> > To remedy this, manually descend into arch/arm64/kernel/vdso upon
> > cleaning.
> >
> > After this commit:
> > $ make defconfig ARCH=arm64
> > $ make ARCH=arm64
> > $ make mrproper ARCH=arm64
> > $ git clean -nxdf
> > <empty>
>
> Well spotted!



Ah, I missed this. Sorry.

Yes, please do this for vdso,
and vdso32 as well.





> > Signed-off-by: Andrew Delgadillo <adelg@google.com>
> > ---
> >  arch/arm64/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> > index b52481f0605d..ef6598cb5a9b 100644
> > --- a/arch/arm64/Makefile
> > +++ b/arch/arm64/Makefile
> > @@ -181,6 +181,7 @@ archprepare:
> >  # We use MRPROPER_FILES and CLEAN_FILES now
> >  archclean:
> >       $(Q)$(MAKE) $(clean)=$(boot)
> > +     $(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso
>
> I think we also need to clean the vdso32 directory here. Please can you
> send a v2 with that added?
>
> Cheers,
>
> Will



-- 
Best Regards
Masahiro Yamada
