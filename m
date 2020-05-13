Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1861D0CF6
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733147AbgEMJsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:55 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44584 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733142AbgEMJsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:48:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id a2so20691588oia.11
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fr/hy8F1vxP95AbuYdAfrvnascV7pBsA9t1Mh9K1dKU=;
        b=icO7XEBavTeloiX+21ejGMh0cOKe+19OZB5Z5F/Zm85V5IX4BZor2I8vnwizJEr9ar
         G7P5SpmLJDnIolt61uUl1ksembBxqMXrJe96elwhedGZPuhAUfIzO58Zcx54SmtP/svE
         3htWsBc8JQLbCEeL5k1jmLSUmv1skUZO6MGF73qE9e5ZqWwxh6zb8rIH5NMf3UM8q6Qe
         YEaETYbvBUicNCUsh2PBr0b+qvNQ9evkqNvneUsscuo1wBj/gQ/q+WG5SDSjgYkcEIOR
         y+TOIiWg+/XP4O8uD/mchkI/7AaqPYFEzQyJl1F3WYBcwH5EyDOdiXQ1BNZKF9VK74yj
         WUUA==
X-Gm-Message-State: AGi0PuaJQoUD3wpEsQz1mLmEnp4C6h1QgL1IZpyAXiO0zgBP7h3Px05Q
        nZWGZCERs+8Emcetr8tLqUXsJK5Z3shmVOpNUpg=
X-Google-Smtp-Source: APiQypJXNJUD6gHbOFzjjTyouS+H1NbLqxkhcP4LJ1f8IlIXwsGga4gZKHnraarnoddknIM2jBdwu+OHmwapaoEUx4k=
X-Received: by 2002:aca:895:: with SMTP id 143mr25512062oii.153.1589363333369;
 Wed, 13 May 2020 02:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200423204014.784944-1-lee.jones@linaro.org> <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
In-Reply-To: <20200513093536.GB830571@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 May 2020 11:48:42 +0200
Message-ID: <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
Subject: Re: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>, stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 13, 2020 at 11:35 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 23, 2020 at 09:40:01PM +0100, Lee Jones wrote:
> > From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> >
> > [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> >
> > Initially we bumped into problem with 32-bit aligned atomic64_t
> > on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> > mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> > If allocation is done by plain kmalloc() obtained buffer will be
> > ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> > devm_kmalloc() should have any other alignment?
> >
> > This way we at least get the same behavior for both types of
> > allocation.
> >
> > [1] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004009.html
> > [2] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004036.html
> >
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: <stable@vger.kernel.org> # 4.8+
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/base/devres.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> > index 8fc654f0807bf..9763325a9c944 100644
> > --- a/drivers/base/devres.c
> > +++ b/drivers/base/devres.c
> > @@ -24,8 +24,14 @@ struct devres_node {
> >
> >  struct devres {
> >       struct devres_node              node;
> > -     /* -- 3 pointers */
> > -     unsigned long long              data[]; /* guarantee ull alignment */
> > +     /*
> > +      * Some archs want to perform DMA into kmalloc caches
> > +      * and need a guaranteed alignment larger than
> > +      * the alignment of a 64-bit integer.
> > +      * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
> > +      * buffer alignment as if it was allocated by plain kmalloc().
> > +      */
> > +     u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
> >  };
> >
> >  struct devres_group {
> > --
> > 2.25.1
> >
>
> I don't want to apply this to older kernels as it could cause extra
> memory usage for no good reason.  I have no idea why a non ARC system
> would want it :(

I think the reference to ARC is a red herring.
The real issue is that buffers used for DMA may not have the required
alignment, which is not limited to ARC systems.

Note that I'm also not super happy with the extra memory usage.
But devm_*() conveniences come with their penalties...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
