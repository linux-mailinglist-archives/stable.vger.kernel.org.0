Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91AB32D3F5
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbhCDNMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhCDNM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:12:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3AF864F09;
        Thu,  4 Mar 2021 13:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614863508;
        bh=ndCF6tSrnKvgTwxtBnZae2FWAdb0TvZ1vFMwVKa1nzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qb+4taoNiAHPK6JZ2qwvknQ1tZq0FdCZ5NOqePq9M/n2kecCXQVwc/F+Zp+D4JeDS
         Cx3dzG2JXT5JZXX+OthYECaTYCpwQ1OqUjv1dRhcnAKJJDQuocRHDffJ/ulsGukpMO
         E4fC6IEflEkDDiHELl7wuPPzdOOg/tah/KRWsduQ=
Date:   Thu, 4 Mar 2021 14:11:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Galbraith <efault@gmx.de>
Cc:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futex breakage in 4.9 stable branch
Message-ID: <YEDckK+g7VosvtGK@kroah.com>
References: <161408880177110@kroah.com>
 <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
 <YDygp3WYafzcgt+s@kroah.com>
 <YD0kkNH+I4xyoTwy@decadent.org.uk>
 <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 10:12:56AM +0100, Mike Galbraith wrote:
> On Mon, 2021-03-01 at 18:29 +0100, Ben Hutchings wrote:
> > On Mon, Mar 01, 2021 at 09:07:03AM +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Mar 01, 2021 at 01:13:08AM +0100, Ben Hutchings wrote:
> > > > On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> > > > > I'm announcing the release of the 4.9.258 kernel.
> > > > >
> > > > > All users of the 4.9 kernel series must upgrade.
> > > > >
> > > > > The updated 4.9.y git tree can be found at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
> > > > > and can be browsed at the normal kernel.org git web browser:
> > > > >
> > > >
> > > > The backported futex fixes are still incomplete/broken in this version.
> > > > If I enable lockdep and run the futex self-tests (from 5.10):
> > > >
> > > > - on 4.9.246, they pass with no lockdep output
> > > > - on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
> > > >   lockdep splat
> > > >
> > > > I have a local branch that essentially updates futex and rtmutex in
> > > > 4.9-stable to match 4.14-stable.  With this, the tests pass and lockdep
> > > > is happy.
> > > >
> > > > Unfortunately, that branch has about another 60 commits.
> >
> > I have now rebased that on top of 4.9.258, and there are "only" 39
> > commits.
> >
> > > > Further, the
> > > > more we change futex in 4.9, the more difficult it is going to be to
> > > > update the 4.9-rt branch.  But I don't see any better option available
> > > > at the moment.
> > > >
> > > > Thoughts?
> > >
> > > There were some posted futex fixes for 4.9 (and 4.4) on the stable list
> > > that I have not gotten to yet.
> > >
> > > Hopefully after these are merged (this week), these issues will be
> > > resolved.
> >
> > I'm afraid they are not sufficient.
> >
> > > If not, then yes, they need to be fixed and any help you can provide
> > > would be appreciated.
> > >
> > > As for "difficulty", yes, it's rough, but the changes backported were
> > > required, for obvious reasons :(
> >
> > I had another look at the locking bug and I was able to make a series
> > of 7 commits (on top of the 2 already queued) that is sufficient to
> > make lockdep happy.  But I am not very confident that there won't be
> > other regressions.  I'll send that over shortly.
> 
> This is all I had to do to make 4.4-stable a happy camper again.
> 
> futex: fix 4.4-stable 34c8e1c2c025 backport inspired lockdep complaint
> 
> 1. 34c8e1c2c025 "futex: Provide and use pi_state_update_owner()" was backported
> to stable, leading to the therein assertion that pi_state->pi_mutex.wait_lock
> be held triggering in 4.4-stable.  Fixing that leads to lockdep moan part 2.
> 
> 2: b4abf91047cf "rtmutex: Make wait_lock irq safe" is absent in 4.4-stable, but
> wake_futex_pi() nonetheless managed to acquire an unbalanced raw_spin_lock()
> raw_spin_inlock_irq() pair, which inspires lockdep to moan after aforementioned
> assert has been appeased.
> 
> With this applied, futex tests pass, and no longer inspire lockdep gripeage.
> 
> Not-Signed-off-by: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/futex.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -874,8 +874,12 @@ static void free_pi_state(struct futex_p
>  	 * and has cleaned up the pi_state already
>  	 */
>  	if (pi_state->owner) {
> +		unsigned long flags;
> +
> +		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
>  		pi_state_update_owner(pi_state, NULL);
>  		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
> +		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
>  	}
> 
>  	if (current->pi_state_cache)
> @@ -1406,7 +1410,7 @@ static int wake_futex_pi(u32 __user *uad
>  	if (pi_state->owner != current)
>  		return -EINVAL;
> 
> -	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> +	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
> 
>  	/*
> 

Care to sign-off on it so that if this is correct, I can apply it?  :)

thanks,

greg k-h
