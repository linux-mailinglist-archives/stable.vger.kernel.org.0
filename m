Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F3059549E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiHPILH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiHPIKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:10:36 -0400
X-Greylist: delayed 41899 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 22:36:40 PDT
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE1C67C84;
        Mon, 15 Aug 2022 22:36:40 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9D5EB447D6;
        Tue, 16 Aug 2022 05:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660628198; bh=LDV8KEPCOtRgxMbfux9/6KsJjkeggvwXB+aHn8IlWLI=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=EcSu5BD6o5VrpBFcpBXJIz6I/+WaBA0jWNVC8P/rW4gyyZncMVpPk1bJgjIK5ksTW
         fHqtXhFxFgAWCzs7stoll3p0mS2G/dTkmwoCCbvyqO+CLva3jPNvavrtR5GWCKtDli
         2k45NWTqBLW3zOpP83gvbLc9/hQ2RrjzZv/xWgOqK670RCY5oY2mihSGfXOoFOM3Pd
         L1Wj81O5ZhAmR99xY6Jvce2M6GvxekL6bBHrcL2OfG1ByMfu2plrwW032Fj67Egexc
         mfSW4St7Shka/buVYsWjsTV1EW/c0OevIMBwJszNcv7hVP4nQrWtm7gfo+wKuHymKc
         WhbfgvKJgpG0Q==
Message-ID: <cd51b422-89f3-1856-5d3b-d6e5b0029085@marcan.st>
Date:   Tue, 16 Aug 2022 14:36:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: es-ES
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        boqun.feng@gmail.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <YvqaK3hxix9AaQBO@slm.duckdns.org>
 <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
In-Reply-To: <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/08/2022 14.27, Linus Torvalds wrote:
> On Mon, Aug 15, 2022 at 9:15 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> Please revert this as test_and_set_bit was always supposed to be
>> a full memory barrier.  This is an arch bug.
> 
<snip>
> From looking at it, the asm-generic implementation is a bit
> questionable, though. In particular, it does
> 
>         if (READ_ONCE(*p) & mask)
>                 return 1;
> 
> so it's *entirely* unordered for the "bit was already set" case.

These ops are documented in Documentation/atomic_bitops.txt as being
unordered in the failure ("bit was already set" case), and that matches
the generic implementation (which arm64 uses).

On the other hand, Twitter just pointed out that contradicting
documentation exists (I believe this was the source of the third party
doc I found that claimed it's always a barrier):

include/asm-generic/bitops/instrumented-atomic.h

So either one doc and the implementation are wrong, or the other doc is
wrong.

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

That does work, I in fact tried that fix first to prove that the
early-exit was the problem.

I don't have a particularly strong opinion on which way is right here, I
just saw the implementation matched the docs (that I found) and Will
commented on the other thread implying this was all deliberate.

- Hector
