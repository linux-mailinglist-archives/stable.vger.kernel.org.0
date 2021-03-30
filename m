Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9257A34E788
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 14:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhC3MfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 08:35:03 -0400
Received: from elvis.franken.de ([193.175.24.41]:37610 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhC3Meb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 08:34:31 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lRDZl-0003nX-00; Tue, 30 Mar 2021 14:34:29 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 64DA4C1D90; Tue, 30 Mar 2021 14:24:37 +0200 (CEST)
Date:   Tue, 30 Mar 2021 14:24:37 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     YunQiang Su <wzssyqa@gmail.com>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
Message-ID: <20210330122437.GA10355@alpha.franken.de>
References: <20210322015902.18451-1-yunqiang.su@cipunited.com>
 <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
 <20210329090058.GA6564@alpha.franken.de>
 <CAKcpw6Vd6pCT2PB4pZATnEq8Y4pSj4cwNFZgg6yK6VjoeY+N-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKcpw6Vd6pCT2PB4pZATnEq8Y4pSj4cwNFZgg6yK6VjoeY+N-Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 06:28:40PM +0800, YunQiang Su wrote:
> Thomas Bogendoerfer <tsbogend@alpha.franken.de> 于2021年3月29日周一 下午5:30写道：
> >
> > On Mon, Mar 29, 2021 at 01:09:18PM +0800, YunQiang Su wrote:
> > > YunQiang Su <yunqiang.su@cipunited.com> 于2021年3月22日周一 上午10:00写道：
> > > >
> > > > The MIPS FPU may have 3 mode:
> > > >   FR=0: MIPS I style, all of the FPR are single.
> > > >   FR=1: all 32 FPR can be double.
> > > >   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.
> > > >
> > > > The binary may have 3 mode:
> > > >   FP32: can only work with FR=0 and FRE mode
> > > >   FPXX: can work with all of FR=0/FR=1/FRE mode.
> > > >   FP64: can only work with FR=1 mode
> > > >
> > > > Some binary, for example the output of golang, may be mark as FPXX,
> > > > while in fact they are FP32. It is caused by the bug of design and linker:
> > > >   Object produced by pure Go has no FP annotation while in fact they are FP32;
> > > >   if we link them with the C module which marked as FPXX,
> > > >   the result will be marked as FPXX. If these fake-FPXX binaries is executed
> > > >   in FR=1 mode, some problem will happen.
> > > >
> > > > In Golang, now we add the FP32 annotation, so the future golang programs
> > > > won't have this problem. While for the existing binaries, we need a
> > > > kernel workaround.
> > > >
> > >
> > > We meet a new problem in Debian: with the O32_FP64 enabled kernel,
> > > mips64el may also be affected.
> > > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983583
> >
> > hmm, raising this issue in this context before knowing more details,
> > feels very trigger happy to me and this doesn't help accepting anything,
> > jfyi...
> >
> > Could you please provide a link for downloading a golang binary, which
> > would need this patch to run ?
> >
> 
> For rootfs, you can download
>    http://58.246.137.130:20180/debian-from/rootfs/buster-mipsel.tar.xz
> or create by:
>     sudo debootstrap --arch mipsel  --include golang-1.11-go \
>                      buster buster-mipsel http://deb.debian.org/debian
> 
> For binary packages, you can download:
>     https://packages.debian.org/buster/mipsel/golang-1.11-go/download
> 
> just chroot the rootfs and run:
>     /usr/lib/go-1.11/bin/go
> It will crash if kernel's O32_FP64 option is enabled.

now I'm confused. Do go binaries crash the kernel ? Or is this just
the issue _not_ related to this patch ?

I want a single go binary, which I can inspect about the FPXX thing and
see how easy it would be to just patch the binary and make it run without
this patch.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
