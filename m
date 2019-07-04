Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B85F7B7
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfGDMKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 08:10:34 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37707 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGDMKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 08:10:34 -0400
Received: by mail-ot1-f67.google.com with SMTP id s20so5763790otp.4;
        Thu, 04 Jul 2019 05:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7m+O+up5FGnrJOrM1NTZjuCCOYBaAlc+EU+VST+P0o=;
        b=ic3Tirp2LhDgUc3OVqfrOg+5Ad4v+eg6vpA/WUjQem3aHFjvnEj6nFiTJQ9AGN8S2s
         +2Zd8/jw9Ch3ItvXWZhtx3ovKkNDLb1j2Zc9cxQclyUrick2xW+CBV/ffJ6BLOQdToaf
         IR4ZNS+JbRks6TP47th7GbdxmAvHD7gXAPCVrBzAgoQmMXb8penX0u2NXGUC8TUTkMd5
         /pVXMH2zaZEg77vHw0xMK+vlDfu4V9kcd1Z+3oA/1Vlrurm2D+mFNEnpXYItVe/NvGX7
         KY5sVniiP+27Jr1HzzgnVwqpHLrVNhDNiixNYv7gylWTFJDdHlTEMQwaDttS1sB/7l78
         cytg==
X-Gm-Message-State: APjAAAUg+bLQ1KFXy3eOO4OjPbe0VEheeuP1kPacWDasepl0AessRVmr
        dZYH/l0phaA2O4htFf7h/A/0DgYEF8hemdXiRRs=
X-Google-Smtp-Source: APXvYqwYVnlGQV7NAmK+2d/0Yyxu0t2VshoBe2404yndi+GEtMIgW92/ip8BqYBix9Pi1jCPsHVu+iyF3JLrAsJ2CFk=
X-Received: by 2002:a9d:704f:: with SMTP id x15mr13127896otj.297.1562242233106;
 Thu, 04 Jul 2019 05:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190704113800.3299636-1-arnd@arndb.de> <20190704120756.GA1582@kunai>
In-Reply-To: <20190704120756.GA1582@kunai>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Jul 2019 14:10:22 +0200
Message-ID: <CAMuHMdXDN60WWFerok1h05COdNNPZTMDCgKXejmQZMj9B6y5Cw@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Marek Vasut <marek.vasut@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wolfram,

On Thu, Jul 4, 2019 at 2:08 PM Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Jul 04, 2019 at 01:37:47PM +0200, Arnd Bergmann wrote:
> > gcc-9 complains about a blatant uninitialized variable use that
> > all earlier compiler versions missed:
> >
> > drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >
> > Return -EINVAL instead here.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This is correct but missing that the above 'return ret' is broken, too.
> ret is initialized but 0 in that case.

Nice catch! Oh well, given enough eyeballs, ...

> And maybe we can use something else than -EINVAL for this case? I am on
> the go right now, I will look for a suggestion later.

-EINVAL is correct here (and in the above case, too), IMHO.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
