Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454591D14BD
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgEMN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:26:29 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39456 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387806AbgEMN00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:26:26 -0400
Received: by mail-oi1-f195.google.com with SMTP id b18so21388762oic.6
        for <stable@vger.kernel.org>; Wed, 13 May 2020 06:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aD9/UDkLB2xdnuO57Iyjtykhwk/p1SQgTPV/NpYnxk0=;
        b=INlkgN3G4MsIAVtbe+EdxV24M8Dpim02eOXmTQi/g1dp2PaOOkZCMZ4Mx8o8eWRqZa
         5ogsyABMVxwf6vqA8F8N9Tfg7RxD/XsBbV/aG3vjqNweSGZDL8QTXDvW4xBnO7HQoRjJ
         gY5CzcDPLnUS34QAOqq+GQM6YwOGhoCaKlLX3HUojF4J83fepjevVqIumvegaAtFwRkh
         1RT5HyyyTBqhgFSxJG9txsb6ayUIL4KSaZxKbpk95EGdMDnfbsxUqtDNqvMMpxf11KSF
         RZ4vcwHN7e0aTacZG7iX4lNWgftz7c74f9obtQzAMDID3M2KWbh+bt3lF/loltn7D2SQ
         XvQA==
X-Gm-Message-State: AGi0PuY9BtCTjktnkHGsab5s5ohpCsGTbNOVwcLbfegGXN5gIpURU8CA
        U/qLxbqbRl1WJK9N2PIp0Yo9pzBcb+jmGbB+qtw=
X-Google-Smtp-Source: APiQypJKNhrtblDO6oECx24Y3ou/QsgFL/1MPmEcWEt31R0E9Nxm+x4xw5MRE0rtQ+FJ1NewEsasYIChWgsqCmLuFmY=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr4583614oig.148.1589376385495;
 Wed, 13 May 2020 06:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200423204014.784944-1-lee.jones@linaro.org> <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com> <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com> <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
 <CAMuHMdUJeJaxtOLVfEkJgXw=A7YO93pD2C11wYCDr3VR7mOJ5g@mail.gmail.com> <204deb990a5949428a9d4fba7359eda1@AcuMS.aculab.com>
In-Reply-To: <204deb990a5949428a9d4fba7359eda1@AcuMS.aculab.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 May 2020 15:26:14 +0200
Message-ID: <CAMuHMdUnbDHJSR+rJVq5h9AvBKDNuRnxw9ttXHyRFXYkqV_F+g@mail.gmail.com>
Subject: Re: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
To:     David Laight <David.Laight@aculab.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Wed, May 13, 2020 at 2:37 PM David Laight <David.Laight@aculab.com> wrote:
> From: Geert Uytterhoeven
> > On Wed, May 13, 2020 at 1:05 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, May 13, 2020 at 12:10 PM David Laight <David.Laight@aculab.com> wrote:
> > > > From: Geert Uytterhoeven
> > > > > Sent: 13 May 2020 10:49
> > > > ...
> > > > > > I don't want to apply this to older kernels as it could cause extra
> > > > > > memory usage for no good reason.  I have no idea why a non ARC system
> > > > > > would want it :(
> > > > >
> > > > > I think the reference to ARC is a red herring.
> > > > > The real issue is that buffers used for DMA may not have the required
> > > > > alignment, which is not limited to ARC systems.
> > > > >
> > > > > Note that I'm also not super happy with the extra memory usage.
> > > > > But devm_*() conveniences come with their penalties...
> > > >
> > > > Interesting thought.
> > > > Could the devm 'header' be put right at the end of the kmalloc()
> > > > buffer?
> > > >
> > > > Then the driver would be given aligned address.
> > >
> > > Yes, if the header is extended to contain the real start address of the
> > > allocated block.
> >
> > But that would break explicit freeing through devm_kfree(), as that is
> > passed a pointer to the payload, not the header.
>
> There is a function that gives the full size of memory that kmalloc()
> returns.
> That can be used to find the end and hence the header.

Do you know the name of the function?

> I don't think you can find the base/size from an address within the
> buffer - so a length and/or pointer is needed to find the start.

If that's really possible, then we can finally fix this in a more
ememory-efficient
way.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
