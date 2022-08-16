Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD305595D90
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiHPNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiHPNmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D53A76446;
        Tue, 16 Aug 2022 06:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A888B819FD;
        Tue, 16 Aug 2022 13:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2356C433D6;
        Tue, 16 Aug 2022 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660657324;
        bh=Qq7Od/WKrPNgJutT+rQAJ/KGqHp84OSZZFvuxh53vfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uxm4xm+ALMb01rM4sXSeb76GPtpquhJHUuGAQPan5hjPTY2PG2/VVJT+yzlSqJSp4
         gbuO20i7MQ/V7LbXJBKi1Kv09HDlPEiykqQMiYrWfUuyR+4RMtgbrS/pNK3Ld1tEBz
         iIteDr8uwY6qNZQEt56Qo4uW7G8/lP+qi52hqjEEwFQkOg6aDn23w+NX3EvCN1bG8/
         BHbwbkZnhyPnYs2uzf/FiTBySdqnGim674TWzDv0o2cWLgMBBhZT84l3ZuxIHs2LhU
         0MFGrARz8A7GOsadQ1/ZmP+BWv6OdePO4izMwZkkb0oCjNAyEJ2dXzgtG2zHhN6Vzo
         71xzl9WdEbD4w==
Date:   Tue, 16 Aug 2022 14:41:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Tejun Heo <tj@kernel.org>, marcan@marcan.st,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
Message-ID: <20220816134156.GB11202@willie-the-truck>
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 10:27:10PM -0700, Linus Torvalds wrote:
> On Mon, Aug 15, 2022 at 9:15 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Please revert this as test_and_set_bit was always supposed to be
> > a full memory barrier.  This is an arch bug.
> 
> Yes, the bitops are kind of strange for various legacy reasons:
> 
>  - set/clear_bit is atomic, but without a memory barrier, and need a
> "smp_mb__before_atomic()" or similar for barriers
> 
>  - test_and_set/clear_bit() are atomic, _and_ are memory barriers
> 
>  - test_and_set_bit_lock and test_and_clear_bit_unlock are atomic and
> _weaker_ than full memory barriers, but sufficient for locking (ie
> acquire/release)
> 
> Does any of this make any sense at all? No. But those are the
> documented semantics exactly because people were worried about
> test_and_set_bit being used for locking, since on x86 all the atomics
> are also memory barriers.
> 
> From looking at it, the asm-generic implementation is a bit
> questionable, though. In particular, it does
> 
>         if (READ_ONCE(*p) & mask)
>                 return 1;
> 
> so it's *entirely* unordered for the "bit was already set" case.
> 
> That looks very wrong to me, since it basically means that the
> test_and_set_bit() can return "bit was already set" based on an old
> value - not a memory barrier at all.
> 
> So if you use "test_and_set_bit()" as some kind of "I've done my work,
> now I am going to set the bit to tell people to pick it up", then that
> early "bit was already set" code completely breaks it.
> 
> Now, arguably our atomic bitop semantics are very very odd, and it
> might be time to revisit them. But that code looks very very buggy to
> me.
> 
> The bug seems to go back to commit e986a0d6cb36 ("locking/atomics,
> asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs"), and the
> fix looks to be as simple as just removing that early READ_ONCE return
> case (test_and_clear has the same bug).
> 
> Will?

Right, this looks like it's all my fault, so sorry about that.

In an effort to replace the spinlock-based atomic bitops with a version
based on atomic instructions in e986a0d6cb36, I inadvertently added this
READ_ONCE() shortcut to test_and_set_bit() because at the time that's
what we had (incorrectly) documented in our attempts at cleaning things
up in this area. I confess that I have never been comfortable with the
comment for test_and_set_bit() prior to my problematic patch:

/**
 * test_and_set_bit - Set a bit and return its old value
 * @nr: Bit to set
 * @addr: Address to count from
 *
 * This operation is atomic and cannot be reordered.
 * It may be reordered on other architectures than x86.
 * It also implies a memory barrier.
 */

so while Peter and I were trying to improve the documentation for
atomics and memory barriers we clearly ended up making the wrong call
trying to treat this like e.g. a cmpxchg() (which has the
unordered-on-failure semantics).

It's worth noting that with the spinlock-based implementation (i.e.
prior to e986a0d6cb36) then we would have the same problem on
architectures that implement spinlocks with acquire/release semantics;
accesses from outside of the critical section can drift in and reorder
with each other there, so the conversion looked legitimate to me in
isolation and I vaguely remember going through callers looking for
potential issues. Alas, I obviously missed this case.

So it looks to me like we need to:

  1. Upgrade test_and_{set,clear}_bit() to have a full memory barrier
     regardless of the value which is read from memory. The lock/unlock
     flavours can remain as-is.

  2. Fix the documentation

  3. Figure out what to do about architectures building atomics out of
     spinlocks (probably ok as lock+unlock == full barrier there?)

  4. Accept my sincerest apologies for the mess!

> IOW, the proper fix for this should, I think, look something like this
> (whitespace mangled) thing:
> 
>    --- a/include/asm-generic/bitops/atomic.h
>    +++ b/include/asm-generic/bitops/atomic.h
>    @@ -39,9 +39,6 @@ arch_test_and_set_bit(
>         unsigned long mask = BIT_MASK(nr);
> 
>         p += BIT_WORD(nr);
>    -    if (READ_ONCE(*p) & mask)
>    -            return 1;
>    -
>         old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
>         return !!(old & mask);
>     }
>    @@ -53,9 +50,6 @@ arch_test_and_clear_bit
>         unsigned long mask = BIT_MASK(nr);
> 
>         p += BIT_WORD(nr);
>    -    if (!(READ_ONCE(*p) & mask))
>    -            return 0;
>    -
>         old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
>         return !!(old & mask);
>     }
> 
> but the above is not just whitespace-damaged, it's entirely untested
> and based purely on me looking at that code.

Yes, I think that's step 1, thanks! I'm a bit worried about the perf
numbers on the other thread, but we can get to the bottom of that
separately.

Will
