Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568C61AB56F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgDPBXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgDPBXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:23:35 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB102076D;
        Thu, 16 Apr 2020 01:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587000214;
        bh=CrhmZ8ml+j1xCYV4vgrPz2HqQRSgeuzUvjHS4LtayWg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qe9aWoY0RCsCz1vBrgNzrPZHlRDR4IiSLdwSvoEuD9Rd0h658nN7Onxc9OkPA3Q/T
         oS+pHumv9p8NRaDK9aFD9qHrpwHmRFKb0L5V26mWf/Q9b1uc/X+Ni5/QmH93p0prr9
         sW7/iEwrsKm20P07IhbKDtfIJlqqmkP56UgNXpQc=
Date:   Thu, 16 Apr 2020 10:23:30 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     <gregkh@linuxfoundation.org>
Cc:     rostedt@goodmis.org, treeze.taeung@gmail.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch
 "[PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events" failed
 to apply to 4.19-stable tree
Message-Id: <20200416102330.3329ef17ca5416dd9f50ec4d@kernel.org>
In-Reply-To: <158695112724822@kroah.com>
References: <158695112724822@kroah.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 15 Apr 2020 13:45:27 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Ah, OK. The next line is modified by multiprobe support.
I'll backport it.

Thank you,

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
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
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 362cca52f5de..d0568af4a0ef 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1078,6 +1078,8 @@ static int trace_kprobe_show(struct seq_file *m, struct dyn_event *ev)
>  	int i;
>  
>  	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
> +	if (trace_kprobe_is_return(tk) && tk->rp.maxactive)
> +		seq_printf(m, "%d", tk->rp.maxactive);
>  	seq_printf(m, ":%s/%s", trace_probe_group_name(&tk->tp),
>  				trace_probe_name(&tk->tp));
>  
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
