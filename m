Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DAC59583C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiHPKa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiHPKa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:30:26 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20D984EF6;
        Tue, 16 Aug 2022 01:16:22 -0700 (PDT)
Received: from mail-ej1-f41.google.com ([209.85.218.41]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MuDPh-1nVmG00fXh-00ucal; Tue, 16 Aug 2022 10:16:21 +0200
Received: by mail-ej1-f41.google.com with SMTP id a7so17567241ejp.2;
        Tue, 16 Aug 2022 01:16:21 -0700 (PDT)
X-Gm-Message-State: ACgBeo33ceRETs9/Jye2QbXxzU5AEAna2/4O5cDeSTf88pRW+k587zJF
        RQYlmByLPR1eD1q8YbKGd7/q3DHxJT/QjiHV0e0=
X-Google-Smtp-Source: AA6agR6iJ0nwhhROioKsW3KiCcnkE21PLtVwi8+SbpiQ4ZkczWhJ8i5DpkLee3nWEvIKF41nGXZNZm3jeBE6JuFII7g=
X-Received: by 2002:a17:906:8a67:b0:738:7bcd:dca1 with SMTP id
 hy7-20020a1709068a6700b007387bcddca1mr1923189ejc.547.1660637780770; Tue, 16
 Aug 2022 01:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220816070311.89186-1-marcan@marcan.st>
In-Reply-To: <20220816070311.89186-1-marcan@marcan.st>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 16 Aug 2022 10:16:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
Message-ID: <CAK8P3a03pfrPzjnx1tB5z0HcKnY=JL=y+F8PMQDpc=Bavs3UCA@mail.gmail.com>
Subject: Re: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
To:     Hector Martin <marcan@marcan.st>
Cc:     Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Jg5mkr7l+zrNyfFzBvs5i1+/l2UlfgBGsjuyilNfjoCAl7e0vIK
 TicO0qiEDijREu19FTd6lsJ/xG/qL+EIpVuiumbZd62aIFx2OXh1gQ+2geNFdBVwvelIaws
 U/qaLsKuC7aXaYHFXRmlVqfYYgxXkdSQJQ1VV3jTdwC81L27G6FvdY7TSzor0+xh/J7PEDb
 qG4zsEw7nQqMDQnoYIF+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0YAPTbXMD6Q=:Cpy3XZMvFH2GhcX0VVyvOx
 0YzlCxR6gGq9Pz3C5g7UZVwFHunn/VyMHkyx8i8pVxdcNhLTiZhcOSq/VKk3uS69cn8rThieC
 191ZejESr8C3yo26hkMLJcrOk6z9Vo7EeTMVzPT1SrhFNJeg029pH9llcmlNznfIfSq2l/yIi
 n70ffHRZBUVLLcRASCGyf6Ht2a1xAvBCw+wtxUjILb324Hqr1BY9nDl2Xhb4YcnD4rhHUmnvd
 CBPw8M17qfmdxtn7bSaRbZ2gXnGca/UQLP9Arj4y0Rc4Yq1ZCdEsOum560JZuBd4IH5HWkw2d
 aPrVpwDiOYHnxK2tKkQOIf6N1TeXIP/RuU3RGT2B6itpK1tCO1VFRa4r/75bQYTtPGLPsY5wE
 9BC2YTZVmza2ADitrSTrAO6yCOE7sAepV6ZIg+KmGB+v5uJhhicb7OoTQ9/AWTW/vPCO6qvjS
 Gc8VBh9rDEoGHZF0SBxY5w+AEPmdykpWxbn1iYKASCGStVasZHrKR/JpV7ldQ1gRmImc0yNYw
 Ch51lpl7AeGzkZwYOZrXSR4OWKc5bPxjw/tliWPkeHuyhdZH59NvYSqE9ZJ7/JRazAOgMS5HN
 j5ohyglFYFGM5PB7pLegV6Ze4tuhGTmZp5/WCMLXciq8C6sSZQqLEjYC63qBIQ6OagxNpPDed
 a1kSkcKSdgzGaBKyW/yTu32BNgyFTKIsdH4C8Jj8TzyD5WZoU/astR6yZN6UyZw8WfXyFt0rl
 gNh0wPeo7rDK6GMzLvZt8KlWzdZLv/GwAUZCJw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 9:03 AM Hector Martin <marcan@marcan.st> wrote:
>
> These operations are documented as always ordered in
> include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
> type use cases where one side needs to ensure a flag is left pending
> after some shared data was updated rely on this ordering, even in the
> failure case.
>
> This is the case with the workqueue code, which currently suffers from a
> reproducible ordering violation on Apple M1 platforms (which are
> notoriously out-of-order) that ends up causing the TTY layer to fail to
> deliver data to userspace properly under the right conditions. This
> change fixes that bug.
>
> Change the documentation to restrict the "no order on failure" story to
> the _lock() variant (for which it makes sense), and remove the
> early-exit from the generic implementation, which is what causes the
> missing barrier semantics in that case. Without this, the remaining
> atomic op is fully ordered (including on ARM64 LSE, as of recent
> versions of the architecture spec).
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: stable@vger.kernel.org
> Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
> Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  Documentation/atomic_bitops.txt     | 2 +-
>  include/asm-generic/bitops/atomic.h | 6 ------

I double-checked all the architecture specific implementations to ensure
that the asm-generic one is the only one that needs the fix.

I assume this gets merged through the locking tree or that Linus picks it up
directly, not through my asm-generic tree.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
