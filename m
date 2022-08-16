Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2FF596143
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 19:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiHPRhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 13:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHPRhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 13:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23121A39C;
        Tue, 16 Aug 2022 10:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75B27B816A4;
        Tue, 16 Aug 2022 17:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FFAC433C1;
        Tue, 16 Aug 2022 17:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660671424;
        bh=E+LNE2NFAYYa8LG9rDr9KWJnY8H1CbWqaT9X9cltAsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q3GsKJD5bA9HAPYjdc987zxp+h8NOwPo9fLGXBLPgXzYy1mnc7FnSVGKdV0Raz20/
         1W3NIRAN1P3GKqoWJbLo98VrPvtvRgQfeQJgmM8/8mtiu0s+mLU8X2HrdRoH6dIDU+
         /a8UziVf+g12jr7gNe4iUf864MDdZMQvz4Ggh8mDMvRv320+bXP26JPXcwUFzCWG+B
         EXYVcPkLQUabUA2FB/F7gNl5Epux81MbFh3OPQLUccak3pyOUBqnUepODjhrC6PHRH
         oJi7+fpsCTrEq87/3mV40rgSPXw/EBGxhecfQr62tl1DXO9p2MVU2dvwZJ+jA20NXg
         HMKObI12LuQ6g==
Date:   Tue, 16 Aug 2022 18:36:54 +0100
From:   Will Deacon <will@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
        jirislaby@kernel.org, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Asahi Linux <asahi@lists.linux.dev>, stable@vger.kernel.org
Subject: Re: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
Message-ID: <20220816173654.GA11766@willie-the-truck>
References: <20220816070311.89186-1-marcan@marcan.st>
 <20220816140423.GC11202@willie-the-truck>
 <c545705f-ee7e-4442-ebfc-64a3baca2836@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c545705f-ee7e-4442-ebfc-64a3baca2836@marcan.st>
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

On Tue, Aug 16, 2022 at 11:30:45PM +0900, Hector Martin wrote:
> On 16/08/2022 23.04, Will Deacon wrote:
> >> diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
> >> index 3096f086b5a3..71ab4ba9c25d 100644
> >> --- a/include/asm-generic/bitops/atomic.h
> >> +++ b/include/asm-generic/bitops/atomic.h
> >> @@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, volatile unsigned long *p)
> >>  	unsigned long mask = BIT_MASK(nr);
> >>  
> >>  	p += BIT_WORD(nr);
> >> -	if (READ_ONCE(*p) & mask)
> >> -		return 1;
> >> -
> >>  	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
> >>  	return !!(old & mask);
> >>  }
> >> @@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr, volatile unsigned long *p)
> >>  	unsigned long mask = BIT_MASK(nr);
> >>  
> >>  	p += BIT_WORD(nr);
> >> -	if (!(READ_ONCE(*p) & mask))
> >> -		return 0;
> >> -
> >>  	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
> >>  	return !!(old & mask);
> > 
> > I suppose one sad thing about this is that, on arm64, we could reasonably
> > keep the READ_ONCE() path with a DMB LD (R->RW) barrier before the return
> > but I don't think we can express that in the Linux memory model so we
> > end up in RmW territory every time.
> 
> You'd need a barrier *before* the READ_ONCE(), since what we're trying
> to prevent is a consumer from writing to the value without being able to
> observe the writes that happened prior, while this side read the old
> value. A barrier after the READ_ONCE() doesn't do anything, as that read
> is the last memory operation in this thread (of the problematic sequence).

Right, having gone back to your litmus test, I now realise it's the "SB"
shape from the memory ordering terminology. It's funny because the arm64
acquire/release instructions are RCsc and so upgrading the READ_ONCE()
to an *arm64* acquire instruction would work for your specific case, but
only because the preceeding store is a release.

> At that point, I'm not sure DMB LD / early read / LSE atomic would be
> any faster than just always doing the LSE atomic?

It depends a lot on the configuration of the system and the state of the
relevant cacheline, but generally avoiding an RmW by introducing a barrier
is likely to be a win. It just gets ugly here as we'd want to avoid the
DMB in the case where we end up doing the RmW. Possibly we could do
something funky like a test-and-test-and-test-and-set (!) where we do
the DMB+READ_ONCE() only if the first READ_ONCE() has the bit set, but
even just typing that is horrible and I'd _absolutely_ want to see perf
numbers to show that it's a benefit once you start taking into account
things like branch prediction.

Anywho, since Linus has applied the patch and it should work, this is
just an interesting aside.

Will
