Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E47BE3174
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 13:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439441AbfJXLvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 07:51:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41636 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730557AbfJXLve (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 07:51:34 -0400
Received: by mail-qk1-f196.google.com with SMTP id p10so23090236qkg.8
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 04:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fn71rS6ReHvy4UBLvwf94Jworjf0D0oVW+GNxGRscwE=;
        b=fCanMbbThrjQ8BD1rKmwg7faRCTM9M3H48xUKhe8TvnCH1bzJfuGFeLvZ5W6+aAXV0
         nm6R1jR9Hsv7ETPrzmmHJ6GzAoOKpw2yuc/ZnWZqvLypmiRPxlSBrFUYOowfg02DQCx5
         nGOBmTZtj219z7P+SAO7uKe3pZChryDOLtwiIwUENGEvMy11k338XaT3srqPR4vgoWsb
         u+qIimV7ArVdxpwHJLD+te8PR7+I5bheOqtXrCcddeXoyFpVv0/2TEOlen9dBOUbLtiq
         Uth+M7QzikkXJPW/M9656ra3UVRFKMxE0TtCvOWisoK0c/gWpOo5fbJlJrxQxJWy9fVG
         fYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fn71rS6ReHvy4UBLvwf94Jworjf0D0oVW+GNxGRscwE=;
        b=n26gXJNL0/KDyQOujINNOGBNmUiQd4Sag7LH+snFwI8h/qrLpNuCoUzEVLPQEzKGzs
         GBTt0jtBGXAYrMRTAydhCFQ5GP0ee38kXBohUPEQW6iDLs3Cr6C21NTdjsMr+V8+add5
         iPpajq9smzFxeRcD/XnFc6jBNSFzH22Vg3CIWG3R98nigLu9AdaM3WYNs/qU2Xra5Rv6
         papH7HgVHU44cErrxi8pkaYbz431O5UhH5R7/0Ax/zyKeV4+1hIEd6yAP51ZigJ9xICa
         Mi/vaS81gy9OQGckao7GzxiNioepwpS4Y+W4rIWKRrX27eu3lFOdyOkWj8EPN0AAy3eN
         oyBg==
X-Gm-Message-State: APjAAAVwIEXZAxCOty6Y8P9kdbEf0xnNe4OzVbYpljU+9cKAE9dAK0G/
        ect8klGmajk9u2BZnxoDvFH/XJfz4WE36ZLvuqyNrw==
X-Google-Smtp-Source: APXvYqy9hgBd93nPeWGRHTk3cy25U/c44xf7hFfKXooycp0aSt7g/D0iewfPfLS973ff2Y3BmC8nPcng6i/Dm+0JgnY=
X-Received: by 2002:a37:4a87:: with SMTP id x129mr2134986qka.43.1571917893077;
 Thu, 24 Oct 2019 04:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com> <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Oct 2019 13:51:20 +0200
Message-ID: <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 1:32 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> > How these later loads can be completely independent of the pointer
> > value? They need to obtain the pointer value from somewhere. And this
> > can only be done by loaded it. And if a thread loads a pointer and
> > then dereferences that pointer, that's a data/address dependency and
> > we assume this is now covered by READ_ONCE.
>
> The "dependency" I was considering here is a dependency _between the
> load of sig->stats in taskstats_tgid_alloc() and the (program-order)
> later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
> such a dependency should correspond to a dependency chain at the asm
> or registers level from the first load to the later loads; e.g., in:
>
>   Thread [register r0 contains the address of sig->stats]
>
>   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
>      ...
>   B: LOAD r2,[r0]       // LOAD *(sig->stats)
>   C: LOAD r3,[r2]
>
> there would be no such dependency from A to C.  Compare, e.g., with:
>
>   Thread [register r0 contains the address of sig->stats]
>
>   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
>      ...
>   C: LOAD r3,[r1]       // LOAD *(sig->stats)
>
> AFAICT, there's no guarantee that the compilers will generate such a
> dependency from the code under discussion.

Fixing this by making A ACQUIRE looks like somewhat weird code pattern
to me (though correct). B is what loads the address used to read
indirect data, so B ought to be ACQUIRE (or LOAD-DEPENDS which we get
from READ_ONCE).

What you are suggesting is:

addr = ptr.load(memory_order_acquire);
if (addr) {
  addr = ptr.load(memory_order_relaxed);
  data = *addr;
}

whereas the canonical/non-convoluted form of this pattern is:

addr = ptr.load(memory_order_consume);
if (addr)
  data = *addr;

Moreover the second load of ptr is not even atomic in our case, so it
is a subject to another data race?
