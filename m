Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410863B8A20
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 23:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhF3Vgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 17:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229705AbhF3Vgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 17:36:32 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A8EB6146D;
        Wed, 30 Jun 2021 21:34:02 +0000 (UTC)
Date:   Wed, 30 Jun 2021 17:34:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Resize tgid_map to PID_MAX_LIMIT, not
 PID_MAX_DEFAULT
Message-ID: <20210630173400.7963f619@oasis.local.home>
In-Reply-To: <YNzdllg/634Sa6Rt@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <20210630003406.4013668-2-paulburton@google.com>
        <20210630083513.1658a6fb@oasis.local.home>
        <YNzdllg/634Sa6Rt@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Jun 2021 14:09:42 -0700
Paul Burton <paulburton@google.com> wrote:

> Hi Steven,
> 
> On Wed, Jun 30, 2021 at 08:35:13AM -0400, Steven Rostedt wrote:
> > On Tue, 29 Jun 2021 17:34:06 -0700
> > Paul Burton <paulburton@google.com> wrote:
> >   
> > > On 64 bit systems this will increase the size of tgid_map from 256KiB to
> > > 16MiB. Whilst this 64x increase in memory overhead sounds significant 64
> > > bit systems are presumably best placed to accommodate it, and since
> > > tgid_map is only allocated when the record-tgid option is actually used
> > > presumably the user would rather it spends sufficient memory to actually
> > > record the tgids they expect.  
> > 
> > NAK. Please see how I fixed this for the saved_cmdlines, and implement
> > it the same way.
> > 
> > 785e3c0a3a87 ("tracing: Map all PIDs to command lines")
> > 
> > It's a cache, it doesn't need to save everything.  
> 
> Well sure, but it's a cache that (modulo pid recycling) previously had a
> 100% hit rate for tasks observed in sched_switch events.

Obviously it wasn't 100% when it went over the PID_MAX_DEFAULT.

> 
> It differs from saved_cmdlines in a few key ways that led me to treat it
> differently:
> 
> 1) The cost of allocating map_pid_to_cmdline is paid by all users of
>    ftrace, whilst as I mentioned in my commit description the cost of
>    allocating tgid_map is only paid by those who actually enable the
>    record-tgid option.

I'll admit that this is a valid point.

> 
> 2) We verify that the data in map_pid_to_cmdline is valid by
>    cross-referencing it against map_cmdline_to_pid before reporting it.
>    We don't currently have an equivalent for tgid_map, so we'd need to
>    add a second array or make tgid_map an array of struct { int pid; int
>    tgid; } to avoid reporting incorrect tgids. We therefore need to
>    double the memory we consume or further reduce the effectiveness of
>    this cache.

Double 256K is just 512K which is still much less than 16M.

> 
> 3) As mentioned before, with the default pid_max tgid_map/record-tgid
>    has a 100% hit rate which was never the case for saved_cmdlines. If
>    we go with a solution that changes this property then I certainly
>    think the docs need updating - the description of saved_tgids in
>    Documentation/trace/ftrace.rst makes no mention of this being
>    anything but a perfect recreation of pid->tgid relationships, and
>    unlike the description of saved_cmdlines it doesn't use the word
>    "cache" at all.
> 
> Having said that I think taking a similar approach to saved_cmdlines
> would be better than what we have now, though I'm not sure whether it'll
> be sufficient to actually be usable for me. My use case is grouping
> threads into processes when displaying scheduling information, and
> experience tells me that if any threads don't get grouped appropriately
> the result will be questions.

I found a few bugs recently in the saved_cmdlines that were causing a
much higher miss rate, but now it's been rather accurate. I wonder how
much pain that's been causing you?

Anyway, I'll wait to hear what Joel says on this. If he thinks this is
worth 16M of memory when enabled, I may take it.

-- Steve
