Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269DE48C2D8
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 12:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352746AbiALLGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 06:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352738AbiALLGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 06:06:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97823C06173F;
        Wed, 12 Jan 2022 03:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nv9oEebndkSiqv8pTcj7NImvDdA6KxSCBwjzUgND6Ac=; b=taEKJ6bDdHze7bETZnYl9/7wDa
        i1PB5dTa9T6SL6KmLnXcEdUBEYRvwYZrthrA3g0T1QrqulikClYv9M9HvbNDcUVJb2H7n7NdLliLW
        IjvOI145W5idiyDI878zCLuASw1nGZxjQgo3mBCuEYVAOyyT3v4NjAfBpVvre+S50zbLfIN+ncqLF
        EdYH9w6eiC1i03M8nm/At/P5M5zsSY6mqDCtZhyXCJ6G8EtJh7hiXfnaujw8dwc5bThZeAgfc8RhL
        bl2P43CB+lVqBXcekr+4SfEOyavXzuvyo6bi97AI529TiCHN3jeX+vfa5JU/RHAEW/P2OWsK8Zi94
        z5mbKIDA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7bSA-0042n8-MV; Wed, 12 Jan 2022 11:06:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4C2FB3001CD;
        Wed, 12 Jan 2022 12:06:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2C9542B33EC0E; Wed, 12 Jan 2022 12:06:04 +0100 (CET)
Date:   Wed, 12 Jan 2022 12:06:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <Yd62HBixfq6jn6jR@hirez.programming.kicks-ass.net>
References: <20220111071212.1210124-1-surenb@google.com>
 <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 11:11:32AM -0800, Linus Torvalds wrote:

> Of course, in practice, for pointers, the whole "dereference off a
> pointer" on the read side *does* imply a barrier in all relevant
> situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> practice, although it's technically wrong (in particular, it's wrong
> on alpha, because of the completely broken memory ordering that alpha
> has that doesn't even honor data dependencies as read-side orderings)

On a tangent, that actually works, even on Alpha, see commit
d646285885154 ("alpha: Override READ_ONCE() with barriered
implementation").
