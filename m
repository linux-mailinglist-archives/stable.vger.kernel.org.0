Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A6A2EAB4E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 13:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbhAEM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 07:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbhAEM6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 07:58:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0950120735;
        Tue,  5 Jan 2021 12:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609851445;
        bh=PjZCp+WbJeJvG7JPyMOA/1h5BNZ4V2uZmwy+JY5B3Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVAQffjy0pEWL2oYDH0CXbDUGtoZWTILrr/mfxxVZJmj9OrU3DDyjFC9BgHsYDGIn
         pJdUwJCgH383JYXwU84OqarYnVJ5JD/72ydgZLpT0XFJ+AndNlmwP48Cpjk5jgmApR
         bqhvA985FXbXyNOwbpPR0vvOqEX9Xi705w1E/kWbNJSBa269u3uULFVpx/CAsPLQGH
         nSlZ3WraHLuz/X7bHbtTOwmeQcJctG3A2D/TUttHCKlVhLZgRcv45Ft/YQajndySNV
         nf3jJ26rzhNMhybuZFHzK3QAeWZuFt4Xo1n+hBx4RZOSvfgz8bHVkO4tCrHgxyvt6f
         FNcKDMBC0xB1A==
Date:   Tue, 5 Jan 2021 13:57:22 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] sched/idle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <20210105125722.GA68490@lothringen>
References: <20210104152058.36642-1-frederic@kernel.org>
 <20210104152058.36642-2-frederic@kernel.org>
 <20210105095503.GF3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105095503.GF3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 10:55:03AM +0100, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 04:20:55PM +0100, Frederic Weisbecker wrote:
> > Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> > kthread (rcuog) to be serviced.
> > 
> > Usually a wake up happening while running the idle task is spotted in
> > one of the need_resched() checks carefully placed within the idle loop
> > that can break to the scheduler.
> 
> Urgh, this is horrific and fragile :/ You having had to audit and fix a
> number of rcu_idle_enter() callers should've made you realize that
> making rcu_idle_enter() return something would've been saner.
> 
> Also, I might hope that when RCU does do that wakeup, it will not have
> put RCU in idle mode? So it is a natural 'fail' state for
> rcu_idle_enter(), *sigh* it continues to put RCU to sleep, so that needs
> fixing too.

Heh, yes you're right, that looks saner.

> 
> I'm thinking that rcu_user_enter() will have the exact same problem? Did
> you audit that?

Yes and I wanted to fix it seperately since it's a bit harder to fix because
we are past the last need_resched() check, all syscall exit works, lockdep
hardirqs on entry prep, tracing hardirqs on, etc... I need to manage to
rollback safely and cleanly.

Unless I can decouple the wakeup from rcu_user_enter() and put it around the
exit_to_user_mode_loop(). But then I must make sure that call_rcu() isn't called
afterward.

> 
> Something like the below, combined with a fixup for all callers (which
> the compiler will help us find thanks to __must_check).

Right, I just need to make sure that the wake up is local as the kthread
awaken can be queued anywhere. But a simple need_resched() check after the
wake up should be fine to get that.

Thanks.
