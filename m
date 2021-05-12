Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5273C37EDC2
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhELUqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:46:32 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33044 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387729AbhELUkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:40:01 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 16:39:52 EDT
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id A0F5392009C; Wed, 12 May 2021 22:38:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 92EAA92009B;
        Wed, 12 May 2021 22:38:24 +0200 (CEST)
Date:   Wed, 12 May 2021 22:38:24 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
In-Reply-To: <CAHk-=wj8jOJtKpw-Jsd043sjdL=rPnOD8uD8Tf84_Q36iu_ewQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2105122224240.3032@angie.orcam.me.uk>
References: <20210512144837.204217980@linuxfoundation.org> <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com> <YJwW2bNXGZw5kmpo@kroah.com> <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
 <CAHk-=wj8jOJtKpw-Jsd043sjdL=rPnOD8uD8Tf84_Q36iu_ewQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021, Linus Torvalds wrote:

> Note that this might just be a random effect of inlining or other
> register allocation pressure details.
> 
> So it's possible that upstream builds mostly by luck.
> 
> The "couldn't allocate output register" thing really does seem more
> like a compiler issue than a kernel source code issue.

 Nope, `x' is the constraint for the multiply-divide unit/MDU accumulator 
register used for calculation output; there's only one, comprised of the 
HI and LO parts.  This register was removed as from the MIPSr6 ISA, which 
I forgot that we support (unlike the microMIPSr6 ISA), in favour to using 
regular GPRs, in a slightly different manner.

 Rather than cluttering code with #ifdefs for the updated MIPSr6 divide 
and modulo instructions I chose to rewrite this piece in plain C, which 
actually makes pre-MIPSr6 code slightly better owing to better instruction 
scheduling (the pre-MIPSr6 MDU runs asynchronously and its output is only 
interlocked on read access to the accumulator register).

 NB I don't know if Clang actually supports the `x' constraint even with 
pre-MIPSr6 code; as it has turned out it has deficiencies compared to GCC 
with inline asm handling with the MIPS target.  OTOH GCC has supported it 
since ~1991 if memory serves me, when MIPS support was initially added.

  Maciej
