Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3943360EF7
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDOP2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOP2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:28:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A21376115B;
        Thu, 15 Apr 2021 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618500506;
        bh=rcKwsyBG71spLEI7owmKnHtzbC9TKpBz3yV7qSke48I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dhqx9dJtE0XYy7xv/0AUzW2pyMnZVCO3iYLenf7XXHMqIhVNBBBAua+GG/A4Xb+Dp
         GFU1QTekLmOtvcP1sbRsm4YCfDdf4ckcKoXM0awzeLL3ynfKUYDW+U1ER551NXj4cp
         D01HpsZjuuARWkcEpiBd3Zum2KhDYLrkklYhNhb7VYcbxkZ6ETN7W6RTqiFv3tO3D0
         05Ps6ze5kcjpHmJ6jPX83cRGNHqlfULHlUcM2opA5ttIHYZVVW39vamvxNNHc+BmL/
         6ykDd6zJdesew8WZ6BvcU40VGnlshECgb4tuYo1+BPaXxKw6IOd6HJ+nz0NFdo1fua
         OTdV/vnEIZ1bA==
Date:   Thu, 15 Apr 2021 16:28:21 +0100
From:   Will Deacon <will@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ali Saidi <alisaidi@amazon.com>, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, steve.capper@arm.com,
        benh@kernel.crashing.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <20210415152820.GB26439@willie-the-truck>
References: <20210415142552.30916-1-alisaidi@amazon.com>
 <YHhV3n2n4OXzaZBM@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YHhV3n2n4OXzaZBM@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 05:03:58PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 15, 2021 at 02:25:52PM +0000, Ali Saidi wrote:
> > While this code is executed with the wait_lock held, a reader can
> > acquire the lock without holding wait_lock.  The writer side loops
> > checking the value with the atomic_cond_read_acquire(), but only truly
> > acquires the lock when the compare-and-exchange is completed
> > successfully which isn’t ordered. The other atomic operations from this
> > point are release-ordered and thus reads after the lock acquisition can
> > be completed before the lock is truly acquired which violates the
> > guarantees the lock should be making.
> 
> Should be per who? We explicitly do not order the lock acquire store.
> qspinlock has the exact same issue.
> 
> If you look in the git history surrounding spin_is_locked(), you'll find
> 'lovely' things.
> 
> Basically, if you're doing crazy things with spin_is_locked() you get to
> keep the pieces.
> 
> > Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")
> > Signed-off-by: Ali Saidi <alisaidi@amazon.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  kernel/locking/qrwlock.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> > index 4786dd271b45..10770f6ac4d9 100644
> > --- a/kernel/locking/qrwlock.c
> > +++ b/kernel/locking/qrwlock.c
> > @@ -73,8 +73,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
> >  
> >  	/* When no more readers or writers, set the locked flag */
> >  	do {
> > -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> > -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> > +		atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
> > +	} while (atomic_cmpxchg_acquire(&lock->cnts, _QW_WAITING,
> >  					_QW_LOCKED) != _QW_WAITING);
> >  unlock:
> >  	arch_spin_unlock(&lock->wait_lock);
> 
> This doesn't make sense, there is no such thing as a store-acquire. What
> you're doing here is moving the acquire from one load to the next. A
> load we know will load the exact same value.
> 
> Also see Documentation/atomic_t.txt:
> 
>   {}_acquire: the R of the RMW (or atomic_read) is an ACQUIRE
> 
> 
> If anything this code wants to be written like so.
> 
> ---
> 
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index 4786dd271b45..22aeccc363ca 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -60,6 +60,8 @@ EXPORT_SYMBOL(queued_read_lock_slowpath);
>   */
>  void queued_write_lock_slowpath(struct qrwlock *lock)
>  {
> +	u32 cnt;
> +
>  	/* Put the writer into the wait queue */
>  	arch_spin_lock(&lock->wait_lock);
>  
> @@ -73,9 +75,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
>  
>  	/* When no more readers or writers, set the locked flag */
>  	do {
> -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> -					_QW_LOCKED) != _QW_WAITING);
> +		cnt = atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);

I think the issue is that >here< a concurrent reader in interrupt context
can take the lock and release it again, but we could speculate reads from
the critical section up over the later release and up before the control
dependency here...

> +	} while (!atomic_try_cmpxchg_relaxed(&lock->cnts, &cnt, _QW_LOCKED));

... and then this cmpxchg() will succeed, so our speculated stale reads
could be used.

*HOWEVER*

Speculating a read should be fine in the face of a concurrent _reader_,
so for this to be an issue it implies that the reader is also doing some
(atomic?) updates.

Ali?

Will
