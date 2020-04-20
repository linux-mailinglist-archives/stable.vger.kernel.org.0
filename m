Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8AA1B00E4
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 07:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgDTFIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 01:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgDTFIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 01:08:36 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FD8C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 22:08:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id f12so6332237edn.12
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 22:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uosnnvhWZ3yyd1hjeyEdalFBW58ozyttD3SAmZ9epkk=;
        b=eoqWpiOwRq7oi4XyC2As+GUHLC5NEcZO1OOE4PRCK1UPnSV64nsIERwHkSaXSb1dXW
         8ciCXTUnSaOgWRKxTBfIk/x746ztoISrwImvbu7zUF//ygyqTnbEwNtwad8pWAE0tlLF
         804WRCHLh/Po0dTXTLal3QEkVr8WjIdRa7gF/K9a+6RXlUwuMEDBQgKPvyO9l6kBNiFQ
         sROA4R4733K1cB+fGzkmc2I49Ou2AL4qMfdApkWJwUKs1HpyfYya8lM6KJGumgV4MRl4
         rKnBTsXYivznrdqhvAu6F57Kt1Wj4IbjIQ1/BkGhB7vdWkBLJOEtt0vSTZFUHrXOIUX6
         OZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uosnnvhWZ3yyd1hjeyEdalFBW58ozyttD3SAmZ9epkk=;
        b=nQseXfss8KHZ0g18yX5ypDlmQP5/J3VRaaTb57b3fjXqzr9fLogph5cBPlvgxk5alA
         BozjyO4K6n2oI7cdxXyxTI0ki6/AD5Xkk4HMzDW96ofaiX4NkN4nxE8YGSTy0RlIDDDW
         4Pru83tCJQpcn7IEmPjV240iSj10rgIrWSixItegPrKLEC1+cs6ifTGDekOmAFoE5t2s
         NtgzRlHyQ9VrgSjhsGvaXYaLLVUqZwKDpJ7hlsvDyYxtg/FZTjMRcBX9PTGiwsBit5ZY
         woRykxc/VTWJzYv2U8yWY9tMc5P0Mqb9MndYYlhqT8ObPwX6Ii29FLg8V6dF2mvyow1z
         NPwQ==
X-Gm-Message-State: AGi0PuaVgk+MRycL8t0S9yVlWedZbdO5tf1/RPtCeiC7l406wBjfLP3B
        59R/vyiJB6aFlcXQFoR+UfAGnt49Rwi3DMN2hp3F1w==
X-Google-Smtp-Source: APiQypKvZgj9wXFg38gj+SIw0DMo/cjC6QoMNTqE70yXQ5Mpi1Piz373LSRUoNAHXo/kXfpbyB4oZQtKaQOTioBGdeE=
X-Received: by 2002:a05:6402:2203:: with SMTP id cq3mr921641edb.154.1587359314565;
 Sun, 19 Apr 2020 22:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net> <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
In-Reply-To: <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sun, 19 Apr 2020 22:08:23 -0700
Message-ID: <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 1:52 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Apr 18, 2020 at 1:30 PM Andy Lutomirski <luto@amacapital.net> wro=
te:
> >
> > Maybe I=E2=80=99m missing something obvious, but what=E2=80=99s the alt=
ernative?  The _mcsafe variants don=E2=80=99t just avoid the REP mess =E2=
=80=94 they also tell the kernel that this particular access is recoverable=
 via extable.
>
> .. which they could easily do exactly the same way the user space
> accessors do, just with a much simplified model that doesn't even care
> about multiple sizes, since unaligned accesses weren't valid anyway.
>
> The thing is, all of the MCS code has been nasty. There's no reason
> for it what-so-ever that I can tell. The hardware has been so
> incredibly broken that it's basically unusable, and most of the
> software around it seems to have been about testing.
>
> So I absolutely abhor that thing. Everything about that code has
> screamed "yeah, we completely mis-designed the hardware, we're pushing
> the problems into software, and nobody even uses it or can test it so
> there's like 5 people who care".
>
> And I'm pushing back on it, because I think that the least the code
> can do is to at least be simple.
>
> For example, none of those optimizations should exist. That function
> shouldn't have been inline to begin with. And if it really really
> matters from a performance angle that it was inline (which I doubt),
> it shouldn't have looked like a memory copy, it should have looked
> like "get_user()" (except without all the complications of actually
> having to test addresses or worry about different sizes).
>
>
> And it almost certainly shouldn't have been done in low-level asm
> either. It could have been a single "read aligned word" interface
> using an inline asm, and then everything else could have been done as
> C code around it.

Do we have examples of doing exception handling from C? I thought all
the exception handling copy routines were assembly routines?

>
> But no. The software side is almost as messy as the hardware side is.
> I hate it. And since nobody sane can test it, and the broken hardware
> is _so_ broken than nobody should ever use it, I have continually
> pushed back against this kind of ugly nasty special code.
>
> We know the writes can't fault, since they are buffered. So they
> aren't special at all.

The writes can mmu-fault now that memcpy_mcsafe() is also used by
_copy_to_iter_mcsafe(). This allows a clean bypass of the block layer
in fs/dax.c in addition to the pmem driver access of poisoned memory.
Now that the fallback is a sane rep; movs; it can be considered for
plain copy_to_iter() for other user copies so you get exception
handling on kernel access of poison outside of persistent memory. To
Andy's point I think a recoverable copy (for exceptions or faults) is
generally useful.

> We know the acceptable reads for the broken hardware basically boil
> down to a single simple word-size aligned read, so you need _one_
> special inline asm for that. The rest of the cases can be handled by
> masking and shifting if you really really need to - and done better
> that way than with byte accesses anyway.
>
> Then you have _one_ C file that implements everything using that
> single operation (ok, if people absolutely want to do sizes, I guess
> they can if they can just hide it in that one file), and you have one
> header file that exposes the interfaces to it, and you're done.
>
> And you strive hard as hell to not impact anything else, because you
> know that the hardware is unacceptable until all those special rules
> go away. Which they apparently finally have.

I understand the gripes about the mcsafe_slow() implementation, but
how do I implement mcsafe_fast() any better than how it is currently
organized given that, setting aside machine check handling,
memcpy_mcsafe() is the core of a copy_to_iter*() front-end that can
mmu-fault on either source or destination access?
