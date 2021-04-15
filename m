Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3A360F83
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhDOPzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhDOPzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 11:55:07 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46821C061756;
        Thu, 15 Apr 2021 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ypmponNNxSe0gBx7OgQXtGUuHBsyAIVpcSTelvx+hQU=; b=J0y8kZzvkORHKBjHfNwxj9fvFw
        u4YnOJM/O4+xjossXw//ncK274XKqdHF3w5wf/LiHLGOVjA2OWYk8CXkeGgo50wODoO/w1+WfKVKs
        /il9p/Hr2LsG1HH+nK6LkuMWhdubT63TKgrfbADyHiqj5aJZX/6VeXogAwaHRWbvNWj/YbWmX2bq3
        ozpgkTW1I4hcwZJ31I5x2HoOBitLcnFwlqiD3MDgNs3q7yDgaWNqNT4UfycglKadMVV6lcln/Aygl
        JO3+IRwKrsBo8KgHP/EnAcexFoN2wuDo2XBJGx4Qtvq9ktmjCk9gU0e1fSc1CIa7cERt7IBlxG52L
        Dgi9An2Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lX4K8-00Gg1X-2n; Thu, 15 Apr 2021 15:54:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B9A2C300209;
        Thu, 15 Apr 2021 17:54:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 79CBD2C7BF8A8; Thu, 15 Apr 2021 17:54:30 +0200 (CEST)
Date:   Thu, 15 Apr 2021 17:54:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will@kernel.org>
Cc:     Ali Saidi <alisaidi@amazon.com>, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, steve.capper@arm.com,
        benh@kernel.crashing.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <YHhhtuVsM4FkINLM@hirez.programming.kicks-ass.net>
References: <20210415142552.30916-1-alisaidi@amazon.com>
 <YHhV3n2n4OXzaZBM@hirez.programming.kicks-ass.net>
 <20210415152820.GB26439@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415152820.GB26439@willie-the-truck>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 04:28:21PM +0100, Will Deacon wrote:
> On Thu, Apr 15, 2021 at 05:03:58PM +0200, Peter Zijlstra wrote:
> > @@ -73,9 +75,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
> >  
> >  	/* When no more readers or writers, set the locked flag */
> >  	do {
> > -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> > -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> > -					_QW_LOCKED) != _QW_WAITING);
> > +		cnt = atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> 
> I think the issue is that >here< a concurrent reader in interrupt context
> can take the lock and release it again, but we could speculate reads from
> the critical section up over the later release and up before the control
> dependency here...

OK, so that was totally not clear from the original changelog.

> > +	} while (!atomic_try_cmpxchg_relaxed(&lock->cnts, &cnt, _QW_LOCKED));
> 
> ... and then this cmpxchg() will succeed, so our speculated stale reads
> could be used.
> 
> *HOWEVER*
> 
> Speculating a read should be fine in the face of a concurrent _reader_,
> so for this to be an issue it implies that the reader is also doing some
> (atomic?) updates.

So we're having something like:

	CPU0				CPU1

	queue_write_lock_slowpath()
	  atomic_cond_read_acquire() == _QW_WAITING

					queued_read_lock_slowpath()
					  atomic_cond_read_acquire()
					  return;
   ,--> (before X's store)
   |					X = y;
   |
   |					queued_read_unlock()
   |					  (void)atomic_sub_return_release()
   |
   |	  atomic_cmpxchg_relaxed(.old = _QW_WAITING)
   |
    `--	r = X;


Which as Will said is a cmpxchg ABA, however for it to be ABA, we have
to observe that unlock-store, and won't we then also have to observe the
whole critical section?

Ah, the issue is yet another load inside our own (CPU0)'s critical
section. which isn't ordered against the cmpxchg_relaxed() and can be
issued before.

So yes, then making the cmpxchg an acquire, will force all our own loads
to happen later.
