Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F60329CA
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFCHkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:40:14 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:55556 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfFCHkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 03:40:14 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 08DAC27E6E;
        Mon,  3 Jun 2019 03:40:11 -0400 (EDT)
Date:   Mon, 3 Jun 2019 17:40:21 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take
 2
In-Reply-To: <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.1906031702220.37@nippy.intranet>
References: <cover.1559438652.git.fthain@telegraphics.com.au> <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au> <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com> <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
 <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Jun 2019, Geert Uytterhoeven wrote:

> Hi Finn,
> 
> On Mon, Jun 3, 2019 at 1:32 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> > On Sun, 2 Jun 2019, Geert Uytterhoeven wrote:
> > > On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au>
> > > wrote:
> > > > A system bus error during a PDMA transfer can mess up the calculation
> > > > of the transfer residual (the PDMA handshaking hardware lacks a byte
> > > > counter). This results in data corruption.
> > > >
> > > > The algorithm in this patch anticipates a bus error by starting each
> > > > transfer with a MOVE.B instruction. If a bus error is caught the
> > > > transfer will be retried. If a bus error is caught later in the
> > > > transfer (for a MOVE.W instruction) the transfer gets failed and
> > > > subsequent requests for that target will use PIO instead of PDMA.
> > > >
> > > > This avoids the "!REQ and !ACK" error so the severity level of that
> > > > message is reduced to KERN_DEBUG.
> > > >
> > > > Cc: Michael Schmitz <schmitzmic@gmail.com>
> > > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > Cc: stable@vger.kernel.org # v4.14+
> > > > Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> > > > Reported-by: Chris Jones <chris@martin-jones.com>
> > > > Tested-by: Stan Johnson <userm57@yahoo.com>
> > > > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > >
> > > Thanks for your patch!
> > >
> > > > ---
> > > >  arch/m68k/include/asm/mac_pdma.h | 179 +++++++++++++++++++++++++++
> > > >  drivers/scsi/mac_scsi.c          | 201 ++++++++-----------------------
> > >
> > > Why have you moved the PDMA implementation to a header file under
> > > arch/m68k/? Do you intend to reuse it by other drivers?
> > >
> >
> > There are a couple of reasons: the mac_esp driver also uses PDMA and the
> > NuBus PowerMac port also uses mac_scsi.c. OTOH, the NuBus PowerMac port is
> > still out-of-tree, and it is unclear whether the mac_esp driver will ever
> > benefit from this code.
> 
> So you do have future sharing in mind...
> 
> > > If not, please keep it in the driver, so (a) you don't need an ack from
> > > me ;-), and (b) your change may be easier to review.
> >
> > I take your wink to mean that you don't want to ask the SCSI maintainers
> > to review m68k asm. Putting aside the code review process for a moment, do
> 
> I meant that apart from the code containing m68k assembler source, it is 
> not related to arch/m68k/, and thus belongs to the driver.

That criterion seems insufficient. It could describe most of arch/m68k/mac 
(which has headers in arch/m68k/include).

> There are several other drivers that contain pieces of assembler code.
> 

Does any driver contain assembler code for multiple architectures? I was 
trying to avoid that -- though admittedly I don't yet have actual code for 
the PDMA implementation for mac_scsi for Nubus PowerMacs.

However, the existence of that out-of-tree port suggests to me that 
arch/powerpc/include/mac_scsi.h and arch/m68k/include/mac_scsi.h would be 
an appropriate layout.

But if there's no clear policy then perhaps we should ignore the whole 
question until the driver code actually becomes shared code. I don't mind 
re-working the patch to combine the two files.

-- 

> > you have an opinion on the most logical way to organise this sort of 
> > code, from the point-of-view of maintainability, re-usability, 
> > readability etc.?
> 
> If the code is used by multiple SCSI drivers, you can move it to a header
> file under drivers/scsi/.
> If the code is shared by drivers belonging to multiple subsystems, you can
> move it to a header file under include/linux/.
> 
> Anyone who has a better solution?
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> 
