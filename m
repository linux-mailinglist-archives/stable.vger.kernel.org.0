Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FEF36101D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 18:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhDOQ1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 12:27:25 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:12821 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDOQ1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 12:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618504022; x=1650040022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANBROxhu8Np9A9YcKnmE/yil0tSOexHbBm1e0G7E1i8=;
  b=nxscYFCo04BJ+VDk6xGIhhXA5ocnwFH9Z77oaqgdWLKZK2oZiLJcTcSK
   jF1L3okzG+BRgwoHYe9EclTqj01XTpD7TN+I+reUy6B9eKYSBq3MqG1wK
   a55nuMzsZF412zXuS02DN7xRI9kQDKwgPomJqusYP2y3ioXTQDn1Ia+yq
   c=;
X-IronPort-AV: E=Sophos;i="5.82,225,1613433600"; 
   d="scan'208";a="118764277"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Apr 2021 16:27:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 1EB7CA1E4D;
        Thu, 15 Apr 2021 16:27:01 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 16:27:00 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 16:27:00 +0000
Received: from dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com
 (10.200.138.153) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 15 Apr 2021 16:26:59 +0000
Received: by dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com (Postfix, from userid 5131138)
        id E0F5225852; Thu, 15 Apr 2021 16:26:59 +0000 (UTC)
From:   Ali Saidi <alisaidi@amazon.com>
To:     <will@kernel.org>
CC:     <alisaidi@amazon.com>, <benh@kernel.crashing.org>,
        <boqun.feng@gmail.com>, <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <longman@redhat.com>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <stable@vger.kernel.org>, <steve.capper@arm.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in queued_write_lock_slowpath
Date:   Thu, 15 Apr 2021 16:26:46 +0000
Message-ID: <20210415162646.9882-1-alisaidi@amazon.com>
X-Mailer: git-send-email 2.24.4.AMZN
In-Reply-To: <20210415150228.GA26439@willie-the-truck>
References: <20210415150228.GA26439@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu, 15 Apr 2021 16:02:29 +0100, Will Deacon wrote:
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
> I think it would be worth spelling this out with an example. The issue
> appears to be a concurrent reader in interrupt context taking and releasing
> the lock in the window where the writer has returned from the
> atomic_cond_read_acquire() but has not yet performed the cmpxchg(). Loads
> can be speculated during this time, but the A-B-A of the lock word
> from _QW_WAITING to (_QW_WAITING | _QR_BIAS) and back to _QW_WAITING allows
> the atomic_cmpxchg_relaxed() to succeed. Is that right?

You're right. What we're seeing is an A-B-A problem that can allow 
atomic_cond_read_acquire() to succeed and before the cmpxchg succeeds a reader
performs an A-B-A on the lock which allows the core to observe a read that
follows the cmpxchg ahead of the cmpxchg succeeding. 

We've seen a problem in epoll where the reader does a xchg while
holding the read lock, but the writer can see a value change out from under it. 

Writer                               | Reader 2
--------------------------------------------------------------------------------
ep_scan_ready_list()                 |
|- write_lock_irq()                  |
    |- queued_write_lock_slowpath()  |
      |- atomic_cond_read_acquire()  |
                                     | read_lock_irqsave(&ep->lock, flags);
                                     | chain_epi_lockless()
                                     |    epi->next = xchg(&ep->ovflist, epi);
                                     | read_unlock_irqrestore(&ep->lock, flags);
                                     |       
         atomic_cmpxchg_relaxed()    |
  READ_ONCE(ep->ovflist);    

> 
> With that in mind, it would probably be a good idea to eyeball the qspinlock
> slowpath as well, as that uses both atomic_cond_read_acquire() and
> atomic_try_cmpxchg_relaxed().

It seems plausible that the same thing could occur here in qspinlock:
          if ((val & _Q_TAIL_MASK) == tail) {
                  if (atomic_try_cmpxchg_relaxed(&lock->val, &val, _Q_LOCKED_VAL))
                          goto release; /* No contention */
          }

> 
> > Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")

Ack, will fix. 

> Typo in the quoted subject ('qrwloc').
> 
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
> 
> Patch looks good, so with an updated message:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Will
