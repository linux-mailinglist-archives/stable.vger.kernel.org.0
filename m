Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301761B1D48
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 06:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgDUEPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 00:15:04 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42415 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgDUEPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 00:15:03 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f5e862ce;
        Tue, 21 Apr 2020 04:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=SCC7Nyh/luGgw0Jn0MvH0KrPL5g=; b=tGIrIQ
        ihiZmCQXqw1aQyKisuH3Tluqj48c4ZbQtiMf2ArKqDzQP9zqT6z34tQitr5TrHGt
        jNb168YP7ncsCgDRaVAj0R2F//qfkOm8/vi/kRrWV8mzOEGzVp5MHznRTqqP2fQR
        ECJ9Z0azAjvYlROusS3sGm43e7b1zLdLEI8OqxZYJNhUFDqlne4iMNevJVtlPxwN
        aEXHnF1VXPgkP9DPBsMScshRUV6UMiy8OtoG89mN8CQNbNQp9voH1SdsU0aW19Oc
        nN0j+SHPqkZsoWXUdouWEsFEzf7X79emB4UoDnrbmm7t4FPcTowK7HHFtIacOnci
        STEbTOXtXsZJYnVw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cb957bb6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 21 Apr 2020 04:04:19 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id x2so10829291ilp.13;
        Mon, 20 Apr 2020 21:15:00 -0700 (PDT)
X-Gm-Message-State: AGi0PuZXTN0Ql8Lc+4AbAILHkf6jURlU5MZLiPocHglLvcA9iKLa0yYS
        JQmGQpUmUwov89qaIcvVzvqmvn+QKUD1GrPSVLM=
X-Google-Smtp-Source: APiQypKs3xcAonoYbr0zq9wk52DzVARE1y8W5SScl+cyeH4qIm5NFAbKA6Cteu0VTtRe9tOKsiDvPBa+7sbONYqzXLo=
X-Received: by 2002:a92:d98c:: with SMTP id r12mr19565542iln.224.1587442500210;
 Mon, 20 Apr 2020 21:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
In-Reply-To: <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Apr 2020 22:14:49 -0600
X-Gmail-Original-Message-ID: <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
Message-ID: <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
Subject: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
To:     David Laight <David.Laight@aculab.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Mon, Apr 20, 2020 at 2:32 AM David Laight <David.Laight@aculab.com> wrote:
> Maybe kernel_fp_begin() should be passed the address of somewhere
> the address of an fpu save area buffer can be written to.
> Then the pre-emption code can allocate the buffer and save the
> state into it.

Interesting idea. It looks like `struct xregs_state` is only 576
bytes. That's not exactly small, but it's not insanely huge either,
and maybe we could justifiably stick that on the stack, or even
reserve part of the stack allocation for that that the function would
know about, without needing to specify any address.

> kernel_fpu_begin() ought also be passed a parameter saying which
> fpu features are required, and return which are allocated.
> On x86 this could be used to check for AVX512 (etc) which may be
> available in an ISR unless it interrupted inside a kernel_fpu_begin()
> section (etc).
> It would also allow optimisations if only 1 or 2 fpu registers are
> needed (eg for some of the crypto functions) rather than the whole
> fpu register set.

For AVX512 this probably makes sense, I suppose. But I'm not sure if
there are too many bits of crypto code that only use a few registers.
There are those accelerated memcpy routines in i915 though -- ever see
drivers/gpu/drm/i915/i915_memcpy.c? sort of wild. But if we did go
this way, I wonder if it'd make sense to totally overengineer it and
write a gcc/as plugin to create the register mask for us. Or, maybe
some checker inside of objtool could help here.

Actually, though, the thing I've been wondering about is actually
moving in the complete opposite direction: is there some
efficient-enough way that we could allow FPU registers in all contexts
always, without the need for kernel_fpu_begin/end? I was reversing
ntoskrnl.exe and was kind of impressed (maybe not the right word?) by
their judicious use of vectorisation everywhere. I assume a lot of
that is being generated by their compiler, which of course gcc could
do for us if we let it. Is that an interesting avenue to consider? Or
are you pretty certain that it'd be a huge mistake, with an
irreversible speed hit?

Jason
