Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E648CACB
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbiALSQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349910AbiALSQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:16:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7841EC06173F;
        Wed, 12 Jan 2022 10:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bJY3C+X7zHwgbbceCQDqbl+wqxvIGfAy5Ps2Lrhqv8U=; b=Vr7TaC/2N3GIKrsxqJRI2k0Rvb
        xAJPJVpk8rxPdllApzyyVjzOpJF3+OYTb/teUsQLRWFGhv2U4cVV5o3oSak2raGXEj/1klVGrZxME
        LjGuMqxaP3EwxIjlWByP+vFii+vXvQidw/dTgrY+3jQ6ILt26vmnzdaoZoVLtXqAcU+SmiUtKSpoF
        dwW4SRlqx5N7fDCLar7VRGHDXOnxV+8PzhCoxHmDA/qjR1jkbmoeXpYX7KxQJzE3SUjSqFW4JlDqB
        WSbwc28U8Dk+68oG6SAU0h3AghEJxz7TLoKY2wDj3XN9WZRcxwzbbJ4/xg6mLy+UCmXRwLFpfiYRU
        2QJyusZw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7iAT-004J17-42; Wed, 12 Jan 2022 18:16:17 +0000
Date:   Wed, 12 Jan 2022 18:16:17 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
Message-ID: <Yd8a8TdThrGHsf2o@casper.infradead.org>
References: <20220111232309.1786347-1-surenb@google.com>
 <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > This happens with the following config:
> >
> > CONFIG_CGROUPS=n
> > CONFIG_PSI=y
> >
> > With cgroups disabled these functions are defined as non-static but
> > are not defined in the header
> > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > since the only external user cgroup.c is disabled. The cleanest way to
> > fix these I think is by doing smth like this in psi.c:

A cleaner way to solve these is simply:

#ifndef CONFIG_CGROUPS
static struct psi_trigger *psi_trigger_create(...);
...
#endif

I tested this works:

$ cat foo5.c
static int psi(void *);

int psi(void *x)
{
	return (int)(long)x;
}

int bar(void *x)
{
	return psi(x);
}
$ gcc -W -Wall -O2 -c -o foo5.o foo5.c
$ readelf -s foo5.o

Symbol table '.symtab' contains 4 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
     3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar

