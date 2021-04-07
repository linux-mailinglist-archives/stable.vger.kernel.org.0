Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96351356D6B
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbhDGNip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344667AbhDGNil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 09:38:41 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8231C061756;
        Wed,  7 Apr 2021 06:38:29 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id CF64E92009C; Wed,  7 Apr 2021 15:38:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C89CB92009B;
        Wed,  7 Apr 2021 15:38:26 +0200 (CEST)
Date:   Wed, 7 Apr 2021 15:38:26 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Huacai Chen <chenhuacai@kernel.org>
cc:     Zhou Yanjie <zhouyu@wanyeetech.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        stable <stable@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
In-Reply-To: <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2104071530370.65251@angie.orcam.me.uk>
References: <20210406112404.2671507-1-chenhuacai@loongson.cn> <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com> <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com> <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk>
 <CAAhV-H7V2ykFqCv8n8pYs1ujbUYNy5UqPu21VPyj_Qzx5y8upQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Apr 2021, Huacai Chen wrote:

> >  This code is rather broken in an obvious way, starting from:
> >
> >         unsigned long long __n;                                         \
> >                                                                         \
> >         __high = *__n >> 32;                                            \
> >         __low = __n;                                                    \
> >
> > where `__n' is used uninitialised.  Since this is my code originally I'll
> > look into it; we may want to reinstate `do_div' too, which didn't have to
> > be removed in the first place.
> I think we can reuse the generic do_div().

 We can, but it's not clear to me if this is optimal.  We have a DIVMOD 
instruction which original code took advantage of (although I can see 
potential in reusing bits from include/asm-generic/div64.h).  The two 
implementations would have to be benchmarked against each other across a 
couple of different CPUs.

> >  Huacai, thanks for your investigation!  Please be more careful in
> > verifying your future submissions however.
> Sorry, I thought there is only one bug in div64.h, but in fact there
> are three...

 This just shows the verification you made was not good enough, hence my 
observation.

  Maciej
