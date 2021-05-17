Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7443838B0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343813AbhEQP7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345965AbhEQP5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B33C60FEF;
        Mon, 17 May 2021 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621266992;
        bh=PrF7f5VN9tCcu2teuHhH/cs8NF3a28IG7J9WaRb1b/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3gU/V3jHg8vYGS99PHnm0+HGaF81Si2hwHeCcnxh6QhTMk6xYxAtGLikuw5OCYX6
         vDbIFWI9wVj/Rvb2lHZ+tKxoNvRFTrNWuEhgzQ4HSRQtqs2V5ove9idT2ya1sl1Ebg
         zFuDJRbF6j22zNCc+KKSMQC1y/nTQ7KFs0pGtKzo=
Date:   Mon, 17 May 2021 16:51:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 123/363] watchdog: cleanup handling of false
 positives
Message-ID: <YKKDCRFOKHjPRrRz@kroah.com>
References: <20210517140302.508966430@linuxfoundation.org>
 <20210517140306.783130885@linuxfoundation.org>
 <YKJ+INpik2i9IhZN@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKJ+INpik2i9IhZN@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 04:30:56PM +0200, Petr Mladek wrote:
> On Mon 2021-05-17 15:59:49, Greg Kroah-Hartman wrote:
> > From: Petr Mladek <pmladek@suse.com>
> > 
> > [ Upstream commit 9bf3bc949f8aeefeacea4b1198db833b722a8e27 ]
> > 
> > Commit d6ad3e286d2c ("softlockup: Add sched_clock_tick() to avoid kernel
> > warning on kgdb resume") introduced touch_softlockup_watchdog_sync().
> 
> [...]
> 
> > Make the code more straightforward:
> > 
> > 1. Always call kvm_check_and_clear_guest_paused() at the very
> >    beginning to handle PVCLOCK_GUEST_STOPPED. It touches the watchdog
> >    when the quest did sleep.
> > 
> > 2. Handle the situation when the watchdog has been touched
> >    (SOFTLOCKUP_DELAY_REPORT is set).
> > 
> >    Call sched_clock_tick() when touch_*sync() variant was used. It makes
> >    sure that the timestamp will be up to date even when it has been
> >    touched in atomic context or quest did sleep.
> > 
> > As a result, kvm_check_and_clear_guest_paused() is called on a single
> > location.  And the right timestamp is always set when returning from the
> > timer callback.
> > 
> > Link: https://lkml.kernel.org/r/20210311122130.6788-7-pmladek@suse.com
> 
> Please, remove this patch from the stable backport. It might
> cause false softlockup reports, see
> https://lore.kernel.org/r/20210517140612.222750-1-senozhatsky@chromium.org

Now dropped, thanks.

greg k-h
