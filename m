Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1313848CB31
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356418AbiALSpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356446AbiALSoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:44:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341D6C06173F;
        Wed, 12 Jan 2022 10:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C816A61A35;
        Wed, 12 Jan 2022 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9663BC36AE5;
        Wed, 12 Jan 2022 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642013094;
        bh=LW70gO4DLI9yvYy93v3QKw+URWyMDt50sXq2NeIJKtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9JyeUuGZinPYZac9f50ZGapw9lan1RmyRRYW6nsTq8Kzhkpsjl1QGkaz+oFRnqVN
         7FZPmXLOZcqpo1pFn456eGEuQuqgkfk4cKrThZvQHIoq0gP0NWJrNg5bT9OYwgigh6
         X1qxvJ8t2zZPtnNyGlI82cYsOlxgc4Wgw8nT4d1kKN5f91W3lGNeyPImjj7G/f9i+s
         b0ygOn9p1x9rcOhj16ej7REyR+9FSy+AA1EubEkrfizXFPIwzk2t7/ocGMNuDUIHZu
         ff6Aai615p5p8nnquDFEkpEwFQ+QQeofZvGLFKcPrV10stWyP4K/kieXrkhKZVwoGh
         vdJBm2AYGVeEw==
Date:   Wed, 12 Jan 2022 10:44:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <Yd8hpPwsIT2pbKUN@gmail.com>
References: <20220111232309.1786347-1-surenb@google.com>
 <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org>
 <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > This happens with the following config:
> > > >
> > > > CONFIG_CGROUPS=n
> > > > CONFIG_PSI=y
> > > >
> > > > With cgroups disabled these functions are defined as non-static but
> > > > are not defined in the header
> > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > fix these I think is by doing smth like this in psi.c:
> >
> > A cleaner way to solve these is simply:
> >
> > #ifndef CONFIG_CGROUPS
> > static struct psi_trigger *psi_trigger_create(...);
> > ...
> > #endif
> >
> > I tested this works:
> >
> > $ cat foo5.c
> > static int psi(void *);
> >
> > int psi(void *x)
> > {
> >         return (int)(long)x;
> > }
> >
> > int bar(void *x)
> > {
> >         return psi(x);
> > }
> > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > $ readelf -s foo5.o
> >
> > Symbol table '.symtab' contains 4 entries:
> >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> >
> 
> Thanks Matthew!
> That looks much cleaner. I'll post a separate patch to fix these. My
> main concern was whether it's worth adding more code to satisfy this
> warning but with this approach the code changes are minimal, so I'll
> go ahead and post it shortly.

Why not simply move the declarations of psi_trigger_create() and
psi_trigger_destroy() in include/linux/psi.h outside of the
'#ifdef CONFIG_CGROUPS' block, to match the .c file?

They *could* be static when !CONFIG_CGROUPS, but IMO it's not worth bothering.

- Eric
