Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48E61A12B9
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGR25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:28:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38741 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgDGR25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:28:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id l11so3030957lfc.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4zBowDsk8SE9XIHjyrUakYlZAvAxnPCEwiNhH5fwjuY=;
        b=Xdrw0xDwBHfCEmGTfzNnWznVG+4AGONJjDQN1h/lv9hhV/dTjZ04MAALboJJD39wFV
         +RqBuvJ+THImYmVKF0P4MGtL+IkFO6kt3MfXs/+Zveld1YcErLWxARFrTvtTcKPOwNOp
         9Br+gwL2oWeO6ACGXesYVoatyDyydJEGdNrLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4zBowDsk8SE9XIHjyrUakYlZAvAxnPCEwiNhH5fwjuY=;
        b=nQobjJ15gUhKLhZnapt1+qG2Wu+I0M92rIJ+9mnpdus3NsFzzELHMYYTOWZfSlSEFQ
         ilwtQuOi9agWELb5ogz/bsUq6gJevNH5b7oZ/jkhd0AqOXju2dE3xhbagYapYHar78w4
         zdCGtVBlW1OWPZzZLxQQCQRYxX9zBJljKGO41BQOBOJ2vpm76N3u+sOT1P00tDZrPVmw
         7CSBEO1uDig5oXD3f0/eVIagxXPPXVJ5NJ83XRZVpsgEpQbmCBSbaH75aObzMB6VvBPS
         gHG5CEUu/89hKgKeLDtv3OLL8EHeRfIYMu2iSXhesipfxHQpZ/wH0Pf2Pujkll3bCH/D
         QwXg==
X-Gm-Message-State: AGi0Puam+210+6ERxbB8GrY9ZnqHTJ1b+xEkNqmJjUIAZDYR/0VERRTf
        mKygb8kTVlunEIlkMrgz12JHvXmlETU=
X-Google-Smtp-Source: APiQypIW7y3WgwjzxEYgkv1pSod+K41yMtzl/o2creThOM9MAQOJcK/qK/6Xv/83zK8TjthK4mcSRg==
X-Received: by 2002:a19:c8cf:: with SMTP id y198mr2001644lff.197.1586280532296;
        Tue, 07 Apr 2020 10:28:52 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id i20sm12089165lja.17.2020.04.07.10.28.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 10:28:51 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id z26so538228ljz.11
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 10:28:50 -0700 (PDT)
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr2257750ljc.209.1586280530396;
 Tue, 07 Apr 2020 10:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <158627540139.8918.10102358634447361335@build.alporthouse.com>
In-Reply-To: <158627540139.8918.10102358634447361335@build.alporthouse.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Apr 2020 10:28:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
Message-ID: <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 7, 2020 at 9:04 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> It'll take some time to reconstruct the original report, but the case in
> question was in removing the last element of the list of the last list,
> switch to a global lock over all such lists to park the HW, which in
> doing so added one more element to the original list. [If we happen to
> be retiring along the kernel timeline in the first place.]

Please point to the real code and the list.

Honestly, what you describe sounds complex enough that I think your
locking is simply just buggy.

IOW, this patch seems to really just paper over a locking bug, and the
KASAN report tied to it.

Because the fundamental issue is that READ_ONCE() can not fix a bug
here. Reading the next pointer once fundamentally cannot matter if it
can change concurrently: the code is buggy, and the READ_ONCE() just
means that it gets one or the other value randomly, and that the list
walking is fundamentally racy.

One the other hand, if the next pointer _cannot_ change concurrently,
then READ_ONCE() cannot make a difference.

So as fat as I can tell, we have two possibilities, and in both cases
changing the code to use READ_ONCE() is not the right thing to do. In
one case it hides a bug, and in another case it's just pointless.

> list->next changed from pointing to list_head, to point to the new
> element instead. However, we don't have to check the next element yet
> and want to terminate the list iteration.

I'd really like to see the actual code that has that list walking. You say:

> For reference,
> drivers/gpu/drm/i915/gt/intel_engine_pm.c::__engine_park()

.. but that function doesn't have any locking or list-walking. Is it
the "call_idle_barriers()" loop? What is it?

I'd really like to see the KASAN report and the discussion about this change.

And if there was no discussion, then the patch just seems like "I
changed code randomly and the KASAN report went away, so it's all
good".

> Global activity is serialised by engine->wakeref.mutex; every active
> timeline is required to hold an engine wakeref, but retiring is local to
> timelines and serialised by their own timeline->mutex.
>
> lock(&timeline->lock)
> list_for_each_safe(&timeline->requests)
>   \-> i915_request_retire [list_del(&timeline->requests)]
>    \-> intel_timeline_exit
>     \-> lock(&engine->wakeref.mutex)
>         engine_park [list_add_tail(&engine->kernel_context->timeline->requests)]

in that particular list_for_each_safe() thing, there's no possibility
that the 'next' field would be reloaded, since the list_del() in the
above will be somethign the compiler is aware of.

So yes, the beginning list_for_each_safe() might load it twice (or a
hundred times), but by the time that list_del() in
i915_request_retire() has been called, if the compiler then reloads it
afterwards, that would be a major compiler bug, since it's after that
value could have been written in the local thread.

So this doesn't explain it to me.

What it *sounds* like is that the "engine" lock that you do *not* hold
initially, is not protecting some accessor to that list, so you have a
race on the list at the time of that list_del().

And that race may be what KASAN is reporting, and what that patch is
_hiding_ from KASAN - but not fixing.

See what I am saying and why I find this patch questionable?

There may be something really subtle going on, but it really smells
like "two threads are modifying the same list at the same time".

And there's no way that the READ_ONCE() will fix that bug, it will
only make KASAN shut up about it.

                  Linus
