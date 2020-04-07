Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387E91A10E5
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgDGQDa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Apr 2020 12:03:30 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:59520 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727991AbgDGQDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:03:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20829903-1500050 
        for multiple; Tue, 07 Apr 2020 17:03:20 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org> <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe' list iteration
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <158627540139.8918.10102358634447361335@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 07 Apr 2020 17:03:21 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Torvalds (2020-04-07 16:44:35)
> On Mon, Apr 6, 2020 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
> >
> > Instruct the compiler to read the next element in the list iteration
> > once, and that it is not allowed to reload the value from the stale
> > element later. This is important as during the course of the safe
> > iteration, the stale element may be poisoned (unbeknownst to the
> > compiler).
> 
> Andrew, Chris, this one looks rather questionable to me.
> 
> How the heck would the ->next pointer be changed without the compiler
> being aware of it? That implies a bug to begin with - possibly an
> inline asm that changes kernel memory without having a memory clobber.
> 
> Quite fundamentally, the READ_ONCE() doesn't seem to fix anything. If
> something else can change the list _concurrently_, it's still
> completely broken, and hiding the KASAN report is just hiding a bug.
> 
> What and where was the actual KASAN issue? The commit log doesn't say...

It'll take some time to reconstruct the original report, but the case in
question was in removing the last element of the list of the last list,
switch to a global lock over all such lists to park the HW, which in
doing so added one more element to the original list. [If we happen to
be retiring along the kernel timeline in the first place.]

list->next changed from pointing to list_head, to point to the new
element instead. However, we don't have to check the next element yet
and want to terminate the list iteration.

For reference,
drivers/gpu/drm/i915/gt/intel_engine_pm.c::__engine_park()

Global activity is serialised by engine->wakeref.mutex; every active
timeline is required to hold an engine wakeref, but retiring is local to
timelines and serialised by their own timeline->mutex.

lock(&timeline->lock)
list_for_each_safe(&timeline->requests)
  \-> i915_request_retire [list_del(&timeline->requests)]
   \-> intel_timeline_exit
    \-> lock(&engine->wakeref.mutex)
        engine_park [list_add_tail(&engine->kernel_context->timeline->requests)]

-Chris
