Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1403C3080B7
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 22:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhA1VqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 16:46:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhA1VqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 16:46:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C2A61477;
        Thu, 28 Jan 2021 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611870324;
        bh=TAG0OFOHqOipkq3N88lV1PsynPlHS4HM/DWLmkOEfYs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=fYDw8YN3bCbgMIXLL1CQ9ypTwmGcKnKBzANNbNz/lPAzUVyglHhlQc7Vz9W8zUpk3
         83v9OEqd6Bw/JR5x/kQNpSTtM+NhQ8xpZXluy6BVVrQWxXVZ300PhbPitgHsXyMIVW
         0pyugV69T1JXM/SjRxtjmiwu0GOXapcrTc9sEkTwbaDhe5bhHq/iMVtGEJcEMHaUQX
         2Pm2PJNzSzn8RWKt7bNYXERx1KyDHdpv5793mA/6+8hYOzpWsG+Sn0y57ZkfpEP5Ng
         PpqdzDfQp7auGOdoaIGAtSKrtk4yLNn+mgXRFGzlx1Y8tAFH/8s79Dfr7aJSw504tX
         LQqZKtZVjmhQA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 9C6CB35237A0; Thu, 28 Jan 2021 13:45:24 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:45:24 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 04/16] rcu/nocb: Only (re-)initialize segcblist when
 needed on CPU up
Message-ID: <20210128214524.GV2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-5-frederic@kernel.org>
 <20210128191228.GQ2743@paulmck-ThinkPad-P72>
 <20210128213413.GC122776@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128213413.GC122776@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 10:34:13PM +0100, Frederic Weisbecker wrote:
> On Thu, Jan 28, 2021 at 11:12:28AM -0800, Paul E. McKenney wrote:
> > On Thu, Jan 28, 2021 at 06:12:10PM +0100, Frederic Weisbecker wrote:
> > > Simply checking if the segcblist is enabled is enough to know if we
> > > need to initialize it or not. It's safe to check within hotplug
> > > machine.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > 
> > Hmmm...
> > 
> > At the start of a CPU-hotplug operation, an incoming CPU's callback
> > list can be in a number of states:
> > 
> > 1.	Disabled and empty.  This is the case when the boot CPU has
> > 	not done call_rcu(), when a non-boot CPU first comes online,
> > 	and when a non-offloaded CPU comes back online.  In this case,
> > 	it is permissible to initialize ->cblist.  Because either the
> > 	CPU is currently running with interrupts disabled (boot CPU)
> > 	or is not yet running at all (other CPUs), it is not necessary
> > 	to acquire ->nocb_lock.
> > 
> > 2.	Disabled and non-empty.  This is the case when the boot CPU has
> > 	done call_rcu().  It is not permissible to initialize ->cblist
> > 	because doing so will leak any callbacks posted by early boot
> > 	invocations of call_rcu().
> 
> I don't think that's possible. In this case __call_rcu() has called
> rcu_segcblist_init() and has enabled the segcblist.

You are right, rcu_segcblist_init() would have been called in that
case and it has: rcu_segcblist_set_flags(rsclp, SEGCBLIST_ENABLED).

> > 	Test for the possibility of leaking by building with
> > 	CONFIG_PROVE_RCU=y and booting with rcupdate.rcu_self_test=1.
> > 
> > 3.	Enabled, whether empty or not.  This is the case when an
> > 	offloaded CPU comes back online.  This is the only case where
> > 	the ->nocb_lock must be held to modify ->cblist.  However,
> > 	it is not necessarily to modify ->cblist because the rcuoc
> > 	kthread is on the job.
> > 
> > So I believe that it is necessary to check for both disabled and empty.
> > But don't take my word for it!  Build with CONFIG_PROVE_RCU=y and boot
> > with rcupdate.rcu_self_test=1.  ;-)
> 
> I'm trying that :-)

Even better!

							Thanx, Paul
