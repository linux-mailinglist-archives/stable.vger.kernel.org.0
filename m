Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7BC36105C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhDOQpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 12:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOQpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 12:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFD161131;
        Thu, 15 Apr 2021 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618505130;
        bh=ORDWc1SvZXapQesN2ExjiEM8+hTKGdHW2Wy08olAwvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uoSxpjQHEJNh+Pp+AAZrgXSYNm4fZ3LeZbMPrimQ3V90L8gYhXSTscqM593et/W8N
         bf216QKOJxE1KmKJA9Yc8MnOIaUVB5Fi/a5xjm7NT+yNP891163fgT3hCtqlhpBCG4
         7y7UwDefcbfnLTgZMdcrehFpuZTMUpgqIRsiAgGnRLQ3n6Y05F+I1FiSSiEEYoqrqA
         6ELYv/mkSiJrcIh0o7AiyQ2p5tC1LMQstqFQ6cgryIFNbca3ZWTvw8GTCNLsP+eKLQ
         AOm7kabmfeoAqgJ3rcLed6yXOCA23ptpPYxMtlyDDDiiyQgwi9/dbt0jWpPZyGAa0O
         dVMrseoLUAolw==
Date:   Thu, 15 Apr 2021 17:45:25 +0100
From:   Will Deacon <will@kernel.org>
To:     Ali Saidi <alisaidi@amazon.com>
Cc:     benh@kernel.crashing.org, boqun.feng@gmail.com,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        longman@redhat.com, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, steve.capper@arm.com
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <20210415164525.GC26594@willie-the-truck>
References: <20210415150228.GA26439@willie-the-truck>
 <20210415162646.9882-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415162646.9882-1-alisaidi@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 04:26:46PM +0000, Ali Saidi wrote:
> 
> On Thu, 15 Apr 2021 16:02:29 +0100, Will Deacon wrote:
> > On Thu, Apr 15, 2021 at 02:25:52PM +0000, Ali Saidi wrote:
> > > While this code is executed with the wait_lock held, a reader can
> > > acquire the lock without holding wait_lock.  The writer side loops
> > > checking the value with the atomic_cond_read_acquire(), but only truly
> > > acquires the lock when the compare-and-exchange is completed
> > > successfully which isn’t ordered. The other atomic operations from this
> > > point are release-ordered and thus reads after the lock acquisition can
> > > be completed before the lock is truly acquired which violates the
> > > guarantees the lock should be making.
> > 
> > I think it would be worth spelling this out with an example. The issue
> > appears to be a concurrent reader in interrupt context taking and releasing
> > the lock in the window where the writer has returned from the
> > atomic_cond_read_acquire() but has not yet performed the cmpxchg(). Loads
> > can be speculated during this time, but the A-B-A of the lock word
> > from _QW_WAITING to (_QW_WAITING | _QR_BIAS) and back to _QW_WAITING allows
> > the atomic_cmpxchg_relaxed() to succeed. Is that right?
> 
> You're right. What we're seeing is an A-B-A problem that can allow 
> atomic_cond_read_acquire() to succeed and before the cmpxchg succeeds a reader
> performs an A-B-A on the lock which allows the core to observe a read that
> follows the cmpxchg ahead of the cmpxchg succeeding. 
> 
> We've seen a problem in epoll where the reader does a xchg while
> holding the read lock, but the writer can see a value change out from under it. 
> 
> Writer                               | Reader 2
> --------------------------------------------------------------------------------
> ep_scan_ready_list()                 |
> |- write_lock_irq()                  |
>     |- queued_write_lock_slowpath()  |
>       |- atomic_cond_read_acquire()  |
>                                      | read_lock_irqsave(&ep->lock, flags);
>                                      | chain_epi_lockless()
>                                      |    epi->next = xchg(&ep->ovflist, epi);
>                                      | read_unlock_irqrestore(&ep->lock, flags);
>                                      |       
>          atomic_cmpxchg_relaxed()    |
>   READ_ONCE(ep->ovflist);    


Please stick this in the commit message, preferably annotated a bit like
Peter's example to show the READ_ONCE() being speculated.

> > With that in mind, it would probably be a good idea to eyeball the qspinlock
> > slowpath as well, as that uses both atomic_cond_read_acquire() and
> > atomic_try_cmpxchg_relaxed().
> 
> It seems plausible that the same thing could occur here in qspinlock:
>           if ((val & _Q_TAIL_MASK) == tail) {
>                   if (atomic_try_cmpxchg_relaxed(&lock->val, &val, _Q_LOCKED_VAL))
>                           goto release; /* No contention */
>           }

Just been thinking about this, but I don't see an issue here because
everybody is queuing the same way (i.e. we don't have a mechanism to jump
the queue like we do for qrwlock) and the tail portion of the lock word
isn't susceptible to ABA. That is, once we're at the head of the queue
and we've seen the lock become unlocked via atomic_cond_read_acquire(),
then we know we hold it.

So qspinlock looks fine to me, but I'd obviously value anybody else's
opinion on that.

Will
