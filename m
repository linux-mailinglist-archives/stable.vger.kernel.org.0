Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EAF33D558
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 15:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhCPOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 10:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235317AbhCPOCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 10:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2ECA65053;
        Tue, 16 Mar 2021 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615903320;
        bh=FZlNhG0GbjjaNOwyUjz7LHRtAsYWpow/g2cDQKBuMpU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=M4tVvyoJ2HYEVe7OYjXMQ334CmYs4EXr2j/Ui8RoA9OfMuGhfm4aNEKQPTq4SZ/ij
         Lsp1m1QcIRRbLM7GSVxvrMNqVbjtMHDydGV7hZB5t46Ol+pZjia3Wcf3CBLuf6ji15
         EXMVkT2OakNTnF2nrXMUZrINh5ZkbPTRPit+pYRyCm5ZsCFr5ACUFz7BoJORuqj/AL
         kyuJe1SWJVDnvucLqsBq/k5OfwTa6VymGbh3GZ5MsZl0KKdawrtV/BhwyW6V4eyIoU
         WkHAiGG9AQVKSeTenZvIJcELPj/13nQ2X4j/GYN4Azybhk2UZVWewvoCnt7CVBox8l
         m7sKSL/wUC8mA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A1E51352262D; Tue, 16 Mar 2021 07:02:00 -0700 (PDT)
Date:   Tue, 16 Mar 2021 07:02:00 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 12/13] rcu/nocb: Prepare for finegrained deferred wakeup
Message-ID: <20210316140200.GT2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-13-frederic@kernel.org>
 <20210316030239.GA13675@paulmck-ThinkPad-P72>
 <20210316114526.GA639918@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316114526.GA639918@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 12:45:26PM +0100, Frederic Weisbecker wrote:
> On Mon, Mar 15, 2021 at 08:02:39PM -0700, Paul E. McKenney wrote:
> > On Tue, Feb 23, 2021 at 01:10:10AM +0100, Frederic Weisbecker wrote:
> > > Provide a way to tune the deferred wakeup level we want to perform from
> > > a safe wakeup point. Currently those sites are:
> > > 
> > > * nocb_timer
> > > * user/idle/guest entry
> > > * CPU down
> > > * softirq/rcuc
> > > 
> > > All of these sites perform the wake up for both RCU_NOCB_WAKE and
> > > RCU_NOCB_WAKE_FORCE.
> > > 
> > > In order to merge nocb_timer and nocb_bypass_timer together, we plan to
> > > add a new RCU_NOCB_WAKE_BYPASS that really want to be deferred until
> > > a timer fires so that we don't wake up the NOCB-gp kthread too early.
> > > 
> > > To prepare for that, integrate a wake up level/limit that a callsite is
> > > deemed to perform.
> > 
> > This appears to need the following in order to build for non-NOCB
> > configurations.  I will fold it in and am retesting.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit 55f59dd75a11455cf558fd387fbf9011017dcc8a
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Mon Mar 15 20:00:34 2021 -0700
> > 
> >     squash! rcu/nocb: Prepare for fine-grained deferred wakeup
> >     
> >     [ paulmck: Fix non-NOCB rcu_nocb_need_deferred_wakeup() definition. ]
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 0cc7f68..dfb048e 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2926,7 +2926,7 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
> >  {
> >  }
> >  
> > -static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
> > +static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp, int level)
> >  {
> >  	return false;
> >  }
> 
> Oops thanks, I missed that.

And with this, light rcutorture testing passed.  I hope to pound on it
harder later this week.

							Thanx, Paul
