Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6711C595E10
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 16:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiHPOGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 10:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiHPOGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 10:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F59580B3;
        Tue, 16 Aug 2022 07:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 753FE60FBE;
        Tue, 16 Aug 2022 14:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9B7C433D7;
        Tue, 16 Aug 2022 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660658809;
        bh=Or6NyDZrBzLzCXiIiquybOJRFR8o21mNOuu9wwm7Nss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kfw1O86y2BXK91mGj0emsKUZkIdWk32UmBAWTwQjudeEvHAasXBTJndVb1TuUneDD
         rVYTtbvFMo+QhYNl2UJK1HMfxu4hKojAVWqZgsyNUoFb+rzPxq+zFxDKs66QJCCtm1
         2txEOXrlVzP3vE7EMu24gEtSP6dRv/3DcWqeW7duIlMCeqnVBXuK8jgabfBzlCc7/l
         fZUv+oaFllnBBMxHS/Q+r5R49NpjKKAEXV5lQOrXfgAPGq2AdzcdlZM1kUydwTcJBV
         JTanTDke6p8gRxBvtYYFcMNyInC9y26AtCwzencBxBL6osJm5XT9OcY9JsudLnfkc7
         XbYfPc765w6cA==
Date:   Tue, 16 Aug 2022 15:06:41 +0100
From:   Will Deacon <will@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Hector Martin <marcan@marcan.st>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20220816140640.GD11202@willie-the-truck>
References: <20220816070311.89186-1-marcan@marcan.st>
 <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
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

On Tue, Aug 16, 2022 at 10:16:04AM +0200, Arnd Bergmann wrote:
> On Tue, Aug 16, 2022 at 9:03 AM Hector Martin <marcan@marcan.st> wrote:
> >
> > These operations are documented as always ordered in
> > include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
> > type use cases where one side needs to ensure a flag is left pending
> > after some shared data was updated rely on this ordering, even in the
> > failure case.
> >
> > This is the case with the workqueue code, which currently suffers from a
> > reproducible ordering violation on Apple M1 platforms (which are
> > notoriously out-of-order) that ends up causing the TTY layer to fail to
> > deliver data to userspace properly under the right conditions. This
> > change fixes that bug.
> >
> > Change the documentation to restrict the "no order on failure" story to
> > the _lock() variant (for which it makes sense), and remove the
> > early-exit from the generic implementation, which is what causes the
> > missing barrier semantics in that case. Without this, the remaining
> > atomic op is fully ordered (including on ARM64 LSE, as of recent
> > versions of the architecture spec).
> >
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: stable@vger.kernel.org
> > Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
> > Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
> > Signed-off-by: Hector Martin <marcan@marcan.st>
> > ---
> >  Documentation/atomic_bitops.txt     | 2 +-
> >  include/asm-generic/bitops/atomic.h | 6 ------
> 
> I double-checked all the architecture specific implementations to ensure
> that the asm-generic one is the only one that needs the fix.

I couldn't figure out parisc -- do you know what ordering their spinlocks
provide? They have a comment talking about a release, but I don't know what
the ordering guarantees of an "ldcw" are.

Will
