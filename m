Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF985143FF6
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAUOuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 09:50:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44262 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgAUOuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0FIyr04Zhuy/Eo5nsco0vhS1JkFQxXv6feZe6IsEwzY=; b=2qNZ9RyEgDWaSiCQ4K/q2wMYI
        NiomtK9UtBhGi6+XyHxs0nAoy0DoTNQV5XRLazb9c8xBRHsTzbJDRQu95eNsXdEyqdP/KGyoaEQCK
        QW61nAn0xwad/i9YZ8RoodYbpNXSDpWzZmmZLCBV7YJdqkskyEnL40gGGJnn3sprCpLkcyRK4gn94
        EpnY/tpJ4AUlwrMn5raGVtg8FPr53cqiijYsxd2EgW/Uyp82Tp9JnWWrfO0pMgBPHqtoBofwd31aS
        zjoanJUk1ppAgX7/rW5eyVWiPj4NEcX4sNXaeOCudewQGjYAvVET+d6hS2Rzo2a9XF9Rwh6E+SxHM
        7EoKBVs2w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1itur5-0007Or-G5; Tue, 21 Jan 2020 14:50:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D3122304BDF;
        Tue, 21 Jan 2020 15:48:30 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C798F20983E32; Tue, 21 Jan 2020 15:50:09 +0100 (CET)
Date:   Tue, 21 Jan 2020 15:50:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <thoiland@redhat.com>,
        Jean-Tsung Hsiao <jhsiao@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event
 linking on multiprobe uprobe
Message-ID: <20200121145009.GR14879@hirez.programming.kicks-ass.net>
References: <20200121143847.609307852@goodmis.org>
 <20200121143956.600928887@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121143956.600928887@goodmis.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 09:38:49AM -0500, Steven Rostedt wrote:
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 4ee703728aec..03e4e180058d 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -230,6 +230,7 @@ struct trace_probe_event {
>  	struct trace_event_call		call;
>  	struct list_head 		files;
>  	struct list_head		probes;
> +	char				data[0];
>  };

Note that this relies on pure 'luck'. If you stick anything <4 bytes in
between the list_head and the data member it'll come unstuck real fast.

> +static struct trace_uprobe_filter *
> +trace_uprobe_get_filter(struct trace_uprobe *tu)
> +{
> +	struct trace_probe_event *event = tu->tp.event;
> +
> +	return (struct trace_uprobe_filter *)&event->data[0];
> +}

That is, the above does not consider the alignment requirements of
struct trace_uprobe_filter.
