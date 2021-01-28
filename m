Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91CE30807A
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 22:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhA1VYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 16:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhA1VY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 16:24:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED6D764DD8;
        Thu, 28 Jan 2021 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611869021;
        bh=iH6suGr3hIscxS1m9Qt5V6ljMSHvYQ88VlLXlbk5DE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f7Rg5FZmKu0gKfkDG4xWZd1kRacrb0eNOVBuPA+UWZSiXsRqfk4GJlT1iGKcetXKK
         eLuDHzBRcKurkVZDmbSexN9HowOGeiyqj5663qDUCCb52El2f0E0ZlZcbLualnDTxK
         TAK0qz2+VHvZBCFsEbWnJ1cg6Ucl0KiqkGKC1BTANsuReN/zvbVD0jDKuaCZIom7Jx
         SL30Wz8Y5Rdf+ab6D2nDeximq6qVlyFEmBulFVDS9TD9TlNeVk03IBoYvz5ZXrQ8Ex
         f/pgqEgVo3q+Zb0tHAG3hA5kFrgWrsnxd7BSAaqyKgRnalmHGx0y9Vfx1EM7JO623c
         bitR8/8hBpWLA==
Date:   Thu, 28 Jan 2021 22:23:38 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 01/16] rcu/nocb: Fix potential missed nocb_timer rearm
Message-ID: <20210128212338.GB122776@lothringen>
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-2-frederic@kernel.org>
 <20210128184834.GP2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128184834.GP2743@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 10:48:34AM -0800, Paul E. McKenney wrote:
> On Thu, Jan 28, 2021 at 06:12:07PM +0100, Frederic Weisbecker wrote:
> > The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
> > the pending "nocb_timer" (note they are not the same timers) for the
> > given rdp without resetting the matching state stored in nocb_defer
> > wakeup.
> > 
> > As a result, a future call_rcu() on that rdp may be fooled and think the
> > timer is armed when it's not, missing a deferred nocb_gp wakeup.
> > 
> > Fix this with resetting rdp->nocb_defer_wakeup when we disarm the timer.
> > 
> > Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
> > Cc: Stable <stable@vger.kernel.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > Cc: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  kernel/rcu/tree_plugin.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 7e33dae0e6ee..a44f80d7661b 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -1705,6 +1705,8 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
> >  		rcu_nocb_unlock_irqrestore(rdp, flags);
> >  		return false;
> >  	}
> > +
> > +	rdp->nocb_defer_wakeup = RCU_NOCB_WAKE_NOT;
> 
> Given this change, does it make sense to remove the
> setting of ->nocb_defer_wakeup to RCU_NOCB_WAKE_NOT from the
> do_nocb_deferred_wakeup_common() function?

I do it later in "[PATCH 09/16] rcu/nocb: Merge nocb_timer to the rdp leader"

> Does the above assignment need
> to be WRITE_ONCE(), in other words, are all reads of ->nocb_defer_wakeup
> done with either ->nocb_lock or ->nocb_gp_lock held?  (I do not believe
> that this is the case.)

Ah indeed it should probably be done with WRITE_ONCE() because it's read
locklessly on many places.

Thanks.

> 
> 							Thanx, Paul
> 
> >  	del_timer(&rdp->nocb_timer);
> >  	rcu_nocb_unlock_irqrestore(rdp, flags);
> >  	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
> > -- 
> > 2.25.1
> > 
