Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8142526F69A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 09:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgIRHUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 03:20:24 -0400
Received: from muru.com ([72.249.23.125]:44820 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgIRHUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 03:20:24 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 03:20:24 EDT
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 823FC8005;
        Fri, 18 Sep 2020 07:15:24 +0000 (UTC)
Date:   Fri, 18 Sep 2020 10:16:13 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: core: fix console port-lock regression
Message-ID: <20200918071613.GL7101@atomide.com>
References: <20200909143101.15389-1-johan@kernel.org>
 <20200909143101.15389-3-johan@kernel.org>
 <20200909154815.GD1891694@smile.fi.intel.com>
 <20200910073527.GC24441@localhost>
 <20200910092715.GM1891694@smile.fi.intel.com>
 <20200914080916.GI7101@atomide.com>
 <20200916122324.GG3956970@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916122324.GG3956970@smile.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Andy Shevchenko <andriy.shevchenko@linux.intel.com> [200916 12:34]:
> On Mon, Sep 14, 2020 at 11:09:16AM +0300, Tony Lindgren wrote:
> > * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [200910 09:27]:
> > > +Cc: Tony, let me add Tony to the discussion.
> > > 
> > > On Thu, Sep 10, 2020 at 09:35:27AM +0200, Johan Hovold wrote:
> > > > And what about power management
> > > > which was the reason for wanting this on OMAP in the first place; tty
> > > > core never calls shutdown() for a console port, not even when it's been
> > > > detached using the new interface.
> > > 
> > > That is interesting... Tony, do we have OMAP case working because of luck?
> > 
> > 8250_omap won't do anything unless autosuspend_timeout is configured for
> > the uart(s). If configured, then the 8250_omap will idle when console is
> > detached and the PM runtime usage count held by console is decremented, and
> > the configured autosuspend_timeout expires.
> > 
> > The console is still kept open by getty, so I don't see why shutdown() would
> > be called for the console port. But maybe I don't follow what you're
> > concerned about, let me know if you want me to check something :)
> 
> Is it possible to test configuration when you have kernel console enabled but
> no getty is run on it (perhaps something with ssh enabled access)?
> 
> Then kernel console should call ->shutdown on detaching, right?

I gave this a quick try and Johan is right, shutdown is not called on console
uart still even if detached and no getty running on that uart. I could not
figure out easily where exactly this gets blocked.. So far I did try setting
port->console = 0 on detach, then init it again on attach.

Regards,

Tony
