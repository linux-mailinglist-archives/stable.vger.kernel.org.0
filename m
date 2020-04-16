Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D871AB57A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgDPB1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbgDPB1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:27:07 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A08A2076D;
        Thu, 16 Apr 2020 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587000427;
        bh=YCSmFeIOSl5ceTT4kl1qbRapzXWrqXJIeGNdm4NzLOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y4XEGPXHeAdFN7Zbfh/ifqEBqdq1hvmmo/zL0QBHfXCVd/qAqEwD093ZNxPK1Y1F0
         gwPLwYkEehTumrIypeEACh+p8p1byjeoldx8qb8Dg+89MhpveS6ji6CwCuIqgCHvbV
         hLNhXmCtKhOnkJizSufgdSY35lWhrX3c+2x2WbsI=
Date:   Thu, 16 Apr 2020 10:27:04 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     <gregkh@linuxfoundation.org>, mhiramat@kernel.org,
        treeze.taeung@gmail.com, <stable@vger.kernel.org>
Subject: Re: FAILED: patch
 "[PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events" failed
 to apply to 4.19-stable tree
Message-Id: <20200416102704.8db39de3deaaf33b4fc5c597@kernel.org>
In-Reply-To: <20200415151400.2347497b@gandalf.local.home>
References: <158695112724822@kroah.com>
        <20200415151400.2347497b@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Apr 2020 15:14:00 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 15 Apr 2020 13:45:27 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> >
> 
> This should apply to both 4.14 and 4.19 and fix the same issue:

Thanks Steven for backporting!
I confirmed this can applied on 4.19 and 4.14.

Thanks!

> 
> From 6a13a0d7b4d1171ef9b80ad69abc37e1daa941b3 Mon Sep 17 00:00:00 2001
> From: Masami Hiramatsu <mhiramat@kernel.org>
> Date: Tue, 24 Mar 2020 16:34:48 +0900
> Subject: [PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events
> 
> Show maxactive parameter on kprobe_events.
> This allows user to save the current configuration and
> restore it without losing maxactive parameter.
> 
> Link: http://lkml.kernel.org/r/4762764a-6df7-bc93-ed60-e336146dce1f@gmail.com
> Link: http://lkml.kernel.org/r/158503528846.22706.5549974121212526020.stgit@devnote2
> 
> Cc: stable@vger.kernel.org
> Fixes: 696ced4fb1d76 ("tracing/kprobes: expose maxactive for kretprobe in kprobe_events")
> Reported-by: Taeung Song <treeze.taeung@gmail.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Index: linux-test.git/kernel/trace/trace_kprobe.c
> ===================================================================
> --- linux-test.git.orig/kernel/trace/trace_kprobe.c
> +++ linux-test.git/kernel/trace/trace_kprobe.c
> @@ -975,6 +975,8 @@ static int probes_seq_show(struct seq_fi
>  	int i;
>  
>  	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
> +	if (trace_kprobe_is_return(tk) && tk->rp.maxactive)
> +		seq_printf(m, "%d", tk->rp.maxactive);
>  	seq_printf(m, ":%s/%s", tk->tp.call.class->system,
>  			trace_event_name(&tk->tp.call));
>  
> 
> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
