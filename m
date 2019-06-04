Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B2533D99
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 05:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDDpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 23:45:16 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:61764 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDDpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 23:45:16 -0400
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x543j1JO005406;
        Tue, 4 Jun 2019 12:45:02 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x543j1JO005406
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559619902;
        bh=R4DTbEc9ajd/+gLs4R0E3A2qZCd8mpp6nT3mLt/MWL4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sSBx0AvDkKyPdfmLobt1FwXeI8jVeiK59RkpnvzCgW1NxC772shGT0Sxc6PAO3Ks8
         PDpJD75pBEKoT6FtjYqkPmeN7nHHdv/MoXFZ+KkARrl7JX7aMkTjv66C+gvwBFrf1k
         B8WFehagQofx/8TM/rEZq5ZQsCBBOmcPxP90UVmxzfiuyDbP2A1GnZ1/QcxY8pzP35
         peOxnzSOfUkm2Oyv22A6p/BEmKU4ophBttj/ymoil1dI3SwP/qqDWA9vS74RKRv/jT
         /r3Ba2dTESj1A1/ZKgvGfqHlnmrjZUEmgp2ARlAXb79sSmfu3ocxF13RuVLBIBPzcu
         YPiPeujYRKBIg==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id a95so7261755uaa.13;
        Mon, 03 Jun 2019 20:45:01 -0700 (PDT)
X-Gm-Message-State: APjAAAUDLD4J7SDn84VESpww0jFOtVdyaxzxZkz3jlvcuRBawx9H1ufg
        Wa6JAZalYrKRQzhmYB2rT60+g0H5PRFCXvJxdsU=
X-Google-Smtp-Source: APXvYqzVUiWM/RaTvJFgDXA6xyHBfBmK48S0H0UYyNEUSUfOWS5M4whPygR0UYBlA4pDOL7pjG5Ty1EEttHRqBCTSd8=
X-Received: by 2002:a9f:24a3:: with SMTP id 32mr13276265uar.109.1559619900888;
 Mon, 03 Jun 2019 20:45:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
 <3dcacca3f71c46cc98fa64b13a405b59@AcuMS.aculab.com> <CAK7LNATt=P5rHrnK_8PTmjMb+tdtPg2qBgopRUDBFw_fkP2SsQ@mail.gmail.com>
 <1ca8a995328f449fa58f732ebe70e378@AcuMS.aculab.com>
In-Reply-To: <1ca8a995328f449fa58f732ebe70e378@AcuMS.aculab.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 4 Jun 2019 12:44:25 +0900
X-Gmail-Original-Message-ID: <CAK7LNASwTS+rfZuFFcR7cz2HaOZWMjxhZUToV=74g09J72=osg@mail.gmail.com>
Message-ID: <CAK7LNASwTS+rfZuFFcR7cz2HaOZWMjxhZUToV=74g09J72=osg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: use more portable 'command -v' for cc-cross-prefix
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 3, 2019 at 9:43 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Masahiro Yamada
> > Sent: 03 June 2019 12:45
> > On Mon, Jun 3, 2019 at 8:16 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Masahiro Yamada
> > > > Sent: 03 June 2019 11:49
> > > >
> > > > To print the pathname that will be used by shell in the current
> > > > environment, 'command -v' is a standardized way. [1]
> > > >
> > > > 'which' is also often used in scripting, but it is not portable.
> > >
> > > All uses of 'which' should be expunged.
> > > It is a bourne shell script that is trying to emulate a csh builtin.
> > > It is doomed to fail in corner cases.
> > > ISTR it has serious problems with shell functions and aliases.
> >
> > OK, I do not have time to check it treewide.
> > I expect somebody will contribute to it.
> >
> >
> >
> > BTW, I see yet another way to get the command path.
> >
> > 'type -path' is bash-specific.
>
> 'type' itself should be supported by all shells, but the output
> format (esp for errors) probably varies.
>
> > Maybe, we should do this too:
> >
> > diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
> > index 4b1fe09e9042..77829ee4268e 100755
> > --- a/scripts/mkuboot.sh
> > +++ b/scripts/mkuboot.sh
> > @@ -1,14 +1,14 @@
> > -#!/bin/bash
> > +#!/bin/sh
>
> /bin/sh might be 'dash' - which is just plain broken in so many ways.
> Try (IIRC) ${foo%${foo#bar}}
> It might even be the original SYSV /bin/sh which doesn't support $((expr))
> or ${foo#bar} - but that may break too much, but $SHELL might fix it.


We cannot use any tool
if you start to argue like
"Hey, I know ancient implementation that did not work as expected".

Nobody can cover all corner-cases.
That's why we have standard.

I think the reliable source is the
Open Group Specification.

The behavior of /bin/sh is defined here:
http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_01

${parameter%[word]} and ${parameter#[word]} are defined,
so we can use them in /bin/sh scripts.


> dash probably has the rather obscure bug in stripping '\n' from $(...)
> output that I found and fixed in NetBSD's ash may years ago.
> Try: foo="$(jot -b "" 130)"
> All 130 '\n' should be deleted.
> Mostly it fails to delete all the '\n', but it can remove extra ones!
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)



-- 
Best Regards
Masahiro Yamada
