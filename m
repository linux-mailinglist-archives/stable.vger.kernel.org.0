Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA713F6A5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437443AbgAPTGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733289AbgAPTGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 14:06:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3076206B7;
        Thu, 16 Jan 2020 19:06:07 +0000 (UTC)
Date:   Thu, 16 Jan 2020 20:06:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: suppress driver bind attributes
Message-ID: <20200116190606.GB1020857@kroah.com>
References: <20200116160705.5199-1-johan@kernel.org>
 <20200116161829.GA909791@kroah.com>
 <20200116162424.GP2301@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116162424.GP2301@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 05:24:24PM +0100, Johan Hovold wrote:
> On Thu, Jan 16, 2020 at 05:18:29PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Jan 16, 2020 at 05:07:05PM +0100, Johan Hovold wrote:
> > > USB-serial drivers must not be unbound from their ports before the
> > > corresponding USB driver is unbound from the parent interface so
> > > suppress the bind and unbind attributes.
> > > 
> > > Unbinding a serial driver while it's port is open is a sure way to
> > > trigger a crash as any driver state is released on unbind while port
> > > hangup is handled on the parent USB interface level. Drivers for
> > > multiport devices where ports share a resource such as an interrupt
> > > endpoint also generally cannot handle individual ports going away.
> > > 
> > > Cc: stable <stable@vger.kernel.org>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  drivers/usb/serial/usb-serial.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> > > index 8f066bb55d7d..dc7a65b9ec98 100644
> > > --- a/drivers/usb/serial/usb-serial.c
> > > +++ b/drivers/usb/serial/usb-serial.c
> > > @@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > +	/* Prevent individual ports from being unbound. */
> > > +	driver->driver.suppress_bind_attrs = true;
> > 
> > We can still unbind the usb driver though, right?  If so, this is fine
> > with me.
> 
> Right, this is only about disabling individual ports, something which
> essentially no subdriver can handle while a port is open (e.g. port-data
> set to NULL while port is still open... boom).

Ok, thanks for verifying, and sorry for writing that bug in the first
place :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
