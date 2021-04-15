Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0D360DE4
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhDOPG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhDOPFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 11:05:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC7C06135C;
        Thu, 15 Apr 2021 08:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=gSbpyPTIKVyJfJiTjht7IPkWWMvmcOXjW8q5rJaotvo=; b=bc/I0ehGbBd/qLhnUGm73sLaXQ
        2U8qz23kUnkrM2rupRuvjQ8PbfKhwPrRX7VU6ciUih+PhY+b5KhiPoJ6f+jJ5HY/O6OwQn263qrCs
        BFDg1aq1NqhCcnEUJ4dgTQf9qt6BUlQlvAeTQ8YJ+pbf/c79kDQOmKViAAT7+8zQyCl57rCahWoZ9
        v/8sy/drvJJc5b3jHZJQQeEjduLUjKnoYvSuma5n6skxOepCNMNAWSJ0FsvWrsrBQWQpo0M/GGllz
        4AVHzIAAqChPDxSoqCUXsxzgtcqevqQgp5CUA7ZakloyeDl3CIJH/y9Qred0RaMz/SrDCcnu2nMOg
        gPBAx8Eg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lX3XD-00GXTn-OO; Thu, 15 Apr 2021 15:03:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DE67230015A;
        Thu, 15 Apr 2021 17:03:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C0884200D0271; Thu, 15 Apr 2021 17:03:58 +0200 (CEST)
Date:   Thu, 15 Apr 2021 17:03:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ali Saidi <alisaidi@amazon.com>
Cc:     linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        steve.capper@arm.com, benh@kernel.crashing.org,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <YHhV3n2n4OXzaZBM@hirez.programming.kicks-ass.net>
References: <20210415142552.30916-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415142552.30916-1-alisaidi@amazon.com>
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

Should be per who? We explicitly do not order the lock acquire store.
qspinlock has the exact same issue.

If you look in the git history surrounding spin_is_locked(), you'll find
'lovely' things.

Basically, if you're doing crazy things with spin_is_locked() you get to
keep the pieces.

> Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")
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
>  unlock:
>  	arch_spin_unlock(&lock->wait_lock);

This doesn't make sense, there is no such thing as a store-acquire. What
you're doing here is moving the acquire from one load to the next. A
load we know will load the exact same value.

Also see Documentation/atomic_t.txt:

  {}_acquire: the R of the RMW (or atomic_read) is an ACQUIRE


If anything this code wants to be written like so.

---

diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index 4786dd271b45..22aeccc363ca 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -60,6 +60,8 @@ EXPORT_SYMBOL(queued_read_lock_slowpath);
  */
 void queued_write_lock_slowpath(struct qrwlock *lock)
 {
+	u32 cnt;
+
 	/* Put the writer into the wait queue */
 	arch_spin_lock(&lock->wait_lock);
 
@@ -73,9 +75,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
 
 	/* When no more readers or writers, set the locked flag */
 	do {
-		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
-	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
-					_QW_LOCKED) != _QW_WAITING);
+		cnt = atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
+	} while (!atomic_try_cmpxchg_relaxed(&lock->cnts, &cnt, _QW_LOCKED));
 unlock:
 	arch_spin_unlock(&lock->wait_lock);
 }
