Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362363286C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 08:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfFCGX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 02:23:28 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32881 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfFCGX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 02:23:27 -0400
Received: by mail-lj1-f194.google.com with SMTP id v29so3720191ljv.0;
        Sun, 02 Jun 2019 23:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lU1yMqA1q556Chq2SdDTyPyC3Sn1W2i9WqstPYhXvqc=;
        b=ZYF8ZHHot0+aZVLTzj+zFLYJ/Bax7NjPF5zoBNHKQebLv17ZWFbuKANwmK5WZwUDvZ
         MiseXXo2G/AkEf+q9+hSpO/y6pv3wHhxeZeLOiZpBZy/0detOd1WQWYqXl5G8EBtALxp
         JD/IFUoOqzXXjCQ5Md5i8RnrZrNoGstocyG5YTq7ORlPezlXmeHI9rRalz8KsAZKosb5
         uXPl/z/YQDeWKOoQg3A39X8AInZ2TU47/LlZl2NtH2k9sFMYrsVHrpqZNkXQ38CfLTjp
         SDfM8P64sk+PvbVyTQzIRXhnPCp/rFwSX7gEC63ezV8eFWirfipUk3tj6kR2ByVOqpOp
         fNNg==
X-Gm-Message-State: APjAAAV+mSHsmQXCf+FxnTZ2Wau2VGtG8XgjxO/+olk36DAg9Y33Q5ze
        NjPKqczPKrGP4yC5hX+Kw2ZVFM7t1wcWZfhtwYY=
X-Google-Smtp-Source: APXvYqxu94SdIj8eZwrxLgUmofdtiuDh9HF9JNbyCeGXFuCdouBxJZhEJasbn4kldVZoxvTiWP1esfEMR+kiTlTlDag=
X-Received: by 2002:a2e:91c5:: with SMTP id u5mr1310202ljg.65.1559543005801;
 Sun, 02 Jun 2019 23:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559438652.git.fthain@telegraphics.com.au>
 <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
 <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com> <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 3 Jun 2019 08:23:13 +0200
Message-ID: <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com>
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

On Mon, Jun 3, 2019 at 1:32 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sun, 2 Jun 2019, Geert Uytterhoeven wrote:
> > On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au>
> > wrote:
> > > A system bus error during a PDMA transfer can mess up the calculation
> > > of the transfer residual (the PDMA handshaking hardware lacks a byte
> > > counter). This results in data corruption.
> > >
> > > The algorithm in this patch anticipates a bus error by starting each
> > > transfer with a MOVE.B instruction. If a bus error is caught the
> > > transfer will be retried. If a bus error is caught later in the
> > > transfer (for a MOVE.W instruction) the transfer gets failed and
> > > subsequent requests for that target will use PIO instead of PDMA.
> > >
> > > This avoids the "!REQ and !ACK" error so the severity level of that
> > > message is reduced to KERN_DEBUG.
> > >
> > > Cc: Michael Schmitz <schmitzmic@gmail.com>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: stable@vger.kernel.org # v4.14+
> > > Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> > > Reported-by: Chris Jones <chris@martin-jones.com>
> > > Tested-by: Stan Johnson <userm57@yahoo.com>
> > > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> >
> > Thanks for your patch!
> >
> > > ---
> > >  arch/m68k/include/asm/mac_pdma.h | 179 +++++++++++++++++++++++++++
> > >  drivers/scsi/mac_scsi.c          | 201 ++++++++-----------------------
> >
> > Why have you moved the PDMA implementation to a header file under
> > arch/m68k/? Do you intend to reuse it by other drivers?
> >
>
> There are a couple of reasons: the mac_esp driver also uses PDMA and the
> NuBus PowerMac port also uses mac_scsi.c. OTOH, the NuBus PowerMac port is
> still out-of-tree, and it is unclear whether the mac_esp driver will ever
> benefit from this code.

So you do have future sharing in mind...

> > If not, please keep it in the driver, so (a) you don't need an ack from
> > me ;-), and (b) your change may be easier to review.
>
> I take your wink to mean that you don't want to ask the SCSI maintainers
> to review m68k asm. Putting aside the code review process for a moment, do

I meant that apart from the code containing m68k assembler source, it
is not related to arch/m68k/, and thus belongs to the driver.
There are several other drivers that contain pieces of assembler code.

> you have an opinion on the most logical way to organise this sort of code,
> from the point-of-view of maintainability, re-usability, readability etc.?

If the code is used by multiple SCSI drivers, you can move it to a header
file under drivers/scsi/.
If the code is shared by drivers belonging to multiple subsystems, you can
move it to a header file under include/linux/.

Anyone who has a better solution?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
