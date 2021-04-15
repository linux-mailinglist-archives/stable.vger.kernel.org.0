Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E1C360DE2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhDOPG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhDOPFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45CF96113B;
        Thu, 15 Apr 2021 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618498954;
        bh=ZvTEnMo9pgWl4sfm4XQJb+dSibzAjNILwQ8qBoBY1Rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGMbr/OcaPrsiIoG8XyDiauxT9fuIuj3DbxZvxoGLZIlQI4k2GkoxNe5MS9LcEQKe
         UOrUF3u27Enqc/+zXoVlkFZbyZ56xVye4VpTHSbDdp52NGE2RROG6ufa7D20dnNHWo
         /oKj86Z1mJ6/Zj2dP7PH0uAWJNzSjWEnxU9byubLs8m69MRzJnj8O3pb7TZ1XOAsYw
         W29iF57CGGk3nWByQsXInZjc6kTqa+Vh9fTOabURtQXkDAQ5H1p3c5ytt3pWsUa36L
         M071SuJATWYgbXYJEUoXTQiBVTBr4cOrA2Ul25is82A9gtaaNcm/SDfn8TUfTb0Yah
         U91JBtzdrR7hg==
Date:   Thu, 15 Apr 2021 16:02:29 +0100
From:   Will Deacon <will@kernel.org>
To:     Ali Saidi <alisaidi@amazon.com>
Cc:     linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        steve.capper@arm.com, benh@kernel.crashing.org,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <20210415150228.GA26439@willie-the-truck>
References: <20210415142552.30916-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415142552.30916-1-alisaidi@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 02:25:52PM +0000, Ali Saidi wrote:
> While this code is executed with the wait_lock held, a reader can
> acquire the lock without holding wait_lock.  The writer side loops
> checking the value with the atomic_cond_read_acquire(), but only truly
> acquires the lock when the compare-and-exchange is completed
> successfully which isn’t ordered. The other atomic operations from this
> point are release-ordered and thus reads after the lock acquisition can
> be completed before the lock is truly acquired which violates the
> guarantees the lock should be making.

I think it would be worth spelling this out with an example. The issue
appears to be a concurrent reader in interrupt context taking and releasing
the lock in the window where the writer has returned from the
atomic_cond_read_acquire() but has not yet performed the cmpxchg(). Loads
can be speculated during this time, but the A-B-A of the lock word
from _QW_WAITING to (_QW_WAITING | _QR_BIAS) and back to _QW_WAITING allows
the atomic_cmpxchg_relaxed() to succeed. Is that right?

With that in mind, it would probably be a good idea to eyeball the qspinlock
slowpath as well, as that uses both atomic_cond_read_acquire() and
atomic_try_cmpxchg_relaxed().

> Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")

Typo in the quoted subject ('qrwloc').

> Signed-off-by: Ali Saidi <alisaidi@amazon.com>
> Cc: stable@vger.kernel.org
> ---
>  kernel/locking/qrwlock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index 4786dd271b45..10770f6ac4d9 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -73,8 +73,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
>  
>  	/* When no more readers or writers, set the locked flag */
>  	do {
> -		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
> -	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
> +		atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
> +	} while (atomic_cmpxchg_acquire(&lock->cnts, _QW_WAITING,
>  					_QW_LOCKED) != _QW_WAITING);

Patch looks good, so with an updated message:

Acked-by: Will Deacon <will@kernel.org>

Will
