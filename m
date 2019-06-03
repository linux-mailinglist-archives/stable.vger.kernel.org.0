Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158E032A16
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfFCHxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:53:39 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46915 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfFCHxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 03:53:39 -0400
Received: by mail-lj1-f195.google.com with SMTP id m15so6911985ljg.13;
        Mon, 03 Jun 2019 00:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lzAu1h4ws8etdnR0vU/6kchHWm+HERlVg4Pmf8ziv2U=;
        b=A97aK9G6Hq9dQ0cvsetYkFPpfiU6T3l00Rh9NBc+1G8HKjbuqe0iHziPoJqp22tclA
         SqlgHnmBR8YX4xLdUD1ewVuJJlswtcInr6VY4mqEeI8obYoD4caMzZXqWZEFtRmAHGIZ
         7AWj5sLzVm0q2fuw2f2cBwGvI0osMpVY6RqRfUJdDtlqLsVKUayNAv4T3qUdvQXmTXOI
         OyO+ASLdHdJTQL4axKSNvyV3BmKqMUMN2MG6LQLCMiYDyVY4TDHXGjANiyi7xT0rJj66
         lAhrGfMmqjlGY5LWirbRh7tI8bzhvUpdSzGKjEuzUd09m38JOZ3csmVmPOGPR7cDmU0q
         hh+g==
X-Gm-Message-State: APjAAAWISBy3txLBxMBhuEhx9lbf+seTJdS76ueImSv2Xum7ZV+biout
        TmDjZaFN2G1Sjv9pEqWiqrHDNVKXPr6JeGA4WgY=
X-Google-Smtp-Source: APXvYqx+a8Vn6llNZaSeUiwhPpGeG7DsGesioGycPlDZreFw3MX3k5wLMh4T4QIhDHY2JgclwMbqAbNpr2tRxmlxJVs=
X-Received: by 2002:a2e:9185:: with SMTP id f5mr10007939ljg.51.1559548416410;
 Mon, 03 Jun 2019 00:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559438652.git.fthain@telegraphics.com.au>
 <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
 <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com>
 <alpine.LNX.2.21.1906030903510.20@nippy.intranet> <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com>
 <alpine.LNX.2.21.1906031702220.37@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1906031702220.37@nippy.intranet>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 3 Jun 2019 09:53:24 +0200
Message-ID: <CAMuHMdXDvrTe09PVFxoDGj6xg-x+99iAhWoM8xXG-7WPKJBZOw@mail.gmail.com>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take 2
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finn,

On Mon, Jun 3, 2019 at 9:40 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> On Mon, 3 Jun 2019, Geert Uytterhoeven wrote:
> > On Mon, Jun 3, 2019 at 1:32 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> > > On Sun, 2 Jun 2019, Geert Uytterhoeven wrote:
> > > > On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au>
> > > > wrote:
> > > > > A system bus error during a PDMA transfer can mess up the calculation
> > > > > of the transfer residual (the PDMA handshaking hardware lacks a byte
> > > > > counter). This results in data corruption.
> > > > >
> > > > > The algorithm in this patch anticipates a bus error by starting each
> > > > > transfer with a MOVE.B instruction. If a bus error is caught the
> > > > > transfer will be retried. If a bus error is caught later in the
> > > > > transfer (for a MOVE.W instruction) the transfer gets failed and
> > > > > subsequent requests for that target will use PIO instead of PDMA.
> > > > >
> > > > > This avoids the "!REQ and !ACK" error so the severity level of that
> > > > > message is reduced to KERN_DEBUG.
> > > > >
> > > > > Cc: Michael Schmitz <schmitzmic@gmail.com>
> > > > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > > Cc: stable@vger.kernel.org # v4.14+
> > > > > Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> > > > > Reported-by: Chris Jones <chris@martin-jones.com>
> > > > > Tested-by: Stan Johnson <userm57@yahoo.com>
> > > > > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > > >
> > > > Thanks for your patch!
> > > >
> > > > > ---
> > > > >  arch/m68k/include/asm/mac_pdma.h | 179 +++++++++++++++++++++++++++
> > > > >  drivers/scsi/mac_scsi.c          | 201 ++++++++-----------------------
> > > >
> > > > Why have you moved the PDMA implementation to a header file under
> > > > arch/m68k/? Do you intend to reuse it by other drivers?
> > > >
> > >
> > > There are a couple of reasons: the mac_esp driver also uses PDMA and the
> > > NuBus PowerMac port also uses mac_scsi.c. OTOH, the NuBus PowerMac port is
> > > still out-of-tree, and it is unclear whether the mac_esp driver will ever
> > > benefit from this code.
> >
> > So you do have future sharing in mind...
> >
> > > > If not, please keep it in the driver, so (a) you don't need an ack from
> > > > me ;-), and (b) your change may be easier to review.
> > >
> > > I take your wink to mean that you don't want to ask the SCSI maintainers
> > > to review m68k asm. Putting aside the code review process for a moment, do
> >
> > I meant that apart from the code containing m68k assembler source, it is
> > not related to arch/m68k/, and thus belongs to the driver.
>
> That criterion seems insufficient. It could describe most of arch/m68k/mac
> (which has headers in arch/m68k/include).
>
> > There are several other drivers that contain pieces of assembler code.
> >
>
> Does any driver contain assembler code for multiple architectures? I was
> trying to avoid that -- though admittedly I don't yet have actual code for
> the PDMA implementation for mac_scsi for Nubus PowerMacs.
>
> However, the existence of that out-of-tree port suggests to me that
> arch/powerpc/include/mac_scsi.h and arch/m68k/include/mac_scsi.h would be
> an appropriate layout.
>
> But if there's no clear policy then perhaps we should ignore the whole
> question until the driver code actually becomes shared code. I don't mind
> re-working the patch to combine the two files.

Yep, can be handled when the need arises.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
