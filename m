Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDE18515D
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMVrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 17:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgCMVrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Mar 2020 17:47:53 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6299E2074E;
        Fri, 13 Mar 2020 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584136072;
        bh=xwtCKX2P8MxJJx8X4zwf2g8PUIkfnSRKtARj+udGAwc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=KGqYDl+7TcFX2aXTi3OMKJXCXPVbEl3pjXaQ5B81LOKoMS600NMQo+SfCmwU5vFlo
         ZQdcFM1oA2j6t8A5Pyi3dr3VKPtmlsoqMIvhGdRPFBAqv2r+Lnt2ztSJkr1vdQ1QJV
         wzUIIjGyWIACnqXdjGOipVp8IyE6sp6qVvUGKSzc=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 3279335226C7; Fri, 13 Mar 2020 14:47:52 -0700 (PDT)
Date:   Fri, 13 Mar 2020 14:47:52 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingo@kernel.org, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, "# 5 . 5 . x" <stable@vger.kernel.org>
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Don't acquire lock in NMI
 handler in rcu_nmi_enter_common()
Message-ID: <20200313214752.GF3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200313024007.GA27492@paulmck-ThinkPad-P72>
 <20200313024046.27622-1-paulmck@kernel.org>
 <20200313035201.GB190951@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313035201.GB190951@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 11:52:01PM -0400, Joel Fernandes wrote:
> On Thu, Mar 12, 2020 at 07:40:45PM -0700, paulmck@kernel.org wrote:
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> > 
> > The rcu_nmi_enter_common() function can be invoked both in interrupt
> > and NMI handlers.  If it is invoked from process context (as opposed
> > to userspace or idle context) on a nohz_full CPU, it might acquire the
> > CPU's leaf rcu_node structure's ->lock.  Because this lock is held only
> > with interrupts disabled, this is safe from an interrupt handler, but
> > doing so from an NMI handler can result in self-deadlock.
> > 
> > This commit therefore adds "irq" to the "if" condition so as to only
> > acquire the ->lock from irq handlers or process context, never from
> > an NMI handler.
> 
> I think Peter's new lockdep changes for NMI would also catch this issue.
> 
> > 
> > Fixes: 5b14557b073c ("rcu: Avoid tick_dep_set_cpu() misordering")
> 
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Applied, thank you!!!

							Thanx, Paul

> thanks,
> 
>  - Joel
> 
> 
> > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: <stable@vger.kernel.org> # 5.5.x
> > ---
> >  kernel/rcu/tree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index d3f52c3..f7d3e48 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -825,7 +825,7 @@ static __always_inline void rcu_nmi_enter_common(bool irq)
> >  			rcu_cleanup_after_idle();
> >  
> >  		incby = 1;
> > -	} else if (tick_nohz_full_cpu(rdp->cpu) &&
> > +	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
> >  		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
> >  		   READ_ONCE(rdp->rcu_urgent_qs) &&
> >  		   !READ_ONCE(rdp->rcu_forced_tick)) {
> > -- 
> > 2.9.5
> > 
