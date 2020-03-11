Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE29C1820A1
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgCKSVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbgCKSVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:21:33 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756F52072F;
        Wed, 11 Mar 2020 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583950892;
        bh=EMTCcOIumdt7jEeudStF/nDyAUTZ9+64dBQJKN/EsCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNyDx7AIzb6Z8gnHZtLGHSTGfrLVHI7ISZtKRl/W/4N8aHSNsMMXhVQI9aIVRZY65
         UcSfexfQDroVVkYxjUgMgIGK1V7Z3DbBBpIc3HAI53WDUznw14tsPtXfl0UPquNv7+
         sXwWK+yCO5HduWIprk+5ucTWMRPSxpApl4VnAO/0=
Date:   Wed, 11 Mar 2020 11:21:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     NeilBrown <neilb@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311182130.GA41227@sol.localdomain>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
 <20200311052620.GD46757@gmail.com>
 <20200311063130.GL11244@42.do-not-panic.com>
 <20200311173545.GA20006@gmail.com>
 <20200311180002.GN11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311180002.GN11244@42.do-not-panic.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 06:00:02PM +0000, Luis Chamberlain wrote:
> On Wed, Mar 11, 2020 at 10:35:45AM -0700, Eric Biggers wrote:
> > On Wed, Mar 11, 2020 at 06:31:30AM +0000, Luis Chamberlain wrote:
> > > On Tue, Mar 10, 2020 at 10:26:20PM -0700, Eric Biggers wrote:
> > > > On Wed, Mar 11, 2020 at 04:32:21AM +0000, Luis Chamberlain wrote:
> > > > > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > > 
> > > > > > It's long been possible to disable kernel module autoloading completely
> > > > > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > > > > > preferable
> > > > > 
> > > > > preferable but ... not documented. Or was this documented or recommended
> > > > > somewhere?
> > > > > 
> > > > > > to setting it to a nonexistent file since it avoids the
> > > > > > overhead of an attempted execve(), avoids potential deadlocks, and
> > > > > > avoids the call to security_kernel_module_request() and thus on
> > > > > > SELinux-based systems eliminates the need to write SELinux rules to
> > > > > > dontaudit module_request.
> > > > 
> > > > Not that I know of, though I didn't look too hard.  proc(5) mentions
> > > > /proc/sys/kernel/modprobe but doesn't mention the empty string case.
> > > > 
> > > > In any case, it's been supported for a long time, and it's useful for the
> > > > reasons I mentioned.
> > > 
> > > Sure. I think then its important to document it as such then, or perhaps
> > > make a kconfig option which sets this to empty and document it on the
> > > kconfig entry.
> > 
> > I'll send a man-pages patch to document it in proc(5).
> > 
> > Most users, including the one I have in mind, should just be able to run
> > 'echo > /proc/sys/kernel/modprobe' early in the boot process.  So I don't think
> > the need for a kconfig option to control the default value has been clearly
> > demonstrated yet.  You're certainly welcome to send a patch for it if you
> > believe it would be useful, though.
> 
> When doing a rewrite of some of this code I did wonder who would use
> this and clear it out. A kconfig entry would remove any doubt over its
> use and would allow one to skip the userspace / early init requirement
> to empty it out, therefore actually being safer because you are not
> racing against modules being loaded.
> 
> Is avoiding the race more suitable for your needs than echo'ing early on boot?
> 

Maybe.  It would avoid the chance of races, but I haven't seen any yet.
Also, our userspace has to support old kernels, so we still need the
'echo > /proc/sys/kernel/modprobe' anyway.  If that turns out to be good enough,
then it makes things easier for everyone.

If setting the default at build time turns out to be needed, then sure in that
case I'll send a patch that adds a kconfig option to do that.  But I'm first
trying to use the existing kernel functionality.

Also, a kconfig option isn't really a substitute for documenting this existing
sysctl.  We still need to document it properly in proc(5) and
Documentation/admin-guide/sysctl/kernel.rst.

- Eric
