Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66E71820FA
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgCKSkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:40:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39064 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730779AbgCKSkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:40:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id s2so1665849pgv.6;
        Wed, 11 Mar 2020 11:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LhEArLNs7yTgrwrh8ppvMZscU8fBidqt0+run5uu778=;
        b=miziYrnFGj5q/3KNzAQD7A1EW0goAUAKr23NuSrnxySJK/LArBoxN6WRuNqTU+CIa7
         n1Uv/5X7Km78lOxGKIw8oORIGgmTgVpMKLG5ygVfnQuRODa9dAE0rX6vIimJ7ngm2J09
         xZkdE0x3HcVYTwmLEu8v+vEm14P+efxPlInqyqdK6GQUg9kDsXaBSIfbct3gTQ2Y+r4f
         +iNz1cVhFi//L6iIaH1obGmsrwwZJVs3i8zCuNK9fjKsDZQln8JZ4p13Ispq8nCETLtN
         YwpEfEeY9Ge1i7OT621BgHffm6mR7H9bhFgW/28tchS9o7WKX/vcxdzIEDTicKK+QreJ
         vrww==
X-Gm-Message-State: ANhLgQ2lEitGOrNfLKG0oPXURmOGDr1JVN6NkY0qeljkaowXxdWKr7F4
        DI1VR8HTSxJM34CmWy2NkdM=
X-Google-Smtp-Source: ADFU+vtKIXTgk7ItAsQoDUPk8VMextzmtkVqChxTjhlpMtIE68/BUmHDJyax3UL59pgxKzo6TkaBmg==
X-Received: by 2002:aa7:85c8:: with SMTP id z8mr4031003pfn.66.1583952039317;
        Wed, 11 Mar 2020 11:40:39 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 136sm50668117pgh.26.2020.03.11.11.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:40:38 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B4F364028E; Wed, 11 Mar 2020 18:40:37 +0000 (UTC)
Date:   Wed, 11 Mar 2020 18:40:37 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     NeilBrown <neilb@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311184037.GP11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
 <20200311052620.GD46757@gmail.com>
 <20200311063130.GL11244@42.do-not-panic.com>
 <20200311173545.GA20006@gmail.com>
 <20200311180002.GN11244@42.do-not-panic.com>
 <20200311182130.GA41227@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311182130.GA41227@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 11:21:30AM -0700, Eric Biggers wrote:
> On Wed, Mar 11, 2020 at 06:00:02PM +0000, Luis Chamberlain wrote:
> > On Wed, Mar 11, 2020 at 10:35:45AM -0700, Eric Biggers wrote:
> > > On Wed, Mar 11, 2020 at 06:31:30AM +0000, Luis Chamberlain wrote:
> > > > On Tue, Mar 10, 2020 at 10:26:20PM -0700, Eric Biggers wrote:
> > > > > On Wed, Mar 11, 2020 at 04:32:21AM +0000, Luis Chamberlain wrote:
> > > > > > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > > > 
> > > > > > > It's long been possible to disable kernel module autoloading completely
> > > > > > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > > > > > > preferable
> > > > > > 
> > > > > > preferable but ... not documented. Or was this documented or recommended
> > > > > > somewhere?
> > > > > > 
> > > > > > > to setting it to a nonexistent file since it avoids the
> > > > > > > overhead of an attempted execve(), avoids potential deadlocks, and
> > > > > > > avoids the call to security_kernel_module_request() and thus on
> > > > > > > SELinux-based systems eliminates the need to write SELinux rules to
> > > > > > > dontaudit module_request.
> > > > > 
> > > > > Not that I know of, though I didn't look too hard.  proc(5) mentions
> > > > > /proc/sys/kernel/modprobe but doesn't mention the empty string case.
> > > > > 
> > > > > In any case, it's been supported for a long time, and it's useful for the
> > > > > reasons I mentioned.
> > > > 
> > > > Sure. I think then its important to document it as such then, or perhaps
> > > > make a kconfig option which sets this to empty and document it on the
> > > > kconfig entry.
> > > 
> > > I'll send a man-pages patch to document it in proc(5).
> > > 
> > > Most users, including the one I have in mind, should just be able to run
> > > 'echo > /proc/sys/kernel/modprobe' early in the boot process.  So I don't think
> > > the need for a kconfig option to control the default value has been clearly
> > > demonstrated yet.  You're certainly welcome to send a patch for it if you
> > > believe it would be useful, though.
> > 
> > When doing a rewrite of some of this code I did wonder who would use
> > this and clear it out. A kconfig entry would remove any doubt over its
> > use and would allow one to skip the userspace / early init requirement
> > to empty it out, therefore actually being safer because you are not
> > racing against modules being loaded.
> > 
> > Is avoiding the race more suitable for your needs than echo'ing early on boot?
> > 
> 
> Maybe.  It would avoid the chance of races, but I haven't seen any yet.
> Also, our userspace has to support old kernels, so we still need the
> 'echo > /proc/sys/kernel/modprobe' anyway.  If that turns out to be good enough,
> then it makes things easier for everyone.
> 
> If setting the default at build time turns out to be needed, then sure in that
> case I'll send a patch that adds a kconfig option to do that.  But I'm first
> trying to use the existing kernel functionality.
> 
> Also, a kconfig option isn't really a substitute for documenting this existing
> sysctl.  We still need to document it properly in proc(5) and
> Documentation/admin-guide/sysctl/kernel.rst.

Yes, sure. Whatever mechanism you find *suitable* I think you may the
shiny best new user of it, and so given all that is shared now, I'm sure
you will document do what is needed. Whatever guidance you can provide
based on your experience is of huge value to this little corner of the
kernel.

I just wanted to do away with unclear tribal knowledge and ensure we
support / test whatever you do well moving forward.

  Luis
