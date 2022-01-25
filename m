Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8B49BDBF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 22:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiAYVMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 16:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiAYVMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 16:12:32 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098DEC061747
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 13:12:32 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bu18so59209432lfb.5
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 13:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QBHMQqqDsv17gNXxl/WTw7sK53Gbe5p4grMT+CpfxuA=;
        b=NRnDl2W9wxPF7CVe2JJ+fAauT7YTR09Y1ID4SzEVXVwPXuNpzgEvRf+TiNtF4erkrY
         aSlYBpHWbA+388sdO7OyCZ/sioFYTO9KjClX3+NxUr74kwahu63WftbvpYru0h+Vz9gR
         F2CIGlpNfrAub0+cVeV3GvsRmFaRVUYCIOzJf9njV6+gClmdNmbpqm4COGtXiaiwcaSm
         47tjYnPKaqP3WWi4bWqo9Slp/iZd/2E0ImliGg9cOGpaJSsr9WlAJi7kSWOdk9NfyCg+
         ISprg9MYR+2I3M2pxxuethoe5yHP2F4EMfHxEHXRQhcHOlNwHMjtYZwur9BreFQ7xC6V
         IH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QBHMQqqDsv17gNXxl/WTw7sK53Gbe5p4grMT+CpfxuA=;
        b=BnDAVw3sr/AtMdMpxXLMtZ5EWDVd3oHkU1Nqx57QIHeVrzikFBBV6qB2ukzd4deKko
         QFgrFnfDsJH5Mk1RmOVsU9zIV8GNjSRtjiQf5gksvv+a6CwwOHADA5QpxR5QCtpO1BCY
         JokrT0TQWRJM28lG9WhYZRnC/H/UFadXWZQM9Vbr96sY45QJn3oh9zxYKE8OBpIh7AMp
         Pe5HyBV7D/iPPW/y1REs5iMP5I9t0oOOwWwlw12DBasAdk7qZm8JUBSEFf3+9zWUo7ce
         v+BsgsAi+efXhFUWyFqT1MBji1Be61r0tssW+Y8izYYBFttOzeF4jTTZz+3rmbvjSxxP
         pCwQ==
X-Gm-Message-State: AOAM533QfBWFvVbnYvqi4DqVb1I8REJe7TBQ7DODO9mxN+WwNa/IkInM
        QHhXurpXUJDMXVJo/TX4Uybol7+Dc0nbEfFXM+qkNQ==
X-Google-Smtp-Source: ABdhPJxf4IoCqJVpsjwC8R5W4hvCt6d1EmV3r4e5Vb2hjAeXpCUkegw1gZicOFVShGFxqDnuZuW/zthc07e9aw20FQ0=
X-Received: by 2002:a05:6512:3b95:: with SMTP id g21mr13750288lfv.651.1643145150217;
 Tue, 25 Jan 2022 13:12:30 -0800 (PST)
MIME-Version: 1.0
References: <20220120133739.4170298-1-alexander.sverdlin@gmail.com> <YfBm/xBJLDtU/fo5@google.com>
In-Reply-To: <YfBm/xBJLDtU/fo5@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 25 Jan 2022 13:12:17 -0800
Message-ID: <CAKwvOdno9jyF4Kmy3ygHANZCsqygQk0gW32Mc59j0Xe16rv6=w@mail.gmail.com>
Subject: Re: [PATCH] ep93xx: clock: Fix UAF in ep93xx_clk_register_gate()
To:     Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@armlinux.org.uk>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 1:10 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Jan 20, 2022 at 02:37:38PM +0100, Alexander Sverdlin wrote:

Also, consider adding the first line of the warning to your commit
message, please:
arch/arm/mach-ep93xx/clock.c:154:2: warning: Use of memory after it is
freed [clang-analyzer-unix.Malloc]

> > arch/arm/mach-ep93xx/clock.c:151:2: note: Taking true branch
> > if (IS_ERR(clk))
> > ^
> > arch/arm/mach-ep93xx/clock.c:152:3: note: Memory is released
> > kfree(psc);
> > ^~~~~~~~~~
> > arch/arm/mach-ep93xx/clock.c:154:2: note: Use of memory after it is freed
> > return &psc->hw;
> > ^ ~~~~~~~~
> >
> > Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/B5YCO2NJEXINCYE26Y255LCVMO55BGWW/
> > Reported-by: kernel test robot <lkp@intel.com>
> > Fixes: 9645ccc7bd7a ("ep93xx: clock: convert in-place to COMMON_CLK")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
> > ---
> >  arch/arm/mach-ep93xx/clock.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
> > index cc75087134d3..4aee14f18123 100644
> > --- a/arch/arm/mach-ep93xx/clock.c
> > +++ b/arch/arm/mach-ep93xx/clock.c
> > @@ -148,8 +148,10 @@ static struct clk_hw *ep93xx_clk_register_gate(const char *name,
> >       psc->lock = &clk_lock;
> >
> >       clk = clk_register(NULL, &psc->hw);
> > -     if (IS_ERR(clk))
> > +     if (IS_ERR(clk)) {
> >               kfree(psc);
> > +             return (void *)clk;
>
> Prefer ERR_CAST to the raw cast. I think that's nicer when we're already
> using the IS_ERR macros.
>
> > +     }
> >
> >       return &psc->hw;
> >  }
> > --
> > 2.34.1
> >



-- 
Thanks,
~Nick Desaulniers
