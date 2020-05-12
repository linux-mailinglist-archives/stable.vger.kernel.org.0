Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910C31CE9BF
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgELAoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:44:04 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35809 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbgELAoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 20:44:03 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 61348260;
        Tue, 12 May 2020 00:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8DMV4dM1KIt+JaIU385jNEGQIbs=; b=K+KyXU
        0jtMQUdbMQIAHKaqePtsyFdwejC4naBxxOFyE5fCOKlgmFzXyHZ8XwH7PZz0U4mt
        YMocHCUVu1OyS75jHZjbH6LphCQKMHhoN7FbczugZwZAOpTN3MkTRqoomEAVMU5u
        xG7roQ6EOdxBz0PzFoK4Q7J0QYB5asJdkAt2KcWXvIAdzKex4XvuF8HJSZT8dIRu
        xLTv1aUxT1Sg4KIvxGbpE08XTh+MS3F1uTlEneXofTObI1bljqR97ah4GpZ9Cmop
        SIpPGSi+EYWKdmcKENDYdJuWQENAxbxFZayOkIZwsM+tOELwpBNgYHS1ew9uZPjD
        +HWO8KlX9ToOug8Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7ca4cff8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 12 May 2020 00:30:37 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id f3so12008026ioj.1;
        Mon, 11 May 2020 17:43:59 -0700 (PDT)
X-Gm-Message-State: AGi0PuaA5Uq/rkTNbai7wWRHQE5CAK7MNXW/Qx56/0C6HW6xQ3QP/YHd
        /xsvmAqjo/f+BN5bkdD8mGvVHQVKyljtcvToTVM=
X-Google-Smtp-Source: APiQypJNbNU2t/ivDnEN/72r9GA+zKw7tmqjTlNbMTmB5sNJ+KbPBu5AJRv/PL9LMyJr/DYFUmPGS3iMuNy8lp1oQcw=
X-Received: by 2002:a6b:e509:: with SMTP id y9mr8237253ioc.67.1589244238910;
 Mon, 11 May 2020 17:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200508090202.7s3kcqpvpxx32syu@butterfly.localdomain>
 <20200511215720.303181-1-Jason@zx2c4.com> <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
In-Reply-To: <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 11 May 2020 18:43:48 -0600
X-Gmail-Original-Message-ID: <CAHmME9pXnYurszyvX8FAYHbMysknpegUSF1g2wZPdBybxD-xZQ@mail.gmail.com>
Message-ID: <CAHmME9pXnYurszyvX8FAYHbMysknpegUSF1g2wZPdBybxD-xZQ@mail.gmail.com>
Subject: Re: [PATCH v2] Kconfig: default to CC_OPTIMIZE_FOR_PERFORMANCE_O3 for
 gcc >= 10
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 6:05 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> There's a reason -O3 isn't even offered as an option.
>
> Maybe things have changed, and maybe they've improved. But I'd like to
> see actual numbers for something like this.
>
> Not inlining as aggressively is not necessarily a bad thing. It can
> be, of course. But I've actually also done gcc bugreports about gcc
> inlining too much, and generating _worse_ code as a result (ie
> inlinging things that were behind an "if (unlikely())" test, and
> causing the likely path to grow a stack fram and stack spills as a
> result).
>
> So just "O3 inlines more" is not a valid argument.

Alright. It might be possible to produce some benchmarks, and then
isolate the precise inlining parameter that makes the difference, and
include that for gcc-10. But you made a compelling argument in that
old gcc bug report about not going down the finicky rabbit hole of gcc
inlining switches that seem to change meaning between releases, which
is persuasive.

The other possibility would be if -O3 actually isn't bad like it used
to be and the codegen is markedly better, alongside some numbers to
back it up. I'm not presently making that argument and don't have
those numbers, but perhaps others who were interested in this patch
for other reasons do have strong arguments there and want to chime in.
Otherwise, no problem dropping this.
