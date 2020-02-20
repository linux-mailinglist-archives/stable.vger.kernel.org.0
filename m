Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8DD1657F5
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 07:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgBTGr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 01:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgBTGr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 01:47:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16AA224654;
        Thu, 20 Feb 2020 06:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582181247;
        bh=av3gIAphexoZk/hwtUUlr6b+78+ltOT73zXzEY7fbv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wukfz8PZklykfRGRH5H3VnHu7/SarJxu56QORmejA5L1XWzJHNormmDIf7Qr4R4zr
         yl/TdMRBtUjjoxWlcFgfgUW1XgnRrtsimMxgOXYLa0Fc8PoDdqo+ODHfT0Fd+peFIM
         QgwtsI74IubuLTOgp+YaykqFZLlzQhxFOR0scQEw=
Date:   Thu, 20 Feb 2020 07:47:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Life is hard, and then you die" <ronald@innovation.ch>
Cc:     Rob Herring <robh@kernel.org>, Jiri Slaby <jslaby@suse.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] serdev: Fix detection of UART devices on Apple machines.
Message-ID: <20200220064723.GA3192090@kroah.com>
References: <20200211194723.486217-1-ronald@innovation.ch>
 <20200219111519.GB2814125@kroah.com>
 <20200220063335.GA9421@innovation.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200220063335.GA9421@innovation.ch>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 10:33:35PM -0800, Life is hard, and then you die wrote:
> 
> On Wed, Feb 19, 2020 at 12:15:19PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Feb 11, 2020 at 11:47:23AM -0800, Ronald Tschalär wrote:
> > > On Apple devices the _CRS method returns an empty resource template, and
> > > the resource settings are instead provided by the _DSM method. But
> > > commit 33364d63c75d6182fa369cea80315cf1bb0ee38e (serdev: Add ACPI
> > > devices by ResourceSource field) changed the search for serdev devices
> > > to require valid, non-empty resource template, thereby breaking Apple
> > > devices and causing bluetooth devices to not be found.
> > > 
> > > This expands the check so that if we don't find a valid template, and
> > > we're on an Apple machine, then just check for the device being an
> > > immediate child of the controller and having a "baud" property.
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.5
> > > Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
> > > ---
> > >  drivers/tty/serdev/core.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> > > index ce5309d00280..0f64a10ba51f 100644
> > > --- a/drivers/tty/serdev/core.c
> > > +++ b/drivers/tty/serdev/core.c
> > > @@ -18,6 +18,7 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/serdev.h>
> > >  #include <linux/slab.h>
> > > +#include <linux/platform_data/x86/apple.h>
> > 
> > Why is this needed?  Just for the x86_apple_machine variable?
> 
> Yes.
> 
> > Why do we still have platform_data for new systems anymore?  Can't this
> > go into a much more generic location?  Like as an inline function?
> 
> I'm not sure I follow you. What exactly would you like to see in the
> function? The check that sets this variable? Note that this was
> originally pulled out into a variable that is set once for performance
> reasons - see commit 630b3aff8a51c.

That's fine, but what I am objecting to is platform-specific include
files being added to random common kernel code.  There's no real reason
for this other than one specific hardware platform has a quirk.  Are we
supposed to keep this pattern up by doing tons of:
	#include <linux/platform_data/x86/vendor_X>
	#include <linux/platform_data/x86/vendor_Y>
	#include <linux/platform_data/x86/vendor_Z>
all through the kernel?

That's a serious regression to the "bad old days" of platform specific
crud being required in each and every driver subsystem.

Now I know it's not your fault this is needed for your one change, but
can you work on a patch series to fix this all up so that it is not
needed?  I'm sure the x86 maintainers don't want to see this spread
around.

Heck, ARM doesn't even need this kind of mess :)

thanks,

greg k-h
