Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E331657AA
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 07:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgBTGdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 01:33:36 -0500
Received: from chill.innovation.ch ([216.218.245.220]:40544 "EHLO
        chill.innovation.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgBTGdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 01:33:36 -0500
Date:   Wed, 19 Feb 2020 22:33:35 -0800
DKIM-Filter: OpenDKIM Filter v2.10.3 chill.innovation.ch 542756412C7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=innovation.ch;
        s=default; t=1582180415;
        bh=vhZWh+2Ztj0g9xXmISjjSlOG2XuQ/opDLS+2Tm7NtT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLH5IrYzS0EdMc1N/kj00Tub4ak+6tCwmXHiPFqLdxUZbWsIVAnbLAU1JPXwtXDbk
         Ifv0uXnKrK01hHrLJn2xEwuAJYXk42kdKJ07HfyaoSWUn9tH0aonajEPOF0NvRlyVp
         jzFfdliaDxUJV/a1+mNUFRXw7xM7hiWjcTLFfY28veVyXxrmCcxmvXJb3TMMGEQQnr
         hTAvLHPRyueeegtBGah99+fgGBDLRTisUeSr1r5O2Gv8trIfmzxq1NWHXKqVZyV9go
         uY5wh58pVFBBZzduOXCCSaatN+YRhwct+dQ5/gIZ4cwaU9GtbGpfMYd/Zf1B04w27k
         pEbxHdB+gpmFQ==
From:   "Life is hard, and then you die" <ronald@innovation.ch>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Rob Herring <robh@kernel.org>, Jiri Slaby <jslaby@suse.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] serdev: Fix detection of UART devices on Apple machines.
Message-ID: <20200220063335.GA9421@innovation.ch>
References: <20200211194723.486217-1-ronald@innovation.ch>
 <20200219111519.GB2814125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200219111519.GB2814125@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Wed, Feb 19, 2020 at 12:15:19PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 11, 2020 at 11:47:23AM -0800, Ronald Tschalär wrote:
> > On Apple devices the _CRS method returns an empty resource template, and
> > the resource settings are instead provided by the _DSM method. But
> > commit 33364d63c75d6182fa369cea80315cf1bb0ee38e (serdev: Add ACPI
> > devices by ResourceSource field) changed the search for serdev devices
> > to require valid, non-empty resource template, thereby breaking Apple
> > devices and causing bluetooth devices to not be found.
> > 
> > This expands the check so that if we don't find a valid template, and
> > we're on an Apple machine, then just check for the device being an
> > immediate child of the controller and having a "baud" property.
> > 
> > Cc: <stable@vger.kernel.org> # 5.5
> > Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
> > ---
> >  drivers/tty/serdev/core.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> > index ce5309d00280..0f64a10ba51f 100644
> > --- a/drivers/tty/serdev/core.c
> > +++ b/drivers/tty/serdev/core.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/serdev.h>
> >  #include <linux/slab.h>
> > +#include <linux/platform_data/x86/apple.h>
> 
> Why is this needed?  Just for the x86_apple_machine variable?

Yes.

> Why do we still have platform_data for new systems anymore?  Can't this
> go into a much more generic location?  Like as an inline function?

I'm not sure I follow you. What exactly would you like to see in the
function? The check that sets this variable? Note that this was
originally pulled out into a variable that is set once for performance
reasons - see commit 630b3aff8a51c.


  Cheers,

  Ronald

