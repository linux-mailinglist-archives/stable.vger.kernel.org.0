Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91B0596237
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiHPSOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiHPSOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:14:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0AD7AC02;
        Tue, 16 Aug 2022 11:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MySzvGXqRSaBBJhmsw3ulDhggVAysoOKEMJnaszkKsU=; b=YPrEDcLvKjIb0xNBG+Jk/CGOJ6
        kW006eJ0NtmQgEuIfrtpv18W/AT3E6P4tU5tApVpU7iXAmUuqgW37qBLQwW2Knu5FTIuqME+NNPyp
        YadFUKbPi+Tq8trcm0xs6iZy0i2DBc3igLK50MYONBYKHxtUkGtlV31WJyX2fPAFh1cO7W3lL6vBo
        rNXj8n/uobl/HADOp+sc3StKPN9OlbxVN+x6YSldP1qDn+vr9g7EePepooP8GXvGf41FpHgOg9w5Q
        eUbNbWIvPg7EMgqcJ9XQFTfQntotK8qMPpjXTNgqVHkWILVngJ8OwCDNX5OV/DmArUSafNpj+lANo
        lPG7MazQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oO153-007DVO-MT; Tue, 16 Aug 2022 18:14:21 +0000
Date:   Tue, 16 Aug 2022 19:14:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Will Deacon <will@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Hector Martin <marcan@marcan.st>,
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
Message-ID: <Yvveff1aW/zeYzBo@casper.infradead.org>
References: <20220816070311.89186-1-marcan@marcan.st>
 <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
 <20220816140640.GD11202@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816140640.GD11202@willie-the-truck>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 03:06:41PM +0100, Will Deacon wrote:
> On Tue, Aug 16, 2022 at 10:16:04AM +0200, Arnd Bergmann wrote:
> > On Tue, Aug 16, 2022 at 9:03 AM Hector Martin <marcan@marcan.st> wrote:
> > >
> > > These operations are documented as always ordered in
> > > include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
> > > type use cases where one side needs to ensure a flag is left pending
> > > after some shared data was updated rely on this ordering, even in the
> > > failure case.
> > >
> > > This is the case with the workqueue code, which currently suffers from a
> > > reproducible ordering violation on Apple M1 platforms (which are
> > > notoriously out-of-order) that ends up causing the TTY layer to fail to
> > > deliver data to userspace properly under the right conditions. This
> > > change fixes that bug.
> > >
> > > Change the documentation to restrict the "no order on failure" story to
> > > the _lock() variant (for which it makes sense), and remove the
> > > early-exit from the generic implementation, which is what causes the
> > > missing barrier semantics in that case. Without this, the remaining
> > > atomic op is fully ordered (including on ARM64 LSE, as of recent
> > > versions of the architecture spec).
> > >
> > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: stable@vger.kernel.org
> > > Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
> > > Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
> > > Signed-off-by: Hector Martin <marcan@marcan.st>
> > > ---
> > >  Documentation/atomic_bitops.txt     | 2 +-
> > >  include/asm-generic/bitops/atomic.h | 6 ------
> > 
> > I double-checked all the architecture specific implementations to ensure
> > that the asm-generic one is the only one that needs the fix.
> 
> I couldn't figure out parisc -- do you know what ordering their spinlocks
> provide? They have a comment talking about a release, but I don't know what
> the ordering guarantees of an "ldcw" are.

"The semaphore operation is strongly ordered" (that's from the
description of the LDCW instruction)
