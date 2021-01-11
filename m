Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DA22F11EB
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 12:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbhAKLvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 06:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbhAKLvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 06:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A351224BD;
        Mon, 11 Jan 2021 11:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610365829;
        bh=NP9L6a6Mu9+yVb7bcao5sARkOO84Twaf5gsOxbxTCz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8xIUnRGbG+eiLmhAKkTAsjfXbTYgQ8uYAVSl4bxG+leFEqHaXhtNHSdrT/Wg1Qby
         p4mox/VJcbAsuChYQKfGUT5MPWDclBa+Vs7ZVCHgzgwZTMKAXZrYdMnyvnA5WocTZq
         WIsSg74NkVIy04joBEPJ+vveTpsaKvpRXhyxJqeiQfpb8QAKII/LGOxXH8yURCs6ir
         pL7MdfM1R4DPUVN7j5G+5GUEv09h1wMLcbtLNnDgfjJ0m6u+F5i39hpxXXUPFKAdIr
         mhkehV98MT98x0YSJ+QMhYPW1hMtXk66Ehc1HAUArzwLoGYfiQTX9DHFDuC2fsyzGI
         3CleWD3eEwxMw==
Date:   Mon, 11 Jan 2021 12:50:26 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] entry: Explicitly flush pending rcuog wakeup
 before last rescheduling points
Message-ID: <20210111115026.GC242508@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-6-frederic@kernel.org>
 <20210111004014.GA242508@lothringen>
 <20210111051318.GZ2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111051318.GZ2743@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 09:13:18PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 11, 2021 at 01:40:14AM +0100, Frederic Weisbecker wrote:
> > On Sat, Jan 09, 2021 at 03:05:33AM +0100, Frederic Weisbecker wrote:
> > > Following the idle loop model, cleanly check for pending rcuog wakeup
> > > before the last rescheduling point on resuming to user mode. This
> > > way we can avoid to do it from rcu_user_enter() with the last resort
> > > self-IPI hack that enforces rescheduling.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar<mingo@kernel.org>
> > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  kernel/entry/common.c |  6 ++++++
> > >  kernel/rcu/tree.c     | 12 +++++++-----
> > >  2 files changed, 13 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> > > index 378341642f94..8f3292b5f9b7 100644
> > > --- a/kernel/entry/common.c
> > > +++ b/kernel/entry/common.c
> > > @@ -178,6 +178,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
> > >  		/* Architecture specific TIF work */
> > >  		arch_exit_to_user_mode_work(regs, ti_work);
> > >  
> > > +		/* Check if any of the above work has queued a deferred wakeup */
> > > +		rcu_nocb_flush_deferred_wakeup();
> > 
> > So this needs to be moved to the IRQs disabled section, just a few lines later,
> > otherwise preemption may schedule another task that in turn do call_rcu() and create
> > new deferred wake up (thank Paul for the warning). Not to mention moving to
> > another CPU with its own deferred wakeups to flush...
> > 
> > I'll fix that for the next version.
> 
> Ah, so it was not just my laptop dying, then!  ;-)

Note that it fixes the "smp_processor_id() in preemptible" warnings you
reported but it shouldn't fix the other issues.
