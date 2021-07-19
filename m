Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844653CCC13
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 03:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhGSB4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 21:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhGSB4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Jul 2021 21:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A7A6101E;
        Mon, 19 Jul 2021 01:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626659593;
        bh=GYBuop9qpLcVug/DJr2XcYTGfTFztJPHFoMtB+R8IyM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=lzfp1xKh+lqP0S4ywihx2NGS/TyZK1whI0V1SnVScfApXQlWsZgweLgd1sRXViMBd
         K4L5Cn8+snuCKroNpstGiKYHWW4XTGkN6wgukG6empMjzcMDJfgDmP87yHOpLB5eyR
         og5qz7wRaeCOj1WbKZQMa1W0+H8JvGYATouQgHXmQ9MypfnCRx36qgZZKehOZbySLE
         8mWCEZVy1RP0ZFif7V+rkXO4zNdGLIPWzP1qqQtbzUBHBvKy/5U/oIoap33rix7ufd
         7W+0Xxhyhcr+pfMyv9sXHh54NIJmvc7I5S/bMazWBfuV4iwDCCyQiVk05tK2LER4Dv
         xI8qrAL//1GCA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 74CA95C2BEE; Sun, 18 Jul 2021 18:53:13 -0700 (PDT)
Date:   Sun, 18 Jul 2021 18:53:13 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPSweHyCrD2q2Pue@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 18, 2021 at 11:51:36PM +0100, Matthew Wilcox wrote:
> On Sun, Jul 18, 2021 at 02:59:14PM -0700, Paul E. McKenney wrote:
> > > > https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=_Eh_1k
> > > > EHLHA@mail.gmail.com/
> > 
> > But this one does show this warning in v5.12.17:
> > 
> > 	WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);
> > 
> > This is in rcu_note_context_switch(), and could be caused by something
> > like a schedule() within an RCU read-side critical section.  This would
> > of course be RCU-usage bugs, given that you are not permitted to block
> > within an RCU read-side critical section.
> > 
> > I suggest checking the functions in the stack trace to see where the
> > rcu_read_lock() is hiding.  CONFIG_PROVE_LOCKING might also be helpful.
> 
> I'm not sure I see it in this stack trace.
> 
> Is it possible that there's something taking the rcu read lock in an
> interrupt handler, then returning from the interrupt handler without
> releasing the rcu lock?  Do we have debugging that would fire if
> somebody did this?

Lockdep should complain, but in the absence of lockdep I don't know
that anything would gripe in this situation.

Also, this is a preemptible kernel, so it is possible to trace
__rcu_read_lock(), if that helps.

							Thanx, Paul
