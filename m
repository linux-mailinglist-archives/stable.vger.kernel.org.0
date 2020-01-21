Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC381144022
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 16:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAUPGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 10:06:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUPGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 10:06:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TYcI2J8+m5fI6D2lTz5Hy7Lgm04gjVpXRrOJfqIDEpY=; b=P/Gk+XxY85kqGawYZuTlwb04D
        lJPsnSqZ6Q0IsXXYe8eEu8+4wzk8p9J3AoLaCLSgDQO83C0s0WrdmDfzBnXUxPhX0YMlRpvvGT2vv
        N1fCR1C4Ef7KxqIkCEnmS1fUfg8uZ04aI+ekCBtcZwq+jl1giiMZ4nOD6Fa4gVyEH2G2RB954uAaD
        juntudQbuI5dTwiJubdvFwbm+F60uBajhdR237MkYoNOz890xcaTvuLrlwXrt1NMobwF5/N6QiW92
        8xPojBIKC0Yw7Qs/kvZglBJei9iqYTuRYQdmc7FEL8jY7BAC+FivaNDinOre4MNUoLD62sHJIgngD
        RYIi/6V3Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1itv6V-0004uo-9L; Tue, 21 Jan 2020 15:06:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DF71F305D3F;
        Tue, 21 Jan 2020 16:04:25 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 11A8E20983FC2; Tue, 21 Jan 2020 16:06:05 +0100 (CET)
Date:   Tue, 21 Jan 2020 16:06:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <thoiland@redhat.com>,
        Jean-Tsung Hsiao <jhsiao@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event
 linking on multiprobe uprobe
Message-ID: <20200121150605.GT14879@hirez.programming.kicks-ass.net>
References: <20200121143847.609307852@goodmis.org>
 <20200121143956.600928887@goodmis.org>
 <20200121145009.GR14879@hirez.programming.kicks-ass.net>
 <bd3126fff15641098af2a4ac2164f3c4@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3126fff15641098af2a4ac2164f3c4@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 02:59:35PM +0000, David Laight wrote:
> From: Peter Zijlstra
> > Sent: 21 January 2020 14:50
> > On Tue, Jan 21, 2020 at 09:38:49AM -0500, Steven Rostedt wrote:
> > > diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> > > index 4ee703728aec..03e4e180058d 100644
> > > --- a/kernel/trace/trace_probe.h
> > > +++ b/kernel/trace/trace_probe.h
> > > @@ -230,6 +230,7 @@ struct trace_probe_event {
> > >  	struct trace_event_call		call;
> > >  	struct list_head 		files;
> > >  	struct list_head		probes;
> > > +	char				data[0];
> > >  };
> > 
> > Note that this relies on pure 'luck'. If you stick anything <4 bytes in
> > between the list_head and the data member it'll come unstuck real fast.
> 
> Can you fix it by adding an unnamed struct as in:

The trivial fix is like I suggested in the other thread:

	struct trace_uprobe_filter filters[0];

The alternative that Masami-San suggested should also work.
