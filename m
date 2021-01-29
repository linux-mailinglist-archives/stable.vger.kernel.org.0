Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F730825C
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 01:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhA2A1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 19:27:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhA2A1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 19:27:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89EB564DDB;
        Fri, 29 Jan 2021 00:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611880017;
        bh=37/4dwIayKxfGhaawfStZ7mP4mcZJd6G3Au2nKjiNKI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Zr8qhI7neRKAtt6clEGnFiKmZ3BRx2F6ulovIhtB8cPXbRYCNGvPAcz9bde3nyZyE
         AJ9ZDvQcpLDn3rzffRkPKhJcXxckYLfhWjgGn9DryOug8gg30dg/I8wQi105vpzKzG
         n35BHXwe+RsnvAo+q2wyxP0rWiUILc8qgsilpdel3lopld8eD4Fwmbb/RsCviwmApb
         dWwNoYN2mYcjKa88vzSmtuh8RRguyPJ0wchBXKRU1R9i2WFdHor/hL232D5BnZUK0H
         xfXM+5My7USZX3wMwDDACfCTh5pc6wPgEntPtOdzVfj+FQwf1FbVSqTmKIK4vMfuKO
         UvKC6rMrKUVtw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 423BF35237A0; Thu, 28 Jan 2021 16:26:57 -0800 (PST)
Date:   Thu, 28 Jan 2021 16:26:57 -0800
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
Message-ID: <20210129002657.GA16372@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-5-frederic@kernel.org>
 <20210128191228.GQ2743@paulmck-ThinkPad-P72>
 <20210128213413.GC122776@lothringen>
 <20210128214524.GV2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128214524.GV2743@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 01:45:24PM -0800, Paul E. McKenney wrote:
> On Thu, Jan 28, 2021 at 10:34:13PM +0100, Frederic Weisbecker wrote:
> > On Thu, Jan 28, 2021 at 11:12:28AM -0800, Paul E. McKenney wrote:
> > > On Thu, Jan 28, 2021 at 06:12:10PM +0100, Frederic Weisbecker wrote:
> > > > Simply checking if the segcblist is enabled is enough to know if we
> > > > need to initialize it or not. It's safe to check within hotplug
> > > > machine.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > > 
> > > Hmmm...
> > > 
> > > At the start of a CPU-hotplug operation, an incoming CPU's callback
> > > list can be in a number of states:
> > > 
> > > 1.	Disabled and empty.  This is the case when the boot CPU has
> > > 	not done call_rcu(), when a non-boot CPU first comes online,
> > > 	and when a non-offloaded CPU comes back online.  In this case,
> > > 	it is permissible to initialize ->cblist.  Because either the
> > > 	CPU is currently running with interrupts disabled (boot CPU)
> > > 	or is not yet running at all (other CPUs), it is not necessary
> > > 	to acquire ->nocb_lock.
> > > 
> > > 2.	Disabled and non-empty.  This is the case when the boot CPU has
> > > 	done call_rcu().  It is not permissible to initialize ->cblist
> > > 	because doing so will leak any callbacks posted by early boot
> > > 	invocations of call_rcu().
> > 
> > I don't think that's possible. In this case __call_rcu() has called
> > rcu_segcblist_init() and has enabled the segcblist.
> 
> You are right, rcu_segcblist_init() would have been called in that
> case and it has: rcu_segcblist_set_flags(rsclp, SEGCBLIST_ENABLED).
> 
> > > 	Test for the possibility of leaking by building with
> > > 	CONFIG_PROVE_RCU=y and booting with rcupdate.rcu_self_test=1.
> > > 
> > > 3.	Enabled, whether empty or not.  This is the case when an
> > > 	offloaded CPU comes back online.  This is the only case where
> > > 	the ->nocb_lock must be held to modify ->cblist.  However,
> > > 	it is not necessarily to modify ->cblist because the rcuoc
> > > 	kthread is on the job.
> > > 
> > > So I believe that it is necessary to check for both disabled and empty.
> > > But don't take my word for it!  Build with CONFIG_PROVE_RCU=y and boot
> > > with rcupdate.rcu_self_test=1.  ;-)
> > 
> > I'm trying that :-)
> 
> Even better!

I applied this patch (with the usual wordsmithing as shown below), then
ran this:

tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 2 --configs "TREE05" --bootargs "rcu_nocbs=0-7" --trust-make

The resulting console.log file says "Running RCU self tests" and the test
runs to completion without complaint.  So good show!

								Thanx, Paul

------------------------------------------------------------------------

commit 0a43799de756a486e45eba8d9d4286a577e746cd
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Thu Jan 28 18:12:10 2021 +0100

    rcu/nocb: Only (re-)initialize segcblist when needed on CPU up
    
    At the start of a CPU-hotplug operation, the incoming CPU's callback
    list can be in a number of states:
    
    1.      Disabled and empty.  This is the case when the boot CPU has
            not invoked call_rcu(), when a non-boot CPU first comes online,
            and when a non-offloaded CPU comes back online.  In this case,
            it is both necessary and permissible to initialize ->cblist.
            Because either the CPU is currently running with interrupts
            disabled (boot CPU) or is not yet running at all (other CPUs),
            it is not necessary to acquire ->nocb_lock.
    
            In this case, initialization is required.
    
    2.      Disabled and non-empty.  This cannot occur, because early boot
            call_rcu() invocations enable the callback list before enqueuing
            their callback.
    
    3.      Enabled, whether empty or not.  In this case, the callback
            list has already been initialized.  This case occurs when the
            boot CPU has executed an early boot call_rcu() and also when
            an offloaded CPU comes back online.  In both cases, there is
            no need to initialize the callback list: In the boot-CPU case,
            the CPU has not (yet) gone offline, and in the offloaded case,
            the rcuo kthreads are taking care of business.
    
            Because it is not necessary to initialize the callback list,
            it is also not necessary to acquire ->nocb_lock.
    
    Therefore, checking if the segcblist is enabled suffices.  This commit
    therefore initializes the callback list at rcutree_prepare_cpu() time
    only if that list is disabled.
    
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Lai Jiangshan <jiangshanlai@gmail.com>
    Cc: Joel Fernandes <joel@joelfernandes.org>
    Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 00059df..70ddc33 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4064,14 +4064,13 @@ int rcutree_prepare_cpu(unsigned int cpu)
 	rdp->dynticks_nesting = 1;	/* CPU not up, no tearing. */
 	rcu_dynticks_eqs_online();
 	raw_spin_unlock_rcu_node(rnp);		/* irqs remain disabled. */
+
 	/*
-	 * Lock in case the CB/GP kthreads are still around handling
-	 * old callbacks.
+	 * Only non-NOCB CPUs that didn't have early-boot callbacks need to be
+	 * (re-)initialized.
 	 */
-	rcu_nocb_lock(rdp);
-	if (rcu_segcblist_empty(&rdp->cblist)) /* No early-boot CBs? */
+	if (!rcu_segcblist_is_enabled(&rdp->cblist))
 		rcu_segcblist_init(&rdp->cblist);  /* Re-enable callbacks. */
-	rcu_nocb_unlock(rdp);
 
 	/*
 	 * Add CPU to leaf rcu_node pending-online bitmask.  Any needed
