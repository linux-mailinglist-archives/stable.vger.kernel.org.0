Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696171407A8
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgAQKNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:13:11 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36852 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAQKNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:13:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so25888970ljg.3;
        Fri, 17 Jan 2020 02:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=27OKuW1EPYQNCW/10XPFeETBURDbLJdk+E98iUT1Caw=;
        b=NofO/ZPZv6WP8VA3XNwhb3xJ+XX/LQ2SbN5+OxNSWFfvzxTg4ARU3zUccy1DY+nGyA
         hiS6pEr9b1BImfCdfimJaHkrGFK7V1oQrirpNZ4mR6M8wWrF42qNyfJUSIiUvScNKYeP
         BbXwfAWByWmjN+AGI3C8rGpAqcb/tDyt7SngTq9Q7RPEPw/rS1YP9OVTZDmetrhNF3EJ
         l/pDa4/i9fYBpneTmD30s1Be5P2tStUD+zoM/pRYQbI2fIUNnP5bmgsrncuKzoCYN244
         sw95kj/zwe+Wnb8X1C2uY23QAw3pMaHgYKkkKE1LvXvzrZ1Jwf9gdMDZ+xJ9IoErWF91
         vyng==
X-Gm-Message-State: APjAAAWmL8PUSo5ZQRFS0JpVMHorDzfZNJe6ucYZfAAve8l9JakwrK+R
        JgvRSs2jHQdi3d4njnFIbIk=
X-Google-Smtp-Source: APXvYqy5a957oEtlMR0bDbBktblL00BQnpOpzbL56Oezu5j5K+CCTVzXtMPJMTfRwMwDax6POlWtgQ==
X-Received: by 2002:a2e:5304:: with SMTP id h4mr5277032ljb.75.1579255985184;
        Fri, 17 Jan 2020 02:13:05 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id n30sm13867442lfi.54.2020.01.17.02.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 02:13:04 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1isOch-0001So-V7; Fri, 17 Jan 2020 11:13:04 +0100
Date:   Fri, 17 Jan 2020 11:13:03 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: suppress driver bind attributes
Message-ID: <20200117101303.GQ2301@localhost>
References: <20200116160705.5199-1-johan@kernel.org>
 <20200116161829.GA909791@kroah.com>
 <20200116162424.GP2301@localhost>
 <20200116190606.GB1020857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116190606.GB1020857@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 08:06:06PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 16, 2020 at 05:24:24PM +0100, Johan Hovold wrote:
> > On Thu, Jan 16, 2020 at 05:18:29PM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Jan 16, 2020 at 05:07:05PM +0100, Johan Hovold wrote:
> > > > USB-serial drivers must not be unbound from their ports before the
> > > > corresponding USB driver is unbound from the parent interface so
> > > > suppress the bind and unbind attributes.
> > > > 
> > > > Unbinding a serial driver while it's port is open is a sure way to
> > > > trigger a crash as any driver state is released on unbind while port
> > > > hangup is handled on the parent USB interface level. Drivers for
> > > > multiport devices where ports share a resource such as an interrupt
> > > > endpoint also generally cannot handle individual ports going away.
> > > > 
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > > >  drivers/usb/serial/usb-serial.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> > > > index 8f066bb55d7d..dc7a65b9ec98 100644
> > > > --- a/drivers/usb/serial/usb-serial.c
> > > > +++ b/drivers/usb/serial/usb-serial.c
> > > > @@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
> > > >  		return -EINVAL;
> > > >  	}
> > > >  
> > > > +	/* Prevent individual ports from being unbound. */
> > > > +	driver->driver.suppress_bind_attrs = true;
> > > 
> > > We can still unbind the usb driver though, right?  If so, this is fine
> > > with me.
> > 
> > Right, this is only about disabling individual ports, something which
> > essentially no subdriver can handle while a port is open (e.g. port-data
> > set to NULL while port is still open... boom).
> 
> Ok, thanks for verifying, and sorry for writing that bug in the first
> place :)
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Heh, thanks for reviewing.

Johan
