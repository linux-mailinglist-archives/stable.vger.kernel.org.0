Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0242654A5
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIJV7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:59:40 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35845 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbgIJLKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 07:10:24 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so7650738ljm.3;
        Thu, 10 Sep 2020 04:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khsISv6KrMDMd3j57rJbO3CE20Pfs/l3bC/RR73dbF4=;
        b=YcLdyUsHp/qQnTy5Xw0TQwgBcNeDgwAlOYNJ8SwNmKzSha5n8+lFdk6T/Lz6DGWM7I
         E/OsKLldIY4iEMpfnPnHnH53F50ryBUHMrE2sQE1Aan5oKF+YnOuHOMkoTS8xfN3OKUQ
         GUph7HfsQ2+xsBjVS5kH/dVzeQNekilVfpuiQGP07BQjt3CP3bJxvI1kP5bIdIosmvoF
         sk25YVnKGQkEi0W7BwFC+XhJ8+0yDA1TBo1IDfxd5zwKlq0PWB8SieaekHbgnThr7ViC
         EsM2kOMcsgoUiLMoxN37NCTj2+uMCyy7Za8EkkUwtJErixfa28WxpfamBrixFIezqSLf
         ahMw==
X-Gm-Message-State: AOAM532KB5A5NSjo3uKbpydEMvFPCkI0GzWW3BoncNY7xQWC7CNUkS+y
        F1zakHXHBQrp2Q4fCP1Wiew=
X-Google-Smtp-Source: ABdhPJxE2eVsfsgDJpsGn8d/K4cY6mYTZqt67kV/mH7Rg97qgCPm6khS6FyHNSOfUaFmKUJ/C0/beA==
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr4059203ljp.281.1599736219850;
        Thu, 10 Sep 2020 04:10:19 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id k14sm1280483lfm.90.2020.09.10.04.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 04:10:19 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kGKT1-0006qV-S1; Thu, 10 Sep 2020 13:10:15 +0200
Date:   Thu, 10 Sep 2020 13:10:15 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Johan Hovold <johan@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: core: fix console port-lock regression
Message-ID: <20200910111015.GE24441@localhost>
References: <20200909143101.15389-1-johan@kernel.org>
 <20200909143101.15389-3-johan@kernel.org>
 <20200909154815.GD1891694@smile.fi.intel.com>
 <20200910073527.GC24441@localhost>
 <20200910092715.GM1891694@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910092715.GM1891694@smile.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 12:27:15PM +0300, Andy Shevchenko wrote:
> +Cc: Tony, let me add Tony to the discussion.
> 
> On Thu, Sep 10, 2020 at 09:35:27AM +0200, Johan Hovold wrote:
> > On Wed, Sep 09, 2020 at 06:48:15PM +0300, Andy Shevchenko wrote:
> > > On Wed, Sep 09, 2020 at 04:31:01PM +0200, Johan Hovold wrote:
> > > > Fix the port-lock initialisation regression introduced by commit
> > > > a3cb39d258ef ("serial: core: Allow detach and attach serial device for
> > > > console") by making sure that the lock is again initialised during
> > > > console setup.
> > > > 
> > > > The console may be registered before the serial controller has been
> > > > probed in which case the port lock needs to be initialised during
> > > > console setup by a call to uart_set_options(). The console-detach
> > > > changes introduced a regression in several drivers by effectively
> > > > removing that initialisation by not initialising the lock when the port
> > > > is used as a console (which is always the case during console setup).
> > > > 
> > > > Add back the early lock initialisation and instead use a new
> > > > console-reinit flag to handle the case where a console is being
> > > > re-attached through sysfs.
> > > > 
> > > > The question whether the console-detach interface should have been added
> > > > in the first place is left for another discussion.
> > > 
> > > It was discussed in [1]. TL;DR: OMAP would like to keep runtime PM available
> > > for UART while at the same time we disable it for kernel consoles in
> > > bedb404e91bb.
> > > 
> > > [1]: https://lists.openwall.net/linux-kernel/2018/09/29/65
> > 
> > Yeah, I remember that. My fear is just that the new interface opens up a
> > can of worms as it removes the earlier assumption that the console would
> > essentially never be deregistered without really fixing all those
> > drivers, and core functions, written under that assumption. Just to
> > mention a few issues; we have drivers enabling clocks and other
> > resources during console setup which can now be done repeatedly,
> 
> The series introduced the console ->exit() callback, so it should be
> easy to fix.

I'm not saying it's necessarily hard, I'm suggesting it should have been
considered before merging. But there could still be complications as the
console have always been considered a special case that's been hacked
around.

> >	and
> > several drivers whose setup callbacks are marked __init and will oops
> > the minute you reattach the console.
> 
> I believe this can be fixed relatively easy. As a last resort it can
> be a quirk that disables console detachment for problematic consoles.

Sure, but just removing the __init without vetting the drivers and
testing the new interface may not be much better than letting them oops.

> > And what about power management
> > which was the reason for wanting this on OMAP in the first place; tty
> > core never calls shutdown() for a console port, not even when it's been
> > detached using the new interface.
> 
> That is interesting... Tony, do we have OMAP case working because of luck?
> 
> > I know, the console setup is all a mess, but this still seems a little
> > rushed to me. I'm even inclined to suggest a revert until the above and
> > similar issues have been addressed properly rather keeping a known buggy
> > interface.
> 
> You know that it will be a dead end. Any solution how to move forward?

I guess that depends on how broken this is. I only gave a few examples
of the top of my head of issues that needs to be considered. 

But if this is to stay then making the feature opt-in by only exposing
the attribute for console drivers that implement the new exit() callback
or some other serial-driver flag might work.

Johan
