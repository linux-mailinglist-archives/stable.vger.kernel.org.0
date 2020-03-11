Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52EB181FA0
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 18:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgCKRfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 13:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgCKRfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 13:35:48 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 029502072F;
        Wed, 11 Mar 2020 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583948148;
        bh=MbY9qlpF44j0kKHATaQuiVivILUnP2tRY5dGbQNpF8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UrO01ddduZpwSwXvJ5QPi/FiMHExJaka5FpC/zwV5XUY60Xqbeuq5DZhoReMG3MX/
         d25tmidlV6uf+FABBOF1lv9HKRiCzLkfluuP5bazXTJinooIfduxQS+AIpb4FZv8nL
         KEG/+1Tg85KZzKi2T7+IMkPQEL8jT5lebPhpqTOY=
Date:   Wed, 11 Mar 2020 10:35:45 -0700
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
Message-ID: <20200311173545.GA20006@gmail.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
 <20200311052620.GD46757@gmail.com>
 <20200311063130.GL11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311063130.GL11244@42.do-not-panic.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 06:31:30AM +0000, Luis Chamberlain wrote:
> On Tue, Mar 10, 2020 at 10:26:20PM -0700, Eric Biggers wrote:
> > On Wed, Mar 11, 2020 at 04:32:21AM +0000, Luis Chamberlain wrote:
> > > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > It's long been possible to disable kernel module autoloading completely
> > > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > > > preferable
> > > 
> > > preferable but ... not documented. Or was this documented or recommended
> > > somewhere?
> > > 
> > > > to setting it to a nonexistent file since it avoids the
> > > > overhead of an attempted execve(), avoids potential deadlocks, and
> > > > avoids the call to security_kernel_module_request() and thus on
> > > > SELinux-based systems eliminates the need to write SELinux rules to
> > > > dontaudit module_request.
> > 
> > Not that I know of, though I didn't look too hard.  proc(5) mentions
> > /proc/sys/kernel/modprobe but doesn't mention the empty string case.
> > 
> > In any case, it's been supported for a long time, and it's useful for the
> > reasons I mentioned.
> 
> Sure. I think then its important to document it as such then, or perhaps
> make a kconfig option which sets this to empty and document it on the
> kconfig entry.

I'll send a man-pages patch to document it in proc(5).

Most users, including the one I have in mind, should just be able to run
'echo > /proc/sys/kernel/modprobe' early in the boot process.  So I don't think
the need for a kconfig option to control the default value has been clearly
demonstrated yet.  You're certainly welcome to send a patch for it if you
believe it would be useful, though.

> > So I don't see
> > why it would be controversial?  I already went through all callers of
> > request_module() that check its return value, and they all appear to work better
> > with -ENOENT, since they assume that 0 means the module was loaded.
> 
> Thanks for doing that, but I note that getting 0 is not assurance
> either. The de-facto best practive for the request_module() call is to
> do your own in place verifier.
> 
> > Incorrectly returning 0 typically causes unnecessary work (checking again
> > whether the module's functionality is available) or misleading log messages.
> 
> Yes but returning 0 cannot be relied upon today for assuming the module
> is loaded. *If* we revisit that decision and want the kernel to do a
> generic verifier, then yes, we can get rid of all the caller specific
> verfifiers, but not today.
> 

Sure, I understand all that; I think we're actually on the same page.  Even if
we make the return value of request_module() completely correct, nothing stops
another process from loading or unloading the module immediately afterwards.

However, callers do sometimes use the return value opportunisticly, like to log
an appropriate message or to return early if module loading failed.  Those seem
like relatively appropriate uses.  The thing which you really can't do, which I
didn't see anyone doing, is use 'ret == 0' as a signal to go ahead and run code
that will crash if the module has been unloaded already.

- Eric
