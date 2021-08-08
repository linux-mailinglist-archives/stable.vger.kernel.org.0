Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F523E3936
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 08:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhHHGrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 02:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhHHGrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 02:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A363E61078;
        Sun,  8 Aug 2021 06:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628405207;
        bh=J+H89kyQcR5dOy0K8Ee87RHxbhy58yZy1lknQsKaTjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XIeiU8k329U0bGQdgPQ1IOzCzQpjS/R11b3QRjPE74OZf1l5KqY6Df6ALeCAM8MDr
         eTQkGRWZapacLyeH2xMqoQUTyeqJGN/1iYUhDNHfxhCUqYUrv/PD9U2zNHkXxNmpqj
         yogU50zoLBC3GSuBC1nK9N2nBKqpYmB4fJZqSUDI=
Date:   Sun, 8 Aug 2021 08:46:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Korty <joe.korty@concurrent-rt.com>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        stable <stable@vger.kernel.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/11] Fix a potential infinite loop in RT futex-pi
 scenarios
Message-ID: <YQ990KMeDFspvGDQ@kroah.com>
References: <20210802134624.1934-1-thunder.leizhen@huawei.com>
 <20210803005325.GA32484@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803005325.GA32484@zipoli.concurrent-rt.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 08:53:25PM -0400, Joe Korty wrote:
> On Mon, Aug 02, 2021 at 09:46:13PM +0800, Zhen Lei wrote:
> > Commit 73d786bd043e "futex: Rework inconsistent rt_mutex/futex_q state"
> > mentions that it could cause an infinite loop, and will fix it in the later
> > patches:
> > bebe5b514345f09 futex: Futex_unlock_pi() determinism
> > cfafcd117da0216 futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
> > 
> > But at the moment they're not backported. In a single-core environment, the
> > probability of triggering is high.
> > 
> > I also backported commit b4abf91047cf ("rtmutex: Make wait_lock irq safe"),
> > it fixes a potential deadlock problem. Although it hasn't actually been
> > triggered in our environment at the moment.
> > 
> > Other patches are used to resolve conflicts or fix problems caused by new
> > patches.
> > 
> > 
> > Anna-Maria Gleixner (1):
> >   rcu: Update documentation of rcu_read_unlock()
> > 
> > Mike Galbraith (1):
> >   futex: Handle transient "ownerless" rtmutex state correctly
> > 
> > Peter Zijlstra (6):
> >   futex: Cleanup refcounting
> >   futex,rt_mutex: Introduce rt_mutex_init_waiter()
> >   futex: Pull rt_mutex_futex_unlock() out from under hb->lock
> >   futex: Rework futex_lock_pi() to use rt_mutex_*_proxy_lock()
> >   futex: Futex_unlock_pi() determinism
> >   futex,rt_mutex: Fix rt_mutex_cleanup_proxy_lock()
> > 
> > Thomas Gleixner (3):
> >   futex: Rename free_pi_state() to put_pi_state()
> >   rtmutex: Make wait_lock irq safe
> >   futex: Avoid freeing an active timer
> > 
> >  include/linux/rcupdate.h        |   4 +-
> >  kernel/futex.c                  | 245 +++++++++++++++++++++-----------
> >  kernel/locking/rtmutex.c        | 185 +++++++++++++-----------
> >  kernel/locking/rtmutex_common.h |   2 +-
> >  4 files changed, 262 insertions(+), 174 deletions(-)
> 
> 
> To all concerned,
> 
> I have verified that this series of patches, when applied
> to 4.4.277, passes the futex-unlock-pi replicator I posted
> to lkml on July 19.
> 
>   Subject: [BUG] 4.4.262: infinite loop in futex_unlock_pi (EAGAIN loop)
> 
> Acked-by: Joe Korty <joe.korty@concurrent-rt.com>
> 

Thanks for testing and the series, all now queued up.

I'll go do a -rc release with just this set of patches in it so that
people can test it well.

greg k-h
