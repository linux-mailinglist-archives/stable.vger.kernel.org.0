Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697BC595483
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiHPIGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiHPIFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:05:14 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253C83ED51
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:27:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r4so12052922edi.8
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8GCiBPOuQM/bTY94OlYfkl/LuAf0jjQOGAAIwdS74Fg=;
        b=JisZo1jwcqMFxEogkyBSj7CD2OQejIZwVaBZLDUMPXyd1/XDJk4yhm5S4XaUclV41a
         DNf6C3jtGn/ICcktl7kKvB8oEvCJEthJjCnq/oKtpHE4qJRvd1ePCf/5cpTiwt6ADx8y
         6ZKi3THb4uQY/A2F+hAzzTdYwLtU3q7b8PgG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8GCiBPOuQM/bTY94OlYfkl/LuAf0jjQOGAAIwdS74Fg=;
        b=lF3vQTeY/mCbUjeVqUuAQBCHX4WK6V5WIyKFDOFgOiJWXioVVop8HuF/9rl/ZW+ZGI
         0lgAiNmKlq66Ae7X/a/HxfEQQqt8K9bjuJBEurBq8sg6RVG+jaKPsYPYWtvdviQ0oRMM
         VOXq4L0nIaqibilyDuP1yEDtE+SMg3c6ocdLnXedbzEwM+9jNn44PujIfJvKrcZPTtGm
         iVoPaUaYr96w6QEkTVcNMhisVfPVJyzzXftANU+FfFDGadrOA0oKO65Wk9B3VEW9TdxH
         7AAjIEGBS/9OGN+lMhLLEPZVG3p7mQ/xtMAy3Sca+ebqTsQ3QDJAbdeBST53o7kwFAoE
         LRBA==
X-Gm-Message-State: ACgBeo17JotYBfbHCwur5stCjuMu1h+s7cBFa/EFlY+sKYC34bXkaW4A
        0zlY/eRt0QvpmNgJVTOU50vdOOelBY71doBih28=
X-Google-Smtp-Source: AA6agR5xH6yhIy3E6ttF9aaReD4JD1Nq/VvhTR3b50BKXB137F56TxmSLEbJSw8n6xGBisv+Y05c9A==
X-Received: by 2002:a05:6402:518b:b0:43e:70be:97cd with SMTP id q11-20020a056402518b00b0043e70be97cdmr17459659edd.388.1660627648226;
        Mon, 15 Aug 2022 22:27:28 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id wi2-20020a170906fd4200b007308bebce51sm4908439ejb.171.2022.08.15.22.27.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 22:27:27 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id j7so11284213wrh.3
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 22:27:27 -0700 (PDT)
X-Received: by 2002:a5d:6248:0:b0:222:cd3b:94c8 with SMTP id
 m8-20020a5d6248000000b00222cd3b94c8mr10739050wrv.97.1660627646821; Mon, 15
 Aug 2022 22:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <YvqaK3hxix9AaQBO@slm.duckdns.org> <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
In-Reply-To: <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Aug 2022 22:27:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
Message-ID: <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, marcan@marcan.st, peterz@infradead.org,
        jirislaby@kernel.org, maz@kernel.org, mark.rutland@arm.com,
        boqun.feng@gmail.com, catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 9:15 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Please revert this as test_and_set_bit was always supposed to be
> a full memory barrier.  This is an arch bug.

Yes, the bitops are kind of strange for various legacy reasons:

 - set/clear_bit is atomic, but without a memory barrier, and need a
"smp_mb__before_atomic()" or similar for barriers

 - test_and_set/clear_bit() are atomic, _and_ are memory barriers

 - test_and_set_bit_lock and test_and_clear_bit_unlock are atomic and
_weaker_ than full memory barriers, but sufficient for locking (ie
acquire/release)

Does any of this make any sense at all? No. But those are the
documented semantics exactly because people were worried about
test_and_set_bit being used for locking, since on x86 all the atomics
are also memory barriers.

From looking at it, the asm-generic implementation is a bit
questionable, though. In particular, it does

        if (READ_ONCE(*p) & mask)
                return 1;

so it's *entirely* unordered for the "bit was already set" case.

That looks very wrong to me, since it basically means that the
test_and_set_bit() can return "bit was already set" based on an old
value - not a memory barrier at all.

So if you use "test_and_set_bit()" as some kind of "I've done my work,
now I am going to set the bit to tell people to pick it up", then that
early "bit was already set" code completely breaks it.

Now, arguably our atomic bitop semantics are very very odd, and it
might be time to revisit them. But that code looks very very buggy to
me.

The bug seems to go back to commit e986a0d6cb36 ("locking/atomics,
asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs"), and the
fix looks to be as simple as just removing that early READ_ONCE return
case (test_and_clear has the same bug).

Will?

IOW, the proper fix for this should, I think, look something like this
(whitespace mangled) thing:

   --- a/include/asm-generic/bitops/atomic.h
   +++ b/include/asm-generic/bitops/atomic.h
   @@ -39,9 +39,6 @@ arch_test_and_set_bit(
        unsigned long mask = BIT_MASK(nr);

        p += BIT_WORD(nr);
   -    if (READ_ONCE(*p) & mask)
   -            return 1;
   -
        old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
        return !!(old & mask);
    }
   @@ -53,9 +50,6 @@ arch_test_and_clear_bit
        unsigned long mask = BIT_MASK(nr);

        p += BIT_WORD(nr);
   -    if (!(READ_ONCE(*p) & mask))
   -            return 0;
   -
        old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
        return !!(old & mask);
    }

but the above is not just whitespace-damaged, it's entirely untested
and based purely on me looking at that code.

            Linus
