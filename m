Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA7F36B770
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhDZRE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 13:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234628AbhDZRE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 13:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7BD861103;
        Mon, 26 Apr 2021 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619456656;
        bh=7CXGXNARIoSURj5YD7uQQRwpUg88MFd6UNAD7hw7J4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOW3LqycjOtSq/DGgtfmV16U4St9QQV4GG0wFSuD7BVK4IPc0y/AYXV+bThRpO+m7
         Z2GYEU8saijgor5wz99F59Ffsbtt75mZ3WkFXHQTFMp7IRXChgKrm/5UwbaVusfUaQ
         fIbkr9uDouHIsU4Ral30MWnopVraHNiuxo2b1Gwg=
Date:   Mon, 26 Apr 2021 19:04:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Richard Genoud <richard.genoud@gmail.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org,
        Kangjie Lu <kjlu@umn.edu>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 120/190] Revert "tty: atmel_serial: fix a potential NULL
 pointer dereference"
Message-ID: <YIbyjQrfxmcyqWW5@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-121-gregkh@linuxfoundation.org>
 <57f44dfa-a502-ee4f-6d53-0ab7cba00e1b@kernel.org>
 <ad76449f-0603-a156-85d6-37d3c906b4cc@posteo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad76449f-0603-a156-85d6-37d3c906b4cc@posteo.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 06:47:20AM +0000, Richard Genoud wrote:
> 
> 
> Le 22/04/2021 à 07:18, Jiri Slaby a écrit :
> > On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
> > > This reverts commit c85be041065c0be8bc48eda4c45e0319caf1d0e5.
> > > 
> > > Commits from @umn.edu addresses have been found to be submitted in "bad
> > > faith" to try to test the kernel community's ability to review "known
> > > malicious" changes.  The result of these submissions can be found in a
> > > paper published at the 42nd IEEE Symposium on Security and Privacy
> > > entitled, "Open Source Insecurity: Stealthily Introducing
> > > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> > > of Minnesota) and Kangjie Lu (University of Minnesota).
> > > 
> > > Because of this, all submissions from this group must be reverted from
> > > the kernel tree and will need to be re-reviewed again to determine if
> > > they actually are a valid fix.  Until that work is complete, remove this
> > > change to ensure that no problems are being introduced into the
> > > codebase.
> > > 
> > > Cc: Kangjie Lu <kjlu@umn.edu>
> > > Cc: Richard Genoud <richard.genoud@gmail.com>
> > > Cc: stable <stable@vger.kernel.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   drivers/tty/serial/atmel_serial.c | 4 ----
> > >   1 file changed, 4 deletions(-)
> > > 
> > > diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> > > index a24e5c2b30bc..9786d8e5f04f 100644
> > > --- a/drivers/tty/serial/atmel_serial.c
> > > +++ b/drivers/tty/serial/atmel_serial.c
> > > @@ -1256,10 +1256,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
> > >                        sg_dma_len(&atmel_port->sg_rx)/2,
> > >                        DMA_DEV_TO_MEM,
> > >                        DMA_PREP_INTERRUPT);
> > > -    if (!desc) {
> > > -        dev_err(port->dev, "Preparing DMA cyclic failed\n");
> > > -        goto chan_err;
> > > -    }
> > 
> > I cannot find anything malicious in the original fix:
> > * port->dev is valid for dev_err
> > * dmaengine_prep_dma_cyclic returns NULL in case of error
> > * chan_err invokes atmel_release_rx_dma which undoes the previous initialization code.
> > 
> > Hence a NACK from me for the revert.
> 
> I agree with your NACK.
> Back at the time (march 2019), I reviewed the changed and asked for a 2nd version and
> I didn't found anything suspicious.
> But the more eyes, the better.
> 
> cf http://lkml.iu.edu/hypermail/linux/kernel/1903.1/05858.html

Thanks for the review, now dropped.

greg k-h
