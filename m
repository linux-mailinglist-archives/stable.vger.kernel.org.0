Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08AA2CEDE2
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 13:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgLDMPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 07:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgLDMPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 07:15:50 -0500
Date:   Fri, 4 Dec 2020 13:16:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607084110;
        bh=xTd4S5HqClLYRg3BR9qLMX4bWJdUsXlibw9xY/ufDI0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=1rShSnDWhVkoFneGHmVxnMryf0POKRTq4s+mjosSBBpwpgHel6lWtxlUJ7ea/8aGS
         N+WTzhs1Oz74TvrBEp/Ad9JII8O59mho6Oz1TUp+stP8uaFxadOTz9mC+k6SVWne4y
         tUHCipDtTm46PiHAj9TIPYKgp3Qqv/Yke3qadFbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Himadri Pandya <himadrispandya@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: kl5kusb105: fix memleak on open
Message-ID: <X8oomifWO//FvDMT@kroah.com>
References: <20201204085519.20230-1-johan@kernel.org>
 <X8oYPir8HfGEoTzB@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8oYPir8HfGEoTzB@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 12:06:38PM +0100, Johan Hovold wrote:
> On Fri, Dec 04, 2020 at 09:55:19AM +0100, Johan Hovold wrote:
> > Fix memory leak of control-message transfer buffer on successful open().
> > 
> > Fixes: 6774d5f53271 ("USB: serial: kl5kusb105: fix open error path")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> > 
> > While reviewing Himadri's control-message series I noticed we have a
> > related bug in klsi_105_open() that needs fixing.
> > 
> > 
> >  drivers/usb/serial/kl5kusb105.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
> > index 5ee48b0650c4..5f6b82ebccc5 100644
> > --- a/drivers/usb/serial/kl5kusb105.c
> > +++ b/drivers/usb/serial/kl5kusb105.c
> > @@ -276,12 +276,12 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
> >  	priv->cfg.unknown2 = cfg->unknown2;
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> >  
> > +	kfree(cfg);
> > +
> >  	/* READ_ON and urb submission */
> >  	rc = usb_serial_generic_open(tty, port);
> > -	if (rc) {
> > -		retval = rc;
> > -		goto err_free_cfg;
> > -	}
> > +	if (rc)
> > +		return rc;
> >  
> >  	rc = usb_control_msg(port->serial->dev,
> >  			     usb_sndctrlpipe(port->serial->dev, 0),
> > @@ -324,8 +324,6 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
> >  			     KLSI_TIMEOUT);
> >  err_generic_close:
> >  	usb_serial_generic_close(port);
> > -err_free_cfg:
> > -	kfree(cfg);
> >  
> >  	return retval;
> >  }
> 
> I've applied this one now so that I can include it in my pull-request
> for -rc7.
> 
> Greg, just let me know if you think I should hold this one off for 5.11
> instead.

Nope, it's fine to take this now, thanks.

greg k-h
