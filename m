Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68BF1D1095
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgEMLHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 07:07:00 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39299 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgEMLG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 07:06:59 -0400
Received: by mail-oi1-f196.google.com with SMTP id b18so21053563oic.6
        for <stable@vger.kernel.org>; Wed, 13 May 2020 04:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/YI8QIsCC+wCEqbtiuRDP6J+09+8ht8LizjaQ11KPeM=;
        b=rI/PfUVBBJl0nej7SsZmgCRGFqQLLt5EHi1oD6qC5tyMkCD5qjkzH3xOFl4L4HzTyA
         ycpUkEIt1hs43Ws2VoiBvNFWw4+MzTSudosK3dUSKt+l65T8y8jFds5q8gg6Nx7OQtmj
         plll9O8k5Np7hS/QFDUvO7aYFHNjlPo6Qi4o+iQ9SLrDqg/kaqXgkEHn7wqji/U62ifh
         1IOzc6A77v7rufsSk5o44miH1UDFL8ymw0OemEns7Vpy1Tm5ZiiEscFgtmga8XA9yDJh
         dqbTLdCtk02LH3zJ9e8UV6rjNZtXXrvnQDC7hWxTsiS0F3ROtImsAMjDvrxOYwEFme9V
         4ifA==
X-Gm-Message-State: AGi0PubxJs+QtKh+kQZPa2YYIFDQ7LWK0VoyBORWvh0OYNehozX3Rz5P
        Vg17qil205JIFXL11HO2ZJEWkR/ya06l7mUxuMY=
X-Google-Smtp-Source: APiQypKZEGKaDrK/rZHRQnBKufw6HomNEBZUGRvzcnEF1tnXR5abqlyad+CmN85cBpN3fWKPbx3aSqmgVvKPxztWGts=
X-Received: by 2002:aca:d50f:: with SMTP id m15mr26807240oig.54.1589368018272;
 Wed, 13 May 2020 04:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200423204014.784944-1-lee.jones@linaro.org> <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com> <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com> <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 May 2020 13:06:46 +0200
Message-ID: <CAMuHMdUJeJaxtOLVfEkJgXw=A7YO93pD2C11wYCDr3VR7mOJ5g@mail.gmail.com>
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

On Wed, May 13, 2020 at 1:05 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, May 13, 2020 at 12:10 PM David Laight <David.Laight@aculab.com> wrote:
> > From: Geert Uytterhoeven
> > > Sent: 13 May 2020 10:49
> > ...
> > > > I don't want to apply this to older kernels as it could cause extra
> > > > memory usage for no good reason.  I have no idea why a non ARC system
> > > > would want it :(
> > >
> > > I think the reference to ARC is a red herring.
> > > The real issue is that buffers used for DMA may not have the required
> > > alignment, which is not limited to ARC systems.
> > >
> > > Note that I'm also not super happy with the extra memory usage.
> > > But devm_*() conveniences come with their penalties...
> >
> > Interesting thought.
> > Could the devm 'header' be put right at the end of the kmalloc()
> > buffer?
> >
> > Then the driver would be given aligned address.
>
> Yes, if the header is extended to contain the real start address of the
> allocated block.

But that would break explicit freeing through devm_kfree(), as that is
passed a pointer to the payload, not the header.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
