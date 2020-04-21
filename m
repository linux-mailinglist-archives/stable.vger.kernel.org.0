Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AFD1B1F65
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 09:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgDUHC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 03:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgDUHC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 03:02:29 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 518F22087E;
        Tue, 21 Apr 2020 07:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587452548;
        bh=yvErlf1ujCEjMuZ1HZhQNIJgQdLtBuEUCgoQdnqZWIc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y0ypIU01zjeTlzT53B8egS3zgE+CoGdF87n9WorvBDR9TlY51Nnqz5sevwJSayFWQ
         VAM6zmWgjEbe5QWMAgg5I0qToX2KyMmlIQgFDTszV1NpT4s+lkqG8dPcLP+20AAOUw
         WHp8QwbOG7cfkhHP3wXHd6wt+qi+dZIahIfrK2J8=
Received: by mail-io1-f51.google.com with SMTP id n10so13915387iom.3;
        Tue, 21 Apr 2020 00:02:28 -0700 (PDT)
X-Gm-Message-State: AGi0PuZlU27pKRX19Wy7aHiQ9KeKvJX3RNPSSNZWRJeC/sI6btFXzDQD
        8l8tn7uK7IFoUc3PO2rH2ELHOHZHhqKbDVUFAaM=
X-Google-Smtp-Source: APiQypJ7U9stCkpY+B3uQDUazOYm7Gv5hkpH/DE6YibToZivYDs+sA9EjIN2vouOcJjK6KTOFzro6D3C6jpn/y7lRBQ=
X-Received: by 2002:a02:8247:: with SMTP id q7mr17940310jag.68.1587452547702;
 Tue, 21 Apr 2020 00:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
 <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
In-Reply-To: <CAHmME9pq2Kdrp5C1+90PQyXsaG8xfdRwG-xGNs5U0ykVORrMbw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Apr 2020 09:02:16 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEdWu1v0tGT2Co0oMqWDJS_FNx97qZJmp3GPrrj8MrnrQ@mail.gmail.com>
Message-ID: <CAMj1kXEdWu1v0tGT2Co0oMqWDJS_FNx97qZJmp3GPrrj8MrnrQ@mail.gmail.com>
Subject: Re: FPU register granularity [Was: Re: [PATCH crypto-stable] crypto:
 arch/lib - limit simd usage to PAGE_SIZE chunks]
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Apr 2020 at 06:15, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi David,
>
> On Mon, Apr 20, 2020 at 2:32 AM David Laight <David.Laight@aculab.com> wrote:
> > Maybe kernel_fp_begin() should be passed the address of somewhere
> > the address of an fpu save area buffer can be written to.
> > Then the pre-emption code can allocate the buffer and save the
> > state into it.
>
> Interesting idea. It looks like `struct xregs_state` is only 576
> bytes. That's not exactly small, but it's not insanely huge either,
> and maybe we could justifiably stick that on the stack, or even
> reserve part of the stack allocation for that that the function would
> know about, without needing to specify any address.
>
> > kernel_fpu_begin() ought also be passed a parameter saying which
> > fpu features are required, and return which are allocated.
> > On x86 this could be used to check for AVX512 (etc) which may be
> > available in an ISR unless it interrupted inside a kernel_fpu_begin()
> > section (etc).
> > It would also allow optimisations if only 1 or 2 fpu registers are
> > needed (eg for some of the crypto functions) rather than the whole
> > fpu register set.
>
> For AVX512 this probably makes sense, I suppose. But I'm not sure if
> there are too many bits of crypto code that only use a few registers.
> There are those accelerated memcpy routines in i915 though -- ever see
> drivers/gpu/drm/i915/i915_memcpy.c? sort of wild. But if we did go
> this way, I wonder if it'd make sense to totally overengineer it and
> write a gcc/as plugin to create the register mask for us. Or, maybe
> some checker inside of objtool could help here.
>
> Actually, though, the thing I've been wondering about is actually
> moving in the complete opposite direction: is there some
> efficient-enough way that we could allow FPU registers in all contexts
> always, without the need for kernel_fpu_begin/end? I was reversing
> ntoskrnl.exe and was kind of impressed (maybe not the right word?) by
> their judicious use of vectorisation everywhere. I assume a lot of
> that is being generated by their compiler, which of course gcc could
> do for us if we let it. Is that an interesting avenue to consider? Or
> are you pretty certain that it'd be a huge mistake, with an
> irreversible speed hit?
>

When I added support for kernel mode SIMD to arm64 originally, there
was a kernel_neon_begin_partial() that took an int to specify how many
registers were being used, the reason being that NEON preserve/store
was fully eager at this point, and arm64 has 32 SIMD registers, many
of which weren't really used, e.g., in the basic implementation of AES
based on special instructions.

With the introduction of lazy restore, and SVE handling for userspace,
we decided to remove this because it didn't really help anymore, and
made the code more difficult to manage.

However, I think it would make sense to have something like this in
the general case. I.e., NEON registers 0-3 are always preserved when
an exception or interrupt (or syscall) is taken, and so they can be
used anywhere in the kernel. If you want the whole set, you will have
to use begin/end as before. This would already unlock a few
interesting case, like memcpy, xor, and sequences that can easily be
implemented with only a few registers such as instructio based AES.

Unfortunately, the compiler needs to be taught about this to be
completely useful, which means lots of prototyping and benchmarking
upfront, as the contract will be set in stone once the compilers get
on board.
