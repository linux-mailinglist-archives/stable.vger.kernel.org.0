Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CAE180BE0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 23:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJWvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 18:51:24 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:64947 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgCJWvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 18:51:24 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 48cVgs3FwSzB1;
        Tue, 10 Mar 2020 23:51:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1583880681; bh=HCqVY0Ab2Jo0fK/uAoRfORRHPkIU6lz6VreLU0tBoWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0yx0ruQd1XhnQDQUFMtuRWclv7Cav2MJsYUnoiQpIWE1llFxTQlyk0IIaQP60Hj7
         jbqMCRX6/SCmPDyj4wo3F/ENP+S7LXEv5MIODRndKeNIyCKYDrBtvlwlGz9RkbdWLA
         0kuYmDot6M6jp2XsBbSU2fQmi3ILK9X+DPufQx8zCWf7VOES3c5ALG+k8lJEToDWX1
         /NjsOd0iAtMNLobnl65mXODLSFWOvtiev+mnWi96vZ5hRM/JzuqrRAYF1sUMcjcsXv
         xlh3bBIeYbxGSNsRWpmDexi0tYz2FXFEbYmMrZ5rFlXDjHr2psjCc+tqG8CT7JAJ+V
         mkgh0EoSI2FcA==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.2 at mail
Date:   Tue, 10 Mar 2020 23:51:18 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergey Organov <sorganov@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/86] usb: gadget: serial: fix Tx stall after
 buffer overflow
Message-ID: <20200310225118.GA32479@qmqm.qmqm.pl>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124531.459641903@linuxfoundation.org>
 <20200310150834.GA24886@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200310150834.GA24886@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 04:08:35PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Sergey Organov <sorganov@gmail.com>
> > 
> > [ Upstream commit e4bfded56cf39b8d02733c1e6ef546b97961e18a ]
> > 
> > Symptom: application opens /dev/ttyGS0 and starts sending (writing) to
> > it while either USB cable is not connected, or nobody listens on the
> > other side of the cable. If driver circular buffer overflows before
> > connection is established, no data will be written to the USB layer
> > until/unless /dev/ttyGS0 is closed and re-opened again by the
> > application (the latter besides having no means of being notified about
> > the event of establishing of the connection.)
> > 
> > Fix: on open and/or connect, kick Tx to flush circular buffer data to
> > USB layer.
> 
> > diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
> > index d4d317db89df5..38afe96c5cd26 100644
> > --- a/drivers/usb/gadget/function/u_serial.c
> > +++ b/drivers/usb/gadget/function/u_serial.c
> > @@ -567,8 +567,10 @@ static int gs_start_io(struct gs_port *port)
> >  	port->n_read = 0;
> >  	started = gs_start_rx(port);
> >  
> > -	/* unblock any pending writes into our circular buffer */
> >  	if (started) {
> > +		gs_start_tx(port);
> > +		/* Unblock any pending writes into our circular buffer, in case
> > +		 * we didn't in gs_start_tx() */
> >  		tty_wakeup(port->port.tty);
> 
> I'm confused. gs-start_tx() is done twice in a row. Its return
> convention seem to be 0 in success case, and non-zero on failure. But
> it is assigned to variable called "started", which does not sound like
> "error" to me.
> 
> Are you sure this is correct?

The function before 'if (started)' is gs_start_rx() - it's RX not TX.

Best Regards,
Micha³ Miros³aw
