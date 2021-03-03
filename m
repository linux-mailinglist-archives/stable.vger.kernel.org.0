Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D503432BC09
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377009AbhCCNi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:38:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239044AbhCCBic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 20:38:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63B7564E4A;
        Wed,  3 Mar 2021 01:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614735336;
        bh=2bfQz+8L2wraD08uxXiGwDU+5COtVm0HVld3OsReDOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqD+LFXGP7QrtSNPJ8IyM18blK8XL/KCHrx1ShuUuawsIVVWMphdp7Y6d18sZUBMO
         I1voHk2P81NyljpAu9kIeqvxPIgVwkQkDEyrQKrKseF+4Lx/wIHugGR4/BBD/KNxX/
         s4TmnyHbyjjEqrq32Slr+b7Imc58UXlgU92J+tRhq3rWhuxHidmRBpPWaUdaTtAVy0
         5EpoA3a/Oz4Grc5HfipY9omGnx1Z0Q07HgDByEYG6O8lQEuLFhPFkUL5/6aX+Nzcl/
         x4RgxC23l8uFr1/PdFtamrk3/iIMSnTp6G+AgKVl4XVo91xjenjz8xQoA9qmNdRxc6
         QrxBjLQEnz9XQ==
Date:   Wed, 3 Mar 2021 02:35:33 +0100
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
Message-ID: <20210303013533.GA102493@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
 <20210302014829.GK2696@paulmck-ThinkPad-P72>
 <20210302123444.GA97498@lothringen>
 <20210302181729.GN2696@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302181729.GN2696@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 10:17:29AM -0800, Paul E. McKenney wrote:
> On Tue, Mar 02, 2021 at 01:34:44PM +0100, Frederic Weisbecker wrote:
> 
> OK, how about if I queue a temporary commit (shown below) that just
> calls out the first scenario so that I can start testing, and you get
> me more detail on the second scenario?  I can then update the commit.

Sure, meanwhile here is an attempt for a nocb_bypass_timer based
scenario, it's overly hairy and perhaps I picture more power
in the hands of callbacks advancing on nocb_cb_wait() than it
really has:


0.          CPU 0's ->nocb_cb_kthread just called rcu_do_batch() and
            executed all the ready callbacks. Its segcblist is now
            entirely empty. It's preempted while calling local_bh_enable().

1.          A new callback is enqueued on CPU 0 with IRQs enabled. So
            the ->nocb_gp_kthread for CPU 0-2's is awaken. Then a storm
            of callbacks enqueue follows on CPU 0 and even reaches the
            bypass queue. Note that ->nocb_gp_kthread is also associated
            with CPU 0.

2.          CPU 0 queues one last bypass callback.

3.          The ->nocb_gp_kthread wakes up and associates a grace period
            with the whole queue of regular callbacks on CPU 0. It also
            tries to flush the bypass queue of CPU 0 but the bypass lock
            is contended due to the concurrent enqueuing on the previous
            step 2, so the flush fails.

4.          This ->nocb_gp_kthread arms its ->nocb_bypass_timer and goes
            to sleep waiting for the end of this future grace period.

5.          This grace period elapses before the ->nocb_bypass_timer timer
            fires. This is normally improbably given that the timer is set
            for only two jiffies, but timers can be delayed.  Besides, it
            is possible that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.

6.          The grace period ends, so rcu_gp_kthread awakens the
            ->nocb_gp_kthread but it doesn't get a chance to run on a CPU
            before a while.

7.          CPU 0's ->nocb_cb_kthread get back to the CPU after its preemption.
            As it notices the new completed grace period, it advances the callbacks
            and executes them. Then it gets preempted again on local_bh_enabled().

8.          A new callback enqueue on CPU 0 flushes itself the bypass queue
            because CPU 0's ->nocb_nobypass_count < nocb_nobypass_lim_per_jiffy.

9.          CPUs from other ->nocb_gp_kthread groups (above CPU 2) initiate and
            elapse a few grace periods. CPU 0's ->nocb_gp_kthread still hasn't
            got an opportunity to run on a CPU and its ->nocb_bypass_timer still
            hasn't fired.

10.         CPU 0's ->nocb_cb_kthread wakes up from preemption. It notices the
            new grace periods that have elapsed, advance all the callbacks and
            executes them. Then it goes to sleep waiting for invocable callbacks.

11.         CPU 0 enqueues a new callback with interrupts disabled, and
            defers awakening its ->nocb_gp_kthread even though ->nocb_gp_sleep
            is actually false. It therefore queues its rcu_data structure's
            ->nocb_timer. At this point, CPU 0's rdp->nocb_defer_wakeup is
            RCU_NOCB_WAKE.

12.         The ->nocb_bypass_timer finally fires! It doesn't wake up
            ->nocb_gp_kthread because it's actually awaken already.
            But it cancels CPU 0's ->nocb_timer armed at 11. Yet it doesn't
            re-initialize CPU 0's ->nocb_defer_wakeup which stays with the
            stale RCU_NOCB_WAKE value. So CPU 0's->nocb_defer_wakeup and
            its ->nocb_timer are now desynchronized.
            
13.         The ->nocb_gp_kthread finally runs. It cancels the ->nocb_bypass_timer
            which has already fired. It sees the new callback on CPU 0 and
            associate it with a new grace period then sleep on it.
            
14.         The grace period elapses, rcu_gp_kthread wakes up ->nocb_gb_kthread
            which wakes up CPU 0's->nocb_cb_kthread which runs the callback.
            Both ->nocb_gp_kthread and CPU 0's->nocb_cb_kthread now wait for new
            callbacks.
            
15.         CPU 0 enqueues another callback, again with interrupts
            disabled so it must queue a timer for a deferred wakeup. However
            the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
            incorrectly indicates that a timer is already queued.  Instead,
            CPU 0's ->nocb_timer was cancelled in 12.  CPU 0 therefore fails
            to queue the ->nocb_timer.

16.         CPU 0 has its pending callback and it may go unnoticed until
            some other CPU ever wakes up ->nocb_gp_kthread or CPU 0 ever
            calls an explicit deferred wakeup, for example, during idle entry.


Thanks.
