Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BB1595BCB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiHPMac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiHPMa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:30:28 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC14578593
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 05:30:26 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id a13so1702368ild.3
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 05:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hfTOgFZQULH3HGjZfVeACZajEiyrHVTnjNgOWYibpaE=;
        b=uO+dRTgAMmNd3fHUIcqiRK5OLbpDzwLIIw1WOm6XSzHseadwJQvRDZx9EQVgkOmhIT
         jU6tQJTaqseJy6jOZ8wLd9+i/S1yFw7g1xDOZox4YLQoO0t05HU6azKLDikZTeOdiRtY
         52OeEIxLIGWo9urVKqH6zTKXEPCftK713RYvvNSD0nZDDuHJNnwUm8W62b1tRJw5OxAx
         Dfhysyugrt4yKaKlt0zX97iKip9YxK7FKebF9Obu5Nrqj0wCGVgF7bHnxLlcbW86qwqL
         P7NjzTkgnEyzkpdBgleanNe1JjZEQRj30waCSclse2wcpfdR68xYll/8GRa8gDuoaCUy
         FIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hfTOgFZQULH3HGjZfVeACZajEiyrHVTnjNgOWYibpaE=;
        b=m2MsB8aezQazdbQ+R/YqgLJ45sESRX4shZLXU/uEvjYeh0SeFojdmZUvPVk5Om8I7J
         6CngHE7mTD9nUofsDqqHkA6UFuwRnQ1nFeDXc1JSsGrO137LMP0eFAyQlZGMqveE9SkQ
         yoZqFtIcF28RMjwCZeo7b8p0ITdP6jHuaw8IeUGSHuWHmge2bW8jmJXAz1pJQ001SVA+
         fiDPfL8ClqZBYtSISOSP3zmAXdxhtvP/8O1DnJWmALfQP1z05Ujt2aFENtWHjqM+QNXY
         ALmYKvNWAMd7L2SeJZLd92KfUq/aaYnyHX/5r2L3L2oVkTj8WWp07bumTeibM6Xl/hpn
         5QIQ==
X-Gm-Message-State: ACgBeo0TqgHJqp7mLy0XMEir1MqHBhVKdgKsZYIGzgk4mkFv/b8wdoZP
        CRFfGh/i5LpaNuty5wxaXFZlpUPEpMy37LnhZPl1yA==
X-Google-Smtp-Source: AA6agR5M7NfRT1WSoa03THrtckC+7+nrcf1DtCA6A6ppxF0ZbktJfge+jLZDQjvUx+i+6Y1iC1iOSv9VbXsnD7m5S9Q=
X-Received: by 2002:a05:6e02:2145:b0:2e4:b2f3:d6fb with SMTP id
 d5-20020a056e02214500b002e4b2f3d6fbmr7584606ilv.163.1660653026211; Tue, 16
 Aug 2022 05:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220816070311.89186-1-marcan@marcan.st> <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
In-Reply-To: <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Tue, 16 Aug 2022 14:29:49 +0200
Message-ID: <CABdtJHvZt=av5YEQvRMtf4-dMFR6JS1jM1Ntj7DMVy5fijvkMw@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Hector Martin <marcan@marcan.st>, Will Deacon <will@kernel.org>,
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 10:17 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
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
>
> I assume this gets merged through the locking tree or that Linus picks it up
> directly, not through my asm-generic tree.
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Testing this patch on pre Armv8.1 specifically Cortex-A72 and
Cortex-A53 cores I am seeing
a huge performance drop with this patch applied. Perf is showing
lock_is_held_type() as the worst offender
but that could just be the function getting blamed. The most obvious
indicator of the performance loss is
ssh throughput.  With the patch I am only able to achieve around
20MB/s and without the patch I am able
to transfer around 112MB/s, no other changes.

When I have more time I can do some more in depth testing, but for now
I just wanted to bring this
issue up so perhaps others can chime in regarding how it performs on
their hardware.

-Jon
