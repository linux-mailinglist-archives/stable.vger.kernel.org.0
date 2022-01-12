Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBD948CB75
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 20:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiALTEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 14:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiALTEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 14:04:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE34DC06173F;
        Wed, 12 Jan 2022 11:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F3DE61A4F;
        Wed, 12 Jan 2022 19:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4757BC36AE5;
        Wed, 12 Jan 2022 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642014243;
        bh=NVaZp2ydCmNzbicjZMh52GQ0rIxQwNb+Kp0iuqAB1/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BLy1WYMWrnDx3II9MNUcyZm67FswTvtppwb42AH+m6CyAg2MsyONUR2F/M0hYKOR0
         ltsmh8l9oBFr8Tq1pGZ6topPUBgiLXWzNK8JvPbJ8EEavgueAzlg+ecblHsIYUcy2e
         r1x1G/yOX1A3VD/FxKp4hHNN3iYMud+KxokmcowWe6SRxsYJjMh6RH+jdJ/IkOiqEM
         qI9SEHTTrFnqFfju0kVllCSgaZcw9XmeSNb5cRBiKooXwqE2hJnMTBlFfajr3hihdl
         sWJ+c6VkM0BR767ibjeYM/bZhHMdcsmW7VTzYNSdnFdYkCX1p+TlqD7nv9vSr2Eowv
         rXm9CF+vgiBIQ==
Date:   Wed, 12 Jan 2022 11:04:01 -0800
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
Message-ID: <Yd8mIY5IxwOKTK+D@gmail.com>
References: <20220111232309.1786347-1-surenb@google.com>
 <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org>
 <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
 <Yd8hpPwsIT2pbKUN@gmail.com>
 <CAJuCfpF_aZ7OnDRYr2MNa-x=ctO-daw-U=k+-GCYkJR1_yTHQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpF_aZ7OnDRYr2MNa-x=ctO-daw-U=k+-GCYkJR1_yTHQg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:53:48AM -0800, Suren Baghdasaryan wrote:
> On Wed, Jan 12, 2022 at 10:44 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> > > On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > > > This happens with the following config:
> > > > > >
> > > > > > CONFIG_CGROUPS=n
> > > > > > CONFIG_PSI=y
> > > > > >
> > > > > > With cgroups disabled these functions are defined as non-static but
> > > > > > are not defined in the header
> > > > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > > > fix these I think is by doing smth like this in psi.c:
> > > >
> > > > A cleaner way to solve these is simply:
> > > >
> > > > #ifndef CONFIG_CGROUPS
> > > > static struct psi_trigger *psi_trigger_create(...);
> > > > ...
> > > > #endif
> > > >
> > > > I tested this works:
> > > >
> > > > $ cat foo5.c
> > > > static int psi(void *);
> > > >
> > > > int psi(void *x)
> > > > {
> > > >         return (int)(long)x;
> > > > }
> > > >
> > > > int bar(void *x)
> > > > {
> > > >         return psi(x);
> > > > }
> > > > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > > > $ readelf -s foo5.o
> > > >
> > > > Symbol table '.symtab' contains 4 entries:
> > > >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> > > >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> > > >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> > > >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> > > >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> > > >
> > >
> > > Thanks Matthew!
> > > That looks much cleaner. I'll post a separate patch to fix these. My
> > > main concern was whether it's worth adding more code to satisfy this
> > > warning but with this approach the code changes are minimal, so I'll
> > > go ahead and post it shortly.
> >
> > Why not simply move the declarations of psi_trigger_create() and
> > psi_trigger_destroy() in include/linux/psi.h outside of the
> > '#ifdef CONFIG_CGROUPS' block, to match the .c file?
> 
> IIRC this was done to avoid another warning that these functions are
> not used outside of psi.c when CONFIG_CGROUPS=n
> 

What tool gave that warning?

- Eric
