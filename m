Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2554F278B51
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgIYOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgIYOzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:55:02 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145BC2074B;
        Fri, 25 Sep 2020 14:55:00 +0000 (UTC)
Date:   Fri, 25 Sep 2020 10:54:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Subject: Re: [stable 4.19] [PANIC]: tracing: Centralize preemptirq
 tracepoints and unify their usage
Message-ID: <20200925105458.567d0bf4@oasis.local.home>
In-Reply-To: <CA+G9fYuokHUBwNkTs=gWqCHxj80gg+RetU4pRd+uLP7gNas4KQ@mail.gmail.com>
References: <20180823023839.GA13343@shao2-debian>
        <20180828195347.GA228832@joelaf.mtv.corp.google.com>
        <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
        <20200925051518.GA605188@kroah.com>
        <CA+G9fYuokHUBwNkTs=gWqCHxj80gg+RetU4pRd+uLP7gNas4KQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 12:55:13 +0530
Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> On Fri, 25 Sep 2020 at 10:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Sep 25, 2020 at 10:13:05AM +0530, Naresh Kamboju wrote:  
> > > >From stable rc 4.18.1 onwards to today's stable rc 4.19.147  
> > >
> > > There are two problems  while running LTP tracing tests
> > > 1) kernel panic  on i386, qemu_i386, x86_64 and qemu_x86_64 [1]
> > > 2) " segfault at 0 ip " and "Code: Bad RIP value" on x86_64 and qemu_x86_64 [2]
> > > Please refer to the full test logs from below links.
> > >
> > > The first bad commit found by git bisect.
> > >    commit: c3bc8fd637a9623f5c507bd18f9677effbddf584
> > >    tracing: Centralize preemptirq tracepoints and unify their usage
> > >
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>  
> >
> > So this also is reproducable in 5.4 and Linus's tree right now?  
> 
> No.
> The reported issues are not reproducible on 5.4, 5.8 and Linus's tree.

The crash looks like its cr3 related, which I believe Peter Zijlstra
did a restructuring of that code to not let it be an issue anymore.
I'll have to look deeper. The rework may be too intrusive to backport,
but we do have other work arounds for this issue if that would be
acceptable for backporting.

> 
> >
> > Or are newer kernels working fine?  
> 
> No.
> There are different issues while testing LTP tracing on 5.4, 5.8 and
> Linus 's 5.9.
> 
> NETDEV WATCHDOG: eth0 (igb): transmit queue 2 timed out
> WARNING: CPU: 1 PID: 331 at net/sched/sch_generic.c:442 dev_watchdog+0x4c7/0x4d0
> https://lore.kernel.org/stable/CA+G9fYtS_nAX=sPV8zTTs-nOdpJ4uxk9sqeHOZNuS4WLvBcPGg@mail.gmail.com/
> 
> I see this on 5.4, 5.8 and Linus 's 5.9.
> rcu: INFO: rcu_sched self-detected stall on CPU
> ? ftrace_graph_caller+0xc0/0xc0
> https://lore.kernel.org/stable/CA+G9fYsdTLRj55_bvod8Sf+0zvK0RRMp5+FeJcOx5oAcAKOGXA@mail.gmail.com/T/#u

I've seen that too and couldn't bisect it down to any such commit. I'm
not sure if it is even a bug per-se, because in my test suite, I've
commented out the warning, and the system still remains stable.

-- Steve
