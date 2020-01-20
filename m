Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0C5143365
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 22:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgATV1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 16:27:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgATV1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 16:27:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D20C217F4;
        Mon, 20 Jan 2020 21:27:20 +0000 (UTC)
Date:   Mon, 20 Jan 2020 16:27:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/7] tracing: Initialize val to zero in parse_entry of
 inject code
Message-ID: <20200120162718.7b8f8886@gandalf.local.home>
In-Reply-To: <20200120163622.8603-1-jbi.octave@gmail.com>
References: <20200120163622.8603-1-jbi.octave@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Why am I receiving these?

-- Steve


On Mon, 20 Jan 2020 16:36:16 +0000
Jules Irenge <jbi.octave@gmail.com> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> gcc produces a variable may be uninitialized warning for "val" in
> parse_entry(). This is really a false positive, but the code is subtle
> enough to just initialize val to zero and it's not a fast path to worry
> about it.
> 
> Marked for stable to remove the warning in the stable trees as well.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6c3edaf9fd6a3 ("tracing: Introduce trace event injection")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events_inject.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events_inject.c b/kernel/trace/trace_events_inject.c
> index d45079ee62f8..22bcf7c51d1e 100644
> --- a/kernel/trace/trace_events_inject.c
> +++ b/kernel/trace/trace_events_inject.c
> @@ -195,7 +195,7 @@ static int parse_entry(char *str, struct trace_event_call *call, void **pentry)
>  	unsigned long irq_flags;
>  	void *entry = NULL;
>  	int entry_size;
> -	u64 val;
> +	u64 val = 0;
>  	int len;
>  
>  	entry = trace_alloc_entry(call, &entry_size);

