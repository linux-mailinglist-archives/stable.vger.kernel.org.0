Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237C4595CC9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 15:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiHPNGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 09:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiHPNGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 09:06:34 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889AC27FD1
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 06:06:32 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id e192so2676526iof.5
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 06:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jYFy/Ap+uf26Gcpe/I0MSisZFVmPhCJtSmEvqbaImns=;
        b=TPm7sp/EC7y75Bb9Hebx9wUeTQofUP3E8N5rnoRewYyUMY2eWw6qAfh2vaf06LqTso
         YjKjRjDFQEcsxNlFOM1iFupmE5nz6Q3XbtcBGZh25VL1dE4iLkyEx+d2OdQkCDQV4F1I
         Q3Gws5+w1yGxQXqr1/i3xdwfJnmv+szNLKS5kWYlfZBsfM5RmI/eB+NWZWPry33NMS3K
         7KUwALiD/FTal89vHgf+W/bQjMhZ1WW4azMae9jdTw2nbZknuM1sk1Pi3+wD/VsqnjMN
         lZ7NcixEG9dmbkdfKcDkCLc/FtxPozmizq5rTPPr/72lRhKJj6KYyso7a0aS6JqLGCVp
         xn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jYFy/Ap+uf26Gcpe/I0MSisZFVmPhCJtSmEvqbaImns=;
        b=g0bEke/A1GirauUf2asCuZiTgndTxRzWjqppsMag1peMdOEPifpSMsnrENl8FW6bwA
         2KuSYozyeLY1PxqAtXpBj5u882O8j0QvGYmwt9abNPRGJTlZCMx9dVmnbL9ZvP/E63GP
         TyGY2tf3wJYcyK9D77eKyHGgj927UrZ5nfbYZLVLIYDGWLD6x+wsoiPr1VbyW/vLpLNp
         YnOxd85tnB+jU/xZeOCUU9rKz70opoVsC5R2agoq7yvON6uI8LPW0KL7CLYr3GqAMQai
         bWAMWjMiv6SX7jMiarZQMs55WhZk+euU2BR/lfpg5/Uy/f6aRg8xmAjX855M3yvwnm2h
         UcyQ==
X-Gm-Message-State: ACgBeo1wcQpkxbWV4g8eIFiarOKG2q9WCf8Q2lmt3iVmKlgOR8FyaZ3Q
        yl3/+5GujFuv2CubhHFv6LPWWXLju7oN3XhgMyPfKQ==
X-Google-Smtp-Source: AA6agR4LYPGyytQ7zXtN6CVNQG0RmLGJHMQuUxL8SF2Np6jEPA1mTRDJD83cAn/zEamlnjrEgjfTpWUAWi1BuGTNAGw=
X-Received: by 2002:a05:6638:d45:b0:343:2ae6:e39a with SMTP id
 d5-20020a0566380d4500b003432ae6e39amr9740158jak.139.1660655191422; Tue, 16
 Aug 2022 06:06:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220816070311.89186-1-marcan@marcan.st> <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
 <CABdtJHvZt=av5YEQvRMtf4-dMFR6JS1jM1Ntj7DMVy5fijvkMw@mail.gmail.com> <20220816130048.GA11202@willie-the-truck>
In-Reply-To: <20220816130048.GA11202@willie-the-truck>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Tue, 16 Aug 2022 15:05:54 +0200
Message-ID: <CABdtJHuRGaod9iGCYXq1ivNPZGw=1cszE024WGmzXMQ4S_9AQw@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 3:01 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Aug 16, 2022 at 02:29:49PM +0200, Jon Nettleton wrote:
> > On Tue, Aug 16, 2022 at 10:17 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Tue, Aug 16, 2022 at 9:03 AM Hector Martin <marcan@marcan.st> wrote:
> > > >
> > > > These operations are documented as always ordered in
> > > > include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
> > > > type use cases where one side needs to ensure a flag is left pending
> > > > after some shared data was updated rely on this ordering, even in the
> > > > failure case.
> > > >
> > > > This is the case with the workqueue code, which currently suffers from a
> > > > reproducible ordering violation on Apple M1 platforms (which are
> > > > notoriously out-of-order) that ends up causing the TTY layer to fail to
> > > > deliver data to userspace properly under the right conditions. This
> > > > change fixes that bug.
> > > >
> > > > Change the documentation to restrict the "no order on failure" story to
> > > > the _lock() variant (for which it makes sense), and remove the
> > > > early-exit from the generic implementation, which is what causes the
> > > > missing barrier semantics in that case. Without this, the remaining
> > > > atomic op is fully ordered (including on ARM64 LSE, as of recent
> > > > versions of the architecture spec).
> > > >
> > > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
> > > > Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
> > > > Signed-off-by: Hector Martin <marcan@marcan.st>
> > > > ---
> > > >  Documentation/atomic_bitops.txt     | 2 +-
> > > >  include/asm-generic/bitops/atomic.h | 6 ------
> > >
> > > I double-checked all the architecture specific implementations to ensure
> > > that the asm-generic one is the only one that needs the fix.
> > >
> > > I assume this gets merged through the locking tree or that Linus picks it up
> > > directly, not through my asm-generic tree.
> > >
> > > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > >
> > > _______________________________________________
> > > linux-arm-kernel mailing list
> > > linux-arm-kernel@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
> > Testing this patch on pre Armv8.1 specifically Cortex-A72 and
> > Cortex-A53 cores I am seeing
> > a huge performance drop with this patch applied. Perf is showing
> > lock_is_held_type() as the worst offender
>
> Hmm, that should only exist if LOCKDEP is enabled and performance tends to
> go out of the window if you have that on. Can you reproduce the same
> regression with lockdep disabled?
>
> Will

Yep I am working on it.  We should note that

config LOCKDEP_SUPPORT
        def_bool y

is the default for arm64

-Jon
