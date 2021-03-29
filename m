Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951DF34CD14
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhC2Jap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 05:30:45 -0400
Received: from elvis.franken.de ([193.175.24.41]:33861 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhC2Ja1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 05:30:27 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lQoE1-0003qb-00; Mon, 29 Mar 2021 11:30:21 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 183E3C0AFD; Mon, 29 Mar 2021 11:00:58 +0200 (CEST)
Date:   Mon, 29 Mar 2021 11:00:58 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     YunQiang Su <wzssyqa@gmail.com>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
Message-ID: <20210329090058.GA6564@alpha.franken.de>
References: <20210322015902.18451-1-yunqiang.su@cipunited.com>
 <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 01:09:18PM +0800, YunQiang Su wrote:
> YunQiang Su <yunqiang.su@cipunited.com> 于2021年3月22日周一 上午10:00写道：
> >
> > The MIPS FPU may have 3 mode:
> >   FR=0: MIPS I style, all of the FPR are single.
> >   FR=1: all 32 FPR can be double.
> >   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.
> >
> > The binary may have 3 mode:
> >   FP32: can only work with FR=0 and FRE mode
> >   FPXX: can work with all of FR=0/FR=1/FRE mode.
> >   FP64: can only work with FR=1 mode
> >
> > Some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are FP32. It is caused by the bug of design and linker:
> >   Object produced by pure Go has no FP annotation while in fact they are FP32;
> >   if we link them with the C module which marked as FPXX,
> >   the result will be marked as FPXX. If these fake-FPXX binaries is executed
> >   in FR=1 mode, some problem will happen.
> >
> > In Golang, now we add the FP32 annotation, so the future golang programs
> > won't have this problem. While for the existing binaries, we need a
> > kernel workaround.
> >
> 
> We meet a new problem in Debian: with the O32_FP64 enabled kernel,
> mips64el may also be affected.
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983583

hmm, raising this issue in this context before knowing more details,
feels very trigger happy to me and this doesn't help accepting anything,
jfyi...

Could you please provide a link for downloading a golang binary, which
would need this patch to run ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
