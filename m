Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8A2641B6
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 11:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIJJ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 05:28:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:34053 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbgIJJ1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 05:27:30 -0400
IronPort-SDR: mN4Uow4Byk5k4UvhSnTNlUyibOBSy0oEUcs8w/rWXt4DNVDCNpRY762hQdPvg7KeqM0VjL30rB
 Nlv48Ggz10YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="155959546"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="155959546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 02:27:19 -0700
IronPort-SDR: eCrhByWXSSpzQhy0QRwbfDpyXB6D1mCK4pQ0qv49CimrJISk/wYVOIIq6oYwYQwClFtU3ibcSG
 89+uWbTIVm1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334120998"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 02:27:17 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kGIrL-00FeWV-0j; Thu, 10 Sep 2020 12:27:15 +0300
Date:   Thu, 10 Sep 2020 12:27:15 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Johan Hovold <johan@kernel.org>, Tony Lindgren <tony@atomide.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: core: fix console port-lock regression
Message-ID: <20200910092715.GM1891694@smile.fi.intel.com>
References: <20200909143101.15389-1-johan@kernel.org>
 <20200909143101.15389-3-johan@kernel.org>
 <20200909154815.GD1891694@smile.fi.intel.com>
 <20200910073527.GC24441@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910073527.GC24441@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Cc: Tony, let me add Tony to the discussion.

On Thu, Sep 10, 2020 at 09:35:27AM +0200, Johan Hovold wrote:
> On Wed, Sep 09, 2020 at 06:48:15PM +0300, Andy Shevchenko wrote:
> > On Wed, Sep 09, 2020 at 04:31:01PM +0200, Johan Hovold wrote:
> > > Fix the port-lock initialisation regression introduced by commit
> > > a3cb39d258ef ("serial: core: Allow detach and attach serial device for
> > > console") by making sure that the lock is again initialised during
> > > console setup.
> > > 
> > > The console may be registered before the serial controller has been
> > > probed in which case the port lock needs to be initialised during
> > > console setup by a call to uart_set_options(). The console-detach
> > > changes introduced a regression in several drivers by effectively
> > > removing that initialisation by not initialising the lock when the port
> > > is used as a console (which is always the case during console setup).
> > > 
> > > Add back the early lock initialisation and instead use a new
> > > console-reinit flag to handle the case where a console is being
> > > re-attached through sysfs.
> > > 
> > > The question whether the console-detach interface should have been added
> > > in the first place is left for another discussion.
> > 
> > It was discussed in [1]. TL;DR: OMAP would like to keep runtime PM available
> > for UART while at the same time we disable it for kernel consoles in
> > bedb404e91bb.
> > 
> > [1]: https://lists.openwall.net/linux-kernel/2018/09/29/65
> 
> Yeah, I remember that. My fear is just that the new interface opens up a
> can of worms as it removes the earlier assumption that the console would
> essentially never be deregistered without really fixing all those
> drivers, and core functions, written under that assumption. Just to
> mention a few issues; we have drivers enabling clocks and other
> resources during console setup which can now be done repeatedly,

The series introduced the console ->exit() callback, so it should be easy to
fix.

>	and
> several drivers whose setup callbacks are marked __init and will oops
> the minute you reattach the console.

I believe this can be fixed relatively easy. As a last resort it can be a quirk
that disables console detachment for problematic consoles.

> And what about power management
> which was the reason for wanting this on OMAP in the first place; tty
> core never calls shutdown() for a console port, not even when it's been
> detached using the new interface.

That is interesting... Tony, do we have OMAP case working because of luck?

> I know, the console setup is all a mess, but this still seems a little
> rushed to me. I'm even inclined to suggest a revert until the above and
> similar issues have been addressed properly rather keeping a known buggy
> interface.

You know that it will be a dead end. Any solution how to move forward?

> > > Note that the console-enabled check in uart_set_options() is not
> > > redundant because of kgdboc, which can end up reinitialising an already
> > > enabled console (see commit 42b6a1baa3ec ("serial_core: Don't
> > > re-initialize a previously initialized spinlock.")).

-- 
With Best Regards,
Andy Shevchenko


