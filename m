Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5D13DFFC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgAPQY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:24:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45136 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAPQY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:24:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id j26so23332034ljc.12;
        Thu, 16 Jan 2020 08:24:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6S6e/mKZ8OvahfYPg2IWhjpWyuOJy/SC3klW8uIZVzE=;
        b=cSfCPBGomZ/Ra25BbGWIJevl/jhpLznMnY8h3EmG8cWo4TI0Yus1SkHnQ77vm4ettg
         ulnrn1F0J4SNBo93Rqglxn2MB25LwAPrA+N93p6CsoLXtbqapgN3ooCx79bgU/BIpEfa
         fcmcg53Nf6dYDTuKTV42fAdDE3yNbWUbPaQkTCk9cC9ICKAFPG5FYXO9r5B0Z6FdvOeS
         0MrGSZb1/h6cRGCa/IsxZsQFeRwPUTTzWTjKG1MFPLRgmj4aoslwJNW06qMARjZQ33jr
         cP1qa+WD36UtxNwBnRnmAIOIH822RANPv3O9eJd9hCK/TZejj8/0ajSzMZvII20GTQyv
         PI9A==
X-Gm-Message-State: APjAAAVHAkQql11FLFhscLtqZfshltpVHt7ybKftnl0/uGG0g5KGfgZe
        l90dedNhQLERWoNj05s9ByJNhFb6
X-Google-Smtp-Source: APXvYqxTGwShEYlbiHJI81+KVBHdhGk7mPkgfs3FDe3EvNWd3W28Z9gzqQIDIfX9tHWVAsMH6PHuCw==
X-Received: by 2002:a2e:97d9:: with SMTP id m25mr2826415ljj.146.1579191866145;
        Thu, 16 Jan 2020 08:24:26 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y7sm10805879lfe.7.2020.01.16.08.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:24:25 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1is7wW-0001Sk-Ql; Thu, 16 Jan 2020 17:24:24 +0100
Date:   Thu, 16 Jan 2020 17:24:24 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: suppress driver bind attributes
Message-ID: <20200116162424.GP2301@localhost>
References: <20200116160705.5199-1-johan@kernel.org>
 <20200116161829.GA909791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116161829.GA909791@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 05:18:29PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 16, 2020 at 05:07:05PM +0100, Johan Hovold wrote:
> > USB-serial drivers must not be unbound from their ports before the
> > corresponding USB driver is unbound from the parent interface so
> > suppress the bind and unbind attributes.
> > 
> > Unbinding a serial driver while it's port is open is a sure way to
> > trigger a crash as any driver state is released on unbind while port
> > hangup is handled on the parent USB interface level. Drivers for
> > multiport devices where ports share a resource such as an interrupt
> > endpoint also generally cannot handle individual ports going away.
> > 
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/usb-serial.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> > index 8f066bb55d7d..dc7a65b9ec98 100644
> > --- a/drivers/usb/serial/usb-serial.c
> > +++ b/drivers/usb/serial/usb-serial.c
> > @@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
> >  		return -EINVAL;
> >  	}
> >  
> > +	/* Prevent individual ports from being unbound. */
> > +	driver->driver.suppress_bind_attrs = true;
> 
> We can still unbind the usb driver though, right?  If so, this is fine
> with me.

Right, this is only about disabling individual ports, something which
essentially no subdriver can handle while a port is open (e.g. port-data
set to NULL while port is still open... boom).

Johan
