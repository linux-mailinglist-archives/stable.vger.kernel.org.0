Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7241A2BE9
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 00:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgDHWgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 18:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgDHWgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 18:36:05 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9A920730;
        Wed,  8 Apr 2020 22:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586385364;
        bh=xLXX5fEXFLevP/kGawYAXZigliHWwYZ4ZptumkLtJo0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=wEXrrXj4cNQCCTiuMQUiNUw6HMzqr3n08ODUHqwddapfqOUmsV3O4N5qtigJ2xoi0
         O/yQ+YVfFB4+7Kqg+ZhNELDoIJ7G1SNReILT4E1ofhJOrGG0VY9IF9EsIc+dSEzLc+
         wLI2HhymtPEeBuw/eguJhtSuX5uudAekGRHSOx/w=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 8B1523523234; Wed,  8 Apr 2020 15:36:04 -0700 (PDT)
Date:   Wed, 8 Apr 2020 15:36:04 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
Message-ID: <20200408223604.GA2799@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
 <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <158627540139.8918.10102358634447361335@build.alporthouse.com>
 <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
 <158628265081.8918.1825514020221532657@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158628265081.8918.1825514020221532657@build.alporthouse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 07:04:10PM +0100, Chris Wilson wrote:
> Quoting Linus Torvalds (2020-04-07 18:28:34)
> > On Tue, Apr 7, 2020 at 9:04 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:

[ . . . ]

> There's some more shutting up required for KCSAN to bring the noise down
> to usable levels which I hope has been done so I don't have to argue for
> it, such as
> 
> diff --git a/include/linux/timer.h b/include/linux/timer.h
> index 1e6650ed066d..c7c8dd89f279 100644
> --- a/include/linux/timer.h
> +++ b/include/linux/timer.h
> @@ -164,7 +164,7 @@ static inline void destroy_timer_on_stack(struct timer_list *timer) { }
>   */
>  static inline int timer_pending(const struct timer_list * timer)
>  {
> -	return timer->entry.pprev != NULL;
> +	return READ_ONCE(timer->entry.pprev) != NULL;

This one is in mainline, courtesy of Eric Dumazet, though in a different
form.

The rest are still TBD.

							Thanx, Paul

>  }
> 
>  extern void add_timer_on(struct timer_list *timer, int cpu);
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 5352ce50a97e..7461b3f33629 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -565,8 +565,9 @@ bool mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner,
>  		/*
>  		 * Use vcpu_is_preempted to detect lock holder preemption issue.
>  		 */
> -		if (!owner->on_cpu || need_resched() ||
> -				vcpu_is_preempted(task_cpu(owner))) {
> +		if (!READ_ONCE(owner->on_cpu) ||
> +		    need_resched() ||
> +		    vcpu_is_preempted(task_cpu(owner))) {
>  			ret = false;
>  			break;
>  		}
> @@ -602,7 +603,7 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
>  	 * on cpu or its cpu is preempted
>  	 */
>  	if (owner)
> -		retval = owner->on_cpu && !vcpu_is_preempted(task_cpu(owner));
> +		retval = READ_ONCE(owner->on_cpu) && !vcpu_is_preempted(task_cpu(owner));
>  	rcu_read_unlock();
> 
>  	/*
> diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
> index 1f7734949ac8..4a81fba4cf70 100644
> --- a/kernel/locking/osq_lock.c
> +++ b/kernel/locking/osq_lock.c
> @@ -75,7 +75,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
>  		 * wait for either @lock to point to us, through its Step-B, or
>  		 * wait for a new @node->next from its Step-C.
>  		 */
> -		if (node->next) {
> +		if (READ_ONCE(node->next)) {
>  			next = xchg(&node->next, NULL);
>  			if (next)
>  				break;
> @@ -154,7 +154,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
>  	 */
> 
>  	for (;;) {
> -		if (prev->next == node &&
> +		if (READ_ONCE(prev->next) == node &&
>  		    cmpxchg(&prev->next, node, NULL) == node)
>  			break;
> 
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index 0d9b6be9ecc8..eef4835cecf2 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -650,7 +650,7 @@ static inline bool owner_on_cpu(struct task_struct *owner)
>  	 * As lock holder preemption issue, we both skip spinning if
>  	 * task is not on cpu or its cpu is preempted
>  	 */
> -	return owner->on_cpu && !vcpu_is_preempted(task_cpu(owner));
> +	return READ_ONCE(owner->on_cpu) && !vcpu_is_preempted(task_cpu(owner));
>  }
> 
>  static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem,
> 
