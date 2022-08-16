Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0DD5959A7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiHPLPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbiHPLPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:15:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D88753AE;
        Tue, 16 Aug 2022 02:41:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C7E361F88D;
        Tue, 16 Aug 2022 09:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660642860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NO7OSX/4HeQXrrq1SbypK9zder6O5DG47D3stDUZzvo=;
        b=ukcTxtZu5gDDQRYJTBXdr3oFHSGBot0i+hVn8pNG1NFoifldH1q3oeLDuwLGWw4L5GsAEt
        e4UjtqMkCyfNLFz1bKTgKveVfukjpwbrZvYzbdXMHqp38O2vDLpP9f8gqGjHJxHRl9ABmz
        M5hO0ScGiPd4Et1Q2RK3oiiwFQ9tAJA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660642860;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NO7OSX/4HeQXrrq1SbypK9zder6O5DG47D3stDUZzvo=;
        b=lqT3K1HpwDKkFJgMvCIcaQQ4s9Nv5on5dZsLLtXZw3hrfrNqoehAsdrrrNg8NkevOlPhQT
        4uVpxSoxvGi6TwAw==
Received: from suse.de (unknown [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 38A872C143;
        Tue, 16 Aug 2022 09:40:58 +0000 (UTC)
Date:   Tue, 16 Aug 2022 10:40:56 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched/all: Change all BUG_ON() instances in the
 scheduler to WARN_ON_ONCE()
Message-ID: <20220816094056.x4ldzednboaln3ag@suse.de>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvYdbn2GtTlCaand@gmail.com>
 <20220815144143.zjsiamw5y22bvgki@suse.de>
 <cbb3697c-f310-ae91-1322-fea5794ebf30@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <cbb3697c-f310-ae91-1322-fea5794ebf30@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 03:12:19PM -0700, John Hubbard wrote:
> On 8/15/22 07:41, Mel Gorman wrote:
> > For the rest, I didn't see obvious recovery paths that would allow the
> > system to run predictably. Any of them firing will have unpredictable
> > consequences (e.g. move_queued_task firing would be fun if it was a per-cpu
> > kthread). Depending on which warning triggers, the remaining life of the
> > system may be very short but maybe long enough to be logged even if system
> > locks up shortly afterwards.
> 
> Hi Mel,
> 
> Are you basically saying, "WARN_ON*() seems acceptable in mm/, because
> we can at least get the problem logged before it locks up, probably"?
> 

I don't consider this to be a subsystem-specific guideline and I am certainly
not suggesting that mm/ is the gold standard but my understanding was
"If a warning is recoverable in a sensible fashion then do so". A warning
is always bad, but it may be possible for the system to continue long
enough for the warning to be logged or an admin to schedule a reboot at
a controlled time. I think Ingo is doing the right thing with this patch
to avoid an unnecessary panic but for at least some of them, a partial
recovery is possible so why not do it seeing as it's been changed anyway?

The outcome of a warning is very variable, it might be a coding error where
state is unexpected but it can be reset to a known state, maybe some data
is leaked that if it persists we eventually OOM, maybe a particular feature
will no longer work as expected (e.g. load balancing doesn't balance load
due to a warning) or maybe the whole system will fail completely in the
near future, possibly before an error can be logged. In the scheduler
side, a warning may mean that a task never runs again and another means
that a task is in the wrong scheduling class which means ... no idea,
but it's not good if it's a deadline task that gets manipulated by the
normal scheduling class instead.

For mm/, take three examples

1. compaction.c warning. PFN ranges are unexpected, reset them.
   Compaction is less effective and opportunities were missed but the system
   will not blow up. Maybe at worst a hugetlb allocation would fail when it
   might otherwise have succeeded or maybe SLUB degrades because it can't
   use a high-order page for a cache that could reside in an order-0 page
   instead. It varies.

2. Warning in in filemap_unaccount_folio -- possible loss of unwritten
   data on normal filesystems. Bad, might cause inconsistency for state but
   maybe it'll be dirtied again and it'll recover eventually.  It's certainly
   not good if that data got lost forever.

3. The warning in isolate_movable_page is bad, page flags state is
   either corrupted by a driver or maybe there was a bit flip error but a
   page may be migrated unexpectedly leading to Who Knows What, corruption
   of a page that gets freed and reused by another process? It's much worse
   than compaction restoring its internal state of where it is scanning
   but maybe not a complete disaster.

> Or are you implying that we should instead introduce and use some new
> PANIC_ON() or VM_PANIC_ON() set of macros that would allow proper "log
> then reboot" behavior?
> 

No, not as a general rule. VM_PANIC_ON would suggest it's under DEBUG_VM
which is not always set and I do not see how either PANIC_ON or VM_PANIC_ON
could be coded in such a way that it always gets logged because it depends
on the context the bad condition occurred.

I also don't think the kernel could conditionally warn or panic for a
specific instance because if an admin wants a panic on a warning (can be
very useful for a crash dump), then panic_on_warn is available.

Either way, PANIC_ON or VM_PANIC_ON is outside the scope of this patch.

My understanding was that a panic() should only be used in the case where the
kernel is screwed and if tries to continue, the outcome will be much worse
or it's early in boot and the error condition means it'll be impossible
to boot anyway.

-- 
Mel Gorman
SUSE Labs
