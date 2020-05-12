Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B401CEF61
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 10:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgELIod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 04:44:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:37344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgELIoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 04:44:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08421AE57;
        Tue, 12 May 2020 08:44:33 +0000 (UTC)
Date:   Tue, 12 May 2020 10:44:29 +0200 (CEST)
From:   Richard Biener <rguenther@suse.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v2] Kconfig: default to CC_OPTIMIZE_FOR_PERFORMANCE_O3
 for gcc >= 10
In-Reply-To: <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2005121037491.4397@zhemvz.fhfr.qr>
References: <20200508090202.7s3kcqpvpxx32syu@butterfly.localdomain> <20200511215720.303181-1-Jason@zx2c4.com> <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1609908220-634017890-1589273070=:4397"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1609908220-634017890-1589273070=:4397
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 May 2020, Linus Torvalds wrote:

> On Mon, May 11, 2020 at 2:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > GCC 10 appears to have changed -O2 in order to make compilation time
> > faster when using -flto, seemingly at the expense of performance, in
> > particular with regards to how the inliner works. Since -O3 these days
> > shouldn't have the same set of bugs as 10 years ago, this commit
> > defaults new kernel compiles to -O3 when using gcc >= 10.
> 
> I'm not convinced this is sensible.

Note the real thing that changed for GCC 10 at -O2 is that -O2
now includes -finline-functions which means GCC considers inlining
of functions not marked with 'inline' at -O2.  To counter code-size
growth and tune that back to previous levels the inlining limits
in effect at -O2 have been lowered.

Note this has been done based on analyzing larger C++ code and obviously
not because the kernel would benefit (IIRC kernel folks like 'inline'
to behave as written and thus rather may dislike the change to default to
-finline-functions).

> -O3 historically does bad things with gcc. Including bad things for
> performance. It traditionally makes code larger and often SLOWER.
> 
> And I don't mean slower to compile (although that's an issue). I mean
> actually generating slower code.
> 
> Things like trying to unroll loops etc makes very little sense in the
> kernel, where we very seldom have high loop counts for pretty much
> anything.
> 
> There's a reason -O3 isn't even offered as an option.

And I think that's completely sensible.  I would not recommend
to use -O3 for the kernel.  Somehow feeding back profile data
might help - though getting such data at all and with enough
coverage is probably hard.

As you said in the followup I wouldn't recommend tweaking GCCs
defaults for the various --param affecting inlining.  The behavior
with this is not consistent across releases.

Richard.

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
> 
>               Linus
> 

-- 
Richard Biener <rguenther@suse.de>
SUSE Software Solutions Germany GmbH, Maxfeldstrasse 5, 90409 Nuernberg,
Germany; GF: Felix Imendörffer; HRB 36809 (AG Nuernberg)
---1609908220-634017890-1589273070=:4397--
