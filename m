Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FDA145E6B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 23:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAVWMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 17:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgAVWMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 17:12:39 -0500
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE9021835;
        Wed, 22 Jan 2020 22:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579731158;
        bh=yXJTAtyUgF/n5VfVCpD4qaPRZD7eOBIuzPZVhbUeTL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvOuqmaRIpjkXG3GkKuNKB7TseHYe4VltsI+SVF8gTpuFw/Y69mtx5NJn6O7WsiPy
         wdEO/h0fAEhvzmxmMiHjSMpiJhrMDmTvPLNWI3PysmL0zvC5Zxz+P2o2FKO9ZL5iiX
         tfVH+5LKRTmDymKuOVKue15KuKBUZI6D6mZJFnAs=
Date:   Thu, 23 Jan 2020 07:12:14 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?ISO-2022-JP?B?bnNlbg==?= 
        <thoiland@redhat.com>, Jean-Tsung Hsiao <jhsiao@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event
 linking on multiprobe uprobe
Message-Id: <20200123071214.fb1975d25177963765511435@kernel.org>
In-Reply-To: <20200121150605.GT14879@hirez.programming.kicks-ass.net>
References: <20200121143847.609307852@goodmis.org>
        <20200121143956.600928887@goodmis.org>
        <20200121145009.GR14879@hirez.programming.kicks-ass.net>
        <bd3126fff15641098af2a4ac2164f3c4@AcuMS.aculab.com>
        <20200121150605.GT14879@hirez.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Jan 2020 16:06:05 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jan 21, 2020 at 02:59:35PM +0000, David Laight wrote:
> > From: Peter Zijlstra
> > > Sent: 21 January 2020 14:50
> > > On Tue, Jan 21, 2020 at 09:38:49AM -0500, Steven Rostedt wrote:
> > > > diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> > > > index 4ee703728aec..03e4e180058d 100644
> > > > --- a/kernel/trace/trace_probe.h
> > > > +++ b/kernel/trace/trace_probe.h
> > > > @@ -230,6 +230,7 @@ struct trace_probe_event {
> > > >  	struct trace_event_call		call;
> > > >  	struct list_head 		files;
> > > >  	struct list_head		probes;
> > > > +	char				data[0];
> > > >  };
> > > 
> > > Note that this relies on pure 'luck'. If you stick anything <4 bytes in
> > > between the list_head and the data member it'll come unstuck real fast.
> > 
> > Can you fix it by adding an unnamed struct as in:
> 
> The trivial fix is like I suggested in the other thread:
> 
> 	struct trace_uprobe_filter filters[0];
> 
> The alternative that Masami-San suggested should also work.

I've sent a fix ( https://lkml.org/lkml/2020/1/21/1214 )
as Peter suggested, change the field to 

	struct trace_uprobe_filter filters[0];

and change the code around that.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
