Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD051A2AE5
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 23:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgDHVPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 17:15:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40526 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgDHVPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 17:15:00 -0400
Received: by mail-lj1-f194.google.com with SMTP id 142so4696719ljj.7
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 14:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tatDUkEu74fJwPgLRw2JZ+S0O3CWrMQzKjdHk2GEH4c=;
        b=ZCJNoBCZFsc4OT/9i1qz85T2vqFB754V8LwcT9UtL7kperRB0ACYsy9mwUhTMOwdTZ
         cyQIo+ysWh7Xu2ZnUStxeozjPNVYxyF/sjojmf/jmD2/NHrfZy72cD82mFPs3G2o0Hqf
         LZeDKiFF50stQUT8aTCHhIfZ+qMj4bo1DHtwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tatDUkEu74fJwPgLRw2JZ+S0O3CWrMQzKjdHk2GEH4c=;
        b=eH3s73hxd4ZiNYdzvF5GgRtJgSSSrOPqfXfQKqdk/J0L8wPSkgYA+tSBexVt059WMx
         pUnkCmQEtyGz+HSq5+Eokn0W10S93D9ZvR+uKUJpb4BSuqbIY0UJfQZupgMZx7Hs+21Z
         S6u1iutPsj1eZ6lWYMZ9wiy0cRJgdHA9nJ4UTGXABcMvgMoYiN3vLFZHKmUw9pButs5q
         RMBXOg1bYr8/BTtQS5V/fSK5PaYY/fNJUfTdeK2uKEFjTQExUi34vNkXLw7YRpEDCrsd
         X1PKO3ALucBzcZaSgSPAcHVb8POVUsRPqwrbzpgpuI9u6BOPGKBPB9hM60uTH2n560w4
         WSnA==
X-Gm-Message-State: AGi0PuY+Wvk4wDk5Zu0orS2iXbnVi+vUdiR5aRTP6LkcHZ0fyFqJISHZ
        i2EQvF3xkp5mzPqIMir4Ifdnxa2Lahc=
X-Google-Smtp-Source: APiQypIxRapSrWqO0IC4PMj5tY/VxLmDL2lMMs/jH1QEfdB2WZD01nwoSAj483su5mPTnjB32LTZDQ==
X-Received: by 2002:a2e:a0d8:: with SMTP id f24mr6114102ljm.270.1586380495935;
        Wed, 08 Apr 2020 14:14:55 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id j16sm13990169ljg.98.2020.04.08.14.14.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:14:54 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id q22so5496825ljg.0
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 14:14:54 -0700 (PDT)
X-Received: by 2002:a2e:a58e:: with SMTP id m14mr6104348ljp.204.1586380494037;
 Wed, 08 Apr 2020 14:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <20200408202630.GA1666@paulmck-ThinkPad-P72>
In-Reply-To: <20200408202630.GA1666@paulmck-ThinkPad-P72>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Apr 2020 14:14:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wicuF-BZj9b_Dbv+Ev8FT4XqULj2qMpkaUgEokNir345A@mail.gmail.com>
Message-ID: <CAHk-=wicuF-BZj9b_Dbv+Ev8FT4XqULj2qMpkaUgEokNir345A@mail.gmail.com>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 8, 2020 at 1:26 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> OK, it sounds like we need to specify what needs to be present in this
> sort of commit log.

That would have helped.

But in this case, after having looked more at it, it wasn't that the
commit log was not sufficient, it was that the change was wrong.

With a better commit log and a pointer to the KCSAN report, I would
have been able to make a better judgment call earlier, and not have
had to ask for more information.

But once I figured out what the problem was, it was clear that

 (a) what the i915 driver does is at a minimum questionable, and quite
likely actively buggy

 (b) even if it's not buggy in the i915 driver, changing the list
traversal macros to use READ_ONCE() would hide other places where it
most definitely is buggy.

> o       The KCSAN splat, optionally including file/line numbers.

I do think that the KCSAN splat - very preferably simplified and with
explanations - should basically always be included if KCSAN was the
reason.

Of course, the "simplified and with explanations" may be simplified to
the point where none of the original splat even remains. Those splats
aren't so legible that anybody should feel like they should be
included.

Put another way: an analysis that is so thorough that it makes the raw
splat data pointless is a *good* thing, and if that means that no
splat is needed, all the better.

> o       Detailed description of the problem this splat identifies, for
>         example, the code might fail to acquire a necessary lock, a plain
>         load might vulnerable to compiler optimizations, and so on.

See above: if the description is detailed enough, then the splat
itself becomes much less interesting.

But in this case, for example, it's worth pointing out that the "safe"
list accessors are used all over the kernel, and they are very much
_not_ thread-safe. The "safe" in them is purely about the current
thread removing an entry, not some kind of general thread-safeness.

Which is why I decided I really hated that patch - it basically would
make KCSAN unable to find _real_ races elsewhere, because it hid a
very special race in the i915 driver.

So I started out with the "that can't be right" kind of general
feeling of uneasiness about the patch. I ended up with a much more
specific "no, that's very much not right" and no amount of commit log
should have saved it.

As mentioned, I suspect that the i915 driver could actually use the
RCU-safe list walkers. Their particular use is not about RCU per se,
but it has some very similar rules about walking a list concurrently
with somebody adding an entry to it.

And the RCU list walkers do end up doing special things to load the
next pointer.

Whether we want to say - and document - that "ok, the RCU list walkers
are also useful for this non-RCU use case" in general might be worth
discussing.

It may be that the i915 use case is so special that it's only worth
documenting there.

              Linus
