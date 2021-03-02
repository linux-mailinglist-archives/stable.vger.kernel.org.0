Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8413D32AFE8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbhCCA3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444876AbhCBMle (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D5C964F3C;
        Tue,  2 Mar 2021 12:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614688487;
        bh=vlKIJY5iGYuDx0D/+TOPIhzkP8FYk7iynomdRFUC8Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFpUN6D0ZqW7VHJRs0LylNTpImF5qCmAe0mJhKf8o4jyJFh/9QMzIzZktD8WQNyrh
         ZJvwvGvh7lR5SPSo4GMqyRp4igI3xjqBClNSkPDVtJwAdB/PkQGJylwfxvffB+xiom
         e3W/TvjEivIKL+ZNCMh5EjnLduBKPbEY0cPLDDLyGQrXBFWq4hoO7zMSxGkguBpmUh
         vpEl7WXTjgJ953inRyenEyfdZXQSMkIExxNMaak9OMZWlBpusZKI9Sn2ETD8V9icuh
         8lYcfDz5zJRfGc/P3/lBW5bLFog54gLVVqAZfbwyW4KwhQCDMEzdUzTUgwI35cLTRL
         UfZXACjyQ5Ylg==
Date:   Tue, 2 Mar 2021 13:34:44 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 01/13] rcu/nocb: Fix potential missed nocb_timer rearm
Message-ID: <20210302123444.GA97498@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
 <20210302014829.GK2696@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302014829.GK2696@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 05:48:29PM -0800, Paul E. McKenney wrote:
> On Wed, Feb 24, 2021 at 11:06:06PM +0100, Frederic Weisbecker wrote:
> > On Wed, Feb 24, 2021 at 10:37:09AM -0800, Paul E. McKenney wrote:
> > > On Tue, Feb 23, 2021 at 01:09:59AM +0100, Frederic Weisbecker wrote:
> > > > Two situations can cause a missed nocb timer rearm:
> > > > 
> > > > 1) rdp(CPU A) queues its nocb timer. The grace period elapses before
> > > >    the timer get a chance to fire. The nocb_gp kthread is awaken by
> > > >    rdp(CPU B). The nocb_cb kthread for rdp(CPU A) is awaken and
> > > >    process the callbacks, again before the nocb_timer for CPU A get a
> > > >    chance to fire. rdp(CPU A) queues a callback and wakes up nocb_gp
> > > >    kthread, cancelling the pending nocb_timer without resetting the
> > > >    corresponding nocb_defer_wakeup.
> > > 
> > > As discussed offlist, expanding the above scenario results in this
> > > sequence of steps:
> 
> I renumbered the CPUs, since the ->nocb_gp_kthread would normally be
> associated with CPU 0.  If the first CPU to enqueue a callback was also
> CPU 0, nocb_gp_wait() might clear that CPU's ->nocb_defer_wakeup, which
> would prevent this scenario from playing out.  (But admittedly only if
> some other CPU handled by this same ->nocb_gp_kthread used its bypass.)

Ok good point.

> 
> > > 1.	There are no callbacks queued for any CPU covered by CPU 0-2's
> > > 	->nocb_gp_kthread.
> 
> And ->nocb_gp_kthread is associated with CPU 0.
> 
> > > 2.	CPU 1 enqueues its first callback with interrupts disabled, and
> > > 	thus must defer awakening its ->nocb_gp_kthread.  It therefore
> > > 	queues its rcu_data structure's ->nocb_timer.
> 
> At this point, CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.

Right.

> > > 7.	The grace period ends, so rcu_gp_kthread awakens the
> > > 	->nocb_gp_kthread, which in turn awakens both CPU 1's and
> > > 	CPU 2's ->nocb_cb_kthread.
> 
> And then ->nocb_cb_kthread sleeps waiting for more callbacks.

Yep

> > I managed to recollect some pieces of my brain. So keep the above but
> > let's change the point 10:
> > 
> > 10.	CPU 1 enqueues its second callback, this time with interrupts
> >  	enabled so it can wake directly	->nocb_gp_kthread.
> > 	It does so with calling __wake_nocb_gp() which also cancels the
> 
> wake_nocb_gp() in current -rcu, correct?

Heh, right.

> > > So far so good, but why isn't the timer still queued from back in step 2?
> > > What am I missing here?  Either way, could you please update the commit
> > > logs to tell the full story?  At some later time, you might be very
> > > happy that you did.  ;-)
> > > 
> > > > 2) The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
> > > >    the pending "nocb_timer" (note they are not the same timers) for the
> > > >    given rdp without resetting the matching state stored in nocb_defer
> > > >    wakeup.
> 
> Would like to similarly expand this one, or would you prefer to rest your
> case on Case 1) above?

I was about to say that we can skip that one, the changelog will already be
big enough but the "Fixes:" tag refers to the second scenario, since it's the
oldest vulnerable commit AFAICS.

> > > > Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)

Thanks.
