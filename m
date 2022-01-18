Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B2F491F9F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 07:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbiARG7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 01:59:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59644 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbiARG7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 01:59:04 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n9iRd-0007cI-7l; Tue, 18 Jan 2022 17:58:18 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Jan 2022 17:58:17 +1100
Date:   Tue, 18 Jan 2022 17:58:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ebiggers@kernel.org, surenb@google.com, hannes@cmpxchg.org,
        tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@android.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <YeZlCfZZkU5jyFS+@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.doc,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Of course, in practice, for pointers, the whole "dereference off a
> pointer" on the read side *does* imply a barrier in all relevant
> situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> practice, although it's technically wrong (in particular, it's wrong
> on alpha, because of the completely broken memory ordering that alpha
> has that doesn't even honor data dependencies as read-side orderings)

READ_ONCE has contained the alpha barrier since 2017:

commit 76ebbe78f7390aee075a7f3768af197ded1bdfbb
Author: Will Deacon <will@kernel.org>
Date:   Tue Oct 24 11:22:47 2017 +0100

    locking/barriers: Add implicit smp_read_barrier_depends() to READ_ONCE()

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
