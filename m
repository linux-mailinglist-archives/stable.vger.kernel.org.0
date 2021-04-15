Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4F0360F60
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhDOPuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOPuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC2A610CE;
        Thu, 15 Apr 2021 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618501814;
        bh=+y8VIY5y82ytEDiO2xzY9qqH4agdV6HrrFbRCGjkdFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EBlF1wHUH9Xo3wnmCcIyAMTJi0XuRjVaac474qfUDyqASmy/pRNMrjZeaujjzi2U0
         A8Z5HV37yhdStseMCJOL6cDo4OVLJP8WRxEUKPQS7twKArfRsX2k09f2pijAz7l07q
         3yX5yRRthqrSHZDsa2ttQnIvPFkhPxLSmzaaZM8C8jBx5HpeZjaSQwtThseK6x1010
         GeNDQDEAfW2+pB2KUCbctbRnZpvsntA8oSkuL0kZ3XeXAc7JsV1x3yQd5n7NbC29Il
         h9QG8LiuYQIOsIWFjarIebr2Pp4nVBzYJ1p34pK8wMCGK68HQ5PYB8+sTRkltGwnE0
         A+opmTM0ZN9Tw==
Date:   Thu, 15 Apr 2021 16:50:10 +0100
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ali Saidi <alisaidi@amazon.com>, linux-kernel@vger.kernel.org,
        steve.capper@arm.com, benh@kernel.crashing.org,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <20210415155009.GA26594@willie-the-truck>
References: <20210415142552.30916-1-alisaidi@amazon.com>
 <YHhV3n2n4OXzaZBM@hirez.programming.kicks-ass.net>
 <20210415152820.GB26439@willie-the-truck>
 <20210415153758.GF1015@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415153758.GF1015@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 04:37:58PM +0100, Catalin Marinas wrote:
> On Thu, Apr 15, 2021 at 04:28:21PM +0100, Will Deacon wrote:
> > On Thu, Apr 15, 2021 at 05:03:58PM +0200, Peter Zijlstra wrote:
> > > diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> > > index 4786dd271b45..22aeccc363ca 100644
> > > --- a/kernel/locking/qrwlock.c
> > > +++ b/kernel/locking/qrwlock.c
> > > @@ -60,6 +60,8 @@ EXPORT_SYMBOL(queued_read_lock_slowpath);
> > >   */
> > >  void queued_write_lock_slowpath(struct qrwlock *lock)
> > >  {
> > > +	u32 cnt;
> > > +
> > >  	/* Put the writer into the wait queue */
> > >  	arch_spin_lock(&lock->wait_lock);
> > >  
> > > @@ -73,9 +75,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
> > >  
> > >  	/* When no more readers or writers, set the locked flag */
> > >  	do {
> > > -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> > > -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> > > -					_QW_LOCKED) != _QW_WAITING);
> > > +		cnt = atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> > 
> > I think the issue is that >here< a concurrent reader in interrupt context
> > can take the lock and release it again, but we could speculate reads from
> > the critical section up over the later release and up before the control
> > dependency here...
> > 
> > > +	} while (!atomic_try_cmpxchg_relaxed(&lock->cnts, &cnt, _QW_LOCKED));
> > 
> > ... and then this cmpxchg() will succeed, so our speculated stale reads
> > could be used.
> > 
> > *HOWEVER*
> > 
> > Speculating a read should be fine in the face of a concurrent _reader_,
> > so for this to be an issue it implies that the reader is also doing some
> > (atomic?) updates.
> 
> There's at least one such case: see chain_epi_lockless() updating
> epi->next, called from ep_poll_callback() with a read_lock held. This
> races with ep_done_scan() which has the write_lock held.

Do you know if that's the code which triggered this patch? If so, it would
be great to have this information in the changelog!

> I think the authors of the above code interpreted the read_lock as
> something that multiple threads can own disregarding the _read_ part.

Using RmW atomics should be fine for that; it's no worse than some of the
tricks pulled in RCU read context in the dentry cache (but then again, what
is? ;)

Will
